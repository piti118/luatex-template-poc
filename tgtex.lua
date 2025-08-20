M = {}

function M.readFile(fname)
  local file = io.open(fname, "r")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  return content
end

function M.readJSON(fname)
  local content = M.readFile(fname)
  local data = utilities.json.tolua(content)
  return data
end

function M.renderTemplate(template, entry)
  local lustache = require "lustache.lua"
  entry = M.enrich(entry)
  local output = lustache:render(template, entry)
  return output
end



function M.surroundX(str, render)
  return "x" .. render(str) .. "x"
end

-- https://stackoverflow.com/questions/10989788/format-integer-in-lua
function M.format_int(number)

  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append a comma to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function M.strip(str)
  str = str:gsub("%s+", "")
  return str
end

function M.toFilter(f)
  return function(str, render)
    local rendered = render(M.strip(str))
    if not rendered or rendered == "" then return "" end
    return f(rendered)
  end
end

function M.comma(str)
  local number = tonumber(str)
  if not number then return str end
  local formatted = M.format_int(number)
  return formatted
end

function M.dateDMY(date)
  if not date then return "" end
  local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
  if not year or not month or not day then return date end
  return string.format("%02d/%02d/%04d", tonumber(day), tonumber(month), tonumber(year))
end

function M.datetimeDMYHHMM(date)
  if not date then return "" end
  local year, month, day, hour, minute = date:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+)")
  if not year or not month or not day or not hour or not minute then return date end
  return string.format("%02d/%02d/%04d %02d:%02d", tonumber(day), tonumber(month), tonumber(year), tonumber(hour), tonumber(minute))
end

function M.enrich(entry)
  entry.surroundX = M.surroundX
  entry.comma = M.toFilter(M.comma)
  entry.date = M.toFilter(M.dateDMY)
  entry.dateDMY = M.toFilter(M.dateDMY)
  entry.datetime = M.toFilter(M.datetimeDMYHHMM)
  entry.datetimeDMYHHMM = M.toFilter(M.datetimeDMYHHMM)
  return entry
end

function M.printTEX(str)
  -- takes care of newline correctly
  -- see https://tex.stackexchange.com/questions/400823/lualatex-insert-text-with-newline
  local lines = {}
  for line in str:gmatch("[^\r\n]+") do
    table.insert(lines, line) 
    -- new line doesn't get translated correctly
  end
  tex.print(table.unpack(lines))
end

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

return M
