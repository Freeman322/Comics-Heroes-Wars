LinkLuaModifier("modifier_alien_jump", "abilities/alien_jump.lua", 1)
LinkLuaModifier("modifier_alien_jump_as_bonus", "abilities/alien_jump.lua", 0)

alien_jump = class({})

function alien_jump:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alien_jump", {ent_index = self:GetCursorTarget():GetEntityIndex()})
end

modifier_alien_jump = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    CheckState = function() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true} end
})

function modifier_alien_jump:OnCreated(params)
    if not IsServer() then return end
    self.target = EntIndexToHScript(params.ent_index)
    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_alien_jump:UpdateHorizontalMotion(me, dt)
    if not IsServer() then return end
    me:FaceTowards(self.target:GetOrigin())
    local distance = (self.target:GetOrigin() - me:GetOrigin()):Normalized()
    me:SetOrigin(me:GetOrigin() + distance * self:GetAbility():GetSpecialValueFor("jump_speed") * dt)
    if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 or (self.target:GetOrigin() - me:GetOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("jump_break_range") or self:GetParent():IsHexed() or self:GetParent():IsStunned() then
        self:Destroy()
    end
end

function modifier_alien_jump:OnHorizontalMotionInterrupted() self:Destroy() end

function modifier_alien_jump:OnDestroy()
    if not IsServer() then return end
    self:GetParent():RemoveHorizontalMotionController(self)
    if self:GetParent():HasModifier("modifier_alien_jump") then
        self:GetParent():RemoveModifierByName("modifier_alien_jump")
    end
    if (self.target:GetOrigin() - self:GetParent():GetOrigin()):Length2D() <= 128 then
        if self.target:TriggerSpellAbsorb(self) then return end
        ApplyDamage({
            victim = self.target,
            attacker = self:GetCaster(),
            ability = self:GetAbility(),
            damage = self:GetAbility():GetSpecialValueFor("damage"),
            damage_type = self:GetAbility():GetAbilityDamageType()
        })
        for _, enemies in pairs (FindUnitsInRadius(self:GetCaster():GetTeam(), self.target:GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("stun_range"), self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), 0, false)) do
            enemies:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
        end
        self:GetCaster():PerformAttack(self.target, true, true, false, false, false, false, false)
        self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alien_jump_as_bonus", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
    end
end

modifier_alien_jump_as_bonus = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
})

function modifier_alien_jump_as_bonus:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("as_bonus") end
