spawn_soul_trick = class({})
LinkLuaModifier( "modifier_spawn_soul_trick", "abilities/spawn_soul_trick.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spawn_soul_trick:CastFilterResultTarget( hTarget )
    if IsServer() then
        if hTarget:HasModifier("modifier_item_mind_gem_active") or hTarget:HasModifier("modifier_spawn_soul_trick") or hTarget:HasModifier("modifier_celebrimbor_overseer") then
            return UF_FAIL_DOMINATED
        end

        local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end

    return UF_SUCCESS
end

function spawn_soul_trick:GetCastRange( vLocation, hTarget )
    return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function spawn_soul_trick:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            local duration = self:GetSpecialValueFor( "duration" )

            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spawn_soul_trick", { duration = duration } )

            EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Target", hTarget )

            ApplyDamage({
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = self:GetSpecialValueFor("damage"),
                damage_type = DAMAGE_TYPE_PURE,
                ability = self
            })
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", self:GetCaster() )

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "pepe") then
            EmitSoundOn( "Pepe.Cast", self:GetCaster() )
        end
    end
end

modifier_spawn_soul_trick = class({})

function modifier_spawn_soul_trick:IsPurgable()
    return false
end

function modifier_spawn_soul_trick:GetStatusEffectName()
    return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end


function modifier_spawn_soul_trick:StatusEffectPriority()
    return 1000
end

function modifier_spawn_soul_trick:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_spawn_soul_trick:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_spawn_soul_trick:OnCreated( params )
    if IsServer() then
        local caster = self:GetParent()
        self.original_team = caster:GetTeamNumber()
        if caster:GetTeamNumber() == 2 then
            self.target_team = 3
        else
            self.target_team = 2
        end
        caster:SetTeam(self.target_team)
    end
end

function modifier_spawn_soul_trick:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }

    return funcs
end

function modifier_spawn_soul_trick:GetModifierProvidesFOWVision()
    return 1
end

function modifier_spawn_soul_trick:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()

        caster:SetTeam(self.original_team)
    end
end

function spawn_soul_trick:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
