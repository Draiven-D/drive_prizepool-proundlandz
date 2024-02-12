Config = {}
Config.DiscordLog = true
Config.Webhook = "https://discord.com/api/webhooks/1137099888279171213/aOFlLX6V45U2Q8IUTL6T35iwMxKaug88Cqa5t2tQIOUPVSxgVUDN0GlxvgEHxjiuZGFZ"
Config.Open = false
Config.Limit = 5000 -- รางวัลสูงสุดต่อรอบ (บาท)
Config.DayReward = {7,14,21,28} -- ประกาศรางวัลทุกวันที่ 7,14,21,28
Config.TimeReward = {18,00} -- เวลาในการออกรางวัล (จะปิดการส่งก่อนออกรางวัล 1 ชม) **ห้ามใส่ช่วงเวลา 00.00 - 02.00
Config.Ticket = "voucher" -- ตั๋วสำหรับส่ง
Config.MultiPrice = 0.2 -- มูลค่าของตั๋ว (บาท) เช่น 0.2 เท่ากับ 1 ใบมูลค่า 20 สตางค์
Config.ExtraDivisible = 10 -- ส่งตั๋วครบ 10 ใบจะได้รับของ Extra
Config.ExtraItem = "energy_drink" -- ของ Extra (cash, black_money)
Config.ExtraCount = 1 --จำนวน
Config.RewardList = {
	[1] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 40 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[2] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 20 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[3] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 10 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[4] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 10 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[5] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 4 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[6] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 4 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[7] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 4 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[8] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 4 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	},
	[9] = {
		['name'] = 'None', -- ห้ามแก้ไข เป็นค่า Default
		['steam'] = '', -- ห้ามแก้ไข เป็นค่า Default
		['reward'] = 0, -- ห้ามแก้ไข เป็นค่า Default
		['percent'] = 4 -- %ของ Prizepool รวมกันทุกรางวัลไม่เกิน 100
	}
}
Config.SentSuccess = "ส่งตั๋วเรียบร้อยแล้ว"
Config.ErrorAmount = "คุณไม่มีตั๋วเหลืออยู่แล้ว"
Config.CloseTicket = "ตอนนี้ปิดการส่งตั๋วรางวัลแล้วจ้า"

ESX = nil
function FirstLoaded()
	TriggerEvent("esx:getSharedObject",function(obj)
		ESX = obj
		SecLoaded()
	end)
end

function GetPlayerFromId(source)
	return ESX.GetPlayerFromId(source)
end

function SendNoti(pid, _type, _text)
	TriggerClientEvent('pNotify:SendNotification', pid, {text = _text, type = _type, queue = "prizepool"})
end

function SendLogs(total, list) --log ดิสคอสสำหรับการออกรางวัลในแต่ละรอบ
    local label = string.format("```รางวัลรวม: %s บาท```", total)
    for k, v in pairs(list) do
        label = label .. string.format("```รางวัลที่: %s\n ชื่อ: %s\n Identifier: %s\n ได้รับ: %s บาท```", k, v.name, v.steam, v.reward)
    end
    local embed = {
        {
            ["title"] = "**รางวัล PRIZE POOL รอบวันที่ " .. os.date("%d/%m/%Y %X") .. "**",
            ["description"] = label,
            ["footer"] = {},
        }
    }

    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST',
        json.encode({ username = "PRIZE POOL", embeds = embed }), { ['Content-Type'] = 'application/json' })
end