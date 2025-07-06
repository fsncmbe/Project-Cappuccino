--! file: main.lua
-- love /home/cmbe/GitHub/Project-Cappuccino

require("registry")
require("render")

function love.load()
  AddEntity("pla", {
    position = {x=200, y=10};
    size = {width=100, height=100};
    render = {drawable=nil, layer=2, color={.2, .6, .2}};
  })
  AddEntity("player", {
    position = {x=10, y=10};
    size = {width=100, height=100};
    render = {drawable=nil, layer=1};
  })
end

function love.update(dt)
  UpdateSystems(dt)
end

function love.draw()
  UpdateRender()
end