local refactoring_status, refactoring = pcall(require, "refactoring")
if not refactoring_status then
	return
end

refactoring.setup({})
