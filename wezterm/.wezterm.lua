local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Kanagawa wave like Color Scheme
config.color_schemes = {
    ['KanagawaWave'] = {
        background = '#1F1F28',
        cursor_bg  = '#C80000',
        foreground = '#D8D8D9',
        cursor_fg  = '#1F1F28',
        selection_bg = '#2D4F67',
        selection_fg = '#D8D8D9',

        ansi = {
            '#090618', -- black
            '#C4746E', -- red
            '#76946A', -- green
            '#C0A36E', -- yellow
            '#7E9CD8', -- blue
            '#957FB8', -- purple
            '#6A9589', -- cyan
            '#C8C093', -- white
        },
        brights = {
            '#727169', -- bright black
            '#E46876', -- bright red
            '#98BB6C', -- bright green
            '#E6C384', -- bright yellow
            '#7FB4CA', -- bright blue
            '#938AA9', -- bright purple
            '#7AA89F', -- bright cyan
            '#DCD7BA', -- bright white
        },
    },
}
config.color_scheme = 'KanagawaWave'
config.enable_tab_bar = true
config.hide_mouse_cursor_when_typing = true

-- use gpu
config.front_end = 'WebGpu'
config.webgpu_power_preference = "HighPerformance"

-- set leader key
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

-- changing the initial geometry for new windows:
config.initial_cols = 150
config.initial_rows = 47

-- or, changing the font size and color scheme.
config.font_size = 12.0
config.default_cursor_style = 'BlinkingBlock'

-- change font
config.font = wezterm.font('Iosevka Nerd Font')

-- background image
config.window_background_image = 'D:/Descargas/archivos/imagenes/fonto_term.jpg'
config.window_background_image_hsb = {
    brightness = 0.05,
    hue = 1.0,
    saturation = 1.0,
}

-- shell
if wezterm.target_triple:find("windows") then
    config.default_prog = { "pwsh.exe" }
    local success, stdout, stderr = wezterm.run_child_process({ "where", "pwsh.exe" })
    if not success then
        config.default_prog = { "powershell.exe" }
    end
end
-- key bindings

config.keys = {
    {
        key = 'z',
        mods = 'LEADER',
        action = wezterm.action.TogglePaneZoomState
    },
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'q',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentPane({ confirm = true}),
    },
    {
        key = 'h',
        mods = 'LEADER|SHIFT',
        action = wezterm.action.RotatePanes('CounterClockwise'),
    },
    {
        key = 'l',
        mods = 'LEADER|SHIFT',
        action = wezterm.action.RotatePanes('Clockwise'),
    },
    {
        key = ",",
        mods = "LEADER",
        action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
            end),
        },
    },
    {
        key = "r",
        mods = "LEADER",
        action = wezterm.action.ActivateKeyTable {
            name = "resize_pane",
            one_shot = false,
        },
    },
}

config.key_tables = {
    resize_pane = {
        { key = 'LeftArrow',  action = wezterm.action.AdjustPaneSize { 'Left', 2 } },
        { key = 'h',          action = wezterm.action.AdjustPaneSize { 'Left', 2 } },

        { key = 'RightArrow', action = wezterm.action.AdjustPaneSize { 'Right', 2 } },
        { key = 'l',          action = wezterm.action.AdjustPaneSize { 'Right', 2 } },

        { key = 'UpArrow',    action = wezterm.action.AdjustPaneSize { 'Up', 2 } },
        { key = 'k',          action = wezterm.action.AdjustPaneSize { 'Up', 2 } },

        { key = 'DownArrow',  action = wezterm.action.AdjustPaneSize { 'Down', 2 } },
        { key = 'j',          action = wezterm.action.AdjustPaneSize { 'Down', 2 } },

        -- Exit resize mode
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'Enter',  action = 'PopKeyTable' },
    },
}
-- show resize state
wezterm.on('update-right-status', function(window, pane)
    local name = window:active_key_table()
    if name then
        name = 'MODE: ' .. name .. ' '
    end
    window:set_right_status(name or '')
end)

-- Intercept startup to apply coordinates for your primary monitor
wezterm.on('gui-startup', function(cmd)
    local args = cmd or {}
    -- Modify these pixel offsets to move your window around
    args.position = { x = 450, y = 10, origin = 'MainScreen' }
    wezterm.mux.spawn_window(args)
end)
return config

