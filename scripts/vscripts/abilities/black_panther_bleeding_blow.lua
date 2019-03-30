black_panther_bleeding_blow = class ( {})

LinkLuaModifier ("modifier_black_panther_bleeding_blow", "abilities/black_panther_bleeding_blow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_black_panther_bleeding_blow_target", "abilities/black_panther_bleeding_blow.lua", LUA_MODIFIER_MOTION_NONE)

function black_panther_bleeding_blow:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function black_panther_bleeding_blow:GetIntrinsicModifierName ()
    return "modifier_black_panther_bleeding_blow"
end

modifier_black_panther_bleeding_blow = class ( {})

function modifier_black_panther_bleeding_blow:IsHidden ()
    return true

end

function modifier_black_panther_bleeding_blow:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end


function modifier_black_panther_bleeding_blow:OnAttackLanded (params)
    if self:GetParent () == params.attacker then
        local hAbility = self:GetAbility()
        local duration = hAbility:GetSpecialValueFor ("duration")
        if hAbility:IsCooldownReady () then
            hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
            local hTarget = params.target
            EmitSoundOn ("Item_Desolator.Target", hTarget)
            hTarget:AddNewModifier (hAbility:GetCaster (), hAbility, "modifier_black_panther_bleeding_blow_target", { duration = duration })
        end
    end
end

modifier_black_panther_bleeding_blow_target = class ( {})

function modifier_black_panther_bleeding_blow_target:GetEffectName ()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_black_panther_bleeding_blow_target:GetTexture ()
    return "black_panther_bleeding_blow"
end

function modifier_black_panther_bleeding_blow_target:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        self:StartIntervalThink(1)
    end
end

function modifier_black_panther_bleeding_blow_target:OnIntervalThink ()
    if IsServer() then
        local thinker = self:GetParent()
        local damage_perc = self:GetAbility ():GetSpecialValueFor ("damage_perc")/100
        local damage = damage_perc * thinker:GetMaxHealth ()
        if thinker:IsBuilding() then
             damage =  damage / 4
        else
             damage = damage
        end
        ApplyDamage ( { attacker = self:GetAbility ():GetCaster (), victim = thinker, ability = self:GetAbility (), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function black_panther_bleeding_blow:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

