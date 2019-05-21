ostarion_hellfire_blast = class({})
LinkLuaModifier( "modifier_ostarion_hellfire_blast", "abilities/ostarion_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function ostarion_hellfire_blast:GetAOERadius()
    if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_ostarion_3") then 
        return 350
    end
    return
end

function ostarion_hellfire_blast:GetBehavior()
    if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_ostarion_3") then 
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
	end
	
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function ostarion_hellfire_blast:OnSpellStart()
	if IsServer() then 
		if self:GetCaster():HasTalent("special_bonus_unique_ostarion_3") then
			local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetOrigin(), self:GetCursorTarget(), 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
			if #units > 0 then
				for _,  unit in pairs(units) do
					self:CreateBlast(unit)
				end
			end 
			return
		end

		self:CreateBlast(self:GetCursorTarget())
    end
end

function ostarion_hellfire_blast:CreateBlast(target)
	local info = {
		EffectName = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf",
		Ability = self,
		iMoveSpeed = self:GetSpecialValueFor( "blast_speed" ),
		Source = self:GetCaster(),
		Target = target,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )
	
	EmitSoundOn( "Hero_SkeletonKing.Hellfire_Blast", self:GetCaster() )
end

--------------------------------------------------------------------------------

function ostarion_hellfire_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_SkeletonKing.Hellfire_BlastImpact", hTarget )
		
		local stun = self:GetSpecialValueFor( "blast_stun_duration" )

		if self:GetCaster():HasTalent("special_bonus_unique_ostarion_2") then
			stun = stun + (self:GetCaster():FindTalentValue("special_bonus_unique_ostarion_2") or 0)
		end

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun } )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ostarion_hellfire_blast", { duration = self:GetSpecialValueFor("blast_dot_duration") } )

		ApplyDamage( damage )
	end

	return true
end


if not modifier_ostarion_hellfire_blast then modifier_ostarion_hellfire_blast = class({}) end 

function modifier_ostarion_hellfire_blast:IsDebuff()
	return true
end

function modifier_ostarion_hellfire_blast:IsPurgeException()
	return true
end

function modifier_ostarion_hellfire_blast:OnCreated( kv )
	if IsServer() then 
		self:StartIntervalThink(1)
		self:OnIntervalThink()
	end 
end

function modifier_ostarion_hellfire_blast:OnDestroy()
	if IsServer() then
		
	end
end


function modifier_ostarion_hellfire_blast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_ostarion_hellfire_blast:GetEffectName ()
	return "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf"
end
  
function modifier_ostarion_hellfire_blast:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ostarion_hellfire_blast:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("blast_slow")
end


function modifier_ostarion_hellfire_blast:OnIntervalThink()
	if IsServer() then
		local flDamagePerTick = self:GetAbility():GetSpecialValueFor("blast_dot_damage")

		if self:GetCaster():HasTalent("special_bonus_unique_ostarion_1") then
			flDamagePerTick = flDamagePerTick + (self:GetCaster():FindTalentValue("special_bonus_unique_ostarion_1") or 0)
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamagePerTick,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
	end	
end

function modifier_ostarion_hellfire_blast:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
