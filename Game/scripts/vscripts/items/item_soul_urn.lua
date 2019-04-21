item_soul_urn = class({})
LinkLuaModifier ("item_soul_urn_modifier", "items/item_soul_urn.lua", LUA_MODIFIER_MOTION_NONE)

function item_soul_urn:GetIntrinsicModifierName()
    return "item_soul_urn_modifier"
end

function item_soul_urn:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local mana = hTarget:GetMana() / 2

            hTarget:SpendMana(mana, self)
            hTarget:Interrupt()

            self:GetCaster():Heal(mana, self)

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin() );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            local nFXIndexCaster = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf", PATTACH_CUSTOMORIGIN, hTarget );
            ParticleManager:SetParticleControlEnt( nFXIndexCaster, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndexCaster, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndexCaster );
        
            EmitSoundOn("DOTA_Item.Bloodstone.Cast", hTarget)
        end
    end
end


item_soul_urn_modifier = class({})

function item_soul_urn_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_soul_urn_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
    }

    return funcs
end

function item_soul_urn_modifier:OnTakeDamageKillCredit( params )
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent() then 
            if RollPercentage(self:GetAbility():GetSpecialValueFor("critical_chance")) then 
                local damage = (params.damage * (self:GetAbility():GetSpecialValueFor("critical_strike") / 100))

                if params.target == self:GetParent() then return end 
                
                ApplyDamage ( {
                    victim = params.target,
                    attacker = self:GetParent(),
                    damage = damage,
                    damage_type = params.damage_type,
                    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
                })

                SendOverheadEventMessage( params.target, OVERHEAD_ALERT_BONUS_POISON_DAMAGE , params.target, math.floor( damage ), nil )
            end 
        end 
    end 
end


function item_soul_urn_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_soul_urn_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_soul_urn_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_soul_urn_modifier:GetModifierPhysicalArmorBonus ( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function item_soul_urn_modifier:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function item_soul_urn_modifier:GetModifierConstantManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen" )
end

function item_soul_urn:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

