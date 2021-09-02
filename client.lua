RegisterNetEvent("esx:playerLoaded", function(data)
    ESX.PlayerData = data
end)

RegisterNetEvent("license_plate_changer:changePlate", function()
    SendNUIMessage({
        type = "enable"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("change_plate", function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent("license_plate_changer:newPlate", data.plate)
    cb("OK")
end)