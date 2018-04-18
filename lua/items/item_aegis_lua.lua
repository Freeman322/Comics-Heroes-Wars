---LinkLuaModifier("modifier_item_aegis_lua", "items/item_aegis_lua.lua", LUA_MODIFIER_MOTION_NONE)
if item_aegis_lua == nil then item_aegis_lua = class({}) end

function item_aegis_lua:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_aegis", {duration = 300})
end

function item_aegis_lua:OnItemEquipped(item)
	if IsServer() then
        print("at server")
    end
    print("not server")
    local hero = self:GetCaster():GetUnitName()
    local hero_name = "#"..hero
    Notifications:BottomToAll({hero=hero, imagestyle="landscape", text=hero_name.." picked up Aegis!", duration=4, style={color="red", ["font-size"]="34px", border="0px solid blue"}})
end

--[[if modifier_item_aegis_lua == nil then modifier_item_aegis_lua = class({}) end

function modifier_item_aegis_lua:IsHidden()
	return false
end

function modifier_item_aegis_lua:IsPurgable()
	return false
end

function modifier_item_aegis_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION,
	}
 
	return funcs
end

function modifier_item_aegis_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_item_aegis_lua:OnCreated(kv)
	self.reincarnateTime = self:GetAbility():GetSpecialValueFor("reincarnate_time")
    if self:GetAbility() then
        self:GetParent():RemoveItem(self:GetAbility())
    end
end

function modifier_item_aegis_lua:ReincarnateTime(params)
	--print("ReincarnateTime")
    local parent = self:GetParent()

    local respawnPosition = parent:GetAbsOrigin()

    local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
    parent.ReincarnateParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
    ParticleManager:SetParticleControl(parent.ReincarnateParticle, 0, respawnPosition)
    ParticleManager:SetParticleControl(parent.ReincarnateParticle, 1, Vector(500,0,0))
    ParticleManager:SetParticleControl(parent.ReincarnateParticle, 1, Vector(500,500,0))
    self:AddParticle( parent.ReincarnateParticle, false, false, -1, false, true )


    local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_bits.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, parent )
    ParticleManager:SetParticleControl(particle1, 0, respawnPosition)
    self:AddParticle( particle1, false, false, -1, false, true )

    local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust.vpcf"
    local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
    ParticleManager:SetParticleControl(particle2, 0, respawnPosition)
    self:AddParticle( particle2, false, false, -1, false, true )

    local particleName = "particles/units/heroes/hero_skeletonking/skeleton_king_death_dust_reincarnate.vpcf"
    local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
    ParticleManager:SetParticleControl(particle3 , 0, respawnPosition)
    self:AddParticle( particle3, false, false, -1, false, true )

    parent:EmitSound("Hero_SkeletonKing.Reincarnate")
    parent:EmitSound("Hero_SkeletonKing.Death")
    return self.reincarnateTime
end

function modifier_item_aegis_lua:OnDestroy()
	if IsServer() then
         self:GetParent():EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")
    end
end]]
function item_aegis_lua:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

