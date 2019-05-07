LinkLuaModifier("modifier_golden_god_penitence", "abilities/golden_god_penitence", LUA_MODIFIER_MOTION_NONE)

golden_god_penitence = class ({})

function golden_god_penitence:OnSpellStart()
    if IsServer() then
        ProjectileManager:CreateTrackingProjectile({
            EffectName = "particles/goldengod/goldengod_penitence_proj.vpcf",
            Ability = self,
            iMoveSpeed = self:GetSpecialValueFor("speed"),
            Source = self:GetCaster(),
            Target = self:GetCursorTarget(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
        })
        EmitSoundOn("Hero_Chen.PenitenceCast", self:GetCaster())
    end
end

function golden_god_penitence:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and hTarget:IsInvulnerable() == false and hTarget:TriggerSpellAbsorb(self) == false and hTarget:IsMagicImmune() == false then
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_golden_god_penitence", { duration = self:GetSpecialValueFor("duration") })
    end
    EmitSoundOn("Hero_Chen.PenitenceImpact", hTarget)
    return true
end

modifier_golden_god_penitence = class ({})

function modifier_golden_god_penitence:IsHidden() return false end
function modifier_golden_god_penitence:IsPurgable() return true end

function modifier_golden_god_penitence:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_golden_god_penitence:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") * -1 end
function modifier_golden_god_penitence:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_damage_taken") end
function modifier_golden_god_penitence:GetEffectName() return "particles/goldengod/goldengod_penitence_debuff.vpcf" end
function modifier_golden_god_penitence:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
