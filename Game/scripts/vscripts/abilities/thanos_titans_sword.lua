LinkLuaModifier("modifier_thanos_titans_sword", "abilities/thanos_titans_sword.lua", 0)
thanos_titans_sword = class({GetIntrinsicModifierName = function() return "modifier_thanos_titans_sword" end})
modifier_thanos_titans_sword = class ({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})

function modifier_thanos_titans_sword:OnCreated()  self.sword = false end
function modifier_thanos_titans_sword:OnAttackLanded (params)
     if not IsServer () then return end
     if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.sword) and not (params.target:IsMagicImmune() or params.target:IsBuilding()) then
         local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_thanos_3") or 0), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)
         if #units > 0 then
             for _,unit in pairs(units) do
                 unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})

                EmitSoundOn("Hero_DoomBringer.Attack.Impact", unit)
                ApplyDamage({
                    attacker = self:GetParent(),
                    victim = unit,
                    damage = params.original_damage + (self:GetAbility():GetSpecialValueFor("bonus_damage") / 100) * unit:GetMaxHealth(),
                    damage_type = self:GetAbility():GetAbilityDamageType(),
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS
                })
            end
        end

        self:GetAbility():PayManaCost()
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1))
        self.sword = false
    end
end
function modifier_thanos_titans_sword:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.sword = true
        else
            self.sword = false
        end
    end
end
function modifier_thanos_titans_sword:OnAttackStart (params)
     if not IsServer () then return end
     if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.sword) and not (params.target:IsMagicImmune() or params.target:IsBuilding()) then
         self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK)
         self:GetCaster():RemoveGesture(ACT_DOTA_ATTACK2)
         self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)
    end
end
