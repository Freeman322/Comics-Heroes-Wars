LinkLuaModifier( "modifier_item_glove_of_the_creator", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_death", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )

if item_glove_of_the_creator == nil then item_glove_of_the_creator = class({}) end

function item_glove_of_the_creator:GetIntrinsicModifierName()
	return "modifier_item_glove_of_the_creator"
end

function item_glove_of_the_creator:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function item_glove_of_the_creator:IsRefreshable()
    return false
end

function item_glove_of_the_creator:OnSpellStart()
	if IsServer() then
        EmitSoundOn("Item.InfinityGauntlet.Cast", self:GetCaster())
       
        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, false )
        if #units > 0 then
            for _,unit in pairs(units) do
               if RollPercentage(50) and unit:IsFort() == false and unit ~= self:GetCaster() then
                  unit:AddNewModifier(self:GetCaster(), self, "modifier_item_glove_of_the_creator_death", {duration = math.random(5, 10)})
               end
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/items/infinity_gauntlet_snap_full.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex ) 

        ApplyDamage({victim = self:GetCaster(), attacker = self:GetCaster(), damage = self:GetCaster():GetHealth() / 2, damage_type = DAMAGE_TYPE_PURE})
    end
end
--------------------------------------------------------------------------------
if modifier_item_glove_of_the_creator == nil then
    modifier_item_glove_of_the_creator = class({})
end

function modifier_item_glove_of_the_creator:IsHidden()
    return true 
end

function modifier_item_glove_of_the_creator:IsPurgable()
    return false 
end

function modifier_item_glove_of_the_creator:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

}

return funcs
end

function modifier_item_glove_of_the_creator:GetModifierPreAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end
function modifier_item_glove_of_the_creator:GetModifierBonusStats_Strength( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_glove_of_the_creator:GetModifierBonusStats_Intellect( params )
   return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_glove_of_the_creator:GetModifierBonusStats_Agility( params )
  return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_glove_of_the_creator:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
end
function modifier_item_glove_of_the_creator:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor("bonus_health_regen" )
end

function modifier_item_glove_of_the_creator:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_glove_of_the_creator:OnCreated(params)
   if IsServer() then 
        if self:GetParent():GetUnitName() == "npc_dota_hero_elder_titan" then 
            EmitSoundOn("IG.Thanos", self:GetParent())

            local pfx = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_cast_moonfall_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControlEnt( pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_gauntlet" , self:GetParent():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_gauntlet" , self:GetParent():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( pfx, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_gauntlet" , self:GetParent():GetAbsOrigin(), true )
            ParticleManager:ReleaseParticleIndex(pfx)
        end
   end
end

if not modifier_item_glove_of_the_creator_death then modifier_item_glove_of_the_creator_death = class({}) end 

function modifier_item_glove_of_the_creator_death:OnDestroy()
    if IsServer() then 
        self:GetParent():Kill(self:GetAbility(), self:GetCaster())
    end 
end

function modifier_item_glove_of_the_creator_death:IsHidden()
    return true 
end

function modifier_item_glove_of_the_creator_death:IsPurgable()
    return false 
end

function modifier_item_glove_of_the_creator_death:RemoveOnDeath()
    return false 
end

function modifier_item_glove_of_the_creator_death:IsDebuff()
    return true
end