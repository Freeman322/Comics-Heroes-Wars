carnage_eject = class({})

LinkLuaModifier( "modifier_carnage_eject",   "abilities/carnage_eject.lua", LUA_MODIFIER_MOTION_NONE)

function carnage_eject:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end


function carnage_eject:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function carnage_eject:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:GetUnitName() == "npc_dota_hero_venomancer" then 
		self:EndCooldown()
		return
	end 

    local heroes = HeroList:GetAllHeroes()
    for i, hero in pairs(heroes) do
        if hero:HasModifier( "modifier_carnage_eject" ) then
            hero:FindModifierByName( "modifier_carnage_eject" ):Destroy()
        end
    end

    local info = {
		EffectName = "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_nasal_goo_proj.vpcf",
		Ability = self,
		iMoveSpeed = 900,
		Source = self:GetCaster(),
		Target = self:GetCursorTarget(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )

	EmitSoundOn( "Hero_Bristleback.ViscousGoo.Cast.Immortal", self:GetCaster() )
end

function carnage_eject:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		EmitSoundOn( "Hero_Bristleback.ViscousGoo.Target", hTarget )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_carnage_eject", { duration = self:GetSpecialValueFor("duration") } )
	end

	return true
end

modifier_carnage_eject = class({})

function modifier_carnage_eject:GetEffectName(  )
    return "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_nasal_goo_debuff.vpcf"
end

function modifier_carnage_eject:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_carnage_eject:IsPurgable()
    return false
end

function carnage_eject:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

