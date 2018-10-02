if venom_assimilate == nil then venom_assimilate = class({}) end 

LinkLuaModifier( "modifier_venom_assimilate", "abilities/venom_assimilate.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_venom_assimilate_buff", "abilities/venom_assimilate.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function venom_assimilate:CastFilterResultTarget( hTarget )
   if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function venom_assimilate:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function venom_assimilate:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function venom_assimilate:IsStealable()
	return false
end

function venom_assimilate:IsRefreshable()
	return true
end
--------------------------------------------------------------------------------

function venom_assimilate:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    local caster = self:GetCaster()
    if hTarget ~= nil then

        local damage = {
			victim = hTarget,
			attacker = caster,
			damage = self:GetSpecialValueFor( "damage" ),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}
        ApplyDamage( damage )
        
        local double = CreateUnitByName( hTarget:GetUnitName(), caster:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber())
        double:SetControllableByPlayer(caster:GetPlayerID(), false)

        local caster_level = hTarget:GetLevel()
        for i = 2, caster_level do
            double:HeroLevelUp(false)
        end


        for ability_id = 0, 15 do
            local ability = double:GetAbilityByIndex(ability_id)
            if ability ~= nil then
                for i = 1, hTarget:GetAbilityByIndex(ability_id):GetLevel() do 
                    ability:UpgradeAbility(false)
                end
            end
        end


        for item_id = 0, 5 do
            local item_in_caster = hTarget:GetItemInSlot(item_id)
            if item_in_caster ~= nil then
                local item_name = item_in_caster:GetName()
                local item_created = CreateItem( item_in_caster:GetName(), double, double)
                double:AddItem(item_created)
            end
        end

        double:SetHealth(hTarget:GetHealth())
        double:SetMana(hTarget:GetMana())

        double:SetMaximumGoldBounty(0)
        double:SetMinimumGoldBounty(0)
        double:SetDeathXP(0)
        double:SetAbilityPoints(0) 

        double:SetHasInventory(false)
        double:SetCanSellItems(false)
        double:AddNewModifier(caster, self, "modifier_kill", {["duration"] = self:GetSpecialValueFor("duration")})
        double:AddNewModifier( self:GetCaster(), self, "modifier_venom_assimilate_buff", nil )

        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_venom_assimilate", {target = double:entindex()} )

        EmitSoundOn( "Hero_LifeStealer.Assimilate.Target", hTarget )  ---entindex()
	end
end

if modifier_venom_assimilate == nil then modifier_venom_assimilate = class({}) end

--------------------------------------------------------------------------------

function modifier_venom_assimilate:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_venom_assimilate:RemoveOnDeath()
	return true
end

function modifier_venom_assimilate:OnCreated(table)
	if IsServer() then
        self.scale = self:GetParent():GetModelScale()
        self:GetParent():SetModelScale(0.004)
        self.target = EntIndexToHScript(table.target)
        self:StartIntervalThink(0.03)
    end
end

function modifier_venom_assimilate:OnDestroy()
	if IsServer() then
        self:GetParent():SetModelScale(self.scale)
        self.target = nil
    end
end

function modifier_venom_assimilate:OnIntervalThink()
    if IsServer() then
        if self.target:IsNull() then 
            self:Destroy()
            return
        end
        if self.target == nil or self.target:IsAlive() == false then
            self:Destroy()
            return 
        end
       self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin())
    end
end

--------------------------------------------------------------------------------

function modifier_venom_assimilate:CheckState()
	local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED]	= true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
        [MODIFIER_STATE_UNSELECTABLE]	= true,
        [MODIFIER_STATE_OUT_OF_GAME]	= true,
        [MODIFIER_STATE_NO_HEALTH_BAR]	= true,
        [MODIFIER_STATE_INVULNERABLE]	= true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end


modifier_venom_assimilate_buff = class({})

function modifier_venom_assimilate_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_SUPER_ILLUSION, 
        MODIFIER_PROPERTY_ILLUSION_LABEL, 
        MODIFIER_PROPERTY_IS_ILLUSION, 
        MODIFIER_EVENT_ON_TAKEDAMAGE 
    }
end

function modifier_venom_assimilate_buff:GetIsIllusion()
	return true
end

function modifier_venom_assimilate_buff:GetModifierSuperIllusion()
	return true
end

function modifier_venom_assimilate_buff:GetModifierIllusionLabel()
	return true
end

function modifier_venom_assimilate_buff:OnTakeDamage( event )
    if event.unit == self:GetParent() then 
        if event.unit:IsAlive() == false then
            event.unit:MakeIllusion()
        end
    end
end

function modifier_venom_assimilate_buff:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_venom_assimilate_buff:IsHidden()
	return true
end

function modifier_venom_assimilate_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end