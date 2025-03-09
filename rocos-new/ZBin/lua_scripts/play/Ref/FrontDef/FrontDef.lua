if type(gOppoConfig.FrontDef) == "function" then
	gCurrentPlay = cond.getOpponentScript("Ref_FrontDefV",gOppoConfig.FrontDef(),1)
else
	gCurrentPlay = cond.getOpponentScript("Ref_FrontDefV",gOppoConfig.FrontDef,1)
end
