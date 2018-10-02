odin_flux = class ( {})

LinkLuaModifier ("modifier_odin_flux", "abilities/odin_flux.lua", LUA_MODIFIER_MOTION_NONE)

function odin_flux:OnSpellStart ()
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

function odin_flux:OnProjectileHit (hTarget, vLocation)
    EmitSoundOn ("Hero_VengefulSpirit.MagicMissileImpact", hTarget)
    local duration = self:GetSpecialValueFor ("duration")
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_odin_flux", { duration = duration } )
    return true
end

modifier_odin_flux = class ( {})

function modifier_odin_flux:IsHidden()
    return false
end

function modifier_odin_flux:IsBuff()
    return false
end

function modifier_odin_flux:IsPurgable()
    return false
end
function modifier_odin_flux:GetStatusEffectName()
    return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_odin_flux:StatusEffectPriority()
    return 1000
end

function modifier_odin_flux:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_odin_flux:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_odin_flux:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function modifier_odin_flux:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent ()
        local hAbility = self:GetAbility ()

        local damage = hAbility:GetSpecialValueFor ("damage_per_second")
        ApplyDamage ( { attacker = self:GetCaster (), victim = thinker, ability = hAbility, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end
function modifier_odin_flux:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_odin_flux:GetModifierMoveSpeedBonus_Percentage (params)
    local hAbility = self:GetAbility ()

    return hAbility:GetSpecialValueFor ("slowing")
end
function modifier_odin_flux:GetModifierMagicalResistanceBonus( params )
	local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("magical_armor")
end

function odin_flux:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

