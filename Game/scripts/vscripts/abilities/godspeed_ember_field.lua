if not godspeed_ember_field then godspeed_ember_field = class({}) end

function godspeed_ember_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

LinkLuaModifier ("modifier_godspeed_ember_field", "abilities/godspeed_ember_field.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_ember_field:GetIntrinsicModifierName()
	return "modifier_godspeed_ember_field"
end

function godspeed_ember_field:SetStacks(stacks)
	local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())

	if mod then
		mod:SetStackCount(stacks)
	end 
end


function godspeed_ember_field:Killed()
	local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())

	if mod then
		mod:IncrementStackCount()
	end
end


function godspeed_ember_field:GetStacks()
	local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())

	if mod then
		return mod:GetStackCount()
	end 

	return 0
end

function godspeed_ember_field:OnOwnerDied()
	if IsServer() then
		local stacks = self:GetStacks() - 1
		if stacks <= 0 then stacks = 1 end  

		self:SetStacks(stacks)
	end
end

if modifier_godspeed_ember_field == nil then modifier_godspeed_ember_field = class({}) end

modifier_godspeed_ember_field.m_iMaxSpeedLimit = 0

function modifier_godspeed_ember_field:OnCreated(params)
	self.m_iMaxSpeedLimit = self:GetAbility():GetSpecialValueFor("max_gain")
end

function modifier_godspeed_ember_field:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}

	return funcs
end

function modifier_godspeed_ember_field:OnHeroKilled(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetAbility():Killed()

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

function modifier_godspeed_ember_field:GetModifierMoveSpeedBonus_Constant(params)
	local speed = self:GetStackCount() * self:GetAbility():GetSpecialValueFor("speed_gain")

	if speed > self.m_iMaxSpeedLimit then speed = self.m_iMaxSpeedLimit end 
		
	return speed
end

function modifier_godspeed_ember_field:GetModifierIgnoreMovespeedLimit(params)
	return 1
end

function modifier_godspeed_ember_field:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
 end

function modifier_godspeed_ember_field:IsHidden() return true end
function modifier_godspeed_ember_field:IsPurgable() return false end
function modifier_godspeed_ember_field:RemoveOnDeath() return false end
