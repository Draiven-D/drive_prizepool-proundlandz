local Token = nil
local resourcename = GetCurrentResourceName()
local isDead = false
local AllData = {}
local MyPool = 0
local Loaded = false
local Ui = false
local CanRegis = false
local NpcR = nil
local SvCf = {}

function SecLoaded()
	RegisterNetEvent("esx:playerLoaded")
	AddEventHandler("esx:playerLoaded", function(response)
		ESX.PlayerData = response
		TriggerServerEvent(resourcename..':SV:GetStatus')
	end)

	AddEventHandler('esx:onPlayerSpawn', function()
		isDead = false
	end)

	AddEventHandler('esx:onPlayerDeath', function(data)
		isDead = true
		SetNuiFocus(false, false)
		SendNUIMessage({
			message = "closeUI",
		})
		Ui = false
	end)

	AddEventHandler('onResourceStop', function(resource)
		if resource == GetCurrentResourceName() then
			if NpcR then
				DeletePed(NpcR)
			end
		end
	end)

	RegisterNetEvent(resourcename..':CL:SetStatus')
	AddEventHandler(resourcename..':CL:SetStatus', function(_tk, _Cf, _AllData, _MyPool)
		Token = _tk
		SvCf = _Cf
		Loaded = true
		AllData = _AllData
		CanRegis = AllData['Status']
		MyPool = _MyPool
		local MyTicket = GetItemAmount(SvCf.Ticket)
		SendNUIMessage({
			message = 'SetData',
			alldata = AllData,
			cf = SvCf,
			mypool = MyPool,
			myticket = MyTicket,
			description = Config.description
		})
	end)

	RegisterNetEvent(resourcename..':CL:UpdateStatus')
	AddEventHandler(resourcename..':CL:UpdateStatus', function(_Status)
		AllData['Status'] = _Status
		CanRegis = _Status
		local MyTicket = GetItemAmount(SvCf.Ticket)
		SendNUIMessage({
			message = 'UpdateData',
			alldata = AllData,
			mypool = MyPool,
			myticket = MyTicket
		})
	end)

	RegisterNetEvent(resourcename..':CL:UpdateAllData')
	AddEventHandler(resourcename..':CL:UpdateAllData', function(_AllData, _Reset)
		AllData = _AllData
		CanRegis = AllData['Status']
		if _Reset then
			MyPool = 0
		end
		local MyTicket = GetItemAmount(SvCf.Ticket)
		SendNUIMessage({
			message = 'UpdateData',
			alldata = AllData,
			mypool = MyPool,
			myticket = MyTicket
		})
	end)

	RegisterNetEvent(resourcename..':CL:UpdateMyData')
	AddEventHandler(resourcename..':CL:UpdateMyData', function(_MyPool)
		MyPool = _MyPool
		local MyTicket = GetItemAmount(SvCf.Ticket)
		SendNUIMessage({
			message = 'UpdateData',
			alldata = AllData,
			mypool = MyPool,
			myticket = MyTicket
		})
	end)

	Citizen.CreateThread(function()
		if Config.Blip.Show then
			local blip = AddBlipForCoord(Config.RegisterZone)
			SetBlipHighDetail(blip, true)
			SetBlipSprite (blip, Config.Blip.Sprite)
			SetBlipScale  (blip, Config.Blip.Scale)
			SetBlipColour (blip, Config.Blip.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Blip.Text)
			EndTextCommandSetBlipName(blip)
		end
		if Config.Npc.Show then
			LoadModels(GetHashKey(Config.Npc.Model))
			NpcR = CreatePed(4, Config.Npc.Model, Config.Npc.Coord.x, Config.Npc.Coord.y, Config.Npc.Coord.z-1.0, Config.Npc.Heading, false, true)
			FreezeEntityPosition(NpcR, true)
			SetEntityInvincible(NpcR, true)
			SetBlockingOfNonTemporaryEvents(NpcR, true)
		end
		while not Loaded do
			Wait(1)
		end
		while true do 
			local threadSleep = true
			local Ped = PlayerPedId()
			local pedCoords = GetEntityCoords(Ped)
			if (GetDistanceBetweenCoords(pedCoords, Config.RegisterZone, true) < 2.0) and not isDead and not Ui and IsPedOnFoot(Ped) then
				Draw3DText(Config.RegisterZone.x, Config.RegisterZone.y, Config.RegisterZone.z+1, Config.TextRegister)
				if (IsControlJustReleased(0, Config.Button)) then
					openRegisterUI()
				end
				threadSleep = false
			end
			if (threadSleep) then 
				Citizen.Wait(500)
			end
			Citizen.Wait(1)
		end
	end)

	function openRegisterUI()
		SetNuiFocus(true, true);
		local MyTicket = GetItemAmount(SvCf.Ticket)
		SendNUIMessage({
			message = 'UpdateData',
			alldata = AllData,
			mypool = MyPool,
			myticket = MyTicket
		})
		SendNUIMessage({
			message = 'openUI'
		})
		Ui = true
	end

	RegisterNUICallback('closeUI', function(data, cb)
		SetNuiFocus(false, false)
		SendNUIMessage({
			message = "closeUI",
		})
		Ui = false
	end)

	RegisterNUICallback('SendTicket', function(data, cb)
		TriggerServerEvent(resourcename..':SV:SendTicket', Token)
	end)

end

FirstLoaded()