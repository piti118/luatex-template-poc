
function surroundX(str, render)
  return "x" .. render(str) .. "x"
end

function enrich(entry)
  entry.surroundX = surroundX
end
