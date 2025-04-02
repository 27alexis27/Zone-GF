ESX = exports[GFConfig.Framework]:getSharedObject()

function RespawnPed(ped, coords, heading)
  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
  SetPlayerInvincible(ped, false)
  ClearPedBloodDamage(ped)
  TriggerServerEvent('esx:onPlayerSpawn')
  TriggerEvent('esx:onPlayerSpawn')
end

InZone = false

function AddAmmoToCurrentWeapon(amount)
    local currentWeapon = GetSelectedPedWeapon(PlayerPedId())
    local ammoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), currentWeapon)

    if ammoType ~= -1 then
        local success = AddAmmoToPed(PlayerPedId(), currentWeapon, amount, ammoType)

        return success
    else
        return false
    end
end


local menuState = false
main_menu = RageUI.CreateMenu("Zone GF", "Vous êtes mort")

main_menu.Closed = function()
    menuState = false
end

function CloseMenuGF()
    RageUI.CloseAll()
    menuState = false
end

function OpenMenuGF()
    if menuState then 
        return 
    end
    Wait(100)
    menuState = true
    RageUI.Visible(main_menu, true)
    CreateThread(function()
        while menuState do

            RageUI.IsVisible(main_menu, function()

                RageUI.Separator()
                RageUI.Separator("~r~appuyez sur E pour réapparaître")
                RageUI.Separator()
                RageUI.Button("Sortir de la zone", "Vous permet de sortir de la zone ~g~gunfight", {RightLabel = ""}, true, {
                    onSelected = function()
                        DoScreenFadeOut(1000)
                        TriggerServerEvent("PabloGF:Revive")
                        RegisterNetEvent('PabloGF:Revive')
                        AddEventHandler('PabloGF:Revive', function()
                        local playerPed = PlayerPedId()
                        local coords = GetEntityCoords(playerPed)
                        local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}
                        RespawnPed(playerPed, formattedCoords, 0.0)
                        isDead = false
                        ClearTimecycleModifier()
                        SetPedMotionBlur(playerPed, false)
                        ClearExtraTimecycleModifier()
                        end)
                        function RespawnPed(ped, coords, heading)
                        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
                        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                        SetPlayerInvincible(ped, false)
                        ClearPedBloodDamage(ped)
                        TriggerServerEvent('esx:onPlayerSpawn')
                        TriggerEvent('esx:onPlayerSpawn')
                        end
                        SetEntityCoords(PlayerPedId(), GFConfig.posbp.x, GFConfig.posbp.y, GFConfig.posbp.z, false, false, false, false)
                        CloseMenuGF()
                        DoScreenFadeOut(1000)
                        Citizen.Wait(1000)
                        DoScreenFadeIn(1000)
                    end
                })                
            end)

            Wait(1)
        end
    end)
end

Citizen.CreateThread(function()
    local markers = {}

    local marker = {
        position = GFConfig.posbp,
        size = vector3(1.5, 1.5, 1.5),
        color = {255, 0, 0},
        type = GFConfig.Typemarker
    }
    table.insert(markers, marker)
    
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, marker in ipairs(markers) do
            local distance = GetDistanceBetweenCoords(playerCoords, marker.position, true)
            
            if distance <= 15.0 then
                DrawMarker(marker.type, marker.position.x, marker.position.y, marker.position.z - 0.2, 0, 0, 0, 0, 0, 0, marker.size.x, marker.size.y, marker.size.z, marker.color[1], marker.color[2], marker.color[3], 100, false, false, 2, true, nil, nil, false)
                
                if distance <= 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour entrer dans la ~r~zone gunfight")
                    
                    if IsControlJustPressed(0, 38) then
                        DoScreenFadeOut(1000) 
                        AddAmmoToCurrentWeapon(GFConfig.Ammocount)
                        Citizen.Wait(1000) 
                        SetEntityCoords(playerPed, GFConfig.coordsgf.x, GFConfig.coordsgf.y, GFConfig.coordsgf.z, false, false, false, false) 
                        Citizen.Wait(1000) 
                        DoScreenFadeIn(1000) 
                        SetPedInfiniteAmmoClip(PlayerPedId(), true)
                        ESX.ShowNotification("Pour quitter la zone GF ~r~/"..GFConfig.Commandleave.."~s~", 5000)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(GFConfig.posbp.x, GFConfig.posbp.y, GFConfig.posbp.z)
    SetBlipSprite(blip, GFConfig.idbp)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, GFConfig.scbp)
    SetBlipColour(blip, GFConfig.colorbp)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(GFConfig.namebp)
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(GFConfig.coordsgf.x, GFConfig.coordsgf.y, GFConfig.coordsgf.z)
    SetBlipSprite(blip, 9)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.5)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 150)
    SetBlipAsShortRange(blip, true)
    SetBlipHiddenOnLegend(blip, true) 
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone gunfight")
    EndTextCommandSetBlipName(blip)
end)


Citizen.CreateThread(function()
    local blip = AddBlipForCoord(GFConfig.coordsgf.x, GFConfig.coordsgf.y, GFConfig.coordsgf.z)
    SetBlipSprite(blip, GFConfig.idbp)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone gunfight")
    EndTextCommandSetBlipName(blip)
    SetBlipHiddenOnLegend(blip, true)
end)

Citizen.CreateThread(function()
    local markerCoords = GFConfig.coordsgf
    local markerType = 28
    local markerColor = {255, 0, 0}
    local markerScale = GFConfig.echelle
    local markerVisible = false

    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(playerCoords, markerCoords, true)

        if distance <= 350.0 then
            markerVisible = true
        else
            markerVisible = false
        end

        if markerVisible then
            DrawMarker(markerType, markerCoords.x, markerCoords.y, markerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, markerScale.x, markerScale.y, markerScale.z - 25, markerColor[1], markerColor[2], markerColor[3], 50, false, true, 2, false, nil, nil, false)

        end

        if markerVisible and distance <= markerScale.x then
            InZone = true
        end

        

        local health = GetEntityHealth(PlayerPedId())
        if markerVisible and distance <= markerScale.x and health == 0 then
            OpenMenuGF()
            if IsControlJustPressed(0, 38) then
                CloseMenuGF()
                local randomCoords = GFConfig.posrea[math.random(1, #GFConfig.posrea)]
                DoScreenFadeOut(200) 
                AddAmmoToCurrentWeapon(GFConfig.Ammocount)
                SetPedInfiniteAmmoClip(PlayerPedId(), true)
                TriggerServerEvent("PabloGF:Revive")

                RegisterNetEvent('PabloGF:Revive')
                AddEventHandler('PabloGF:Revive', function()
                  local playerPed = PlayerPedId()
                  local coords = GetEntityCoords(playerPed)
                  local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}
                  RespawnPed(playerPed, formattedCoords, 0.0)
                  isDead = false
                  ClearTimecycleModifier()
                  SetPedMotionBlur(playerPed, false)
                  ClearExtraTimecycleModifier()
                end)
              
                function RespawnPed(ped, coords, heading)
                  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
                  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                  SetPlayerInvincible(ped, false)
                  ClearPedBloodDamage(ped)
                  TriggerServerEvent('esx:onPlayerSpawn')
                  TriggerEvent('esx:onPlayerSpawn')
                end
                Citizen.Wait(200)
                SetEntityCoords(PlayerPedId(), randomCoords.x, randomCoords.y, randomCoords.z, false, false, false, false)
                Citizen.Wait(200)
                SetPedInfiniteAmmo(GetPlayerServerId(PlayerPedId()), true) 
                DoScreenFadeIn(200)
                SetEntityInvincible(PlayerPedId(), true)
                SetEntityAlpha(PlayerPedId(), 51, false)
                Citizen.Wait(GFConfig.invicible)
                SetEntityInvincible(PlayerPedId(), false)                  
                ResetEntityAlpha(PlayerPedId())                  
            end
        end
    end
end)

RegisterCommand(GFConfig.Commandleave, function()
    if InZone then 
        local playerPed = PlayerPedId()
        DoScreenFadeOut(1000) 
        Citizen.Wait(1000) 
        TriggerServerEvent("PabloGF:Revive")

        RegisterNetEvent('PabloGF:Revive')
        AddEventHandler('PabloGF:Revive', function()
          local playerPed = PlayerPedId()
          local coords = GetEntityCoords(playerPed)
          local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}
          RespawnPed(playerPed, formattedCoords, 0.0)
          isDead = false
          ClearTimecycleModifier()
          SetPedMotionBlur(playerPed, false)
          ClearExtraTimecycleModifier()
        end)
      
        function RespawnPed(ped, coords, heading)
          SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
          NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
          SetPlayerInvincible(ped, false)
          ClearPedBloodDamage(ped)
          TriggerServerEvent('esx:onPlayerSpawn')
          TriggerEvent('esx:onPlayerSpawn')
        end
        SetEntityCoords(playerPed, GFConfig.posbp.x, GFConfig.posbp.y, GFConfig.posbp.z, false, false, false, false) 
        Citizen.Wait(1000) 
        DoScreenFadeIn(1000) 
        SetPedInfiniteAmmoClip(PlayerPedId(), false)
        InZone = false
    else
        ESX.ShowNotification("Vous n'êtes pas dans la zone~r~ GF")
    end
end, false)
