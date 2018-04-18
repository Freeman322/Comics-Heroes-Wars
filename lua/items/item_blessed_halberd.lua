LinkLuaModifier ("modifier_item_blessed_halberd", "items/item_blessed_halberd.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_blessed_halberd_curruption", "items/item_blessed_halberd.lua", LUA_MODIFIER_MOTION_NONE)

item_blessed_halberd = class({})


function item_blessed_halberd:GetIntrinsicModifierName ()
    return "modifier_item_blessed_halberd"
end

function item_blessed_halberd:OnSpellStart()
    if IsServer () then
        local hTarget = self:GetCursorTarget()
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            local duration = self:GetSpecialValueFor ("curruption_duration")
            EmitSoundOn("Hero_Magnataur.ReversePolarity.Stun", hTarget)
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_blessed_halberd_curruption", { duration = duration })
        end
    end
end

modifier_item_blessed_halberd_curruption = class({})

function modifier_item_blessed_halberd_curruption:OnCreated( kv )
    self.curruption_perc = self:GetAbility():GetSpecialValueFor( "curruption_perc" )/100
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_fatesedict_arc_pnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_item_blessed_halberd_curruption:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_item_blessed_halberd_curruption:IsHidden()
    return false
end

function modifier_item_blessed_halberd_curruption:IsPurgable()
    return false
end

function modifier_item_blessed_halberd_curruption:IsDebuff()
    return true
end

function modifier_item_blessed_halberd_curruption:GetModifierPhysicalArmorBonus( params )
    return (-35)
end

function modifier_item_blessed_halberd_curruption:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end


modifier_item_blessed_halberd = class({})

function modifier_item_blessed_halberd:OnCreated( kv )
    if IsServer() then
        self.evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
        self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
        self.str = self:GetAbility():GetSpecialValueFor( "bonus_strength")
    end
end
--------------------------------------------------------------------------------

function modifier_item_blessed_halberd:OnRefresh( kv )
    self.evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
    self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
    self.str = self:GetAbility():GetSpecialValueFor( "bonus_strength")
end

--------------------------------------------------------------------------------

function modifier_item_blessed_halberd:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_item_blessed_halberd:GetModifierEvasion_Constant( params )
    return self.evasion
end

function modifier_item_blessed_halberd:GetModifierPreAttack_BonusDamage( params )
    return self.damage
end

function modifier_item_blessed_halberd:GetModifierBonusStats_Strength( params )
    return self.str
end

function modifier_item_blessed_halberd:IsHidden( params )
    return true
end

function item_blessed_halberd:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

