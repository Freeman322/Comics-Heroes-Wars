LinkLuaModifier ("modifier_black_panther_shadow_warrior", "abilities/black_panther_shadow_warrior.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

black_panther_shadow_warrior = class ( {})

function black_panther_shadow_warrior:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("duration")

    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_black_panther_shadow_warrior", { duration = duration } )
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_invisible", { duration = duration } )

    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
    ParticleManager:SetParticleControlEnt (nFXIndex, 2, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster ():GetOrigin (), true)
    ParticleManager:ReleaseParticleIndex (nFXIndex)

    EmitSoundOn ("Item.GlimmerCape.Activate", self:GetCaster () )

    self:GetCaster ():StartGesture (ACT_DOTA_OVERRIDE_ABILITY_3);

    local hAbility_sub = self:GetCaster ():GetAbilityByIndex (4)
    self:SetHidden (true)
    hAbility_sub:SetHidden (false)
    hAbility_sub:SetLevel (self:GetLevel ())
end

modifier_black_panther_shadow_warrior = class ( {})

function modifier_black_panther_shadow_warrior:IsHidden ()
    return true
end

function modifier_black_panther_shadow_warrior:OnCreated (args)
    local caster = self:GetParent ()
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle ("particles/vermilion_robe/glimmers_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster ():GetOrigin (), true)
        ParticleManager:SetParticleControl (nFXIndex, 1, Vector (100, 100, 0))
        ParticleManager:SetParticleControlEnt (nFXIndex, 2, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster ():GetOrigin (), true)
        ParticleManager:SetParticleControlEnt (nFXIndex, 3, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster ():GetOrigin (), true)
        ParticleManager:SetParticleControlEnt (nFXIndex, 5, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster ():GetOrigin (), true)
        ParticleManager:ReleaseParticleIndex (nFXIndex)
        local hAbility_sub1 = caster:GetAbilityByIndex (0)
        hAbility_sub1:SetActivated(false)
    end
end

function modifier_black_panther_shadow_warrior:OnDestroy (args)
    local caster = self:GetParent ()
    if IsServer () then
        local hAbility_sub = caster:GetAbilityByIndex (4)
        self:GetAbility():SetHidden (false)
        hAbility_sub:SetHidden (true)
        hAbility_sub:SetLevel (self:GetAbility ():GetLevel ())

        local hAbility_sub2 = caster:GetAbilityByIndex (0)
        hAbility_sub2:SetActivated (true)
    end
end

function modifier_black_panther_shadow_warrior:CheckState ()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    }

    return state
end

function black_panther_shadow_warrior:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

