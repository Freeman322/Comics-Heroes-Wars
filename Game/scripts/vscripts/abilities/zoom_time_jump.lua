zoom_time_jump = class({})
LinkLuaModifier( "modifier_zoom_time_jump", "abilities/zoom_time_jump.lua", LUA_MODIFIER_MOTION_NONE )

function zoom_time_jump:ProcsMagicStick()
	return false
end


function zoom_time_jump:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_zoom_time_jump", nil )
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_zoom_time_jump" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

if modifier_zoom_time_jump == nil then modifier_zoom_time_jump = class({}) end

function modifier_zoom_time_jump:IsHidden()
	return true
end

function modifier_zoom_time_jump:IsPurgable()
	return false
end

function modifier_zoom_time_jump:OnCreated(args)
  if IsServer() then
    self.vPoint = self:GetParent():GetAbsOrigin()
    EmitSoundOn("Hero_Medusa.ManaShield.On", self:GetParent())
  end
end

function modifier_zoom_time_jump:OnDestroy()
   if IsServer() then
     if self.vPoint and self:GetParent():GetHealth() > 0 then
       self:GetParent():SetAbsOrigin(self.vPoint)
     end
     self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("cooldown"))
   end
end

function zoom_time_jump:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_doomsday_clock") then return "custom/reverse_speed_back" end
	return self.BaseClass.GetAbilityTextureName(self) 
end
