--gCurrentPlay = gOppoConfig.KickOffDef
if vision:getCycle() - gOurIndirectTable.lastRefCycle > 6 then
    if type(gOppoConfig.KickOffDef) == "function" then
    	gCurrentPlay = cond.getOpponentScript("Ref_PenaltyDefV",gOppoConfig.KickOffDef(),1)
    else
    	gCurrentPlay = cond.getOpponentScript("Ref_PenaltyDefV",gOppoConfig.KickOffDef,1)
    end
    -- gCurrentPlay = "Ref_CornerKickMessi"
end