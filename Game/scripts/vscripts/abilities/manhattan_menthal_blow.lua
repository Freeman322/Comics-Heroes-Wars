manhattan_menthal_blow = class({})

function manhattan_menthal_blow:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_lotus_orb_active", { duration = duration } )
            EmitSoundOn ("Item.CrimsonGuard.Cast", hTarget)
    
            local nFXIndex = ParticleManager:CreateParticle ("particles/items3_fx/iron_talon_active.vpcf", PATTACH_CUSTOMORIGIN, nil);
            ParticleManager:SetParticleControlEnt (nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_attack1", hTarget:GetOrigin (), true);
            ParticleManager:SetParticleControl(nFXIndex, 1, hTarget:GetOrigin ());
            ParticleManager:SetParticleControl(nFXIndex, 3, hTarget:GetOrigin ());
            ParticleManager:SetParticleControl(nFXIndex, 4, hTarget:GetOrigin ());
            ParticleManager:ReleaseParticleIndex (nFXIndex);
        end
    end
end

function manhattan_menthal_blow:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

