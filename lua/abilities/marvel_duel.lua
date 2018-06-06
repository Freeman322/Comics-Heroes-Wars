if marvel_duel == nil then marvel_duel = class({}) end

LinkLuaModifier( "modifier_marvel_duel_caster", "abilities/marvel_duel.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marvel_duel_target", "abilities/marvel_duel.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marvel_duel_damage", "abilities/marvel_duel.lua", LUA_MODIFIER_MOTION_NONE )

function marvel_duel:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function marvel_duel:OnSpellStart()
	self.hTarget = self:GetCursorTarget()
	self.hCaster = self:GetCaster()
	if self.hTarget ~= nil then
		local duration = self:GetSpecialValueFor( "duration" )

		self.hTarget:AddNewModifier( self:GetCaster(), self, "modifier_marvel_duel_target", { duration = duration } )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_marvel_duel_caster", { duration = duration } )

		EmitSoundOn( "Hero_LegionCommander.Duel.Cast.Arcana", self.hTarget )

		EmitSoundOn( "Hero_LegionCommander.Duel.Cast", self:GetCaster() )
	end
end

function marvel_duel:GetDuelTarget()
	return self.hTarget
end

function marvel_duel:GetDuelCaster()
	return self.hCaster
end

if modifier_marvel_duel_caster == nil then modifier_marvel_duel_caster = class({}) end

function modifier_marvel_duel_caster:IsHidden()
	return true
end

function modifier_marvel_duel_caster:IsPurgable()
	return true
end

function modifier_marvel_duel_caster:OnCreated(table)
	if IsServer() then
		local caster = self:GetParent()

		EmitSoundOn("Hero_LegionCommander.Duel", caster)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, caster)
		local center_point = self:GetAbility():GetDuelTarget():GetAbsOrigin() + ((caster:GetAbsOrigin() - self:GetAbility():GetDuelTarget():GetAbsOrigin()) / 2)
		ParticleManager:SetParticleControl(particle, 0, center_point)  --The center position.
		ParticleManager:SetParticleControl(particle, 7, center_point)  --The flag's position (also centered).
		self:AddParticle(particle, false, false, -1, false, false)
		local target = self:GetAbility():GetCursorTarget()

		local order_target =
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		local order_caster =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex()
		}

		target:Stop()

		ExecuteOrderFromTable(order_target)
		ExecuteOrderFromTable(order_caster)

		caster:SetForceAttackTarget(target)
		target:SetForceAttackTarget(caster)
	end
end

function modifier_marvel_duel_caster:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local target = self:GetAbility():GetDuelTarget()

		if caster:IsAlive() == false then
			if target:HasModifier("modifier_marvel_duel_damage") then
				target:FindModifierByName("modifier_marvel_duel_damage"):IncrementStackCount()
			else
				target:AddNewModifier(caster, self:GetAbility(), "modifier_marvel_duel_damage", nil)
				target:FindModifierByName("modifier_marvel_duel_damage"):IncrementStackCount()
			end
			EmitSoundOn("Hero_LegionCommander.Duel.Victory", target)
		end
		if target:IsAlive() == false then
			if caster:HasModifier("modifier_marvel_duel_damage") then
				caster:FindModifierByName("modifier_marvel_duel_damage"):IncrementStackCount()
			else
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_marvel_duel_damage", nil)
				caster:FindModifierByName("modifier_marvel_duel_damage"):IncrementStackCount()
			end
			EmitSoundOn("Hero_LegionCommander.Duel.Victory", caster)
		end
		if target:HasModifier("modifier_marvel_duel_target") then
			target:FindModifierByName("modifier_marvel_duel_target"):Destroy()
		end
		target:Stop()
		caster:SetForceAttackTarget(nil)
		target:SetForceAttackTarget(nil)
	end
end


function modifier_marvel_duel_caster:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_marvel_duel_caster:StatusEffectPriority()
	return 1000
end

function modifier_marvel_duel_caster:GetHeroEffectName()
	return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end


function modifier_marvel_duel_caster:HeroEffectPriority()
	return 100
end

function modifier_marvel_duel_caster:DeclareFunctions()
	local funcs = {
      MODIFIER_EVENT_ON_TAKEDAMAGE,
      MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function modifier_marvel_duel_caster:CheckState()
	local state = {
  	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_marvel_duel_caster:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		local target = params.attacker
        if target ~= self:GetAbility():GetDuelTarget() then
            self:GetParent():Heal(params.damage, self:GetParent())
            self:GetParent():Purge(false, true, false, true, false)
        else
        	return
        end
	end
end

function modifier_marvel_duel_caster:OnHeroKilled(params)
	if params.attacker == self:GetParent() then
		self:Destroy()
	end
end
if modifier_marvel_duel_target == nil then modifier_marvel_duel_target = class({}) end

function modifier_marvel_duel_target:IsHidden()
	return true
end

function modifier_marvel_duel_target:IsPurgable()
	return true
end

function modifier_marvel_duel_target:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_marvel_duel_target:StatusEffectPriority()
	return 1000
end

function modifier_marvel_duel_target:GetHeroEffectName()
	return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end


function modifier_marvel_duel_target:HeroEffectPriority()
	return 100
end

function modifier_marvel_duel_target:DeclareFunctions()
	local funcs = {
      MODIFIER_EVENT_ON_TAKEDAMAGE,
      MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function modifier_marvel_duel_target:CheckState()
	local state = {
  	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_marvel_duel_caster:OnHeroKilled(params)
	if params.attacker == self:GetParent() then
		self:Destroy()
	end
end

function modifier_marvel_duel_target:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		local target = params.attacker
		if not self:GetAbility():GetCaster():HasScepter() then
	        if target ~= self:GetAbility():GetDuelCaster() then
	            self:GetParent():Heal(params.damage, self:GetParent())
	            self:GetParent():Purge(false, false, false, true, false)
	        else
	        	return
	        end
	    else
	    	return
	    end
	end
end

function modifier_marvel_duel_target:OnCreated(table)
	if IsServer() then
		local target = self:GetParent()

		EmitSoundOn("Hero_LegionCommander.Duel", self:GetCaster())

		local order_target =
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self:GetCaster():entindex()
		}

		ExecuteOrderFromTable(order_target)

		target:SetForceAttackTarget(self:GetCaster())
	end
end

function modifier_marvel_duel_target:OnDestroy()
	if IsServer() then
		local target = self:GetParent()
		target:Stop()
		target:SetForceAttackTarget(nil)
	end
end

if modifier_marvel_duel_damage == nil then modifier_marvel_duel_damage = class({}) end

function modifier_marvel_duel_damage:IsPurgable()
    return false
end

function modifier_marvel_duel_damage:RemoveOnDeath()
    return false
end


function modifier_marvel_duel_damage:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_marvel_duel_damage:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("reward_damage") * self:GetStackCount()
end

function marvel_duel:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

