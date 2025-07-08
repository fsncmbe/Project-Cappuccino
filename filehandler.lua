--! file: filehandler.lua

require("registry")
local json = require("json")

-- returns json as table
function ReadJson(path)
    local file = io.open(path, "r")
    local content = ""
    if file then
        content = file:read("*a")
        file:close()
    else
        print("Failed to load " .. path)
    end

    return json.decode(content)
end