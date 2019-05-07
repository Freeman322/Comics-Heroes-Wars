LinkLuaModifier( "modifier_palpatine_dark_aura", "abilities/palpatine_dark_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_palpatine_dark_aura_aura", "abilities/palpatine_dark_aura.lua", LUA_MODIFIER_MOTION_NONE )

palpatine_dark_aura = class({})

function palpatine_dark_aura:OnSpellStart(  )
    if IsServer() then
        local duration = self:GetSpecialValueFor("duration")
        if self:GetCaster():HasTalent("special_bonus_unique_palpatine_4") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_palpatine_4") or 0) end

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_palpatine_dark_aura_aura", {duration = duration})

        EmitSoundOn("Hero_Necrolyte.SpiritForm.Cast", self:GetCaster())
    end
end

if modifier_palpatine_dark_aura_aura == nil then modifier_palpatine_dark_aura_aura = class({}) end

function modifier_palpatine_dark_aura_aura:IsAura() return true end
function modifier_palpatine_dark_aura_aura:IsHidden() return true end
function modifier_palpatine_dark_aura_aura:IsPurgable() return false end
function modifier_palpatine_dark_aura_aura:GetStatusEffectName() return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf" end
function modifier_palpatine_dark_aura_aura:StatusEffectPriority() return 1000 end
function modifier_palpatine_dark_aura_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_palpatine_dark_aura_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_palpatine_dark_aura_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_palpatine_dark_aura_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD end
function modifier_palpatine_dark_aura_aura:GetModifierAura() return "modifier_palpatine_dark_aura" end

function modifier_palpatine_dark_aura_aura:OnCreated(event)
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_palpatine/palpatine_darkaura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_palpatine_dark_aura_aura:DeclareFunctions()return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE} end
function modifier_palpatine_dark_aura_aura:GetModifierTotalDamageOutgoing_Percentage( params ) return self:GetAbility():GetSpecialValueFor("bonus_damage") end


if modifier_palpatine_dark_aura == nil then modifier_palpatine_dark_aura = class({}) end

function modifier_palpatine_dark_aura:IsPurgable() return false end
function modifier_palpatine_dark_aura:RemoveOnDeath() return false end
function modifier_palpatine_dark_aura:IsHidden() return false end
function modifier_palpatine_dark_aura:GetStatusEffectName() return "particles/status_fx/status_effect_huskar_lifebreak.vpcf" end
function modifier_palpatine_dark_aura:StatusEffectPriority() return 1000 end

function modifier_palpatine_dark_aura:OnCreated(params)
    if IsServer() then
        if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
            self:StartIntervalThink(FrameTime())
        end
	end
end

function modifier_palpatine_dark_aura:OnIntervalThink()
    if IsServer() then
        local damage = self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("damage_enemy") / 100)
        if self:GetCaster():HasTalent("special_bonus_unique_palpatine_3") then damage = damage + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_palpatine_3") or 0) end 

        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage * FrameTime(), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN})
	end
end


function modifier_palpatine_dark_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_palpatine_dark_aura:GetModifierMoveSpeedBonus_Percentage( params )
    if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
        return self:GetAbility():GetSpecialValueFor("movement_speed_reduction") * (-1)
    end
    return
end
