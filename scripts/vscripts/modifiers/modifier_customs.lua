if modifier_pugalo == nil then modifier_pugalo = class({}) end
function modifier_pugalo:IsHidden() return true end
function modifier_pugalo:IsPurgable() return false end
function modifier_pugalo:RemoveOnDeath() return false end

-------------------------------------------------------------------------------

if modifier_deadshot == nil then modifier_deadshot = class({}) end
function modifier_deadshot:IsHidden() return true end
function modifier_deadshot:IsPurgable() return false end
function modifier_deadshot:RemoveOnDeath() return false end


if modifier_sephiroth == nil then modifier_sephiroth = class({}) end
function modifier_sephiroth:IsHidden() return true end
function modifier_sephiroth:IsPurgable() return false end
function modifier_sephiroth:RemoveOnDeath() return false end
function modifier_sephiroth:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_sephiroth:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local nFXIndex = ParticleManager:CreateParticle( "particles/items4_fx/nullifier_proj_impact.vpcf", PATTACH_CUSTOMORIGIN, params.target )
            ParticleManager:SetParticleControl( nFXIndex, 0, params.target:GetOrigin() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )      
        end
    end

    return 0
end

function modifier_sephiroth:OnCreated(params)
    if IsServer() then 
        self.item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_deadpool/econs/sephiroth_custom/econs/wing.vmdl"})
        self.item:FollowEntity(self:GetParent(), true)
        self.item:AddEffects(EF_NODRAW)

        self:StartIntervalThink(0.1)
    end 
end

function modifier_sephiroth:OnIntervalThink()
    if IsServer() then 
        if self:GetParent():HasModifier("modifier_life_stealer_rage") then 
            if self.item then self.item:RemoveEffects(EF_NODRAW) end else 
            if self.item then self.item:AddEffects(EF_NODRAW) end 
        end
    end 
end

if modifier_ozaruu == nil then modifier_ozaruu = class({}) end
function modifier_ozaruu:IsHidden() return true end
function modifier_ozaruu:IsPurgable() return false end
function modifier_ozaruu:RemoveOnDeath() return false end


if modifier_mera == nil then modifier_mera = class({}) end 
function modifier_mera:IsHidden() return true end
function modifier_mera:IsPurgable() return false end
function modifier_mera:RemoveOnDeath() return false end

if modifier_beerus == nil then modifier_beerus = class({}) end 
function modifier_beerus:IsHidden() return true end
function modifier_beerus:IsPurgable() return false end
function modifier_beerus:RemoveOnDeath() return false end

