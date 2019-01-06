eternity_ult = class({})
LinkLuaModifier( "modifier_eternity_ult", "abilities/eternity_ult.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function eternity_ult:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/oblivion_ult_immortal"
	end
	return "custom/eternity_2"
end

function eternity_ult:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end

function eternity_ult:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "tooltip_duration" )
	if self:GetCaster():HasScepter() then
	  duration = self:GetSpecialValueFor(  "duration_scepter" )
	end

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #units > 0 then
		for _,target in pairs(units) do
			if not target:IsMagicImmune() then 
				target:AddNewModifier( self:GetCaster(), self, "modifier_eternity_ult", { duration = duration } )
				EmitSoundOn( "Hero_Oracle.FalsePromise.Cast", self:GetCaster() )
			end 
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Silencer.GlobalSilence.Cast", self:GetCaster() )
  	if self:GetCaster():HasModifier("modifier_arcana") then
		EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetCaster())
		EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
		EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetCaster())

		local particle_start = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle_start, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_start, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_start, 2, self:GetCaster():GetAbsOrigin())

		EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", target)
		EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", target)
  	end
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

if modifier_eternity_ult == nil then modifier_eternity_ult = class({}) end

function modifier_eternity_ult:IsDebuff()
	return true
end

function modifier_eternity_ult:IsPurgable()
	return false
end

function modifier_eternity_ult:OnCreated(ht)
	if IsServer() then 
		if self:GetCaster():HasModifier("modifier_arcana") then
			local target =	self:GetParent()

			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
			self:AddParticle(nFXIndex, false, false, -1, false, false)

			EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", target)
			EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", target)
			
			local particle = ParticleManager:CreateParticle("particles/hero_zuus/zeus_immortal_thundergod.vpcf", PATTACH_WORLDORIGIN, target)
			ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
			ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
			ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
		end 
	end
end

function modifier_eternity_ult:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf"
end

function modifier_eternity_ult:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_eternity_ult:GetModifierMagicalResistanceBonus( params )
    return self:GetAbility():GetSpecialValueFor("magical_armor_bonus")
end

function modifier_eternity_ult:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_eternity_ult:CheckState()
  if self:GetCaster():HasScepter() then
    return {
	  	[MODIFIER_STATE_SILENCED] = true,
	    [MODIFIER_STATE_DISARMED] = true
  	}
  end
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end
