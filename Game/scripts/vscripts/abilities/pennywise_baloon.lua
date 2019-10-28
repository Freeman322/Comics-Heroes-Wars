pennywise_baloon = class({})

LinkLuaModifier( "modifier_pennywise_baloon", "abilities/pennywise_baloon.lua", LUA_MODIFIER_MOTION_NONE )

function pennywise_baloon:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end 
end

function pennywise_baloon:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor( "baloon_duration" )
        local loc = self:GetCaster():GetCursorPosition()

        PrecacheUnitByNameAsync("pennywise_baloon_creature", function()
            local unit = CreateUnitByName( "pennywise_baloon_creature", loc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
           
            unit:AddNewModifier(unit, self, "modifier_pennywise_baloon", {duration = duration})
            unit:AddNewModifier(unit, self, "modifier_kill", {duration = duration})

            FindClearSpaceForUnit(unit, loc, true)
        end)

        EmitSoundOn( "Visage_Familar.StoneForm.Cast.Tolling", self:GetCaster() )
    end
end

function pennywise_baloon:OnProjectileHit(hTarget, vLocation)
    if IsServer() then
        if hTarget and not hTarget:IsNull() and not hTarget:IsAncient() then
            EmitSoundOn("Item_Desolator.Target", hTarget)

            if self:GetCaster():HasTalent("special_bonus_unique_pennywise_2") then 
                self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true) return
            end

            self:GetCaster():PerformAttack(hTarget, true, false, true, true, false, false, true)
        end
    end
end


if modifier_pennywise_baloon == nil then modifier_pennywise_baloon = class({}) end


function modifier_pennywise_baloon:IsHidden() return true end
function modifier_pennywise_baloon:IsPurgable()  return false end


function modifier_pennywise_baloon:OnCreated(params)
    if IsServer() then
        if self:GetAbility():GetCaster():HasScepter() then -----if self:GetCaster():HasScepter() then ГЕЙБ!!! Хули не работает???
            self:OnIntervalThink()

            self:StartIntervalThink(1) 
        end
    end 
end

function modifier_pennywise_baloon:OnIntervalThink()
    if IsServer() then
        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("baloon_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.05 } )

                self:Attack(unit)
            end
        end
    end 
end

function modifier_pennywise_baloon:Attack(target)
    if IsServer() then
        local info = 
        {
            Target = target,
            Source = self:GetCaster(),
            Ability = self:GetAbility(),	
            EffectName = "particles/world_tower/tower_upgrade/ti7_dire_tower_projectile.vpcf",
            iMoveSpeed = 1400,
            vSourceLoc= self:GetCaster():GetAbsOrigin(),                -- Optional (HOW)
            bDrawsOnMinimap = false,                          -- Optional
            bDodgeable = true,                                -- Optional
            bIsAttack = false,                                -- Optional
            bVisibleToEnemies = true,                         -- Optional
            bReplaceExisting = false,                         -- Optional
            flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
            bProvidesVision = true,                           -- Optional
            iVisionRadius = 400,                              -- Optional
            iVisionTeamNumber = self:GetCaster():GetTeamNumber()        -- Optional
        }

        ProjectileManager:CreateTrackingProjectile(info)
    end
end
