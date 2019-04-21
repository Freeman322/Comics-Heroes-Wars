if not creeps_gangsta_ability then creeps_gangsta_ability = class({}) end 
LinkLuaModifier("modifier_creeps", "abilities/creeps_gangsta_ability.lua", LUA_MODIFIER_MOTION_NONE)

function creeps_gangsta_ability:GetIntrinsicModifierName()
    return "modifier_creeps"
end


if modifier_creeps == nil then modifier_creeps = class({}) end

function modifier_creeps:IsPurgable()
  return false
end

function modifier_creeps:OnCreated(table)
	if IsServer() then
		if string.find(self:GetParent():GetUnitName(), "upgraded_mega") then
	       self.dmg = math.floor(GameRules:GetGameTime()/60)*2
	       self.hp = math.floor(GameRules:GetGameTime()/60)*25
	    else
	       self.dmg = math.floor(GameRules:GetGameTime()/60)
	       self.hp = math.floor(GameRules:GetGameTime()/60)*15
	    end
	end
end

function modifier_creeps:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creeps:GetModifierExtraHealthBonus( params )
	return self.hp
end

--------------------------------------------------------------------------------

function modifier_creeps:GetModifierBaseAttack_BonusDamage( params )
	return self.dmg
end