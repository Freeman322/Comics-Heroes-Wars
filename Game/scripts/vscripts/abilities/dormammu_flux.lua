dormammu_flux = class({})
LinkLuaModifier( "modifier_dormammu_flux", "abilities/dormammu_flux.lua", LUA_MODIFIER_MOTION_NONE )

function dormammu_flux:OnSpellStart()
	if IsServer() then 
		local info = {
				EffectName = "particles/items4_fx/nullifier_proj.vpcf",
				Ability = self,
				iMoveSpeed = 900,
				Source = self:GetCaster(),
				Target = self:GetCursorTarget(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
			}

		ProjectileManager:CreateTrackingProjectile( info )
		EmitSoundOn( "Hero_ArcWarden.Flux.Cast", self:GetCaster() )
	end
end


function dormammu_flux:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_ArcWarden.Flux.Target", hTarget )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_dormammu_flux", { duration = self:GetSpecialValueFor("duration") } )
	end
	return true
end

if modifier_dormammu_flux == nil then modifier_dormammu_flux = class({}) end 

function modifier_dormammu_flux:GetStatusEffectName()
    return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_dormammu_flux:GetEffectName()
	return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end

function modifier_dormammu_flux:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dormammu_flux:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

    return funcs
end

function modifier_dormammu_flux:GetModifierMoveSpeedBonus_Percentage( event )
    return self:GetAbility():GetSpecialValueFor("damage_per_second") * (-1)
end

function modifier_dormammu_flux:IsHidden()
    return false
end

function modifier_dormammu_flux:IsDebuff()
    return true
end

function modifier_dormammu_flux:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_dormammu_flux:OnCreated(table)
	if IsServer() then 
		self:StartIntervalThink(1)
		self:OnIntervalThink()

		EmitSoundOn( "Hero_ArcWarden.SparkWraith.Activate", self:GetCaster() )
	end
end

function modifier_dormammu_flux:OnDestroy()
	if IsServer() then 
		EmitSoundOn( "Hero_ArcWarden.SparkWraith.Damage", self:GetCaster() )
	end
end

function modifier_dormammu_flux:OnIntervalThink(  )
	if IsServer() then 
		if pcall(function () 
			local damage = self:GetAbility():GetSpecialValueFor("damage_per_second")
			if self:GetCaster():HasTalent("special_bonus_unique_dormammu_5") then 
	            damage = damage + 120
	        end
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}
			ApplyDamage(damage)
		end) then end
	end
end
