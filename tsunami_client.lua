local nkhd_tsunamiActive = false
local currentWaterHeight = 0.0
local maxWaterHeight = Config.maxWaterHeight
local nkhd_tsunamiSpeed = Config.tsunamiSpeed
local WaterWaitingTime = Config.WaterWaitingTime
local Waterloaded = false

function setGlobalWaterHeight(height)
    ModifyWater(height)
end

RegisterNetEvent('nkhd_tsunami:updateHeight')
AddEventHandler('nkhd_tsunami:updateHeight', function(newHeight)

    if Waterloaded == false then
        TriggerEvent('nkhd_tsunami:load')
    end

    if Swimmcheck == false then
        TriggerEvent('nkhd_tsunami:swimcheck')
    end

    local waterQuadCount = GetWaterQuadCount()
    for i = 1, waterQuadCount, 1 do
        local success, waterQuadLevel = GetWaterQuadLevel(i)
        if success then
            currentWaterHeight = newHeight
            SetWaterQuadLevel(i, currentWaterHeight)
        end
    end
end)

RegisterNetEvent('nkhd_tsunami:start')
AddEventHandler('nkhd_tsunami:start', function(startHeight, maxHeight, speed, waitTime)
    if Waterloaded == false then
        TriggerEvent('nkhd_tsunami:load')
    end

    TriggerEvent('nkhd_tsunami:stopSpawning')
    nkhd_tsunamiActive = true
    currentWaterHeight = startHeight or 0.0
    maxWaterHeight = maxHeight or 50.0
    nkhd_tsunamiSpeed = speed or 0.05

    Citizen.CreateThread(function()
        while nkhd_tsunamiActive do
            if currentWaterHeight < maxWaterHeight then
                currentWaterHeight = currentWaterHeight + nkhd_tsunamiSpeed
                setGlobalWaterHeight(currentWaterHeight)
            else
                Citizen.Wait(waitTime)
                nkhd_tsunamiActive = false
            end
            Citizen.Wait(WaterWaitingTime)
        end

        while currentWaterHeight > 0.0 do
            currentWaterHeight = currentWaterHeight - nkhd_tsunamiSpeed
            setGlobalWaterHeight(currentWaterHeight)
            Citizen.Wait(WaterWaitingTime)
        end
    end)
end)

RegisterNetEvent('nkhd_tsunami:stop')
AddEventHandler('nkhd_tsunami:stop', function()
    nkhd_tsunamiActive = false
    while currentWaterHeight > 0.0 do
        currentWaterHeight = currentWaterHeight - nkhd_tsunamiSpeed
        setGlobalWaterHeight(currentWaterHeight)
        Citizen.Wait(WaterWaitingTime)
    end
    TriggerEvent('nkhd_tsunami:resumeSpawning')
    Waterloaded = false
    Swimmcheck = false
end)

RegisterNetEvent('nkhd_tsunami:load')
AddEventHandler('nkhd_tsunami:load', function()
    Waterloaded = true
    print('Loading custom flood_initial.xml')
    local success = LoadWaterFromPath(GetCurrentResourceName(), 'flood_initial.xml')
    if success ~= 1 then
        print('Failed to load flood_initial.xml, does the file exist within the resource?')
    end
end)

RegisterNetEvent('nkhd_tsunami:loadend')
AddEventHandler('nkhd_tsunami:loadend', function()
    print('Loading custom water.xml')
    local success = LoadWaterFromPath(GetCurrentResourceName(), 'water.xml')
    if success ~= 1 then
        print('Failed to load water.xml, does the file exist within the resource?')
    end
end)

RegisterNetEvent('nkhd_tsunami:stopSpawning')
AddEventHandler('nkhd_tsunami:stopSpawning', function()
    SetPedPopulationBudget(0)
    SetVehiclePopulationBudget(0)
end)

RegisterNetEvent('nkhd_tsunami:resumeSpawning')
AddEventHandler('nkhd_tsunami:resumeSpawning', function()
    SetPedPopulationBudget(3)
    SetVehiclePopulationBudget(3)
end)

RegisterNetEvent('openTsunamiMenu')
AddEventHandler('openTsunamiMenu', function()
    SetNuiFocus(true, true) 
    SendNUIMessage({
        action = 'open'  
    })
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)  
    SendNUIMessage({
        action = 'close'  
    })
    cb('ok')
end)

RegisterNUICallback('startTsunami', function(data, cb)
    TriggerServerEvent('nkhd_startTsunami_server')
    cb('ok')
end)

RegisterNUICallback('stopTsunami', function(data, cb)
    TriggerServerEvent('nkhd_stopTsunami_server')
    cb('ok')
end)

RegisterNUICallback('reloadWater', function(data, cb)
    TriggerServerEvent('reloadWater')
    cb('ok')
end)
