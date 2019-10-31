spectre_lvl_death = class ( {})
LinkLuaModifier ("modifier_spectre_lvl_death", "abilities/spectre_lvl_death.lua", LUA_MODIFIER_MOTION_NONE)

function spectre_lvl_death:GetIntrinsicModifierName()
    return "modifier_spectre_lvl_death"
end


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
        local sound = "Hero_DoomBringer.LvlDeath"
  
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "bloodlust_mask") then
          sound = "Hero_LifeStealer.Infest"
          local nFXIndex = ParticleManager:CreateParticle( "particles/spectre/bloodlust_effect.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
          ParticleManager:ReleaseParticleIndex (nFXIndex);
          local nFXIndex3 = ParticleManager:CreateParticle ("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_CUSTOMORIGIN, hTarget);
          ParticleManager:SetParticleControlEnt (nFXIndex3, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
          ParticleManager:ReleaseParticleIndex (nFXIndex3);
        else
          local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
          ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
          ParticleManager:ReleaseParticleIndex (nFXIndex);
  
          local nFXIndex2 = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
          ParticleManager:SetParticleControlEnt (nFXIndex2, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
          ParticleManager:ReleaseParticleIndex (nFXIndex2);
  
          local nFXIndex3 = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death.vpcf", PATTACH_CUSTOMORIGIN, hTarget);
          ParticleManager:SetParticleControlEnt (nFXIndex3, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
          ParticleManager:ReleaseParticleIndex (nFXIndex3);
  
          local nFXIndex4 = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_CUSTOMORIGIN, hTarget);
          ParticleManager:SetParticleControlEnt (nFXIndex4, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
          ParticleManager:ReleaseParticleIndex (nFXIndex4);
        end
  
        EmitSoundOn (sound, hTarget)
  
        local pers_damage = self:GetSpecialValueFor ("pers_damage") / 100
        local damage = 100
  
        local modifier = self:GetCaster():FindModifierByName("modifier_spectre_lvl_death")
        if modifier then if modifier._hUnits then damage = modifier._hUnits[hTarget] or 100 end end
  
        ApplyDamage ( { victim = hTarget, attacker = hCaster, damage = (damage * pers_damage) + self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
      end
   end
end

function spectre_lvl_death:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 


if modifier_spectre_lvl_death == nil then
    modifier_spectre_lvl_death = class({})
end

function modifier_spectre_lvl_death:IsHidden()
    return true
end

function modifier_spectre_lvl_death:IsPurgable()
    return false
end

function modifier_spectre_lvl_death:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end

function modifier_spectre_lvl_death:OnCreated(params)
    if IsServer() then 
        self._hUnits = {}
    end
end

function modifier_spectre_lvl_death:Destroy()
    if IsServer() then 
        self._hUnits = nil
    end
end

function modifier_spectre_lvl_death:OnTakeDamage( params )
    if IsServer() then
        local target = params.attacker
        local victim = params.unit

        if target:IsRealHero() and victim:IsRealHero() and target:GetTeamNumber() ~= victim:GetTeamNumber()  then 
            self._hUnits[target] = (self._hUnits[target] or 0) + params.damage
        end
    end
end

function modifier_spectre_lvl_death:OnDeath( params )
    if IsServer() then
        local unit = params.unit

        if unit:IsRealHero() and self._hUnits[unit] then self._hUnits[unit] = 0 end 
    end
end