murlock_pounce = class({})

function murlock_pounce:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function murlock_pounce:OnSpellStart()
    local hero = self:GetCaster()
    EmitSoundOn("Hero_Slark.Pounce.Cast", hero)
    hero:AddNewModifier(hero, self, "modifier_slark_pounce", nil)
end

function murlock_pounce:GetPlaybackRateOverride()
    return 2
end
