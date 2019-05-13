LinkLuaModifier( "modifier_item_jarnbjorn", "items/item_jarnbjorn.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_jarnbjorn_cooldown", "items/item_jarnbjorn.lua", LUA_MODIFIER_MOTION_NONE )

item_jarnbjorn = class({})

local INDEX_FADE_TIME = 0.15

function item_jarnbjorn:GetIntrinsicModifierName()
	return "modifier_item_jarnbjorn"
end

function item_jarnbjorn:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function item_jarnbjorn:GetCustomCastErrorTarget( hTarget )
	return ""
end

function item_jarnbjorn:OnSpellStart()
     if IsServer() then
          local hTarget = self:GetCursorTarget()
          local hCaster = self:GetCaster()

          if hTarget ~= nil then
               hTarget:AddNewModifier( hCaster, self, "modifier_item_mjollnir_static", {duration = self:GetSpecialValueFor("static_duration")} )
          end
     end
end

modifier_item_jarnbjorn = class({})

modifier_item_jarnbjorn.m_hCashedUnit = nil

function modifier_item_jarnbjorn:IsHidden() return true end
function modifier_item_jarnbjorn:IsPermanent() return true end
function modifier_item_jarnbjorn:IsPurgable() return false end
function modifier_item_jarnbjorn:RemoveOnDeath() return false end

function modifier_item_jarnbjorn:DeclareFunctions() --we want to use these functions in this item
     local funcs = {
          MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
          MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
          MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
          MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
          MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
          MODIFIER_EVENT_ON_ATTACK_LANDED
     }

     return funcs
end

function modifier_item_jarnbjorn:GetModifierBonusStats_Strength( params ) return self:GetAbility():GetSpecialValueFor( "bonus_strength" ) end
function modifier_item_jarnbjorn:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_intellect" ) end
function modifier_item_jarnbjorn:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "bonus_agility" ) end
function modifier_item_jarnbjorn:GetModifierPreAttack_BonusDamage( params ) return self:GetAbility():GetSpecialValueFor( "bonus_damage" ) end
function modifier_item_jarnbjorn:GetModifierAttackSpeedBonus_Constant( params ) return self:GetAbility():GetSpecialValueFor( "bonus_evasion" ) end

function modifier_item_jarnbjorn:OnAttackLanded( params )
     if IsServer() then
          if params.target and params.attacker == self:GetParent() then
               ---BASH
               if self.m_hCashedUnit ~= params.target and not self:HasCooldown() then
                    self:Bash(params.target)
               end 

               if RollPercentage(self:GetAbility():GetSpecialValueFor("bash_chance_melee")) then
                    self:Bash(params.target)
               end 

               if RollPercentage(self:GetAbility():GetSpecialValueFor("chain_chance")) then
                    self:Chain(params.target)
               end 
          end 
     end 
end

function modifier_item_jarnbjorn:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end
function modifier_item_jarnbjorn:Bash( taget )
     if IsServer() then
          self.m_hCashedUnit = taget

          self:StartCooldown(self:GetAbility():GetSpecialValueFor("bash_cooldown"))

          EmitSoundOn("DOTA_Item.SkullBasher", taget)

          taget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("bash_duration")})
     end 
end
function modifier_item_jarnbjorn:StartCooldown(cooldown)
     if IsServer() then
          self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_jarnbjorn_cooldown", {duration = cooldown})
     end 
end
function modifier_item_jarnbjorn:HasCooldown()
    return self:GetParent():HasModifier("modifier_item_jarnbjorn_cooldown")
end
function modifier_item_jarnbjorn:Chain(target)
     if IsServer() then
          local radius = self:GetAbility():GetSpecialValueFor( "chain_radius" ) 

          local units = FindUnitsInRadius( target:GetTeamNumber(), target:GetOrigin(), target, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
          if #units > 0 then
               for i = 1, #units do
                    local unit = units[i]
                    local next_unit = units[i + 1]

                    if not unit:IsNull() and unit then
                         Timers:CreateTimer(INDEX_FADE_TIME * i, function()
                              local damage = {
                                   victim = unit,
                                   attacker = self:GetCaster(),
                                   damage = self:GetAbility():GetSpecialValueFor( "chain_damage" ),
                                   damage_type = DAMAGE_TYPE_MAGICAL,
                                   ability = self:GetAbility()
                               }
               
                              ApplyDamage( damage )

                              EmitSoundOn("Item.Maelstrom.Chain_Lightning", unit)

                              if not next_unit:IsNull() and next_unit then
                                   local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil );
                                   ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
                                   ParticleManager:SetParticleControlEnt( nFXIndex, 1, next_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin(), true );
                                   ParticleManager:ReleaseParticleIndex( nFXIndex );

                                   EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", next_unit)
                              end
                         end)
                    end
               end
          end
     end 
end

modifier_item_jarnbjorn_cooldown = class({})

function modifier_item_jarnbjorn_cooldown:IsHidden() return true end
function modifier_item_jarnbjorn_cooldown:IsPurgable() return false end

