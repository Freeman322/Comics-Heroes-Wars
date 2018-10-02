odin_gods_mark = class({})

LinkLuaModifier( "modifier_odin_gods_mark",   "abilities/odin_gods_mark.lua", LUA_MODIFIER_MOTION_NONE)

function odin_gods_mark:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end


function odin_gods_mark:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function odin_gods_mark:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_Omniknight.Purification", hCaster )
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )
    local heroes = HeroList:GetAllHeroes()
    for i, hero in pairs(heroes) do
        if hero:HasModifier( "modifier_odin_gods_mark" ) then
            hero:FindModifierByName( "modifier_odin_gods_mark" ):Destroy()
        end
    end

    hTarget:AddNewModifier( hCaster, self, "modifier_odin_gods_mark", nil)
end

modifier_odin_gods_mark = class({})

function modifier_odin_gods_mark:GetEffectName(  )
    return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end

function modifier_odin_gods_mark:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_odin_gods_mark:IsPurgable()
    return false
end

function modifier_odin_gods_mark:OnCreated(htable)
    if IsServer() then
    	self:StartIntervalThink(1)
    	self.stats = (self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )/100)
    	if self:GetCaster():HasTalent("special_bonus_unique_odin") then
	        self.stats = (self:GetCaster():FindTalentValue("special_bonus_unique_odin") + self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ))/100
		end
    end
end

function modifier_odin_gods_mark:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsAlive() == false then
			self:Destroy()
		end
	end
end

function modifier_odin_gods_mark:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}

	return funcs
end

function modifier_odin_gods_mark:GetModifierBonusStats_Strength (params)
    local caster = self:GetAbility ():GetCaster()
    return caster:GetStrength()*self.stats
end

function modifier_odin_gods_mark:GetModifierBonusStats_Intellect (params)
    local caster = self:GetAbility ():GetCaster()
    return caster:GetIntellect()*self.stats
end
function modifier_odin_gods_mark:GetModifierBonusStats_Agility (params)
    local caster = self:GetAbility ():GetCaster()
    return caster:GetAgility()*self.stats
end

function modifier_odin_gods_mark:GetModifierPhysicalArmorBonus( params )
	local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_odin_gods_mark:GetModifierMagicalResistanceBonus( params )
	local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_magical_armor")
end

function odin_gods_mark:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

