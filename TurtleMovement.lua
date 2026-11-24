--x is forward y is left and right z is up and down 
local TurtleIO = require("IO")
local positionDataHandle = assert(io.open("aPositionData.txt", "w+"), "Failed to open file")
local fuelLevel = turtle.getFuelLevel()
local TurtleMovement = {}

TurtleMovement.orientation = {
    x = 1,
    y = 0
}

TurtleMovement.position = {
    x = 0,
    y = 0
}

function TurtleMovement.newCoord(x, y)
    return {
      x = x,
      y = y
    }
end

function TurtleMovement.subtractVec2(vec1, vec2)
    local result = {}
    result.x = vec1.x - vec2.x
    result.y = vec1.y - vec2.y
    return result
end

function TurtleMovement.addVec2(vec1, vec2)
    local result = {}
    result.x = vec1.x + vec2.x
    result.y = vec1.y + vec2.y
    return result
end

function TurtleMovement.multiplyVec2(vec1, vec2)
    local result = {}
    result.x = vec1.x * vec2.x
    result.y = vec1.y * vec2.y
    return result
end

function TurtleMovement.turnRight ()
    turtle.turnRight()
    TurtleMovement.orientation.x = TurtleMovement.orientation.y
    TurtleMovement.orientation.y = -TurtleMovement.orientation.x
end

function TurtleMovement.turnLeft ()
    turtle.turnRight()
    TurtleMovement.orientation.x = -TurtleMovement.orientation.y
    TurtleMovement.orientation.y = TurtleMovement.orientation.x
end

function TurtleMovement.moveForward(steps)
    steps = steps or 1
    print("Moving forward by "..steps)
    for i = 1, steps, 1 do
        if turtle.forward() then
            local offset = TurtleMovement.newCoord(1, 0)
            local transformedOffset = TurtleMovement.multiplyVec2(TurtleMovement.orientation, offset)
            TurtleMovement.position = TurtleMovement.addVec2(TurtleMovement.position, transformedOffset)
            TurtleIO.serializeTo(positionDataHandle, TurtleMovement.position)
        else
            return false
        end
    end
    return true
end

function TurtleMovement.moveBackward(steps)
    steps = steps or 1
    print("Moving backward by "..steps)
    for i = 1, steps, 1 do
        if turtle.back() then
            local offset = TurtleMovement.newCoord(-1, 0)
            local transformedOffset = TurtleMovement.multiplyVec2(TurtleMovement.orientation, offset)
            TurtleMovement.position = TurtleMovement.addVec2(TurtleMovement.position, transformedOffset)
            TurtleIO.serializeTo(positionDataHandle, TurtleMovement.position)
        else
            return false
        end
    end
    return true
end

function TurtleMovement.moveRight(steps)
    steps = steps or 1
    TurtleMovement.turnRight()
    print("Moving right by "..steps)
    for i = 1, steps, 1 do
        if TurtleMovement.moveForward() then
            TurtleMovement.turnLeft()
            return true
        end
        return false
    end
end

function TurtleMovement.moveLeft(steps)
    steps = steps or 1
    TurtleMovement.turnLeft()
    print("Moving left by "..steps)
    for i = 1, steps, 1 do
        if TurtleMovement.moveForward() then
            TurtleMovement.turnRight()
            return true
        end
        return false
    end
end

function TurtleMovement.moveTo(targetPos)
    local getX = TurtleIO.readFrom(positionDataHandle).x
    local getY = TurtleIO.readFrom(positionDataHandle).y

    local vector = TurtleMovement.subtractVec2(targetPos, {x=getX, y=getY})

    if vector.x > 0 then
        TurtleMovement.moveForward(vector.x)
    elseif vector.x < 0 then
        TurtleMovement.moveBackward(-vector.x)
    end

    if vector.y > 0 then
        TurtleMovement.moveRight(vector.y)
    elseif vector.y < 0 then
        TurtleMovement.moveLeft(-vector.y)
    end

end

local function followPath(path)
    for index, node in ipairs(path) do
        TurtleMovement.moveTo(node)
    end
end

TurtleIO.serializeTo(positionDataHandle, TurtleMovement.position)

return TurtleMovement