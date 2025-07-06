--! file: render.lua

require("core")
require("registry")

-- 5 different layers of rendering, 1 is the first one to be drawn
local num_layers = 5
local renderpipeline = {
  {};
  {};
  {};
}

-- but this will not be in updateSystems, but its own with updateRender()

--components: render={drawable, layer}, position={x, y}, size={width, height}

function UpdateRender()
  -- Update layers
  for i=1, num_layers do
    renderpipeline[i] = {}
  end

  -- Get all entities to render
  local dir = View("render", "position", "size")

  -- Go through each and assign to layer
  for i,v in pairs(dir) do
    -- Optional color property
    if v["render"]["color"] ~= nil then
      love.graphics.setColor(v["render"]["color"])
    end

    -- If object has a drawable in it like an image 
    if v["render"]["drawable"] ~= nil then
      table.insert(renderpipeline[v["render"]["layer"]], function () love.graphics.draw(v["render"]["drawable"], v["position"]["x"], v["position"]["y"]) end)
    end

    -- If Debug is on show rectangle
    if DebugMode == true then
      love.graphics.rectangle("fill", v["position"]["x"], v["position"]["y"], v["size"]["width"], v["size"]["height"])
    end

    love.graphics.setColor({1, 1, 1})
  end
end