Config = {
    BreakSpeed = 90,
    NoBrakeClasses = {
        [8] = true,                     -- bike
        [9] = true,                     -- off-road
        [14] = true,                    -- boats
        [15] = true,                    -- helicopter
        [16] = true                     -- planes
    }
}

Main = {}

function Main:CheckClass(class)
    return not Config.NoBrakeClasses[class]
end

function Main:GetPlayerPed()
    return PlayerPedId()
end

function Main:HandleCollision(veh, speed)
    local chance = math.random(0, 3)

    if speed >= Config.BreakSpeed then
        if speed >= Config.BreakSpeed - 30 then
            SetVehicleTyreBurst(veh, chance, speed >= Config.BreakSpeed - 10)
        elseif speed >= Config.BreakSpeed - 10 then
            BreakOffVehicleWheel(veh, chance, true, false, true, false)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local loopInterval = 5000
        local playerPed = Main:GetPlayerPed()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if GetPedInVehicleSeat(vehicle, -1) ~= 0 and Main:CheckClass(GetVehicleClass(vehicle)) then
                loopInterval = 10
                local vehicleSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.6)
                if HasEntityCollidedWithAnything(vehicle) then
                    Main:HandleCollision(vehicle, vehicleSpeed)
                end
            end
        end

        Citizen.Wait(loopInterval)
    end
end)
