LinkLuaModifier ("modifier_lich_stealer", "abilities/lich_stealer.lua", LUA_MODIFIER_MOTION_NONE)
---LinkLuaModifier ("modifier_lich_aura_passive", "abilities/lich_stealer.lua", LUA_MODIFIER_MOTION_NONE)
lich_stealer = class({})

function lich_stealer:GetIntrinsicModifierName()
	return "modifier_lich_stealer"
end

modifier_lich_stealer = class({})

function modifier_lich_stealer:IsHidden()
	return true
end

function modifier_lich_stealer:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_lich_stealer:GetModifierProcAttack_BonusDamage_Physical (params)
 	if self.bonus_damage == nil then
 		self.bonus_damage = 0
 	end
    return self.bonus_damage
end


function modifier_lich_stealer:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            self.bonus_damage = target:GetHealth()*(self:GetAbility():GetSpecialValueFor("hp_leech_percent")/100)
            if target:IsBuilding() or target:IsConsideredHero() then
            	self.bonus_damage = 0
            end
        end
    end

    return 0
end

function modifier_lich_stealer:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            local heal = target:GetHealth()*(self:GetAbility():GetSpecialValueFor("hp_leech_percent")/100)
            if not target:IsBuilding() then
                self:GetParent ():Heal(heal, self:GetParent ())
                local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
                local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
                ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
            end
        end
    end

    return 0
end

function lich_stealer:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

