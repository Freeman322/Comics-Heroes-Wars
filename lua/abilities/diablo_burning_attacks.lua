if diablo_burning_attacks == nil then diablo_burning_attacks = class({}) end
LinkLuaModifier( "modifier_diablo_burning_attacks",	"abilities/diablo_burning_attacks.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diablo_burning_target",	"abilities/diablo_burning_attacks.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function diablo_burning_attacks:ProcsMagicStick()
	return false
end

function diablo_burning_attacks:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_diablo_burning_attacks", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
		end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_diablo_burning_attacks" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

if modifier_diablo_burning_attacks == nil then
    modifier_diablo_burning_attacks = class ( {})
end


function modifier_diablo_burning_attacks:IsHidden ()
    return true
end


function modifier_diablo_burning_attacks:RemoveOnDeath ()
    return true
end


function modifier_diablo_burning_attacks:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_diablo_burning_attacks:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
           if self:GetAbility():IsCooldownReady() then
                if not params.target:IsBuilding() and not params.target:IsAncient() then
    	           params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_diablo_burning_target", {duration = self:GetAbility():GetSpecialValueFor("burn_duration")})
    	           params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})
    	           self:GetAbility():PayManaCost()
    	           self:GetAbility():StartCooldown(2)
    	           EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
    	           EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)
               end
	       end
        end
    end

    return 0
end
if modifier_diablo_burning_target == nil then modifier_diablo_burning_target = class ( {}) end

function modifier_diablo_burning_target:GetEffectName ()
    return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_diablo_burning_target:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_diablo_burning_target:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
				if thinker:IsBuilding() or thinker:IsAncient() then
					self:Destroy()
				end
        EmitSoundOn("Hero_DoomBringer.InfernalBlade.Target", thinker)
        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = (self:GetAbility():GetSpecialValueFor("burn_damage_pct")/100)*self:GetParent():GetMaxHealth()+self:GetAbility():GetSpecialValueFor("burn_damage"), damage_type = self:GetAbility():GetAbilityDamageType()})
        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function modifier_diablo_burning_target:OnIntervalThink ()
    if IsServer() then
        local thinker = self:GetParent()
        ApplyDamage ( { attacker = self:GetAbility ():GetCaster (), victim = thinker, ability = self:GetAbility (), damage = (self:GetAbility():GetSpecialValueFor("burn_damage_pct")/100)*self:GetParent():GetMaxHealth()+self:GetAbility():GetSpecialValueFor("burn_damage"), damage_type = self:GetAbility():GetAbilityDamageType()})
    end
end

function diablo_burning_attacks:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

