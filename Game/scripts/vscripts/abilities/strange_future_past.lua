LinkLuaModifier( "modifier_strange_future_past", "abilities/strange_future_past.lua", LUA_MODIFIER_MOTION_NONE )

strange_future_past = class({})

function strange_future_past:CastFilterResultTarget( hTarget )
	if not hTarget:HasModifier("modifier_strange_future_past") then
		return UF_FAIL_CUSTOM
    end
    
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end


function strange_future_past:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_strange_eternal_bracers") then return "custom/strange_eternal_bracers_future_past" end
    return self.BaseClass.GetAbilityTextureName(self) 
end


function strange_future_past:GetCustomCastErrorTarget( hTarget )
	if not hTarget:HasModifier("modifier_strange_future_past") then
		return "#dota_hud_error_cant_cast_on_invalid_target"
	end

	return ""
end

function strange_future_past:IsStealable(  )
    return false
end

function strange_future_past:OnHeroLevelUp()
    if IsServer() then 
        self._tUnits = HeroList:GetAllHeroes()
        for _, hero in pairs(self._tUnits) do
            if hero:IsRealHero() and hero:HasModifier("modifier_strange_future_past") == false then 
                hero:AddNewModifier(self:GetCaster(), self, "modifier_strange_future_past", nil)
            end
        end
    end
end

function strange_future_past:OnSpellStart(  )
    if IsServer() then 
        local hTarget = self:GetCursorTarget()

        if hTarget:HasModifier("modifier_strange_future_past") then 
            local damage = hTarget:FindModifierByName("modifier_strange_future_past"):GetTotalLifetimeDamage()

            damage = damage * (self:GetSpecialValueFor("damage_mult") / 100)

            if self:GetCaster():HasTalent("special_bonus_unique_strange") then
                damage = damage + (damage * (self:GetCaster():FindTalentValue("special_bonus_unique_strange")/100))
            end

            local damage_table = {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = damage,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self
            }

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2017/dagon_wm07.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            local nFXIndexTarget = ParticleManager:CreateParticle( "particles/dr_starnge/strange_future_past_target.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndexTarget, 0, hTarget:GetOrigin());
            ParticleManager:ReleaseParticleIndex( nFXIndexTarget );

            EmitSoundOn( "Hero_Invoker.Tornado.Cast.Immortal", self:GetCaster() )
            EmitSoundOn( "Hero_Invoker.DeafeningBlast.Immortal", hTarget )

            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "cat") then
                EmitSoundOn( "Strange.Cast2", self:GetCaster() )
            end

            ApplyDamage( damage_table )
        end
    end
end


modifier_strange_future_past = class({})

function modifier_strange_future_past:IsHidden()
	return true
end

function modifier_strange_future_past:IsPurgable()
	return false
end

function modifier_strange_future_past:RemoveOnDeath()
	return false
end

function modifier_strange_future_past:OnCreated( kv )
	self.damage = 0
end

function modifier_strange_future_past:GetTotalLifetimeDamage()
    return self.damage or 0
end

function modifier_strange_future_past:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_strange_future_past:OnDeath( params )
    if IsServer() then        
        if self:GetParent() == params.unit then 
            self.damage = 0
        end
	end

	return 0
end

function modifier_strange_future_past:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
        self.damage = (self.damage or 0) + params.damage
        end
    end
end
