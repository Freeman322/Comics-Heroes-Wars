LinkLuaModifier ("modifier_scarlet_witch_scarlet_magic", "abilities/scarlet_witch_scarlet_magic.lua", 0)

scarlet_witch_scarlet_magic = class({})

function scarlet_witch_scarlet_magic:CastFilterResultTarget(hTarget)
    if IsServer () then
        local nResult = UnitFilter(hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function scarlet_witch_scarlet_magic:GetAbilityDamageType() return self:GetCaster():HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL end
function scarlet_witch_scarlet_magic:GetCooldown(nLevel) return self:GetCaster():HasScepter() and self:GetSpecialValueFor("cooldown_scepter") or self.BaseClass.GetCooldown(self, nLevel) end
function scarlet_witch_scarlet_magic:GetCastRange(vLocation, hTarget) return self:GetCaster():HasScepter() and self:GetSpecialValueFor ("cast_range_scepter") or self.BaseClass.GetCastRange(self, vLocation, hTarget) end

function scarlet_witch_scarlet_magic:OnSpellStart()
    if self:GetCursorTarget() ~= nil then
        if not self:GetCursorTarget():TriggerSpellAbsorb (self) then
            ProjectileManager:CreateTrackingProjectile ({
                EffectName = "particles/scarlet_witch_flux.vpcf",
                Ability = self,
                iMoveSpeed = 1500,
                Source = self:GetCaster(),
                Target = self:GetCursorTarget(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            })
            EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster())
        end
        EmitSoundOn ("Hero_VengefulSpirit.MagicMissile", self:GetCaster())
    end
end

function scarlet_witch_scarlet_magic:OnProjectileHit (hTarget, vLocation)
    if self:GetCaster():HasModifier("modifier_arcana") then
		EmitSoundOn ("Hero_Nightstalker.Void.Nihility", hTarget)
	else
        EmitSoundOn ("Hero_VengefulSpirit.MagicMissileImpact", hTarget)
    end
    hTarget:AddNewModifier(self:GetCaster (), self, "modifier_scarlet_witch_scarlet_magic", {duration = self:GetSpecialValueFor("duration")})
    if self:GetCaster():HasScepter() then
        hTarget:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("scarlet_witch_unstable_energy"), "modifier_scarlet_witch_unstable_energy", {duration = self:GetSpecialValueFor("duration")})
    end
    return true
end

modifier_scarlet_witch_scarlet_magic = class({
    IsHidden = function() return false end,
    IsBuff = function() return false end,
    IsPurgable = function() return false end,
    StatusEffectPriority = function() return 1000 end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
    GetModifierMoveSpeedBonus_Percentage = function() return -1000 end
})

function modifier_scarlet_witch_scarlet_magic:GetStatusEffectName()
    if self:GetCaster():HasModifier("modifier_arcana") then return "particles/status_fx/status_effect_fiendsgrip.vpcf" end
    return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end
function modifier_scarlet_witch_scarlet_magic:GetEffectName()
    if self:GetCaster():HasModifier("modifier_arcana") then return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf" end
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_scarlet_witch_scarlet_magic:OnCreated() if not IsServer() then return end self:StartIntervalThink(1) end
function modifier_scarlet_witch_scarlet_magic:OnIntervalThink()
    if not IsServer() then return end
    local hp_damage = self:GetParent():GetMaxHealth() * (0.01 * (self:GetCaster():HasScepter() and self:GetAbility():GetSpecialValueFor("damage_scepter") or self:GetAbility():GetSpecialValueFor("damage")))
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        ability = self:GetAbility(),
        damage = hp_damage + self:GetAbility():GetSpecialValueFor("base_damage"),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION}) 
end

function scarlet_witch_scarlet_magic:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then return "custom/vititate_nightmare" end
	return self.BaseClass.GetAbilityTextureName(self)
end
