LinkLuaModifier ("modifier_death_touch_of_death_debuff", "abilities/death_touch_of_death.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_death_touch_of_death", "abilities/death_touch_of_death.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_death_touch_of_death_debuff_parcticle", "abilities/death_touch_of_death.lua", LUA_MODIFIER_MOTION_NONE)

death_touch_of_death = class ( {})

function death_touch_of_death:GetIntrinsicModifierName ()
    return "modifier_death_touch_of_death"
end

modifier_death_touch_of_death = class ( {})


function modifier_death_touch_of_death:IsHidden ()
    return true
end


function modifier_death_touch_of_death:RemoveOnDeath ()
    return true
end


function modifier_death_touch_of_death:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end


function modifier_death_touch_of_death:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then

            local target = params.target
            if target:IsRealHero () then
                local hAbility = self:GetAbility ()
                local damage_per_stack = hAbility:GetSpecialValueFor ("damage_per_stack")
                target:AddNewModifier (self:GetCaster (), hAbility, "modifier_death_touch_of_death_debuff", nil)
                target:AddNewModifier (self:GetCaster (), hAbility, "modifier_death_touch_of_death_debuff_parcticle", nil)
                local debuff = target:FindModifierByName ("modifier_death_touch_of_death_debuff")
                local debuff_counts = debuff:GetStackCount ()
                self.bonus = 0
                if self:GetCaster():HasModifier("modifier_death") then
                    local mod = self:GetCaster():FindModifierByName("modifier_death")
                    self.bonus = mod:GetStackCount()
                end
                local iDamage = (damage_per_stack * debuff_counts) + self.bonus
                if self:GetParent():HasTalent("special_bonus_unique_death") then
                    iDamage = (self:GetCaster():FindTalentValue("special_bonus_unique_death")*debuff_counts) + iDamage
                end
                ApplyDamage ( { attacker = self:GetCaster (), victim = target, ability = hAbility, damage = iDamage, damage_type = DAMAGE_TYPE_PHYSICAL })
                debuff:SetStackCount (debuff_counts + 1)
                if debuff_counts >= self:GetAbility():GetSpecialValueFor("stacks_to_kill") then
                    target:Kill (hAbility, self:GetCaster ())
                    if self:GetCaster():HasModifier("modifier_death") then
                        local mod = self:GetCaster():FindModifierByName("modifier_death")
                        mod:SetStackCount(mod:GetStackCount() + 1)
                    end
                    debuff:SetStackCount(1)
                end
                self:GetCaster():CalculateStatBonus()
            end
        end
    end

    return 0
end

modifier_death_touch_of_death_debuff = class ( {})


function modifier_death_touch_of_death_debuff:IsHidden ()
    return false
end


function modifier_death_touch_of_death_debuff:RemoveOnDeath ()
    return false
end

function modifier_death_touch_of_death_debuff:IsBuff()
    return false
end

function modifier_death_touch_of_death_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function modifier_death_touch_of_death_debuff:OnHeroKilled(params)
	if params.target:GetTeam() ~= self:GetParent():GetTeam() then
		if params.attacker == self:GetParent() then
			if params.target == self:GetCaster() then
                if self:GetStackCount() >= 50 then
                    if self:GetCaster():HasModifier("modifier_death") then
                        local mod = self:GetCaster():FindModifierByName("modifier_death")
                        mod:SetStackCount(mod:GetStackCount() + 1)
                        self:Destroy()
                    end
                else
                    self:Destroy()
                end
            end
		end
	end
end

function modifier_death_touch_of_death_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

--------------------------------------------------------------------------------

function modifier_death_touch_of_death_debuff:StatusEffectPriority()
    return 1000
end


function modifier_death_touch_of_death_debuff:IsPurgable()
    return false
end

modifier_death_touch_of_death_debuff_parcticle = class ( {})


function modifier_death_touch_of_death_debuff_parcticle:IsHidden ()
    return true
end


function modifier_death_touch_of_death_debuff_parcticle:RemoveOnDeath ()
    return false
end

function modifier_death_touch_of_death_debuff_parcticle:IsBuff()
    return false
end

function modifier_death_touch_of_death_debuff_parcticle:IsPurgable()
    return false
end

function modifier_death_touch_of_death_debuff_parcticle:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_death_touch_of_death_debuff_parcticle:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent()
        if thinker:HasModifier("modifier_death_touch_of_death_debuff") then
            local mod = thinker:FindModifierByName("modifier_death_touch_of_death_debuff")
            local mod_counts = mod:GetStackCount ()
            if mod_counts <= 1 then
                self:Destroy()
            end
        end
    end
end

function modifier_death_touch_of_death_debuff_parcticle:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function death_touch_of_death:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

