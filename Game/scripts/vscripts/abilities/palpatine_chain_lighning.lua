palpatine_chain_lighning = class({})
LinkLuaModifier( "modifier_palpatine_chain_lighning", "abilities/palpatine_chain_lighning.lua", LUA_MODIFIER_MOTION_NONE )

function palpatine_chain_lighning:GetIntrinsicModifierName() return "modifier_palpatine_chain_lighning" end

if modifier_palpatine_chain_lighning == nil then modifier_palpatine_chain_lighning = class({}) end

function modifier_palpatine_chain_lighning:IsHidden() return true end
function modifier_palpatine_chain_lighning:IsPurgable() return false end
function modifier_palpatine_chain_lighning:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_palpatine_chain_lighning:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then       
            if not self:GetParent():IsRealHero() then return end
            if params.target:IsBuilding() then return end 

            if RollPercentage(self:GetAbility():GetSpecialValueFor("trg_chance")) then 
                local units = FindUnitsInRadius(self:GetParent():GetTeam(), params.target:GetAbsOrigin(), params.target, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

                local damage = self:GetAbility():GetSpecialValueFor("damage")

                if self:GetCaster():HasTalent("special_bonus_unique_palpatine_1") then
                    damage = self:GetCaster():FindTalentValue("special_bonus_unique_palpatine_1") + damage
                end

                local jumps = self:GetAbility():GetSpecialValueFor("jumps")
                
                for i, target in pairs(units) do
                    ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
                    
                    if target and not target:IsNull() and units[i + 1] then 
                        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc.vpcf", PATTACH_CUSTOMORIGIN, target );
                        ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                        ParticleManager:SetParticleControlEnt( nFXIndex, 1, units[i + 1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i + 1]:GetOrigin(), true );
                        ParticleManager:ReleaseParticleIndex( nFXIndex );

                        EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", target)
                        EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", units[i + 1])
            
                        if not self:GetCaster():HasTalent("special_bonus_unique_palpatine_2") then jumps = jumps - 1 end

                        if jumps <= 0 then break end 
                    end 
                end
            end 
        end
    end
    return 0
end

