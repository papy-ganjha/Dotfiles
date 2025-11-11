-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  return
end

-- Function to dynamically get paths of editable/dev installed packages
local function get_editable_package_paths()
  local paths = {}

  -- Get the python executable path
  local python_path = vim.fn.exepath("python3")
  if python_path == "" then
    python_path = vim.fn.exepath("python")
  end

  if python_path == "" then
    return paths
  end

  -- Check if uv is available (prefer uv over pip)
  local uv_path = vim.fn.exepath("uv")
  local pip_cmd = ""

  if uv_path ~= "" then
    pip_cmd = uv_path .. " pip"
  else
    -- Fall back to python -m pip
    pip_cmd = python_path .. " -m pip"
  end

  -- Get site-packages directory to look for direct_url.json files
  local site_packages_handle = io.popen(python_path .. " -c \"import site; print(site.getsitepackages()[0])\" 2>/dev/null")
  if not site_packages_handle then
    return paths
  end

  local site_packages = site_packages_handle:read("*l")
  site_packages_handle:close()

  if not site_packages or site_packages == "" then
    return paths
  end

  -- Run pip/uv list --editable to get all editable packages
  local handle = io.popen(pip_cmd .. " list --editable --format=freeze 2>/dev/null")
  if not handle then
    return paths
  end

  local result = handle:read("*a")
  handle:close()

  -- Parse the output to get package names
  for line in result:gmatch("[^\r\n]+") do
    -- Extract package name (before ==)
    local pkg_name = line:match("^([^=]+)")
    if pkg_name then
      -- Look for direct_url.json which contains the actual source path
      local dist_info_pattern = site_packages .. "/" .. pkg_name:gsub("%-", "_") .. "*.dist-info/direct_url.json"
      local glob_handle = io.popen("ls " .. dist_info_pattern .. " 2>/dev/null")

      if glob_handle then
        local direct_url_file = glob_handle:read("*l")
        glob_handle:close()

        if direct_url_file and direct_url_file ~= "" then
          -- Read and parse direct_url.json
          local json_file = io.open(direct_url_file, "r")
          if json_file then
            local json_content = json_file:read("*a")
            json_file:close()

            -- Extract the URL/path from the JSON (simple regex since we just need the dir path)
            local source_path = json_content:match('"url":%s*"file://([^"]+)"')
            if source_path then
              -- Decode URL encoding (e.g., %20 -> space)
              source_path = source_path:gsub("%%(%x%x)", function(hex)
                return string.char(tonumber(hex, 16))
              end)

              -- Find all directories containing Python packages (with __init__.py)
              -- Search up to 3 levels deep for package directories
              local find_handle = io.popen(
                "find " .. vim.fn.shellescape(source_path) .. " -maxdepth 3 -name '__init__.py' -type f 2>/dev/null"
              )

              if find_handle then
                local found_packages = find_handle:read("*a")
                find_handle:close()

                local added_paths = {}

                -- Add the source root
                added_paths[source_path] = true
                table.insert(paths, source_path)

                -- Parse each found __init__.py and add its parent directory
                for init_file in found_packages:gmatch("[^\r\n]+") do
                  -- Get the directory containing __init__.py (this is a package)
                  local package_dir = init_file:match("(.+)/[^/]+$")

                  if package_dir then
                    -- Get the parent of the package directory (this should be in PYTHONPATH)
                    local parent_dir = package_dir:match("(.+)/[^/]+$")

                    -- Only add if it's not the source_path itself and we haven't added it yet
                    if parent_dir and parent_dir ~= source_path and not added_paths[parent_dir] then
                      added_paths[parent_dir] = true
                      table.insert(paths, parent_dir)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  -- Remove duplicates
  local unique_paths = {}
  local seen = {}
  for _, path in ipairs(paths) do
    if not seen[path] then
      seen[path] = true
      table.insert(unique_paths, path)
    end
  end

  return unique_paths
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = {
    "pyright",
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})

-- Use the new vim.lsp.config API instead of lspconfig
local lspconfig = vim.lsp.config

-- Get capabilities from cmp-nvim-lsp
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp_status and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- Configure pyright LSP server
lspconfig.pyright = {
  filetypes = { "python" },
  capabilities = capabilities,
  settings = {
    python = {
      pythonPath = vim.fn.exepath("python"),
      analysis = {
        -- Enable auto-import completions for symbols not yet imported
        autoImportCompletions = true,
        -- Enable background indexing of the entire workspace
        indexing = true,
        -- Analyze the entire workspace, not just open files
        diagnosticMode = "workspace",
        -- Enable auto-search for Python paths
        autoSearchPaths = true,
        -- Use library code for completions
        useLibraryCodeForTypes = true,
        -- Configure how deeply to index packages
        packageIndexDepths = {
          {
            name = "",  -- empty string means workspace root
            depth = 10, -- index up to 10 levels deep
            includeAllSymbols = true,
          },
        },
        -- Type checking mode
        typeCheckingMode = "basic",
        -- Dynamically add paths for editable/dev installed packages
        extraPaths = get_editable_package_paths(),
      }
    }
  },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { ".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" }))
  end,
}

-- Command to manually refresh editable package paths
vim.api.nvim_create_user_command("PyRefreshDevPackages", function()
  local new_paths = get_editable_package_paths()

  -- Update the config
  if vim.lsp.config and vim.lsp.config.pyright and vim.lsp.config.pyright.settings then
    vim.lsp.config.pyright.settings.python.analysis.extraPaths = new_paths
  end

  -- Restart all pyright clients to pick up new paths
  local restarted = false
  for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
    local buffers = vim.lsp.get_buffers_by_client_id(client.id)
    client.stop()
    restarted = true

    -- Wait a bit and restart for each buffer
    vim.defer_fn(function()
      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("LspStart pyright")
          end)
        end
      end
    end, 500)
  end

  if restarted then
    vim.notify("Restarting pyright with " .. #new_paths .. " dev package paths", vim.log.levels.INFO)
  else
    vim.notify("No pyright clients to restart. Detected " .. #new_paths .. " paths.", vim.log.levels.WARN)
  end
end, { desc = "Refresh Python dev/editable package paths for autocomplete" })

-- Command to show detected editable package paths (for debugging)
vim.api.nvim_create_user_command("PyShowDevPackages", function()
  local paths = get_editable_package_paths()
  if #paths == 0 then
    vim.notify("No editable packages detected", vim.log.levels.WARN)
  else
    vim.notify("Detected " .. #paths .. " editable package paths:", vim.log.levels.INFO)
    for i, path in ipairs(paths) do
      print(i .. ": " .. path)
    end
  end
end, { desc = "Show detected Python dev/editable package paths" })

-- Debug command to show what's happening step by step
vim.api.nvim_create_user_command("PyDebugDevPackages", function()
  print("=== Debugging Editable Package Detection ===")

  -- Get python path
  local python_path = vim.fn.exepath("python3")
  if python_path == "" then
    python_path = vim.fn.exepath("python")
  end
  print("Python executable: " .. (python_path ~= "" and python_path or "NOT FOUND"))

  if python_path == "" then
    print("ERROR: No Python executable found!")
    return
  end

  -- Check for uv vs pip
  local uv_path = vim.fn.exepath("uv")
  local pip_cmd = ""

  if uv_path ~= "" then
    pip_cmd = uv_path .. " pip"
    print("Package manager: uv (found at " .. uv_path .. ")")
  else
    pip_cmd = python_path .. " -m pip"
    print("Package manager: pip (uv not found, using fallback)")
  end

  -- Get site-packages
  local site_packages_handle = io.popen(python_path .. " -c \"import site; print(site.getsitepackages()[0])\" 2>/dev/null")
  if not site_packages_handle then
    print("ERROR: Could not get site-packages")
    return
  end

  local site_packages = site_packages_handle:read("*l")
  site_packages_handle:close()
  print("Site-packages: " .. (site_packages or "NOT FOUND"))

  -- Get editable packages
  print("\n=== Running: " .. pip_cmd .. " list --editable ===")
  local handle = io.popen(pip_cmd .. " list --editable --format=freeze 2>&1")
  if not handle then
    print("ERROR: Could not run pip/uv list")
    return
  end

  local result = handle:read("*a")
  handle:close()
  print("Output:\n" .. result)

  -- Parse packages
  print("\n=== Parsing Packages ===")
  for line in result:gmatch("[^\r\n]+") do
    local pkg_name = line:match("^([^=]+)")
    if pkg_name then
      print("\nPackage: " .. pkg_name)

      local dist_info_pattern = site_packages .. "/" .. pkg_name:gsub("%-", "_") .. "*.dist-info/direct_url.json"
      print("Looking for: " .. dist_info_pattern)

      local glob_handle = io.popen("ls " .. dist_info_pattern .. " 2>&1")
      if glob_handle then
        local direct_url_file = glob_handle:read("*l")
        glob_handle:close()

        if direct_url_file and direct_url_file ~= "" and not direct_url_file:match("No such file") then
          print("Found: " .. direct_url_file)

          local json_file = io.open(direct_url_file, "r")
          if json_file then
            local json_content = json_file:read("*a")
            json_file:close()
            print("Content: " .. json_content)

            local source_path = json_content:match('"url":%s*"file://([^"]+)"')
            if source_path then
              source_path = source_path:gsub("%%(%x%x)", function(hex)
                return string.char(tonumber(hex, 16))
              end)
              print("Source path: " .. source_path)
            else
              print("Could not extract source path from JSON")
            end
          else
            print("Could not open file")
          end
        else
          print("File not found: " .. (direct_url_file or "nil"))
        end
      end
    end
  end
end, { desc = "Debug Python dev/editable package detection" })

mason_null_ls.setup({
  -- list of formatters & linters for mason to install
  ensure_installed = {
    "stylua", -- lua formatter
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
})
