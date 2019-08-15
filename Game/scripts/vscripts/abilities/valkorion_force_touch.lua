LinkLuaModifier ("modifier_valkorion_force_touch", 				"abilities/valkorion_force_touch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_valkorion_force_touch_passive", "abilities/valkorion_force_touch.lua", LUA_MODIFIER_MOTION_NONE)
valkorion_force_touch = class ({})

function valkorion_force_touch:GetIntrinsicModifierName() return "modifier_valkorion_force_touch" end

function valkorion_force_touch:Set( flRegen, flHealth, flSpell )
     local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
     if mod then
          mod.m_iManaRegen = flRegen + mod.m_iManaRegen
          if mod.m_iManaRegen < 0 then mod.m_iManaRegen = 0 end 

          mod.m_iHealthRegen = flRegen + mod.m_iHealthRegen
          if mod.m_iHealthRegen < 0 then mod.m_iHealthRegen = 0 end 

          mod.m_iSpell = flRegen + mod.m_iSpell
          if mod.m_iSpell < 0 then mod.m_iSpell = 0 end 
     end
end
modifier_valkorion_force_touch = class({})

modifier_valkorion_force_touch.m_iManaRegen = 0
modifier_valkorion_force_touch.m_iHealthRegen = 0
modifier_valkorion_force_touch.m_iSpell = 0

function modifier_valkorion_force_touch:IsAura() return true end
function modifier_valkorion_force_touch:IsHidden() return true end
function modifier_valkorion_force_touch:IsPurgable()	return true end
function modifier_valkorion_force_touch:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_valkorion_force_touch:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_valkorion_force_touch:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_valkorion_force_touch:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MANA_ONLY end
function modifier_valkorion_force_touch:GetModifierAura() return "modifier_valkorion_force_touch_passive" end

function modifier_valkorion_force_touch:DeclareFunctions()
     local funcs = {
       MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
       MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
       MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
     }
   
     return funcs
end
   
function modifier_valkorion_force_touch:GetModifierConstantManaRegen (params)
     if IsServer() then
          return self.m_iManaRegen
     end
end

function modifier_valkorion_force_touch:GetModifierConstantHealthRegen (params)
     if IsServer() then
          return self.m_iHealthRegen
     end
end

function modifier_valkorion_force_touch:GetModifierSpellAmplify_Percentage (params)
     if IsServer() then
          return self.m_iSpell
     end
end
   
modifier_valkorion_force_touch_passive = class({})

modifier_valkorion_force_touch_passive.m_iManaRegen = 0
modifier_valkorion_force_touch_passive.m_iHealthRegen = 0
modifier_valkorion_force_touch_passive.m_iSpell = 0


function modifier_valkorion_force_touch_passive:OnCreated(params)
     if IsServer() then
          if self:GetCaster():IsRealHero() then
               self.m_iManaRegen = self:GetParent():GetManaRegen() * (self:GetAbility():GetSpecialValueFor("mana_regen_ptc") / 100)
               self.m_iHealthRegen = self:GetParent():GetHealthRegen() * (self:GetAbility():GetSpecialValueFor("health_regen_ptc") / 100)
               self.m_iSpell = self:GetParent():GetSpellAmplification(false) * (self:GetAbility():GetSpecialValueFor("spell_steal_ptc") / 100)

               self:GetAbility():Set(self.m_iManaRegen, self.m_iHealthRegen, self.m_iSpell)
          end
     end 
end

function modifier_valkorion_force_touch_passive:OnDestroy()
     if IsServer() then
          if self:GetCaster() and self:GetCaster():IsNull() == false and self:GetCaster():IsRealHero() then
               self:GetAbility():Set(self.m_iManaRegen * (-1), self.m_iHealthRegen * (-1), self.m_iSpell * (-1))
          end
     end 
end

function modifier_valkorion_force_touch_passive:GetEffectName()
	return "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_debuff_arcana.vpcf"
end

function modifier_valkorion_force_touch_passive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_valkorion_force_touch_passive:IsPurgable() return false end

function modifier_valkorion_force_touch_passive:DeclareFunctions()
     local funcs = {
          MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
          MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
          MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
     }
   
     return funcs
end
   
function modifier_valkorion_force_touch_passive:GetModifierConstantManaRegen (params)
     if IsServer() then
          return self.m_iManaRegen * (-1)
     end
end

function modifier_valkorion_force_touch_passive:GetModifierConstantHealthRegen (params)
     if IsServer() then
          return self.m_iHealthRegen * (-1)
     end
end

function modifier_valkorion_force_touch_passive:GetModifierSpellAmplify_Percentage (params)
     if IsServer() then
          return self.m_iSpell * (-1)
     end
end