scarlet_witch_scarlet_magic = class ( {})

LinkLuaModifier ("modifier_scarlet_witch_scarlet_magic", "abilities/scarlet_witch_scarlet_magic.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function scarlet_witch_scarlet_magic:CastFilterResultTarget (hTarget)
    if IsServer () then
        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function scarlet_witch_scarlet_magic:GetAbilityDamageType()
    return DAMAGE_TYPE_MAGICAL
end

function scarlet_witch_scarlet_magic:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return 40
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end
--------------------------------------------------------------------------------

function scarlet_witch_scarlet_magic:GetCastRange (vLocation, hTarget)
    if self:GetCaster ():HasScepter () then
        return self:GetSpecialValueFor ("cast_range_scepter")
    end

    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

--------------------------------------------------------------------------------

function scarlet_witch_scarlet_magic:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local info = {
                EffectName = "particles/scarlet_witch_flux.vpcf",
                Ability = self,
                iMoveSpeed = 1500,
                Source = self:GetCaster (),
                Target = self:GetCursorTarget (),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile (info)
            EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
        end
        EmitSoundOn ("Hero_VengefulSpirit.MagicMissile", self:GetCaster () )
    end
end

function scarlet_witch_scarlet_magic:OnProjectileHit (hTarget, vLocation)
    if self:GetCaster():HasModifier("modifier_arcana") then
		EmitSoundOn ("Hero_Nightstalker.Void.Nihility", hTarget)
	else
        EmitSoundOn ("Hero_VengefulSpirit.MagicMissileImpact", hTarget)
    end
    local duration = self:GetSpecialValueFor ("duration")
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_scarlet_witch_scarlet_magic", { duration = duration } )
    if self:GetCaster():HasScepter() then
        Timers:CreateTimer(5, function()
            local scarlet_m = self:GetCaster():GetAbilityByIndex(0)
            local bourder = scarlet_m:GetLevelSpecialValueFor("damage_on_destroy", scarlet_m:GetLevel() - 1)
            local bourder_dmg = scarlet_m:GetLevelSpecialValueFor("damage", scarlet_m:GetLevel() - 1)

            ApplyDamage ( { attacker = self:GetCaster(), victim = hTarget, ability = hAbility, damage = bourder_dmg, damage_type = self:GetAbilityDamageType()})
            if hTarget:GetHealthPercent() <= bourder then
                hTarget:Kill(self, self:GetCaster())
            end
        end)
    end
    return true
end

modifier_scarlet_witch_scarlet_magic = class ( {})

function modifier_scarlet_witch_scarlet_magic:IsHidden()
    return false
end

function modifier_scarlet_witch_scarlet_magic:IsBuff()
    return false
end

function modifier_scarlet_witch_scarlet_magic:IsPurgable()
    return false
end
function modifier_scarlet_witch_scarlet_magic:GetStatusEffectName()
    if self:GetCaster():HasModifier("modifier_arcana") then
		return "particles/status_fx/status_effect_fiendsgrip.vpcf"
	end
    return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_scarlet_witch_scarlet_magic:StatusEffectPriority()
    return 1000
end

function modifier_scarlet_witch_scarlet_magic:GetEffectName()
    if self:GetCaster():HasModifier("modifier_arcana") then
		return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"
	end
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_scarlet_witch_scarlet_magic:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_scarlet_witch_scarlet_magic:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_scarlet_witch_scarlet_magic:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent ()
        local hAbility = self:GetAbility ()

        print(hAbility:GetAbilityDamageType())
        local thinker_pos = thinker:GetAbsOrigin ()
        if self:GetCaster ():HasScepter () then
            damage_pers = hAbility:GetSpecialValueFor ("damage_scepter")/100
            damage_base = hAbility:GetSpecialValueFor ("base_damage")
        else
            damage_pers = hAbility:GetSpecialValueFor ("damage")/100
            damage_base = hAbility:GetSpecialValueFor ("base_damage")
        end
        local damage = (thinker:GetMaxHealth () * damage_pers) + damage_base

        ApplyDamage ( { attacker = self:GetCaster (), victim = thinker, ability = hAbility, damage = damage, damage_type = hAbility:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS})
    end
end
function modifier_scarlet_witch_scarlet_magic:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_scarlet_witch_scarlet_magic:GetModifierMoveSpeedBonus_Percentage (params)
    return (-100)
end

function scarlet_witch_scarlet_magic:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/vititate_nightmare"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end