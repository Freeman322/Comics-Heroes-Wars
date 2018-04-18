LinkLuaModifier ("modifier_ruby_sphere", "items/item_ruby_sphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ruby_sphere", "items/item_ruby_sphere.lua", LUA_MODIFIER_MOTION_NONE)
if item_ruby_sphere == nil then
    item_ruby_sphere = class({})
end
function item_ruby_sphere:GetIntrinsicModifierName()
    return "modifier_item_ruby_sphere"
end
function item_ruby_sphere:CastFilterResultTarget (hTarget)
    if IsServer () then
        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

--------------------------------------------------------------------------------

function item_ruby_sphere:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

--------------------------------------------------------------------------------

function item_ruby_sphere:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        local duration = self:GetSpecialValueFor ("duration")
        hTarget:AddNewModifier (self:GetCaster (), self, "modifier_ruby_sphere", { duration = duration } )
        EmitSoundOn ("Item.LotusOrb.Activate", hTarget)
    end
end

if modifier_ruby_sphere == nil then
    modifier_ruby_sphere = class({})
end

function modifier_ruby_sphere:GetTexture()
    return "item_ruby_sphere"
end

function modifier_ruby_sphere:IsPurgable()
    return false
end

function modifier_ruby_sphere:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/effects/lotus_shell.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100, 100, 100))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))
        ParticleManager:SetParticleControl( nFXIndex, 3, Vector(100, 100, 100))
        ParticleManager:SetParticleControl( nFXIndex, 4, Vector(100, 100, 100))
        ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_ruby_sphere:OnDestroy()
    EmitSoundOn ("Item.LotusOrb.Destroy", self:GetParent())
end


function modifier_ruby_sphere:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_REFLECT_SPELL
    }

    return funcs
end

function modifier_ruby_sphere:GetReflectSpell(params)
    if IsServer() then
        local hAbility = self:GetAbility()
        self:GetParent():Purge(true, true, false, true, false) 
        EmitSoundOn ("Item.LotusOrb.Target", self:GetParent())
        return 1
    end
end

function modifier_ruby_sphere:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local damage = params.damage
            local attackName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf" 
            local attack = ParticleManager:CreateParticle(attackName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(attack, 1, target:GetAbsOrigin())
            local nearby_units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, 475, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
            for i, units in ipairs(nearby_units) do
                if target:GetClassname() == "ent_dota_fountain" then
                    return
                else
                    units:ModifyHealth(units:GetHealth() - damage, self:GetAbility(), true, 0)
                    ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, units)
                end
            end

            EmitSoundOn("Hero_Pugna.NetherWard.Target", self:GetParent())

            local nFXIndex = ParticleManager:CreateParticle("particles/echo_shield/echo_shield_reflect.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetAbsOrigin()) 
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        end
    end
end

if modifier_item_ruby_sphere == nil then
    modifier_item_ruby_sphere = class({})
end

function modifier_item_ruby_sphere:IsHidden()
    return true 
end

function modifier_item_ruby_sphere:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE
    }

    return funcs
end

function modifier_item_ruby_sphere:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function modifier_item_ruby_sphere:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_ruby_sphere:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function modifier_item_ruby_sphere:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function item_ruby_sphere:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

