bolt_aoe = class({})

function bolt_aoe:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_bolt_arcana") then
		return "custom/bolt_stun_arcana"
	end
	return "custom/bolt_stun"
end

function bolt_aoe:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor(  "dur" )
 
	local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #targets > 0 then
		for _,target in pairs(targets) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
			
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
 
	local nFXIndex = "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp.vpcf"
 
	if self:GetCaster():HasModifier("modifier_bolt_arcana") then
	    nFXIndex = "particles/hero_black_bolt/arcana/black_bolt_stun_arcana.vpcf"
	end
 
	local nFXIndex = ParticleManager:CreateParticle( nFXIndex, PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector(255, 255, 255) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
 
	EmitSoundOn( "chw.bolt_aoe", self:GetCaster() )
 
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_2 );
 end
 
function bolt_aoe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

