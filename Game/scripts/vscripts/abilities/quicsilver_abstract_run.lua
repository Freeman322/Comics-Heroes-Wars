quicsilver_abstract_run = class({})
LinkLuaModifier( "modifier_quicsilver_abstract_run_aura", "abilities/quicsilver_abstract_run.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_quicsilver_abstract_run", "abilities/quicsilver_abstract_run.lua", LUA_MODIFIER_MOTION_NONE )

function quicsilver_abstract_run:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_quicsilver_abstract_run_aura", { duration = duration }  )
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
  EmitSoundOn("Hero_ArcWarden.MagneticField.Cast", self:GetCaster())
end

modifier_quicsilver_abstract_run_aura = class({})


function modifier_quicsilver_abstract_run_aura:IsPurgable()
	return false
end

function modifier_quicsilver_abstract_run_aura:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end

function modifier_quicsilver_abstract_run_aura:StatusEffectPriority()
	return 2000
end

function modifier_quicsilver_abstract_run_aura:IsAura()
	return true
end

function modifier_quicsilver_abstract_run_aura:GetModifierAura()
	return "modifier_quicsilver_abstract_run"
end

function modifier_quicsilver_abstract_run_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_quicsilver_abstract_run_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_quicsilver_abstract_run_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_quicsilver_abstract_run_aura:GetAuraRadius()
	return 2000
end

function modifier_quicsilver_abstract_run_aura:GetAuraEntityReject( hEntity )
	if IsServer() then
		if self:GetParent() == hEntity then
			return true
		end
	end

	return false
end

function modifier_quicsilver_abstract_run_aura:CheckState()
	return 
end

function modifier_quicsilver_abstract_run_aura:OnCreated( kv )
	  if IsServer() then
		local particle = "particles/hero_quicksilver/abstract_run_aura.vpcf"
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "android") == true then particle = "particles/hero_quicksilver/abstract_run_skin.vpcf" end 

    		local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		    
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin" , self:GetParent():GetOrigin(), true )
    		self:AddParticle( nFXIndex, false, false, -1, false, true )
		  
		EmitSoundOn("Hero_ArcWarden.MagneticField", self:GetParent())
  	end
end


function modifier_quicsilver_abstract_run_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function modifier_quicsilver_abstract_run_aura:GetModifierMoveSpeed_Max()
	return 10000
end

function modifier_quicsilver_abstract_run_aura:GetModifierMoveSpeed_Limit()
	return 10000
end

function modifier_quicsilver_abstract_run_aura:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("move_speed")
end

if modifier_quicsilver_abstract_run == nil then modifier_quicsilver_abstract_run = class({}) end

function modifier_quicsilver_abstract_run:IsPurgable()
	return false
end

function modifier_quicsilver_abstract_run:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_quicsilver_abstract_run:GetModifierMoveSpeed_Max()
	return self.min_speed
end

function modifier_quicsilver_abstract_run:GetModifierMoveSpeed_Limit()
	return self.min_speed
end

function modifier_quicsilver_abstract_run:GetModifierTurnRate_Percentage()
	return -self.min_speed
end

function modifier_quicsilver_abstract_run:GetModifierMoveSpeedBonus_Constant()
	return -self.min_speed
end

function modifier_quicsilver_abstract_run:OnCreated(htable)
	self.pers = 0
	self.min_speed = 0
		if IsServer() then
		if self:GetParent() ~= self:GetCaster() then
		self.pers = 100
		self.min_speed = 10000
		self:StartIntervalThink(1)
		else
		self.pers = 0
		self.min_speed = 0
		end
	end
end

function modifier_quicsilver_abstract_run:OnIntervalThink()
   if IsServer() then
     local target = self:GetParent()
     local damage = (self:GetCaster():GetIdealSpeed() * (self:GetAbility():GetSpecialValueFor("damage") / 100))
     ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL}) ---133180494
   end
end

function quicsilver_abstract_run:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

