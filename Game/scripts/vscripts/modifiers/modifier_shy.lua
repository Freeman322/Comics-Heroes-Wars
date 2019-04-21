
if modifier_shy == nil then modifier_shy = class({}) end

function modifier_shy:IsHidden()
	return false
end

function modifier_shy:IsPurgable()
    return false
end

function modifier_shy:RemoveOnDeath()
    return false
end

function modifier_shy:CheckState()
    if self:GetStackCount() == 1 then return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true } end 
    if self:GetStackCount() == 2 then return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVULNERABLE] = true } end 
    return 
end

function modifier_shy:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
return funcs
end

function modifier_shy:GetModifierMoveSpeed_Absolute()
	return 1000
end

function modifier_shy:OnCreated(params)
    if IsServer() then 
        self._vPosition = self:GetParent():GetAbsOrigin()

        self:StartIntervalThink(0.1)   
    end 
end

function modifier_shy:OnIntervalThink()
  if IsServer() then
    if (self:GetParent():GetAbsOrigin() - self._vPosition):Length2D() > 1500 then 
        self:SetStackCount(2)
    else 
        self:SetStackCount(1)
    end 
  end 
end