hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,
    layout = "dwindle",
  },
  decoration = {
    rounding = 3,
    active_opacity = 0.95,
    inactive_opacity = 0.80,
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
    },
  },
  animations = {
    enabled = true,
  },
  input = {
    kb_layout = "tr",
    follow_mouse = 1,
    touchpad = {
      natural_scroll = true,
    },
  },
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
  },
})
