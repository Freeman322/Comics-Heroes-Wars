LinkLuaModifier ("modifier_item_vibranium_sword", "items/item_vibranium_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_vibranium_sword_active", "items/item_vibranium_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_vibranium_sword_crit", "items/item_vibranium_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_vibranium_sword_rupture", "items/item_vibranium_sword.lua", LUA_MODIFIER_MOTION_NONE)
if item_vibranium_sword == nil then
    item_vibranium_sword = class({})
end

function item_vibranium_sword:GetIntrinsicModifierName ()
    return "modifier_item_vibranium_sword"
end

function item_vibranium_sword:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local silence_duration = self:GetSpecialValueFor ("silence_duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_bloodthorn_debuff", { duration = silence_duration } )
            EmitSoundOn ("DOTA_Item.Bloodthorn.Activate", hTarget)
        end
    end
end

if modifier_item_vibranium_sword == nil then
    modifier_item_vibranium_sword = class ( {})
end

function modifier_item_vibranium_sword:IsHidden ()
    return true
end



function modifier_item_vibranium_sword:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_START
    }

    return funcs
end

function modifier_item_vibranium_sword:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_vibranium_sword:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_vibranium_sword:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_vibranium_sword:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_vibranium_sword:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_vibranium_sword:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end

function modifier_item_vibranium_sword:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
          
            local hAbility = self:GetAbility ()
            local chance = hAbility:GetSpecialValueFor ("crit_chance")
            local random = math.random (100)
            if random <= chance then
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_vibranium_sword_crit", nil)
                return 0
            elseif random >= 81 then
                params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_vibranium_sword_rupture", {duration = 5})
                return 0
            end
        end
    end

    return 0
end


if modifier_item_vibranium_sword_crit == nil then
    modifier_item_vibranium_sword_crit = class ( {})
end


function modifier_item_vibranium_sword_crit:IsHidden ()
    return true
end


function modifier_item_vibranium_sword_crit:RemoveOnDeath ()
    return true
end


function modifier_item_vibranium_sword_crit:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_vibranium_sword_crit:GetModifierPreAttack_CriticalStrike (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("crit_multiplier")
end


function modifier_item_vibranium_sword_crit:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetParent ():HasModifier ("modifier_item_vibranium_sword_crit") then
                self:Destroy ()
            end
        end
    end

    return 0
end

if modifier_item_vibranium_sword_active == nil then
    modifier_item_vibranium_sword_active = class ( {})
end

function modifier_item_vibranium_sword_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_item_vibranium_sword_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_vibranium_sword_active:StatusEffectPriority()
    return 1
end

function modifier_item_vibranium_sword_active:GetTexture()
    return "item_vibranium_sword"
end

--------------------------------------------------------------------------------

function modifier_item_vibranium_sword_active:GetEffectName()
    return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_vibranium_sword_active:IsAura()
    return false
end

function modifier_item_vibranium_sword_active:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle("particles/items2_fx/orchid.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
      
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end


function modifier_item_vibranium_sword_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE
    }

    return funcs
end

function modifier_item_vibranium_sword_active:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_item_vibranium_sword_active:GetModifierIncomingDamage_Percentage(params)
    return self:GetAbility():GetSpecialValueFor( "silence_damage_percent" )
end

function modifier_item_vibranium_sword_active:GetModifierPreAttack_Target_CriticalStrike(params)
    return self:GetAbility():GetSpecialValueFor( "target_crit_multiplier" )
end


if modifier_item_vibranium_sword_rupture == nil then
    modifier_item_vibranium_sword_rupture = class({})
end

function modifier_item_vibranium_sword_rupture:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_item_vibranium_sword_rupture:GetTexture()
    return "item_vibranium_sword"
end

--------------------------------------------------------------------------------

function modifier_item_vibranium_sword_rupture:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_vibranium_sword_rupture:OnCreated(event)
    if IsServer() then
        local startup_time = 0.1
        EmitSoundOn( "Hero_Bloodseeker.Rupture", self:GetParent() )
        self.ElapsedDistance = self:GetParent():GetAbsOrigin()
        self:StartIntervalThink(startup_time)
    end
end

function modifier_item_vibranium_sword_rupture:OnIntervalThink()
    local target = self:GetParent()
    local dmg_pers = 1.2
    if target:GetAbsOrigin() ~= self.ElapsedDistance then
        local targetDistance = (target:GetAbsOrigin() - self.ElapsedDistance):Length2D()
        ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), damage = targetDistance*dmg_pers, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
        self.ElapsedDistance = target:GetAbsOrigin()
    end
end

function modifier_item_vibranium_sword_rupture:OnDestroy()
    self.ElapsedDistance = nil
end
function modifier_item_vibranium_sword_rupture:IsHidden()
    return false
end

function modifier_item_vibranium_sword_rupture:IsDebuff()
    return true
end

function modifier_item_vibranium_sword_rupture:IsPurgable()
    return false
end

function modifier_item_vibranium_sword_rupture:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_item_vibranium_sword_rupture:GetModifierMoveSpeedBonus_Percentage( params )
    return (-15)
end


function item_vibranium_sword:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

