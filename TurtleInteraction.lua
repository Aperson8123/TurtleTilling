local function pushToTop(inventoryPeripheral, itemName)
    local name = peripheral.getName(inventoryPeripheral)
    local size = inventoryPeripheral.size()
    for slot = 1, size, 1 do
        local itemDetail = inventoryPeripheral.getItemDetail(slot)
        if not itemDetail then

        elseif itemDetail.name == itemName then
            inventoryPeripheral.pushItems(name, slot, itemDetail.count, 1)
            return true
        end
    end
    print("Could not find item: "..itemName)
    return false
end

local function moveToEmpty(inventoryPeripheral, itemSlot, count)
    local name = peripheral.getName(inventoryPeripheral)
    local size = inventoryPeripheral.size()
    for slot = 1, size, 1 do
        local itemDetail = inventoryPeripheral.getItemDetail(slot)
        if itemDetail == nil then
            inventoryPeripheral.pushItems(name, itemSlot, nil, slot)
            return true
        end
    end
    print("Could not find empty slot")
    return false
end

local function getItem(inventoryPeripheral, itemName, count)
    count = count or 64

    local name = peripheral.getName(inventoryPeripheral)
    local size = inventoryPeripheral.size()
    local items = inventoryPeripheral.list()
    local itemDetail = inventoryPeripheral.getItemDetail(1)

    if itemDetail == nil then
        print("First slot is empty")
        pushToTop(inventoryPeripheral, itemName)
    elseif itemDetail.name ~= itemName then
        moveToEmpty(inventoryPeripheral, 1)
        pushToTop(inventoryPeripheral, itemName)
    else
        print("First slot already has desired item")
    end
    turtle.suck(count)
end

return {getItem = getItem}