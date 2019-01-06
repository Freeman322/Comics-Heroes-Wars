palpatine_force = class({})

LinkLuaModifier( "modifier_palpatine_force", "abilities/palpatine_force.lua", LUA_MODIFIER_MOTION_NONE )

function palpatine_force:OnUpgrade()
    if IsServer() then 
        if not self:GetCaster():HasModifier("modifier_palpatine_force") then 
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_palpatine_force", nil):SetStackCount(self:GetSpecialValueFor("charges")) 
        end 
    end 
end

function palpatine_force:OnSpellStart ()
    if IsServer() then
        self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5, push_length = self:GetSpecialValueFor("push_length") } )
    
        EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
    end 
end

modifier_palpatine_force = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_palpatine_force:IsHidden() return false end
function modifier_palpatine_force:IsDebuff() return false end
function modifier_palpatine_force:RemoveOnDeath() return false end
function modifier_palpatine_force:IsPurgable() return false end
function modifier_palpatine_force:DestroyOnExpire() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_palpatine_force:OnCreated( kv )
	-- references
	self.max_charges = self:GetAbility():GetSpecialValueFor( "charges" ) -- special value

	if IsServer() then
		self:SetStackCount( self.max_charges )
		self:CalculateCharge()
	end
end

function modifier_palpatine_force:OnRefresh( kv )
	-- references
	self.max_charges = self:GetAbility():GetSpecialValueFor( "charges" ) -- special value

	if IsServer() then
		self:CalculateCharge()
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_palpatine_force:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_palpatine_force:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() or params.ability~=self:GetAbility() then
			return
		end

		self:DecrementStackCount()
		self:CalculateCharge()
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_palpatine_force:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_palpatine_force:CalculateCharge()
	self:GetAbility():EndCooldown()
	if self:GetStackCount()>=self.max_charges then
		-- stop charging
		self:SetDuration( -1, false )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time = self:GetAbility():GetCooldown( -1 )
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount()==0 then
			self:GetAbility():StartCooldown( self:GetRemainingTime() )
		end
	end
end