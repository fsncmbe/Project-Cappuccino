--! file: render.lua

require("core")
require("registry")

-- 5 different layers of rendering, 1 is the first one to be drawn
local num_layers = 5
local renderpipeline = {
  {};
  {};
  {}
}

-- but this will not be in updateSystems, but its own with updateRender()

function SortBy(entity1, entity2, ...)
  local ent1 = entity1
  local ent2 = entity2
  local args = {...}
  for i,v in pairs(args) do
    ent1 = ent1[v]
    ent2 = ent2[v]
  end
  return ent1 < ent2
end

--components: render={drawable, layer}, position={x, y}, size={x, y}

function UpdateRender()
  -- Update layers
  for i=1, num_layers do
    renderpipeline[i] = {}
  end

  -- Get all entities to render
  local dir = View("render", "position", "size")

  -- Sort the dir by y positions, no regard to layer
  table.sort(dir, function(a, b) return SortBy(a, b, "position", "y") end)

  -- Go through each and assign to layer
  for i,v in pairs(dir) do

    local color = {1, 1, 1}
    -- Optional color property
    if v["render"]["color"] ~= nil then
      color = (v["render"]["color"])
    end

    -- Add objects to render pipeline, to distinguish between layers

    -- If object has a drawable in it like an image 
    if v["render"]["drawable"] ~= 0 then
      table.insert(renderpipeline[v["render"]["layer"]],
      function ()
        love.graphics.setColor(color)
        love.graphics.draw(v["render"]["drawable"], v["position"]["x"], v["position"]["y"])
      end)
    end

    -- If Debug is on show rectangle
    if DebugMode == true then
      table.insert(renderpipeline[v["render"]["layer"]],
      function ()
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", v["position"]["x"], v["position"]["y"], v["size"]["x"], v["size"]["y"])
        end)
    end

  end

  -- Render all renderables by calling their functions, going through each layer
  for i,v in pairs(renderpipeline) do
    for j,f in pairs(v) do
      f()
    end
  end

end