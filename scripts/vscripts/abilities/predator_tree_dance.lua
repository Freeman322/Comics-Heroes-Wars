LinkLuaModifier( "modifier_predator_tree_dance", "abilities/predator_tree_dance.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_predator_tree_dance_tree", "abilities/predator_tree_dance.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_predator_tree_dance_passive", "abilities/predator_tree_dance.lua", LUA_MODIFIER_MOTION_BOTH )
if predator_tree_dance == nil then predator_tree_dance = class({}) end

function predator_tree_dance:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function predator_tree_dance:GetIntrinsicModifierName()
  return "modifier_predator_tree_dance_passive"
end

function predator_tree_dance:GetCastRange( vLocation, hTarget )
  return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function predator_tree_dance:OnSpellStart()
	local hTarget = self:GetCursorTarget()
  local hCaster = self:GetCaster()
	if hTarget ~= nil then
      if hCaster:HasModifier("modifier_predator_tree_dance_tree") then
        hCaster:RemoveModifierByName("modifier_predator_tree_dance_tree")
      end
			hCaster:AddNewModifier( self:GetCaster(), self, "modifier_predator_tree_dance", {target = hTarget} )
			EmitSoundOn( "Hero_MonkeyKing.TreeJump.Cast", hCaster )
	end
end

function predator_tree_dance:GetPlaybackRateOverride()
    return 2
end

if modifier_predator_tree_dance == nil then modifier_predator_tree_dance = class({}) end

function modifier_predator_tree_dance:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }

    return state
end

function modifier_predator_tree_dance:IsHidden()
    return true
end

function modifier_predator_tree_dance:RemoveOnDeath()
    return false
end

function modifier_predator_tree_dance:IsPurgable()
    return false
end

function modifier_predator_tree_dance:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }

    return funcs
end

function modifier_predator_tree_dance:GetOverrideAnimation(params)
    return ACT_DOTA_MK_TREE_SOAR
end

function modifier_predator_tree_dance:GetOverrideAnimationRate(params)
    return 0.4
end

function modifier_predator_tree_dance:OnCreated( kv )
    if IsServer() then
        self.target = self:GetAbility():GetCursorTarget():GetAbsOrigin()
        abil = {}
        abil.leap_direction = (self.target - self:GetParent():GetAbsOrigin()):Normalized()
        abil.leap_distance = (self.target - self:GetParent():GetAbsOrigin()):Length2D()
        abil.leap_speed = 1000/30
        abil.leap_traveled = 0
        abil.leap_z = 0
        self:GetParent():StartGesture(ACT_DOTA_MK_TREE_SOAR)
        self:StartIntervalThink(0.03)
    end
end

function modifier_predator_tree_dance:OnIntervalThink()
  if IsServer() then
      local caster = self:GetParent()
      local ability = self:GetAbility()

      if abil.leap_traveled < abil.leap_distance/2 then
          abil.leap_z = abil.leap_z + abil.leap_speed
          caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,abil.leap_z))
      else
          abil.leap_z = abil.leap_z - abil.leap_speed
          caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,abil.leap_z))
      end

      if abil.leap_traveled < abil.leap_distance then
          caster:SetAbsOrigin(caster:GetAbsOrigin() + abil.leap_direction * abil.leap_speed)
          abil.leap_traveled = abil.leap_traveled + abil.leap_speed
      else
          caster:SetAbsOrigin(self.target)
          self:JumpOnTree()
      end
  end
end

function modifier_predator_tree_dance:JumpOnTree()
    if IsServer() then
        local caster = self:GetParent()
        if caster:HasModifier("modifier_predator_tree_dance_tree") then
          caster:RemoveModifierByName("modifier_predator_tree_dance_tree")
        end
        self:GetParent():RemoveGesture(ACT_DOTA_MK_TREE_SOAR)
        caster:AddNewModifier( caster, self:GetAbility(), "modifier_predator_tree_dance_tree", nil)
        self:Destroy()
    end
end

if modifier_predator_tree_dance_tree == nil then modifier_predator_tree_dance_tree = class({}) end


function modifier_predator_tree_dance_tree:IsHidden()
    return true
end

function modifier_predator_tree_dance_tree:RemoveOnDeath()
    return true
end

function modifier_predator_tree_dance_tree:IsPurgable()
    return false
end


function modifier_predator_tree_dance_tree:OnCreated( kv )
	if IsServer() then
      EmitSoundOn("Hero_MonkeyKing.TreeJump.Tree", self:GetParent())
      self:GetParent():StartGesture(ACT_DOTA_MK_TREE_END)
      self:StartIntervalThink(0.1)
	end
end


function modifier_predator_tree_dance_tree:OnDestroy()
	if IsServer() then
      EmitSoundOn("Hero_MonkeyKing.TreeJump.Tree", self:GetParent())
      self:GetParent():RemoveGesture(ACT_DOTA_MK_TREE_END)
	end
end


function modifier_predator_tree_dance_tree:OnIntervalThink()
	if IsServer() then
    local trees = GridNav:GetAllTreesAroundPoint(self:GetParent():GetAbsOrigin(), 20, true)
    for k, tree in pairs(trees) do
      if tree:IsStanding() == false then
        print(tree:IsStanding())
        local vTarget = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 40
        self:GetParent():SetAbsOrigin(vTarget)
        if caster:HasModifier("modifier_predator_tree_dance_tree") then
          caster:RemoveModifierByName("modifier_predator_tree_dance_tree")
        end
      end
    end
	end
end


function modifier_predator_tree_dance_tree:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_FLYING] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end

function modifier_predator_tree_dance_tree:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_EVENT_ON_ORDER,
    MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
    MODIFIER_PROPERTY_BONUS_DAY_VISION,
    MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_predator_tree_dance_tree:GetBonusDayVision( params )
	return self:GetAbility():GetSpecialValueFor("bonus_cast_range")
end

function modifier_predator_tree_dance_tree:GetBonusNightVision( params )
	return self:GetAbility():GetSpecialValueFor("bonus_cast_range")
end

function modifier_predator_tree_dance_tree:GetModifierPersistentInvisibility( params )
	return 1
end

function modifier_predator_tree_dance_tree:GetOverrideAnimation( params )
	return ACT_DOTA_MK_TREE_END
end

function modifier_predator_tree_dance_tree:OnOrder( params )
  if self:GetParent() == params.unit then
      if params.order_type == 1 or params.order_type == 2 or params.order_type == 3 or params.order_type == 4 then
        local vTarget = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 40
        self:GetParent():SetAbsOrigin(vTarget)
        self:Destroy()
      end
  end
end

function modifier_predator_tree_dance_tree:OnTakeDamage( params )
  if self:GetParent() == params.unit then
      local vTarget = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 40
      self:GetParent():SetAbsOrigin(vTarget)
      self:Destroy()
  end
end

function modifier_predator_tree_dance_tree:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end


function modifier_predator_tree_dance_tree:StatusEffectPriority()
	return 1000
end


if modifier_predator_tree_dance_passive == nil then modifier_predator_tree_dance_passive = class({}) end

function modifier_predator_tree_dance_passive:IsHidden()
    return true
end

function modifier_predator_tree_dance_passive:RemoveOnDeath()
    return false
end

function modifier_predator_tree_dance_passive:IsPurgable()
    return false
end

function modifier_predator_tree_dance_passive:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function modifier_predator_tree_dance_passive:OnTakeDamage( params )
  if self:GetParent() == params.unit then
      if params.attacker:IsHero() then
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
      end
  end
end

function predator_tree_dance:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

