LinkLuaModifier( "modifier_item_dvine_armor", "items/item_dvine_armor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_dvine_armor_aura", "items/item_dvine_armor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_dvine_armor_active", "items/item_dvine_armor.lua", LUA_MODIFIER_MOTION_NONE )

if item_dvine_armor == nil then item_dvine_armor = class({}) end
function item_dvine_armor:GetIntrinsicModifierName() return "modifier_item_dvine_armor" end
function item_dvine_armor:GetBehavior() return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
function item_dvine_armor:OnSpellStart() if IsServer() then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_dvine_armor_active", {duration = self:GetSpecialValueFor("active_flux_duration")}) end end

--------------------------------------------------------------------------------
if modifier_item_dvine_armor == nil then modifier_item_dvine_armor = class({}) end
function modifier_item_dvine_armor:IsHidden() return false end
function modifier_item_dvine_armor:IsPurgable() return false end
function modifier_item_dvine_armor:DestroyOnExpire() return false end
function modifier_item_dvine_armor:DeclareFunctions() return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL } end
function modifier_item_dvine_armor:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_dvine_armor:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
 
function modifier_item_dvine_armor:GetAbsoluteNoDamageMagical( params )
    if IsServer() then
        if params.inflictor and params.damage_type > DAMAGE_TYPE_PHYSICAL and self:IsCooldownReady() then 
            local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/dvine_armor_block.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            EmitSoundOn("DOTA_Item.Buckler.Activate", self:GetParent())

            SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), params.damage, nil )
            
            self:StartCooldown(self:GetAbility():GetSpecialValueFor("dvine_shield_cooldown"))

            return 1
        end 
    end 

    return 
end

function modifier_item_dvine_armor:GetModifierPreAttack_BonusDamage( params ) return self:GetAbility():GetSpecialValueFor( "bonus_damage" ) end
function modifier_item_dvine_armor:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_intellect" ) end
function modifier_item_dvine_armor:GetModifierPhysicalArmorBonus( params ) return self:GetAbility():GetSpecialValueFor( "bonus_armor" ) end
function modifier_item_dvine_armor:IsAura() return true end
function modifier_item_dvine_armor:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_dvine_armor:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_dvine_armor:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_item_dvine_armor:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_dvine_armor:GetModifierAura() return "modifier_item_dvine_armor_aura" end

if not modifier_item_dvine_armor_aura then modifier_item_dvine_armor_aura = class({}) end 

function modifier_item_dvine_armor_aura:IsHidden() return false end
function modifier_item_dvine_armor_aura:GetEffectName() return "particles/items2_fx/radiance.vpcf" end
function modifier_item_dvine_armor_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_dvine_armor_aura:OnCreated(params) if IsServer() then self:StartIntervalThink(1) self:OnIntervalThink() end end
function modifier_item_dvine_armor_aura:OnIntervalThink()
    if IsServer() then ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("aura_damage"), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION}) end
end

if not modifier_item_dvine_armor_active then modifier_item_dvine_armor_active = class({}) end 
function modifier_item_dvine_armor_active:IsHidden() return false end
function modifier_item_dvine_armor_active:IsPurgable() return true end
function modifier_item_dvine_armor_active:OnCreated(params) 
    if IsServer() then self:StartIntervalThink(.05) self:OnIntervalThink() 
        EmitSoundOn("Fate.Phasemirror.Cast", self:GetParent())
    end 
end

function modifier_item_dvine_armor_active:OnIntervalThink()
    if IsServer() then
        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("active_flux_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
        if #units > 0 then
            for _, unit in pairs(units) do
                local damage = (self:GetAbility():GetSpecialValueFor("active_flux_radius") - (unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()) * FrameTime()

                ApplyDamage ( {
                    victim = unit,
                    attacker = self:GetCaster(),
                    damage = damage * self:GetAbility():GetSpecialValueFor("active_flux_mult"),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                })
            end
        end
    end 
end

function modifier_item_dvine_armor_active:GetStatusEffectName() return "particles/status_fx/status_effect_burn.vpcf" end
function modifier_item_dvine_armor_active:StatusEffectPriority() return 1000 end
function modifier_item_dvine_armor_active:GetEffectName() return "particles/hero_doctor_fate/phase_mirror_aura.vpcf" end
function modifier_item_dvine_armor_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end