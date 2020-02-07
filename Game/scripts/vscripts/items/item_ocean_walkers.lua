if not item_ocean_walkers then item_ocean_walkers = class({}) end 

local Z_PROXY = 130

LinkLuaModifier ("modifier_item_ocean_walkers_active", "items/item_ocean_walkers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ocean_walkers_water_boost", "items/item_ocean_walkers.lua", LUA_MODIFIER_MOTION_NONE)

----Buffs-----------------------------------------------------------------------дюшес
function item_ocean_walkers:GetIntrinsicModifierName() return "modifier_item_guardian_greaves" end
--------------------------------------------------------------------------------

item_ocean_walkers.m_hPrimaryBuff = nil

function item_ocean_walkers:OnOwnerDied() 
     if IsServer() then
          if self.m_hPrimaryBuff ~= nil then
               UTIL_Remove(self.m_hPrimaryBuff)
          end
     end
end 

function item_ocean_walkers:OnDestroy()
     if IsServer() then
          if self.m_hPrimaryBuff ~= nil then
               UTIL_Remove(self.m_hPrimaryBuff)
          end
     end
end 

function item_ocean_walkers:OnOwnerSpawned() 
     if IsServer() then
          self.m_hPrimaryBuff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_ocean_walkers_water_boost", nil)
     end
end 

function item_ocean_walkers:OnSpellStart()
     if IsServer() then 
          local radius = self:GetSpecialValueFor("aura_radius") 
          local duration = self:GetSpecialValueFor("water_buff_active_duration")
          local target = self:GetCaster():GetAbsOrigin()

          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
          if #units > 0 then
               for _, unit in pairs(units) do
                    unit:AddNewModifier( self:GetCaster(), self, "modifier_item_ocean_walkers_active", { duration = duration } )

                    unit:Heal(self:GetSpecialValueFor("replenish_health"), self)
                    unit:GiveMana(self:GetSpecialValueFor("replenish_mana"))

                    EmitSoundOn("Item.GuardianGreaves.Target", unit)
               end
          end

          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
          ParticleManager:SetParticleControl(nFXIndex, 0, target)
          ParticleManager:SetParticleControl(nFXIndex, 1, Vector(radius, duration, 0))
          ParticleManager:ReleaseParticleIndex( nFXIndex )

          EmitSoundOn( "Item.Majestic_staff.Cast", self:GetCaster() )

          self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
     end 
end

modifier_item_ocean_walkers_water_boost = class ({})

function modifier_item_ocean_walkers_water_boost:IsHidden() return true end
function modifier_item_ocean_walkers_water_boost:IsPurgable() return true end

function modifier_item_ocean_walkers_water_boost:OnCreated(params)
     print("modifier_item_ocean_walkers_water_boost")
end

function modifier_item_ocean_walkers_water_boost:DeclareFunctions()
	local stats =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, 
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
		}
	return stats
end

function modifier_item_ocean_walkers_water_boost:GetModifierConstantHealthRegen()
     if self:GetAbility() and self:GetCaster():GetAbsOrigin().z <= Z_PROXY then
         return self:GetAbility():GetSpecialValueFor("water_buff_owner_regen_hp")
     end
 
     return 0
 end
 
 function modifier_item_ocean_walkers_water_boost:GetModifierConstantManaRegen()
     if self:GetAbility() and self:GetCaster():GetAbsOrigin().z <= Z_PROXY then
         return self:GetAbility():GetSpecialValueFor("water_buff_owner_regen_mana")
     end
 
     return 0
 end
 
 
 function modifier_item_ocean_walkers_water_boost:GetModifierMoveSpeedBonus_Constant()
     if self:GetAbility() and self:GetCaster():GetAbsOrigin().z <= Z_PROXY then
         return self:GetAbility():GetSpecialValueFor("water_buff_owner_bonus_movespeed")
     end
 
     return 0
 end
 

if not modifier_item_ocean_walkers_active then modifier_item_ocean_walkers_active = class({}) end 

function modifier_item_ocean_walkers_active:IsHidden() return false end
function modifier_item_ocean_walkers_active:IsPurgable() return true end
function modifier_item_ocean_walkers_active:DeclareFunctions() 
     local stats =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, 
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
		}
	return stats
end

function modifier_item_ocean_walkers_active:GetEffectName() return "particles/econ/events/ti7/bottle_ti7.vpcf" end
function modifier_item_ocean_walkers_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_ocean_walkers_active:GetModifierMoveSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor ("water_buff_owner_bonus_movespeed") - 10 end
function modifier_item_ocean_walkers_active:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor ("water_buff_active_bonus_regen_hp") end
function modifier_item_ocean_walkers_active:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor ("water_buff_active_bonus_regen_mana") end

