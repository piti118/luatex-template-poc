
function surroundX(str, render)
  return "x" .. render(str) .. "x"
end

-- https://stackoverflow.com/questions/10989788/format-integer-in-lua
function format_int(number)

  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append a comma to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function strip(str)
  str = str:gsub("%s+", "")
  return str
end

function comma(str, render)
  local rendered = render(strip(str))
  local number = tonumber(rendered)
  if not number then return rendered end
  local formatted = format_int(number)
  return formatted
end

function enrich(entry)
  entry.surroundX = surroundX
  entry.comma = comma
end
