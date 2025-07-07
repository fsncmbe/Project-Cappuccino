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

  if current_bool == true then
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
  local dir = View("input")
  
end