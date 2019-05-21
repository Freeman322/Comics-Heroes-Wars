if not godspeed_speed_void then godspeed_speed_void = class({}) end
LinkLuaModifier ("modifier_godspeed_speed_void", "abilities/godspeed_speed_void.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_speed_void:IsRefreshable()
    return true
end

function godspeed_speed_void:OnUpgrade()
    if IsServer() then 
        local heroes = HeroList:GetAllHeroes()

        for k, hero in pairs(heroes) do
            if not hero:HasModifier("modifier_godspeed_speed_void") then hero:AddNewModifier(self:GetCaster(), self, "modifier_godspeed_speed_void", nil) end 
        end
    end 
end

function godspeed_speed_void:GetCooldown( nLevel )
    if IsServer() then if self:GetCaster():HasTalent("special_bonus_godspeed_2") then return self:GetCaster():FindTalentValue("special_bonus_godspeed_2") end end 
    return self.BaseClass.GetCooldown( self, nLevel )
end

function godspeed_speed_void:GetAOERadius()
    if self:GetCaster():HasScepter() then 
        return self:GetSpecialValueFor("radius_scepter")
    end
    return
end

function godspeed_speed_void:GetBehavior()
    if self:GetCaster():HasScepter() then 
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function godspeed_speed_void:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil and hTarget:HasModifier("modifier_godspeed_speed_void") then
            if ( not hTarget:TriggerSpellAbsorb( self ) ) then
                pcall(function()
                    local damage = hTarget:FindModifierByName("modifier_godspeed_speed_void"):GetTotalDistance() * (self:GetSpecialValueFor("damage") / 100)

                    local nFXIndex = ParticleManager:CreateParticle( "particles/godspeed/godspeed_speed_void.vpcf", PATTACH_CUSTOMORIGIN, nil );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    EmitSoundOn("Godspeed.SpeedVoid.Cast", hTarget)

                    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("ministun")})
                    
                    local damage_tbl = {
                        victim = hTarget,
                        attacker = self:GetCaster(),
                        damage = damage,
                        damage_type = self:GetAbilityDamageType(),
                        damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
                        ability = self
                    }

                    if self:GetCaster():HasScepter() then
                        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, self:GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
                        if #units > 0 then
                            for _,  unit in pairs(units) do
                                unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("ministun")})
                                
                                EmitSoundOn("Godspeed.SpeedVoid.Cast", unit)

                                local damage_tbl = {
                                    victim = unit,
                                    attacker = self:GetCaster(),
                                    damage = damage,
                                    damage_type = self:GetAbilityDamageType(),
                                    damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
                                    ability = self
                                }
                                ApplyDamage( damage_tbl )
                            end
                        end 
                    end

                    ApplyDamage( damage_tbl )
                end)
            end
        end
    end
end

if modifier_godspeed_speed_void == nil then modifier_godspeed_speed_void = class({}) end

function modifier_godspeed_speed_void:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end

function modifier_godspeed_speed_void:OnCreated(params)
    if IsServer() then 
        self._iDistance = 0
        self._vPosition = self:GetParent():GetAbsOrigin()
    end 
end

function modifier_godspeed_speed_void:GetTotalDistance()
    if IsServer() then 
        return self._iDistance or 0
    end 
end

function modifier_godspeed_speed_void:OnDeath(params)
    if IsServer() and params.unit == self:GetParent() then 
        self._iDistance = 0
    end 
end

function modifier_godspeed_speed_void:OnUnitMoved(params)
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

function modifier_godspeed_speed_void:OnPositionChanged( distance )
	if IsServer() then 
		self._iDistance = (self._iDistance or 0) + distance
	end
end

function modifier_godspeed_speed_void:IsHidden()
	return true
end

function modifier_godspeed_speed_void:IsPurgable()
	return false
end

function modifier_godspeed_speed_void:RemoveOnDeath()
	return false
end