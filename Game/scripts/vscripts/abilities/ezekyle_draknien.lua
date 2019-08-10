ezekyle_draknien = class({})
LinkLuaModifier( "modifier_ezekyle_draknien", "abilities/ezekyle_draknien.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ezekyle_draknien_debuff", "abilities/ezekyle_draknien.lua", LUA_MODIFIER_MOTION_NONE )

function ezekyle_draknien:GetIntrinsicModifierName () return "modifier_ezekyle_draknien" end
function ezekyle_draknien:GetCooldown( nLevel ) return self.BaseClass.GetCooldown( self, nLevel ) end

function ezekyle_draknien:OnSpellStart()
    if IsServer() then
      local hTarget = self:GetCursorTarget()
      if hTarget ~= nil then
        self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
      end
    end
end

if modifier_ezekyle_draknien == nil then modifier_ezekyle_draknien = class({}) end

function modifier_ezekyle_draknien:IsHidden() return false end
function modifier_ezekyle_draknien:IsPurgable() return false end
function modifier_ezekyle_draknien:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_START
    }

    return funcs
end


function modifier_ezekyle_draknien:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                if not params.target:IsBuilding() and not params.target:IsAncient() then
                    self:GetParent():RemoveGesture(ACT_DOTA_ATTACK) 
                    self:GetParent():RemoveGesture(ACT_DOTA_ATTACK2)
                    self:GetParent():StartGesture(ACT_DOTA_ATTACK_EVENT_BASH)        
                end         
            end
        end
    end

    return 0
end


function modifier_ezekyle_draknien:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                if not params.target:IsBuilding() and not params.target:IsAncient() then
                    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ezekyle_draknien_debuff", {duration = self:GetAbility():GetSpecialValueFor("soul_duration")})
                    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})

                    self:GetAbility():UseResources(true, false, true)

                    EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
                    EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)

                    EmitSoundOn("doom_bringer_doom_radiance_02", self:GetParent())
                end
            end
        end
    end
    
    return 0
end


if modifier_ezekyle_draknien_debuff == nil then modifier_ezekyle_draknien_debuff = class ( {}) end

function modifier_ezekyle_draknien_debuff:GetEffectName () return "particles/units/heroes/hero_spectre/spectre_desolate_debuff.vpcf" end
function modifier_ezekyle_draknien_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ezekyle_draknien_debuff:OnCreated(event)
  if IsServer() then
    EmitSoundOn("Hero_DoomBringer.InfernalBlade.Target", thinker)    

    ApplyDamage ( { victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = (self:GetAbility():GetSpecialValueFor("soul_damage") / 100) * self:GetParent():GetHealth(), damage_type = DAMAGE_TYPE_PURE})

    self:StartIntervalThink(1)
    self:OnIntervalThink()
  end
end

function modifier_ezekyle_draknien_debuff:OnIntervalThink()
    if IsServer() then
        if self:GetParent():GetMana() > 0 then 
            local ptc = self:GetAbility():GetSpecialValueFor("soul_damage_pct")
            if self:GetCaster():HasTalent("special_bonus_unique_ezekyle_2") then ptc = ptc + self:GetCaster():FindTalentValue("special_bonus_unique_ezekyle_2") end
            
            local damage = (ptc / 100) * self:GetParent():GetMana()
            self:GetParent():SpendMana(damage, self:GetAbility())

            ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType()})
        end 
    end
end

function modifier_ezekyle_draknien_debuff:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
