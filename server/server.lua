local RSGCore = exports['rsg-core']:GetCoreObject()

-- get players active horse
RSGCore.Functions.CreateCallback('rsg-horsetrainer:server:GetActiveHorse', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid=@citizenid AND active=@active', {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })
    if (result[1] ~= nil) then
        cb(result[1])
    else
        return
    end
end)

-- update horse xp
RegisterNetEvent('rsg-horsetrainer:server:updateXP', function(newxp, activehorse)
    local src = source
    if activehorse ~= nil then
        MySQL.update('UPDATE player_horses SET horsexp = ?  WHERE horseid = ? AND active = ?', {newxp, activehorse, 1})
        TriggerClientEvent('RSGCore:Notify', src, 'horse xp now '..newxp, 'success')
    end
end)