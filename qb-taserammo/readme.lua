--QB-core/Shared.lua
     ["taserammo"]                      = {["name"] = "taserammo",                        ["label"] = "Taser Cartridges",            ["weight"] = 3000,        ["type"] = "item",        ["image"] = "taserammo.png",              ["unique"] = false,        ["useable"] = true,        ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "No More Spamming. lul"},  

     --in smallresources > client > ignore add
     maxTaserCarts = 2 -- The amount of taser cartridges a person can have.

     local taserCartsLeft = maxTaserCarts
     
     RegisterNetEvent("FillTaser")
     AddEventHandler("FillTaser",function(source, args, rawCommand)
         
         QBCore.Functions.Progressbar("load_tazer", "Reloading Tazer..", 2000, false, true, {
             disableMovement = false,
             disableCarMovement = false,
             disableMouse = false,
             disableCombat = true,
         }, {
             animDict = "anim@weapons@pistol@singleshot_str",
             anim = "reload_aim",
             flags = 48,
         }, {}, {}, function() -- Done
         
             
             taserCartsLeft = maxTaserCarts
             TriggerServerEvent("QBCore:Server:RemoveItem", "taserammo", 1)
             TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["taserammo"], "remove")
             
         end)
     end)  

   --add this also in the same area right below
 local taserModel = GetHashKey("WEAPON_STUNGUN")

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()

        if GetSelectedPedWeapon(ped) == taserModel then
            if IsPedShooting(ped) then
                DisplayAmmoThisFrame(true)
                taserCartsLeft = taserCartsLeft - 1
            end
        end

        if taserCartsLeft <= 0 then
            if GetSelectedPedWeapon(ped) == taserModel then
                SetPlayerCanDoDriveBy(ped, false)
                DisablePlayerFiring(ped, true)
                if IsControlJustReleased(0, 106) then
                    QBCore.Functions.Notify("You need to reload your taser!", "error")
                end
            end
        end

        if longerTazeTime then
            SetPedMinGroundTimeForStungun(ped, longerTazeSecTime * 1000)
        end
    end
end)

RegisterCommand('test', function()
    TriggerEvent("FillTaser")
end) 

--this goes in smallresoureces>server>consumables
 
 QBCore.Functions.CreateUseableItem("taserammo", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("FillTaser", source)
    end
end) 