--! file: registry.lua

require("core")

local entities = {}
local systems = {}

function AddEntity(name, entity_dir)
  entities[name] = entity_dir
end

function GetEntity(name)
  return entities[name]
end

function DelEntity(name)
  entities[name] = nil
end

function AddComponentToEntity(name, component_name, component)
  entities[name][component_name] = component
end

-- pass entity dir
function HasComponent(entity, component)
  if entity[component] ~= nil then
      return true
    else
      return false
  end
end

function View(...)
  local args = {...}
  local dir = {}
  for i,e in pairs(entities) do
    local fits = true
    for j,c in pairs(args) do
      if not HasComponent(e, c) then
        fits = false
        break
      end
    end
    if fits == true then
      table.insert(dir, e)
    end
  end
  return dir
end

function AddSystem(sysfunc)
  table.insert(systems, sysfunc)
end

function UpdateSystems(dt)
  for i,v in pairs(systems) do
    v(dt)
  end
end