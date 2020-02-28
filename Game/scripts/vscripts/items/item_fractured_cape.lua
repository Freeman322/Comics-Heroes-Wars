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

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )

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
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, 1, radius) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Crystal.CrystalNova.Yulsaria", self:GetCaster() )
    end
end

function modifier_item_fractured_cape_active:GetModifierIncomingDamage_Percentage(params)
    self.m_iDamage = self.m_iDamage + (params.original_damage * 0.75)

    return -75
end

if modifier_item_fractured_cape == nil then modifier_item_fractured_cape = class({}) end

function modifier_item_fractured_cape:IsHidden() return true  end
function modifier_item_fractured_cape:IsPurgable() return false end
function modifier_item_fractured_cape:IsPermanent() return true end
function modifier_item_fractured_cape:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_fractured_cape:OnCreated( params )
    if IsServer() then
        self.mod = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_special_bonus_spell_block", nil)
    end
end

function modifier_item_fractured_cape:OnDestroy()
    if IsServer() then
        if self.mod and not self.mod:IsNull() then
            UTIL_Remove(self.mod)
        end
    end
end

function modifier_item_fractured_cape:DeclareFunctions() 
    local funcs = {
	    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_BONUS
    }

    return funcs
end

function modifier_item_fractured_cape:GetModifierPhysicalArmorBonus( params ) return self:GetAbility():GetSpecialValueFor ("bonus_armor" )  end
function modifier_item_fractured_cape:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )  end
function modifier_item_fractured_cape:GetModifierBonusStats_Strength( params )  return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )  end
function modifier_item_fractured_cape:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_fractured_cape:GetModifierManaBonus( params )  return self:GetAbility():GetSpecialValueFor( "bonus_mana" ) end
function modifier_item_fractured_cape:GetModifierConstantManaRegen( params )   return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )  end
