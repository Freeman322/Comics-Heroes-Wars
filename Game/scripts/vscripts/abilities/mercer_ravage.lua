mercer_ravage = class({})
LinkLuaModifier( "modifier_mercer_ravage", "abilities/mercer_ravage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mercer_ravage_aura", "abilities/mercer_ravage", LUA_MODIFIER_MOTION_NONE )


function mercer_ravage:GetAOERadius()
	return self:GetSpecialValueFor( "coil_radius" )
end

function mercer_ravage:OnSpellStart()
    if IsServer() then 
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_mercer_ravage_aura", -- modifier name
			{
				duration = self:GetSpecialValueFor("duration")
			}
		)

		print("Modifier applied!")

		EmitSoundOn("Hero_LifeStealer.Assimilate.Target", self:GetCaster())
		
		print("Sound applied!")
    end 
end


modifier_mercer_ravage_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mercer_ravage_aura:IsHidden()
	return true
end

function modifier_mercer_ravage_aura:IsPurgable()
	return false
end

function modifier_mercer_ravage_aura:IsAura()
	return true
end

function modifier_mercer_ravage_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_mercer_5") or 0)
end

function modifier_mercer_ravage_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mercer_ravage_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_mercer_ravage_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_mercer_ravage_aura:GetModifierAura()
	return "modifier_mercer_ravage"
end

function modifier_mercer_ravage_aura:GetStatusEffectName()
	return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf"
end

function modifier_mercer_ravage_aura:StatusEffectPriority()
	return 1000
end

function modifier_mercer_ravage_aura:GetHeroEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_souls_hero_effect.vpcf"
end

function modifier_mercer_ravage_aura:HeroEffectPriority()
	return 100
end

function modifier_mercer_ravage_aura:OnCreated( kv ) 
    if IsServer() then 
		print("Aura applied!")
    end 
end

function modifier_mercer_ravage_aura:OnDestroy( kv )
	if IsServer() then
	end
end

modifier_mercer_ravage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mercer_ravage:IsHidden()
	return false
end

function modifier_mercer_ravage:IsDebuff()
	return true
end

function modifier_mercer_ravage:IsStunDebuff()
	return false
end

function modifier_mercer_ravage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_mercer_ravage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mercer_ravage:OnCreated( kv )
	if IsServer() then
		-- Create Particle
		local effect_cast = ParticleManager:CreateParticle( "particles/hero_mercer/mercer_chain.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetCaster(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			self:GetCaster():GetOrigin(), 
			true 
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			self:GetParent():GetOrigin(), 
			true 
		)
		-- buff particle
		self:AddParticle(
			effect_cast,
			false,
			false,
			-1,
			false,
			false
		)

		self:StartIntervalThink(1) 
		self:OnIntervalThink()
	end

	self.m_speed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
end

function modifier_mercer_ravage:OnIntervalThink()
	if IsServer() then 
		local damage = self:GetAbility():GetSpecialValueFor("think_damage")
		if self:GetCaster():HasTalent("special_bonus_unique_mercer_4") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_mercer_4") end    


		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), 
		}

		ApplyDamage(damageTable)
	end 
end

function modifier_mercer_ravage:OnDestroy( kv )

end

function modifier_mercer_ravage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_mercer_ravage:GetModifierMoveSpeed_Absolute(params)
    if IsServer() then 
		local distToUnit = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		local unit_dir = self:GetParent():GetForwardVector() 
		if distToUnit:Dot(unit_dir) > math.cos(2.44346) then 
			if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= self:GetAbility():GetSpecialValueFor("radius") then
				return 1  
			end
		end 
	end 
	
    return self.m_speed
end


function modifier_mercer_ravage:OnUnitMoved( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end
		
		local damage = params.gain * FrameTime() if damage <= 0 then damage = 1 end 

		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), 
		} 

		ApplyDamage(damageTable)
	end
end
