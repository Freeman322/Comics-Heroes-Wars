if modifier_joker_custom == nil then modifier_joker_custom = class({}) end

function modifier_joker_custom:IsAura()
	return false
end

function modifier_joker_custom:IsHidden()
	return true
end

function modifier_joker_custom:IsPurgable()
	return false
end

function modifier_joker_custom:RemoveOnDeath()
	return false
end

function modifier_joker_custom:OnCreated(params)
    if IsServer() then 
        self:GetCaster():SetRangedProjectileName("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf")
    end
end

function modifier_joker_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_joker_custom:GetAttackSound( params )
    return "Hero_DragonKnight.DragonTail.Target"
end
