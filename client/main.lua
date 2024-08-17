local ESX = nil
local isFlitsmeisterOn = true
local lastNotificationTime = 0

-- Fetch the ESX shared object
Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(500) -- Wait for ESX to be fetched
end)

-- Show blips on the map
function CreateBlips()
    if Config.ShowBlips then
        for _, camera in ipairs(Config.MobileCameras) do
            local blip = AddBlipForCoord(camera.x, camera.y, camera.z)
            SetBlipSprite(blip, 1) -- Red dot
            SetBlipColour(blip, 1) -- Red color
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Mobile Camera")
            EndTextCommandSetBlipName(blip)
        end

        for _, camera in ipairs(Config.FixedCameras) do
            local blip = AddBlipForCoord(camera.x, camera.y, camera.z)
            SetBlipSprite(blip, 1) -- Red dot
            SetBlipColour(blip, 1) -- Red color
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Fixed Camera")
            EndTextCommandSetBlipName(blip)
        end
    end
end

-- Notify player if speeding
function NotifyPlayer(title, message)
    local currentTime = GetGameTimer()
    if isFlitsmeisterOn and (currentTime - lastNotificationTime) >= Config.SpeedingNotificationCooldown * 1000 then
        TriggerEvent('esx:showNotification', message)
        lastNotificationTime = currentTime
    end
end

-- Check speed and send notifications
Citizen.CreateThread(function()
    CreateBlips()
    
    while true do
        Citizen.Wait(500) -- Check every half a second
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and vehicle ~= 0 and isFlitsmeisterOn then
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h
            if speed > Config.SpeedLimit then
                local speedExcess = speed - Config.SpeedLimit
                local message = string.format(
                    "~y~Flitsmeister~s~\n~r~Speeding Alert!~s~\nYou are driving at ~o~%.2f km/h~s~, which is ~r~%.2f km/h over the speed limit~s~.\n\n~g~Current Speed: ~o~%.2f km/h\n~g~Speed Limit: ~r~%d km/h",
                    speed, speedExcess, speed, Config.SpeedLimit
                )
                NotifyPlayer("Flitsmeister Speeding Alert", message)
                TriggerServerEvent('flitsmeister:sendSpeedingLog')
            end
        end
    end
end)

-- Open ESX Menu with Flitsmeister options
function OpenFlitsmeisterMenu()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'flitsmeister_menu',
        {
            title = 'Flitsmeister Settings',
            align = 'top-left',
            elements = {
                { label = 'Turn On', value = 'turn_on' },
                { label = 'Turn Off', value = 'turn_off' },
                { label = 'Check Speed Limit', value = 'check_speed_limit' },
                { label = 'Set Speed Limit', value = 'set_speed_limit' }
            }
        },
        function(data, menu)
            if data.current.value == 'turn_on' then
                isFlitsmeisterOn = true
                TriggerEvent('esx:showNotification', "Flitsmeister notifications are now ~g~ON~s~.")
            elseif data.current.value == 'turn_off' then
                isFlitsmeisterOn = false
                TriggerEvent('esx:showNotification', "Flitsmeister notifications are now ~r~OFF~s~.")
            elseif data.current.value == 'check_speed_limit' then
                TriggerEvent('esx:showNotification', "Current speed limit is ~r~" .. Config.SpeedLimit .. " km/h~s~.")
            elseif data.current.value == 'set_speed_limit' then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'set_speed_limit_menu',
                    {
                        title = 'Enter New Speed Limit (km/h)'
                    },
                    function(data2, menu2)
                        local newLimit = tonumber(data2.value)
                        if newLimit and newLimit > 0 then
                            Config.SpeedLimit = newLimit
                            TriggerEvent('esx:showNotification', "Speed limit updated to ~r~" .. newLimit .. " km/h~s~.")
                            menu2.close()
                        else
                            TriggerEvent('esx:showNotification', "~r~Invalid input. Please enter a positive number.")
                        end
                    end,
                    function(data2, menu2)
                        menu2.close()
                    end
                )
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

-- Command to open Flitsmeister menu
RegisterCommand('flits', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        OpenFlitsmeisterMenu()
    else
        TriggerEvent('esx:showNotification', "You must be in a vehicle to use this command.")
    end
end, false)
