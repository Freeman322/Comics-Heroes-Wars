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

if modifier_heart_timegem == nil then modifier_heart_timegem = class({}) end 
function modifier_heart_timegem:IsHidden() return true end
function modifier_heart_timegem:IsPurgable() return false end
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


if modifier_scarlett == nil then modifier_scarlett = class({}) end 
function modifier_scarlett:IsHidden() return true end
function modifier_scarlett:IsPurgable() return false end
function modifier_scarlett:RemoveOnDeath() return false end


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

if modifier_strange_artifact == nil then modifier_strange_artifact = class({}) end

function modifier_strange_artifact:IsHidden() return true end
function modifier_strange_artifact:IsPurgable() return false end
function modifier_strange_artifact:RemoveOnDeath() return false end
function modifier_strange_artifact:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
    return funcs
end
        
function modifier_strange_artifact:GetAttackSound( params )
    return "Hero_VoidSpirit.Pulse.Target"
end

if modifier_deep_murloc == nil then modifier_deep_murloc = class({}) end

function modifier_deep_murloc:IsHidden() return true end
function modifier_deep_murloc:IsPurgable() return false end
function modifier_deep_murloc:RemoveOnDeath() return false end
function modifier_deep_murloc:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
    return funcs
end
        
function modifier_deep_murloc:GetAttackSound( params )
    return "Deep_Murloc.Attack"
end

if modifier_lovuska_jokera == nil then modifier_lovuska_jokera = class({}) end

function modifier_lovuska_jokera:IsHidden() return true end
function modifier_lovuska_jokera:IsPurgable() return false end
function modifier_lovuska_jokera:RemoveOnDeath() return false end
function modifier_lovuska_jokera:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }

    return funcs
end

function modifier_lovuska_jokera:GetAttackSound( params )
    return "Hero_Juggernaut.Attack"
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


if modifier_goku == nil then modifier_goku = class({}) end

function modifier_goku:IsHidden() return true end
function modifier_goku:IsPurgable() return false end
function modifier_goku:RemoveOnDeath() return false end

if modifier_io == nil then modifier_io = class({}) end
function modifier_io:IsHidden() return true end
function modifier_io:IsPurgable() return false end
function modifier_io:RemoveOnDeath() return false end

function modifier_io:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}

	return funcs
end

function modifier_io:GetEffectName()
    return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_io:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_io:GetVisualZDelta( params )
    return 97
end

if modifier_dark_emblem == nil then modifier_dark_emblem = class({}) end
function modifier_dark_emblem:IsHidden() return true end
function modifier_dark_emblem:IsPurgable() return false end
function modifier_dark_emblem:RemoveOnDeath() return false end
function modifier_dark_emblem:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_EXP_RATE_BOOST
    }

    return funcs
end
function modifier_dark_emblem:GetEffectName()
    return "particles/econ/events/ti7/fountain_regen_ti7_lvl3.vpcf"
end
function modifier_dark_emblem:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_dark_emblem:GetModifierPercentageCooldown( params )
    if IsServer() then
        return 2
    end
end

function modifier_dark_emblem:GetModifierConstantHealthRegen( params )
    if IsServer() then
        return 5
    end
end

function modifier_dark_emblem:GetModifierPercentageExpRateBoost( params )
    if IsServer() then
        return 50
    end
end

if modifier_rat == nil then modifier_rat = class({}) end

function modifier_rat:IsHidden() return true end
function modifier_rat:IsPurgable() return false end
function modifier_rat:RemoveOnDeath() return false end

if modifier_izanagi == nil then modifier_izanagi = class({}) end

function modifier_izanagi:IsHidden() return true end
function modifier_izanagi:IsPurgable() return false end
function modifier_izanagi:RemoveOnDeath() return false end
