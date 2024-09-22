local nkhd_tsunamiActive = false
local currentWaterHeight = 0.0
local maxWaterHeight = 250.0
local nkhd_tsunamiSpeed = 250
local nkhd_tsunamiWaitTime = 600000000 
local WaterWaitingTime = 100

function updateWaterHeight(newHeight)
    currentWaterHeight = newHeight
    TriggerClientEvent('nkhd_tsunami:updateHeight', -1, currentWaterHeight)
end

RegisterCommand("tsunami", function(source, args, rawCommand)
    TriggerClientEvent("openTsunamiMenu", source)
end)

RegisterServerEvent('nkhd_startTsunami_server')
AddEventHandler('nkhd_startTsunami_server', function()
    TriggerClientEvent("nkhd_tsunami:start", -1)
    nkhd_tsunamiActive = true

    Citizen.CreateThread(function()
        while nkhd_tsunamiActive do
            if currentWaterHeight < maxWaterHeight then
                updateWaterHeight(currentWaterHeight + nkhd_tsunamiSpeed)
            else
                Citizen.Wait(nkhd_tsunamiWaitTime)
                nkhd_tsunamiActive = false
            end
            Citizen.Wait(WaterWaitingTime)
        end

        while currentWaterHeight > 0.0 do
            updateWaterHeight(currentWaterHeight - nkhd_tsunamiSpeed)
            Citizen.Wait(WaterWaitingTime)
        end
    end)
end)

RegisterServerEvent('nkhd_stopTsunami_server')
AddEventHandler('nkhd_stopTsunami_server', function()
    print('Stopping Tsunami')
    nkhd_tsunamiActive = false
    TriggerClientEvent("nkhd_tsunami:stop", -1)
end)

RegisterServerEvent('reloadWater')
AddEventHandler('reloadWater', function()
    TriggerClientEvent("nkhd_tsunami:loadend", -1)
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    if nkhd_tsunamiActive then
        TriggerClientEvent('nkhd_tsunami:start', source, currentWaterHeight, maxWaterHeight, nkhd_tsunamiSpeed, nkhd_tsunamiWaitTime)
    end
end)
