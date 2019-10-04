deadpool_hypersonic_slashes = class ( {})

LinkLuaModifier ("modifier_deadpool_hypersonic_slashes", "abilities/deadpool_hypersonic_slashes.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_deadpool_hypersonic_slashes_target", "abilities/deadpool_hypersonic_slashes.lua", LUA_MODIFIER_MOTION_NONE)

function deadpool_hypersonic_slashes:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_neo_noir") then return "custom/the_old_facion_ult" end
    return self.BaseClass.GetAbilityTextureName(self) 
end
  
function deadpool_hypersonic_slashes:GetAOERadius ()
    if self:GetCaster ():HasScepter () then
        return 450
    end
    return 0
end

function deadpool_hypersonic_slashes:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function deadpool_hypersonic_slashes:GetBehavior ()
    if 	self:GetCaster ():HasScepter () then
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function deadpool_hypersonic_slashes:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        hTarget:AddNewModifier (self:GetCaster (), self, "modifier_deadpool_hypersonic_slashes_target", nil)
        EmitSoundOn ("Hero_Juggernaut.OmniSlash", hTarget)
        
        local nFXIndex = ParticleManager:CreateParticle ("particles/deadpool_multislash_cast.vpcf", PATTACH_CUSTOMORIGIN, hTarget);
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
        ParticleManager:SetParticleControl (nFXIndex, 1, hTarget:GetOrigin ());
        ParticleManager:ReleaseParticleIndex (nFXIndex);
    end
end

modifier_deadpool_hypersonic_slashes = class ( {})

function modifier_deadpool_hypersonic_slashes:IsHidden ()
    return true
end

function modifier_deadpool_hypersonic_slashes:IsPurgable ()
    return false
end

--------------------------------------------------------------------------------

function modifier_deadpool_hypersonic_slashes:GetStatusEffectName ()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

--------------------------------------------------------------------------------

function modifier_deadpool_hypersonic_slashes:StatusEffectPriority ()
    return 1000
end

function modifier_deadpool_hypersonic_slashes:GetHeroEffectName ()
    return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end


function modifier_deadpool_hypersonic_slashes:HeroEffectPriority ()
    return 100
end


function modifier_deadpool_hypersonic_slashes:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

modifier_deadpool_hypersonic_slashes_target = class ( {})

function modifier_deadpool_hypersonic_slashes_target:IsHidden ()
    return true
end

function modifier_deadpool_hypersonic_slashes_target:IsPurgable ()
    return false
end

function modifier_deadpool_hypersonic_slashes_target:OnCreated (kv)
    if IsServer () then
        local hTarget = self:GetParent ()
        self.damage = self:GetAbility ():GetSpecialValueFor ("damage")

        local caster = self:GetAbility ():GetCaster ()

        self.jumps_bonus = 0

        if self:GetCaster():HasTalent("special_bonus_unique_kyloren_4") then self.jumps_bonus = self:GetCaster():FindTalentValue("special_bonus_unique_kyloren_4") end 

        self.bounce_tick = self:GetAbility ():GetSpecialValueFor ("bounce_tick")

        self.jumps = self:GetAbility ():GetSpecialValueFor ("jumps") + self.jumps_bonus

        self:StartIntervalThink (self.bounce_tick)

        hTarget:Stop ()

        self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_deadpool_hypersonic_slashes", nil)
    end
end


function modifier_deadpool_hypersonic_slashes_target:OnRefresh (kv)
    if IsServer () then
        self.damage = self:GetAbility ():GetSpecialValueFor ("damage")
    end
end

function modifier_deadpool_hypersonic_slashes_target:OnIntervalThink ()
    if IsServer () then
        local target = self:GetParent ()
        local caster = self:GetAbility ():GetCaster ()
        if target:IsCreep () then
            target:Kill (self:GetAbility (), caster)
        end
        if  self.jumps <= 0 then
            self:Destroy ()
        end
        caster:SetAbsOrigin (target:GetAbsOrigin ())
        FindClearSpaceForUnit (caster, target:GetAbsOrigin (), false)

        local nFXIndex = ParticleManager:CreateParticle ("particles/deadpool_multislash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target);
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin () + Vector (0, 0, 96), true);
        ParticleManager:SetParticleControl (nFXIndex, 2, Vector (0, 0, 0));
        ParticleManager:SetParticleControl (nFXIndex, 3, Vector (0, 0, 0));
        ParticleManager:ReleaseParticleIndex (nFXIndex);
        caster:StartGestureWithPlaybackRate (ACT_DOTA_ATTACK, 2)
        EmitSoundOn ("Hero_Juggernaut.OmniSlash.Damage", target)

        caster:PerformAttack (target, true, true, true, true, false, false, true)
        ApplyDamage ( { victim = target, attacker = caster, damage = self.damage, ability = self:GetAbility (), damage_type = DAMAGE_TYPE_PHYSICAL })

        if self:GetCaster():HasTalent("special_bonus_unique_kyloren_5") then 
            caster:PerformAttack (target, true, true, true, true, false, false, true)
        end 

        self.jumps = self.jumps - 1
    end
end
--------------------------------------------------------------------------------
function modifier_deadpool_hypersonic_slashes_target:OnDestroy (kv)
    if IsServer () then
        local target = self:GetParent ()
        local caster = self:GetAbility ():GetCaster ()
        target:Stop ()
        caster:Stop ()
        caster:RemoveGesture (ACT_DOTA_ATTACK)

        caster:RemoveModifierByName ("modifier_deadpool_hypersonic_slashes")
        local chance = math.random (100)

        if caster:HasScepter () and chance <= 25 then
            self:FindNearestTarget ()
        end
    end
end

function modifier_deadpool_hypersonic_slashes_target:FindNearestTarget ()
    if IsServer () then
        self.radius = self:GetAbility ():GetSpecialValueFor ("radius_scepter")
        local caster = self:GetAbility ():GetCaster ()
        local nearby_units = FindUnitsInRadius (caster:GetTeam (), caster:GetAbsOrigin (), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        for i=1, #nearby_units do
            if  #nearby_units == 0 then
                return nil
            else
                local target = nearby_units[1]
                target:AddNewModifier (self:GetAbility ():GetCaster (), self:GetAbility (), "modifier_deadpool_hypersonic_slashes_target", nil)

                local nFXIndex = ParticleManager:CreateParticle ("particles/deadpool_multislash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, target);
                ParticleManager:SetParticleControl (nFXIndex, 0, target:GetAbsOrigin ());
                ParticleManager:SetParticleControl (nFXIndex, 1, caster:GetAbsOrigin ());
            end
        end
    end
end

