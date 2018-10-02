if modifier_strange_eternal_bracers == nil then modifier_strange_eternal_bracers = class({}) end


function modifier_strange_eternal_bracers:IsHidden()
	return true
end

function modifier_strange_eternal_bracers:IsPurgable()
	return false
end

function modifier_strange_eternal_bracers:RemoveOnDeath()
	return false
end

function modifier_strange_eternal_bracers:OnCreated(params)
    if IsServer() then 
        self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_bane/bane_projectile.vpcf")
    end 
end

function modifier_strange_eternal_bracers:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_strange_eternal_bracers:GetAttackSound( params )
    return "Hero_Invoker.Attack"
end
