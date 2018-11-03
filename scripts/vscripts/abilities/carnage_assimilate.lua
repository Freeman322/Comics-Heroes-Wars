carnage_assimilate = class({})
LinkLuaModifier( "modifier_carnage_assimilate", "abilities/carnage_assimilate.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_carnage_assimilate_unit", "abilities/carnage_assimilate.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_carnage_eject", "abilities/carnage_eject.lua", LUA_MODIFIER_MOTION_NONE )

function carnage_assimilate:OnUpgrade()
    if IsServer() then 
        self:GetCaster():FindAbilityByName("carnage_eject"):SetLevel(1)
    end
end

function carnage_assimilate:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end


function carnage_assimilate:SentCustomCastErrorTarget(error)
	if IsServer() then 
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "dota_hud_error_message", {message = error})
	end
end

function carnage_assimilate:FindRecipient()
	if IsServer() then 
		local heroes = HeroList:GetAllHeroes()
	    for i, hero in pairs(heroes) do
	        if hero:HasModifier( "modifier_carnage_eject" ) then
	           return hero
	        end
	    end
	    return nil
	end
end


function carnage_assimilate:GetEjectAbility()
	return self:GetCaster():GetAbilityByIndex(4)
end

function carnage_assimilate:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil or hCaster == hTarget or hCaster:GetTeamNumber() == hTarget:GetTeamNumber() then
		self:EndCooldown()
		return
	end

	if self:FindRecipient() == nil then
		self:SentCustomCastErrorTarget("dota_hud_error_cant_cast_recipient_null")
		self:EndCooldown()
		return 
	end

	if (self:FindRecipient():GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D() > 400 then 
		self:SentCustomCastErrorTarget("Target is too way")
		self:EndCooldown()
		return
	end

	if hTarget:GetUnitName() == "npc_dota_hero_venomancer" then 
		self:EndCooldown()
		return
	end 

	hTarget:Interrupt()

	hRecipient = self:FindRecipient()

	hRecipient:AddNewModifier(hCaster, self, "modifier_carnage_assimilate_unit", {duration = self:GetSpecialValueFor("duration"), damage = hTarget:GetAttackDamage() * (self:GetSpecialValueFor("damage_stole") / 100), hp = hTarget:GetHealth() * (self:GetSpecialValueFor("health_stole") / 100)})
	hTarget:AddNewModifier(hCaster, self, "modifier_carnage_assimilate", {duration = self:GetSpecialValueFor("duration")})


	EmitSoundOn( "Hero_LifeStealer.Assimilate.Target", hCaster )
	EmitSoundOn( "Hero_LifeStealer.Assimilate.Destroy", hTarget )

	hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
end

if modifier_carnage_assimilate == nil then modifier_carnage_assimilate = class({}) end 

function modifier_carnage_assimilate:IsPurgable()
	return false
end

function modifier_carnage_assimilate:RemoveOnDeath()
	return true
end

function modifier_carnage_assimilate:OnCreated(table)
	if IsServer() then
        self:StartIntervalThink(0.03)

        self.target = self:GetAbility():FindRecipient()
    end
end

function modifier_carnage_assimilate:OnDestroy()
	if IsServer() then
  
    end
end

function modifier_carnage_assimilate:OnIntervalThink()
	if IsServer() then
        if self:GetCaster():IsAlive() == false or self.target:IsAlive() == false then
            self:Destroy()
        end
       self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin())
    end
end

function modifier_carnage_assimilate:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	    [MODIFIER_STATE_DISARMED]	= true,
	    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	    [MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
	    [MODIFIER_STATE_UNSELECTABLE]	= true,
	    [MODIFIER_STATE_OUT_OF_GAME]	= true,
	    [MODIFIER_STATE_NO_HEALTH_BAR]	= true,
	    [MODIFIER_STATE_INVULNERABLE]	= true,
	    [MODIFIER_STATE_COMMAND_RESTRICTED]	= true
	}

	return state
end

function modifier_carnage_assimilate:DeclareFunctions()
	local funcs = {
	    MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	return funcs
end


function modifier_carnage_assimilate:GetVisualZDelta()
	return -1000
end


function modifier_carnage_assimilate:OnDestroy()
	if IsServer() then 
		local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nCasterFX, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
		ParticleManager:ReleaseParticleIndex( nCasterFX )

		EmitSoundOn("Hero_LifeStealer.OpenWounds", self:GetParent())

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage( damage )
	end 
end

if modifier_carnage_assimilate_unit == nil then modifier_carnage_assimilate_unit = class({}) end 

function modifier_carnage_assimilate_unit:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end

function modifier_carnage_assimilate_unit:StatusEffectPriority()
	return 1000
end

function modifier_carnage_assimilate_unit:GetEffectName()
	return "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf"
end

function modifier_carnage_assimilate_unit:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_carnage_assimilate_unit:IsPurgable()
	return false
end

function modifier_carnage_assimilate_unit:IsHidden()
	return false
end

function modifier_carnage_assimilate_unit:OnCreated(params)
	if IsServer() then
		self.dmg = params.damage
        self.hp = params.hp

        EmitSoundOn("Hero_LifeStealer.Rage", self:GetParent())

        self:GetParent():Heal(self:GetParent():GetMaxHealth(), self:GetAbility())
	end
end

function modifier_carnage_assimilate_unit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

function modifier_carnage_assimilate_unit:GetModifierExtraHealthBonus( params )
	return self.hp
end

function modifier_carnage_assimilate_unit:GetModifierBaseAttack_BonusDamage( params )
	return self.dmg
end

function modifier_carnage_assimilate_unit:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end