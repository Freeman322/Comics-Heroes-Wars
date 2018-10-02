LinkLuaModifier ("modifier_ds_sniper_shot", "abilities/ds_sniper_shot.lua", LUA_MODIFIER_MOTION_NONE)
ds_sniper_shot = class ({})

function ds_sniper_shot:GetBehavior ()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function ds_sniper_shot:GetIntrinsicModifierName()
	return "modifier_ds_sniper_shot"
end

modifier_ds_sniper_shot = class ( {})


function modifier_ds_sniper_shot:OnCreated( kv )
    self.range = self:GetAbility():GetSpecialValueFor( "range" )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        self.caster_attack = self:GetParent():GetAttackCapability()
        self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_sniper/sniper_base_attack.vpcf")

        -- Sets the new attack type
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
        if self:GetCaster():HasTalent("special_bonus_unique_deathstroke") then
            self.range = self:GetCaster():FindTalentValue("special_bonus_unique_deathstroke") + self.range
        end
    end
end

--------------------------------------------------------------------------------

function modifier_ds_sniper_shot:OnDestroy( kv )
    if IsServer() then
        self:GetParent():SetAttackCapability(self.caster_attack)
    end
end

function modifier_ds_sniper_shot:OnRefresh( kv )
    self.range = self:GetAbility():GetSpecialValueFor( "range" )
    if IsServer() then
        if self:GetCaster():HasTalent("special_bonus_unique_deathstroke") then
            self.range = self:GetCaster():FindTalentValue("special_bonus_unique_deathstroke") + self.range
        end
    end
end

--------------------------------------------------------------------------------

function modifier_ds_sniper_shot:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_ds_sniper_shot:GetModifierAttackRangeBonus( params )
    return self.range
end

function modifier_ds_sniper_shot:GetModifierProjectileSpeedBonus( params )
    return 2000
end


--------------------------------------------------------------------------------

function modifier_ds_sniper_shot:OnAttackStart(params)
    if IsServer()  then
        if params.attacker:GetUnitName() == self:GetCaster():GetUnitName() then
            EmitSoundOn ("Hero_Sniper.MKG_attack",  self:GetParent())
            self:GetParent():RemoveGesture(ACT_DOTA_ATTACK)
            self:GetParent():StartGesture(ACT_DOTA_DAGON)
        end
    end
end
--------------------------------------------------------------------------------

function ds_sniper_shot:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

