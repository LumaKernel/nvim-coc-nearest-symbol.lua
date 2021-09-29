# nvim-coc-nearest-symbol.lua

```lua
lua << EOF
local m = require'coc-nearest-symbol'
local n = m:nearest_symbol(vim.fn.CocAction('documentSymbols'), m:get_char_pos())
n['prev']
n['here']
n['next']
EOF
```
