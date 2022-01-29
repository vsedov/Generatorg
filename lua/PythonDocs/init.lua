local api = vim.api
local Job = require("plenary.job")

local run_pdoc = function(args)
    Job
        :new({
            command = "pdoc",
            args = args,
            -- better std_err and out
            on_stderr = function(line)
                vim.notify("pdoc: " .. line, vim.log.warning)
            end,
            on_stdout = function(line)
                vim.notify("pdoc created")
            end,
        })
        :start()
end

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

local M = {}

M.save_project = function()
    local function arg_parser(info)
        return { "-o", "./docs", info }
    end
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
    run_pdoc(file_name)
end

M.local_run_file = function()


return M
