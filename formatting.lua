
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

function toFilter(f)
  return function(str, render)
    local rendered = render(strip(str))
    if not rendered or rendered == "" then return "" end
    return f(rendered)
  end
end

function comma(str, render)
  local number = tonumber(str)
  if not number then return str end
  local formatted = format_int(number)
  return formatted
end

function dateDMY(date)
  if not date then return "" end
  local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
  if not year or not month or not day then return date end
  return string.format("%02d/%02d/%04d", tonumber(day), tonumber(month), tonumber(year))
end

function datetimeDMYHHMM(date)
  if not date then return "" end
  local year, month, day, hour, minute = date:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+)")
  if not year or not month or not day or not hour or not minute then return date end
  return string.format("%02d/%02d/%04d %02d:%02d", tonumber(day), tonumber(month), tonumber(year), tonumber(hour), tonumber(minute))
end

function enrich(entry)
  entry.surroundX = surroundX
  entry.comma = toFilter(comma)
  entry.date = toFilter(dateDMY)
  entry.dateDMY = toFilter(dateDMY)
  entry.datetime = toFilter(datetimeDMYHHMM)
  entry.datetimeDMYHHMM = toFilter(datetimeDMYHHMM)
end
