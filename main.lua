--! file: main.lua
-- Linux:   love /home/cmbe/GitHub/Project-Cappuccino
-- Windows: & 'C:\Program Files\LOVE\love.exe' .

require("registry")
require("physics")
require("input")
require("render")

function love.load()

  -- Set window 
  love.window.setMode(1920, 1080)

  -- Add Systems
  AddSystem(SysInputFunc)
  AddSystem(SysPhysicsFunc)
  -- !!Implement way for components to auto generate

  -- Add Entities
  AddEntity("pla", {
    position = {x=200, y=10};
    size = {x=100, y=100};
    render = {drawable=nil, layer=1, color={.2, .6, .2}};
    collision = {weight = -1, future_pos = {x=200, y=10}}
  })
  AddEntity("player", {
    position = {x=10, y=29};
    size = {x=100, y=100};
    render = {drawable=nil, layer=1};
    movement = {direction = {x=0, y=0}, speed = 500};
    input = {};
    collision = {weight = 100, future_pos = {x=10, y=29}}
  })

  -- Commands
  AddCommand("move", CoMove)

  BindCommand("player", "w", KEY_STATE.DOWN, "move", {x=0,y=-1})
  BindCommand("player", "a", KEY_STATE.DOWN, "move", {x=-1,y=0})
  BindCommand("player", "s", KEY_STATE.DOWN, "move", {x=0,y=1})
  BindCommand("player", "d", KEY_STATE.DOWN, "move", {x=1,y=0})
end

function love.update(dt)
  UpdateSystems(dt)
end

function love.draw()
  UpdateRender()
end