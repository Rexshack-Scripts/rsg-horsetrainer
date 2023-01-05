local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false
local walking = false
local leading = false
local playerjob = nil
local cleancooldownSecondsRemaining = 0
local feedcooldownSecondsRemaining = 0

-------------------------------------------------------------------------------

-- leading horse for xp
CreateThread(function()
	if LocalPlayer.state['isLoggedIn'] then
		local playerjob = RSGCore.Functions.GetPlayerData().job.name
		while true do
			Wait(1000)
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
					print('xp increase trigger')
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
                RSGCore.Functions.Notify('horse trainer brush needed for this', 'error')
            end
        else
            RSGCore.Functions.Notify('you are not a horse trainer!', 'error')
        end
    else
        RSGCore.Functions.Notify('horse is too clean right now!', 'error')
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
                RSGCore.Functions.Notify('carrot needed for this', 'error')
            end
        else
            RSGCore.Functions.Notify('you are not a horse trainer!', 'error')
        end
    else
        RSGCore.Functions.Notify('horse is too full right now!', 'error')
    end
end)

-------------------------------------------------------------------------------

-- cleaning cooldown timer
function handlecleanCooldown()
    cleancooldownSecondsRemaining = (Config.HorseCleanCooldown * 60 * 1000)
    Citizen.CreateThread(function()
        while cleancooldownSecondsRemaining > 0 do
            Wait(1000)
            cleancooldownSecondsRemaining = cleancooldownSecondsRemaining - 1
        end
    end)
end

-- feeding cooldown timer
function handlefeedCooldown()
    feedcooldownSecondsRemaining = (Config.HorseFeedCooldown * 60 * 1000)
    Citizen.CreateThread(function()
        while feedcooldownSecondsRemaining > 0 do
            Wait(1000)
            feedcooldownSecondsRemaining = feedcooldownSecondsRemaining - 1
        end
    end)
end

-------------------------------------------------------------------------------
