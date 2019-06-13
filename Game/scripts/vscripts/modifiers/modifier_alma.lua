if modifier_alma == nil then modifier_alma = class({}) end

function modifier_alma:IsAura()
	return false
end

function modifier_alma:IsHidden()
	return true
end

function modifier_alma:IsPurgable()
	return false
end

function modifier_alma:RemoveOnDeath()
	return false
end

function modifier_alma:OnCreated(params)
    if IsServer() then 
        self:GetCaster():SetRangedProjectileName("particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle_crimson.vpcf")

        Timers:CreateTimer(1, function()
            if self:GetParent().wearables["__head"] ~= nil then
                self:GetParent().wearables["__head"]:RemoveSelf()
            end
        end)
    end
end

function modifier_alma:GetEffectName()
    return "particles/collector/alma_ambient.vpcf"
end

function modifier_alma:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_alma:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_alma:GetAttackSound( params )
    return "Hero_Grimstroke.Attack"
end
