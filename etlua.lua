-- etlua.lua (MIT License)
-- https://github.com/leafo/etlua (minimal version for LuaLaTeX)
local etlua = {}
local function escape(str)
  return tostring(str):gsub('[&<>"]', {
    ['&'] = "&amp;",
    ['<'] = "&lt;",
    ['>'] = "&gt;",
    ['\"'] = "&quot;"
  })
end
function etlua.render(template, env)
  local code = {'local _OUT = {}'}
  local pos = 1
  for s, e, expr in template:gmatch('()(<%%=?(.-)%%>)()') do
    table.insert(code, string.format('_OUT[#_OUT+1]=[=[%s]=]', template:sub(pos, s-1)))
    if expr:sub(1,1) == '=' then
      table.insert(code, string.format('_OUT[#_OUT+1]=tostring(%s)', expr:sub(2)))
    else
      table.insert(code, expr)
    end
    pos = e
  end
  table.insert(code, string.format('_OUT[#_OUT+1]=[=[%s]=]', template:sub(pos)))
  table.insert(code, 'return table.concat(_OUT)')
  local f = assert(load(table.concat(code, '\n'), 'etlua', 't', env))
  return f()
end
return etlua
