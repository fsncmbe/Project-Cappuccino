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