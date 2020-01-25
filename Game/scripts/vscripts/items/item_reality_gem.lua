item_reality_gem = class ( {})

LinkLuaModifier( "modifier_item_reality_gem", "items/item_reality_gem.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_reality_gem_active", "items/item_reality_gem.lua", LUA_MODIFIER_MOTION_NONE )

function item_reality_gem:GetIntrinsicModifierName()
    return "modifier_item_reality_gem"
end

function item_reality_gem:GetAOERadius()
    return self:GetSpecialValueFor("reality_reverse_radius")
end

function item_reality_gem:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function item_reality_gem:OnSpellStart()
    if IsServer() then 
        local radius = self:GetSpecialValueFor( "reality_reverse_radius" ) 
        local duration = self:GetSpecialValueFor(  "reality_reverse_duration" )
        local target = self:GetCursorPosition()

        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #targets > 0 then
            for _,enemy in pairs(targets) do
                EmitSoundOn("Item.RealityStone.Unit", enemy)
                enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_reality_gem_active", {duration = duration})
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/items/reality_gem_aoe.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0,  target )
        ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(radius, radius, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 2,  Vector(radius, radius, 0)  )
        ParticleManager:SetParticleControl( nFXIndex, 3,  target )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Item.RealityStone.Cast", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end
---------------------------------------------------------------------------------

if modifier_item_reality_gem_active == nil then
    modifier_item_reality_gem_active = class({})
end
--------------------------------------------------------------------------------

function modifier_item_reality_gem_active:IsPurgable()
    return false
end

function modifier_item_reality_gem_active:IsHidden()
    return false
end

function modifier_item_reality_gem_active:IsDebuff()
    return true
end

function modifier_item_reality_gem_active:GetEffectName()
    return "particles/items/reality_gem_rebuff.vpcf"
end

function modifier_item_reality_gem_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_reality_gem_active:DeclareFunctions() 
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_reality_gem_active:OnTakeDamage( params )
    if IsServer() then
        if params.attacker == self:GetParent() then
            local unit = params.unit

            if unit == self:GetParent() then
                return
            end

            if unit:GetClassname() == "ent_dota_fountain" then
        	   return
            end

            if not params.attacker:IsMagicImmune() then 
                ApplyDamage ( {
                    victim = params.attacker,
                    attacker = unit,
                    damage = params.damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
                })
            end 

            unit:Heal(params.damage * 0.5, self:GetAbility())

            EmitSoundOn("DOTA_Item.BladeMail.Damage", target)
        end
    end
end

if modifier_item_reality_gem == nil then
    modifier_item_reality_gem = class({})
end

function modifier_item_reality_gem:IsHidden()
    return true 
end

function modifier_item_reality_gem:IsPurgable()
    return false
end

function modifier_item_reality_gem:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS
    }

    return funcs
end



function modifier_item_reality_gem:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
end

function modifier_item_reality_gem:GetModifierCastRangeBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_cast_range" )
end

function modifier_item_reality_gem:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_item_reality_gem:GetModifierHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health" )
end

function modifier_item_reality_gem:GetModifierManaBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana" )
end
