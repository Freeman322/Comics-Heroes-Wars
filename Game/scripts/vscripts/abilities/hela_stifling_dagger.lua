if hela_stifling_dagger == nil then hela_stifling_dagger = class({}) end 

LinkLuaModifier( "modifier_hela_stifling_dagger", "abilities/hela_stifling_dagger.lua", LUA_MODIFIER_MOTION_NONE )

function hela_stifling_dagger:ProcsMagicStick()
	return false
end

function hela_stifling_dagger:GetAbilityDamageType()
	return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_hela_2") or DAMAGE_TYPE_PHYSICAL
end
  

--------------------------------------------------------------------------------
function hela_stifling_dagger:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hela_stifling_dagger", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
		end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_hela_stifling_dagger" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

if modifier_hela_stifling_dagger == nil then modifier_hela_stifling_dagger = class({}) end 

function modifier_hela_stifling_dagger:IsHidden ()
    return true
end

function modifier_hela_stifling_dagger:IsPurgable()
    return false
end

function modifier_hela_stifling_dagger:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end


function modifier_hela_stifling_dagger:OnAttackLanded (params)
	if IsServer() then 
	    if self:GetParent () == params.attacker then
	        local hAbility = self:GetAbility()
	        local duration = hAbility:GetSpecialValueFor ("duration")
	        local hTarget = params.target

	        EmitSoundOn ("Hero_PhantomAssassin.Dagger.Cast", hTarget)

	        local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self:GetAbility():GetAbilityDamage(),
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility()
			}

			ApplyDamage( damage )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 3, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			self:GetParent():RemoveGesture(ACT_DOTA_ATTACK_EVENT)
	    end
	end
end

function modifier_hela_stifling_dagger:OnAttackStart (params)
	if IsServer() then 
	    if self:GetParent () == params.attacker then
	        if self:GetParent():GetMana() < self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) then 
	        	self:GetAbility():ToggleAbility()
	        	self:GetParent():Interrupt()
	        end

	        self:GetAbility():PayManaCost()
	        self:GetParent():StartGesture(ACT_DOTA_ATTACK_EVENT)
	    end
	end
end


function modifier_hela_stifling_dagger:OnCreated(table)
	if IsServer() then 
	    self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf")
		if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "fate_of_asgard") == true then self:GetParent():SetRangedProjectileName("particles/econ/items/queen_of_pain/qop_ti8_immortal/qop_ti8_base_attack.vpcf") end 
		if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "golden_fate_of_asgard") == true then self:GetParent():SetRangedProjectileName("particles/econ/items/queen_of_pain/qop_ti8_immortal/queen_ti8_golden_shadow_strike.vpcf") end 
	end 
end

function modifier_hela_stifling_dagger:OnDestroy(table)
	if IsServer() then 
		self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end 
end

function modifier_hela_stifling_dagger:CheckState()
	local state = {
	[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

function modifier_hela_stifling_dagger:GetModifierAttackRangeBonus( params )
    local hAbility = self:GetAbility()
    if self:GetParent():IsRangedAttacker() then
 	    return hAbility:GetSpecialValueFor( "tooltip_range" ) - 150
 	else
 		return 0
 	end
end