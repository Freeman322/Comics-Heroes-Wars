if item_soul_gem == nil then item_soul_gem = class({}) end

local RANGE = 1600

LinkLuaModifier("modifier_item_soul_gem", "items/item_soul_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_soul_gem_debuff", "items/item_soul_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_soul_gem_active", "items/item_soul_gem.lua", LUA_MODIFIER_MOTION_NONE)

function item_soul_gem:GetIntrinsicModifierName()
	return "modifier_item_soul"
end


function item_soul_gem:OnOwnerDied()
     if IsServer() then
          local charges = self:GetCurrentCharges()
          local reduce = self:GetSpecialValueFor("death_charges")

          if (charges - reduce >= 1) then
               self:SetCurrentCharges(charges - reduce)
          end
     end
end


function item_soul_gem:OnHeroDiedNearby( hVictim, hKiller, kv )
     if IsServer() then
          if hVictim == nil or hKiller == nil then
               return
          end

          if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
               local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
               local flDistance = vToCaster:Length2D()
               if hKiller == self:GetCaster() or RANGE >= flDistance then
                    
                    self:SetCurrentCharges(self:GetCurrentCharges() + self:GetSpecialValueFor("kill_charges"))
                    self:GetCaster():CalculateStatBonus()

                    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
                    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
               end
          end
     end
end

function item_soul_gem:OnSpellStart()
     if IsServer() then 
          local target = self:GetCursorTarget()

		local duration = self:GetSpecialValueFor(  "soul_steal_duration" )

          target:AddNewModifier( self:GetCaster(), self, "modifier_hexxed", { duration = duration } )
          
          EmitSoundOn("Item.SoulGem.Cast", target)

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_bramble_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
          ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
          ParticleManager:SetParticleControl( nFXIndex, 1, Vector(300, 300, 1) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_ElderTitan.EchoStomp.Channel.ti7", self:GetCaster() )

          self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_soul_gem_active", { duration = duration } )

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
	end
end

if modifier_item_soul_gem == nil then  modifier_item_soul_gem = class ( {}) end

function modifier_item_soul_gem:IsHidden() return true end
function modifier_item_soul_gem:IsPurgable() return false end

function modifier_item_soul_gem:DeclareFunctions()
	local funcs = {
          MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
          MODIFIER_PROPERTY_MANA_BONUS,
          MODIFIER_PROPERTY_HEALTH_BONUS,
          MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
          MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
          MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
          MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
	return funcs
end

function modifier_item_soul_gem:OnCreated(params)
     self.amp_per_charge = self:GetAbility():GetSpecialValueFor("amp_per_charge")
     self.regen_per_charge = self:GetAbility():GetSpecialValueFor("regen_per_charge")
end
function modifier_item_soul_gem:OnRefresh(params)
     self.amp_per_charge = self:GetAbility():GetSpecialValueFor("amp_per_charge")
     self.regen_per_charge = self:GetAbility():GetSpecialValueFor("regen_per_charge")
end

function modifier_item_soul_gem:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_soul_gem:GetModifierTotalPercentageManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" ) / 100
end

function modifier_item_soul_gem:GetModifierManaBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana" )
end

function modifier_item_soul_gem:GetModifierHealthBonus( params )
     return self:GetAbility():GetSpecialValueFor( "bonus_health" )
end

function modifier_item_soul_gem:GetModifierConstantHealthRegen( params )
     return self:GetAbility():GetCurrentCharges() * self.regen_per_charge
end

function modifier_item_soul_gem:GetModifierPercentageManacost( params )
     return self:GetAbility():GetSpecialValueFor( "manacost_reduction" )
end

function modifier_item_soul_gem:GetModifierSpellAmplify_Percentage( params )
     return self:GetAbility():GetSpecialValueFor( "spell_amp" ) + (self:GetAbility():GetCurrentCharges() * self.amp_per_charge)
end

if modifier_item_soul_gem_active == nil then modifier_item_soul_gem_active = class({}) end

function modifier_item_soul_gem_active:IsHidden() return true end
function modifier_item_soul_gem_active:IsPurgable()  return false end
function modifier_item_soul_gem_active:GetEffectName() return "particles/soulgem_buff_halo.vpcf" end
function modifier_item_soul_gem_active:GetEffectAttachType()  return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_soul_gem_active:StatusEffectPriority()  return 1000 end

function modifier_item_soul_gem_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_ghost.vpcf"
end


function modifier_item_soul_gem_active:DeclareFunctions()
local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }

    return funcs
end

function modifier_item_soul_gem_active:GetModifierTotalPercentageManaRegen( params )
    return -10
end

function modifier_item_soul_gem_active:GetModifierHealthRegenPercentage( params )
    return 15
end
