LinkLuaModifier( "modifier_molagbal_sacrifice_thinker", "abilities/molagbal_sacrifice.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_molagbal_sacrifice_modifier", "abilities/molagbal_sacrifice.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_molagbal_sacrifice_damage", "abilities/molagbal_sacrifice.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

molagbal_sacrifice = class ( {})

function molagbal_sacrifice:OnSpellStart()
    if IsServer() then 
        CreateModifierThinker(self:GetCaster(), self, "modifier_molagbal_sacrifice_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
    end 
end

function molagbal_sacrifice:GetIntrinsicModifierName()
   return "modifier_molagbal_sacrifice_damage"
end

function molagbal_sacrifice:AddDamage()
    if IsServer() then 
        local damage = self:GetSpecialValueFor("ensnare_damage")
        if self:GetCaster():HasTalent("special_bonus_unique_molag_bal") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_molag_bal") end 

        local modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()) 

        if modifier then 
            modifier:SetStackCount(modifier:GetStackCount() + damage)
        end 
    end 
end

modifier_molagbal_sacrifice_thinker = class ({})

function modifier_molagbal_sacrifice_thinker:OnCreated(event)
    if IsServer() then
        self:StartIntervalThink(0.1)

        local nFXIndex = ParticleManager:CreateParticle( "particles/molag_bal/sacrifice.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
        ParticleManager:SetParticleControl( nFXIndex, 10, self:GetParent():GetAbsOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("MolagBal.Sacrifice.Cast", self:GetParent())

        AddFOWViewer( self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("duration"), false)
        GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), false)
    end
end

function modifier_molagbal_sacrifice_thinker:OnDestroy()
    if IsServer() then StopSoundOn("MolagBal.Sacrifice.Cast", self:GetParent()) end 
end

function modifier_molagbal_sacrifice_thinker:CheckState()
     return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_molagbal_sacrifice_thinker:IsAura()
    return true
end

function modifier_molagbal_sacrifice_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_molagbal_sacrifice_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_molagbal_sacrifice_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_molagbal_sacrifice_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_molagbal_sacrifice_thinker:GetModifierAura()
    return "modifier_molagbal_sacrifice_modifier"
end

modifier_molagbal_sacrifice_modifier = class ( {})


function modifier_molagbal_sacrifice_modifier:GetEffectName(  )
    return "particles/molag_bal/sacrifice_debuff.vpcf"
end

function modifier_molagbal_sacrifice_modifier:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_molagbal_sacrifice_modifier:IsPurgable()
    return false
end

function modifier_molagbal_sacrifice_modifier:OnCreated(htable)
    if IsServer() then
        self:StartIntervalThink(1)     

        EmitSoundOn("MolagBal.Sacrifice.Target", self:GetParent())

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
        
        self:AddParticle(nFXIndex, false, false, -1, false, false)
    end
end

function modifier_molagbal_sacrifice_modifier:OnDestroy()
    if IsServer() then
        if not self:GetParent():IsAlive() then 
            self:GetAbility():AddDamage()

            EmitSoundOn("MolagBal.Sacrifice.TargetDead", self:GetParent())
        end 

        StopSoundOn("MolagBal.Sacrifice.Target", self:GetParent())
    end
end

function modifier_molagbal_sacrifice_modifier:OnIntervalThink()
    if IsServer() then
        local damage = self:GetAbility():GetSpecialValueFor("damage")
        if self:GetCaster():HasTalent("special_bonus_unique_molag_bal_1") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_molag_bal_1") end 
        
        self:GetParent():ModifyHealth(self:GetParent():GetHealth() - damage, self:GetAbility(), true, 0)
        self:GetCaster():Heal(damage, self:GetAbility())
    end
end


--------------------------------------------------------------------------------
if modifier_molagbal_sacrifice_damage == nil then modifier_molagbal_sacrifice_damage = class({}) end

function modifier_molagbal_sacrifice_damage:IsPurgable()
    return false
end

function modifier_molagbal_sacrifice_damage:IsHidden()
    return true
end

function modifier_molagbal_sacrifice_damage:RemoveOnDeath()
    return false
end

function modifier_molagbal_sacrifice_damage:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_molagbal_sacrifice_damage:GetModifierPreAttack_BonusDamage (params)
    return self:GetStackCount()
end