pudge_jab = class({})
LinkLuaModifier( "modifier_pudge_jab", "abilities/pudge_jab.lua", LUA_MODIFIER_MOTION_NONE )

function pudge_jab:GetIntrinsicModifierName()
     return "modifier_pudge_jab"
end

function pudge_jab:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function pudge_jab:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
        end
    end
end

if modifier_pudge_jab == nil then modifier_pudge_jab = class({}) end

function modifier_pudge_jab:IsHidden()
    return false
end

function modifier_pudge_jab:IsPurgable()
    return false
end

function modifier_pudge_jab:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
    }

    return funcs
end

function modifier_pudge_jab:GetModifierProcAttack_BonusDamage_Pure (params)
    if IsServer () then
        if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
            if not params.target:IsBuilding() and not params.target:IsAncient() then
                params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})

                self:GetAbility():PayManaCost()
                self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

                EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", self:GetParent())
                EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)

                local flDamage = self:GetParent():GetHealth() * (self:GetAbility():GetSpecialValueFor("health_conversion") / 100)

                ApplyDamage ( {
                    victim = self:GetParent(),
                    attacker = self:GetParent(),
                    damage = flDamage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
                })

                return flDamage
            end
        end
    end
    return 0
end

