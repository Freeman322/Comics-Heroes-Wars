tracer_time_lapse = class({
    IsRefreshable = function() return false end,
    IsStealable = function() return false end
})
local tStates = {}
local IsFirstTimeUpgrade = true

local tUnits = {}

function tracer_time_lapse:GetManaCost(hTarget) return self:GetCaster():HasScepter() and self:GetCaster():GetMaxMana() / 100 * self:GetSpecialValueFor("manacost_scepter") or self.BaseClass.GetManaCost(self, hTarget) end
function tracer_time_lapse:GetCooldown(nLevel) return self:GetCaster():HasScepter() and self:GetSpecialValueFor("time_jump_cooldown_scepter") or self.BaseClass.GetCooldown(self, nLevel) end

function tracer_time_lapse:OnUpgrade( params )
    if IsFirstTimeUpgrade then
    	tUnits = {self:GetCaster()}
    	self:_init()
    	IsFirstTimeUpgrade = false
        Timers:CreateTimer(1, function()
            self:OnTimerThink()
            return 1
        end)
    end
end

function tracer_time_lapse:_init()
    for _, hUnit in pairs(tUnits) do
        tStates[hUnit] 				= tStates[hUnit] 			or {}
	    tStates[hUnit][0] 			= tStates[hUnit][0] 		or {}
	    tStates[hUnit][0].pos 		= tStates[hUnit][0].pos 	or hUnit:GetAbsOrigin()
	    tStates[hUnit][0].health 	= tStates[hUnit][0].health 	or hUnit:GetHealth()
	    tStates[hUnit][0].mana		= tStates[hUnit][0].mana 	or hUnit:GetMana()
	    tStates[hUnit][0].abil1 	= tStates[hUnit][0].abil1 	or hUnit:GetAbilityByIndex(0):GetCooldownTimeRemaining()
	    tStates[hUnit][0].abil2 	= tStates[hUnit][0].abil2 	or hUnit:GetAbilityByIndex(1):GetCooldownTimeRemaining()
	    --tStates[hUnit][0].abil3		= tStates[hUnit][0].abil3 	or hUnit:GetAbilityByIndex(2):GetCooldownTimeRemaining()
    end
end
function tracer_time_lapse:OnTimerThink()
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
	    tStates[hUnit][need_time].abil1 	= hUnit:GetAbilityByIndex(0):GetCooldownTimeRemaining()
	    tStates[hUnit][need_time].abil2 	= hUnit:GetAbilityByIndex(1):GetCooldownTimeRemaining()
	    --tStates[hUnit][need_time].abil3		= hUnit:GetAbilityByIndex(2):GetCooldownTimeRemaining()
    end
 end

function tracer_time_lapse:OnSpellStart()
    self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
    for hUnit, data in pairs(tStates) do
         hUnit:SetAbsOrigin( data[0].pos )
         hUnit:SetHealth( data[0].health )
         if hUnit:GetHealth() == 0 then
            hUnit:SetHealth(1)
         end
         hUnit:SetMana( data[0].mana )
 		 --hUnit:GetAbilityByIndex(0):EndCooldown()
 		 --hUnit:GetAbilityByIndex(0):StartCooldown(data[0].abil1)

 		 --hUnit:GetAbilityByIndex(1):EndCooldown()
 		 --hUnit:GetAbilityByIndex(1):StartCooldown(data[0].abil2)

 		 --hUnit:GetAbilityByIndex(2):EndCooldown()
 		 --hUnit:GetAbilityByIndex(2):StartCooldown(data[0].abil3)


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
    self:UseResources(true, false, false)
    self:GetCaster():Purge(false, true, false, false, true)
    ProjectileManager:ProjectileDodge(self:GetCaster())
end
