-- gCurrentPlay = gOppoConfig.PenaltyDef
if vision:getCycle() - gOurIndirectTable.lastRefCycle > 6 then
    if type(gOppoConfig.PenaltyDef) == "function" then
    	gCurrentPlay = cond.getOpponentScript("Ref_PenaltyDefV",gOppoConfig.PenaltyDef(),1)
    else
    	gCurrentPlay = cond.getOpponentScript("Ref_PenaltyDefV",gOppoConfig.PenaltyDef,1)
    end
    -- gCurrentPlay = "Ref_CornerKickMessi"
end