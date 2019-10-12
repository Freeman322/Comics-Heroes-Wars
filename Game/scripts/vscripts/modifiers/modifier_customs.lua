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

if modifier_neo_noir_khan == nil then modifier_neo_noir_khan = class({}) end

function modifier_neo_noir_khan:IsHidden() return true end
function modifier_neo_noir_khan:IsPurgable() return false end
function modifier_neo_noir_khan:RemoveOnDeath() return false end
function modifier_neo_noir_khan:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end

function modifier_neo_noir_khan:GetAttackSound( params )
    return "Hero_Juggernaut.Attack"
end

function modifier_neo_noir_khan:GetModifierAttackRangeBonus( params )
    return
end

function modifier_neo_noir_khan:GetModifierModelScale( params )
    return 100
end

if modifier_custom_unique == nil then modifier_custom_unique = class({}) end 
function modifier_custom_unique:IsHidden() return true end
function modifier_custom_unique:IsPurgable() return false end
function modifier_custom_unique:RemoveOnDeath() return false end


if modifier_sargeras_s7_custom == nil then modifier_sargeras_s7_custom = class({}) end

function modifier_sargeras_s7_custom:IsHidden() return true end
function modifier_sargeras_s7_custom:IsPurgable() return false end
function modifier_sargeras_s7_custom:RemoveOnDeath() return false end
function modifier_sargeras_s7_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_sargeras_s7_custom:GetAttackSound( params )
    return "Sargeras.WD.Attack"
end

if modifier_raiden_skin == nil then modifier_raiden_skin = class({}) end
function modifier_raiden_skin:IsHidden() return true end
function modifier_raiden_skin:IsPurgable() return false end
function modifier_raiden_skin:RemoveOnDeath() return false end

if modifier_nike == nil then modifier_nike = class({}) end
function modifier_nike:IsHidden() return true end
function modifier_nike:IsPurgable() return false end
function modifier_nike:RemoveOnDeath() return false end

if modifier_officer == nil then modifier_officer = class({}) end

function modifier_officer:IsHidden() return true end
function modifier_officer:IsPurgable() return false end
function modifier_officer:RemoveOnDeath() return false end
function modifier_officer:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_officer:GetAttackSound( params )
    return "Hero_Tinker.Laser"
end

if modifier_android == nil then modifier_android = class({}) end

function modifier_android:IsHidden() return true end
function modifier_android:IsPurgable() return false end
function modifier_android:RemoveOnDeath() return false end
function modifier_android:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }

    return funcs
end

function modifier_android:GetAttackSound( params )
    return "Hero_Juggernaut.Attack"
end

function modifier_android:OnCreated(params)
    if IsServer() then 
        self.sword = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_qucksilver/econs/qucksilver_skin/sword.vmdl"})
        self.sword:FollowEntity(self:GetParent(), true)

        self.umbrella = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_qucksilver/econs/qucksilver_skin/umbrella/umbrella.vmdl"})
        self.umbrella:FollowEntity(self:GetParent(), true)
        
        self:OnIntervalThink()
        self:StartIntervalThink(0.33)
    end 
end

function modifier_android:OnIntervalThink()
    if IsServer() then 
        local bool = self:GetParent():HasModifier("modifier_quicsilver_abstract_run_aura")

        SetObjectHidden(self.sword, bool)
        SetObjectHidden(self.umbrella, not bool)
    end 
end

function modifier_android:GetActivityTranslationModifiers( params )
	if self:GetParent():HasModifier("modifier_quicsilver_abstract_run_aura") then
		return "umbrella"
	end

	return 0
end


if modifier_octavia == nil then modifier_octavia = class({}) end

function modifier_octavia:IsHidden() return true end
function modifier_octavia:IsPurgable() return false end
function modifier_octavia:RemoveOnDeath() return false end
function modifier_octavia:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_octavia:GetAttackSound( params )
    return "Hero_Juggernaut.Attack"
end

if modifier_freeza == nil then modifier_freeza = class({}) end

function modifier_freeza:IsHidden() return true end
function modifier_freeza:IsPurgable() return false end
function modifier_freeza:RemoveOnDeath() return false end


if modifier_uganda == nil then modifier_uganda = class({}) end

function modifier_uganda:IsHidden() return true end
function modifier_uganda:IsPurgable() return false end
function modifier_uganda:RemoveOnDeath() return false end
