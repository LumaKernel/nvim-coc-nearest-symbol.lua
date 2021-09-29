# nvim-coc-nearest-symbol.lua

```lua
lua << EOF
local m = require'coc-nearest-symbol'
local n = m:nearest_symbols(vim.fn.CocAction('documentSymbols'), m:get_char_pos())
n['prev']
n['here']
n['next']

o = m:all_symbols(vim.fn.CocAction('documentSymbols'), m:get_char_pos())
-- o[1], o[2], ...
EOF
```
