local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "Symbols Nerd Font",
  }),
  font_size = 12.0,
  color_scheme = "Gruvbox Dark",

  term = "xterm-256color",
  enable_wayland = false,
  enable_kitty_keyboard = true,

  -- ALWAYS attach or create tmux
  default_prog = {
    "/bin/bash",
    "-lc",
    "tmux attach -t main || tmux new -s main"
  },

  keys = {
    -- Let tmux fully own Ctrl-b
    { key = "b", mods = "CTRL", action = wezterm.action.SendKey { key = "b", mods = "CTRL" } },
  },
}
