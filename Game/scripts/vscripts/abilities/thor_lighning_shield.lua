thor_lighning_shield = class({})

LinkLuaModifier( "modifier_thor_lighning_shield", "abilities/thor_lighning_shield.lua", LUA_MODIFIER_MOTION_NONE )

function thor_lighning_shield:OnSpellStart()
    if IsServer() then 
    	local hTarget = self:GetCursorTarget()
    	if hTarget ~= nil then
            local duration = self:GetSpecialValueFor( "duration" )
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_thor_lighning_shield", { duration = duration } )
            EmitSoundOn( "DOTA_Item.Mjollnir.Activate", hTarget )
    	end
    end
end

modifier_thor_lighning_shield = class({})
function modifier_thor_lighning_shield:IsHidden() return false end
function modifier_thor_lighning_shield:IsDebuff() return false end
function modifier_thor_lighning_shield:IsPurgable() return false end
function modifier_thor_lighning_shield:GetEffectName() return "particles/econ/events/ti6/mjollnir_shield_ti6.vpcf" end
function modifier_thor_lighning_shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_thor_lighning_shield:OnCreated( params )
    if IsServer() then
        StartSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())

        self.damage_return = self:GetAbility():GetSpecialValueFor("damage_return")

        if self:GetCaster():HasTalent("special_bonus_unique_thor") then
            self.damage_return = self.damage_return + self:GetCaster():FindTalentValue("special_bonus_unique_thor")
        end
    end
end

function modifier_thor_lighning_shield:OnDestroy( params )
    if IsServer() then
        EmitSoundOn( "DOTA_Item.Mjollnir.DeActivate", self:GetParent() )
        StopSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())
    end
end


function modifier_thor_lighning_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end


function modifier_thor_lighning_shield:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            if target == self:GetParent() then
                return
            end

            if target:GetClassname() == "ent_dota_fountain" then
        	   return
			end

			ApplyDamage ( {
                victim = target,
                attacker = self:GetParent(),
                damage = params.damage * ( self.damage_return / 100),
                damage_type = params.damage_type,
                ability = self:GetAbility(),
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
            })

        	EmitSoundOn("DOTA_Item.BladeMail.Damage", target)
        end
    end
end


function modifier_thor_lighning_shield:GetModifierPreAttack_BonusDamage(params)
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
