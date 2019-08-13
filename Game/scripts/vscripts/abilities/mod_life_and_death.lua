mod_life_and_death = class({})
LinkLuaModifier( "modifier_mod_life_and_death", "abilities/mod_life_and_death", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function mod_life_and_death:OnSpellStart()
     if IsServer() then
          local duration = self:GetSpecialValueFor(  "duration" )

          if self:GetCaster():HasTalent("special_bonus_unique_mod_1") then
               duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_mod_1")
          end
     
          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
          if #units > 0 then
               for _,unit in pairs(units) do
                    unit:AddNewModifier( self:GetCaster(), self, "modifier_mod_life_and_death", { duration = duration } )
               end
          end
     
          local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ) )
          ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ) )
          ParticleManager:ReleaseParticleIndex( nFXIndex )
     
          EmitSoundOn( "Hero_Terrorblade.Metamorphosis.Scepter", self:GetCaster() )
     
          self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
     end
end

modifier_mod_life_and_death = class({})

local EF_MAX_REDUCTION = -100
local EF_DAMAGE_REDUCTION =  2

function modifier_mod_life_and_death:IsHidden()
    return false
end

function modifier_mod_life_and_death:GetEffectName()
	return "particles/mod/life_and_death_word_buff.vpcf"
end

function modifier_mod_life_and_death:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_mod_life_and_death:OnCreated(params)
     self.m_hUnitsTable = {}
end

function modifier_mod_life_and_death:IsPurgable()
    return false
end

function modifier_mod_life_and_death:OnDestroy()
     if IsServer() then
          local damage_ptc = self:GetAbility():GetSpecialValueFor("damage")

          if self:GetCaster():HasTalent("special_bonus_unique_mod_2") then
               damage_ptc = damage_ptc + self:GetCaster():FindTalentValue("special_bonus_unique_mod_2")
          end

          damage_ptc = damage_ptc / 100

          for k,v in pairs(self.m_hUnitsTable) do
               ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = k, ability = self:GetAbility(), damage = v * damage_ptc, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
               ApplyDamage({attacker = k, victim = self:GetParent(), ability = self:GetAbility(), damage = v / EF_DAMAGE_REDUCTION, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
          end
     end
end

function modifier_mod_life_and_death:DeclareFunctions() 
    local funcs = {
          MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_mod_life_and_death:GetModifierIncomingDamage_Percentage( params )
     if IsServer() then
          if self:GetParent() == params.target and params.attacker:IsRealHero() then
               self.m_hUnitsTable[params.attacker] = (self.m_hUnitsTable[params.attacker] or 0) + params.damage

               return EF_MAX_REDUCTION
          end 
     end 
end
