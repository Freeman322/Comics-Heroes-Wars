kratos_god_of_war = class({})
LinkLuaModifier( "modifier_kratos_god_of_war", "abilities/kratos_god_of_war.lua", LUA_MODIFIER_MOTION_NONE )

function kratos_god_of_war:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function kratos_god_of_war:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function kratos_god_of_war:GetChannelTime() return self:GetSpecialValueFor("duration") end
function kratos_god_of_war:OnSpellStart() if IsServer() then self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_kratos_god_of_war", {duration = self:GetChannelTime()}) end end
function kratos_god_of_war:OnChannelFinish( bInterrupted ) if IsServer() then self:GetCaster():RemoveModifierByName( "modifier_kratos_god_of_war" ) end end

if modifier_kratos_god_of_war == nil then modifier_kratos_god_of_war = class({}) end

function modifier_kratos_god_of_war:IsDebuff() return false end
function modifier_kratos_god_of_war:IsHidden() return true end
function modifier_kratos_god_of_war:IsPurgable() return false end

function modifier_kratos_god_of_war:OnCreated( kv )
	if IsServer() then
        EmitSoundOn( "Kratos.Block.Cast" , self:GetParent())
	end
end

function modifier_kratos_god_of_war:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_kratos_god_of_war:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}

	return state
end


function modifier_kratos_god_of_war:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_kratos_god_of_war:GetStatusEffectName()
    return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_kratos_god_of_war:StatusEffectPriority()
    return 1000
end

function modifier_kratos_god_of_war:GetEffectName()
    return "particles/hero_kratos/god_of_war_buff.vpcf"
end

function modifier_kratos_god_of_war:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_kratos_god_of_war:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("damage_reduction") * (-1)
end

function modifier_kratos_god_of_war:OnTakeDamage(params)
    if IsServer() then 
        if params.unit == self:GetParent() then
			local target = params.attacker

            ----fixed crash. Valve cant chech for nullptr after damage is dealt, so we should do that.
            if target and not target:IsNull() and target:IsAlive() then
                if target == self:GetParent() then return end
                if target:GetClassname() == "ent_dota_fountain" then return end
                
                EmitSoundOn("Kratos.GOW.Damage", target)      

                local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
                ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex( nFXIndex );  
                
                ApplyDamage ( {
                    victim = target,
                    attacker = self:GetParent(),
                    damage = params.original_damage,
                    damage_type = params.damage_type,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
                })
            end
		end
	end
end

