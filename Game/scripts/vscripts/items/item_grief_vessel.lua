LinkLuaModifier( "modifier_item_grief_vessel", "items/item_grief_vessel.lua", LUA_MODIFIER_MOTION_NONE )

if item_grief_vessel == nil then item_grief_vessel = class({}) end
function item_grief_vessel:GetIntrinsicModifierName() return "modifier_item_grief_vessel" end

--------------------------------------------------------------------------------
if modifier_item_grief_vessel == nil then modifier_item_grief_vessel = class({}) end
function modifier_item_grief_vessel:IsHidden() return false end
function modifier_item_grief_vessel:IsPurgable() return false end
function modifier_item_grief_vessel:DestroyOnExpire() return false end
function modifier_item_grief_vessel:DeclareFunctions() return { MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL } end

function modifier_item_grief_vessel:GetAbsoluteNoDamageMagical( params )
    if IsServer() then
        if params.inflictor and params.damage_type > DAMAGE_TYPE_PHYSICAL and self:GetAbility():IsCooldownReady() then 
            local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/dvine_armor_block.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            EmitSoundOn("DOTA_Item.Buckler.Activate", self:GetParent())

            SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), params.damage, nil )

            self:GetAbility():UseResources(false, false, true)

            return 1
        end 
    end 

    return 
end

function modifier_item_grief_vessel:GetModifierConstantManaRegen( params ) return self:GetAbility():GetSpecialValueFor( "mana_regen" ) end
function modifier_item_grief_vessel:GetModifierPhysicalArmorBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_armor" ) end
