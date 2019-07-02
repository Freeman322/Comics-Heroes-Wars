LinkLuaModifier( "modifier_darkrider_time_aura", "abilities/darkrider_time_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_darkrider_time_aura_aura", "abilities/darkrider_time_aura.lua", LUA_MODIFIER_MOTION_NONE )

darkrider_time_aura = class({})

function darkrider_time_aura:OnUpgrade()
    if IsServer() then 
        self:GetCaster():FindAbilityByName("darkrider_alter_reverse"):SetLevel(self:GetLevel())
    end
end

function darkrider_time_aura:OnSpellStart(  )
    if IsServer() then 
        local duration = self:GetSpecialValueFor("duration") 
        if self:GetCaster():HasTalent("special_bonus_unique_darkrider_3") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_darkrider_3") or 0) end 
        
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_darkrider_time_aura_aura", {duration = duration})
        
        EmitSoundOn("Hero_FacelessVoid.TimeDilation.Cast.ti7", self:GetCaster())

        local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate_hex.vpcf", PATTACH_EYES_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() );
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0));
        ParticleManager:SetParticleControl( nFXIndex, 6, Vector(1, 1, 0));
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

if modifier_darkrider_time_aura_aura == nil then modifier_darkrider_time_aura_aura = class({}) end

function modifier_darkrider_time_aura_aura:IsAura()
	return true
end

function modifier_darkrider_time_aura_aura:OnCreated()
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle ("particles/hero_black_flash/rider_dissynchronization.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() );
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0));
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "hit") then
            self:AddParticle( ParticleManager:CreateParticle ("particles/items4_fx/nullifier_mute_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()), false, false, -1, false, true )
        end
    end
end

function modifier_darkrider_time_aura_aura:OnDestroy()
    if IsServer () then
        EmitSoundOn("Hero_FacelessVoid.FunkyFeets", self:GetParent())
    end
end

function modifier_darkrider_time_aura_aura:IsHidden() return false end
function modifier_darkrider_time_aura_aura:IsPurgable() return false end
function modifier_darkrider_time_aura_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_darkrider_time_aura_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_darkrider_time_aura_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_darkrider_time_aura_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD end
function modifier_darkrider_time_aura_aura:GetModifierAura() return "modifier_darkrider_time_aura" end

if modifier_darkrider_time_aura == nil then modifier_darkrider_time_aura = class({}) end

function modifier_darkrider_time_aura:IsPurgable(  ) return false end
function modifier_darkrider_time_aura:RemoveOnDeath() return false end
function modifier_darkrider_time_aura:IsHidden() return true end
function modifier_darkrider_time_aura:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_darkrider_time_aura:StatusEffectPriority() return 1000 end
function modifier_darkrider_time_aura:CheckState()
    if IsServer() then 
        if self:GetCaster() ~= self:GetParent() then 
            return {[MODIFIER_STATE_STUNNED] = true,[MODIFIER_STATE_FROZEN] = true}
        end 
    end 
    return 
end