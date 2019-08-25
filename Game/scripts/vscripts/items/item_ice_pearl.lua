LinkLuaModifier ("modifier_item_ice_pearl", "items/item_ice_pearl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ice_pearl_reduction", "items/item_ice_pearl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ice_pearl_active", "items/item_ice_pearl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ice_pearl_cooldown", "items/item_ice_pearl.lua", LUA_MODIFIER_MOTION_NONE)

item_ice_pearl = class({})

function item_ice_pearl:GetIntrinsicModifierName() return "modifier_item_ice_pearl" end

function item_ice_pearl:OnSpellStart()
    if IsServer() then       
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_ice_pearl_active", {duration = self:GetSpecialValueFor("active_duration")})

        self:GetCaster():Purge(false, true, false, true, false)
        
        EmitSoundOn("Item.GuardianGreaves.Activate", self:GetCaster())
    
        local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, allies in pairs (allies) do
			local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/mekanism_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, allies)
			ParticleManager:SetParticleControl(particle, 0, allies:GetAbsOrigin())
			allies:EmitSound("Item.GuardianGreaves.Target")
			allies:Heal(allies:GetMaxHealth() * (self:GetSpecialValueFor("restore_pct") / 100) + self:GetSpecialValueFor("hp_restore"), self:GetCaster())
			allies:GiveMana(allies:GetMaxMana() * (self:GetSpecialValueFor("restore_pct") / 100))
		end
        
        local waves = 3

        Timers:CreateTimer(1, function()
            if waves >= 1 then
                waves = waves - 1
                self:CreateWave() return 1
            end 

            return nil
        end)
    end
end

function item_ice_pearl:CreateWave()
  if IsServer() then
    local shivas_guard_particle = ParticleManager:CreateParticle("particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(shivas_guard_particle, 1, Vector(900, 900 / 350, 350))

    EmitSoundOn("DOTA_Item.ShivasGuard.Activate", self:GetCaster())
    self._iCurrent_blast_radius = 0

    Timers:CreateTimer({ ---КАСТЫЛЬ, А ЧТО ДЕЛАТЬ?
      endTime = .03,
      callback = function()
      self:CreateVisibilityNode(self:GetCaster():GetAbsOrigin(), 800, 2)

      self._iCurrent_blast_radius = self._iCurrent_blast_radius + (350 * .03)

      local units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, self._iCurrent_blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

      for i, unit in pairs(units) do
        if not unit:HasModifier("modifier_item_ice_pearl_reduction") then
          ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("blast_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

          local shivas_guard_impact_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
          local target_point = unit:GetAbsOrigin()
          local caster_point = self:GetCaster():GetAbsOrigin()
          ParticleManager:SetParticleControl(shivas_guard_impact_particle, 1, target_point + (target_point - caster_point) * 30)

          unit:AddNewModifier(self:GetCaster(), self, "modifier_item_ice_pearl_reduction", {duration = self:GetSpecialValueFor("blast_debuff_duration")})
        end
      end

      if self._iCurrent_blast_radius < 900 then return .03 else self._iCurrent_blast_radius = 0 return nil end
    end})
  end
end

modifier_item_ice_pearl = class({})

function modifier_item_ice_pearl:IsHidden() return true end
function modifier_item_ice_pearl:IsPurgable() return false end

function modifier_item_ice_pearl:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_item_ice_pearl:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor ("bonus_damage") end
function modifier_item_ice_pearl:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor ("bonus_armor") end
function modifier_item_ice_pearl:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mp_regen") end
function modifier_item_ice_pearl:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_ice_pearl:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_ice_pearl:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_ice_pearl:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end

function modifier_item_ice_pearl:OnTakeDamage(params)
  if IsServer() then
    if params.unit == self:GetParent() and self:GetParent():HasModifier("modifier_item_ice_pearl_cooldown") == false and params.attacker ~= self:GetParent() and params.attacker:IsBuilding() == false and params.attacker:IsRealHero() and self:GetParent():IsRealHero() then

      params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_ice_pearl_reduction", {duration = self:GetAbility():GetSpecialValueFor("debuff_duration")})
      
      EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Cast", params.attacker)
      EmitSoundOn("Hero_Winter_Wyvern.ColdEmbrace.Cast", params.attacker)

      ApplyDamage({
          victim = params.attacker,
          attacker = self:GetParent(),
          damage = params.original_damage * self:GetAbility():GetSpecialValueFor("damage_return") / 100,
          damage_type = DAMAGE_TYPE_PURE,
          ability = self:GetAbility(),
          damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
      })

        ---self:GetParent():Heal(params.damage, self:GetAbility())

      self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_ice_pearl_cooldown", {duration = self:GetAbility():GetSpecialValueFor("pearl_shield_cooldown")})
    end
  end
end

modifier_item_ice_pearl_reduction = class({})

function modifier_item_ice_pearl_reduction:IsDebuff() return true end
function modifier_item_ice_pearl_reduction:DeclareFunctions()  return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_item_ice_pearl_reduction:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_item_ice_pearl_reduction:StatusEffectPriority() return 1000 end
function modifier_item_ice_pearl_reduction:GetEffectName() return "particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite.vpcf" end
function modifier_item_ice_pearl_reduction:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_ice_pearl_reduction:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor ("attack_speed_reduction") end
function modifier_item_ice_pearl_reduction:GetModifierMoveSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor ("move_speed_reduction") end

modifier_item_ice_pearl_active = class({})

function modifier_item_ice_pearl_active:IsPurgable() return false end
function modifier_item_ice_pearl_active:GetEffectName() return "particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_carapace.vpcf" end
function modifier_item_ice_pearl_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_ice_pearl_active:GetStatusEffectName() return "particles/status_fx/status_effect_frost_armor.vpcf" end
function modifier_item_ice_pearl_active:StatusEffectPriority() return 1000 end
function modifier_item_ice_pearl_active:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_item_ice_pearl_active:OnTakeDamage(params)
    if IsServer() then
        if params.unit == self:GetParent() and params.attacker ~= self:GetParent() and params.attacker:GetClassname() ~= "ent_dota_fountain" and params.attacker:HasModifier("modifier_item_ice_pearl_active") == false then

            ApplyDamage ({
                victim = params.attacker,
                attacker = self:GetParent(),
                damage = params.damage,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self:GetAbility(),
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
            })

            EmitSoundOn("DOTA_Item.BladeMail.Damage", params.attacker)
        end
    end
end

modifier_item_ice_pearl_cooldown = class({})
function modifier_item_ice_pearl_cooldown:IsPurgable() return false end
function modifier_item_ice_pearl_cooldown:RemoveOnDeath() return false end
