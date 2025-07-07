--! file: input.lua

require("registry")

-- Enum like, reference with .
KEY_STATE = {
  UP = 0;
  PRESSED = 1;
  DOWN = 2;
  RELEASED = 3;
}

local keys = {

}

local commands = {}

-- commands = {commandname = com()} to be able to save them 
-- Entities need component input = {key = {state = command(),..},..} where f() 
-- is a function that changes state or something if the key is pressed and 
-- keystates is a reference to the keys dir

function UpdateKey(key)
  if keys[key] == nil then
    keys[key] = KEY_STATE.UP
  end
  local current_bool = love.keyboard.isDown(key)
  local current_state = keys[key]

  if current_bool then
    if current_state == KEY_STATE.UP then
      keys[key] = KEY_STATE.PRESSED
    else
      keys[key] = KEY_STATE.DOWN
    end
  else
    if current_state == KEY_STATE.DOWN then
      keys[key] = KEY_STATE.RELEASED
    else
      keys[key] = KEY_STATE.UP
    end
  end
end

function SysInputFunc(dt)
  local updatablekeys = {
    "w", "a", "s", "d"
  }

  for i,v in pairs(updatablekeys) do
    UpdateKey(v)
  end

  local dir = View("input")
  -- every entity that has input
  for i,v in pairs(dir) do
    -- every key thats mapped
    for j,w in pairs(v["input"]) do
      -- every state command pair
      if w[GetKey(j)] ~= nil then
        w[GetKey(j)]()
      end
    end
  end
end

function GetKey(key)
  return keys[key]
end

function BindCommand(entityname, key, state, commandname, ...)
  local values = {...}
  local entity = GetEntity(entityname)
  if entity["input"][key] == nil then
    entity["input"][key] = {}
  end
  entity["input"][key][state] =
  function ()
    commands[commandname](entity, unpack(values))
  end
end

function AddCommand(name, command)
  commands[name] = command
end