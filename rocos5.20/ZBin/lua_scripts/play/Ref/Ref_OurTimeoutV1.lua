--暂停脚本，我方暂停与敌方暂停都会调用，左右需要side调整
local TargetPosG  = CGeoPoint:new_local(-3500,-0)
local TargetPos1  = CGeoPoint:new_local(-3000,-1000)
local TargetPos2  = CGeoPoint:new_local(-3000,1000)
local TargetPos3  = CGeoPoint:new_local(-1300,-1600)
local TargetPos4  = CGeoPoint:new_local(-1300,1600)
local TargetPos5  = CGeoPoint:new_local(-2000, 0)

gPlayTable.CreatePlay{

firstState = "move",
["move"] = {
	switch = function ()
		if bufcnt(
			player.toTargetDist("Goalie")   <20 and 
			player.toTargetDist("Kicker")   <20 and 
			player.toTargetDist("Receiver") <20 and 
			player.toTargetDist("Defender") <20 and 
			player.toTargetDist("Middle")   <20 and 
			player.toTargetDist("Tier")     <20 		
			,20,999) then
			return "halt"
		end
	end,
	Goalie   = task.goCmuRush(TargetPosG,0,_,flag.allow_dss),
	Tier     = task.goCmuRush(TargetPos1,0,_,flag.allow_dss),
	Middle   = task.goCmuRush(TargetPos3,0,_,flag.allow_dss),
	Defender = task.goCmuRush(TargetPos4,0,_,flag.allow_dss),
	Receiver = task.goCmuRush(TargetPos5,0,_,flag.allow_dss),
	Kicker   = task.goCmuRush(TargetPos2,0,_,flag.allow_dss),
	
	match = "{G}[KMTRD]"
},


["halt"] = {
	switch = function()

	end,
	["Leader"]   = task.stop(),
	["Special"]  = task.stop(),
	["Assister"] = task.stop(),
	["Defender"] = task.stop(),
	["Middle"]   = task.stop(),
	["Center"]   = task.stop(),
	["Breaker"]  = task.stop(),
	["Goalie"]   = task.stop(),
	match = ""
},

name = "Ref_OurTimeoutV1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
