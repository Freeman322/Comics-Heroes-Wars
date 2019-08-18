valkorion_ligning_explosion = class({})
LinkLuaModifier( "modifier_valkorion_ligning_explosion", "abilities/valkorion_ligning_explosion.lua", LUA_MODIFIER_MOTION_NONE )

function valkorion_ligning_explosion:OnSpellStart()
     if IsServer () then
          local hTarget = self:GetCursorTarget()
          if hTarget ~= nil then
               if ( not hTarget:TriggerSpellAbsorb( self ) ) then
                    local units = FindUnitsInRadius(self:GetCaster():GetTeam(), hTarget:GetAbsOrigin(), hTarget, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

                    local damage = self:GetSpecialValueFor("damage")

                    if self:GetCaster():HasTalent("special_bonus_unique_valkorion_2") then
                         damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_valkorion_2")
                    end

                    EmitSoundOn("Hero_ObsidianDestroyer.ArcaneOrb", hTarget)
                    
                    for i, target in pairs(units) do
                         target:AddNewModifier(self:GetCaster(), self, "modifier_valkorion_ligning_explosion", {duration = self:GetSpecialValueFor("duration")})

                         ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
                    
                         if target and not target:IsNull() and units[i + 1] then 
                              local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_CUSTOMORIGIN, target );
                              ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                              ParticleManager:SetParticleControlEnt( nFXIndex, 1, units[i + 1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i + 1]:GetOrigin(), true );
                              ParticleManager:ReleaseParticleIndex( nFXIndex );

                              EmitSoundOn("Hero_ObsidianDestroyer.Equilibrium.Damage", target)
                              EmitSoundOn("Hero_ObsidianDestroyer.Equilibrium.Damage", units[i + 1])
                         end 
                    end
               end
          end
    end
end

modifier_valkorion_ligning_explosion = class({})

function modifier_valkorion_ligning_explosion:IsHidden()
    return true
end

function modifier_valkorion_ligning_explosion:IsPurgable()
    return false
end

function modifier_valkorion_ligning_explosion:DeclareFunctions() 
     local funcs = {
          MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
     }
     return funcs
end

function modifier_valkorion_ligning_explosion:GetModifierMagicalResistanceBonus( params )
     return self:GetAbility():GetSpecialValueFor( "magical_armor_reductuion" ) * (-1)
end

function modifier_valkorion_ligning_explosion:GetStatusEffectName() return "particles/status_fx/status_effect_earth_spirit_boulderslow.vpcf" end
function modifier_valkorion_ligning_explosion:StatusEffectPriority() return 1000 end

function modifier_valkorion_ligning_explosion:GetEffectName() return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf" end
function modifier_valkorion_ligning_explosion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
