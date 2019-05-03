LinkLuaModifier ("modifier_item_frostmourne", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_frostmourne_slowing", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
local kills = 0

item_frostmourne = class({})

function item_frostmourne:IsRefreshable() return false end
function item_frostmourne:GetCooldown(nLevel) return self.BaseClass.GetCooldown( self, nLevel ) end
function item_frostmourne:GetIntrinsicModifierName () return "modifier_item_frostmourne" end

function item_frostmourne:OnHeroDiedNearby (hVictim, hKiller, kv)
    if hVictim == nil or hKiller == nil then
        return
    end

    if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
        self.range = self:GetSpecialValueFor ("soul_stole_range")
        local vToCaster = self:GetCaster ():GetOrigin () - hVictim:GetOrigin ()
        local flDistance = vToCaster:Length2D ()
        if hKiller == self:GetCaster () or self.range >= flDistance then
            if kills == nil then kills = 0 end
            self:SetCurrentCharges(self:GetCurrentCharges() + 1)
            kills = kills + 1
            self:GetCaster():CalculateStatBonus ()
            local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster () )
            ParticleManager:SetParticleControl (nFXIndex, 1, Vector (1, 0, 0) )
            ParticleManager:ReleaseParticleIndex (nFXIndex)
            self:GetCaster():FindModifierByName("modifier_item_frostmourne"):ForceRefresh()
        end
    end
end


function item_frostmourne:GetFrostmourneStacks ()
    if kills == nil then kills = 1 end
    return kills * self:GetSpecialValueFor("soul_stole_stack_damage")
end

modifier_item_frostmourne = class({})

function modifier_item_frostmourne:IsHidden() return true end
function modifier_item_frostmourne:WillReincarnate() return self.IsReincarnating end

function modifier_item_frostmourne:OnCreated (kv)
    if IsServer () then
        self:GetParent ():CalculateStatBonus ()
        self.IsReincarnating = false
    end
end

function modifier_item_frostmourne:DeclareFunctions ()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_REINCARNATION
    }
end

function modifier_item_frostmourne:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor ("bonus_damage") end
function modifier_item_frostmourne:GetModifierBaseAttack_BonusDamage() return self:GetAbility():GetFrostmourneStacks() end
function modifier_item_frostmourne:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor ("bonus_all_stats") end
function modifier_item_frostmourne:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor ("bonus_all_stats") end
function modifier_item_frostmourne:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor ("bonus_all_stats") end
function modifier_item_frostmourne:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor ("bonus_health") end
function modifier_item_frostmourne:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor ("bonus_mana") end

function modifier_item_frostmourne:OnAttackLanded (params)
  if IsServer () then
    if params.attacker == self:GetParent() and params.attacker:IsRealHero() then
      params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_frostmourne_slowing", { duration = self:GetAbility():GetSpecialValueFor("slow_duration") })
      local cold_attack_damage = self:GetAbility():GetSpecialValueFor ("cold_attack_damage")

      if params.target:IsBuilding() then
        cold_attack_damage = cold_attack_damage / 2
      end

      EmitSoundOn ("Hero_Ancient_Apparition.Attack", params.target)
      ApplyDamage ( { attacker = self:GetCaster(), victim = params.target, ability = self:GetAbility(), damage = cold_attack_damage, damage_type = DAMAGE_TYPE_PURE })
    end
  end
  return 0
end

function modifier_item_frostmourne:ReincarnateTime()
  if IsServer() then
    if self:GetAbility():IsCooldownReady() and self:GetParent():IsRealHero() and self:GetAbility():GetCurrentCharges() > 0  then
      self:Reincarnate()
      return self:GetAbility():GetSpecialValueFor("reincarnate_time")
    end
    return 0
  end
end

function modifier_item_frostmourne:Reincarnate()
    if IsServer() then
        -- spend resources
        self:GetAbility():UseResources(true, false, true)

        -- find affected enemies
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),	-- int, your team number
            self:GetParent():GetOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            self:GetAbility():GetSpecialValueFor("slow_radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            0,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
        )

        -- apply slow
        for _,enemy in pairs(enemies) do
            enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wraith_king_reincarnation_debuff", { duration = self:GetAbility():GetSpecialValueFor("slow_duration")})
        end

        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( 3, 0, 0 ) )
        ParticleManager:ReleaseParticleIndex( effect_cast )

        -- play sound
        EmitSoundOn("Hero_SkeletonKing.Reincarnate", self:GetParent())

        self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() - 1)
    end
end

modifier_item_frostmourne_slowing = class({})

function modifier_item_frostmourne_slowing:IsBuff() return false end
function modifier_item_frostmourne_slowing:GetTexture() return "item_frostmourne" end

function modifier_item_frostmourne_slowing:DeclareFunctions ()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_frostmourne_slowing:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end

function modifier_item_frostmourne_slowing:StatusEffectPriority () return 1000 end
function modifier_item_frostmourne_slowing:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor ("cold_attack_speed") * -1 end
function modifier_item_frostmourne_slowing:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor ("cold_movement_speed") * -1 end
