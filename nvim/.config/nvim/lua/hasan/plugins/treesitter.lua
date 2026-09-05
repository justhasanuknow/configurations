-- Tree-sitter parser/query manager: syntax-aware highlighting and indentation
return {
  "neovim-treesitter/nvim-treesitter",
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      -- config and shell
      "lua",
      "vim",
      "vimdoc",
      "query",
      "bash",
      -- data and docs
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      -- languages in active use
      "python",
      "c",
      "cpp",
      "cmake",
      "latex",
      -- web stack
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "svelte",
      -- git
      "gitcommit",
      "diff",
    })

    -- Features are opt-in: enable them for any buffer that has a parser installed
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.start) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
