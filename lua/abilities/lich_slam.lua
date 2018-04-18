if lich_slam == nil then lich_slam = class({}) end
LinkLuaModifier("modifier_slowing_lich", "abilities/lich_slam.lua", LUA_MODIFIER_MOTION_NONE)

function lich_slam:IsRefreshable()
    return false
end

function lich_slam:IsStealable()
    return false
end

function lich_slam:OnSpellStart()
    local caster = self:GetCaster()
    local spawn_location = caster:GetAbsOrigin()
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, Vector(0, 0, 0))
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(250, 250, 250))
    EmitSoundOn( "Hero_Ancient_Apparition.IceBlast.Target", self:GetCaster() )
    EmitSoundOn( "HHero_Crystal.CrystalNova", self:GetCaster() )
    EmitSoundOn( "hero_Crystal.CrystalNovaCast", self:GetCaster() )

    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("range"), 5, 0))
    ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))

    local targets = FindUnitsInRadius(caster:GetTeamNumber(), spawn_location, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for i = 1, #targets do
        local target = targets[i]
        local origin = target:GetAbsOrigin()
        target:AddNewModifier(caster, self, "modifier_slowing_lich", {duration = self:GetSpecialValueFor("slow_duration_unit")})
 		    ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage() + (target:GetMaxHealth()/2), damage_type = DAMAGE_TYPE_PURE, ability = self})
    end
    caster:Purge(false, true, false, true, true)
end

if modifier_slowing_lich == nil then modifier_slowing_lich = class({}) end


function modifier_slowing_lich:IsPurgable()
	return false
end


function modifier_slowing_lich:GetStatusEffectName()
	return "particles/status_fx/status_effect_wyvern_curse_target.vpcf"
end


function modifier_slowing_lich:StatusEffectPriority()
	return 1000
end


function modifier_slowing_lich:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end


function modifier_slowing_lich:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_slowing_lich:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_slowing_lich:GetModifierAttackSpeedBonus_Constant()
	return -200
end

function lich_slam:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

