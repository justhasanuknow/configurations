-- LaTeX: compile with latexmk, open the PDF, jump between source and viewer.
-- texlab (Mason) does completion and diagnostics; vimtex does the rest
return {
  "lervag/vimtex",
  -- vimtex asks not to be lazy-loaded: its own filetype detection must run first
  lazy = false,
  init = function()
    -- Read by vimtex at load time, so they have to be set in init, not config
    vim.g.vimtex_compiler_method = "latexmk"
    -- zathura on the desktop; "general" falls back to xdg-open elsewhere
    vim.g.vimtex_view_method = vim.fn.executable("zathura") == 1 and "zathura" or "general"
    -- texlab already reports errors inline; no quickfix window on every warning
    vim.g.vimtex_quickfix_mode = 0
  end,
}
