if blac_adam_arc_lightning == nil then
    blac_adam_arc_lightning = class({})
end

LinkLuaModifier( "blac_adam_arc_lightning_modifier", "abilities/blac_adam_arc_lightning.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "blac_adam_arc_lightning_protect", "abilities/blac_adam_arc_lightning.lua", LUA_MODIFIER_MOTION_NONE )

function blac_adam_arc_lightning:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    return behav
end
function blac_adam_arc_lightning:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 10
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end
function blac_adam_arc_lightning:OnSpellStart()
    self.JumpDelay = self:GetSpecialValueFor("jump_delay")
    self.JumpCount = self:GetSpecialValueFor("jump_count")
    self.JumpRadius = self:GetSpecialValueFor("radius")
    self.iMDamage = self:GetSpecialValueFor( "magic_damage" )
    self.JumpDamage = self:GetSpecialValueFor( "damage" )
    self.JumpDmgType = self:GetAbilityDamageType()
    self.InsProtect = self.JumpCount --We use this so the chain lightning can't circle back.

    local hCaster = self:GetCaster()
    local hTarget = false
    if not self:GetCursorTargetingNothing() then
        hTarget = self:GetCursorTarget()
    end
    if hTarget then
        --hTarget:TriggerSpellReflect( self )
        local absorb = hTarget:TriggerSpellAbsorb( self )
        if not absorb then
            local nFXIndex = ParticleManager:CreateParticle( self.Effect, PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetOrigin() + Vector( 0, 0, 50 ), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );
            --EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), self.SoundA, self:GetCaster() )
            EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_Zuus.ArcLightning.Cast", self:GetCaster() )
            hTarget:AddNewModifier( self:GetCaster(), self, self.MainMod, {
                duration = self.JumpDelay
                ,jumps = self.JumpCount
                ,radius = self.JumpRadius
                ,dmg = self.JumpDamage
                ,mdmg = self.iMDamage
                ,dmgtype = self.JumpDmgType
                ,instance = GameRules:GetGameTime()
            } )
        else
            print("absorb")
            print(absorb)
        end
    end
end

function blac_adam_arc_lightning:OnUpgrade()
    self.Sound = "Hero_Zuus.ArcLightning.Cast"
    self.Effect = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
    self.MainMod = "blac_adam_arc_lightning_modifier"
    self.ProtectMod = "blac_adam_arc_lightning_protect"
end
if blac_adam_arc_lightning_modifier == nil then
    blac_adam_arc_lightning_modifier = class({})
end

function blac_adam_arc_lightning_modifier:OnCreated( kv )
    if IsServer() then
        self.jumps = kv.jumps - 1
        self.radius = kv.radius
        self.dmg = kv.dmg + self:GetAbility():GetSpecialValueFor("bonus_damage_per_jump")
        self.mdmg = kv.mdmg
        self.dmgtype = kv.dmgtype
        self.instance = kv.instance
    end
end

function blac_adam_arc_lightning_modifier:IsHidden()
    return true
end


function blac_adam_arc_lightning_modifier:OnDestroy()
    if IsServer() then
        local hAbility = self:GetAbility()
        if self.jumps > 0 then
            self:GetParent():AddNewModifier( self:GetCaster(), hAbility, hAbility.ProtectMod, { duration = hAbility.InsProtect , instance = self.instance })
            EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Zuus.ArcLightning.Target", self:GetCaster() )
            local hCaster = self:GetCaster()
            local nFlag = hAbility:GetAbilityTargetFlags() or DOTA_UNIT_TARGET_FLAG_NONE
            local nTeam = hAbility:GetAbilityTargetTeam() or DOTA_UNIT_TARGET_TEAM_BOTH
            local nType = hAbility:GetAbilityTargetType() or DOTA_UNIT_TARGET_ALL
            local tTargets = FindUnitsInRadius(hCaster:GetTeam(),
                self:GetParent():GetOrigin(),
                self:GetParent(),
                self.radius,
                nTeam,
                nType,
                nFlag,
                FIND_CLOSEST,
                false
            )
            if #tTargets > 0 then
                for _,hTarget in pairs(tTargets) do
                    if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) and hTarget ~= self:GetParent() then
                        if not self:HasProtection(hTarget) then
                            local nFXIndex = ParticleManager:CreateParticle( hAbility.Effect, PATTACH_CUSTOMORIGIN, nil );
                            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
                            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                            ParticleManager:ReleaseParticleIndex( nFXIndex );
                            hTarget:AddNewModifier( self:GetCaster(), hAbility, hAbility.MainMod, {
                                duration = hAbility.JumpDelay
                                ,jumps = self.jumps
                                ,radius = self.radius
                                ,dmg = self.dmg
                                ,mdmg = self.mdmg
                                ,dmgtype = self.dmgtype
                                ,instance = self.instance
                            } )
                            break
                        end
                    end
                end
            else
                self.dmg = nil
                end
        end
        self:DamageParent()
    end
end

function blac_adam_arc_lightning_modifier:DamageParent()
    if IsServer() then
        local armor = self:GetParent():GetPhysicalArmorValue()
        if armor < 1 then armor = 1 end
        local damage = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.dmg * armor + self.mdmg ,
            damage_type = self.dmgtype,
            ability = self:GetAbility()
        }
        local dmg = ApplyDamage( damage )
        local life_time = 2.0
        local digits = string.len( math.floor( dmg ) ) + 1
        local numParticle = ParticleManager:CreateParticle( "particles/msg_fx/msg_crit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( numParticle, 1, Vector( 0, dmg, 4 ) )
        ParticleManager:SetParticleControl( numParticle, 2, Vector( life_time, digits, 0 ) )
        ParticleManager:SetParticleControl( numParticle, 3, Vector( 0, 150, 255 ) )

    end
end

function blac_adam_arc_lightning_modifier:HasProtection(hTarget)
    if IsServer() then
        local hAbility = self:GetAbility()
        if hTarget:HasModifier(hAbility.ProtectMod) then
            local tMods = hTarget:FindAllModifiersByName(hAbility.ProtectMod)
            if tMods then
                for k, v in pairs(tMods) do
                    if v.instance == self.instance then
                        return true
                    end
                end
            end
        end
        return false
    end
end

function blac_adam_arc_lightning_modifier:IsPurgable()
    return false
end

function blac_adam_arc_lightning_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
if blac_adam_arc_lightning_protect == nil then
    blac_adam_arc_lightning_protect = class({})
end

function blac_adam_arc_lightning_protect:OnCreated( kv )
    if IsServer() then
        self.instance = kv.instance
    end
end

function blac_adam_arc_lightning_protect:IsHidden()
    return true
end

function blac_adam_arc_lightning_protect:IsPurgable()
    return false
end

function blac_adam_arc_lightning_protect:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function blac_adam_arc_lightning:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

