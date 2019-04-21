LinkLuaModifier("modifier_groot_divided_we_stand", "abilities/groot_divided_we_stand.lua", LUA_MODIFIER_MOTION_NONE)

groot_divided_we_stand = class({})

function groot_divided_we_stand:GetManaCost( nLevel)
  if self:GetCaster():HasScepter() then
    return self:GetCaster():GetMaxMana() * (0.01 * self:GetSpecialValueFor("manacost_scepter_pct"))
  else
    return self.BaseClass.GetManaCost( self, nLevel )
  end
end

function groot_divided_we_stand:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 0
    else
      return self.BaseClass.GetCooldown( self, nLevel )
    end
end

function groot_divided_we_stand:OnSpellStart()
    if IsServer() then
        if self:GetCaster():HasScepter() then
            if not self:GetCaster():HasModifier("modifier_groot_divided_we_stand") then
                self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_groot_divided_we_stand", nil )
            else
                hRotBuff = self:GetCaster():FindModifierByName( "modifier_groot_divided_we_stand" )
                if hRotBuff ~= nil then
                    hRotBuff:Destroy()
                end
            end
        else
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_groot_divided_we_stand", {duration = self:GetSpecialValueFor("duration")})
        end
    end
end

if modifier_groot_divided_we_stand == nil then modifier_groot_divided_we_stand = class({}) end

function modifier_groot_divided_we_stand:IsPurgable() return false end
function modifier_groot_divided_we_stand:IsHidden() return false end

function modifier_groot_divided_we_stand:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_groot_divided_we_stand:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_groot_divided_we_stand:OnCreated(table)
    if IsServer() then
        local projectile_model = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

        -- Saves the original model and attack capability
        if self.caster_model == nil then
            self.caster_model = self:GetParent():GetModelName()
        end
        self.caster_attack = self:GetParent():GetAttackCapability()

        -- Sets the new model and projectile
        self:GetParent():SetOriginalModel("models/heroes/furion/treant.vmdl")
        self:GetParent():SetRangedProjectileName(projectile_model)

        -- Sets the new attack type
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

        self:GetParent():SetModelScale(1.00)

        if self:GetParent():HasScepter() then
            self:StartIntervalThink(1)
        end
    end
end

function modifier_groot_divided_we_stand:OnIntervalThink()
   if IsServer() then
     self:GetParent():SpendMana(self:GetParent():GetMaxMana() * (0.01 * self:GetAbility():GetSpecialValueFor("manacost_scepter_pct")), self:GetAbility())
     if self:GetParent():GetMana() < self:GetParent():GetMaxMana() * (0.01 * self:GetAbility():GetSpecialValueFor("manacost_scepter_pct")) then
       self:GetParent():FindModifierByName("modifier_groot_divided_we_stand"):Destroy()
     end

   end
end

function modifier_groot_divided_we_stand:OnDestroy()
    if IsServer() then
        self:GetParent():SetModel(self.caster_model)
        self:GetParent():SetOriginalModel(self.caster_model)
        self:GetParent():SetAttackCapability(self.caster_attack)
        self:GetParent():SetModelScale(1)
    end
end

function modifier_groot_divided_we_stand:DeclareFunctions()
return {  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
          MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
          MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
          MODIFIER_PROPERTY_STATS_STRENGTH_BONUS }
end

function modifier_groot_divided_we_stand:GetModifierAttackRangeBonus( params )
    return self:GetAbility():GetSpecialValueFor("bonus_range")
end
function modifier_groot_divided_we_stand:GetModifierPreAttack_BonusDamage( params )
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_groot_divided_we_stand:GetModifierMoveSpeedBonus_Percentage( params )
  return self:GetAbility():GetSpecialValueFor("bonus_speed_pct")
end
function modifier_groot_divided_we_stand:GetModifierBonusStats_Strength( params )
    if self:GetParent():HasScepter() then
        return self:GetAbility():GetSpecialValueFor("bonus_str_scepter")
    else
      return 0
    end
end
