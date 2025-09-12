-- smoothcursorの色
vim.cmd("highlight SmoothCursor guifg=#a6e3a1")
vim.cmd("highlight SmoothCursorRed guifg=#f38ba8")
vim.cmd("highlight SmoothCursorOrange guifg=#fab387")
vim.cmd("highlight SmoothCursorYellow guifg=#f9e2af")
vim.cmd("highlight SmoothCursorGreen guifg=#a6e3a1")
vim.cmd("highlight SmoothCursorAqua guifg=#89dceb")
vim.cmd("highlight SmoothCursorBlue guifg=#89b4fa")
vim.cmd("highlight SmoothCursorPurple guifg=#cba6f7")

return {
    "gen740/SmoothCursor.nvim",
    event = "CursorMoved",
    opts = {
        fancy = {
            enable = true,
            head = { cursor = "●", linehl = nil },
            body = {
                { cursor = "󰝥", texthl = "SmoothCursorRed" },
                { cursor = "󰝥", texthl = "SmoothCursorOrange" },
                { cursor = "●", texthl = "SmoothCursorYellow" },
                { cursor = "●", texthl = "SmoothCursorGreen" },
                { cursor = "•", texthl = "SmoothCursorAqua" },
                { cursor = ".", texthl = "SmoothCursorBlue" },
                { cursor = ".", texthl = "SmoothCursorPurple" },
            },
            tail = { cursor = nil, texthl = "SmoothCursor" },
        },
        autostart = true,         -- Automatically start SmoothCursor
        always_redraw = true,     -- Redraw the screen on each update
        flyin_effect = "top",     -- Choose "bottom" or "top" for flying effect
        speed = 40,               -- Max speed is 100 to stick with your current position
        intervals = 25,           -- Update intervals in milliseconds
        priority = 13,            -- Set marker priority
        timeout = 3000,           -- Timeout for animations in milliseconds
        threshold = 3,            -- Animate only if cursor moves more than this many lines
        disable_float_win = true, -- Disable in floating windows
        enabled_filetypes = nil,  -- Enable only for specific file types, e.g., { "lua", "vim" }
        show_last_positions = nil,
    },
}
