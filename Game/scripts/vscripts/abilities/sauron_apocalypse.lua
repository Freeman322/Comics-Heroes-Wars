sauron_apocalypse = class ( {})
LinkLuaModifier ("sauron_apocalypse_thinker", "abilities/sauron_apocalypse.lua",LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function sauron_apocalypse:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

--------------------------------------------------------------------------------

function sauron_apocalypse:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("wave_duration")

    local kv = {duration = duration}
    CreateModifierThinker (self:GetCaster(), self, "sauron_apocalypse_thinker", kv, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

sauron_apocalypse_thinker = class ( {})

--------------------------------------------------------------------------------

function sauron_apocalypse_thinker:IsHidden ()
    return true
end

--------------------------------------------------------------------------------

function sauron_apocalypse_thinker:OnCreated (kv)
    self.aoe = self:GetAbility ():GetSpecialValueFor ("radius")
    self.damage = self:GetAbility ():GetSpecialValueFor ("wave_damage")
    if IsServer () then
        self:StartIntervalThink (1)
    end
end

--------------------------------------------------------------------------------

function sauron_apocalypse_thinker:OnIntervalThink ()
    if IsServer () then
        GridNav:DestroyTreesAroundPoint (self:GetParent ():GetOrigin (), self.aoe, false)

        local enemies = FindUnitsInRadius (self:GetParent ():GetTeamNumber (), self:GetParent ():GetOrigin (), self:GetParent (), self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        if #enemies > 0 then
            for _, enemy in pairs (enemies) do
                if enemy ~= nil and ( not enemy:IsMagicImmune () ) and ( not enemy:IsInvulnerable () ) then
                    local damage = {
                        victim = enemy,
                        attacker = self:GetCaster (),
                        damage = self.damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility ()
                    }
                    
                    EmitSoundOn ("Hero_Silencer.Curse.Impact", enemy)
                   
                    enemy:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_stunned", { duration = 0.1 } )

                    ApplyDamage (damage)
                end
            end
        end
        EmitSoundOn ("Hero_Silencer.Curse", self:GetParent ())
        local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (nFXIndex, 0, self:GetParent ():GetOrigin () )
        ParticleManager:SetParticleControl (nFXIndex, 1, Vector (self.aoe, self.aoe, 1) )
        ParticleManager:ReleaseParticleIndex (nFXIndex)
    end
end

function sauron_apocalypse:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

