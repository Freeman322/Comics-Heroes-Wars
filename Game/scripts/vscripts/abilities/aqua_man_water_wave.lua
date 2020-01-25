aqua_man_water_wave = class ( {})

LinkLuaModifier( "modifier_aqua_man_water_wave", "abilities/aqua_man_water_wave.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aqua_man_water_wave_debuff", "abilities/aqua_man_water_wave.lua", LUA_MODIFIER_MOTION_NONE )

function aqua_man_water_wave:OnSpellStart ()
    if IsServer() then 
        local radius = self:GetSpecialValueFor( "radius" ) 
        local duration = self:GetSpecialValueFor(  "duration" )
        local debuff = self:GetSpecialValueFor(  "cast_debuff_duration" )

        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_aqua_man_water_wave", { duration = duration } )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_slardar_amplify_damage", { duration = debuff } )
                unit:AddNewModifier( self:GetCaster(), self, "modifier_slithereen_crush",  { duration = debuff } )
                unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 1.0 } )
			    ApplyDamage({attacker = self:GetCaster(), victim = unit, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})	
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/slardar/slardar_takoyaki/slardar_crush_tako.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Slardar.Slithereen_Crush_Tako", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end

if not modifier_aqua_man_water_wave then modifier_aqua_man_water_wave = class({}) end

function modifier_aqua_man_water_wave:IsAura() return true end
function modifier_aqua_man_water_wave:IsHidden() return true end
function modifier_aqua_man_water_wave:IsPurgable() return false end
function modifier_aqua_man_water_wave:GetStatusEffectName() return "particles/status_fx/status_effect_ancestral_spirit.vpcf" end
function modifier_aqua_man_water_wave:StatusEffectPriority() return 1000 end
function modifier_aqua_man_water_wave:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_aqua_man_water_wave:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_aqua_man_water_wave:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_aqua_man_water_wave:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD end
function modifier_aqua_man_water_wave:GetModifierAura() return "modifier_slardar_amplify_damage" end

function modifier_aqua_man_water_wave:OnCreated(event)
    if IsServer () then
        StartSoundEvent("Aquaman.Waterpool", self:GetParent())

        local nFXIndex = ParticleManager:CreateParticle( "particles/aquaman/aquaman_spin_water.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_aqua_man_water_wave:OnDestroy()
    if IsServer () then
        StopSoundEvent("Aquaman.Waterpool", self:GetParent())
    end
end

function modifier_aqua_man_water_wave:DeclareFunctions()return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE } end
function modifier_aqua_man_water_wave:GetModifierMoveSpeed_Absolute( params ) return self:GetAbility():GetSpecialValueFor("absolute_speed") end
