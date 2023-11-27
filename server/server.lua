local RSGCore = exports['rsg-core']:GetCoreObject()
local horsename = nil
local horsexp = 0
local newxp = 0
local horseid = nil

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-horsetrainer/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

-- use horse trainer brush
RSGCore.Functions.CreateUseableItem("horsetrainingbrush", function(source, item)
    local src = source

    TriggerClientEvent('rsg-horsetrainer:client:brushHorse', src, item.name)
end)

-- use horse trainer carrot
RSGCore.Functions.CreateUseableItem("horsetrainingcarrot", function(source, item)
    local src = source

    TriggerClientEvent('rsg-horsetrainer:client:feedHorse', src, item.name)
end)

-----------------------------------------------------------------------------------

RegisterNetEvent('rsg-horsetrainer:server:updatexp',function(action)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local expRiding = Config.RidingXpIncreaseTrainer

    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid = @citizenid AND active = @active',
    {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })

    if result[1] then
        horsename = result[1].name
        horseid = result[1].horseid
        horsexp = result[1].horsexp
    end

    if action == 'riding' and horsexp <= Config.FullyTrained then
        newxp = horsexp + expRiding

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        return
    end

    if action == 'leading' and horsexp <= Config.FullyTrained then
        newxp = horsexp + Config.LeadingXpIncrease

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        if Config.TrainingEXPNotification then
            TriggerClientEvent('RSGCore:Notify', src, horsename..'\'s'..Lang:t('success.xp_now')..newxp, 'success')
        end

        return
    end

    if action == 'cleaning' and horsexp <= Config.FullyTrained then
        newxp = horsexp + Config.CleaningXpIncrease

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        if Config.TrainingEXPNotification then
            TriggerClientEvent('RSGCore:Notify', src, horsename..'\'s'..Lang:t('success.xp_now')..newxp, 'success')
        end

        return
    end

    if action == 'feeding' and horsexp <= Config.FullyTrained then
        newxp = horsexp + Config.FeedingXpIncrease

        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})

        if Config.TrainingEXPNotification then
            TriggerClientEvent('RSGCore:Notify', src, horsename..'\'s'..Lang:t('success.xp_now')..newxp, 'success')
        end

        return
    end
end)

-----------------------------------------------------------------------------
-- horse xp token use
-----------------------------------------------------------------------------

RSGCore.Functions.CreateUseableItem("horsexp5", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp10", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp25", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp50", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:tokenupdatexp', src, item.name)
end)

RSGCore.Functions.CreateUseableItem("horsexp100", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:tokenupdatexp', src, item.name)
end)

-----------------------------------------------------------------------------

RegisterNetEvent('rsg-horsetrainer:server:tokenupdatexp',function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid

    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid = @citizenid AND active = @active',
    {
        ['@citizenid'] = cid,
        ['@active'] = 1
    })

    if result[1] then
        horsename = result[1].name
        horseid = result[1].horseid
        horsexp = result[1].horsexp
    end

    if horsexp >= Config.FullyTrained then
        TriggerClientEvent('ox_lib:notify', src, {title = 'Horse Fully Trained', description = 'your horse is fully trained', type = 'inform', 5000 })
        return
    end

    if amount == 5 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 5
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp5', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp5'], "remove")
        TriggerClientEvent('ox_lib:notify', src, {title = 'Horse XP Updated', description = 'your horse XP is now '..newxp, type = 'inform', 5000 })
        return
    end

    if amount == 10 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 10
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp10', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp10'], "remove")
        TriggerClientEvent('ox_lib:notify', src, {title = 'Horse XP Updated', description = 'your horse XP is now '..newxp, type = 'inform', 5000 })
        return
    end

    if amount == 25 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 25
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp25', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp25'], "remove")
        TriggerClientEvent('ox_lib:notify', src, {title = 'Horse XP Updated', description = 'your horse XP is now '..newxp, type = 'inform', 5000 })
        return
    end

    if amount == 50 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 50
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp50', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp50'], "remove")
        TriggerClientEvent('ox_lib:notify', src, {title = 'Horse XP Updated', description = 'your horse XP is now '..newxp, type = 'inform', 5000 })
        return
    end

    if amount == 100 and horsexp <= Config.FullyTrained then
        newxp = horsexp + 100
        MySQL.update('UPDATE player_horses SET horsexp = ? WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
        Player.Functions.RemoveItem('horsexp100', 1)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['horsexp100'], "remove")
        TriggerClientEvent('ox_lib:notify', src, {title = 'Horse XP Updated', description = 'your horse XP is now '..newxp, type = 'inform', 5000 })
        return
    end

end)

-----------------------------------------------------------------------------------

-- remove item
RegisterNetEvent('rsg-horsetrainer:server:deleteItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "remove")
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()

