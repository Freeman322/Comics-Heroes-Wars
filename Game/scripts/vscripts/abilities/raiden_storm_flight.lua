raiden_storm_flight = class({})
LinkLuaModifier("modifier_raiden_storm_flight", "abilities/raiden_storm_flight.lua", LUA_MODIFIER_MOTION_NONE)

local CONST_CAST_RANGE_GLOBAL = 99999
local CONST_FL_INTERVAL = 0.03
local CONST_INTERRUPT = -1

raiden_storm_flight.m_iManaCost = 1

function raiden_storm_flight:CastFilterResultTarget( hTarget )
  if IsServer() then

    if hTarget ~= nil and hTarget:IsMagicImmune() then
      return UF_FAIL_MAGIC_IMMUNE_ENEMY
    end

    local iMana = (hTarget:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() * self:GetSpecialValueFor("mana_per_distance")

    if iMana > self:GetCaster():GetMana() then
        return UF_FAIL_INVALID_LOCATION
    end 

    self.m_iManaCost = iMana

    local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
    return nResult
  end

  return UF_SUCCESS
end

function raiden_storm_flight:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self) end
function raiden_storm_flight:GetCooldown( nLevel ) return self.BaseClass.GetCooldown( self, nLevel ) end
function raiden_storm_flight:GetCastRange( vLocation, hTarget ) return CONST_CAST_RANGE_GLOBAL end
function raiden_storm_flight:IsRefreshable() return false end

function raiden_storm_flight:OnSpellStart()
    if IsServer() then 
        local target = self:GetCursorTarget()

        if target and not target:TriggerSpellAbsorb(self) then 
            EmitSoundOn("Hero_StormSpirit.Orchid_BallLightning", self:GetCaster())

            self:GetCaster():SpendMana(self.m_iManaCost, self)

            print(self.m_iManaCost)

            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_raiden_storm_flight", {target = target:entindex()})
        end 
    end 
end


if modifier_raiden_storm_flight == nil then modifier_raiden_storm_flight = class({}) end

function modifier_raiden_storm_flight:IsPurgable() return false end
function modifier_raiden_storm_flight:RemoveOnDeath() return true end
function modifier_raiden_storm_flight:IsHidden() return true end
function modifier_raiden_storm_flight:GetEffectName() return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf" end
function modifier_raiden_storm_flight:GetEffectAttachType() return PATTACH_CUSTOMORIGIN_FOLLOW end


function modifier_raiden_storm_flight:OnCreated(params) 
    if IsServer() then
        self.m_hTarget = params.target

        if self.m_hTarget then 
            self.m_hTarget = EntIndexToHScript(self.m_hTarget)
            
            self.m_flSpeed = self:GetAbility():GetSpecialValueFor("speed")
            self.m_iDamage = self:GetAbility():GetSpecialValueFor("damage")
            self.m_iRadius = self:GetAbility():GetSpecialValueFor("radius")

            StartSoundEvent("Hero_StormSpirit.BallLightning.Loop", self:GetParent())
            
            self:StartIntervalThink(CONST_FL_INTERVAL)
            return
        end 

        self:Destroy()
    end 
end 

function modifier_raiden_storm_flight:OnIntervalThink()
    if IsServer() then 
        local dist = (self.m_hTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

        if dist <= 128 then
            self:DealDamage()
            FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
            self:StartIntervalThink(CONST_INTERRUPT) return
        end 

        local direction = (self.m_hTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()

        self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + direction * (self.m_flSpeed * CONST_FL_INTERVAL))
    end 
end 

function modifier_raiden_storm_flight:DealDamage() 
    ---//// DEAL DAMAGE ////----
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/storm_spirit/strom_spirit_ti8/storm_spirit_ti8_overload_active.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius") , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if units ~= nil then
            if #units > 0 then
                for _, unit in pairs(units) do
                    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
                                             
                    ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = unit, ability = self:GetAbility(), damage = self:GetAbility():GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
                end
            end
        end
    end 

    self:Destroy()
end 

function modifier_raiden_storm_flight:OnDestroy()
   StopSoundEvent("Hero_StormSpirit.BallLightning.Loop", self:GetParent())
end