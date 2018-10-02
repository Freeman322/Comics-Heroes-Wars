LinkLuaModifier( "item_time_gem_active", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )
strange_faces_reality = class({})
local tStates = {}

local tUnits
function strange_faces_reality:IsStealable(  )
    return false
end

function strange_faces_reality:OnUpgrade( params )
    if tUnits == nil then
        tUnits = HeroList:GetAllHeroes()
        _init()
        Timers:CreateTimer(1, function()
            OnTimerThink()
            return 1
        end)
    end
end
function _init()
    for _, hUnit in pairs(tUnits) do
        tStates[hUnit] 				= tStates[hUnit] 			or {}
        tStates[hUnit][0] 			= tStates[hUnit][0] 		or {}
        tStates[hUnit][0].pos 		= tStates[hUnit][0].pos 	or hUnit:GetAbsOrigin()
        tStates[hUnit][0].health 	= tStates[hUnit][0].health 	or hUnit:GetHealth()
        tStates[hUnit][0].mana		= tStates[hUnit][0].mana 	or hUnit:GetMana()
    end
end
function OnTimerThink()
    for hUnit, tUnitData in pairs(tStates) do
        for i = 0, #tUnitData do
            if tStates[hUnit][i + 1] then
                tStates[hUnit][i] = tStates[hUnit][i + 1]
            end
        end

        local need_time = #tUnitData + 1

        if need_time > 5 then need_time = 5 end

        tStates[hUnit][need_time] 			= {}
        tStates[hUnit][need_time].pos 		= hUnit:GetAbsOrigin()
        tStates[hUnit][need_time].health 	= hUnit:GetHealth()
        tStates[hUnit][need_time].mana 		= hUnit:GetMana()
    end
 end

function strange_faces_reality:OnSpellStart(  )
    local caster = self:GetCaster()
    for hUnit, data in pairs(tStates) do
        if hUnit:GetUnitName() ~= "npc_dota_hero_wisp" and hUnit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
          if hUnit:IsAlive() == false then
               hUnit:RespawnHero(false, false, true)
               hUnit:SetHealth(data[0].health + (hUnit:GetMaxHealth()/2) + 300)
               hUnit:SetAbsOrigin( data[0].pos )
               hUnit:SetMana( data[0].mana )
          else
               hUnit:SetAbsOrigin( data[0].pos )
               hUnit:SetHealth( data[0].health )
               hUnit:SetMana( data[0].mana )
          end
          if hUnit:GetHealth() == 0 then
              hUnit:Heal( 100, hUnit )
              hUnit:SetHealth(hUnit:GetHealth() + 300)
          end

          local nFXIndex = ParticleManager:CreateParticle( "particles/effects/time_lapse_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit )
          ParticleManager:SetParticleControl( nFXIndex, 0, hUnit:GetOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 1, hUnit:GetOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))
          ParticleManager:SetParticleControl( nFXIndex, 3, hUnit:GetOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 4, hUnit:GetOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 5, hUnit:GetOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 6, hUnit:GetOrigin())
          ParticleManager:SetParticleControl( nFXIndex, 10,hUnit:GetOrigin())
          ParticleManager:ReleaseParticleIndex( nFXIndex )

          EmitSoundOn( "Hero_Weaver.TimeLapse", hUnit )
        end
    end
end

function strange_faces_reality:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

