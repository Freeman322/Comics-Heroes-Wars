if sam_elecrtic_blow == nil then sam_elecrtic_blow = class({}) end
LinkLuaModifier( "modifier_sam_elecrtic_blow",	"abilities/sam_elecrtic_blow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sam_elecrtic_blow_damage",	"abilities/sam_elecrtic_blow.lua", LUA_MODIFIER_MOTION_NONE )

function sam_elecrtic_blow:GetIntrinsicModifierName() return "modifier_sam_elecrtic_blow" end

function sam_elecrtic_blow:OnSpellStart()
     if IsServer() then
          local hTarget = self:GetCursorTarget()
          if hTarget ~= nil then
               if not hTarget:IsBuilding() and not hTarget:IsAncient() then
                    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sam_elecrtic_blow_damage", nil)

                    local cleaveDamage = ( self:GetSpecialValueFor("splash_dmg_ptc") * self:GetCaster():GetAverageTrueAttackDamage(hTarget) ) / 100.0                    
                    DoCleaveAttack( self:GetParent(), hTarget, self, cleaveDamage, 225, 420, self:GetSpecialValueFor("splash_radius"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf" )

                    self:GetCaster():RemoveModifierByName("modifier_sam_elecrtic_blow_damage")

                    EmitSoundOn("Hero_Mars.Phalanx.Target", hTarget)
                    EmitSoundOn("Hero_Mars.Shield.Crit", hTarget)

                    self:UseResources(true, false, true)
               end
          end
     end
end

if modifier_sam_elecrtic_blow == nil then modifier_sam_elecrtic_blow = class ( {}) end

function modifier_sam_elecrtic_blow:IsHidden() return true end
function modifier_sam_elecrtic_blow:IsPurgable() return false end
function modifier_sam_elecrtic_blow:DeclareFunctions()  return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_sam_elecrtic_blow:OnAttackLanded (params)
     if IsServer () then
          if params.attacker == self:GetParent () then
               if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                    if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
                         self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sam_elecrtic_blow_damage", nil)

                         local cleaveDamage = ( self:GetAbility():GetSpecialValueFor("splash_dmg_ptc") * self:GetCaster():GetAverageTrueAttackDamage(params.target) ) / 100.0                    
                         DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, 225, 420, self:GetAbility():GetSpecialValueFor("splash_radius"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf" )

                         self:GetCaster():RemoveModifierByName("modifier_sam_elecrtic_blow_damage")

                         EmitSoundOn("Hero_Mars.Phalanx.Target", params.target)
                         EmitSoundOn("Hero_Mars.Shield.Crit", params.target)

                         self:GetAbility():UseResources(true, false, true)
                    end
               end
          end
     end

  return 0
end

if modifier_sam_elecrtic_blow_damage == nil then modifier_sam_elecrtic_blow_damage = class ( {}) end

function modifier_sam_elecrtic_blow_damage:IsHidden() return true end
function modifier_sam_elecrtic_blow_damage:IsPurgable() return false end
function modifier_sam_elecrtic_blow_damage:DeclareFunctions()  return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_sam_elecrtic_blow_damage:GetModifierPreAttack_BonusDamage (params)
     return self:GetAbility():GetSpecialValueFor("bonus_damage")
end