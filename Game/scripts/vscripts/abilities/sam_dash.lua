LinkLuaModifier("modifier_sam_dash", "abilities/sam_dash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_charges", "modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sam_dash_dash", "abilities/sam_dash.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

sam_dash = class({})

if IsServer() then
  function sam_dash:OnUpgrade()
    if not self:GetCaster():HasModifier("modifier_charges") then
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_charges", nil)
    end
  end

  function sam_dash:OnSpellStart()
    local caster = self:GetCaster()
    local distance = self:GetSpecialValueFor("dash_distance")
    local speed = self:GetSpecialValueFor( "dash_speed" )
    local treeRadius = self:GetSpecialValueFor( "tree_radius" )
    local duration = distance / speed

    caster:RemoveModifierByName( "modifier_sam_dash_dash" )
    caster:StartGesture( ACT_DOTA_RUN )
    caster:AddNewModifier( nil, nil, "modifier_sam_dash_dash", {
      duration = duration,
      distance = distance,
      tree_radius = treeRadius,
      speed = speed
    } )
    if self:GetCaster():HasTalent("special_bonus_unique_sam_dash_projectile") then
      ProjectileManager:ProjectileDodge(self:GetCaster())
    end
  end
end

modifier_sam_dash_dash = class({})

function modifier_sam_dash_dash:IsDebuff() return false end
function modifier_sam_dash_dash:IsHidden() return true end
function modifier_sam_dash_dash:IsPurgable() return false end
function modifier_sam_dash_dash:GetPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end

function modifier_sam_dash_dash:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

if IsServer() then
	function modifier_sam_dash_dash:OnCreated(event)
		local parent = self:GetParent()
		self.direction = self:GetParent():GetForwardVector()
		self.distance = event.distance
		self.speed = event.speed
		self.tree_radius = event.tree_radius

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end

		local trail_pfx = ParticleManager:CreateParticle( "particles/sam/sam_dash.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(trail_pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(trail_pfx, 1, self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 300)
		ParticleManager:ReleaseParticleIndex(trail_pfx)
	end

	function modifier_sam_dash_dash:OnDestroy()
		self:GetParent():FadeGesture( ACT_DOTA_RUN )
		self:GetParent():RemoveHorizontalMotionController( self )
		ResolveNPCPositions( self:GetParent():GetAbsOrigin(), 128 )
	end

	function modifier_sam_dash_dash:UpdateHorizontalMotion( parent, deltaTime )
		local parentOrigin = parent:GetAbsOrigin()
		local tickSpeed = self.speed * deltaTime
		tickSpeed = math.min( tickSpeed, self.distance )
		local tickOrigin = parentOrigin + ( tickSpeed * self.direction )
		parent:SetAbsOrigin( tickOrigin )
		self.distance = self.distance - tickSpeed
		GridNav:DestroyTreesAroundPoint( tickOrigin, self.tree_radius, false )
	end

	function modifier_sam_dash_dash:OnHorizontalMotionInterrupted()
		self:Destroy()
	end
end
