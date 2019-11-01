if medivh_energy_void == nil then medivh_energy_void = class({}) end

LinkLuaModifier( "medivh_energy_void_thinker", "abilities/medivh_energy_void.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "medivh_energy_void_modifier", "abilities/medivh_energy_void.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

medivh_energy_void = class ( {})

function medivh_energy_void:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "medivh_energy_void_thinker", {duration = self:GetSpecialValueFor("delay")}, point, team_id, false)
end

medivh_energy_void_thinker = class ({})

function medivh_energy_void_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        local sound = "Hero_Invoker.EMP.Cast"
        local sound2 = "Hero_Invoker.EMP.Charge"

        self.radius = ability:GetSpecialValueFor("area_of_effect")

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "elder_warlock") then
            local nFXIndex = ParticleManager:CreateParticle( "particles/stygian/elder_warlock_emp.vpcf", PATTACH_CUSTOMORIGIN, thinker )
            ParticleManager:SetParticleControl( nFXIndex, 0, target)
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(625, 625, 0))
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        else 
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_CUSTOMORIGIN, thinker )
            ParticleManager:SetParticleControl( nFXIndex, 0, target)
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(625, 625, 0))
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        end

        EmitSoundOn(sound, thinker)
        EmitSoundOn(sound2, thinker)

        AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 1500, false)
    end
end

function medivh_energy_void_thinker:OnDestroy()
    if IsServer() then
        local thinker = self:GetParent()
        local sound3 = "Hero_Invoker.EMP.Discharge"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "elder_warlock") then
            local nFXIndex = ParticleManager:CreateParticle( "particles/stygian/elder_warlock_emp_explode.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(500, 500, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex );
            sound3 = "Hero_Lion.FoD.Target.TI8_layer"
        else   
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(500, 500, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        end

        EmitSoundOn( sound3, thinker )

        local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, target in ipairs(nearby_targets) do
        	EmitSoundOn( "Hero_AbyssalUnderlord.Pit.Target", target )
           
            local damage = target:GetMaxMana()*(self:GetAbility():GetSpecialValueFor("mana_burned")/100)
           
            target:SetMana(target:GetMana() - damage)
            target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_item_diffusal_blade_slow", {duration = 2.5})

            ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage + 300, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end
end

function medivh_energy_void_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function medivh_energy_void_thinker:IsAura()
    return true
end

function medivh_energy_void_thinker:GetAuraRadius()
    return self.radius
end

function medivh_energy_void_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function medivh_energy_void_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function medivh_energy_void_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function medivh_energy_void_thinker:GetModifierAura()
    return "medivh_energy_void_modifier"
end

medivh_energy_void_modifier = class ( {})

function medivh_energy_void_modifier:IsDebuff ()
    return true
end

function medivh_energy_void_modifier:OnCreated (event)
    local ability = self:GetAbility ()
end

function medivh_energy_void_modifier:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function medivh_energy_void_modifier:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end

function medivh_energy_void:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

