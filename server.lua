RegisterNetEvent("grabAIPhone")
AddEventHandler("grabAIPhone", function()
    local src = source
    local playerPed = GetPlayerPed(src) -- Get the player's Ped
    
    -- Find the nearest NPC (Ped) within a certain radius
    local playerCoords = GetEntityCoords(playerPed)
    local radius = 10.0 -- Radius to search for NPCs

    local nearestPed = nil
    local nearestDistance = radius

    for ped in EnumeratePeds() do
        if ped ~= playerPed and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - pedCoords)

            -- Check if the NPC is on the phone
            if distance < nearestDistance and IsPedOnPhone(ped) then
                nearestPed = ped
                nearestDistance = distance
            end
        end
    end

    -- If a ped was found, handle the logic
    if nearestPed then
        -- Make the NPC drop their phone and run toward the player
        ClearPedTasks(nearestPed) -- Clear any current tasks (e.g., phone call)

        -- Get player position and make the ped run toward the player
        local runToCoords = playerCoords

        TaskGoStraightToCoord(nearestPed, runToCoords.x, runToCoords.y, runToCoords.z, 2.5, -1, 0.0, 0.0)

        -- Chat msg
        TriggerClientEvent("chat:addMessage", src, {
            args = {"Hands", "You grabbed the phone from the Civ and they are running toward you!"}
        })
    else
        -- Notify the player if no NPCs were found on the phone
        TriggerClientEvent("chat:addMessage", src, {
            args = {"Hands", "No one the phone were found nearby!"}
        })
    end
end)

function EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        if not handle or handle == -1 then
            EndFindPed(handle)
            return
        end

        local success
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success

        EndFindPed(handle)
    end)
end

-- Checks if AI on zee phone
function IsPedOnPhone(ped)
    return IsEntityPlayingAnim(ped, "cellphone@", "cellphone_call_listen_base", 3) or 
           IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_in", 3)
end