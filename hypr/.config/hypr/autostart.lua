-- Programs started once with the session
hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle") -- locks and turns the screen off when idle
  hl.exec_cmd("mako") -- notification daemon
  hl.exec_cmd("systemctl --user start hyprpolkitagent") -- password prompts for GUI apps

  -- Clipboard history: one watcher per MIME class, cliphist stores both
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
