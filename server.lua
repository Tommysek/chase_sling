AddEventHandler('playerSpawned', function()
    local src = source
    local stateBag = ('player:%s'):format(src)
    SetStateBagValue(stateBag, 'weapons_carry', json.encode({}), #json.encode({}), true)
    SetStateBagValue(stateBag, 'carry_items', json.encode({}), #json.encode({}), true)
end)

AddEventHandler('playerDropped', function()
    local src = source
    TriggerClientEvent('onPlayerDropped', -1, src)
end)
