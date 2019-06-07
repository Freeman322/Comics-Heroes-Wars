if modifier_alisa == nil then modifier_alisa = class({}) end

modifier_alisa.item = null;

function modifier_alisa:IsAura()
	return false
end

function modifier_alisa:IsHidden()
	return true
end

function modifier_alisa:IsPurgable()
	return false
end

function modifier_alisa:RemoveOnDeath()
	return false
end

function modifier_alisa:OnCreated(params)
    if IsServer() then 
        self.item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_america/econs/alisa/econs/alisa_econs.vmdl"})
        self.item:FollowEntity(self:GetParent(), true)
        self.item:AddEffects(EF_NODRAW)

        self:StartIntervalThink(0.1)
    end 
end

function modifier_alisa:OnIntervalThink()
    if IsServer() then 
        if self:GetParent():HasModifier("modifier_cap_warcry") or self:GetParent():HasModifier("modifier_sam_bladerun_buff") then 
            if self.item then self.item:RemoveEffects(EF_NODRAW) end else 
            if self.item then self.item:AddEffects(EF_NODRAW) end 
        end
    end 
end
