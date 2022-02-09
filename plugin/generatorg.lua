-- Save current file into ./docs
vim.cmd("command! -bang -nargs=0 DocCurrent :lua require('generatorg').save_current_file()")

-- save entire folder into ./docs
vim.cmd("command! -bang -nargs=0 DocFolder :lua require('generatorg').save_project()")

vim.cmd("command! -bang -nargs=0 LiveDoc :lua require('generatorg').live_run_current_file()")

-- kill pdoc
vim.cmd("command! -bang -nargs=0 KillPdoc :lua require('generatorg').pdoc_close()")
