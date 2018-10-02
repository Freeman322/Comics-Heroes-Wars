if antman_battle_state == nil then antman_battle_state = class({}) end

LinkLuaModifier ("modifier_antman_battle_state", "abilities/antman_battle_state.lua", LUA_MODIFIER_MOTION_NONE )

function antman_battle_state:OnSpellStart()
    if IsServer() then 
        local duration = self:GetSpecialValueFor(  "duration" )

        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_antman_battle_state", { duration = duration } )
        
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end


if modifier_antman_battle_state == nil then
    modifier_antman_battle_state = class ( {})
end

function modifier_antman_battle_state:IsHidden ()
    return false
end

function modifier_antman_battle_state:IsPurgable()
    return false
end

function modifier_antman_battle_state:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_antman_battle_state:OnAttackLanded(params)
    if IsServer () then
        if params.attacker == self:GetParent() then
          if params.target:IsRealHero() then
                local modifier = self:GetParent():FindModifierByName("antman_size_modifier")
                if modifier then 
                    local multiplier = modifier:GetStackCount() / 100

                    local stun = self:GetAbility():GetSpecialValueFor("bash_mult") * multiplier
                    local cleave = self:GetAbility():GetSpecialValueFor("cleave_mult") * multiplier
                    local damage = self:GetAbility():GetSpecialValueFor("damage") * multiplier

                    params.target:AddNewModifier (self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = stun })
                    ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = params.target, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})

                    local cleaveDamage = (damage * params.damage) / 100.0
                    DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, 150, 300, 570, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf" )
                end
            end
        end
    end

    return 0
end

