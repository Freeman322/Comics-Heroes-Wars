sauron_depletion = class ( {})

function sauron_depletion:CastFilterResultTarget (hTarget)
    if IsServer () then
        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

--------------------------------------------------------------------------------

function sauron_depletion:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

--------------------------------------------------------------------------------

function sauron_depletion:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local damage_mult = self:GetSpecialValueFor ("damage_per_health")
            local damage = damage_mult * hTarget:GetHealthDeficit ()
            local bourder = self:GetSpecialValueFor ("hit_point_minimum_pct")
            
            if bourder >= hTarget:GetHealthPercent() then
                hTarget:Kill(self, self:GetCaster())
            end
            
            ApplyDamage ( { attacker = self:GetCaster (), victim = hTarget, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self})
           
            if hTarget and not hTarget:IsNull() then
                self:GetCaster ():Heal (damage * (self:GetSpecialValueFor ("heal_pct")/100), self:GetCaster ())
                hTarget:AddNewModifier (self:GetCaster (), self, "modifier_stunned", { duration = 1.0 } )
                EmitSoundOn ("Hero_Lina.LagunaBlade.Immortal", hTarget)
            end
        end

        local nFXIndex = ParticleManager:CreateParticle ("particles/sauron/diplation.vpcf", PATTACH_CUSTOMORIGIN, nil);
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_attack1", hTarget:GetOrigin () + Vector (0, 0, 96), true);
        ParticleManager:SetParticleControlEnt (nFXIndex, 1,  self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetCaster ():GetOrigin (), true);
        ParticleManager:SetParticleControl (nFXIndex, 2, hTarget:GetOrigin ());
        ParticleManager:SetParticleControl (nFXIndex, 3, hTarget:GetOrigin ());
        ParticleManager:SetParticleControl (nFXIndex, 4, hTarget:GetOrigin ());
        ParticleManager:SetParticleControl (nFXIndex, 5, hTarget:GetOrigin ());
        ParticleManager:ReleaseParticleIndex (nFXIndex);

        EmitSoundOn ("Hero_Lina.LagunaBladeImpact.Immortal", self:GetCaster () )
    end
end
function sauron_depletion:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

