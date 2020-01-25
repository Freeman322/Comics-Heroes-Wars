LinkLuaModifier ("modifier_raiden_elecro_mine_thinker", "abilities/raiden_elecro_mine.lua", LUA_MODIFIER_MOTION_NONE)

raiden_elecro_mine = class({})

local CONST_FL_CHECK_TIME = 0.04
local CONST_GLOBAL = 99999

function raiden_elecro_mine:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then
		return CONST_GLOBAL
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function raiden_elecro_mine:GetAOERadius() return self:GetSpecialValueFor("radius") end
function raiden_elecro_mine:GetBehavior() return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT end

function raiden_elecro_mine:OnSpellStart ()
    if IsServer() then
        local duration = self:GetSpecialValueFor("mine_duration")
        
        self.m_hThinker = CreateModifierThinker (self:GetCaster(), self, "modifier_raiden_elecro_mine_thinker", {duration = duration }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
        
        GridNav:DestroyTreesAroundPoint (self:GetCursorPosition(), 500, false)
    end 
end

modifier_raiden_elecro_mine_thinker = class({})

modifier_raiden_elecro_mine_thinker.m_hChashedUnit = nil

function modifier_raiden_elecro_mine_thinker:OnCreated (event)
    if IsServer() then
        self.m_radius = self:GetAbility():GetSpecialValueFor("mine_radius")

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.m_radius, self.m_radius, 0))
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
       
        EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetParent())

        self:StartIntervalThink(CONST_FL_CHECK_TIME)
    end
end

function modifier_raiden_elecro_mine_thinker:OnIntervalThink()
     if IsServer() then
        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.m_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if units ~= nil and not self.m_hChashedUnit then
            if #units > 0 then
                for _, unit in pairs(units) do
                    self.m_hChashedUnit = unit 

                    local iDamage = self:GetAbility():GetAbilityDamage()
                   
                    if self:GetCaster():HasTalent("special_bonus_unique_raiden_2") then iDamage = iDamage + self:GetCaster():FindTalentValue("special_bonus_unique_raiden_2") end
                    
                    iDamage = iDamage + ((self:GetAbility():GetSpecialValueFor("mine_damage_mana_ptc") / 100) * unit:GetMana())
                    
                    self:StartIntervalThink(-1)

                    Timers:CreateTimer(self:GetAbility():GetSpecialValueFor("mine_deleay_interval"), function()
                        self:OnExplosion(iDamage, self:GetParent():GetAbsOrigin()) return 
                    end)
                end
            end
        end
     end
end

function modifier_raiden_elecro_mine_thinker:OnExplosion(iDamage, vLoc)
    if IsServer() then
        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.m_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
        if units ~= nil then
            if #units > 0 then
                for _, unit in pairs(units) do
                    ---if not unit:IsIllusion() then
                        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = unit, ability = self:GetAbility(), damage = iDamage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})


                        AddNewModifier_pcall(unit, self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})                                         
                   --- end
                end
            end
        end

        EmitSoundOnLocationWithCaster(vLoc, "Hero_Zuus.LightningBolt.Cast.Righteous", self:GetAbility():GetCaster())
        EmitSoundOnLocationWithCaster(vLoc, "Hero_Zuus.LightningBolt.Righteous", self:GetAbility():GetCaster())
        EmitSoundOnLocationWithCaster(vLoc, "Hero_Zeus.BlinkDagger.Arcana", self:GetAbility():GetCaster())

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_spirit_ti8_overload_active.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, vLoc)
        ParticleManager:SetParticleControl( nFXIndex, 2, vLoc)
        ParticleManager:SetParticleControl( nFXIndex, 5, vLoc)
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        UTIL_Remove(self:GetParent())
    end 
    return
end

function modifier_raiden_elecro_mine_thinker:CheckState() return {[MODIFIER_STATE_PROVIDES_VISION] = true} end
