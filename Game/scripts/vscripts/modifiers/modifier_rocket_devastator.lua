if modifier_rocket_devastator == nil then modifier_rocket_devastator = class({}) end

function modifier_rocket_devastator:IsAura()
	return false
end

function modifier_rocket_devastator:IsHidden()
	return true
end

function modifier_rocket_devastator:IsPurgable()
	return false
end

function modifier_rocket_devastator:RemoveOnDeath()
	return false
end

function modifier_rocket_devastator:OnCreated(params)
    if IsServer() then 
        self:GetCaster():SetRangedProjectileName("particles/items4_fx/nullifier_proj.vpcf")
    end
end

function modifier_rocket_devastator:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_rocket_devastator:GetAttackSound( params )
    return "DOTA_Item.Nullifier.Cast"
end
