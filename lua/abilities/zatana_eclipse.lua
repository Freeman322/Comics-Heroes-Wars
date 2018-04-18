LinkLuaModifier( "modifier_zatana_eclipse", "abilities/zatana_eclipse.lua", LUA_MODIFIER_MOTION_NONE )
if zatana_eclipse == nil then zatana_eclipse = class({}) end

function zatana_eclipse:CastFilterResultTarget( hTarget )
	if IsServer() then

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end


function zatana_eclipse:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		local duration = self:GetSpecialValueFor( "duration" )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_zatana_eclipse", { duration = duration } )

		EmitSoundOn( "Hero_Antimage.ManaVoidCast", hTarget )
		EmitSoundOn( "Hero_Oracle.PurifyingFlames.Damage", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

if modifier_zatana_eclipse == nil then modifier_zatana_eclipse = class({}) end

function modifier_zatana_eclipse:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_zatana/zatana_eclipse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
		self:StartIntervalThink(0.03)
        self.heal = 0
        self.mana = 0
        self.spent_mana = 0
        self.cooldown_spells = {}
        self.cooldown_items = {}
        for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
            local current_ability = self:GetParent():GetAbilityByIndex(i)
            if current_ability ~= nil then
                 self.cooldown_spells[current_ability] = current_ability:GetCooldownTimeRemaining()
            end
        end
        for i=0, 5, 1 do
			local current_item = self:GetParent():GetItemInSlot(i)
			if current_item ~= nil then
				if current_item:GetCooldownTimeRemaining() ~= nil or current_item:GetCooldownTimeRemaining() > 0 then
					self.cooldown_items[current_item] = current_item:GetCooldownTimeRemaining()
				end
			end
		end
	end
end

function modifier_zatana_eclipse:OnDestroy()
    if IsServer() then
        self:GetParent():Heal( self.heal*2, self:GetParent() )
        local mana = self.mana - self.spent_mana
        self:GetParent():SetMana(self:GetParent():GetMana() + mana)
        EmitSoundOn( "Hero_Oracle.PurifyingFlames", self:GetParent() )
        ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
        EmitSoundOn( "Hero_Oracle.FalsePromise.Damaged", self:GetParent() )
        -- Heal this unit.
		if _G.attackers_table[self:GetParent()] ~= nil then
			for attacker, data in pairs(_G.attackers_table[self:GetParent()]) do
			ApplyDamage ( {
					victim = self:GetParent(),
					attacker = attacker,
					damage = data.damage,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility(),
					damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
				})
			end
		end
        _G.attackers_table[self:GetParent()] = {}
        for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
            local current_ability = self:GetParent():GetAbilityByIndex(i)
            if current_ability ~= nil then
            	 current_ability:EndCooldown()
                 current_ability:StartCooldown( self.cooldown_spells[current_ability] - (self:GetAbility():GetSpecialValueFor("duration")*2))
            end
        end

        for i=0, 5, 1 do
			local current_item = self:GetParent():GetItemInSlot(i)
			if current_item ~= nil then
				if current_item:GetCooldownTimeRemaining() ~= nil or current_item:GetCooldownTimeRemaining() > 0 then
					current_item:EndCooldown()
                    current_item:StartCooldown( self.cooldown_items[current_item] - (self:GetAbility():GetSpecialValueFor("duration")*2))
				end
			end
		end
    end
end

function modifier_zatana_eclipse:OnIntervalThink()
	if IsServer() then
		self:GetParent():Purge(false, true, false, true, true)
		for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
            local current_ability = self:GetParent():GetAbilityByIndex(i)
            if current_ability ~= nil then
                 current_ability:StartCooldown( self.cooldown_spells[current_ability] )
            end
        end

        for i=0, 5, 1 do
			local current_item = self:GetParent():GetItemInSlot(i)
			if current_item ~= nil then
				if current_item ~= nil then
					current_item:StartCooldown( self.cooldown_items[current_item] )
				end
			end
		end
	end
end

function modifier_zatana_eclipse:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_MANA_GAINED,
		MODIFIER_EVENT_ON_SPENT_MANA
	}

	return funcs
end

function modifier_zatana_eclipse:OnHealReceived( params )
    if self:GetParent () == params.unit then
        self.heal = self.heal + params.gain
        self:GetParent ():SetHealth ( self:GetParent():GetHealth() - params.gain )
    end
end

function modifier_zatana_eclipse:OnManaGained( params )
    if self:GetParent () == params.unit then
        self.mana = self.mana + params.gain
        self:GetParent ():SetMana ( self:GetParent():GetMana() - params.gain )
    end
end

function modifier_zatana_eclipse:OnSpentMana( params )
    if self:GetParent () == params.unit then
        self.spent_mana = self.spent_mana + params.gain
    end
end

function zatana_eclipse:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

