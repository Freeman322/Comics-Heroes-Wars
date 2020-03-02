item_spear_of_destiny = class({})

LinkLuaModifier( "modifier_item_spear_of_destiny_active", "items/item_spear_of_destiny.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_spear_of_destiny", "items/item_spear_of_destiny.lua", LUA_MODIFIER_MOTION_NONE )

function item_spear_of_destiny:ProcsMagicStick()
	return false
end

function item_spear_of_destiny:GetIntrinsicModifierName()
	return "modifier_item_spear_of_destiny"
end

function item_spear_of_destiny:OnSpellStart()
    if IsServer() then 
        local target = self:GetCursorTarget()

        if target:IsFriendly(self:GetCaster()) then
            target:AddNewModifier( self:GetCaster(), self, "modifier_item_solar_crest_armor_addition", {duration = self:GetSpecialValueFor("duration")} )
        else 
            if target ~= nil then
                if ( not target:TriggerSpellAbsorb( self ) ) then
                    EmitSoundOn("Item.StarEmblem.Friendly", self:GetCaster())
                    EmitSoundOn("Item.StarEmblem.Enemy", target)
                    
                    target:AddNewModifier( self:GetCaster(), self, "modifier_item_spear_of_destiny_active", {duration = self:GetSpecialValueFor("duration")} )
                    target:AddNewModifier( self:GetCaster(), self, "modifier_item_solar_crest_armor_reduction", {duration = self:GetSpecialValueFor("duration")} )
                end
            end
        end
    end
end

if modifier_item_spear_of_destiny == nil then modifier_item_spear_of_destiny = class({})  end
function modifier_item_spear_of_destiny:IsHidden() return true end
function modifier_item_spear_of_destiny:IsPurgable() return false end

function modifier_item_spear_of_destiny:DeclareFunctions()
local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_spear_of_destiny:GetModifierMoveSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("self_movement_speed") end
function modifier_item_spear_of_destiny:GetModifierHPRegenAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("heal_amplify") end
function modifier_item_spear_of_destiny:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_spear_of_destiny:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_spear_of_destiny:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_spear_of_destiny:GetModifierPreAttack_BonusDamage (params) return self:GetAbility():GetSpecialValueFor ("bonus_damage") end
function modifier_item_spear_of_destiny:GetModifierPhysicalArmorBonus (params) return self:GetAbility():GetSpecialValueFor ("bonus_armor") end

function modifier_item_spear_of_destiny:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
        if params.target ~= nil and params.target.IsBuilding() == false and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
            local damage = params.damage

            ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ))
            
            self:GetParent():Heal(damage * (self:GetAbility():GetSpecialValueFor("bonus_vampirism") / 100), self:GetAbility())
        end
    end
end

function modifier_item_spear_of_destiny:GetModifierProcAttack_BonusDamage_Magical (params)
    if IsServer() then
        if RollPercentage(self:GetAbility():GetSpecialValueFor("bonus_chance")) then 
            if not params.target:IsBuilding() and self:GetParent():IsRealHero() then 
                EmitSoundOn( "DOTA_Item.MKB.Minibash", params.target )
                return self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
            end
        end
    end

    return 0
end

function modifier_item_spear_of_destiny:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_spear_of_destiny_active == nil then modifier_item_spear_of_destiny_active = class({}) end

function modifier_item_spear_of_destiny_active:IsHidden() return true end
function modifier_item_spear_of_destiny_active:IsPurgable() return false end
function modifier_item_spear_of_destiny_active:GetEffectName() return "particles/items_fx/ghost.vpcf" end
function modifier_item_spear_of_destiny_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_spear_of_destiny_active:StatusEffectPriority() return 1000 end

function modifier_item_spear_of_destiny_active:GetStatusEffectName()
    return "particles/econ/courier/courier_trail_ember/courier_trail_ember.vpcf"
end

function modifier_item_spear_of_destiny_active:OnCreated(params)
   if IsServer() then
        self:SetStackCount(self:GetParent():GetPhysicalArmorValue( false ) * (self:GetAbility():GetSpecialValueFor("armor_active_ptc") / 100))
   end
end

function modifier_item_spear_of_destiny_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS 
    }

    return funcs
end

function modifier_item_spear_of_destiny_active:CheckState ()
    local state = {
        [MODIFIER_STATE_BLIND] = true
    }

    return state
end


function modifier_item_spear_of_destiny_active:GetModifierPhysicalArmorBonus( params )
    return self:GetStackCount() * (-1)
end
