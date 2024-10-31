ESX = nil
QBCore = nil

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local nkhd_tsunamiActive = false
local nkhd_tsunamiPaused = false
local currentWaterHeight = 0.0
local maxWaterHeight = Config.maxWaterHeight
local nkhd_tsunamiSpeed = Config.tsunamiSpeed
local nkhd_tsunamiWaitTime = Config.tsunamiWaitTime 
local WaterWaitingTime = Config.WaterWaitingTime

function updateWaterHeight(newHeight)
    currentWaterHeight = newHeight
    TriggerClientEvent('nkhd_tsunami:updateHeight', -1, currentWaterHeight)
end

local function isPlayerAdmin(source)
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.getGroup() == "admin"     
    elseif Config.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player and (Player.PlayerData.group == "admin" or Player.PlayerData.group == "superadmin")
    else
        return true
    end
end

RegisterCommand("tsunami", function(source, args, rawCommand)
    if isPlayerAdmin(source) then
        TriggerClientEvent("openTsunamiMenu", source)
    end
end)

RegisterServerEvent('nkhd_startTsunami_server')
AddEventHandler('nkhd_startTsunami_server', function()
    TriggerClientEvent("nkhd_tsunami:start", -1)
    nkhd_tsunamiActive = true

    Citizen.CreateThread(function()
        while nkhd_tsunamiActive do
            if nkhd_tsunamiPaused == false then
                if currentWaterHeight < maxWaterHeight then
                    updateWaterHeight(currentWaterHeight + nkhd_tsunamiSpeed)
                else
                    Citizen.Wait(nkhd_tsunamiWaitTime)
                    nkhd_tsunamiActive = false
                end
            end
            Citizen.Wait(WaterWaitingTime)
        end

        while currentWaterHeight > 0.0 do
            if nkhd_tsunamiPaused == false then
                updateWaterHeight(currentWaterHeight - nkhd_tsunamiSpeed)
                Citizen.Wait(WaterWaitingTime)
            end
            Citizen.Wait(WaterWaitingTime)
        end
    end)
end)

RegisterServerEvent('nkhd_stopTsunami_server')
AddEventHandler('nkhd_stopTsunami_server', function()
    nkhd_tsunamiActive = false
    TriggerClientEvent("nkhd_tsunami:stop", -1)
end)

RegisterServerEvent('nkhd_pauseTsunami_server')
AddEventHandler('nkhd_pauseTsunami_server', function()
    if nkhd_tsunamiPaused == false then
        nkhd_tsunamiPaused = true
    else
        nkhd_tsunamiPaused = false
    end
    TriggerClientEvent("nkhd_tsunami:pause", -1)
end)


RegisterServerEvent('reloadWater')
AddEventHandler('reloadWater', function()
    TriggerClientEvent("nkhd_tsunami:loadend", -1)
end)

AddEventHandler('playerSpawned', function()
    if nkhd_tsunamiActive then
        TriggerClientEvent('nkhd_tsunami:load', source)
        TriggerClientEvent('nkhd_tsunami:start', source, currentWaterHeight, maxWaterHeight, nkhd_tsunamiSpeed, nkhd_tsunamiWaitTime)
    end
end)
