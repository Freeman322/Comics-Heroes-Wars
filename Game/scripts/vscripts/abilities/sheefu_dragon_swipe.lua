LinkLuaModifier( "modifier_sheefu_dragon_swipe_thinker", "abilities/sheefu_dragon_swipe.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sheefu_dragon_swipe_modifier", "abilities/sheefu_dragon_swipe.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

sheefu_dragon_swipe = class ( {})

function sheefu_dragon_swipe:OnSpellStart()
     if IsServer() then
          local caster = self:GetCaster()
          local point = self:GetCursorPosition()
          local team_id = caster:GetTeamNumber()
          local thinker = CreateModifierThinker(caster, self, "modifier_sheefu_dragon_swipe_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
     end
end

modifier_sheefu_dragon_swipe_thinker = class ({})

function modifier_sheefu_dragon_swipe_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()

        local radius = ability:GetSpecialValueFor("radius")

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, target)
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(radius, radius, 1))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", thinker)

        AddFOWViewer( thinker:GetTeam(), target, radius, 5, false)
        GridNav:DestroyTreesAroundPoint(target, radius, false)
    end
end

function modifier_sheefu_dragon_swipe_thinker:CheckState()
     return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_sheefu_dragon_swipe_thinker:IsAura()
    return true
end

function modifier_sheefu_dragon_swipe_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_sheefu_dragon_swipe_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sheefu_dragon_swipe_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_sheefu_dragon_swipe_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_sheefu_dragon_swipe_thinker:GetModifierAura()
    return "modifier_sheefu_dragon_swipe_modifier"
end

modifier_sheefu_dragon_swipe_modifier = class ( {})

function modifier_sheefu_dragon_swipe_modifier:IsDebuff ()
    return true
end

function modifier_sheefu_dragon_swipe_modifier:IsPurgable()
     return false
end

function modifier_sheefu_dragon_swipe_modifier:OnCreated (event)
     if IsServer() then
          self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
     end 
end

function modifier_sheefu_dragon_swipe_modifier:OnIntervalThink()
     if IsServer() then
        local damage = self:GetAbility():GetCaster():GetAverageTrueAttackDamage(self:GetParent())
        local ptc = self:GetAbility():GetSpecialValueFor("damage")
        
        if self:GetCaster():HasTalent("special_bonus_unique_sheefu_2") then
            ptc = self:GetCaster():FindTalentValue("special_bonus_unique_sheefu_2") + ptc
        end

        if self:GetCaster():HasTalent("special_bonus_unique_sheefu_3") then
            self:GetAbility():GetCaster():PerformAttack(self:GetParent(), false, false, true, true, false, false, true)
        end 
        
        ApplyDamage( {
            victim = self:GetParent(),
            attacker = self:GetAbility():GetCaster(),
            damage = damage * (ptc / 100),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        })

        ApplyDamage( {
            victim = self:GetParent(),
            attacker = self:GetAbility():GetCaster(),
            damage = self:GetAbility():GetSpecialValueFor("bonus_damage"),
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility()
        })
     end 
end

function modifier_sheefu_dragon_swipe_modifier:GetEffectName()
    return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf"
end

function modifier_sheefu_dragon_swipe_modifier:GetEffectAttachType ()
    return PATTACH_POINT_FOLLOW
end
