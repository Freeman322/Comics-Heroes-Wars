LinkLuaModifier("modifier_domino_luck_exp", "abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_luck_attention_of_death", "abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_luck_blood_rage", "abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_luck_protection_of_fortune", "abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_luck_unluck","abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_luck_lucky_trick", "abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domino_luck_absolute_luck", "abilities/domino/domino_luck.lua", LUA_MODIFIER_MOTION_NONE)

domino_luck = class ({})

function domino_luck:GetManaCost()
    return self:GetCaster():GetMaxMana() / 10
end

function domino_luck:OnSpellStart()
    local luck = math.random (1, 10)

    if luck == 1 then --Bonus exp
        local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        for _, allies in pairs(allies) do
            allies:AddNewModifier(self:GetCaster(), self, "modifier_domino_luck_exp", {duration = self:GetSpecialValueFor("exp_boost_duration")})
        end


    elseif luck == 2 then --Lightning strike
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999--[[self:GetSpecialValueFor("lightning_radius")]], DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO--[[ + DOTA_UNIT_TARGET_BASIC]], 0, 0, false)
        for _,target in pairs(enemies) do
            EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, target)
            ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
            ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,2000 ))
            ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
            local damage = {
                victim = target,
                attacker = self:GetCaster(),
                damage = self:GetSpecialValueFor("lightning_damage"),
                damage_type = DAMAGE_TYPE_PURE,
                ability = self
            }
            ApplyDamage(damage)
            AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 300, 3, false)
        end


    elseif luck == 3 then --Heal
        local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        for _, allies in pairs(allies) do
            allies:Heal(allies:GetMaxHealth()*(self:GetSpecialValueFor("heal_pct")/100), self:GetCaster())
            EmitSoundOn("DOTA_Item.Mekansm.Activate", allies)
            local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/mekanism_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, allies)
            ParticleManager:SetParticleControl(particle, 0, allies:GetAbsOrigin())
        end



    elseif luck == 4 then -- Attention of death
        local heroes = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), nil, 999999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, 0, 0, false)
        for _,heroes in pairs(heroes) do
            if RollPercentage(self:GetSpecialValueFor("modifier_chance")) then
                heroes:AddNewModifier(self:GetCaster(), self, "modifier_domino_luck_attention_of_death", {duration = 5})
            end
        end

    elseif luck == 5 then --Blood rage
      local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
      for _, allies in pairs(allies) do
        allies:AddNewModifier(self:GetCaster(), self, "modifier_domino_luck_blood_rage", {duration = self:GetSpecialValueFor("blood_rage_duration")})
      end

    elseif luck == 6 then --Protection of Fortune
      local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
      for _, allies in pairs(allies) do
        allies:AddNewModifier(self:GetCaster(), self, "modifier_domino_luck_protection_of_fortune", {duration = self:GetSpecialValueFor("damage_receive_duration")})
      end

    elseif luck == 7 then --Absolute unluck
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
        for _, target in pairs(enemies) do
          target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("unluck_duration")})
          local particle = ParticleManager:CreateParticle("particles/items_fx/abyssal_blade_crimson_jugger.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
          ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
          target:EmitSound("DOTA_Item.AbyssalBlade.Activate")
        end

    elseif luck == 8 then --Lucky trick
      local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
      for _, allies in pairs(allies) do
        allies:AddNewModifier(self:GetCaster(), self, "modifier_domino_luck_lucky_trick", { duration = self:GetSpecialValueFor("lucky_trick_duration") })
      end

    elseif luck == 9 then --gold/exp bonus
      local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
      for _, allies in pairs(allies) do
        allies:ModifyGold(self:GetSpecialValueFor("bonus_gold"), true, 0)--
        allies:AddExperience(self:GetSpecialValueFor("bonus_exp"), false, false)
        allies:EmitSound("DOTA_Item.Hand_Of_Midas")
        local particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf",PATTACH_ABSORIGIN_FOLLOW, allies)
        ParticleManager:SetParticleControl(particle, 0, allies:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, allies:GetAbsOrigin())
      end

    elseif luck == 10 then --МАКСИМАЛЬНОЕ ВЕЗЕНИЕ
        local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        for _, allies in pairs(allies) do
            allies:AddNewModifier(self:GetCaster(), self, "modifier_faceless_void_backtrack", { duration = self:GetSpecialValueFor("absolute_luck_duration"), dodge_chance_pct = self:GetSpecialValueFor("dodge_chance_pct") })
            allies:EmitSound("Hero_FacelessVoid.TimeWalk")
        end
    end
        --cooldown--
    self:EndCooldown()
    if self:GetCaster():HasTalent("special_bonus_unique_domino_4") then
      self:StartCooldown(self:GetCaster():FindTalentValue("special_bonus_unique_domino_4"))
    else
      self:StartCooldown(50)
    end
        --cooldown--
end

modifier_domino_luck_exp = class ({}) --=============== Бонусный опыт ===============--

function modifier_domino_luck_exp:IsHidden() return true end
function modifier_domino_luck_exp:IsPurgable() return false end

function modifier_domino_luck_exp:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_EXP_RATE_BOOST}
    return funcs
end

function modifier_domino_luck_exp:GetModifierPercentageExpRateBoost()
    return self:GetAbility():GetSpecialValueFor("exp_boost")
end

function modifier_domino_luck_exp:GetEffectName()
  return "particles/domino/domino_luck_exp.vpcf"
end

function modifier_domino_luck_exp:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

modifier_domino_luck_attention_of_death = class ({}) --=============== Внимание смерти ===============--

function modifier_domino_luck_attention_of_death:IsDebuff() return true end
function modifier_domino_luck_attention_of_death:IsPurgable() return false end

function modifier_domino_luck_attention_of_death:OnCreated()
    self.random = math.random(1,100)
    self:StartIntervalThink(0.01)
    self.trigger = 0
end

function modifier_domino_luck_attention_of_death:OnIntervalThink()
    if self.random <= self:GetAbility():GetSpecialValueFor("death_chance") then
        if self:GetElapsedTime() > 3.59 and self.trigger == 0 then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 1.4})
            local pop_pfx = ParticleManager:CreateParticle("particles/domino/domino_luck_attention_of_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(pop_pfx, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(pop_pfx, 1, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(pop_pfx, 9, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(pop_pfx, 4, self:GetParent():GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(pop_pfx)
            EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast.ti7", self:GetParent())
            EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target", self:GetParent())
            self.trigger = 1
        end
    end
end

function modifier_domino_luck_attention_of_death:OnDestroy()
  if IsServer() then
    if self.random <= self:GetAbility():GetSpecialValueFor("death_chance") then
        self:GetParent():ForceKill(false)
    end
    self.trigger = 0
  end
end

function modifier_domino_luck_attention_of_death:IsHidden() return true end
function modifier_domino_luck_attention_of_death:IsPurgable() return false end


modifier_domino_luck_blood_rage = class({}) --=============== Кровавая ярость ===============--

function modifier_domino_luck_blood_rage:IsHidden() return true end
function modifier_domino_luck_blood_rage:IsPurgable() return false end

function modifier_domino_luck_blood_rage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
    }
    return funcs
end

function modifier_domino_luck_blood_rage:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("blood_rage_AS_bonus")
end

function modifier_domino_luck_blood_rage:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("blood_rage_MS_bonus_pct")
end

function modifier_domino_luck_blood_rage:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("blood_rage_D_bonus")
end

function modifier_domino_luck_blood_rage:GetModifierHPRegenAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("blood_rage_healing_weak") * -1
end

function modifier_domino_luck_blood_rage:GetEffectName()
    return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"
end

function modifier_domino_luck_blood_rage:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_domino_luck_protection_of_fortune = class({})  --=============== Защита Фортуны ===============--

function modifier_domino_luck_protection_of_fortune:IsHidden() return true end
function modifier_domino_luck_protection_of_fortune:IsPurgable() return false end
function modifier_domino_luck_protection_of_fortune:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_domino_luck_protection_of_fortune:OnTakeDamage(params)
    if params.unit == self:GetParent() then
        local particle = ParticleManager:CreateParticle("particles/domino/domino_luck_protection_of_fortune.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
        ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( particle )
        self:GetParent():Heal(params.damage * ((100 - self:GetAbility():GetSpecialValueFor("damage_receive"))/100), self:GetAbility())
    end
end

modifier_domino_luck_lucky_trick = class ({})

function modifier_domino_luck_lucky_trick:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_ABSORB_SPELL}
    return funcs
end

function modifier_domino_luck_lucky_trick:GetEffectName()
  return "particles/domino/domino_luck_lucky_trick.vpcf"
end

function modifier_domino_luck_lucky_trick:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_domino_luck_lucky_trick:GetAbsorbSpell(keys)--GetAbsorbSpell(keys)
    if self.stored ~= nil then
        self.stored:RemoveSelf() --we make sure to remove previous spell.
    end
    local hCaster = self:GetParent()
    EmitSoundOn("Hero_Antimage.Counterspell.Absorb", self:GetParent())
    if keys.ability:GetAbilityName() == "loki_spell_steal" then
        return nil
    end
    local hAbility = hCaster:AddAbility(keys.ability:GetAbilityName())
    hAbility:SetStolen(true) --just to be safe with some interactions.
    hAbility:SetHidden(true) --hide the ability.
    hAbility:SetLevel(keys.ability:GetLevel()) --same level of ability as the origin.
    hCaster:SetCursorCastTarget(keys.ability:GetCaster()) --lets send this spell back.
    hAbility:OnSpellStart() --cast the spell.
    self.stored = hAbility --store the spell reference for future use.

    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
    return 1
end
