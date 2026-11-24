local TurtleMovement = require("TurtleMovement")
local args = {...}

-- local function hoe(width, height)
--     for y = 1, height, 1 do
--         for x = 1, width, 1 do
--             local target = TurtleMovement.newCoord(x, y)
--             TurtleMovement.moveTo(target)
--             if turtle.detectDown() == false then
--                 TurtleMovement.moveDown()
--             else
--                 turtle.dig()
--             end
--         end
--     end

-- end

local function hoe(width, height)
    while true do
        local predictedPos = TurtleMovement.addVec2(
            TurtleMovement.multiplyVec2(TurtleMovement.orientation, TurtleMovement.newCoord(1, 0)),
            TurtleMovement.position
        )
        local forward = TurtleMovement.moveForward()
        if forward == false and turtle.detect() then
            repeat
                TurtleMovement.turnRight()
            until TurtleMovement.moveForward()
        elseif turtle.detect() == false then
            turtle.dig("right")
        end
    end
end

hoe(args[1], args[2])