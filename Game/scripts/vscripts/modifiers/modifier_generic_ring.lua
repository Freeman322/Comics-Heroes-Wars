modifier_generic_ring = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_ring:IsHidden() return true end
function modifier_generic_ring:IsDebuff() return false end
function modifier_generic_ring:IsStunDebuff() return false end
function modifier_generic_ring:IsPurgable()return false end
function modifier_generic_ring:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_generic_ring:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.start_radius = kv.start_radius or 0
	self.end_radius = kv.end_radius or 0
	self.width = kv.width or 100
	self.speed = kv.speed or 0

	self.target_team = kv.target_team or 0
	self.target_type = kv.target_type or 0
	self.target_flags = kv.target_flags or 0

	self.targets = {}
end


function modifier_generic_ring:SetCallback( callback )
	self.Callback = callback

	-- Start interval
	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()
end

function modifier_generic_ring:OnIntervalThink()
	local radius = self.start_radius + self.speed * self:GetElapsedTime()
	if radius>self.end_radius then
		self:Destroy()
		return
	end

	-- Find targets in ring
	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.target_team,	-- int, team filter
		self.target_type,	-- int, type filter
		self.target_flags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,target in pairs(targets) do
		-- only check for targets that have not been hit, and within width
		if not self.targets[target] and (target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()>(radius-self.width) then
			self.targets[target] = true

			-- do something
			self.Callback( target )
		end
	end
end