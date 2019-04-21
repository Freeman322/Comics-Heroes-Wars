Trades = class({})
local Items = {}
Items[3] = {
  "34",
  "35",
  "36",
  "37",
  "38"
}
Items[4] = {
  "17",
  "20",
  "21",
  "27",
  "29"
}
Items[5] = {
  "31",
  "16",
  "18",
  "4"
}
Items[6] = {
  "5",
  "6",
  "19",
  "26",
  "28",
  "40",
  "51"
}
Items[7] = {
  "23",
  "24",
  "39",
  "2"
}

local fontRitites = {}

fontRitites[0] = nil
fontRitites[1] = "#B0C3D9"
fontRitites[2] = "#5E98D9"
fontRitites[3] = "#4B69FF"
fontRitites[4] = "#8847FF"
fontRitites[5] = "#D32CE6"
fontRitites[6] = "#EB4B4B"
fontRitites[7] = "#E4AE33"
fontRitites[8] = "#476291"
fontRitites[9] = "#ADE55C"
fontRitites[10] = "#A50F79"


function Trades:Init()
  CustomGameEventManager:RegisterListener("trade_recive", Dynamic_Wrap(Trades, 'OnTradeSubmit'))
  CustomGameEventManager:RegisterListener("apply_trade", Dynamic_Wrap(Trades, 'OnTradeApplied'))
  CustomGameEventManager:RegisterListener("item_dropped", Dynamic_Wrap(Trades, 'OnItemDropped'))
  CustomGameEventManager:RegisterListener("on_contract_submitted", Dynamic_Wrap(Trades, 'OnContractSubmitted'))
  CustomGameEventManager:RegisterListener("on_get_inventory", Dynamic_Wrap(Trades, 'OnGetInventory'))

  print("TRADES IS INIT")
end

function Trades:OnGetInventory(args)
  local pID = args['playerID']

  local result = {}
  result.type = 14
  result.token = GetDedicatedServerKey( "7.8.1" ) 

  local connection = CreateHTTPRequestScriptVM('POST', "http://94.250.251.65/games/chw/test/data.php")
  local encoded_data = json.encode(result)
  connection:SetHTTPRequestGetOrPostParameter('payload', encoded_data)
  connection:Send (function(result_keys)
      local obj, pos, err = json.decode(result_keys["Body"])
      if obj then
          DeepPrintTable(obj)
          if obj["key"] == 1 then 
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "on_auth_sucseed", data)
          end 
      end
  end)
end

function Trades:OnContractSubmitted(args)
  
end

function Trades:OnItemDropped(args)
  local pID = args["playerID"]
  local item = args["item"]
  local requester = args["player"]
  local steam_id = PlayerResource:GetSteamAccountID(pID)
  local treasure = args["treasure"]

  if tostring(requester) ~= tostring(steam_id) then return end 

  local value = PlayerTables:GetTableValue("globals", "econs")

  local data = {
    item = item,
    rarity = value[tostring(item)]['rarity'],
    quality = value[tostring(item)]['quality'],
    is_medal = value[tostring(item)]['is_medal'],
    is_treasure = value[tostring(item)]['is_treasure'],
    tradeable = 1,
    steam_id = tostring(steam_id),
    source = treasure
  }
  
  stats.create_item(data)

  local rarity = value[tostring(item)]['rarity']
  local message = {
    pID = pID,
    item = item,
    color = fontRitites[rarity],
    reason = 1
  }

  Util:SendCustomMessage(message)
end

function Trades:OnTradeSubmit(args)
  local player = args["target"]
  local data = args["result"]

  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player), "get_trade", args)
end

function Trades:OnTradeApplied(args)
  local player = args["target"]
  local request = args["request"]

  Timers:CreateTimer(0.6, function()
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(request), "update_inventory", args)
  end)
  Timers:CreateTimer(0.8, function()
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player), "update_inventory", args)
  end)

  local data = args["result"]

  stats.submit_trade(data)
end
