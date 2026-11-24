-- local file = assert(io.open("PositionData.txt", "w+"), "Failed to open file")
-- local out = assert(io.open("Out.txt", "w"), "Failed to open file")

local function serializeTo(handle, obj, indentCount)
    local t = type(obj)
    local indentation = ""
    indentCount = indentCount or 0

    for i = 1, indentCount, 1 do
        indentation = indentation .. "\t"
    end

    if t == "number" then
        handle:write(indentation .. tostring(obj))
    elseif t == "string" then
        handle:write(indentation .. string.format("%q", obj))
    elseif t == "table" then
        handle:write("{\n")
        for key, value in pairs(obj) do
            handle:write(indentation .. key .. " = ")

            if type(value) == "table" then
                serializeTo(handle, value, indentCount+1)
            else
                serializeTo(handle, value, 0)
            end

            handle:write("\n")
        end
        handle:write(indentation.."}")
    else
        print("Cannot serialize " .. t)
    end
end

local function readFrom(handle)
    if type(handle) ~= "userdata" then
        print("Tried reading from non file type " .. type(handle))
        return false
    end

    local str = handle:read("*all")

    str = str:gsub(" ", "")
    str = str:gsub("\t", "")
    str = str:gsub("\n", "")
    str = str:gsub("=%w", "%0,")
    str = str:gsub("}", "},")
    str = str:gsub(",}", "}")
    str = str:sub(1, #str-1)
    str = "return "..str

    print(load(str))

    return load(str)()
end

-- serializeTo(file, {x = 0, y = 2, t = {a = 0, b = 3, lt = {g = 2, y = 1}}}, 0)
-- serializeTo(file, {x = 0, y = 2, z={a = 3, b = 8}})
-- serializeTo(file, {x=1, y=2})
-- file:seek("set", 0)
-- local tab = readFrom(file)
-- serializeTo(out, tab)
-- file:close()
-- local first = str:sub(index+1, index+1)
-- if first ~= "{" and first ~= "}" then

return {serializeTo = serializeTo, readFrom = readFrom}