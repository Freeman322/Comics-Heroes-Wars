LinkLuaModifier ("modifier_item_frostmourne", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_frostmourne_slowing", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_frostmourne_cooldown_dummy", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)

if item_frostmourne == nil then
    item_frostmourne = class ( {})
end

function item_frostmourne:GetCooldown(iLevel)
    if self:GetCaster():GetUnitName() == "npc_dota_hero_sand_king" or self:GetCaster():GetUnitName() == "npc_dota_hero_skeleton_king" then
        return 60
    end
    return self.BaseClass.GetCooldown( self, iLevel )
end

function item_frostmourne:GetIntrinsicModifierName ()
    return "modifier_item_frostmourne"
end

function item_frostmourne:OnHeroDiedNearby (hVictim, hKiller, kv)
    if hVictim == nil or hKiller == nil then
        return
    end

    if hVictim:GetTeamNumber () ~= self:GetCaster ():GetTeamNumber () and self:GetCaster ():IsAlive () then
        self.range = self:GetSpecialValueFor ("soul_stole_range")
        local vToCaster = self:GetCaster ():GetOrigin () - hVictim:GetOrigin ()
        local flDistance = vToCaster:Length2D ()
        if hKiller == self:GetCaster () or self.range >= flDistance then
            if self.nKills == nil then
                self.nKills = 0
            end
            self:SetCurrentCharges(self:GetCurrentCharges() + 1)
            self.nKills = self.nKills + 1
            self:GetCaster():CalculateStatBonus ()
            local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster () )
            ParticleManager:SetParticleControl (nFXIndex, 1, Vector (1, 0, 0) )
            ParticleManager:ReleaseParticleIndex (nFXIndex)
            self:GetCaster():FindModifierByName("modifier_item_frostmourne"):ForceRefresh()
        end
    end
end

--------------------------------------------------------------------------------

function item_frostmourne:GetFrostmourneStacks ()
    if self.nKills == nil then
        self.nKills = 1
    end
    local damage = self:GetSpecialValueFor ("soul_stole_stack_damage")
    local stacks = self.nKills * damage
    return stacks
end

--------------------------------------------------------------------------------
if modifier_item_frostmourne == nil then
    modifier_item_frostmourne = class ( {})
end

function modifier_item_frostmourne:IsHidden ()
    return true
end

function modifier_item_frostmourne:WillReincarnate()
    return self.IsReincarnating
end

function modifier_item_frostmourne:OnCreated (kv)
    if IsServer () then
        local hAbility = self:GetAbility ()
        self:GetParent ():CalculateStatBonus ()

        self.IsReincarnating = false
    end
end

function modifier_item_frostmourne:OnDestroy(kv)
    if IsServer () then
        local hAbility = self:GetAbility ()
    end
end

function modifier_item_frostmourne:DeclareFunctions ()
    local funcs = {
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

    return funcs
end

function modifier_item_frostmourne:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage") + self:GetAbility():GetFrostmourneStacks()
end
function modifier_item_frostmourne:GetModifierBaseAttack_BonusDamage (params)
    return self:GetAbility():GetFrostmourneStacks()
end
function modifier_item_frostmourne:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_frostmourne:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_frostmourne:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_frostmourne:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_frostmourne:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end

function modifier_item_frostmourne:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hAbility = self:GetAbility ()
            params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_frostmourne_slowing", { duration = 5 })
            local cold_attack_damage = hAbility:GetSpecialValueFor ("cold_attack_damage")
            if params.target:IsBuilding() then
                cold_attack_damage = cold_attack_damage / 2
            end
            if self:GetParent():IsIllusion() then 
              return nil
            end
            EmitSoundOn ("Hero_Ancient_Apparition.Attack", params.target)
            ApplyDamage ( { attacker = hAbility:GetCaster (), victim = params.target, ability = hAbility, damage = cold_attack_damage, damage_type = DAMAGE_TYPE_PURE })
        end
    end
    return 0
end

function modifier_item_frostmourne:ReincarnateTime (params)
    if IsServer () then
        local parent = self:GetParent ()
        if self:GetAbility ():IsCooldownReady () and self:GetAbility():GetName() == "item_frostmourne" then
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
            self.IsReincarnating = true
            
            local respawnPosition = parent:GetAbsOrigin()

            local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
            self.ReincarnateParticle = ParticleManager:CreateParticle (particleName, PATTACH_ABSORIGIN_FOLLOW, parent)
            ParticleManager:SetParticleControl (self.ReincarnateParticle, 0, respawnPosition)
            ParticleManager:SetParticleControl (self.ReincarnateParticle, 1, Vector (500, 0, 0))
            ParticleManager:SetParticleControl (self.ReincarnateParticle, 1, Vector (500, 500, 0))
            parent:EmitSound ("Hero_SkeletonKing.Reincarnate")
            parent:EmitSound ("Hero_SkeletonKing.Death")

            Timers:CreateTimer (3, function ()
                ParticleManager:DestroyParticle (self.ReincarnateParticle, false)
                parent:EmitSound ("Hero_SkeletonKing.Reincarnate.Stinger")

                self.IsReincarnating = false
            end)
            return 3
        end
        return
    end
end

if modifier_item_frostmourne_slowing == nil then
    modifier_item_frostmourne_slowing = class ( {})
end

function modifier_item_frostmourne_slowing:IsBuff ()
    return false
end

function modifier_item_frostmourne_slowing:GetTexture ()
    return "item_frostmourne"
end

function modifier_item_frostmourne_slowing:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_item_frostmourne_slowing:GetStatusEffectName ()
    return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_frostmourne_slowing:StatusEffectPriority ()
    return 1000
end

function modifier_item_frostmourne_slowing:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("cold_attack_speed")
end

function modifier_item_frostmourne_slowing:GetModifierMoveSpeedBonus_Percentage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("cold_movement_speed")
end

function item_frostmourne:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

if not modifier_item_frostmourne_cooldown_dummy then modifier_item_frostmourne_cooldown_dummy = class({}) end

function modifier_item_frostmourne_cooldown_dummy:IsHidden()
    return true
end

function modifier_item_frostmourne_cooldown_dummy:IsPurgable()
    return false
end

function modifier_item_frostmourne_cooldown_dummy:RemoveOnDeath()
    return false
end