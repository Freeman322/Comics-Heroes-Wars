if not item_void_orb then item_void_orb = class({}) end 

LinkLuaModifier ("modifier_item_void_orb_active", "items/item_void_orb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_void_orb", "items/item_void_orb.lua", LUA_MODIFIER_MOTION_NONE)

local exception_spell = 
{   
    ["loki_spell_steal"] = true,
}

function item_void_orb:GetIntrinsicModifierName ()
    return "modifier_item_void_orb"
end

function item_void_orb:OnSpellStart ()
    if IsServer() then 
        self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_void_orb_active", {duration = self:GetSpecialValueFor ("active_duration")})
    end
end

if modifier_item_void_orb_active == nil then
    modifier_item_void_orb_active = class({})
end
function modifier_item_void_orb_active:IsPurgable()
    return false
end
function modifier_item_void_orb_active:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/void_orb/void_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(120, 120, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn ("DOTA_Item.SpiritVessel.Cas", self:GetParent())
        EmitSoundOn ("DOTA_Item.SpiritVessel.Target.Ally", self:GetParent())

        self._iMaxSpellsReflection = self:GetAbility():GetSpecialValueFor("max_spells_block")
    end
end
function modifier_item_void_orb_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_REFLECT_SPELL
    }

    return funcs
end
function modifier_item_void_orb_active:GetAbsorbSpell(keys)
	return 1
end
function modifier_item_void_orb_active:GetReflectSpell(params)
    if IsServer() then 
        local reflected_spell_name = params.ability:GetAbilityName()
        local target = params.ability:GetCaster()  

        if self.stored ~= nil then self.stored:RemoveSelf() end
        if target:GetTeamNumber() == self:GetParent():GetTeamNumber() then return nil end
        if  self._iMaxSpellsReflection <= 0 then self:Destroy() end 

        if ( not exception_spell[reflected_spell_name] ) and (not target:WillReflectAnySpell()) then
            local hCaster = self:GetParent()

            local hAbility = hCaster:AddAbility(params.ability:GetAbilityName())

            hAbility:SetStolen(true) 
            hAbility:SetHidden(true) 
            hAbility:SetLevel(params.ability:GetLevel()) 
            hCaster:SetCursorCastTarget(params.ability:GetCaster()) 
            hAbility:OnSpellStart() 
            self.stored = hAbility 

            ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
            EmitSoundOn( "DOTA_Item.ComboBreaker", self:GetParent( ))

            self._iMaxSpellsReflection = self._iMaxSpellsReflection - 1
            return true
        end
    end
    return false
end

if modifier_item_void_orb == nil then
    modifier_item_void_orb = class({})
end

function modifier_item_void_orb:IsHidden()
    return true 
end

function modifier_item_void_orb:IsPurgable()
    return false
end

function modifier_item_void_orb:DeclareFunctions() 
    local funcs = {
	    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_ABSORB_SPELL
    }

    return funcs
end

function modifier_item_void_orb:GetAbsorbSpell(keys)
	if self:GetAbility():IsCooldownReady() and not self:GetParent():HasModifier("modifier_item_void_orb_active") then
        
        ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
        EmitSoundOn( "DOTA_Item.ComboBreaker", self:GetParent( ))

        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel())/3)
        return 1
	end
	return false
end

function modifier_item_void_orb:GetModifierCastRangeBonus( params )
    return self:GetAbility():GetSpecialValueFor ("cast_range_bonus" ) or 0
end

function modifier_item_void_orb:GetModifierSpellAmplify_Percentage( params )
    return self:GetAbility():GetSpecialValueFor ("spell_amp" ) or 0
end

function modifier_item_void_orb:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) or 0
end

function modifier_item_void_orb:GetModifierBonusStats_Strength( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) or 0
end

function modifier_item_void_orb:GetModifierBonusStats_Agility( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) or 0
end

function modifier_item_void_orb:GetModifierPreAttack_BonusDamage( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_damage" ) or 0
end

function modifier_item_void_orb:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" ) or 0
end

function modifier_item_void_orb:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) or 0
end

