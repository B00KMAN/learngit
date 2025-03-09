-- if vision:getCycle() - gOurIndirectTable.lastRefCycle > 6 then
-- 	if type(gOppoConfig.FrontKick) == "function" then 
-- 		gCurrentPlay = cond.getOpponentScript("Ref_FrontKickV", gOppoConfig.FrontKick(),1)
-- 	else
-- 		gCurrentPlay = cond.getOpponentScript("Ref_FrontKickV", gOppoConfig.FrontKick, 1)
-- 	end
-- end

if vision:getCycle() - gOurIndirectTable.lastRefCycle > 6 then
	if type(gOppoConfig.FrontKick) == "function" then 
		gCurrentPlay = cond.getOpponentScript("Ref_FrontKickV", gOppoConfig.FrontKick(),1)
	else
		gCurrentPlay = cond.getOpponentScript("Ref_FrontKickV", gOppoConfig.FrontKick, 1)
	end
end