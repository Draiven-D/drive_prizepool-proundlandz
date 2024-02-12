Config = {}
Config.Button = 38 -- ปุ่มกด 38 = E
Config.Blip = {
	Show = true,
	Sprite = 436,
	Scale = 0.6,
	Color = 1,
	Text = '<font face="THSarabunNew">Prize Pool</font>'
}
Config.Npc = {
	Show = true,
	Model = "Panda",
	Coord = vector3(259.2904, -756.2295, 33.69),
	Heading = 182.8300
}
Config.RegisterZone = vector3(259.2904, -756.2295, 33.69)
Config.TextRegister = "~w~Prize Pool~s~"
Config.description = { -- คำอธิบายกิจกรรม
    "จำนวนเงินสูงสุดของ Prize Pool ในแต่ละรอบคือ 5,000 บาท",
    "ตั๋วทุกใบมีมูลค่า ยิ่งส่งมายิ่งมีโอกาสที่จะได้รางวัลมากขึ้น",
    "ตั๋ว 1 ใบที่ส่งเข้า Pool มีมูลค่า 0.2 บาท",
    "ทุกๆการส่งตั๋วครบ 10 ใบ จะได้รับไอเทมพิเศษ",
    "ตั๋วสามารถหาได้จากการฟาร์มรอบเมือง ออนไลน์ในเมือง เข้าร่วมกิจกรรม ทำเควส",
    "ตั๋วที่อยู่ใน Pool จะถูก Reset หลังจากออกรางวัล",
    "คำตัดสินของทีมงานถือเป็นที่สิ้นสุด",
}


ESX = nil
function FirstLoaded()
	Citizen.CreateThread(function()
		while ESX == nil do 
			Citizen.Wait(1)
			-- Init extended object.
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		end
		SecLoaded()
	end)
end

function GetItemAmount(name) -- ดึงจำนวนไอเท็ม
    for k, v in ipairs(ESX.GetPlayerData().inventory) do
        if v.name == name then return v.count end
    end
    return 0
end

local fontID = nil
Citizen.CreateThread(function()
    while fontID == nil do
        Citizen.Wait(5000)
        fontID = exports["base_font"]:GetFontId("srbn")
    end
end)

function Draw3DText(x,y,z,textInput,sc)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local distance = GetDistanceBetweenCoords(px,py,pz, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    if sc then scale = scale * sc end
    SetTextScale(0.0 * scale, 0.35 * scale)
    SetTextFont(fontID)   ------แบบอักษร 1-7
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+1, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function LoadModels(model)
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	while not HasModelLoaded(model) do
		Citizen.Wait(7)
	end
end