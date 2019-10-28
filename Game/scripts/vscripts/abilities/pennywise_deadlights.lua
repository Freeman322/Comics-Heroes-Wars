LinkLuaModifier( "modifier_pennywise_deadlights_aura", "abilities/pennywise_deadlights.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pennywise_deadlights_debuff", "abilities/pennywise_deadlights.lua", LUA_MODIFIER_MOTION_NONE )

pennywise_deadlights = class({})

function pennywise_deadlights:OnSpellStart(  )
    if IsServer() then
        local duration = self:GetSpecialValueFor("duration")
       
        if self:GetCaster():HasTalent("special_bonus_unique_pennywise_1") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_pennywise_1") or 0) end

        local baloons = Entities:FindAllByClassname("npc_dota_base_additive")

        for _, baloon in pairs(baloons) do
            if baloon and not baloon:IsNull() and baloon:GetUnitLabel() == "baloon_creature" then
                baloon:AddNewModifier(self:GetCaster(), self, "modifier_pennywise_deadlights_aura", {duration = duration})
            end
        end

        EmitSoundOn("Hero_Visage.Death", self:GetCaster())
    end
end

if modifier_pennywise_deadlights_aura == nil then modifier_pennywise_deadlights_aura = class({}) end

function modifier_pennywise_deadlights_aura:IsAura() return true end
function modifier_pennywise_deadlights_aura:IsHidden() return true end
function modifier_pennywise_deadlights_aura:IsPurgable() return false end
function modifier_pennywise_deadlights_aura:GetStatusEffectName() return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf" end
function modifier_pennywise_deadlights_aura:StatusEffectPriority() return 1000 end
function modifier_pennywise_deadlights_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_pennywise_deadlights_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_pennywise_deadlights_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_pennywise_deadlights_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS end
function modifier_pennywise_deadlights_aura:GetModifierAura() return "modifier_pennywise_deadlights_debuff" end

function modifier_pennywise_deadlights_aura:OnCreated(event)
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1))
        
        EmitSoundOn("Hero_Visage.SoulAssumption.Cast", self:GetCaster())

        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

local MAX_SLOPH_DISTANCE = 128.0
local FALL_SPEED = 35.0

if modifier_pennywise_deadlights_debuff == nil then modifier_pennywise_deadlights_debuff = class({}) end

function modifier_pennywise_deadlights_debuff:IsPurgable() return false end
function modifier_pennywise_deadlights_debuff:RemoveOnDeath() return true end
function modifier_pennywise_deadlights_debuff:IsHidden() return false end
function modifier_pennywise_deadlights_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_terrorblade_reflection.vpcf" end
function modifier_pennywise_deadlights_debuff:StatusEffectPriority() return 1000 end

modifier_pennywise_deadlights_debuff._vLoc = nil

function modifier_pennywise_deadlights_debuff:OnCreated(params)
    if IsServer() then
        self._vLoc = self:GetParent():GetBasePos()

        self:StartIntervalThink(1)
        self:OnIntervalThink()
        
        self:GetParent():MoveToPosition(self._vLoc)
	end
end

function modifier_pennywise_deadlights_debuff:OnIntervalThink()
    if IsServer() then
        ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
	end
end


function modifier_pennywise_deadlights_debuff:CheckState()
	local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_DOMINATED] = true,
        [MODIFIER_STATE_HEXED] = true
	}

	return state
end

