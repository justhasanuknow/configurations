local mod = "SUPER"
local terminal = "kitty"
local launcher = "wofi --show drun"

local function bind(keys, action, opts)
	hl.bind(mod .. " + " .. keys, action, opts)
end

-- Launch and close
bind("Return", hl.dsp.exec_cmd(terminal))
bind("D", hl.dsp.exec_cmd(launcher))
bind("Q", hl.dsp.window.close())
bind("SHIFT + E", hl.dsp.exit())

-- Focus and move, vim style
local dirs = { H = "left", J = "down", K = "up", L = "right" }
for key, dir in pairs(dirs) do
	bind(key, hl.dsp.focus({ direction = dir }))
	bind("SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Window state
bind("F", hl.dsp.window.fullscreen())
bind("V", hl.dsp.window.float({ action = "toggle" }))
bind("P", hl.dsp.window.pseudo())
bind("S", hl.dsp.layout("togglesplit"))

-- Workspaces
for i = 1, 5 do
	bind(tostring(i), hl.dsp.focus({ workspace = i }))
	bind("SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
bind("Tab", hl.dsp.focus({ workspace = "previous" }))

-- Mouse
bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Bar
bind("B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))        -- toggle visibility
bind("SHIFT + B", hl.dsp.exec_cmd("pkill waybar; waybar")) -- restart after config changes
