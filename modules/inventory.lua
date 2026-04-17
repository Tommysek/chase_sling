local playerState

local function initPlayerState()
    playerState = LocalPlayer.state
    print('[Sling] playerState initialized')
end

AddEventHandler('playerActivated', initPlayerState)
AddEventHandler('QBCore:Client:OnPlayerLoaded', initPlayerState)
AddEventHandler('qbx_core:playerLoaded', initPlayerState)

CreateThread(function()
    while not playerState do
        if LocalPlayer and LocalPlayer.state then
            initPlayerState()
        end
        Wait(500)
    end
end)

local function getHotbarItems(inventory)
    local items = {}
    local count = 0
    local ped = PlayerPedId()
    local _, heldHash = GetCurrentPedWeapon(ped, true)

    for slot = 1, 5 do
        local item = inventory[slot]
        if item and item.name then
            local name = item.name:lower()
            if WeaponsConfig[name] then
                local hash = joaat(name)
                if hash ~= heldHash then
                    count += 1
                    items[count] = Utils.formatData(item, WeaponsConfig[name])
                end
            end
        end
    end

    return items
end

local function broadcastWeapons(inventory)
    if not playerState then
        print('[Sling] broadcastWeapons: playerState is nil!')
        return
    end
    local items = getHotbarItems(inventory)
    print('[Sling] broadcasting weapons_carry count=' .. tostring(#items))
    playerState:set('weapons_carry', items, true)
end

AddEventHandler('ox_inventory:currentWeapon', function()
    Wait(200)
    local items = exports.ox_inventory:GetPlayerItems() or {}
    broadcastWeapons(items)
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
                broadcastWeapons(items)
            end
        end
    end
end)

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if not changes then return end
    local items = exports.ox_inventory:GetPlayerItems() or {}
    broadcastWeapons(items)
    CarryModule.updateCarryState(items)
end)

AddEventHandler('playerActivated', function()
    Wait(500)
    local items = exports.ox_inventory:GetPlayerItems() or {}
    broadcastWeapons(items)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if playerState then
            playerState:set('weapons_carry', nil, true)
        end
    end
end)