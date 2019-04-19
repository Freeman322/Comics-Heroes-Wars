LinkLuaModifier( "modifier_strange_obliteration_of_eternity", "abilities/strange_obliteration_of_eternity.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_strange_obliteration_of_eternity_aura", "abilities/strange_obliteration_of_eternity.lua", LUA_MODIFIER_MOTION_NONE )

strange_obliteration_of_eternity = class({})

function strange_obliteration_of_eternity:IsStealable() return false end 

function strange_obliteration_of_eternity:OnSpellStart(  )
    if IsServer() then
        local duration = self:GetSpecialValueFor("tooltip_duration")
        if self:GetCaster():HasTalent("special_bonus_unique_strange_2") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_strange_2") or 0) end

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_strange_obliteration_of_eternity_aura", {duration = duration})

        EmitSoundOn("Strange.Obliteration_of_eternity.Cast", self:GetCaster())

        local nFXIndex = ParticleManager:CreateParticle("particles/hero_strange/strange_time_stop_spell.vpcf", PATTACH_EYES_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() );
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() );
        ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetOrigin() );
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

modifier_strange_obliteration_of_eternity_aura = class({})

function modifier_strange_obliteration_of_eternity_aura:IsAura() return true end

function modifier_strange_obliteration_of_eternity_aura:OnCreated()
    if IsServer () then
        local particle = ParticleManager:CreateParticleForPlayer("particles/hero_tzeench/tzeentch_warp_realm_of_chaos_screen.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
        self:AddParticle( particle, false, false, -1, false, true )

        local nFXIndex = ParticleManager:CreateParticle ("particles/dr_starnge/strange_obliteration_of_eternity_eye.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_of_aghamotto", self:GetCaster():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_of_aghamotto", self:GetCaster():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_of_aghamotto", self:GetCaster():GetOrigin(), true );
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_strange_obliteration_of_eternity_aura:OnDestroy()
    if IsServer () then
        EmitSoundOn("Strange.Obliteration_of_eternity.End", self:GetParent())
    end
end

function modifier_strange_obliteration_of_eternity_aura:IsHidden() return false end
function modifier_strange_obliteration_of_eternity_aura:IsPurgable() return false end
function modifier_strange_obliteration_of_eternity_aura:GetAuraRadius()	return 99999 end
function modifier_strange_obliteration_of_eternity_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_strange_obliteration_of_eternity_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_strange_obliteration_of_eternity_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD end
function modifier_strange_obliteration_of_eternity_aura:GetModifierAura()	return "modifier_strange_obliteration_of_eternity" end

modifier_strange_obliteration_of_eternity = class({})

function modifier_strange_obliteration_of_eternity:IsPurgable() return false end
function modifier_strange_obliteration_of_eternity:RemoveOnDeath() return false end
function modifier_strange_obliteration_of_eternity:IsHidden() return true end
function modifier_strange_obliteration_of_eternity:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_strange_obliteration_of_eternity:StatusEffectPriority() return 1000 end
function modifier_strange_obliteration_of_eternity:IsPurgable() return false end
function modifier_strange_obliteration_of_eternity:DeclareFunctions() return { MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE } end
function modifier_strange_obliteration_of_eternity:GetModifierTotalDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("damage_reduction") end

function modifier_strange_obliteration_of_eternity:CheckState()
    if IsServer() then
        if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() or not self:GetParent():IsRealHero() then
            return {[MODIFIER_STATE_STUNNED] = true,[MODIFIER_STATE_FROZEN] = true}
        end
    end
    return
end
