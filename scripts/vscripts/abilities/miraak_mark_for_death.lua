miraak_mark_for_death = class({})
LinkLuaModifier( "modifier_miraak_mark_for_death", "abilities/miraak_mark_for_death.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function miraak_mark_for_death:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end


function miraak_mark_for_death:OnAbilityPhaseStart()
    if IsServer() then 
        if not Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "megumin") then
            EmitSoundOn("Miraak.MarkForDeath.Cast", self:GetCaster())
        end
    end 
	return true
end

function miraak_mark_for_death:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_miraak_mark_for_death", {duration = self:GetSpecialValueFor("duration")})
                     
            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "megumin") then
                EmitSoundOn( "Megumin.Cast1", self:GetCaster() )
            else
                EmitSoundOn( "Hero_Terrorblade.Reflection", self:GetCaster() )
            end 
        end
    end
end

if not modifier_miraak_mark_for_death then modifier_miraak_mark_for_death = class({}) end 

function modifier_miraak_mark_for_death:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_debuff_energy.vpcf"
end

function modifier_miraak_mark_for_death:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_miraak_mark_for_death:IsPurgable()
	return false
end

function modifier_miraak_mark_for_death:OnCreated(params)
    if IsServer() then 
        local tick = self:GetAbility():GetSpecialValueFor("tick_interval") if self:GetCaster():HasTalent("special_bonus_unique_miraak_2") then tick = tick - self:GetCaster():FindTalentValue("special_bonus_unique_miraak_2") end 
        
        self:StartIntervalThink(tick)
    end 
end

function modifier_miraak_mark_for_death:OnIntervalThink()
    if IsServer() then 
        local radius = self:GetAbility():GetSpecialValueFor( "radius" ) 

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _, target in pairs(units) do
                if self:GetCaster():HasTalent("special_bonus_unique_miraak_4") then
                    self:GetParent():ReduceMana(self:GetAbility():GetSpecialValueFor("damage") + self:GetParent():GetMaxMana() / 50 )
                end
                local damage = {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = self:GetAbility():GetSpecialValueFor("damage"),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                ApplyDamage( damage )
            end
        end
    end 
end

