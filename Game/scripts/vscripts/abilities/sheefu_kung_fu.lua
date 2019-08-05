if not sheefu_kung_fu then sheefu_kung_fu = class({}) end
LinkLuaModifier( "modifier_sheefu_kung_fu", "abilities/sheefu_kung_fu.lua", LUA_MODIFIER_MOTION_NONE )

function sheefu_kung_fu:GetIntrinsicModifierName() return "modifier_sheefu_kung_fu" end

modifier_sheefu_kung_fu = class({})
function modifier_sheefu_kung_fu:IsHidden() return true end
function modifier_sheefu_kung_fu:IsPurgable() return false end
function modifier_sheefu_kung_fu:RemoveOnDeath() return false end
function modifier_sheefu_kung_fu:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_sheefu_kung_fu:OnAttackLanded (params)
     if IsServer() then
          if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and params.attacker:IsRealHero() and not params.attacker:PassivesDisabled() and not params.attacker:IsSilenced() then
               if params.target:IsHero() and RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then
                    local damage = self:GetCaster():GetAverageTrueAttackDamage(params.target) * (self:GetAbility():GetSpecialValueFor("damage_proc_pct") / 100)

                    params.target:ModifyHealth(params.target:GetHealth() - damage, self:GetAbility(), true, 0)

                    EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", params.target)

                    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/frostivus/frostivus_tree_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
                    ParticleManager:SetParticleControl( nFXIndex, 0, params.target:GetOrigin() );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );
               end
          end
     end
end
