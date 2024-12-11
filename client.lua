RegisterCommand("grabphone", function()
    TriggerServerEvent("grabAIPhone")
end, false)

TriggerEvent('chat:addSuggestion', '/grabphone', 'To get the phone of the nereit Civ')
-- When cmd used 
RegisterNetEvent("chat:addMessage")
AddEventHandler("chat:addMessage", function(message)
    print(message.args[2])
end)
