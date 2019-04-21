if modifier_pet_model == nil then modifier_pet_model = class({}) end

function modifier_pet_model:IsPurgable() return false end
function modifier_pet_model:IsHidden() return true end
function modifier_pet_model:RemoveOnDeath() return false end
function modifier_pet_model:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_pet_model:OnCreated(params)
    if IsServer() then 
        self._mModel = params.model
    end
end

function modifier_pet_model:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}

	return funcs
end

function modifier_pet_model:GetModifierModelChange(params)
    if IsServer() then 
        return self._mModel
    end
    
    return
end

