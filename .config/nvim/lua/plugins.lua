return require('packer').startup(function()
    use 'wbthomason/packer.nvim'


    use 'cocopon/vaffle.vim'    -- File browser
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'rhysd/conflict-marker.vim'

    use 'tpope/vim-fugitive'
    use {
        'mattn/gist-vim',
        requires = {
            'mattn/webapi-vim'
        }
    }
    use 'godlygeek/tabular'
    use 'luochen1990/rainbow'
    use 'machakann/vim-highlightedyank'

    -- Python
    use 'klen/python-mode'

    -- Javascript
    use 'elzr/vim-json'
    use 'pangloss/vim-javascript'
    use 'leafgarland/typescript-vim'
    use 'peitalin/vim-jsx-typescript'
    use 'MaxMEllon/vim-jsx-pretty'

    -- HTML
    use 'alvan/vim-closetag'
    use 'hail2u/vim-css3-syntax'
    use 'gko/vim-coloresque'
    use 'tpope/vim-haml'
    use 'mattn/emmet-vim'

    -- Markdown + TOML
    use 'tpope/vim-markdown'
    use 'cespare/vim-toml'

    -- Airline
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
end)