LinkLuaModifier( "modifier_ebonymaw_magnetize", "abilities/ebonymaw_magnetize.lua",LUA_MODIFIER_MOTION_NONE )

ebonymaw_magnetize = class ({})

function ebonymaw_magnetize:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function ebonymaw_magnetize:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function ebonymaw_magnetize:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function ebonymaw_magnetize:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil and not hTarget:TriggerSpellAbsorb(self) then 
    	local duration = self:GetSpecialValueFor("duration")
		EmitSoundOn( "Hero_EarthSpirit.Magnetize.Cast", self:GetCaster() )	

    	local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ebony/ebonymaw_magnetizm.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

      	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #units > 0 then
			for _,target in pairs(units) do
				target:AddNewModifier( self:GetCaster(), self, "modifier_ebonymaw_magnetize", { duration = duration } )
			end
		end
		EmitSoundOn( "Hero_Lion.FingerOfDeath.TI8", self:GetCaster() )
		EmitSoundOn( "Hero_Lion.FingerOfDeathImpact.TI8", hTarget )
        
        local dmg = self:GetSpecialValueFor("damage_mana_pct")
        if self:GetCaster():HasTalent("special_bonus_unique_ebonymaw_3") then 
            dmg = dmg + self:GetCaster():FindTalentValue("special_bonus_unique_ebonymaw_3")
        end

		local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = (dmg / 100) * hTarget:GetMaxMana(),
            damage_type = DAMAGE_TYPE_PURE,
            ability = self
        }
        ApplyDamage( damage ) 

        if hTarget:GetManaPercent() <= self:GetSpecialValueFor("mana_kill_border") then 
        	hTarget:Kill(self, self:GetCaster())
        end
    end
end

modifier_ebonymaw_magnetize = class ({})

function modifier_ebonymaw_magnetize:IsHidden()
    return false
end

function modifier_ebonymaw_magnetize:IsBuff()
    return false
end

function modifier_ebonymaw_magnetize:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_ebonymaw_magnetize:OnIntervalThink()
    if IsServer() then   
        ApplyDamage ( { attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage_per_second"), damage_type = self:GetAbility():GetAbilityDamageType()})
    end
end