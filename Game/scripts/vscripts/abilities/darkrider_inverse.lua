darkrider_inverse = class({})
LinkLuaModifier( "modifier_darkrider_inverse", "abilities/darkrider_inverse.lua", LUA_MODIFIER_MOTION_NONE )

function darkrider_inverse:GetAOERadius() return self:GetSpecialValueFor("search_aoe") end

function darkrider_inverse:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_darkrider_inverse", {duration = self:GetSpecialValueFor("delay")})
            
            EmitSoundOn( "Hero_Grimstroke.InkSwell.Cast", self:GetCaster() )
        end
    end
end


if not modifier_darkrider_inverse then modifier_darkrider_inverse = class({}) end 
function modifier_darkrider_inverse:GetEffectName() return "particles/ghost/mind_chaos_cast_debuff.vpcf" end
function modifier_darkrider_inverse:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_darkrider_inverse:IsPurgable() return false end

function modifier_darkrider_inverse:OnDestroy()
    if IsServer() then 
        local radius = self:GetAbility():GetSpecialValueFor( "search_aoe" ) 
        local damage = self:GetParent():GetIdealSpeed()
        local share_ptc = self:GetAbility():GetSpecialValueFor("damage_share_percentage")

        if self:GetCaster():HasTalent("special_bonus_unique_darkrider_2") then
            share_ptc = self:GetCaster():FindTalentValue("special_bonus_unique_darkrider_2") + share_ptc
        end

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _, target in pairs(units) do
                if target ~= self:GetParent() then 
                    damage = damage * (share_ptc / 100)
                end 
                
                target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.75})
                
                local damage = {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }
        
                ApplyDamage (damage)
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_crimson_ti8_immortal_cursed_crownmarker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(radius, radius, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetAbsOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Grimstroke.InkSwell.Damage", self:GetCaster() )
    end 
end

