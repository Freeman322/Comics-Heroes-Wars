if cosmos_cosmos_power == nil then cosmos_cosmos_power = class({}) end
LinkLuaModifier( "modifier_cosmos_cosmos_power",	"abilities/cosmos_cosmos_power.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cosmos_cosmos_power_target",	"abilities/cosmos_cosmos_power.lua", LUA_MODIFIER_MOTION_NONE )

function cosmos_cosmos_power:GetIntrinsicModifierName() return "modifier_cosmos_cosmos_power" end
function cosmos_cosmos_power:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function cosmos_cosmos_power:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function cosmos_cosmos_power:IsStealable() return false end
function cosmos_cosmos_power:GetManaCost(iLevel)  return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_pool_damage_pct") / 100) end
function cosmos_cosmos_power:GetCooldown( nLevel )  return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_cosmos_1") or self.BaseClass.GetCooldown( self, nLevel ) end

function cosmos_cosmos_power:OnSpellStart()
    if IsServer() then
          local hTarget = self:GetCursorTarget()
          if hTarget ~= nil then
               if ( not hTarget:TriggerSpellAbsorb( self ) ) then
                    if not hTarget:IsBuilding() and not hTarget:IsAncient() then
                         local info = {
                              EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
                              Ability = self,
                              iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
                              Source = self:GetCaster(),
                              Target = self:GetCursorTarget(),
                              iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
                         }
                    
                         ProjectileManager:CreateTrackingProjectile( info )

                         EmitSoundOn("Hero_Abaddon.Curse.Proc", self:GetCaster())

                         self:GetAbility():UseResources(true, false, true)
                    end
               end
          end
    end
end

function cosmos_cosmos_power:OnProjectileHit( hTarget, vLocation )
     if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_Lich.IceAge.Damage", hTarget )
          
          local debuff_dur = self:GetSpecialValueFor( "warp_duration" )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage =  self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_pool_damage_pct") / 100),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}

          ApplyDamage( damage )
          
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_cosmos_cosmos_power_target", { duration = debuff_dur } )
	end

	return true
end


if modifier_cosmos_cosmos_power == nil then modifier_cosmos_cosmos_power = class ( {}) end

function modifier_cosmos_cosmos_power:IsHidden () return true end
function modifier_cosmos_cosmos_power:IsPurgable()  return false end
function modifier_cosmos_cosmos_power:DeclareFunctions ()  return { MODIFIER_EVENT_ON_ATTACK_START } end
function modifier_cosmos_cosmos_power:OnAttackStart (params)
     if IsServer () then
         if params.attacker == self:GetParent () then
             if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                 if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
                    local info = {
                         EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
                         Ability = self:GetAbility(),
                         iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
                         Source = self:GetCaster(),
                         Target = params.target,
                         iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
                    }
               
                    ProjectileManager:CreateTrackingProjectile( info )

                    EmitSoundOn("Hero_Abaddon.Curse.Proc", self:GetCaster())

                    self:GetAbility():UseResources(true, false, true)
                 end
             end
         end
     end
 
     return 0
end

if modifier_cosmos_cosmos_power_target == nil then modifier_cosmos_cosmos_power_target = class ( {}) end

function modifier_cosmos_cosmos_power_target:GetEffectName() return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf" end
function modifier_cosmos_cosmos_power_target:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_cosmos_cosmos_power_target:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_cosmos_cosmos_power_target:DeclareFunctions ()
     local funcs = {
          MODIFIER_PROPERTY_DISABLE_HEALING
     }
 
     return funcs
 end
 
 function modifier_cosmos_cosmos_power_target:GetDisableHealing(params) return 1 end
 