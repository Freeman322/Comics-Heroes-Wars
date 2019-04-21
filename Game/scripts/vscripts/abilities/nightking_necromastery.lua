LinkLuaModifier("modifier_nightking_necromastery", "abilities/nightking_necromastery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_nightking_necromastery_undead", "abilities/nightking_necromastery.lua", LUA_MODIFIER_MOTION_NONE )

nightking_necromastery = class({})

--------------------------------------------------------------------------------

function nightking_necromastery:OnSpellStart()
    if IsServer() then 
        local radius = self:GetSpecialValueFor( "radius" ) 
        local duration = self:GetSpecialValueFor(  "duration_tooltip" )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                if unit:GetHealth() <= 0 then 
                    local unit = unit:CreateIllusion(self:GetCaster(), self, (unit:GetTimeUntilRespawn() or duration))
                    unit:AddNewModifier(self:GetCaster(), self, "modifier_nightking_necromastery_undead", nil)
                end
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Lich.FrostArmorDamage", self:GetCaster() )
    end
end


modifier_nightking_necromastery_undead = class({})

function modifier_nightking_necromastery_undead:GetStatusEffectName()
	return "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf"
end

function modifier_nightking_necromastery_undead:IsHidden()
	return true
end

function modifier_nightking_necromastery_undead:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_nightking_necromastery_undead:GetEffectName()
	return "particles/hero_nightking/nightking_frost_debuff.vpcf"
end

function modifier_nightking_necromastery_undead:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_nightking_necromastery_undead:IsPurgable()
	return false
end
