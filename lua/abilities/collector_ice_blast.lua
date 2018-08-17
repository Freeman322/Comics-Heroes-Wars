if collector_ice_blast == nil then collector_ice_blast = class({}) end

function collector_ice_blast:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function collector_ice_blast:IsStealable()
	return false
end



function collector_ice_blast:OnSpellStart()
    if IsServer() then 
        local duration = self:GetOrbSpecialValueFor("duration","q")
        local damage = self:GetOrbSpecialValueFor("damage","e")
        local radius = self:GetOrbSpecialValueFor("radius","q")

        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #targets > 0 then
            for _,target in pairs(targets) do
                target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
                ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
            end
        end

        EmitSoundOn("Hero_Crystal.CrystalNova", self:GetCaster())
        EmitSoundOn("hero_Crystal.CrystalNovaCast", self:GetCaster())
    
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    end
end
