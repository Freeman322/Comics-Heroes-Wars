LinkLuaModifier ("modifier_gostrider_punishing_gaze", "abilities/gostrider_punishing_gaze.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_gostrider_punishing_gaze_death_lable", "abilities/gostrider_punishing_gaze.lua", LUA_MODIFIER_MOTION_NONE)

gostrider_punishing_gaze = class({})

function gostrider_punishing_gaze:GetIntrinsicModifierName()
	return "modifier_gostrider_punishing_gaze"
end

function gostrider_punishing_gaze:GetModifier()
	return self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
end

function gostrider_punishing_gaze:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function gostrider_punishing_gaze:GetCustomCastErrorTarget( hTarget )
	return ""
end

--------------------------------------------------------------------------------

function gostrider_punishing_gaze:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function gostrider_punishing_gaze:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil then
		return
	end

	local vPos1 = hCaster:GetOrigin()
	local vPos2 = hTarget:GetOrigin()

	GridNav:DestroyTreesAroundPoint( vPos1, 300, false )
	GridNav:DestroyTreesAroundPoint( vPos2, 300, false )

	hTarget:Interrupt()

	local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ghost_rider/ghost_rider_punishing_gaze.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );  
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_DarkWillow.Shadow_Realm", hCaster )
	EmitSoundOn( "Hero_DarkWillow.Shadow_Realm.Attack", hTarget )

    self:GetModifier()

    local damage = self:GetModifier()._hUnits[hTarget] or 0 

    hTarget:AddNewModifier(hCaster, self, "modifier_gostrider_punishing_gaze_death_lable", {duration = 2})
    
    ApplyDamage ({
        victim = hTarget,
        attacker = hCaster,
        damage = damage + self:GetAbilityDamage(),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
    })
end


if modifier_gostrider_punishing_gaze == nil then
    modifier_gostrider_punishing_gaze = class({})
end

function modifier_gostrider_punishing_gaze:IsHidden()
	return true
end

function modifier_gostrider_punishing_gaze:IsPurgable()
    return false
end

function modifier_gostrider_punishing_gaze:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end

function modifier_gostrider_punishing_gaze:OnCreated(params)
    if IsServer() then 
        self._hUnits = {}
    end
end

function modifier_gostrider_punishing_gaze:Destroy()
    if IsServer() then 
        self._hUnits = nil
    end
end

function modifier_gostrider_punishing_gaze:OnDeath(params)
    if IsServer() then
        local target = params.attacker
        local victim = params.unit

        if target ~= nil and target:IsRealHero() and target:GetTeamNumber() ~= victim:GetTeamNumber() then
            local bonus = self:GetAbility():GetSpecialValueFor("damage_per_hero")

            if not victim:IsHero() then
                bonus = self:GetAbility():GetSpecialValueFor("damage_per_unit")
            end

            self._hUnits[target] = (self._hUnits[target] or 0) + bonus
        end
    end
end

if not modifier_gostrider_punishing_gaze_death_lable then modifier_gostrider_punishing_gaze_death_lable = class({}) end 

function modifier_gostrider_punishing_gaze_death_lable:IsHidden()
	return true
end

function modifier_gostrider_punishing_gaze_death_lable:IsPurgable()
	return false
end

function modifier_gostrider_punishing_gaze_death_lable:RemoveOnDeath()
	return false
end

function modifier_gostrider_punishing_gaze_death_lable:OnCreated( params )
    if IsServer() then
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())
        
        
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/lion/lion_ti8/lion_spell_finger_death_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    end
end
