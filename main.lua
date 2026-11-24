local TurtleMovement = require("TurtleMovement")
local args = {...}

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