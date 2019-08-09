if byonder_void == nil then byonder_void = class({}) end

function byonder_void:OnSpellStart()
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/galactus/galactus_seed_of_ambition_eternal_item.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )

        EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.TI8", self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "radius" ), 0) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetSpecialValueFor("radius"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false )
        if #targets > 0 then
            for _,target in pairs(targets) do
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")})
                ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetAbilityDamage() + self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("damage_mana_pct") / 100), damage_type = self:GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end
        end
    end
end
