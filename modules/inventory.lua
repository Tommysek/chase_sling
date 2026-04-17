local attached = {}

local function getPlayerSlot(weaponName)
    local cfg = WeaponsConfig[weaponName]
    if not cfg then return nil end
    return Utils.findOpenSlot(cfg.slot)
end

local function attachWeapon(weaponName, ped)
    if attached[weaponName] then return end
    local slot = getPlayerSlot(weaponName)
    if not slot then return end

    local hash = joaat(weaponName)
    RequestWeaponAsset(hash, 31, 0)
    local timeout = GetGameTimer() + 5000
    while not HasWeaponAssetLoaded(hash) and GetGameTimer() < timeout do
        Wait(10)
    end
    local obj = CreateWeaponObject(hash, 0, 0.0, 0.0, 0.0, true, 1.0, 0, false, true)
    if not obj or obj == 0 then return end

    local boneIndex = GetPedBoneIndex(ped, slot.bone)
    AttachEntityToEntity(obj, ped, boneIndex,
        slot.pos.x, slot.pos.y, slot.pos.z,
        slot.rot.x, slot.rot.y, slot.rot.z,
        true, true, false, false, 2, true)
    SetEntityCompletelyDisableCollision(obj, false, true)
    RemoveWeaponAsset(hash)
    attached[weaponName] = obj
end

local function detachWeapon(weaponName)
    local obj = attached[weaponName]
    if obj and DoesEntityExist(obj) then
        DeleteObject(obj)
    end
    attached[weaponName] = nil
end

local function detachAll()
    for name, _ in pairs(attached) do
        detachWeapon(name)
    end
    if Utils then Utils.resetSlots() end
end

local function updateAttached(inventory)
    local ped = PlayerPedId()
    local _, heldHash = GetCurrentPedWeapon(ped, true)
    Utils.resetSlots()

    local present = {}
    for slot = 1, 5 do
        local item = inventory[slot]
        if item and item.name then
            local name = item.name:lower()
            if WeaponsConfig[name] then
                local hash = joaat(name)
                if hash ~= heldHash then
                    present[name] = true
                    attachWeapon(name, ped)
                end
            end
        end
    end

    for name, _ in pairs(attached) do
        if not present[name] then
            detachWeapon(name)
        end
    end
end

AddEventHandler('ox_inventory:currentWeapon', function()
    Wait(200)
    local items = exports.ox_inventory:GetPlayerItems() or {}
    updateAttached(items)
end)

CreateThread(function()
    local lastWeaponHash = 0
    while true do
        Wait(300)
        local ped = PlayerPedId()
        if ped and ped ~= 0 then
            local _, hash = GetCurrentPedWeapon(ped, true)
            if hash ~= lastWeaponHash then
                lastWeaponHash = hash
                local items = exports.ox_inventory:GetPlayerItems() or {}
                updateAttached(items)
            end
        end
    end
end)

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if not changes then return end
    local items = exports.ox_inventory:GetPlayerItems() or {}
    updateAttached(items)
    CarryModule.updateCarryState(items)
end)

AddEventHandler('playerActivated', function()
    Wait(500)
    local items = exports.ox_inventory:GetPlayerItems() or {}
    updateAttached(items)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        detachAll()
    end
end)