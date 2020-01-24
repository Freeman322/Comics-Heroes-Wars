LinkLuaModifier ("modifier_item_frostmourne", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_frostmourne_slowing", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_death_scyche_active", "items/item_death_scyche.lua", LUA_MODIFIER_MOTION_NONE)

item_frostmourne = class({})

function item_frostmourne:OnSpellStart ()
    if IsServer() then
        local duration = self:GetSpecialValueFor ("active_effect_duration")

        self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_death_scyche_active", { duration = duration } )

        local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
        ParticleManager:SetParticleControlEnt (nFXIndex, 2, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster ():GetOrigin (), true)
        ParticleManager:ReleaseParticleIndex (nFXIndex)

        EmitSoundOn ("Hero_DoomBringer.Devour", self:GetCaster () )
    end
end

function item_frostmourne:IsRefreshable() return false end
function item_frostmourne:GetCooldown(nLevel) return self.BaseClass.GetCooldown( self, nLevel ) end
function item_frostmourne:GetIntrinsicModifierName() return "modifier_item_frostmourne" end

function item_frostmourne:OnHeroDiedNearby (hVictim, hKiller, kv)
    if hVictim == nil or hKiller == nil then
        return
    end

    if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
        self.range = self:GetSpecialValueFor ("soul_stole_range")

        local vToCaster = self:GetCaster ():GetOrigin () - hVictim:GetOrigin ()
        local flDistance = vToCaster:Length2D ()

        if hKiller == self:GetCaster () or self.range >= flDistance then
            self:SetCurrentCharges(self:GetCurrentCharges() + 1)

            self:GetCaster():CalculateStatBonus()

            local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster () )
            ParticleManager:SetParticleControl (nFXIndex, 1, Vector (1, 0, 0) )
            ParticleManager:ReleaseParticleIndex (nFXIndex)

            self:GetCaster():FindModifierByName("modifier_item_frostmourne"):ForceRefresh()
        end
    end
end

modifier_item_frostmourne = class({})

function modifier_item_frostmourne:IsHidden() return true end
function modifier_item_frostmourne:IsPurgable() return true end

modifier_item_frostmourne.m_hMod = nil

function modifier_item_frostmourne:OnCreated (kv)
    if IsServer () then
        self:GetParent():CalculateStatBonus ()

        self:StartIntervalThink(FrameTime())

        if self.m_hMod and not self.m_hMod:IsNull() then
            self.m_hMod:Destroy()
        end

        self.m_hMod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_special_bonus_reincarnation", nil)
    end
end

function modifier_item_frostmourne:OnDestroy()
    if IsServer () then
        if self.m_hMod and not self.m_hMod:IsNull() then
            self.m_hMod:Destroy()
        end
    end
end

function modifier_item_frostmourne:OnIntervalThink()
    if IsServer () then
        self:SetStackCount(self:GetAbility():GetCurrentCharges())
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
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_frostmourne:GetModifierPreAttack_BonusDamage()
    return (self:GetAbility():GetSpecialValueFor ("bonus_damage") + (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("soul_stole_stack_damage") * (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_lich_king") or 1)))
end
function modifier_item_frostmourne:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_frostmourne:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_frostmourne:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_frostmourne:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_frostmourne:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor("bonus_mana") end

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
