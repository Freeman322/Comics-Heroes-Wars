black_flash_speed_blast = class({})
LinkLuaModifier( "modifier_black_flash_speed_blast",         "abilities/black_flash_speed_blast.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_flash_speed_blast_slowing", "abilities/black_flash_speed_blast.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_flash_speed_blast_aghanim", "abilities/black_flash_speed_blast.lua",LUA_MODIFIER_MOTION_NONE )

local slowing = 0
function black_flash_speed_blast:GetIntrinsicModifierName()
	return	"modifier_black_flash_speed_blast"
end

function black_flash_speed_blast:OnUpgrade()
	if not self:GetCaster():HasModifier("modifier_black_flash_speed_blast_aghanim") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_black_flash_speed_blast_aghanim", nil)
	end
end

function black_flash_speed_blast:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function black_flash_speed_blast:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "missile_speed" ),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
end

--------------------------------------------------------------------------------

function black_flash_speed_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )
		local stun = self:GetSpecialValueFor( "stun" )
		local damage = self:GetAbilityDamage()
		if self:GetCaster():HasScepter() then 
			if self:GetCaster():HasModifier("modifier_black_flash_speed_blast") then
				local mod = self:GetCaster():FindModifierByName("modifier_black_flash_speed_blast")
				slowing = mod:GetStackCount()
				damage = damage + (slowing/2)
			end
		end
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		if self:GetCaster():HasModifier("modifier_black_flash_speed_blast") then
			local mod = self:GetCaster():FindModifierByName("modifier_black_flash_speed_blast")
			slowing = mod:GetStackCount()
			mod:SetStackCount(slowing + 1)
		end
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_black_flash_speed_blast_slowing", { duration = 4} )

		if self:GetCaster():HasModifier("modifier_movespeed_bonus_talent") then 
			local mod = self:GetCaster():FindModifierByName("modifier_movespeed_bonus_talent")
			mod:SetStackCount(mod:GetStackCount() + 1)
			mod:ForceRefresh()
		end
	end

	return true
end

if modifier_black_flash_speed_blast == nil then modifier_black_flash_speed_blast = class({}) end

function modifier_black_flash_speed_blast:IsPurgable()
    return false
end

function modifier_black_flash_speed_blast:IsHidden()
    return false
end

function modifier_black_flash_speed_blast:RemoveOnDeath()
    return false
end


function modifier_black_flash_speed_blast:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_black_flash_speed_blast_slowing == nil then modifier_black_flash_speed_blast_slowing = class({}) end

function modifier_black_flash_speed_blast_slowing:OnCreated(table)
	self.slowing = slowing
end

function modifier_black_flash_speed_blast_slowing:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_black_flash_speed_blast_slowing:GetModifierMoveSpeedBonus_Percentage()
	return self.slowing*(-1)
end

if modifier_black_flash_speed_blast_aghanim == nil then modifier_black_flash_speed_blast_aghanim = class({}) end

function modifier_black_flash_speed_blast_aghanim:IsPurgable()
    return false
end

function modifier_black_flash_speed_blast_aghanim:IsHidden()
    return true
end

function modifier_black_flash_speed_blast_aghanim:RemoveOnDeath()
    return false
end

function modifier_black_flash_speed_blast_aghanim:OnCreated(htable)
    if IsServer() then
    	self:StartIntervalThink(1)
    end
end

function modifier_black_flash_speed_blast_aghanim:OnIntervalThink()
    if IsServer() then
    	if self:GetCaster():HasScepter() then
			self.radius = self:GetAbility():GetSpecialValueFor("radius")
			if self:GetParent():HasModifier("modifier_black_flash_tahion_field") then 
				local ability = self:GetParent():FindModifierByName("modifier_black_flash_tahion_field"):GetAbility()
				local count = 100
				local bonus = count * ability:GetLevel()
				self.radius = self.radius + bonus
			end
	    	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
			if #units > 0 then
				for _,target in pairs(units) do
					if self:GetAbility():IsCooldownReady() then
						local info = {
								EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
								Ability = self:GetAbility(),
								iMoveSpeed = self:GetAbility():GetSpecialValueFor( "missile_speed" ),
								Source = self:GetAbility():GetCaster(),
								Target = target,
								iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
							}

						ProjectileManager:CreateTrackingProjectile( info )
						EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
						local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())
						if self:GetCaster():HasItemInInventory("item_octarine_core") or self:GetCaster():HasItemInInventory("item_octarine_core_2") then
							cooldown = cooldown * 0.75
						end
						self:GetAbility():StartCooldown(cooldown)
						break
					end
				end
			end
		end
    end
end

function black_flash_speed_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

