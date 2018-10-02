function IsHasTalent( pID, talent )
    local talents = CustomNetTables:GetTableValue("talents", "talents")
    if talents[tostring(pID)] then
        return talents[tostring(pID)][talent]
    end 
    return nil
end