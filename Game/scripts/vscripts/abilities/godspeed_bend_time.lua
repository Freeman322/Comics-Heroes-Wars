if not godspeed_bend_time then godspeed_bend_time = class({}) end

LinkLuaModifier ("modifier_godspeed_bend_time", "abilities/godspeed_bend_time.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_godspeed_bend_time_passive", "abilities/godspeed_bend_time.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_bend_time:GetIntrinsicModifierName() return "modifier_godspeed_bend_time_passive" end

function godspeed_bend_time:AddSpeed(speed)
	local max = self:GetSpecialValueFor("max_gain")
	local mod = self:GetCaster():FindModifierByName("modifier_godspeed_bend_time_passive")
	local curr = mod:GetStackCount()

	if curr + speed > max then return end

	mod:SetStackCount(mod:GetStackCount() + speed)
end

function godspeed_bend_time:ResetSpeed() self:GetCaster():FindModifierByName("modifier_godspeed_bend_time_passive"):SetStackCount(0) end

function godspeed_bend_time:OnSpellStart()
    if IsServer() then

        local hTarget = self:GetCursorTarget()
        local info = {
    			EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
    			Ability = self,
    			iMoveSpeed = 1200,
    			Source = self:GetCaster(),
    			Target = self:GetCursorTarget(),
    			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
	    ProjectileManager:CreateTrackingProjectile( info )

		EmitSoundOn("Hero_PhantomLancer.SpiritLance.Throw", self:GetCaster())
    end
end

function godspeed_bend_time:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn("Hero_PhantomLancer.SpiritLance.Impact", self:GetCaster())

   		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_godspeed_bend_time", {duration = self:GetSpecialValueFor("duration")})
	end

	return true
end

if not modifier_godspeed_bend_time then modifier_godspeed_bend_time = class({}) end

function modifier_godspeed_bend_time:IsPurgeException() return true end
function modifier_godspeed_bend_time:GetStatusEffectName() return "particles/status_fx/status_effect_siren_song.vpcf" end
function modifier_godspeed_bend_time:StatusEffectPriority() return 1000 end
function modifier_godspeed_bend_time:GetEffectName() return "particles/godspeed/godspeed_bend_time.vpcf" end
function modifier_godspeed_bend_time:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_godspeed_bend_time:OnCreated( kv )
	if IsServer() then
		self._iPtc = self:GetAbility():GetSpecialValueFor("speed_ptc")
		self._iTotalDist = 0

		if self:GetParent():HasTalent("special_bonus_godspeed_1") then self._iPtc = self._iPtc + self:GetParent():FindTalentValue("special_bonus_godspeed_1") end 

		self._vPosition = self:GetParent():GetAbsOrigin()
    end
end

function modifier_godspeed_bend_time:OnDestroy()
	if IsServer() then
		self:GetAbility():AddSpeed(self._iTotalDist * (self._iPtc / 100))
	end
end

function modifier_godspeed_bend_time:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED
    }

    return funcs
end

function modifier_godspeed_bend_time:OnUnitMoved(params)
	if IsServer() then 
		if params.unit == self:GetParent() then 
			if self._vPosition ~= self:GetParent():GetAbsOrigin() then 
				local distance = (self:GetParent():GetAbsOrigin() - self._vPosition):Length2D()

				self._vPosition = self:GetParent():GetAbsOrigin()

				self:OnPositionChanged(distance)
			end 			
		end
	end 
end

function modifier_godspeed_bend_time:OnPositionChanged( distance )
	if IsServer() then 
		self._iTotalDist = distance + self._iTotalDist
	end
end


if modifier_godspeed_bend_time_passive == nil then modifier_godspeed_bend_time_passive = class({}) end

function modifier_godspeed_bend_time_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}

	return funcs
end

function modifier_godspeed_bend_time_passive:GetModifierMoveSpeedBonus_Constant(params)
	return self:GetStackCount()
end

function modifier_godspeed_bend_time_passive:GetModifierIgnoreMovespeedLimit(params)
	return 1
end

function modifier_godspeed_bend_time_passive:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_godspeed_bend_time_passive:IsHidden() return true end
function modifier_godspeed_bend_time_passive:IsPurgable() return false end
function modifier_godspeed_bend_time_passive:RemoveOnDeath() return false end
