local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false
local walking = false
local leading = false
local playerjob = nil
local cleancooldownSecondsRemaining = 0
local feedcooldownSecondsRemaining = 0

-------------------------------------------------------------------------------

AddEventHandler('RSGCore:Client:OnPlayerLoaded', function() -- Don't use this with the native method
    isLoggedIn = true
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function() -- Don't use this with the native method
    isLoggedIn = false
end)

-------------------------------------------------------------------------------

-- cleaning cooldown timer
function handlecleanCooldown()
    cleancooldownSecondsRemaining = (Config.HorseCleanCooldown * 60)
    Citizen.CreateThread(function()
        while cleancooldownSecondsRemaining > 0 do
            Wait(1000)
            cleancooldownSecondsRemaining = cleancooldownSecondsRemaining - 1
            if Config.Debug == true then
                print(cleancooldownSecondsRemaining)
            end
        end
    end)
end

-- feeding cooldown timer
function handlefeedCooldown()
    feedcooldownSecondsRemaining = (Config.HorseFeedCooldown * 60)
    Citizen.CreateThread(function()
        while feedcooldownSecondsRemaining > 0 do
            Wait(1000)
            feedcooldownSecondsRemaining = feedcooldownSecondsRemaining - 1
            if Config.Debug == true then
                print(feedcooldownSecondsRemaining)
            end
        end
    end)
end

-------------------------------------------------------------------------------

-- leading horse for xp
CreateThread(function()
    while true do
        Wait(1000)
        if LocalPlayer.state['isLoggedIn'] then
            local playerjob = RSGCore.Functions.GetPlayerData().job.name
            if playerjob == 'horsetrainer' then
                if Citizen.InvokeNative(0xDE4C184B2B9B071A, PlayerPedId()) then    -- walking
                    walking = true
                else
                    walking = false
                end
                if Citizen.InvokeNative(0xEFC4303DDC6E60D3, PlayerPedId()) then -- leading
                    leading = true
                else
                    leading = false
                end
                if walking == true and leading == true then
                    Wait(Config.LeadingXpTime)
                    TriggerServerEvent('rsg-horsetrainer:server:updatexp', 'leading')
                end
            end
        end
    end
end)

-------------------------------------------------------------------------------

-- brush horse for xp
RegisterNetEvent('rsg-horsetrainer:client:brushHorse',function(item)
    local playerjob = RSGCore.Functions.GetPlayerData().job.name
    if cleancooldownSecondsRemaining == 0 then
        if playerjob == 'horsetrainer' then
            local hasItem = RSGCore.Functions.HasItem('horsetrainingbrush', 1)
            if hasItem then
                local horsePed = Citizen.InvokeNative(0xE7E11B8DCBED1058, PlayerPedId())
                Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), horsePed, `INTERACTION_BRUSH`, 0, 0)
                Wait(8000)
                Citizen.InvokeNative(0xE3144B932DFDFF65, horsePed, 0.0, -1, 1, 1)
                ClearPedEnvDirt(horsePed)
                ClearPedDamageDecalByZone(horsePed, 10, "ALL")
                ClearPedBloodDamage(horsePed)
                PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                TriggerServerEvent('rsg-horsetrainer:server:updatexp', 'cleaning')
                handlecleanCooldown()
            else
                RSGCore.Functions.Notify(Lang:t('error.horse_brush_needed'), 'error')
            end
        else
            RSGCore.Functions.Notify(Lang:t('error.not_horse_trainer'), 'error')
        end
    else
        RSGCore.Functions.Notify(Lang:t('error.horse_too_clean'), 'error')
    end
end)

-------------------------------------------------------------------------------

-- feed horse for xp
RegisterNetEvent('rsg-horsetrainer:client:feedHorse',function(item)
    local playerjob = RSGCore.Functions.GetPlayerData().job.name
    if feedcooldownSecondsRemaining == 0 then
        if playerjob == 'horsetrainer' then
            local hasItem = RSGCore.Functions.HasItem(item, 1)
            if hasItem then
                local horsePed = Citizen.InvokeNative(0xE7E11B8DCBED1058, PlayerPedId())
                Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), horsePed, -224471938, 0, 0)
                Wait(5000)
                TriggerServerEvent('rsg-horsetrainer:server:updatexp', 'feeding')
                TriggerServerEvent('rsg-horsetrainer:server:deleteItem', item, 1)
                handlefeedCooldown()
            else
                RSGCore.Functions.Notify(Lang:t('error.carrot_needed'), 'error')
            end
        else
            RSGCore.Functions.Notify(Lang:t('error.not_horse_trainer'), 'error')
        end
    else
        RSGCore.Functions.Notify(Lang:t('error.horse_too_full'), 'error')
    end
end)

