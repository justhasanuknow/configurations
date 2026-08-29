-- Full git UI inside a floating Neovim window
return {
	"kdheepak/lazygit.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "LazyGit", "LazyGitCurrentFile" },
	keys = {
		{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open lazygit" },
	},
}
