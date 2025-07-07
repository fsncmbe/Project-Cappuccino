--! file: physics.lua

require("core")

-- small implementation of movement, collision and other checks
-- movement, collision need : position, size

-- movement = {direction = {x, y}, speed = 0}

-- collision component is needed if you want to collide:
-- collision = {weight = 100, future_pos = {x, y}}

-- if an entity has collision but not movement, it is treated like terrain, immovable

--direction should be {x=1, y=0} for right for example
function CoMove(entity, direction)
    if entity["position"] ~= nil and entity["movement"] ~= nil then
        local entdir = entity["movement"]["direction"]
        entdir["x"] = entdir["x"] + direction["x"]
        entdir["y"] = entdir["y"] + direction["y"]
    end
end

-- called before collision checks if entity has collision, if not update instantly
function UpdatePos(entity, dt)
    local direction = Normalize(entity["movement"]["direction"])
    direction = MulVectors(direction, MakeVector(entity["movement"]["speed"]))
    direction = MulVectors(direction, MakeVector(dt))

    if LenVector(direction) == 0 then
        return false
    end

    local position = AddVectors(entity["position"], direction)
    -- if the entity has collision component, it first needs to check with every other collision
    -- component for possible collisions

    if HasComponent(entity, "collision") then
        entity["collision"]["future_pos"] = position
    else
        entity["position"] = position
    end

    -- reset all now
    entity["movement"]["direction"] = {x=0, y=0}
    return true
end

function CheckCollisionAndMove(move_dir, col_dir)
    local hadtomove = false
    local out = {}
    for i=1,#move_dir do
        hadtomove = false
        for j=1,#col_dir do
            if move_dir[i] ~= col_dir[j] then
                if CheckOverlap(move_dir[i], col_dir[j]) then
                    ResolveOverlap(move_dir[i], col_dir[j])
                    hadtomove = true
                end
            end
        end
        if hadtomove then
            table.insert(out, move_dir[i])
        else
            MoveToFuturePos(move_dir[i])
        end
    end
    if #out > 0 then
        CheckCollisionAndMove(out, col_dir)
    end
end

function CheckOverlap(ent1, ent2)
    -- if first 1x+1size > 2x and if 2x+2size > 1pos
    -- and ent2["position"]["x"] + ent2["size"]["x"] > ent1["position"]["x"]
    local ent1fut = ent1["collision"]["future_pos"]
    local ent2fut = ent2["collision"]["future_pos"]
    local coll_x = ent1fut["x"] + ent1["size"]["x"] > ent2fut["x"] and ent2fut["x"] + ent2["size"]["x"] > ent1fut["x"]
    local coll_y = ent1fut["y"] + ent1["size"]["y"] > ent2["position"]["y"] and ent2fut["y"] + ent2["size"]["y"] > ent1fut["y"]

    return (coll_x and coll_y)
end

-- Always works from left to right, sorting the positions beforehand is very important!!
function ResolveOverlap(ent1, ent2)
    local oldpos1 = ent1["position"]
    local oldpos2 = ent2["position"]

    local newpos1 = ent1["collision"]["future_pos"]
    local newpos2 = ent2["collision"]["future_pos"]

    local distx = (newpos1["x"] + ent1["size"]["x"] / 2) - (newpos2["x"] + ent2["size"]["x"]/2)
    local disty = (newpos1["y"] + ent1["size"]["y"] / 2) - (newpos2["y"] + ent2["size"]["y"]/2)

    local overlapx = (ent1["size"]["x"] + ent2["size"]["x"]) / 2 - math.abs(distx)
    local overlapy = (ent1["size"]["y"] + ent2["size"]["y"]) / 2 - math.abs(disty)

    if overlapx <= 0 or overlapy <= 0 then
        return
    end

    if ent2["collision"]["weight"] == -1 then
        local newx = 0
        local newy = 0

        if overlapx < overlapy then
            if distx > 0 then
                newx = newpos2["x"] + ent2["size"]["x"]
            else
                newx = newpos2["x"] - ent1["size"]["x"]
            end
        else
            if disty > 0 then
                newy = newpos2["y"] + ent2["size"]["y"]
            else
                newy = newpos2["y"] - ent1["size"]["y"]
                
            end
        end

        if newx == 0 then
            newx = newy / oldpos1["y"] * oldpos1["x"]
        end
        if newy == 0 then
            newy = newx / oldpos1["x"] * oldpos1["y"]
        end
        ent1["collision"]["future_pos"] = {x = newx, y=newy}
    end

end

function MoveToFuturePos(ent1)
    ent1["position"] = ent1["collision"]["future_pos"]
end

-- implement functionality for knockback when its needed in the future here!
-- something like overwrite movedirection 

function SysPhysicsFunc(dt)
    local dir = View("movement")
    local col_dir = View("collision")
    local move_dir = {}
    for i,v in pairs(dir) do
        -- if position of entity has changed, check if its a collision type and add to col_dir
        if UpdatePos(v, dt) then
            if HasComponent(v, "collision")then
                table.insert(move_dir, v)
            end
        end
    end

    if next(move_dir) == nil then
        return
    end
    -- Sort both by x
    table.sort(move_dir, function (a, b) return SortBy(a, b, "collision", "future_pos", "x") end)
    table.sort(col_dir, function (a, b) return SortBy(a, b, "collision", "future_pos", "x") end)

    CheckCollisionAndMove(move_dir, col_dir)
end