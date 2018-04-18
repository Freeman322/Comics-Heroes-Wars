LinkLuaModifier( "item_time_gem", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_time_gem_active", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )

if item_time == nil then item_time = class({}) end

function item_time:GetIntrinsicModifierName()
	return "item_time_gem"
end

function item_time:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
	return behav
end

function item_time:OnSpellStart()
	if IsServer() then
        if not self:GetCaster():HasModifier("item_time_gem_active") then
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "item_time_gem_active", {duration = self:GetSpecialValueFor("duration")})
        else
            self:EndCooldown()
        end
    end
end
--------------------------------------------------------------------------------
if item_time_gem == nil then
    item_time_gem = class({})
end

function item_time_gem:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_time_gem:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_time_gem:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

return funcs
end

function item_time_gem:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_time_gem:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

function item_time_gem:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function item_time_gem:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

if item_time_gem_active == nil then item_time_gem_active = class({}) end

function item_time_gem_active:IsPurgable()
    return false
end

function item_time_gem_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

--------------------------------------------------------------------------------

function item_time_gem_active:StatusEffectPriority()
    return 1000
end

--------------------------------------------------------------------------------

function item_time_gem_active:GetEffectName()
    return "particles/econ/items/pugna/pugna_ward_golden_nether_lord/pugna_gold_ambient.vpcf"
end

--------------------------------------------------------------------------------

function item_time_gem_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function item_time_gem_active:RemoveOnDeath()
    return false
end

function item_time_gem_active:OnCreated( params )
    if IsServer() then
        local nFXIndexCast = ParticleManager:CreateParticle( "particles/item_time/time_gem_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(nFXIndexCast, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndexCast, 1, Vector(0, 0, 0))
        ParticleManager:SetParticleControl(nFXIndexCast, 2, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(nFXIndexCast, 3, self:GetParent():GetAbsOrigin())

        EmitSoundOn("Hero_FacelessVoid.Chronosphere.MaceOfAeons", self:GetParent())
        EmitSoundOn("Hero_FacelessVoid.TimeDilation.Cast.ti7_layer", self:GetParent())

        self.data = {}
        self.data["abilities"] = {}
        self.data["items"] = {}
        self.data["health"] = self:GetParent():GetHealth()
        self.data["mana"] = self:GetParent():GetMana()
        self.data["origin"] = self:GetParent():GetOrigin()

        for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
            local current_ability = self:GetCaster ():GetAbilityByIndex (i)
            if current_ability ~= nil then
                if current_ability:GetMaxLevel() > 3 then
                   table.insert(self.data["abilities"], i, current_ability:GetCooldownTimeRemaining())
                end
            end
        end

        for i=0, 5, 1 do
            local current_item = self:GetCaster ():GetItemInSlot (i)
            if current_item ~= nil then
                table.insert(self.data["items"], i, current_item:GetCooldownTimeRemaining())
            end
        end
    end
end

function item_time_gem_active:OnDeathEmit()
    if IsServer() then
        local nFXIndexCast = ParticleManager:CreateParticle( "particles/item_time/time_gem_active_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(nFXIndexCast, 0, self:GetParent():GetAbsOrigin())

        EmitSoundOn("Hero_FacelessVoid.Chronosphere.MaceOfAeons", self:GetParent())
        EmitSoundOn("Hero_FacelessVoid.TimeDilation.Cast.ti7_layer", self:GetParent())

        self:GetParent():RespawnHero(false, false)

        self:GetParent():SetHealth(self.data["health"])
        self:GetParent():SetMana(self.data["mana"])
        self:GetParent():SetAbsOrigin(self.data["origin"])

        for k,v in pairs(self.data["abilities"]) do
            local ability = self:GetParent():GetAbilityByIndex(k)
            ability:EndCooldown()
            ability:StartCooldown(v)
        end

        for k,v in pairs(self.data["items"]) do
            local item = self:GetParent():GetItemInSlot(k)
            if item ~= nill then
                item:EndCooldown()
                item:StartCooldown(v)
            end
        end
    end
end
