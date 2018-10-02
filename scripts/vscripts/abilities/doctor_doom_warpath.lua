LinkLuaModifier ("modifier_doctor_doom_warpath", "abilities/doctor_doom_warpath.lua", LUA_MODIFIER_MOTION_NONE)
doctor_doom_warpath = class ( {})
--------------------------------------------------------------------------------

function doctor_doom_warpath:OnSpellStart ()
    local hCaster = self:GetCaster ()
    local hTarget = self:GetCursorTarget ()


    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        hTarget:Interrupt()
        local nCasterFX = ParticleManager:CreateParticle ("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
        ParticleManager:SetParticleControlEnt (nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin (), false)
        ParticleManager:ReleaseParticleIndex (nCasterFX)
        local nTargetFX = ParticleManager:CreateParticle ("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
        ParticleManager:SetParticleControlEnt (nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin (), false)
        ParticleManager:ReleaseParticleIndex (nTargetFX)
        EmitSoundOn ("Hero_VengefulSpirit.NetherSwap", hCaster)
        EmitSoundOn ("Hero_Dark_Seer.Surge", hTarget)
        local duration = self:GetSpecialValueFor ("duration")
        hTarget:AddNewModifier (hCaster, self, "modifier_doctor_doom_warpath", nil)
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_doctor_doom_warpath = class({})

--------------------------------------------------------------------------------

function modifier_doctor_doom_warpath:IsPurgable(  )
    return false
end

function modifier_doctor_doom_warpath:RemoveOnDeath(  )
    return true
end

function modifier_doctor_doom_warpath:OnCreated( kv )
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_doom") and self:GetCaster():HasScepter() then
            local mod = self:GetCaster():FindModifierByName("modifier_doom")
            self.damage_bonus = mod:GetStackCount()
        else
            self.damage_bonus = 0
        end
    end
    self.damage_bonus = self.damage_bonus or 0
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self.damage_bonus
    self.counter = 0
    self:StartIntervalThink(1)
end

function modifier_doctor_doom_warpath:OnIntervalThink()
    local thinker = self:GetParent()
    if IsServer() then
        if self:GetCaster():IsAlive() == false then
            self:Destroy()
        end
        self.counter = self.counter + 1
        if self.counter == 30 then
            self.counter = 0
            if self:GetCaster():HasModifier("modifier_doom") then
                local mod = self:GetCaster():FindModifierByName("modifier_doom")
                mod:SetStackCount(mod:GetStackCount() + 1)
                self:GetCaster():CalculateStatBonus()
            end
        end
        ApplyDamage({victim = thinker, attacker = self:GetAbility():GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
    end
end

function modifier_doctor_doom_warpath:GetEffectName()
    return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end

--------------------------------------------------------------------------------

function modifier_doctor_doom_warpath:GetEffectAttachType()
    return PATTACH_POINT_FOLLOW
end

function doctor_doom_warpath:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

