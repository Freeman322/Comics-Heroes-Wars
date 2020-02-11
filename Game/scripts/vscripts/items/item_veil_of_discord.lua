item_veil_of_discord = class({})
LinkLuaModifier ("item_item_veil_of_discord_buff", "items/item_veil_of_discord.lua", LUA_MODIFIER_MOTION_NONE)

function item_veil_of_discord:GetIntrinsicModifierName()
    return "item_item_veil_of_discord_buff"
end

function item_veil_of_discord:OnSpellStart()
     if IsServer() then
          local radius = self:GetSpecialValueFor( "debuff_radius" ) 
          local duration = self:GetSpecialValueFor(  "resist_debuff_duration" )
          local pos = self:GetCursorPosition()

          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), pos, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          if #units > 0 then
               for _,unit in pairs(units) do
                    unit:AddNewModifier( self:GetCaster(), self, "modifier_item_veil_of_discord_debuff", { duration = duration } )
               end
          end

          local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, nil )
          ParticleManager:SetParticleControl( nFXIndex, 0, pos )
          ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
          ParticleManager:ReleaseParticleIndex( nFXIndex )

          EmitSoundOn( "DOTA_Item.VeilofDiscord.Activate", self:GetCaster() )

          self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
     end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if item_item_veil_of_discord_buff == nil then  item_item_veil_of_discord_buff = class ({}) end
 
function item_item_veil_of_discord_buff:IsHidden() return true end
function item_item_veil_of_discord_buff:IsPurgable()  return true end
 
function item_item_veil_of_discord_buff:DeclareFunctions ()
     local funcs = {
         MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
         MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
         MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
         MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
         MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
     }
 
     return funcs
end

function item_item_veil_of_discord_buff:GetModifierConstantHealthRegen (params)
     return self:GetAbility():GetSpecialValueFor ("bonus_health_regen")
end

function item_item_veil_of_discord_buff:GetModifierPhysicalArmorBonus (params)
     return self:GetAbility():GetSpecialValueFor ("bonus_armor")
end

function item_item_veil_of_discord_buff:GetModifierBonusStats_Agility (params)
     return self:GetAbility():GetSpecialValueFor ("bonus_agi")
end

function item_item_veil_of_discord_buff:GetModifierBonusStats_Intellect (params)
     return self:GetAbility():GetSpecialValueFor ("bonus_int")
end

function item_item_veil_of_discord_buff:GetModifierBonusStats_Strength (params)
     return self:GetAbility():GetSpecialValueFor ("bonus_str")
end