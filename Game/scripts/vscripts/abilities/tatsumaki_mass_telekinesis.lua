if not tatsumaki_mass_telekinesis then tatsumaki_mass_telekinesis = class({}) end 
LinkLuaModifier ("modifier_tatsumaki_mass_telekinesis", "abilities/tatsumaki_mass_telekinesis.lua", LUA_MODIFIER_MOTION_NONE)

function tatsumaki_mass_telekinesis:GetAssociatedSecondaryAbilities()
     return "tatsumaki_mass_telekinesis_land"
end

function tatsumaki_mass_telekinesis:GetSecondaryAbilitiy()
     return self:GetCaster():FindAbilityByName(self:GetAssociatedSecondaryAbilities())
end

tatsumaki_mass_telekinesis.units = {}
tatsumaki_mass_telekinesis.b_Landed = false
tatsumaki_mass_telekinesis.m_vPos = nil
tatsumaki_mass_telekinesis.m_timestamp = 0

function tatsumaki_mass_telekinesis:OnLandedPressed()
     if IsServer() then
          if not self.b_Landed then
               if self.units then
                    for k, unit in pairs(self.units) do
                         if unit:HasModifier("modifier_tatsumaki_mass_telekinesis") then
                              unit:RemoveModifierByName("modifier_tatsumaki_mass_telekinesis")
                         end
                    end
               end

               self.units = nil

               self:Stun()
               self:GetCaster():SwapAbilities(self:GetAbilityName(), self:GetAssociatedSecondaryAbilities(), true, false)
          end

          self.b_Landed = true
     end

     return nil
end

function tatsumaki_mass_telekinesis:Stun()
     if IsServer() then
          local radius = self:GetSpecialValueFor("telekinesis_radius")
          local boost = self:GetSpecialValueFor("telekinesis_duration") - (GameRules:GetDOTATime(false, false) - self.m_timestamp)
          
          if boost < 0 then
               boost = 0 
          end
          
          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.m_vPos, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          if #units > 0 then
               for _,unit in pairs(units) do
                    unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("earth_shake_bonus_stun") + boost } )
               
                    ApplyDamage({
                         victim = unit,
                         attacker = self:GetCaster(),
                         ability = self,
                         damage = self:GetSpecialValueFor("telekinesis_fall_damage"),
                         damage_type = self:GetAbilityDamageType()
                    })
               end
          end

          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_split_retro_tormented.vpcf", PATTACH_CUSTOMORIGIN, nil )
          ParticleManager:SetParticleControl( nFXIndex, 0, self.m_vPos )
          ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, radius) )
          ParticleManager:SetParticleControl( nFXIndex, 2, self.m_vPos )
          ParticleManager:ReleaseParticleIndex( nFXIndex )
          EmitSoundOnLocationWithCaster(self.m_vPos, "Hero_Leshrac.Split_Earth.Tormented", self:GetCaster())

          EmitSoundOn( "Tatsumaki.Cast2_Landed", self:GetCaster() )
     end
end

function tatsumaki_mass_telekinesis:OnSpellStart() 
     if IsServer() then
          self.m_vPos = self:GetCursorPosition()
          self.m_timestamp = GameRules:GetDOTATime(false, false)

          if self.m_vPos ~= nil then
               local radius = self:GetSpecialValueFor("telekinesis_radius")
               self.b_Landed = false

               self.units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.m_vPos, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
               if self.units ~= nil then
                    if #self.units > 0 then
                         for _, unit in pairs(self.units) do
                              if unit ~= self:GetCaster() then
                                   unit:AddNewModifier(self:GetCaster(), self, "modifier_tatsumaki_mass_telekinesis", {duration = self:GetSpecialValueFor("telekinesis_duration")})
                              end
                         end
                    end
               end
          end
          
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf", PATTACH_CUSTOMORIGIN, nil)
          ParticleManager:SetParticleControl( nFXIndex, 0, self.m_vPos )
          ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
          ParticleManager:SetParticleControl( nFXIndex, 3, self.m_vPos )
          ParticleManager:ReleaseParticleIndex( nFXIndex )

          EmitSoundOn( "Tatsumaki.Cast2", self:GetCaster() )

          self:GetCaster():SwapAbilities(self:GetAbilityName(), self:GetAssociatedSecondaryAbilities(), false, true)
          self:SetThink( "OnLandedPressed", self, self:GetSpecialValueFor("telekinesis_duration") )
     end 
end 

if not modifier_tatsumaki_mass_telekinesis then modifier_tatsumaki_mass_telekinesis = class({}) end 

local VISUAL_Z_DELTA = 150

function modifier_tatsumaki_mass_telekinesis:IsHidden() return false end
function modifier_tatsumaki_mass_telekinesis:IsPurgable() return false end
function modifier_tatsumaki_mass_telekinesis:RemoveOnDeath() return false end
function modifier_tatsumaki_mass_telekinesis:IsDebuff() return true end
function modifier_tatsumaki_mass_telekinesis:IsStunDebuff() return true end

function modifier_tatsumaki_mass_telekinesis:OnCreated(params)
    if IsServer() then
		EmitSoundOn("Hero_Rubick.Telekinesis.Target", self:GetParent())
    end 
end

function modifier_tatsumaki_mass_telekinesis:OnDestroy()
     if IsServer() then
          EmitSoundOn("Hero_Rubick.Telekinesis.Cast", self:GetParent())
     end 
end

function modifier_tatsumaki_mass_telekinesis:GetEffectName()
	return "particles/misterio/telekinesis_puppet.vpcf"
end

function modifier_tatsumaki_mass_telekinesis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_tatsumaki_mass_telekinesis:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

	return funcs
end

function modifier_tatsumaki_mass_telekinesis:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_tatsumaki_mass_telekinesis:GetVisualZDelta(params)
	return VISUAL_Z_DELTA
end

function modifier_tatsumaki_mass_telekinesis:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

if not tatsumaki_mass_telekinesis_land then tatsumaki_mass_telekinesis_land = class({}) end 

function tatsumaki_mass_telekinesis_land:GetAssociatedSecondaryAbilities()
     return "tatsumaki_mass_telekinesis"
end

function tatsumaki_mass_telekinesis_land:GetManaCost() return self:GetCaster():GetMana() * 0.5 end

function tatsumaki_mass_telekinesis_land:Spawn()
     if IsServer() then
          self:SetLevel(1)
     end
end

function tatsumaki_mass_telekinesis_land:GetSecondaryAbilitiy()
     return self:GetCaster():FindAbilityByName(self:GetAssociatedSecondaryAbilities())
end

function tatsumaki_mass_telekinesis_land:OnSpellStart() 
     if IsServer() then
          local abil = self:GetSecondaryAbilitiy()

          if abil then
               abil:OnLandedPressed()
          end
     end 
end 
