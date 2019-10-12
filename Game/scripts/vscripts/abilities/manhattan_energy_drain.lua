LinkLuaModifier("modifier_manhattan_energy_drain_buff", "abilities/manhattan_energy_drain.lua", 0)
LinkLuaModifier("modifier_manhattan_energy_drain_debuff", "abilities/manhattan_energy_drain.lua", 0)


manhattan_energy_drain = class({})

function manhattan_energy_drain:GetCooldown(nLevel)
    return self.BaseClass.GetCooldown(self, nLevel) - (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_manhattan_energy_drain_1") or 0)
end

function manhattan_energy_drain:OnSpellStart()
    ProjectileManager:CreateTrackingProjectile({
            EffectName = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj.vpcf",
            Ability = self,
            iMoveSpeed = 2000,
            Source = self:GetCaster(),
            Target = self:GetCursorTarget(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        })
end

function manhattan_energy_drain:OnProjectileHit(hTarget, vLocation)
    local duration = self:GetSpecialValueFor("steal_duration") * (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_manhattan_energy_drain") or 1)
   
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_manhattan_energy_drain_buff", {duration = duration})
    
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_manhattan_energy_drain_debuff", {duration = duration})
    
    EmitSoundOn("Hero_Antimage.ManaBreak", hTarget)

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "uganda") then
        EmitSoundOn("Uganda.Cast2", hTarget)
    end
end


modifier_manhattan_energy_drain_buff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MANA_BONUS} end
})

function modifier_manhattan_energy_drain_buff:OnCreated() if IsServer() then self:StartIntervalThink(FrameTime()) self:SetStackCount(0) end end
function modifier_manhattan_energy_drain_buff:OnIntervalThink() self:GetParent():CalculateStatBonus() end
function modifier_manhattan_energy_drain_buff:GetModifierManaBonus() return self:GetStackCount() end


modifier_manhattan_energy_drain_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MANA_BONUS} end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_manhattan_energy_drain_debuff:OnCreated()
    if IsServer() then
        self:StartIntervalThink(FrameTime())
        local mana = self:GetParent():GetMaxMana() / 100 * 2.5
        self:SetStackCount(mana)
        modifier_manhattan_energy_drain_debuff.mana = mana * -1
        if self:GetCaster():HasModifier("modifier_manhattan_energy_drain_buff") then
            self:GetCaster():FindModifierByName("modifier_manhattan_energy_drain_buff"):SetStackCount(self:GetCaster():FindModifierByName("modifier_manhattan_energy_drain_buff"):GetStackCount() + mana)
        end
    end
end

function modifier_manhattan_energy_drain_debuff:OnIntervalThink() self:GetParent():CalculateStatBonus() end
function modifier_manhattan_energy_drain_debuff:GetModifierManaBonus() return modifier_manhattan_energy_drain_debuff.mana end
