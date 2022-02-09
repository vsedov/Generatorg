local api = vim.api
local uv = require("luv")

local run_pdoc = function(args, cwd, live)
    live = false or live
    cwd = cwd or vim.fn.getcwd()
    local stderr = vim.loop.new_pipe(false)
    local handle = uv.spawn("pdoc", {
        args = args,
        cwd = cwd,
        stdio = { stderr },

        on_exit = function(code, signal)
            if code == 0 then
                vim.notify("pdoc created")
            else
                vim.notify("pdoc: " .. signal, vim.log.warning)
            end
        end,
    })
    if handle and live then
        vim.notify("pdoc: " .. "started")
        vim.cmd("autocmd VimLeave * lua require('generatorg').pdoc_close()")
    end
end

---Check project checks if __init__ is at head,
-- if not then it converts all python files into docs
local check_if_proejct = function()
    local proj_path = vim.fn.getcwd()
    local is_project = false
    local files = require("plenary.scandir").scan_dir(proj_path, {})

    -- check root if __init__.py exist
    -- im not sure of a better way of doing this for the time
    for _, file in ipairs(files) do
        -- this would have to get tested
        if string.match(file, proj_path .. "/__init__.py") then
            is_project = true
            break
        end
    end
    if is_project then
        return proj_path
    else
        local current_files = {}
        for _, file in ipairs(files) do
            if string.match(file, ".py$") then
                table.insert(current_files, file)
            end
        end
        return current_files
    end
end

local function arg_parser(info)
    return { "-o", "./docs", info }
end

local M = {}

M.save_project = function()
    local get_project_info = check_if_proejct()
    vim.notify("Pdoc generating ./docs", get_project_info)
    if type(get_project_info) == "string" then
        run_pdoc(arg_parser(get_project_info))
    else
        for _, file in ipairs(get_project_info) do
            run_pdoc(get_project_info(file))
        end
    end
end

M.save_current_file = function()
    local file_type = api.nvim_buf_get_option(0, "filetype") -- get filetype
    if file_type ~= "python" then
        return
    end
    local file_name = api.nvim_buf_get_name(0)
    run_pdoc(arg_parser(file_name))
end

function M.pdoc_close()
    local cmd = "!lsof -t -i:8080 | xargs kill -9"
    vim.cmd(cmd)
end

function M.live_run_current_file()
    local args = { vim.fn.expand("%") }
    local cwd = vim.fn.getcwd()
    run_pdoc(args, cwd, true)
end

return M
