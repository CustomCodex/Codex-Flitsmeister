Config = {}

-- ASCII Art for Custom Code
Config.CustomCodeArt = [[
   ___              _                        ___             _             
  / __\ _   _  ___ | |_   ___   _ __ ___    / __\  ___    __| |  ___ __  __
 / /   | | | |/ __|| __| / _ \ | '_ ` _ \  / /    / _ \  / _` | / _ \\ \/ /
/ /___ | |_| |\__ \| |_ | (_) || | | | | |/ /___ | (_) || (_| ||  __/ >  < 
\____/  \__,_||___/ \__| \___/ |_| |_| |_|\____/  \___/  \__,_| \___|/_/\_\
]]

-- Function to Print the Custom Code Art
function printCustomCodeArt()
    print(Config.CustomCodeArt)
end

-- Call the function to display the ASCII art
printCustomCodeArt()

-- Display GitHub Link
print("Visit us at: https://github.com/CustomCodex")

-- General settings
Config.WarnDistance = 120 -- Distance to warn players about the camera
Config.SpeedLimit = 120 -- Speed limit for the speed check in km/h
Config.ShowBlips = true -- Set to true to show blips on the map
Config.FlitsEnabledDefault = true -- Default state for Flitsmeister notifications

-- Notification settings
Config.SpeedingNotificationCooldown = 10 -- Cooldown time in seconds before the player can receive another speeding notification

-- Webhook URL
Config.WebhookURL = "https://discord.com/api/webhooks/1273981140343980103/vWpAhaJ5OOqM8XjMnYIMKCztKvFPRkck-xBdMd4VzfpNyv3y5NF3R5pqoANz2FBu5Ppc" -- Set your actual webhook URL here

-- Utility function to generate random locations around the map
function GenerateRandomCameraLocations(count)
    local locations = {}
    for i = 1, count do
        -- Random coordinates for cameras (customize as needed)
        local x = math.random(-3000, 3000)
        local y = math.random(-3000, 3000)
        local z = 30 -- Set to a suitable height

        table.insert(locations, { x = x, y = y, z = z })
    end
    return locations
end

-- Populate cameras
Config.MobileCameras = GenerateRandomCameraLocations(100)
Config.FixedCameras = GenerateRandomCameraLocations(150)
