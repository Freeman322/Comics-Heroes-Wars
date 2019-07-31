if byonder_void == nil then byonder_void = class({}) end

function byonder_void:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor("duration")
        local dmg = self:GetAbilityDamage() + self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("damage_mana_pct") / 100)
        local nFXIndex = ParticleManager:CreateParticle( "particles/galactus/galactus_seed_of_ambition_eternal_item.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )

        EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.TI8", self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "radius" ), 0) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #targets > 0 then
            for _,target in pairs(targets) do
                target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
                ApplyDamage({victim = target, attacker = self:GetCaster(), damage = dmg, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY}) 
			end
        end
    end
end
        


 


        
        
    