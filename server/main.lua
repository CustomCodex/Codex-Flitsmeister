ESX = nil

-- Initialize ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Event to handle speed checks from the client
RegisterNetEvent('flitsmeister:checkSpeed')
AddEventHandler('flitsmeister:checkSpeed', function(speed)
    print(('Player speed: %s km/h'):format(speed))
end)

-- Event to handle camera position updates (if needed in the future)
RegisterNetEvent('flitsmeister:updateCameras')
AddEventHandler('flitsmeister:updateCameras', function(cameraData)
    print('Received camera data:', json.encode(cameraData))
end)

-- Event to send speeding logs to the webhook
RegisterServerEvent('flitsmeister:sendSpeedingLog')
AddEventHandler('flitsmeister:sendSpeedingLog', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h

        -- Use a consistent color for the webhook log
        local color = 7506394 -- Light orange color
        local currentTime = os.date("%Y-%m-%d %H:%M:%S")

        -- Format the message to be sent to the webhook
        local message = {
            {
                ["color"] = color,
                ["title"] = "🚨 Flitsmeister Speeding Log 🚨",
                ["description"] = string.format(
                    "**Player**: %s\n**Speed**: %.2f km/h\n**Coordinates**: [%.2f, %.2f, %.2f]\n**Time**: %s\n**Additional Info**: Speeding event detected. Immediate attention might be required to address potential fines.",
                    xPlayer.getName(), speed, coords.x, coords.y, coords.z, currentTime
                ),
                ["footer"] = {
                    ["text"] = "Flitsmeister - Speeding Detection System"
                }
            }
        }

        -- Send the message to the webhook
        local webhookURL = Config.WebhookURL
        PerformHttpRequest(webhookURL, function(err, text, headers)
            if err ~= 200 then
                print(('Failed to send webhook: %d'):format(err))
            end
        end, 'POST', json.encode({ username = "Flitsmeister", embeds = message }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Command to toggle Flitsmeister settings
RegisterCommand('flits', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('esx:showNotification', source, 'You can now access the Flitsmeister menu.')
    else
        print('Player not found')
    end
end, false)

-- Function to handle player joining (could be used for setting default settings)
AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    deferrals.defer()
    deferrals.update('Loading Flitsmeister settings...')
    -- Add logic here if needed for player-specific settings
    deferrals.done()
end)


-- Log that the Black Market System has successfully started
print("\27[32mCodex-Flitsmeister has successfully started\27[0m")
