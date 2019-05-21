odin_sacred_purge = class({})
LinkLuaModifier( "modifier_odin_sacred_purge", "abilities/odin_sacred_purge.lua", LUA_MODIFIER_MOTION_NONE)

function odin_sacred_purge:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function odin_sacred_purge:OnSpellStart( )
    local caster = self:GetCaster()
    local point = self:GetCaster():GetCursorPosition()

    local nearby_units = FindUnitsInRadius(caster:GetTeam(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    for i, target in ipairs(nearby_units) do
        EmitSoundOn( "Hero_Omniknight.Purification.Wingfall", target )
        
        local nFXIndex = ParticleManager:CreateParticle( "particles/odin/sacred_purge.vpcf", PATTACH_WORLDORIGIN, target )
        ParticleManager:SetParticleControl( nFXIndex, 0, target:GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 100, 1, 1 ) )
        ParticleManager:SetParticleControl( nFXIndex, 2, target:GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 3, target:GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 4, target:GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 5, target:GetAbsOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        -- Play named sound on Entity
        target:Purge( false, true, false, true, false )
        
        if target:GetTeamNumber(  ) ~= caster:GetTeamNumber() then
            target:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
            ApplyDamage({victim = target, attacker = caster, ability = self, damage = self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_PURE})
        else
            target:Heal( self:GetAbilityDamage(), caster )
            target:AddNewModifier(caster, self, "modifier_odin_sacred_purge", {duration = self:GetSpecialValueFor("stun_duration")})
        end
    end
end

if modifier_odin_sacred_purge == nil then
    modifier_odin_sacred_purge = class ( {})
end

function modifier_odin_sacred_purge:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_odin_sacred_purge:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_odin_sacred_purge:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_odin_sacred_purge:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_odin_sacred_purge:HeroEffectPriority()
	return 100
end

function modifier_odin_sacred_purge:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_odin_sacred_purge:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_odin_sacred_purge:OnCreated( table )
    if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function odin_sacred_purge:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

