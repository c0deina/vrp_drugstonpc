local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_drugstonpc")


RegisterServerEvent('drugs:check')
AddEventHandler('drugs:check', function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local cops = vRP.getUsersByGroup({"cop"})
    if vRP.hasGroup({user_id,"cop"}) then
	    vRPclient.notify(player,{"~r~Cops can't sell drugs."})
	    TriggerClientEvent('done', player)
	    TriggerClientEvent('cancel', player)
    else
    if #cops >= 1 then
	    TriggerClientEvent("currentlySelling")
    else
        vRPclient.notify(player,{"~r~Not enough cops online."})
        TriggerClientEvent('done', player)
        TriggerClientEvent('cancel', player)
    end
  end
end)


RegisterServerEvent('drugs:item')
AddEventHandler('drugs:item', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if not vRP.tryGetInventoryItem({user_id,"weed",1,notify}) then
		TriggerClientEvent('done', player)
		TriggerClientEvent('cancel', player)
	else
		TriggerClientEvent('cancel', player)
	end
end)

RegisterServerEvent('drugs:money')
AddEventHandler('drugs:money', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local reward = math.random(150,300)
	vRP.giveMoney({user_id,reward})
end)

RegisterServerEvent('vRP_drugNPC:policia')
AddEventHandler('vRP_drugNPC:policia', function(x,y,z)
     vRP.sendServiceAlert({nil, "police",x,y,z,"Someone is offering me drugs."})
end)