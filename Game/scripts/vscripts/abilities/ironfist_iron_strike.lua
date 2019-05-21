if ironfist_iron_strike == nil then ironfist_iron_strike = class({}) end

LinkLuaModifier( "modifier_ironfist_iron_strike", "abilities/ironfist_iron_strike.lua", LUA_MODIFIER_MOTION_NONE )

function ironfist_iron_strike:OnAbilityPhaseStart()
		self.damage = self:GetCaster():GetMana()
    return true
end

function ironfist_iron_strike:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ironfist_iron_strike", {damage = self.damage}  )
	EmitSoundOn( "Hero_ObsidianDestroyer.EssenceAura", self:GetCaster() )
end

function ironfist_iron_strike:GetManaCost(iLevel)
    return self:GetCaster():GetMana() * 0.8
end

if modifier_ironfist_iron_strike == nil then modifier_ironfist_iron_strike = class({}) end

function modifier_ironfist_iron_strike:IsPurgable()
	return false
end

function modifier_ironfist_iron_strike:GetStatusEffectName()
	return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

function modifier_ironfist_iron_strike:StatusEffectPriority()
	return 1000
end

function modifier_ironfist_iron_strike:OnCreated( kv )
	if IsServer() then
		self.damage = (self:GetAbility():GetSpecialValueFor( "mana_to_damage" ) / 100) * kv.damage
		
		if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "iron_fist_golden_ways_of_faith") == true then
			local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/iron_fist_iron_strike_immortal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 15, Vector(255, 123, 0) )
			ParticleManager:SetParticleControl( nFXIndex, 16, Vector(1, 0, 0) )
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector(1, 0, 0) )
			ParticleManager:SetParticleControl( nFXIndex, 4, Vector(1, 0, 0) )
			ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fist" , self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 8, Vector(1, 0, 0) )
			self:AddParticle( nFXIndex, false, false, -1, false, true )
		end
	end
end


function modifier_ironfist_iron_strike:OnRefresh( kv )
	self.damage = (self:GetAbility():GetSpecialValueFor( "mana_to_damage" ) / 100) * kv.damage
end


function modifier_ironfist_iron_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_ironfist_iron_strike:GetModifierBaseAttack_BonusDamage()
	return self.damage
end

function modifier_ironfist_iron_strike:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hTarget = params.target
            EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
            EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", hTarget )
            EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
            EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )

            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_ground.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 0, 0) )
            ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0, 255, 0) )
            ParticleManager:SetParticleControl( nFXIndex, 3, Vector(0, 0.4, 0) )
            ParticleManager:SetParticleControl( nFXIndex, 11, hTarget:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 12, hTarget:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            local distanation = (self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self:GetAbility():GetSpecialValueFor("lenght"))
            local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
            local unit_table = FindUnitsInLine(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), distanation, nil, self:GetAbility():GetSpecialValueFor("width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags)

            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_iron_strike_line.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, distanation );
            ParticleManager:ReleaseParticleIndex( nFXIndex );


            for _, unit in pairs(unit_table) do
                local damage = {
                    victim = unit,
                    attacker = self:GetParent(),
                    damage = self.damage * (self:GetAbility():GetSpecialValueFor("cleave_percent") / 100),
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    ability = self:GetAbility(),
                }

                local knockbackProperties =
                {
                    center_x = unit:GetAbsOrigin().x,
                    center_y = unit:GetAbsOrigin().y,
                    center_z = unit:GetAbsOrigin().z,
                    duration = self:GetAbility():GetSpecialValueFor("stun_duration"),
                    knockback_duration = self:GetAbility():GetSpecialValueFor("stun_duration"),
                    knockback_distance = 500,
                    knockback_height = 0
                }
                unit:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )

                ApplyDamage( damage )
            end

            self:Destroy()
        end
    end
    return 0
end

function ironfist_iron_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
