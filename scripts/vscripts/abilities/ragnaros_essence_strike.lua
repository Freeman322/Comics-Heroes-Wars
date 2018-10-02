ragnaros_essence_strike = class({})

LinkLuaModifier ("modifier_ragnaros_essence_strike", "abilities/ragnaros_essence_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ragnaros_essence_strike_target", "abilities/ragnaros_essence_strike.lua", LUA_MODIFIER_MOTION_NONE)

function ragnaros_essence_strike:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ragnaros_essence_strike:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ragnaros_essence_strike", nil )
        self:EndCooldown()
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_ragnaros_essence_strike" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end


modifier_ragnaros_essence_strike = class ( {})

function modifier_ragnaros_essence_strike:IsHidden ()
    return true

end

function modifier_ragnaros_essence_strike:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end


function modifier_ragnaros_essence_strike:OnAttackLanded (params)
    if self:GetParent () == params.attacker then
        local hAbility = self:GetAbility()
        local duration = hAbility:GetSpecialValueFor ("burn_duration")
        if hAbility:IsCooldownReady () and self:GetCaster():GetMana() >= 40 then
            local hTarget = params.target
            if not hTarget:IsBuilding(  ) then
                self:GetCaster():SpendMana( 40, hAbility )
                hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
                EmitSoundOn ("Hero_DoomBringer.InfernalBlade.PreAttack", hTarget)
                hTarget:AddNewModifier (hAbility:GetCaster (), hAbility, "modifier_ragnaros_essence_strike_target", { duration = duration })
            end
        end
    end
end

modifier_ragnaros_essence_strike_target = class ( {})

function modifier_ragnaros_essence_strike_target:IsPurgable(  )
    return false
end

function modifier_ragnaros_essence_strike_target:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local damage_perc = self:GetAbility ():GetSpecialValueFor ("burn_damage_pct")/100
        local damage = (damage_perc * thinker:GetMaxHealth ()) + self:GetAbility ():GetSpecialValueFor ("burn_damage")
        
        ApplyDamage ( { attacker = self:GetAbility():GetCaster(), victim = thinker, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
        EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", thinker )
        -- Play named sound on Entity
        self:StartIntervalThink(1)
        self:OnIntervalThink()
        thinker:AddNewModifier(thinker, self:GetAbility(), "modifier_stunned", {duration = 0.3})
    end
end

function modifier_ragnaros_essence_strike_target:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent()
        local damage_perc = self:GetAbility ():GetSpecialValueFor ("burn_damage_pct")/100
        local damage = (damage_perc * thinker:GetMaxHealth ()) + self:GetAbility ():GetSpecialValueFor ("burn_damage")
        ApplyDamage ( { attacker = self:GetAbility():GetCaster(), victim = thinker, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function ragnaros_essence_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

