--! file: physics.lua

require("core")

-- small implementation of movement, collision and other checks
-- movement, collision need : position, size

-- movement = {direction = {x, y}, speed = 0}

-- collision component is needed if you want to collide:
-- collision = {weight = 100, future = {x, y}}

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
        entity["collision"]["future"] = {x = position.x, y = position.y}
    else
        entity["position"] = position
    end

    -- reset all now
    entity["movement"]["direction"] = {x=0, y=0}
    return true
end

function CheckCollisionAndMove(move_dir, col_dir)
    for _, moving in pairs(move_dir) do
        for _, other in pairs(col_dir) do
            if moving ~= other and CheckOverlap(moving, other) then

                local savefuture = {x=moving["collision"]["future"]["x"], y=moving["collision"]["future"]["y"]}

                -- reset y to test x in isolation
                moving["collision"]["future"]["y"] = moving["position"]["y"]

                if CheckOverlap(moving, other) then
                    MoveClose(moving, other, "x")
                end

                -- check y by reversing x
                moving["collision"]["future"]["y"] = savefuture["y"]

                if CheckOverlap(moving, other) then
                    MoveClose(moving, other, "y")
                end
            end
        end
        MoveToFuture(moving)
    end
end

function MoveToFuture(ent1)
    ent1["position"] = {x=ent1["collision"]["future"]["x"], y=ent1["collision"]["future"]["y"]}
end

function MoveClose(ent1, ent2, dir)
    local one = AddVectors(ent1["collision"]["future"], ScalVector(ent1["size"], 0.5))
    local two = AddVectors(ent2["collision"]["future"], ScalVector(ent2["size"], 0.5))
    local distance = SubVectors(one, two)
    local direction = SignVector(distance)
    local overlap = SubVectors(ScalVector(AddVectors(ent1["size"], ent2["size"]), 0.5), FuncVector(distance, math.abs))

    if overlap.x <= 0 or overlap.y <= 0 then
        return
    end

    ent1["collision"]["future"][dir] = ent1["collision"]["future"][dir] + overlap[dir] * direction[dir]
end

function CheckOverlap(ent1, ent2)
    local ent1fut = ent1["collision"]["future"]
    local ent2fut = ent2["collision"]["future"]
    local coll_x = ent1fut["x"] + ent1["size"]["x"] > ent2fut["x"] and ent2fut["x"] + ent2["size"]["x"] > ent1fut["x"]
    local coll_y = ent1fut["y"] + ent1["size"]["y"] > ent2fut["y"] and ent2fut["y"] + ent2["size"]["y"] > ent1fut["y"]

    return (coll_x and coll_y)
end

-- implement functionality for knockback when its needed in the future here!
-- something like overwrite movedirection 

function SysPhysicsFunc(dt)
    local dir = View("movement")
    local col_dir = View("collision")
    local move_dir = {}
    for _,v in pairs(dir) do
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
    table.sort(move_dir, function (a, b) return SortBy(a, b, "collision", "future", "x") end)
    table.sort(col_dir, function (a, b) return SortBy(a, b, "collision", "future", "x") end)

    CheckCollisionAndMove(move_dir, col_dir)
end