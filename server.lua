RegisterNetEvent("license_plate_changer:newPlate", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldPlate = GetVehicleNumberPlateText(vehicle)
    oldPlate = string.gsub(oldPlate, '^%s*(.-)%s*$', '%1')

    if plate ~= oldPlate then
        MySQL.Async.execute("UPDATE owned_vehicles SET plate = @newPlate WHERE plate = @oldPlate AND owner = @owner", {
            ["@newPlate"] = plate,
            ["@oldPlate"] = oldPlate,
            ["@owner"] = xPlayer.getIdentifier(),
        }, function(result)
            plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')
            SetVehicleNumberPlateText(vehicle, plate)
            xPlayer.showNotification("Succefully changed your license plate")
            xPlayer.removeInventoryItem("license_plate", 1)
        end)
    end
end)

ESX.RegisterUsableItem("license_plate", function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')
        MySQL.Async.fetchScalar("SELECT COUNT(1) FROM owned_vehicles WHERE plate = @plate AND owner = @owner", {
            ["@plate"] = plate,
            ["@owner"] = xPlayer.getIdentifier()
        }, function(result)
            print(plate)
            print("item: license_plate")
            print(json.encode(result))
            if result == 1 then
                TriggerClientEvent("license_plate_changer:changePlate", source)
            else
                xPlayer.showNotification("This vehicle doesn't belong to you")
            end
        end)
    end
end)

ESX.RegisterCommand("changeplate", "admin", function()
end)