--! file: main.lua
-- Linux:   love /home/cmbe/GitHub/Project-Cappuccino
-- Windows: & 'C:\Program Files\LOVE\love.exe' .

require("registry")
require("physics")
require("input")
require("render")
require("filehandler")

function love.load()

  -- Set window 
  love.window.setMode(1920, 1080)

  -- Add Systems
  AddSystem(SysInputFunc)
  AddSystem(SysPhysicsFunc)

  -- Reg Components
  LoadComponentsFromFile("assets/entity/components.json")

  -- Entities
  LoadEntityFromFile("player", "assets/entity/player.json")
  LoadEntityFromFile("bat", "assets/entity/enemy.json")
  
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