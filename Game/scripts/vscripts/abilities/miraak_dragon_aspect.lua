miraak_dragon_aspect = class({})
LinkLuaModifier( "modifier_miraak_dragon_aspect", "abilities/miraak_dragon_aspect.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function miraak_dragon_aspect:OnAbilityPhaseStart()
    if IsServer() then
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "megumin") then
            EmitSoundOn( "Megumin.Cast2", self:GetCaster() )
        else
            EmitSoundOn("Miraak.DragonAspect.Cast", self:GetCaster())
        end
    end
	return true
end

function miraak_dragon_aspect:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_miraak_dragon_aspect", {duration = self:GetSpecialValueFor("duration")})

        EmitSoundOn( "Hero_Terrorblade.ConjureImage", self:GetCaster() )
    end
end

modifier_miraak_dragon_aspect = class({})

function modifier_miraak_dragon_aspect:GetEffectName() return "particles/miraak/dragon_aspect.vpcf" end
function modifier_miraak_dragon_aspect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_miraak_dragon_aspect:IsPurgable()	return false end
function modifier_miraak_dragon_aspect:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_miraak_dragon_aspect:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() and params.attacker:HasModifier("modifier_miraak_dragon_aspect") == false then
            local target = params.attacker
            local damage = params.damage

            local units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for i, unit in pairs(units) do
                if unit and not unit:IsNull() then
                    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/shadow_shaman/shadow_shaman_ti8/shadow_shaman_ti8_ether_shock.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    EmitSoundOn("Hero_Pugna.NetherWard.Target", unit)

                    ApplyDamage({
                        victim = unit,
                        attacker = self:GetCaster(),
                        damage = damage * (self:GetAbility():GetSpecialValueFor("damage_return") / 100),
                        damage_type = self:GetAbility():GetAbilityDamageType(),
                        ability = self:GetAbility(),
                        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS 
                    })
                end
            end

            if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_miraak_3") then self:GetCaster():Heal(damage, self:GetAbility()) end
        end
    end
end
