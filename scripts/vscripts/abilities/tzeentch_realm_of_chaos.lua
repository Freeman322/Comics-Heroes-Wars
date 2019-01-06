if tzeentch_realm_of_chaos == nil then tzeentch_realm_of_chaos = class({}) end

LinkLuaModifier( "modifier_tzeentch_realm_of_chaos_caster", "abilities/tzeentch_realm_of_chaos.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tzeentch_realm_of_chaos_caster_units", "abilities/tzeentch_realm_of_chaos.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tzeentch_realm_of_chaos:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "tooltip_duration" )

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #units > 0 then
		for _,unit in pairs(units) do
            if unit ~= self:GetCaster() then
			    unit:AddNewModifier( self:GetCaster(), self, "modifier_tzeentch_realm_of_chaos_caster_units", { duration = duration } )
            end
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_tzeentch_realm_of_chaos_caster", { duration = duration } )

	EmitSoundOn( "Hero_ShadowDemon.DemonicPurge.Damage", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end
----particles/generic_hero_status/status_invisibility_start_ground.vpcf

if modifier_tzeentch_realm_of_chaos_caster_units == nil then modifier_tzeentch_realm_of_chaos_caster_units = class({}) end

 function modifier_tzeentch_realm_of_chaos_caster_units:IsHidden()
    return true
end

function modifier_tzeentch_realm_of_chaos_caster_units:IsPurgable()
    return false
end


function modifier_tzeentch_realm_of_chaos_caster_units:OnCreated()
    if IsServer () then
        local warp = ParticleManager:CreateParticleForPlayer("particles/hero_tzeench/tzeentch_warp_realm_of_chaos.vpcf", PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetOwner())
        ParticleManager:SetParticleControl (warp, 0, self:GetParent ():GetAbsOrigin ())
        ParticleManager:SetParticleControl (warp, 1, Vector (9999, 9999, 50))
        self:AddParticle( warp, false, false, -1, false, true )

        local invis = ParticleManager:CreateParticleForPlayer("particles/generic_hero_status/status_invisibility_start_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetOwner())
        self:AddParticle(invis, false, true, 1000, false, false)
    end
end

if modifier_tzeentch_realm_of_chaos_caster == nil then modifier_tzeentch_realm_of_chaos_caster = class({}) end

function modifier_tzeentch_realm_of_chaos_caster:OnCreated( kv )
    if IsServer() then
        EmitSoundOn( "Hero_Invoker.EMP.Discharge", self:GetCaster() )
        local warp = ParticleManager:CreateParticleForPlayer("particles/hero_tzeench/tzeentch_warp_realm_of_chaos_screen.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetCaster():GetOwner())
        self:AddParticle( warp, false, false, -1, false, true )
    end
end

function modifier_tzeentch_realm_of_chaos_caster:OnDestroy( kv )
    if IsServer() then
        EmitSoundOn( "Hero_Invoker.ForgeSpirit", self:GetCaster() )
    end
end

function modifier_tzeentch_realm_of_chaos_caster:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }

    return funcs
end

function modifier_tzeentch_realm_of_chaos_caster:GetModifierMoveSpeed_Absolute(params)
    return 10000
end

function modifier_tzeentch_realm_of_chaos_caster:GetModifierMoveSpeed_Max( params )
    return 10000
end

function modifier_tzeentch_realm_of_chaos_caster:GetModifierMoveSpeed_Limit( params )
    return 10000
end

function modifier_tzeentch_realm_of_chaos_caster:IsHidden()
    return true
end

function modifier_tzeentch_realm_of_chaos_caster:IsPurgable()
    return false
end

function modifier_tzeentch_realm_of_chaos_caster:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }

    return state
end

function modifier_tzeentch_realm_of_chaos_caster:GetEffectName()
    if self:GetParent():HasModifier("modifier_mera") then return "particles/hero_tzeench/mera_auravpcf.vpcf" end 
    return 
end

function modifier_tzeentch_realm_of_chaos_caster:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function tzeentch_realm_of_chaos:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

