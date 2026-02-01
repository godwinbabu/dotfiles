local map = vim.keymap.set

-- Better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Force delete buffer" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down (using Ctrl-Shift to avoid collision with Zellij's Alt-h/j/k/l)
map("n", "<C-S-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<C-S-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<C-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<C-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Previous search centered" })

-- Paste without yanking selection
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Save file
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- Split windows
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- macOS CMD key mappings (requires terminal to pass through Cmd)
-- These work in Ghostty and iTerm2 with proper config
map({ "n", "v" }, "<D-c>", '"+y', { desc = "Copy to clipboard" })
map({ "n", "v" }, "<D-v>", '"+p', { desc = "Paste from clipboard" })
map("i", "<D-v>", '<C-r>+', { desc = "Paste from clipboard" })
map("c", "<D-v>", '<C-r>+', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<D-x>", '"+d', { desc = "Cut to clipboard" })
map("n", "<D-a>", "ggVG", { desc = "Select all" })
map("n", "<D-s>", "<cmd>w<CR>", { desc = "Save" })
map("i", "<D-s>", "<Esc><cmd>w<CR>", { desc = "Save" })
map("n", "<D-w>", "<cmd>bd<CR>", { desc = "Close buffer" })
map("n", "<D-q>", "<cmd>qa<CR>", { desc = "Quit" })
