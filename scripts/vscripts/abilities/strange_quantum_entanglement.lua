LinkLuaModifier( "modifier_strange_quantum_entanglement", "abilities/strange_quantum_entanglement.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_strange_quantum_entanglement_illusion", "abilities/strange_quantum_entanglement.lua", LUA_MODIFIER_MOTION_NONE )

strange_quantum_entanglement = class({})

function strange_quantum_entanglement:OnSpellStart(  )
    if IsServer() then 
        local caster = self:GetCaster()
        local hUnits = HeroList:GetAllHeroes() 
        for __index, unit in pairs(hUnits) do
            if unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
                unit:AddNewModifier(self:GetCaster(), self, "modifier_strange_quantum_entanglement", {duration = self:GetSpecialValueFor("tooltip_duration")})
            end
        end
        EmitSoundOn("Hero_Spectre.HauntCast", self:GetCaster())
    end
end


modifier_strange_quantum_entanglement = class({})

function modifier_strange_quantum_entanglement:IsHidden()
	return true
end

function modifier_strange_quantum_entanglement:GetEffectName()
    return "particles/generic_gameplay/screen_arcane_drop.vpcf"
  end
  
  function modifier_strange_quantum_entanglement:GetEffectAttachType()
      return PATTACH_EYES_FOLLOW
  end

function modifier_strange_quantum_entanglement:IsPurgable()
	return false
end

function modifier_strange_quantum_entanglement:OnCreated( kv )
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:StartIntervalThink(1)

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        
        self:GetParent():InterruptChannel()
        self:GetParent():Stop()

        local unit = self:CreateUnit()

		local order =
		{
			UnitIndex = unit:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self:GetParent():entindex()
		}

		ExecuteOrderFromTable(order)

		unit:SetForceAttackTarget(self:GetParent())
	end
end

function modifier_strange_quantum_entanglement:OnCreated(params)
    if IsServer() then 
        local double = CreateUnitByName( self:GetParent():GetUnitName(), self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent():GetOwner(), self:GetCaster():GetTeamNumber())
        
        local caster_level = self:GetParent():GetLevel()
        for i = 2, caster_level do
            double:HeroLevelUp(false)
        end

        for ability_id = 0, 15 do
            local ability = double:GetAbilityByIndex(ability_id)
            if ability then	
                ability:SetLevel(self:GetParent():GetAbilityByIndex(ability_id):GetLevel())
                ability:SetActivated(false)
            end
        end

        for item_id = 0, 5 do
            local item_in_caster = self:GetCaster():GetItemInSlot(item_id)
            if item_in_caster ~= nil then
                local item_name = item_in_caster:GetName()
                local item_created = CreateItem( item_in_caster:GetName(), double, double)
                double:AddItem(item_created)
            end
        end

        double:SetMaximumGoldBounty(0)
        double:SetMinimumGoldBounty(0)
        double:SetDeathXP(0)
        double:SetAbilityPoints(0) 

        double:SetHasInventory(false)
        double:SetCanSellItems(false)

        double:AddNewModifier(self:GetCaster(), self, "modifier_strange_quantum_entanglement_illusion", nil)
        double:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double", nil)
        double:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = self:GetRemainingTime()})

        EmitSoundOn("Hero_Spectre.Haunt", double)

        FindClearSpaceForUnit(double, double:GetAbsOrigin(), false)

        return double
    end 
end

function modifier_strange_quantum_entanglement:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptChannel()
        self:GetParent():Stop()
	end
end

function modifier_strange_quantum_entanglement:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}

	return state
end


function modifier_strange_quantum_entanglement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

modifier_strange_quantum_entanglement_illusion = class({})

function modifier_strange_quantum_entanglement_illusion:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_strange_quantum_entanglement_illusion:IsHidden()
	return true
end

function modifier_strange_quantum_entanglement_illusion:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_strange_quantum_entanglement_illusion:IsPurgable()
	return false
end

function modifier_strange_quantum_entanglement_illusion:OnCreated(table)
	if IsServer() then 
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
end

function modifier_strange_quantum_entanglement_illusion:CheckState()
	local state = {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true
	}

	return state
end
