if modifier_mercer == nil then modifier_mercer = class({}) end

modifier_mercer.items = {
    "models/heroes/hero_mercer/econs/blades.vmdl",
    "models/heroes/hero_mercer/econs/claws.vmdl",
    "models/heroes/hero_mercer/econs/punches.vmdl"
}

function modifier_mercer:IsHidden() return true end
function modifier_mercer:IsPurgable() return false end
function modifier_mercer:RemoveOnDeath() return false end

function modifier_mercer:OnCreated(params)
    if IsServer() then 
       self:GetParent().abilities = {}
       
       for _,i in pairs(modifier_mercer.items) do 
            local item = SpawnEntityFromTableSynchronous("prop_dynamic", {model = i})
            item:FollowEntity(self:GetParent(), true)

            item:AddEffects(EF_NODRAW)

            table.insert(self:GetParent().abilities, item)
       end 
    end
end
