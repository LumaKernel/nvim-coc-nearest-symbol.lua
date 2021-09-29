local M = {}

-- @typedef Pos
-- @property line {number} 0-indexed
-- @property character {number} 0-indexed

-- @typedef Range
-- @property start {Pos}
-- @property end {Pos}

-- @typedef SymbolDefinition
-- @property lnum {number} 1-indexed
-- @property col {number} 1-indexed
-- @property range {Range}

-- @param lhs {Pos}
-- @param rhs {Pos}
-- @return {number}
local compare_pos = function(lhs, rhs)
  if lhs['line'] ~= rhs['line'] then
    return lhs['line'] - rhs['line']
  end
  return lhs['character'] - rhs['character']
end

-- @param symbols {SymbolDefinition[]} symbols table got from CocAction('documentSymbols')
-- @param curpos {Pos} cursor position to find nearest symbol
-- @return {{ prev: number , here: number , next: number }} 0-indexed indices
function M:nearest_symbol_indices(symbols, curpos)
  local prev
  local here
  local next
  for i=1, #symbols do
    local s = symbols[i]
    if compare_pos(s['range']['start'], curpos) <= 0 then
      if compare_pos(curpos, s['range']['end']) <= 0 then
        here = i - 1
      else
        prev = i - 1
      end
    elseif compare_pos(curpos, s['range']['end']) > 0 then
      if next == nil then
        next = i - 1
      end
    end
  end
  return { prev = prev, here = here, next = next }
end

-- @param symbols {SymbolDefinition[]} symbols table got from CocAction('documentSymbols')
-- @param curpos {Pos} cursor position to find nearest symbol
-- @return {{ prev: SymbolDefinition, here: SymbolDefinition , next: SymbolDefinition }}
function M:nearest_symbol(symbols, curpos)
  local i = M:nearest_symbol_indices(symbols, curpos)
  return {
    prev = i['prev'] and symbols[i['prev'] + 1],
    here = i['here'] and symbols[i['here'] + 1],
    next = i['next'] and symbols[i['next'] + 1]
  }
end

-- @return {Pos}
function M:get_char_pos()
  local pos = vim.fn.getpos('.')
  local txt = vim.fn.getline(pos[2])
  local char_col = vim.fn.charidx(txt, math.min(pos[3], #txt) - 1)
  return {line = pos[2] - 1, character = char_col}
end

return M
