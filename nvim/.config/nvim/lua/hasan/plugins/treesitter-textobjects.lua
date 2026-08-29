-- Syntax-aware text objects: select, move and swap by function, class or parameter
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "neovim-treesitter/nvim-treesitter" },
  lazy = false,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- Jump forward to the next textobject when the cursor is not inside one
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    -- Select: usable after operators (d, c, y) and in visual mode
    local selections = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
    }

    for key, query in pairs(selections) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(query, "textobjects")
      end, { desc = "Select " .. query })
    end

    -- Move to next/previous function
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function" })

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function" })

    -- Swap the parameter under the cursor with its neighbour
    vim.keymap.set("n", "<leader>sa", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap parameter with next" })

    vim.keymap.set("n", "<leader>sA", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap parameter with previous" })
  end,
}
