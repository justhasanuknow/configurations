-- Clear search highlight with ESC
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Carry lines in  visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Carry the selection to bottom" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Carry the selection to top" })

-- Keep indent select in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Decrease indent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Increase indent and keep selection" })

-- Paste without change
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste clipboard without change" })

-- Save file and exit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close" })
