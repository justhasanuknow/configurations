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
bind("B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")) -- toggle visibility
bind("SHIFT + B", hl.dsp.exec_cmd("pkill waybar; waybar")) -- restart after config changes

-- Lock. SUPER + SHIFT + L already moves a window right, so Escape it is
bind("Escape", hl.dsp.exec_cmd("hyprlock"))

-- Lid: lock when it closes. "Lid Switch" is the libinput name on nearly every
-- laptop (`hyprctl devices` lists it); on a desktop the bind simply never fires.
-- `locked` keeps it working while hyprlock is already up
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })

-- Screenshots: clipboard + ~/Pictures/Screenshots + notification, see scripts/.local/bin/screenshot
-- Absolute path: the session's shell does not read .zshrc, so ~/.local/bin is not on PATH
local screenshot = "$HOME/.local/bin/screenshot"
bind("SHIFT + S", hl.dsp.exec_cmd(screenshot .. " region"))
bind("Print", hl.dsp.exec_cmd(screenshot .. " screen"))

-- Clipboard history: pick an earlier entry, it becomes the current one
bind("SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Media keys: no modifier, work while locked, repeat while held
local media = { locked = true, repeating = true }
local once = { locked = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), media)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), once)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), once)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), media)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), media)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), once)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), once)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), once)
