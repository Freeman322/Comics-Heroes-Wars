LinkLuaModifier ("modifier_god_emperor_inqusition", 				"abilities/god_emperor_inqusition.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_god_emperor_inqusition_passive", "abilities/god_emperor_inqusition.lua", LUA_MODIFIER_MOTION_NONE)
if god_emperor_inqusition == nil then god_emperor_inqusition = class({}) end

function god_emperor_inqusition:GetIntrinsicModifierName()
	return "modifier_god_emperor_inqusition"
end

if modifier_god_emperor_inqusition == nil then modifier_god_emperor_inqusition = class({}) end

function modifier_god_emperor_inqusition:IsAura()
	return true
end

function modifier_god_emperor_inqusition:IsHidden()
	return true
end

function modifier_god_emperor_inqusition:IsPurgable()
	return true
end

function modifier_god_emperor_inqusition:GetAuraRadius()
	return 99999
end

function modifier_god_emperor_inqusition:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_god_emperor_inqusition:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_god_emperor_inqusition:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_god_emperor_inqusition:GetModifierAura()
	return "modifier_god_emperor_inqusition_passive"
end

if modifier_god_emperor_inqusition_passive == nil then modifier_god_emperor_inqusition_passive = class({}) end

function modifier_god_emperor_inqusition_passive:OnCreated(htable)
    if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_god_emperor_inqusition_passive:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetParent()

	if parent:IsCreep() or parent:IsCreature() then
		local flDist = (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
		if flDist <= 1000 then
			self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
		else
			self.damage = 0
		end
	elseif parent:IsHero() then
		self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	else
		self.damage = 0
	end
	print(self.damage)
	self:ForceRefresh()
end

function modifier_god_emperor_inqusition_passive:IsPurgable(  )
    return false
end

function modifier_god_emperor_inqusition_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_god_emperor_inqusition_passive:GetModifierDamageOutgoing_Percentage( params )
    return self.damage
end

function god_emperor_inqusition:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

