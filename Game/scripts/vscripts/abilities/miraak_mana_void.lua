LinkLuaModifier("modifier_miraak_mana_void", "abilities/miraak_mana_void.lua", 0)
miraak_mana_void = class({GetIntrinsicModifierName = function() return "modifier_miraak_mana_void" end})
function miraak_mana_void:GetManaCost(iLevel) return self:GetSpecialValueFor("mana_damage") end

modifier_miraak_mana_void = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})
function modifier_miraak_mana_void:OnCreated() self.void = false end
function modifier_miraak_mana_void:OnAttackLanded (params)
    if not IsServer () then return end
    if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.void) then
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})
        ApplyDamage({
            victim = params.target,
            attacker = self:GetCaster(),
            damage = self:GetAbility():GetSpecialValueFor("mana_damage") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_miraak_1") or 0),
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        })

        if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "emerald_whale_blade") == true then
            EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice.TI8", params.target)

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_ti8_immortal_pitofmalice.vpcf", PATTACH_CUSTOMORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0,  params.target:GetAbsOrigin() )
            ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(200, 1, 1) )
            ParticleManager:SetParticleControl( nFXIndex, 2,  Vector(1, 0, 0))
            ParticleManager:SetParticleControl( nFXIndex, 6,  Vector(255, 255, 255) )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
        else
            EmitSoundOn("Hero_Antimage.ManaBreak", params.target)
        end

        self:GetAbility():UseResources(true, false, true)
        self.void = false
    end
end
function modifier_miraak_mana_void:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.void = true
        else
            self.void = false
        end
    end
end
