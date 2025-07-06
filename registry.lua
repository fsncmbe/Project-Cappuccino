--! file: registry.lua

require("core")

local entities = {}
local systems = {}

function AddEntity(name, entity_dir)
  entities[name] = entity_dir
end

function DelEntity(name)
  entities[name] = nil
end

function AddComponentToEntity(name, component_name, component)
  entities[name][component_name] = component
end

function HasComponent(entity, component)
  if entities[entity][component] ~= nil then
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
      if not HasComponent(i, c) then
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

function AddSystem(system, sysfunc)
  systems[system] = sysfunc
end

function UpdateSystems(dt)
  for i,v in pairs(systems) do
    v(dt)
  end
end