if not mod_mirror_in_glass then mod_mirror_in_glass = class({}) end
LinkLuaModifier ("modifier_mod_mirror_in_glass", "abilities/mod_mirror_in_glass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_mod_mirror_in_glass_target", "abilities/mod_mirror_in_glass.lua", LUA_MODIFIER_MOTION_NONE)

function mod_mirror_in_glass:GetIntrinsicModifierName() return "modifier_mod_mirror_in_glass" end

function mod_mirror_in_glass:IsRefreshable()
    return false
end

local MINI_STUN_DURATION = 0.03
local EF_DMG_CAP = 250

function mod_mirror_in_glass:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function mod_mirror_in_glass:IncrementSouls()
    local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())

     if mod then
          local max = self:GetSpecialValueFor("max_souls")
          if self:GetCaster():HasTalent("special_bonus_unique_mod_5") then max = 999 end 
          if mod:GetStackCount() < max then mod:IncrementStackCount() end 
     end 
end
 
function mod_mirror_in_glass:GetSouls()
     return self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):GetStackCount()
end
 
function mod_mirror_in_glass:ResetSouls()
     self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(1)
end

function mod_mirror_in_glass:OnSpellStart()
     if IsServer() then
          local souls = self:GetSouls()

          EmitSoundOn("Hero_Terrorblade.Reflection", self:GetCaster())

          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetSpecialValueFor("area_of_effect"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          if #units > 0 then
               for _,  unit in pairs(units) do
                    unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = MINI_STUN_DURATION})        
                    EmitSoundOn( "Hero_Terrorblade_Morphed.projectileImpact", unit )

                    if self:GetCaster():IsFriendly(unit) then
                         unit:Heal(souls * self:GetSpecialValueFor("damage_per_soul"), self)
                    else 
					ApplyDamage( {
						victim = unit,
						attacker = self:GetCaster(),
						damage = souls * self:GetSpecialValueFor("damage_per_soul"),
                              damage_type = DAMAGE_TYPE_MAGICAL,
                              ability = self
                         } )
                    end 

                    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner_impact.vpcf", PATTACH_CUSTOMORIGIN, unit );
                    ParticleManager:SetParticleControl( nFXIndex, 0, unit:GetOrigin() + Vector( 0, 0, 96 ) );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );
               end
          end 

          self:ResetSouls()
     end
end

if modifier_mod_mirror_in_glass == nil then modifier_mod_mirror_in_glass = class({}) end

function modifier_mod_mirror_in_glass:IsAura()
	return true
end

function modifier_mod_mirror_in_glass:IsHidden()
	return false
end

function modifier_mod_mirror_in_glass:IsPurgable()
	return false
end

function modifier_mod_mirror_in_glass:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "area_of_effect" )
end

function modifier_mod_mirror_in_glass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mod_mirror_in_glass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_mod_mirror_in_glass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_mod_mirror_in_glass:GetModifierAura()
	return "modifier_mod_mirror_in_glass_target"
end

function modifier_mod_mirror_in_glass:DeclareFunctions()
     local funcs = {
         MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
     }
     return funcs
end
 
function modifier_mod_mirror_in_glass:GetModifierPreAttack_BonusDamage()
     local damage = self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "preattack_damage_per_soul" )

     if (damage > EF_DMG_CAP) then damage = 250 end 

     return damage
end

 
modifier_mod_mirror_in_glass_target = class({})

function modifier_mod_mirror_in_glass_target:IsHidden() return true end
function modifier_mod_mirror_in_glass_target:IsPurgable() return false end

function modifier_mod_mirror_in_glass_target:DeclareFunctions()
     local funcs = {
          MODIFIER_EVENT_ON_DEATH
     }
 
     return funcs
 end
 
 function modifier_mod_mirror_in_glass_target:OnDeath(params)
     if IsServer() then
          if params.unit == self:GetParent() then
               self:GetAbility():IncrementSouls()
          end 
     end 
 end