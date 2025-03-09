if vision:getCycle() - gOurIndirectTable.lastRefCycle > 6 then
    if type(gOppoConfig.CenterKick) == "function" then
    	gCurrentPlay = cond.getOpponentScript("Ref_CenterKickV",gOppoConfig.CenterKick(),1)
    else
    	gCurrentPlay = cond.getOpponentScript("Ref_CenterKickV",gOppoConfig.CenterKick,1)
    end
end
