spectre_lvl_death = class ( {})

function spectre_lvl_death:CastFilterResultTarget (hTarget)

    if hTarget:GetUnitName() == "npc_dota_hero_chaos_knight" then
        return UF_FAIL_CUSTOM
    end
    if hTarget ~= nil and hTarget:IsMagicImmune ()  then
        return UF_FAIL_MAGIC_IMMUNE_ENEMY
    end
    local nResult = UnitFilter (hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster ():GetTeamNumber () )
    if nResult ~= UF_SUCCESS then
        return nResult
    end

    return UF_SUCCESS
end

--------------------------------------------------------------------------------

function spectre_lvl_death:GetCustomCastErrorTarget (hTarget)
    if hTarget:GetUnitName () == "npc_dota_hero_chaos_knight" then
        return "#dota_hud_error_cant_cast_ghost_rider"
    end
    return ""
end

--------------------------------------------------------------------------------

function spectre_lvl_death:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

--------------------------------------------------------------------------------

function spectre_lvl_death:OnSpellStart ()
    local hCaster = self:GetCaster ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local stun_duration = self:GetSpecialValueFor ("stun_duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_stunned", { duration = stun_duration } )
            EmitSoundOn ("Hero_DoomBringer.LvlDeath", hTarget)
            local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
            ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
            ParticleManager:ReleaseParticleIndex (nFXIndex);

            local nFXIndex2 = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
            ParticleManager:SetParticleControlEnt (nFXIndex2, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
            ParticleManager:ReleaseParticleIndex (nFXIndex2);
            local pers_damage = self:GetSpecialValueFor ("pers_damage") / 100

            local damage = _G.PunishingGazeTable[hTarget] or 0

            ApplyDamage ( { victim = hTarget, attacker = hCaster, damage = damage * pers_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })

            local nFXIndex3 = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death.vpcf", PATTACH_CUSTOMORIGIN, hTarget);
            ParticleManager:SetParticleControlEnt (nFXIndex3, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
            ParticleManager:ReleaseParticleIndex (nFXIndex3);

            local nFXIndex4 = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_CUSTOMORIGIN, hTarget);
            ParticleManager:SetParticleControlEnt (nFXIndex4, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
            ParticleManager:ReleaseParticleIndex (nFXIndex4);
        end
    end
end

function spectre_lvl_death:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

