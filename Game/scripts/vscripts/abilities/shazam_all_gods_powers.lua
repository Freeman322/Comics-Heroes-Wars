LinkLuaModifier( "modifier_shazam_all_gods_powers", "abilities/shazam_all_gods_powers.lua", LUA_MODIFIER_MOTION_NONE )

shazam_all_gods_powers = class({}) 

function shazam_all_gods_powers:OnSpellStart()
     if IsServer() then
          local radius = self:GetSpecialValueFor( "radius" ) 
          local duration = self:GetSpecialValueFor(  "duration" )

          if self:GetCaster():HasTalent("special_bonus_unique_shazam_1") then 
               duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_shazam_1")
           end 

          local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
          if #allies > 0 then
               for _,ally in pairs(allies) do
                    ally:AddNewModifier( self:GetCaster(), self, "modifier_shazam_all_gods_powers", { duration = duration } )
               end
          end

          local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
          ParticleManager:ReleaseParticleIndex( nFXIndex )

          EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

          self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
     end 
end

modifier_shazam_all_gods_powers = class({}) 

modifier_shazam_all_gods_powers.m_iStrMult = 0
modifier_shazam_all_gods_powers.m_iDamage = 0
modifier_shazam_all_gods_powers.m_iBonus_attack_speed = 0
modifier_shazam_all_gods_powers.m_iStrBonus = 0

function modifier_shazam_all_gods_powers:OnCreated( kv )
     self.m_iStrMult = self:GetAbility():GetSpecialValueFor("strength_multiplier")
     self.m_iDamage = self:GetAbility():GetSpecialValueFor("bonus_damage_ptc")
     self.m_iBonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")

	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
          self:AddParticle( nFXIndex, false, false, -1, false, true )
          
          self.m_iStrBonus = (self.m_iStrMult * self:GetParent():GetStrength()) - self:GetParent():GetStrength()
	end
end

function modifier_shazam_all_gods_powers:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_shazam_all_gods_powers:GetModifierAttackSpeedBonus_Constant( params ) return self.m_iBonus_attack_speed end
function modifier_shazam_all_gods_powers:GetModifierExtraStrengthBonus( params ) return self.m_iStrBonus end
function modifier_shazam_all_gods_powers:GetModifierDamageOutgoing_Percentage( params ) return self.m_iDamage end