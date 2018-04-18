LinkLuaModifier ("modifier_spectre_quantum_brake", "abilities/spectre_quantum_brake.lua", LUA_MODIFIER_MOTION_NONE)
spectre_quantum_brake = class ( {})
--------------------------------------------------------------------------------
function spectre_quantum_brake:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_special_bonus_unique_sentinel_specter") then
        return 100
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function spectre_quantum_brake:OnSpellStart ()
    local radius = 99999
    local duration = self:GetSpecialValueFor ("duration")

    local enemies = FindUnitsInRadius (self:GetCaster ():GetTeamNumber (), self:GetCaster ():GetOrigin (), self:GetCaster (), radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
    if #enemies > 0 then
        for _, target in pairs (enemies) do
            target:AddNewModifier (self:GetCaster (), self, "modifier_spectre_quantum_brake", { duration = duration } )
        end
    end

    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
    ParticleManager:SetParticleControlEnt (nFXIndex, 2, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster ():GetOrigin (), true)
    ParticleManager:ReleaseParticleIndex (nFXIndex)

    EmitSoundOn ("Hero_Invoker.EMP.Discharge", self:GetCaster () )

    self:GetCaster ():StartGesture (ACT_DOTA_OVERRIDE_ABILITY_3);
end

modifier_spectre_quantum_brake = class ( {})

function modifier_spectre_quantum_brake:IsHidden()
    if self:GetParent():GetUnitName() == "npc_dota_hero_spectre" then
        return true
    else
        return false
    end
end

function modifier_spectre_quantum_brake:IsPurgable()
    return false
end

function modifier_spectre_quantum_brake:GetStatusEffectName()
    return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spectre_quantum_brake:StatusEffectPriority()
    return 1000
end

function modifier_spectre_quantum_brake:OnCreated()
    if IsServer () then
        local quantum_brake_effect = ParticleManager:CreateParticle ("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere_warp.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl (quantum_brake_effect, 0, self:GetParent ():GetAbsOrigin ())
        ParticleManager:SetParticleControl (quantum_brake_effect, 1, Vector (9999, 9999, 50))
        self:AddParticle( quantum_brake_effect, false, false, -1, false, true )
    end

end

function modifier_spectre_quantum_brake:CheckState()
    if self:GetParent():GetUnitName() == "npc_dota_hero_spectre" then
        state = {}
    else
        state = {
            [MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_FROZEN] = true,
        }
    end
    return state
end

function spectre_quantum_brake:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

