if enigma_vacuum == nil then enigma_vacuum = class({}) end

LinkLuaModifier("modifier_enigma_vacuum", "abilities/enigma_vacuum.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enigma_vacuum_aura", "abilities/enigma_vacuum.lua", LUA_MODIFIER_MOTION_NONE)

function enigma_vacuum:ProcsMagicStick() return false end
function enigma_vacuum:GetIntrinsicModifierName() return "modifier_enigma_vacuum_aura" end

function enigma_vacuum:OnToggle()
    if self:GetToggleState() then
        if not self:GetCaster():IsChanneling() then
            self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_3 )
        end
    end
end


if modifier_enigma_vacuum_aura == nil then modifier_enigma_vacuum_aura = class({}) end

function modifier_enigma_vacuum_aura:IsAura() return true end
function modifier_enigma_vacuum_aura:IsHidden() return true end
function modifier_enigma_vacuum_aura:IsPurgable() return true end
function modifier_enigma_vacuum_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_enigma_vacuum_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_enigma_vacuum_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_enigma_vacuum_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_enigma_vacuum_aura:GetModifierAura() return "modifier_enigma_vacuum" end

if modifier_enigma_vacuum == nil then modifier_enigma_vacuum = class({}) end

function modifier_enigma_vacuum:OnCreated(htable)
    if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_enigma_vacuum:OnIntervalThink()
    if IsServer() and self:GetAbility():GetToggleState() then
        local parent = self:GetParent()
        local target_location = self:GetCaster():GetAbsOrigin()

        local speed = self:GetAbility():GetSpecialValueFor("speed")
        if self:GetCaster():HasTalent("special_bonus_unique_infinity") then
            local value = self:GetCaster():FindTalentValue("special_bonus_unique_infinity")
            speed = speed + value
        end
        speed = speed * 0.03

        local unit_location = parent:GetAbsOrigin()
        local vector_distance = target_location - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()
        -- If the target is greater than 40 units from the center, we move them 40 units towards it, otherwise we move them directly to the center
        if distance >= 80 then
            local pos = unit_location + direction * speed

            parent:SetAbsOrigin(pos)

            FindClearSpaceForUnit(parent, pos, false)
        end

        ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = parent, ability = self:GetAbility(), damage = self:GetCaster():GetIntellect() * FrameTime() * self:GetAbility():GetSpecialValueFor("damage_mult"), damage_type = self:GetAbility():GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
    end
end

function modifier_enigma_vacuum:OnDestroy()
    if IsServer() then
        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
    end
end
function enigma_vacuum:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

