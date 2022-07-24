-------------------------------------------------
local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

nmap = bind("n", {noremap = false})
nnoremap = bind("n")
vnoremap = bind("v")
xnoremap = bind("x")
inoremap = bind("i")
tnoremap = bind("t")
map = bind("")
-------------------------------------------------

-- Navigate windows with ctrl + shift + hjkl
map("<C-J>", "<C-W>j")
map("<C-K>", "<C-W>k")
map("<C-L>", "<C-W>l")
map("<C-H>", "<C-W>h")

-- ctrl + h unhighlights
map("<C-h>", ":noh<CR>")

-- Stay in visual mode after indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- No-op stupid commands that are annoying
nnoremap("q:", "<nop>")
nnoremap("Q", "<nop>")

nnoremap("Y", "Y$")