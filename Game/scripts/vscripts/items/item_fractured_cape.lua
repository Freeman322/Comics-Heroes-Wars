if not item_fractured_cape then item_fractured_cape = class({}) end 

LinkLuaModifier ("modifier_item_fractured_cape_active", "items/item_fractured_cape.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_fractured_cape", "items/item_fractured_cape.lua", LUA_MODIFIER_MOTION_NONE)

function item_fractured_cape:GetIntrinsicModifierName()
    return "modifier_item_fractured_cape"
end

function item_fractured_cape:OnSpellStart ()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            local duration = self:GetSpecialValueFor( "active_duration" )

            hTarget:Purge(false, true, false, true, false)

            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_fractured_cape_active", { duration = duration } )
            EmitSoundOn( "Hero_VoidSpirit.Pulse", hTarget )

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast_ti6_combined.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin() );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            EmitSoundOn( "Hero_VoidSpirit.Pulse.Target", self:GetCaster() )
        end
    end
end

if modifier_item_fractured_cape_active == nil then modifier_item_fractured_cape_active = class({}) end

function modifier_item_fractured_cape_active:IsPurgable() return false end
function modifier_item_fractured_cape_active:IsHidden()  return false end

modifier_item_fractured_cape_active.m_iDamage = 0

function modifier_item_fractured_cape_active:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/fractured_cape.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_item_fractured_cape_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_item_fractured_cape_active:OnDestroy()
    if IsServer() then
        local radius = self:GetAbility():GetSpecialValueFor( "active_radius" ) 
        local duration = self:GetAbility():GetSpecialValueFor(  "stun_duration" )

        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                ApplyDamage( {
                    victim = unit,
                    attacker = self:GetCaster(),
                    damage = self.m_iDamage / #units,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS  
                })
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, 1, radius) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Crystal.CrystalNova.Yulsaria", self:GetParent() )
    end
end

function modifier_item_fractured_cape_active:GetModifierIncomingDamage_Percentage(params)
    self.m_iDamage = self.m_iDamage + (params.original_damage * 0.75)

    return -75
end

if modifier_item_fractured_cape == nil then modifier_item_fractured_cape = class({}) end

function modifier_item_fractured_cape:IsHidden() return true end
function modifier_item_fractured_cape:IsPurgable() return false end
function modifier_item_fractured_cape:IsPermanent() return true end
function modifier_item_fractured_cape:DestroyOnExpire() return false end
function modifier_item_fractured_cape:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_fractured_cape:OnCreated( params )
    if IsServer() then
    end
end

function modifier_item_fractured_cape:OnDestroy()
    if IsServer() then
      
    end
end

function modifier_item_fractured_cape:IsCooldownReady()
   return self:GetRemainingTime() <= 0
end

function modifier_item_fractured_cape:StartCooldown(cd)
    return self:SetDuration(cd, false)
end

function modifier_item_fractured_cape:DeclareFunctions() 
    local funcs = {
	    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_fractured_cape:OnTakeDamage(params)
    if IsServer() then
        if params.damage_type >= DAMAGE_TYPE_MAGICAL then
            if self:IsCooldownReady() and params.unit == self:GetParent() and params.attacker ~= self:GetParent() and params.attacker:IsBuilding() == false and params.attacker:IsRealHero() and self:GetParent():IsRealHero() then
                EmitSoundOn("Item.LotusOrb.Activate", self:GetParent())
    
                ApplyDamage({
                    victim = params.attacker,
                    attacker = self:GetParent(),
                    damage = params.original_damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
                })

                local nFXIndex = ParticleManager:CreateParticle( "particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                
                self:StartCooldown(3.5)
            end
        end
    end
end

function modifier_item_fractured_cape:GetModifierMagicalResistanceBonus( params ) return self:GetAbility():GetSpecialValueFor ("bonus_magic_resist" )  end
function modifier_item_fractured_cape:GetModifierAttackSpeedBonus_Constant( params ) return self:GetAbility():GetSpecialValueFor ("bonus_attack_speed" )  end
function modifier_item_fractured_cape:GetModifierPhysicalArmorBonus( params ) return self:GetAbility():GetSpecialValueFor ("bonus_armor" )  end
function modifier_item_fractured_cape:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )  end
function modifier_item_fractured_cape:GetModifierBonusStats_Strength( params )  return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )  end
function modifier_item_fractured_cape:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_fractured_cape:GetModifierManaBonus( params )  return self:GetAbility():GetSpecialValueFor( "bonus_mana" ) end
function modifier_item_fractured_cape:GetModifierConstantManaRegen( params )   return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )  end
