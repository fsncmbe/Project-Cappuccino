--! file: core.lua

-- Settings

DebugMode = true

function PrintableTable(table)
  if type(table) == 'table' then
    local s = "{ "
    for k,v in pairs(table) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. PrintableTable(v) .. ','
    end
    return s .. "}"
  else
    return tostring(table)
  end
end

-- vector in form of {x, y}
function Normalize(vector)
  local length = LenVector(vector)
  if length > 1 then
    return {x = vector["x"]/length; y = vector["y"]/length}
  else
    return vector
  end
end

function LenVector(vector)
  local x_s = vector["x"] * vector["x"]
  local y_s = vector["y"] * vector["y"]
  return math.sqrt(x_s + y_s)
end

function MakeVector(value)
  return {x = value, y = value}
end

function AddVectors(vec1, vec2)
  return {x = vec1.x + vec2.x; y = vec1.y + vec2.y}
end

function SubVectors(vec1, vec2)
  return AddVectors(MulVectors(vec1, MakeVector(-1)), vec2)
end

function MulVectors(vec1, vec2)
  return {x = vec1.x * vec2.x; y = vec1.y * vec2.y}
end