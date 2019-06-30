if item_ethereal_boots == nil then item_ethereal_boots = class({}) end
LinkLuaModifier("modifier_item_ethereal_boots", "items/item_ethereal_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ethereal_boots_delay", "items/item_ethereal_boots.lua", LUA_MODIFIER_MOTION_NONE)

function item_ethereal_boots:GetIntrinsicModifierName()
    return "modifier_item_ethereal_boots"
end

function item_ethereal_boots:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        local hCaster = self:GetCaster()

        if IsValidEntity(hTarget) then
            hCaster:AddNewModifier(hCaster, self, "modifier_item_ethereal_boots_delay", {duration = 2, target = hTarget:entindex()})
        else 
            hTarget = self:GetCursorPosition()

            EmitSoundOn("DOTA_Item.BlinkDagger.Activate", hCaster)

            local casterPos = hCaster:GetAbsOrigin()
            local difference = hTarget - casterPos
            local range = self:GetSpecialValueFor("maximum_distance")

            if difference:Length2D() > range then
                hTarget = casterPos + (hTarget - casterPos):Normalized() * range
            end

            ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", PATTACH_ABSORIGIN, hCaster)

            FindClearSpaceForUnit(hCaster, hTarget, false)
            ProjectileManager:ProjectileDodge(hCaster)

            ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_ABSORIGIN, hCaster)

            self:EndCooldown() self:StartCooldown(self:GetSpecialValueFor("blink_cooldown"))

            EmitSoundOn("DOTA_Item.BlinkDagger.Activate", hCaster)
        end 
    end 
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if modifier_item_ethereal_boots == nil then
    modifier_item_ethereal_boots = class ( {})
end

function modifier_item_ethereal_boots:IsHidden()
    return true
end

function modifier_item_ethereal_boots:IsPurgable()
    return true
end

function modifier_item_ethereal_boots:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }

    return funcs
end

function modifier_item_ethereal_boots:GetModifierPreAttack_BonusDamage (params) return self:GetAbility():GetSpecialValueFor ("bonus_damage") end
function modifier_item_ethereal_boots:GetModifierMoveSpeedBonus_Percentage (params) return self:GetAbility():GetSpecialValueFor ("bonus_movement_speed") end
function modifier_item_ethereal_boots:GetModifierBonusStats_Intellect (params) return self:GetAbility():GetSpecialValueFor ("bonus_all_stats") end
function modifier_item_ethereal_boots:GetModifierBonusStats_Agility (params) return self:GetAbility():GetSpecialValueFor ("bonus_all_stats") end
function modifier_item_ethereal_boots:GetModifierBonusStats_Strength (params) return self:GetAbility():GetSpecialValueFor ("bonus_all_stats") end

if not modifier_item_ethereal_boots_delay then modifier_item_ethereal_boots_delay = class({}) end 

function modifier_item_ethereal_boots_delay:IsPurgable()
   return false
end

function modifier_item_ethereal_boots_delay:OnCreated(params)
   if IsServer() then 
        local pfx = ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_end_league.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 1, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 4, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( pfx, 5, Vector(200, 200, 0) )
        ParticleManager:SetParticleControl( pfx, 16, Vector(200, 200, 0) )
        self:AddParticle(pfx, false, false, -1, false, false)

        EmitSoundOn("DOTA_Item.Pipe.Activate", self:GetParent())

        self._bShouldTeleport = true
        self._hTarget = EntIndexToHScript(params.target) if not self._hTarget then self._bShouldTeleport = false self:Destroy() end 
   end 
end

function modifier_item_ethereal_boots_delay:OnDestroy()
   if IsServer() and self._bShouldTeleport then 
        EmitSoundOn("DOTA_Item.BlinkDagger.Activate", self._hTarget) EmitSoundOn("DOTA_Item.BlinkDagger.Activate", self:GetParent())

        self:GetParent():SetAbsOrigin(self._hTarget:GetAbsOrigin())
        FindClearSpaceForUnit(self:GetParent(), self._hTarget:GetAbsOrigin(), true)

        ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_ABSORIGIN, self._hTarget)
   end 
end