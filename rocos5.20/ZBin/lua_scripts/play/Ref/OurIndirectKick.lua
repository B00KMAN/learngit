
-- 在进入每一个定位球时，需要在第一次进时进行保持
-- 在进入每一个定位球时，需要在第一次进时进行保持
----need to modify

	if ball.refPosX() > 0 * param.pitchLength  then
		dofile("./lua_scripts/play/Ref/FrontKick/FrontKick.lua")
	else
		dofile("./lua_scripts/play/Ref/BackKick/BackKick.lua")
	end

gOurIndirectTable.lastRefCycle = vision:getCycle()




--23.5.16 ddr 

--[[-- 在进入每一个定位球时，需要在第一次进时进行保持
-- 在进入每一个定位球时，需要在第一次进时进行保持
----need to modify
if math.abs(ball.refPosY()) < 1/3 * param.pitchWidth then
	dofile("./lua_scripts/play/Ref/CenterKick/CenterKick.lua")

else
	if ball.refPosX() > 1 / 3 * param.pitchLength then
		dofile("./lua_scripts/play/Ref/CornerKick/CornerKick.lua")
		

	elseif ball.refPosX() > 0 * param.pitchLength and ball.refPosX() < 1/3 * param.pitchLength + 2 then
		dofile("./lua_scripts/play/Ref/FrontKick/FrontKick.lua")
		--		 gCurrentPlay = "FrontKickV1"

	elseif ball.refPosX() > -1/4 * param.pitchLength and ball.refPosX() < 0 * param.pitchLength + 2 then
		dofile("./lua_scripts/play/Ref/MiddleKick/MiddleKick.lua")

	else

		dofile("./lua_scripts/play/Ref/BackKick/BackKick.lua")
	end
end

gOurIndirectTable.lastRefCycle = vision:getCycle()--]]