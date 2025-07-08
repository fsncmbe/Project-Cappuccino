--! file: core.lua

-- SETTINGS

DebugMode = true

-- HELPER FUNCTIONS

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

function CopyTable(orig, seen)
  if type(orig) ~= "table" then
    return orig
  end

  local copy = {}
  seen = seen or {}
  seen[orig] = copy

  for i,v in pairs(orig) do
    copy[CopyTable(i, seen)] = CopyTable(v, seen)
  end

  return setmetatable(copy, getmetatable(orig))
end

function MergeIntoFirstTable(tab1, tab2)
  for i,v in pairs(tab2) do
    tab1[i] = tab2[i]
  end
end

-- VECTOR FUNCTIONS always in form {x=10, y=10}
function Normalize(vector)
  local length = LenVector(vector)
  if length > 1 then
    return {x = vector.x/length; y = vector.y/length}
  else
    return vector
  end
end

function LenVector(vector)
  local x_s = vector.x * vector.x
  local y_s = vector.y * vector.y
  return math.sqrt(x_s + y_s)
end

function MakeVector(value)
  return {x = value, y = value}
end

function AddVectors(vec1, vec2)
  return {x = vec1.x + vec2.x; y = vec1.y + vec2.y}
end

function SubVectors(vec1, vec2)
  return AddVectors(vec1, MulVectors(vec2, MakeVector(-1)))
end

function MulVectors(vec1, vec2)
  return {x = (vec1.x * vec2.x); y = (vec1.y * vec2.y)}
end

function ScalVector(vec1, scal)
  return {x = vec1.x * scal, y = vec1.y * scal}
end

function FuncVector(vec1, func)
  return {x = func(vec1.x), y = func(vec1.y)}
end

-- the part after the and is the value returned if the one before is true
function SignVector(vec1)
  local x = vec1.x > 0 and 1 or (vec1.x < 0 and -1 or 0)
  local y = vec1.y > 0 and 1 or (vec1.y < 0 and -1 or 0)
  return {x=x; y=y}
end