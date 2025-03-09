if vision:getCycle() - gOurIndirectTable.lastRefCycle > 6 then
    if type(gOppoConfig.MiddleKick) == "function" then
    	gCurrentPlay = cond.getOpponentScript("Ref_MiddleKickV", gOppoConfig.MiddleKick(), 1)
    else
    	gCurrentPlay = cond.getOpponentScript("Ref_MiddleKickV", gOppoConfig.MiddleKick, 1)
    end
end