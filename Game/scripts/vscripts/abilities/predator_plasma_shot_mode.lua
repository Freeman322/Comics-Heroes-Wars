if predator_plasma_shot_mode == nil then predator_plasma_shot_mode = class({}) end

LinkLuaModifier( "modifier_predator_plasma_shot_mode", "abilities/predator_plasma_shot_mode.lua", LUA_MODIFIER_MOTION_NONE )

function predator_plasma_shot_mode:ProcsMagicStick()
	return false
end

function predator_plasma_shot_mode:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_predator_plasma_shot_mode", nil )
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_predator_plasma_shot_mode" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

if modifier_predator_plasma_shot_mode == nil then modifier_predator_plasma_shot_mode = class({}) end

function modifier_predator_plasma_shot_mode:IsHidden()
    return false
end

function modifier_predator_plasma_shot_mode:RemoveOnDeath()
    return false
end

function modifier_predator_plasma_shot_mode:IsPurgable()
    return false
end

function predator_plasma_shot_mode:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

