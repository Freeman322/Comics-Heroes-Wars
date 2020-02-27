if modifier_courier_model == nil then modifier_courier_model = class({}) end

function modifier_courier_model:IsPurgable() return false end
function modifier_courier_model:IsHidden() return true end
function modifier_courier_model:RemoveOnDeath() return false end
function modifier_courier_model:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_courier_model:OnCreated(params)
    if IsServer() then 
        self._mModel_Default = params.model or "models/items/courier/mighty_chicken/mighty_chicken.vmdl"
        self._mModel_Flying = params.model_flying or "models/items/courier/mighty_chicken/mighty_chicken_flying.vmdl"
        self._mMaterial = params.model_material
        self.speed = params.speed or 700
    end
end

function modifier_courier_model:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_courier_model:GetModifierModelChange(params)
    return self._mModel_Default
end

function modifier_courier_model:GetModifierMoveSpeed_Absolute( params )
    return self.speed
end

function modifier_courier_model:GetVisualZDelta( params )
    if self:GetParent():HasFlyMovementCapability() then 
        return 0
    end 

    return
end