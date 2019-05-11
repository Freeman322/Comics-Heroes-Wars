if not darkrider_speedforce_necromacy then darkrider_speedforce_necromacy = class({}) end
LinkLuaModifier( "modifier_darkrider_speedforce_necromacy", "abilities/darkrider_speedforce_necromacy.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_darkrider_speedforce_necromacy_target", "abilities/darkrider_speedforce_necromacy.lua", LUA_MODIFIER_MOTION_NONE )

function darkrider_speedforce_necromacy:GetIntrinsicModifierName() return "modifier_darkrider_speedforce_necromacy" end

modifier_darkrider_speedforce_necromacy = class({})
function modifier_darkrider_speedforce_necromacy:IsHidden() return true end
function modifier_darkrider_speedforce_necromacy:IsPurgable() return false end
function modifier_darkrider_speedforce_necromacy:RemoveOnDeath() return false end
function modifier_darkrider_speedforce_necromacy:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_darkrider_speedforce_necromacy:OnAttackLanded (params)
    if IsServer() then
        if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and params.attacker:IsRealHero() then
            if params.target:IsHero() then
                local modifier = params.target:FindModifierByName("modifier_darkrider_speedforce_necromacy_target")
                if not modifier then
                    modifier =  params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_darkrider_speedforce_necromacy_target", {duration = self:GetAbility():GetSpecialValueFor("counter_duration")})
                end
                modifier:IncrementStackCount()
            end
        end
    end
end

if not modifier_darkrider_speedforce_necromacy_target then modifier_darkrider_speedforce_necromacy_target = class({}) end
function modifier_darkrider_speedforce_necromacy_target:IsHidden() return false end
function modifier_darkrider_speedforce_necromacy_target:IsPurgable() return false end
function modifier_darkrider_speedforce_necromacy_target:GetEffectName() return "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_debuff_energy.vpcf" end
function modifier_darkrider_speedforce_necromacy_target:GetEffectAttachType() return PATTACH_ABSORIGIN end

function modifier_darkrider_speedforce_necromacy_target:OnStackCountChanged(iStackCount)
    if IsServer() then
        ParticleManager:DestroyParticle(self.effect, false)

        self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( self.effect, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( self.effect, 1, Vector(1, self:GetStackCount() + 1, 0) )
        ParticleManager:SetParticleControl( self.effect, 3, self:GetParent():GetAbsOrigin() )
        self:AddParticle(self.effect, false, false, -1, false, true)

        if iStackCount == self:GetAbility():GetSpecialValueFor("required_hits") then
            local radius = self:GetAbility():GetSpecialValueFor( "radius" )
            local duration = self:GetAbility():GetSpecialValueFor(  "stun_duration" )
            local damage = self:GetAbility():GetSpecialValueFor("bonus_damage")

            if self:GetCaster():HasTalent("special_bonus_unique_darkrider_1") then
                damage = self:GetCaster():FindTalentValue("special_bonus_unique_darkrider_1") + damage
            end


            local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
            if #units > 0 then
                for _, target in pairs(units) do
                    target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = duration } )

                    local damage = {
                        victim = target,
                        attacker = self:GetCaster(),
                        damage = damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility(),
                    }

                    ApplyDamage( damage )
                end
            end

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
            ParticleManager:SetParticleControl( nFXIndex, 2, Vector(radius, radius, 0) )
            ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetAbsOrigin() )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            EmitSoundOn( "Hero_Grimstroke.InkCreature.Returned", self:GetCaster() )

            self:GetAbility():UseResources(false, false, true)
            self:Destroy()
        end
    end
end

function modifier_darkrider_speedforce_necromacy_target:OnCreated(params)
    if IsServer() then
        self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( self.effect, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( self.effect, 1, Vector(1, self:GetStackCount() + 1, 0) )
        ParticleManager:SetParticleControl( self.effect, 3, self:GetParent():GetAbsOrigin() )
        self:AddParticle(self.effect, false, false, -1, false, true)

        EmitSoundOn( "Hero_Grimstroke.InkCreature.Cast", self:GetCaster() )
    end
end


function modifier_darkrider_speedforce_necromacy_target:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_darkrider_speedforce_necromacy_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
  end

  function modifier_darkrider_speedforce_necromacy_target:GetModifierPhysicalArmorBonus (params)
      return (self:GetAbility():GetSpecialValueFor("armor_reduction") * self:GetStackCount()) * (-1)
  end
