--! file: registry.lua

require("core")

local entities = {}
local systems = {}
local components = {}

function AddEntity(name, comps)
  entities[name] = {}
  for _, v in pairs(comps) do
    AddComponent(name, v)
  end
end

function LoadEntityFromFile(name, path)
  local dir = ReadJson(path)
  AddEntity(name, dir["components"])
  for i,v in pairs(dir) do
    if i ~= "components" then
      MergeIntoFirstTable(GetComponent(name, i), v)
    end
  end
end

function GetEntity(name)
  return entities[name]
end

function DelEntity(name)
  entities[name] = nil
end

function RegComponent(name, table)
  components[name] = table
end

function LoadComponentsFromFile(path)
  local dir = ReadJson(path)
  for i,v in pairs(dir) do
    RegComponent(i, v)
  end
end

function AddComponent(name, componentname)
  entities[name][componentname] = CopyTable(components[componentname])
end

function GetComponent(name, componentname)
  return entities[name][componentname]
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