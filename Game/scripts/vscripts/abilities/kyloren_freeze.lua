kyloren_freeze = class({})
LinkLuaModifier( "modifier_kyloren_freeze",   "abilities/kyloren_freeze.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function kyloren_freeze:GetAOERadius()
    if self:GetCaster():HasScepter() then 
        return self:GetSpecialValueFor("radius_scepter")
    end
    return
end

function kyloren_freeze:GetBehavior()
    if self:GetCaster():HasScepter() then 
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function kyloren_freeze:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
            local damage = self:GetSpecialValueFor("damage")
            if self:GetCaster():HasTalent("special_bonus_unique_kyloren_1") then
                damage = damage + (self:GetCaster():FindTalentValue("special_bonus_unique_kyloren_1") or 0)
            end

            local duration = self:GetSpecialValueFor("freeze_duration")
            if self:GetCaster():HasTalent("special_bonus_unique_kyloren_2") then
                duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_kyloren_2") or 0)
            end

            ApplyDamage( {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = damage,
                damage_type = self:GetAbilityDamageType(),
                ability = self
            } )
            
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_kyloren_freeze", { duration = duration} )
            
            EmitSoundOn( "Kyloren.Freeze", self:GetCaster() )
            EmitSoundOn( "Kyloren.Freeze", hTarget )

            if self:GetCaster():HasScepter() then
                local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, self:GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
                if #units > 0 then
                    for _,  unit in pairs(units) do
                        unit:AddNewModifier(self:GetCaster(), self, "modifier_kyloren_freeze", {duration = duration})

                        EmitSoundOn( "Kyloren.Freeze", unit )

                        ApplyDamage( {
                            victim = unit,
                            attacker = self:GetCaster(),
                            damage = damage,
                            damage_type = self:GetAbilityDamageType(),
                            ability = self
                        })
                    end
                end 
            end
        end
    end
end

if not modifier_kyloren_freeze then modifier_kyloren_freeze = class({}) end 

function modifier_kyloren_freeze:IsDebuff() return true end
function modifier_kyloren_freeze:IsStunDebuff() return true end
function modifier_kyloren_freeze:IsHidden() return true end
function modifier_kyloren_freeze:CheckState() return { [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true} end