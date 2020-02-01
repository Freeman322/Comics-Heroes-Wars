if samurai_atomic_dance == nil then
    samurai_atomic_dance = class({})
end
LinkLuaModifier( "modifier_samurai_atomic_dance", "abilities/samurai_atomic_dance.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_samurai_atomic_dance_cast", "abilities/samurai_atomic_dance.lua" ,LUA_MODIFIER_MOTION_NONE )

function samurai_atomic_dance:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "lenght_scepter" )
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function samurai_atomic_dance:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end

function samurai_atomic_dance:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_daredevil_arcana") then return "custom/lich_aura_passive" end
    if self:GetCaster():HasModifier("modifier_samurai_ancestors") then return "custom/samurai_omnislash_helmet" end
    return self.BaseClass.GetAbilityTextureName(self) 
end

function samurai_atomic_dance:OnAbilityPhaseStart()
    if IsServer() then
        local duration = 1.8
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_samurai_atomic_dance_cast", {duration = duration})

        EmitSoundOn( "Hero_Juggernaut.HealingWard.Cast", self:GetCaster() )
    end

    return true
end

--------------------------------------------------------------------------------

function samurai_atomic_dance:OnAbilityPhaseInterrupted()
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_samurai_atomic_dance_cast") then
            self:GetCaster():RemoveModifierByName("modifier_samurai_atomic_dance_cast")
        end
    end
end




function samurai_atomic_dance:OnSpellStart()
	local hCaster = self:GetCaster()
	local target_teams = self:GetAbilityTargetTeam()
    local target_types = self:GetAbilityTargetType()
    local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
    local unit_table = FindUnitsInLine(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), (self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self:GetSpecialValueFor("lenght")), nil, self:GetSpecialValueFor("width"), target_teams, target_types, target_flags)
    if #unit_table == 0 then
        self:EndCooldown()
        self:GetCaster():SetMana(self:GetCaster():GetMana() + self:GetManaCost(self:GetLevel()))
    end
    local start_pos = hCaster:GetAbsOrigin(  )

    for index, unit in pairs(unit_table) do
      unit.dest = ( start_pos - unit:GetAbsOrigin() ):Length2D()
    end

    table.sort(unit_table,
    function(i, j)
        if i.dest < j.dest then
            return true
        else
            return false
        end
    end)
    if IsServer() then
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "zoro") then
            EmitSoundOn( "Zoro.Cast4", self:GetCaster() )
        end
        for index, unit in pairs(unit_table) do
            Timers:CreateTimer(index * 0.1, function()
                hCaster:SetAbsOrigin(unit:GetAbsOrigin())
                FindClearSpaceForUnit (hCaster, unit:GetAbsOrigin (), false)
                if hCaster:HasScepter(  ) then
                    self.bonus_damage = self:GetSpecialValueFor( "damage_scepter" )
                end
                self.bonus_damage = self:GetSpecialValueFor( "damage" )
                self.prtc_damage = self:GetSpecialValueFor( "bonus_damage" )/100

                self.damage = self.bonus_damage + (self.prtc_damage*unit:GetMaxHealth())
                DamageTable = {attacker = hCaster, victim = unit, ability = self, damage = self.damage, damage_type = DAMAGE_TYPE_PURE}
                EmitSoundOn( "Hero_Juggernaut.OmniSlash.Damage", unit )
                -- Play named sound on Entity
                ApplyDamage( DamageTable )
                if unit and unit:IsNull() == false then
                    self:GetCaster():PerformAttack(unit, true, true, true, true, false, false, true)
                    if unit:IsCreep() and not unit:GetUnitName() == "npc_dota_warlock_golem_1" then
                        unit:Kill( self, hCaster )
                    end
                end
                local next_unit = unit_table[index + 1]
                if next_unit == nil then
                    next_unit = hCaster
                end
                if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "atomic_samurai_frost_arcana") == true then
                    EmitSoundOn("Hero_MonkeyKing.Spring.Impact", self:GetCaster())
                    EmitSoundOn("Hero_MonkeyKing.Spring.Water", self:GetCaster())
                    EmitSoundOn("Hero_MonkeyKing.Spring.Impact.Water", self:GetCaster())
                    EmitSoundOn("Hero_MonkeyKing.FurArmy.End", self:GetCaster())

                    local nFXIndex = ParticleManager:CreateParticle ("particles/hero_samurai/samurai_stomic_dance_arcana_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin (), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 1, next_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin (), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 2, next_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin (), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 3, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin (), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 5, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin (), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 6, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin (), true);
                    ParticleManager:ReleaseParticleIndex (nFXIndex);

                    local nFXIndex = ParticleManager:CreateParticle ("particles/hero_samurai/samurai_stomic_dance_arcana_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 3, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 4, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 5, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:ReleaseParticleIndex (nFXIndex);

                    local nFXIndex = ParticleManager:CreateParticle ("particles/hero_samurai/samurai_stomic_dance_arcana_snow.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControl(nFXIndex, 1, Vector (500, 500, 0));
                    ParticleManager:ReleaseParticleIndex (nFXIndex);
                elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "samurai_ancestors") == true then
                    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_samurai/samurai_stomic_dance_helmet_rope.vpcf", PATTACH_CUSTOMORIGIN, unit );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, next_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    local nFXIndex = ParticleManager:CreateParticle ("particles/hero_samurai/samurai_stomic_dance_helmet_tgt.vpcf", PATTACH_ABSORIGIN, unit);
                    ParticleManager:ReleaseParticleIndex (nFXIndex);

                    EmitSoundOn("Hero_Omniknight.Purification.Wingfall", self:GetCaster())
                    EmitSoundOn("Hero_Omniknight.Repel.TI8", self:GetCaster())
                 elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "samurai_sword_od_darkness") == true then
                 
                    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_trail_serrakura.vpcf", PATTACH_CUSTOMORIGIN, unit );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, next_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    local nFXIndex = ParticleManager:CreateParticle ("particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN, unit);
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex (nFXIndex);

                     EmitSoundOn("Hero_Juggernaut.BladeDance.Arcana", self:GetCaster())
                else
                     local nFXIndex = ParticleManager:CreateParticle ("particles/samurai/samurai_atomic_dance_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit);
                    ParticleManager:SetParticleControl(nFXIndex, 0, unit:GetAbsOrigin());
                    ParticleManager:SetParticleControl(nFXIndex, 1, next_unit:GetAbsOrigin());
                    ParticleManager:SetParticleControl(nFXIndex, 2, unit:GetAbsOrigin());
                    ParticleManager:SetParticleControl(nFXIndex, 3, next_unit:GetAbsOrigin());
                    ParticleManager:ReleaseParticleIndex (nFXIndex);
                    local nFXIndex = ParticleManager:CreateParticle ("particles/samurai/samurai_atomic_dance_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit);
                    ParticleManager:SetParticleControlEnt (nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin () + Vector (0, 0, 96), true);
                    ParticleManager:SetParticleControl (nFXIndex, 2, Vector (0, 0, 0));
                    ParticleManager:SetParticleControl (nFXIndex, 3, Vector (0, 0, 0));
                    ParticleManager:ReleaseParticleIndex (nFXIndex);
                end

                hCaster:StartGestureWithPlaybackRate (ACT_DOTA_ATTACK, 2)
                
                EmitSoundOn ("Hero_Juggernaut.OmniSlash.Damage", target)

                hCaster:PerformAttack (unit, false, false, true, true, false, false, true)
                hCaster:PerformAttack (unit, false, false, true, true, false, false, true)
                hCaster:PerformAttack (unit, false, false, true, true, false, false, true)       
            end)
            unit.dest = nil
        end
    end
end

if modifier_samurai_atomic_dance == nil then
    modifier_samurai_atomic_dance = class({})
end

function modifier_samurai_atomic_dance:IsHidden ()
    return true
end

function modifier_samurai_atomic_dance:IsPurgable ()
    return false
end

--------------------------------------------------------------------------------

function modifier_samurai_atomic_dance:GetStatusEffectName ()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

--------------------------------------------------------------------------------

function modifier_samurai_atomic_dance:StatusEffectPriority ()
    return 1000
end

function modifier_samurai_atomic_dance:GetHeroEffectName ()
    return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end


function modifier_samurai_atomic_dance:HeroEffectPriority ()
    return 100
end


function modifier_samurai_atomic_dance:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end


if modifier_samurai_atomic_dance_cast == nil then modifier_samurai_atomic_dance_cast = class({}) end

function modifier_samurai_atomic_dance_cast:IsHidden()
    return true
end

function modifier_samurai_atomic_dance_cast:IsPurgable()
    return false
end

function modifier_samurai_atomic_dance_cast:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

function modifier_samurai_atomic_dance_cast:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }

    return funcs
end

function modifier_samurai_atomic_dance_cast:GetOverrideAnimation(params)
    return ACT_DOTA_ATTACK
end

function modifier_samurai_atomic_dance_cast:GetOverrideAnimationRate(params)
    return 0.2
end
