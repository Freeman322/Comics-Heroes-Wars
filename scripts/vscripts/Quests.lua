Quests = class({})

local quests_table

function Quests:Init(args)
  local quests = LoadKeyValues('scripts/quests.kv')
  CustomNetTables:SetTableValue( "globals", "quests", quests )
  quests_table = quests

  CustomGameEventManager:RegisterListener("select_quest", Dynamic_Wrap(Quests, 'RegisterPlayer'))
end

function Quests:RegisterPlayer(args)
  local pID = args['playerID']
  local quest = args['quest']

  if GameRules.Globals.Quests and  GameRules.Globals.Quests[pID] == nil then
    GameRules.Globals.Quests[pID] = {}
    GameRules.Globals.Quests[pID].questID = quest
    GameRules.Globals.Quests[pID].steam_id = PlayerResource:GetSteamAccountID(pID)
    GameRules.Globals.Quests[pID].name = quests_table[quest]['name']
    GameRules.Globals.Quests[pID].number = quests_table[quest]['number']
    GameRules.Globals.Quests[pID].hero = quests_table[quest]['hero']
    GameRules.Globals.Quests[pID].task = quests_table[quest]['task']
    GameRules.Globals.Quests[pID].progress = 0
    GameRules.Globals.Quests[pID].complite = false
    GameRules.Globals.Quests[pID].item = quests_table[quest]['item']

    CustomNetTables:SetTableValue( "globals", "quests_current", GameRules.Globals.Quests)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "select_current_quest", GameRules.Globals.Quests[pID])
  end
end

function Quests:UpdateQuest(pID)
  if GameRules.Globals.Quests and GameRules.Globals.Quests[pID] then
    if GameRules.Globals.Quests[pID]["progress"] >= GameRules.Globals.Quests[pID]["number"] then
      GameRules.Globals.Quests[pID].complite = true
      Quests:EndQuest(pID)
      return nil
    end
  end
  if GameRules.Globals.Quests[pID] and not GameRules.Globals.Quests[pID].complite then
    CustomNetTables:SetTableValue( "globals", "quests_current", GameRules.Globals.Quests)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "update_current_quest", {data = GameRules.Globals.Quests[pID]})
  end
end


function Quests:EndQuest(pID)
  local data = GameRules.Globals.Quests[pID]
  CustomNetTables:SetTableValue( "globals", "quests_current", GameRules.Globals.Quests)
  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "end_quest", {data = GameRules.Globals.Quests[pID]})
  Stats:SendQuestResult(data)
end
