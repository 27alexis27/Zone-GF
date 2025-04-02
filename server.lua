ESX = exports[GFConfig.Framework]:getSharedObject()

RegisterNetEvent('PabloGF:Revive')
  AddEventHandler('PabloGF:Revive', function()
  TriggerClientEvent("PabloGF:Revive", source)
end)