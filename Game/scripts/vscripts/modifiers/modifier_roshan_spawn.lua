if modifier_roshan_spawn == nil then modifier_roshan_spawn = class({}) end

function modifier_roshan_spawn:IsHidden()
	return false
end

function modifier_roshan_spawn:IsPurgable()
	return false
end


function modifier_roshan_spawn:OnDestroy()
    if IsServer() then
        local roshan_origin = self:GetParent():GetAbsOrigin()
        local aegis = CreateItem("item_aegis", nil, nil)
        CreateItemOnPositionSync(roshan_origin, aegis)
        Notifications:BottomToAll({text="Ursa has been defeated!", duration=3, style={color="red", ["font-size"]="34px", border="0px solid blue"}})
        EmitGlobalSound("diretide_select_target_Stinger")
        Timers:CreateTimer(600, function()
            PrecacheUnitByNameAsync("npc_mega_greevil", function() 
                local roshan = CreateUnitByName( "npc_mega_greevil", roshan_origin, true, nil, nil, 4)
                roshan:AddNewModifier(roshan, nil, "modifier_roshan_spawn", nil)
                return nil
            end)
        end)
    end
end