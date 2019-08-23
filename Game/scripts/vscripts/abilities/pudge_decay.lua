LinkLuaModifier( "modifier_pudge_decay", "abilities/pudge_decay.lua", LUA_MODIFIER_MOTION_NONE )

pudge_decay = class({})

function pudge_decay:ProcsMagicStick() return false end


function pudge_decay:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_decay", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
		end
	else
		if self:GetCaster():FindModifierByName( "modifier_pudge_decay" )~=nil then
			self:GetCaster():FindModifierByName( "modifier_pudge_decay" ):Destroy()
		end
	end
end

modifier_pudge_decay = class({})

function modifier_pudge_decay:IsDebuff() return true end
function modifier_pudge_decay:IsPurgable() return false end
function modifier_pudge_decay:IsAura() if self:GetCaster() == self:GetParent() then return true end return false end
function modifier_pudge_decay:GetModifierAura()	return "modifier_pudge_decay" end
function modifier_pudge_decay:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_pudge_decay:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_pudge_decay:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("decay_radius") end


function modifier_pudge_decay:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("decay_tick"))

		local particle = "particles/units/heroes/hero_pudge/pudge_rot.vpcf"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "champion_of_nurgle") == true then particle = "particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_rot.vpcf" end

		if self:GetParent() == self:GetCaster() then
			EmitSoundOn( "Hero_Pudge.Rot", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self:GetAbility():GetSpecialValueFor("decay_radius"), 1, self:GetAbility():GetSpecialValueFor("decay_radius")))
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		end
	end
end


function modifier_pudge_decay:OnDestroy() if IsServer() then StopSoundOn("Hero_Pudge.Rot", self:GetCaster()) end end
function modifier_pudge_decay:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end

function modifier_pudge_decay:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent() == self:GetCaster() then return 0 end
	return self:GetAbility():GetSpecialValueFor("decay_slow")
end


function modifier_pudge_decay:OnIntervalThink()
	if IsServer() then
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self:GetAbility():GetSpecialValueFor("damage") / 2,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			})
	end
end
