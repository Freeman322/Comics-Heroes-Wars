if modifier_voland_custom == nil then modifier_voland_custom = class({}) end

function modifier_voland_custom:IsAura()
	return false
end

function modifier_voland_custom:IsHidden()
	return true
end

function modifier_voland_custom:IsPurgable()
	return false
end

function modifier_voland_custom:RemoveOnDeath()
	return false
end

function modifier_voland_custom:OnCreated(params)
    if IsServer() then 
        self:GetCaster():SetRangedProjectileName("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf")
    end
end

function modifier_voland_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_voland_custom:GetAttackSound( params )
    return "Hero_Pugna.NetherWard.Attack.Wight"
end
