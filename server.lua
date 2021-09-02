RegisterNetEvent("license_plate_changer:newPlate", function(newPlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldPlate = GetVehicleNumberPlateText(vehicle)
    oldPlate = string.gsub(oldPlate, '^%s*(.-)%s*$', '%1')

    if newPlate ~= oldPlate then
        MySQL.Async.fetchScalar("SELECT COUNT(1) FROM owned_vehicles WHERE plate = @plate AND owner = @owner", {
            ["@plate"] = newPlate,
            ["@owner"] = xPlayer.getIdentifier(),
        }, function(result)
            if result == 1 then
                xPlayer.showNotification(string.format("This plate `%s` is already registered to another vehicle", newPlate))
            else
                MySQL.Async.execute("UPDATE owned_vehicles SET plate = @newPlate WHERE plate = @oldPlate AND owner = @owner", {
                    ["@newPlate"] = newPlate,
                    ["@oldPlate"] = oldPlate,
                    ["@owner"] = xPlayer.getIdentifier(),
                }, function(result)
                    newPlate = string.gsub(newPlate, '^%s*(.-)%s*$', '%1')
                    SetVehicleNumberPlateText(vehicle, newPlate)
                    xPlayer.showNotification("Succefully changed your license plate")
                    if Config.RemoveAfterUse then
                        xPlayer.removeInventoryItem(Config.RequiredItem, 1)                        
                    end
                end)
            end
        end)
    end
end)

ESX.RegisterUsableItem(Config.RequiredItem, function(source, item)
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
            if result == 1 then
                TriggerClientEvent("license_plate_changer:changePlate", source)
            else
                xPlayer.showNotification("This vehicle doesn't belong to you")
            end
        end)
    end
end)