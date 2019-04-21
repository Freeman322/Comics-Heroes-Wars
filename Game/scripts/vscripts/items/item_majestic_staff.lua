if not item_majestic_staff then item_majestic_staff = class({}) end 
LinkLuaModifier ("modifier_item_majestic_staff", "items/item_majestic_staff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_majestic_staff_active", "items/item_majestic_staff.lua", LUA_MODIFIER_MOTION_NONE)


function item_majestic_staff:GetAOERadius()
	return self:GetSpecialValueFor( "active_radius" )
end

function item_majestic_staff:GetIntrinsicModifierName()
	return "modifier_item_majestic_staff"
end
--------------------------------------------------------------------------------

function item_majestic_staff:OnSpellStart()
    if IsServer() then 
        local radius = self:GetSpecialValueFor("active_radius") 
        local duration = self:GetSpecialValueFor("duration")
        local target = self:GetCursorPosition()

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
        if #units > 0 then
            for _, unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_item_majestic_staff_active", { duration = duration } )
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_marker.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl(nFXIndex, 0, target)
        ParticleManager:SetParticleControl(nFXIndex, 2, Vector(radius, radius, 0))
        ParticleManager:SetParticleControl(nFXIndex, 4, target)
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Item.Majestic_staff.Cast", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end 
end

if not modifier_item_majestic_staff then modifier_item_majestic_staff = class({}) end 

function modifier_item_majestic_staff:IsHidden() return true end
function modifier_item_majestic_staff:IsPurgable() return true end
function modifier_item_majestic_staff:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, MODIFIER_PROPERTY_HEALTH_BONUS} end
function modifier_item_majestic_staff:GetModifierBonusStats_Strength( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_majestic_staff:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_majestic_staff:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_majestic_staff:GetModifierPhysicalArmorBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_armor" ) end
function modifier_item_majestic_staff:GetModifierMoveSpeedBonus_Constant( params ) return self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" ) end
function modifier_item_majestic_staff:GetModifierConstantManaRegen( params ) return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" ) end
function modifier_item_majestic_staff:GetModifierHealthBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_health" ) end

if not modifier_item_majestic_staff_active then modifier_item_majestic_staff_active = class({}) end 

function modifier_item_majestic_staff_active:IsHidden() return false end
function modifier_item_majestic_staff_active:IsPurgable() return true end
function modifier_item_majestic_staff_active:DeclareFunctions() return { MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_STATUS_RESISTANCE } end
function modifier_item_majestic_staff_active:IsDebuff()
    if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
        return true
    end 
    return false
end

function modifier_item_majestic_staff_active:GetModifierStatusResistance (params) return self:GetAbility():GetSpecialValueFor ("status_resistance") end
function modifier_item_majestic_staff_active:OnCreated(params) if IsServer() then self:StartIntervalThink(1) self:OnIntervalThink() end end

function modifier_item_majestic_staff_active:OnIntervalThink()
    if IsServer() then
        if self:GetParent():IsMagicImmune() and self:IsDebuff() then self:Destroy() end  

        if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
            ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = (self:GetAbility():GetSpecialValueFor("enemy_hp_drain") / 100) * self:GetParent():GetHealth(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
            EmitSoundOn("DOTA_Item.DiffusalBlade.Target", caster) 
        else 
            self:GetParent():Heal((self:GetAbility():GetSpecialValueFor("ally_hp_gain") / 100) * self:GetParent():GetMaxHealth(), self:GetAbility())
        end 
    end 
end

function modifier_item_majestic_staff_active:GetModifierIncomingDamage_Percentage (params)
    if self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("status_resistance")
    end 
    return 
end

function modifier_item_majestic_staff_active:GetEffectName()
    return "particles/items2_fx/majestic_staff_debuff.vpcf"
end

function modifier_item_majestic_staff_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_majestic_staff_active:GetModifierHPRegenAmplify_Percentage (params)
    if self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("hp_regen_reduction_enemy")
    end 
    return self:GetAbility():GetSpecialValueFor ("hp_regen_increase_allies")
end

function modifier_item_majestic_staff_active:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

