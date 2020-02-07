LinkLuaModifier( "modifier_manhattan_clockwork_mechanism", "abilities/manhattan_clockwork_mechanism.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_manhattan_clockwork_mechanism_aura", "abilities/manhattan_clockwork_mechanism.lua", LUA_MODIFIER_MOTION_NONE )

local CONST_RED_PTC = -95

manhattan_clockwork_mechanism = class({})

function manhattan_clockwork_mechanism:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor("duration")
        
        if self:GetCaster():HasTalent("special_bonus_unique_manhattan_1") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_manhattan_1") or 0) end

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_manhattan_clockwork_mechanism_aura", {duration = duration})

        EmitSoundOn("Manhattan.Elemental_Fragmentation.Start", self:GetCaster())
    end
end

if modifier_manhattan_clockwork_mechanism_aura == nil then modifier_manhattan_clockwork_mechanism_aura = class({}) end

function modifier_manhattan_clockwork_mechanism_aura:IsAura() return true end
function modifier_manhattan_clockwork_mechanism_aura:IsHidden() return true end
function modifier_manhattan_clockwork_mechanism_aura:IsPurgable() return false end
function modifier_manhattan_clockwork_mechanism_aura:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_manhattan_clockwork_mechanism_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_manhattan_clockwork_mechanism_aura:GetStatusEffectName() return "particles/status_fx/status_effect_wraithking_ghosts.vpcf" end
function modifier_manhattan_clockwork_mechanism_aura:StatusEffectPriority() return 1000 end

function modifier_manhattan_clockwork_mechanism_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end

function modifier_manhattan_clockwork_mechanism_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_manhattan_clockwork_mechanism_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_manhattan_clockwork_mechanism_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD end
function modifier_manhattan_clockwork_mechanism_aura:GetModifierAura() return "modifier_manhattan_clockwork_mechanism" end

function modifier_manhattan_clockwork_mechanism_aura:OnCreated(event)
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle( "particles/dr_manhattan/manhattan_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_manhattan_clockwork_mechanism_aura:DeclareFunctions()return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end
function modifier_manhattan_clockwork_mechanism_aura:GetModifierPercentageCooldown() return 99 end


if modifier_manhattan_clockwork_mechanism == nil then modifier_manhattan_clockwork_mechanism = class({}) end

function modifier_manhattan_clockwork_mechanism:IsPurgable() return false end
function modifier_manhattan_clockwork_mechanism:RemoveOnDeath() return false end
function modifier_manhattan_clockwork_mechanism:IsHidden() return false end
function modifier_manhattan_clockwork_mechanism:GetStatusEffectName() return "particles/status_fx/status_effect_enigma_blackhole_tgt.vpcf" end
function modifier_manhattan_clockwork_mechanism:StatusEffectPriority() return 1000 end

function modifier_manhattan_clockwork_mechanism:OnCreated(params)
     self.time_coff = self:GetAbility():GetSpecialValueFor("time_coff")
     self.speed = 1

     if IsServer() then
          self.speed = self:GetParent():GetProjectileSpeed() or 500

          for i = 0, 15, 1 do  
               local current_ability = self:GetParent():GetAbilityByIndex(i)
               
               if current_ability ~= nil then
                    current_ability:SetFrozenCooldown(true)
               end
           end
           for i = 0, 5, 1 do
               local current_item = self:GetParent():GetItemInSlot(i)
               
               if current_item ~= nil then
                    current_item:SetFrozenCooldown(true)
               end
          end

          self:StartIntervalThink(1)
          self:OnIntervalThink()
     end
end

function modifier_manhattan_clockwork_mechanism:OnDestroy()
     if IsServer() then
          for i = 0, 15, 1 do  
               local current_ability = self:GetParent():GetAbilityByIndex(i)
               
               if current_ability ~= nil then
                    current_ability:SetFrozenCooldown(false)
               end
           end
           for i = 0, 5, 1 do
               local current_item = self:GetParent():GetItemInSlot(i)
               
               if current_item ~= nil then
                    current_item:SetFrozenCooldown(false)
               end
          end

          EmitSoundOn ("Manhattan.Elemental_Fragmentation.Damage", self:GetParent())
     end
end

function modifier_manhattan_clockwork_mechanism:OnIntervalThink()
    if IsServer() then
        local damage = self:GetAbility():GetSpecialValueFor("damage")
        if self:GetCaster():HasTalent("special_bonus_unique_manhattan_2") then damage = damage + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_manhattan_2") or 0) end 

        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage * self.time_coff, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end


function modifier_manhattan_clockwork_mechanism:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS 
    }

    return funcs
end

function modifier_manhattan_clockwork_mechanism:GetModifierMoveSpeedBonus_Percentage( params )
     return self:GetAbility():GetSpecialValueFor("movespeed_slow") * self.time_coff
end

function modifier_manhattan_clockwork_mechanism:GetModifierAttackSpeedBonus_Constant( params )
     return self:GetAbility():GetSpecialValueFor("attack_slow") * self.time_coff
end

function modifier_manhattan_clockwork_mechanism:GetModifierTurnRate_Percentage( params )
     return CONST_RED_PTC
end

function modifier_manhattan_clockwork_mechanism:GetModifierProjectileSpeedBonus( params )
     if self:GetParent():IsRangedAttacker() then 
          return ((self.speed or 500) - 24) * (-1)
     end 
     return 
end