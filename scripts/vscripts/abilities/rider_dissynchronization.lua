rider_dissynchronization = class({})

LinkLuaModifier( "modifier_movespeed_bonus_talent", "abilities/rider_dissynchronization.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rider_dissynchronization", "abilities/rider_dissynchronization.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rider_dissynchronization_debuff", "abilities/rider_dissynchronization.lua", LUA_MODIFIER_MOTION_NONE )

function rider_dissynchronization:GetIntrinsicModifierName()
    return "modifier_movespeed_bonus_talent"
end

function rider_dissynchronization:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster() )
    EmitSoundOn("Hero_FacelessVoid.Chronosphere.MaceOfAeons", self:GetCaster())
	if self:GetCaster():HasModifier("modifier_black_flash_speed_blast") then
        local mod = self:GetCaster():FindModifierByName("modifier_black_flash_speed_blast")
        local dur = mod:GetStackCount()
        duration = duration + (dur*self:GetSpecialValueFor("duration_per_stack"))
    end
    if duration > self:GetCooldown(self:GetLevel()) then 
        duration = self:GetCooldown(self:GetLevel()) - 5
    end 
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_rider_dissynchronization", { duration = duration } )
    
    if self:IsIgnoreCooldownReduction() then
        self:EndCooldown()
        self:StartCooldown(self:GetSpecialValueFor("cooldown")) 
    end
end

if modifier_rider_dissynchronization == nil then modifier_rider_dissynchronization = class({}) end

--------------------------------------------------------------------------------

function modifier_rider_dissynchronization:OnCreated( kv )
    if IsServer() then
       local nFXIndex = ParticleManager:CreateParticle( "particles/hero_black_flash/rider_dissynchronization.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	   ParticleManager:SetParticleControl( nFXIndex, 1, Vector(400, 400, 1) )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	   self:AddParticle( nFXIndex, false, false, -1, false, true )
	   EmitSoundOn("Hero_Oracle.FatesEdict", self:GetParent())

       self.range = self:GetAbility():GetSpecialValueFor("radius")
       if self:GetParent():HasModifier("modifier_black_flash_tahion_field") then 
          local ability = self:GetParent():FindModifierByName("modifier_black_flash_tahion_field"):GetAbility()
          local count = 100
          local bonus = count * ability:GetLevel()
          self.range = self.range + bonus
       end
    end
end

function modifier_rider_dissynchronization:IsPurgable()
	return false
end

function modifier_rider_dissynchronization:IsHidden()
	return true
end

function modifier_rider_dissynchronization:IsAura()
	return true
end

function modifier_rider_dissynchronization:GetAuraRadius() 
	return self.range
end

function modifier_rider_dissynchronization:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_rider_dissynchronization:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_rider_dissynchronization:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_rider_dissynchronization:GetModifierAura()
	return "modifier_rider_dissynchronization_debuff"
end

if modifier_rider_dissynchronization_debuff == nil then modifier_rider_dissynchronization_debuff = class({}) end

function modifier_rider_dissynchronization_debuff:IsBuff ()
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return true
    else
        return false
    end
end

function modifier_rider_dissynchronization_debuff:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function modifier_rider_dissynchronization_debuff:OnIntervalThink()
    if IsServer() then
        if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
            self.damage = 0
            if self:GetCaster():HasModifier("modifier_black_flash_speed_blast") then
                local mod = self:GetCaster():FindModifierByName("modifier_black_flash_speed_blast")
                slowing = mod:GetStackCount()
                self.damage = slowing*self:GetAbility():GetSpecialValueFor("speed_blast_mult")
            end
            local damage = {
                victim = self:GetParent(),
                attacker = self:GetCaster(),
                damage = self.damage + self:GetAbility():GetAbilityDamage(),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility()
            }

            ApplyDamage( damage )
        end
    end
end


function modifier_rider_dissynchronization_debuff:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_rider_dissynchronization_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_rider_dissynchronization_debuff:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true}
    local state2 = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVULNERABLE] = true}
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return state2
    else
        return state
    end
end


if modifier_movespeed_bonus_talent == nil then modifier_movespeed_bonus_talent = class({}) end 

function modifier_movespeed_bonus_talent:IsPurgable()
	return false
end

function modifier_movespeed_bonus_talent:IsHidden()
	return true
end

function modifier_movespeed_bonus_talent:OnCreated(params)
	if IsServer() then 
        self.bonus = 0
         if self:GetCaster():HasTalent("special_bonus_unique_darkrider") then
            local value = self:GetCaster():FindTalentValue("special_bonus_unique_darkrider")
            self.bonus = value * self:GetStackCount()
        end
    end
end

function modifier_movespeed_bonus_talent:OnRefresh(params)
	if IsServer() then 
        self.bonus = 0
         if self:GetCaster():HasTalent("special_bonus_unique_darkrider") then
            local value = self:GetCaster():FindTalentValue("special_bonus_unique_darkrider")
            self.bonus = value * self:GetStackCount()
        end
    end
end


function modifier_movespeed_bonus_talent:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_movespeed_bonus_talent:GetModifierMoveSpeedBonus_Constant()
	return self.bonus
end

function modifier_movespeed_bonus_talent:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function rider_dissynchronization:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

