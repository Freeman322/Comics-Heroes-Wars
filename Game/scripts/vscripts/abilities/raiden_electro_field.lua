LinkLuaModifier ("modifier_raiden_electro_field", 				"abilities/raiden_electro_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_raiden_electro_field_passive", "abilities/raiden_electro_field.lua", LUA_MODIFIER_MOTION_NONE)

local CONST_DAMAGE_INTERVAL = 1
local CONST_AURA_FIELD_PARTICLE = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_static_field.vpcf"
local COBST_DAMAGE_PARTICLE = "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc.vpcf"

raiden_electro_field = class ({})

function raiden_electro_field:GetIntrinsicModifierName() return "modifier_raiden_electro_field" end

modifier_raiden_electro_field = class({})

modifier_raiden_electro_field.m_iParticle = nil

function modifier_raiden_electro_field:IsAura() return true end
function modifier_raiden_electro_field:IsHidden() return true end
function modifier_raiden_electro_field:IsPurgable()	return true end
function modifier_raiden_electro_field:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_raiden_electro_field:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_raiden_electro_field:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_raiden_electro_field:GetAuraSearchFlags()	return 0 end
function modifier_raiden_electro_field:GetModifierAura() return "modifier_raiden_electro_field_passive" end

function modifier_raiden_electro_field:OnCreated(params)
    if IsServer() then
        if not self:GetParent():IsRealHero() then self:Destroy() end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "ultron") then
            CONST_AURA_FIELD_PARTICLE = "particles/raiden/raiden_ultron.vpcf"
            COBST_DAMAGE_PARTICLE = "particles/items_fx/dagon.vpcf"
		end

        self:StartIntervalThink(0.3)
    end
end

function modifier_raiden_electro_field:OnIntervalThink()
    if IsServer() then
        self.m_iParticle = ParticleManager:CreateParticle( CONST_AURA_FIELD_PARTICLE, PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControl( self.m_iParticle, 0, self:GetParent():GetAbsOrigin());
    end
end

modifier_raiden_electro_field_passive = class({})

function modifier_raiden_electro_field_passive:IsPurgable() return false end
function modifier_raiden_electro_field_passive:IsHidden() return true end
function modifier_raiden_electro_field_passive:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(CONST_DAMAGE_INTERVAL)
    end
end

function modifier_raiden_electro_field_passive:OnIntervalThink()
    if IsServer() then
        local damage = self:GetAbility():GetAbilityDamage()

        if self:GetCaster():HasTalent("special_bonus_unique_raiden_1") then
            damage = damage + self:GetAbility():GetCaster():FindTalentValue("special_bonus_unique_raiden_1")
        end

        EmitSoundOn("Hero_Zuus.StaticField", self:GetParent())

        local nFXIndex = ParticleManager:CreateParticle( COBST_DAMAGE_PARTICLE, PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );
        
        
        ApplyDamage({
            attacker = self:GetCaster(),
            victim = self:GetParent(),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(),
            damage = damage
        })
    end
end
