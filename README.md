# plate_changer
A really stupid and simple script to change your license plate on an ESX server. It assumes that you use `esx_vehicleshop` and have a table named `owned_vehicles`

## Configuration
| Name | Type | Description |
| ---- | ---- | ----------- |
| RemoveAfterUse | bool | Should the item be removed after it's used? |
| RequiredItem | string | The item name a player needs to have to change his plate |
