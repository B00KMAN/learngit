-------------------------debug角球点----------------------
local lj1=CGeoPoint:new_local(-2000,1100)
local lj2=CGeoPoint:new_local(-2000,2800)
local lj3=CGeoPoint:new_local(-4000,2800)
local lj4=CGeoPoint:new_local(-4000,1100)
local ljf=CGeoPoint:new_local(-2800,1100)--角球防守点

local rj1=CGeoPoint:new_local(-2000,-1100)
local rj2=CGeoPoint:new_local(-2000,-2800)
local rj3=CGeoPoint:new_local(-4000,-2800)
local rj4=CGeoPoint:new_local(-4000,-1100)
local rjf=CGeoPoint:new_local(-2800,-1100)--角球防守点
-------------------------debug禁区前-----------------------
local jq1=CGeoPoint:new_local(-3500,-1500)
local jq2=CGeoPoint:new_local(-3500,1500)
local jq3=CGeoPoint:new_local(-1000,1500)
local jq4=CGeoPoint:new_local(-1000,-1500)
local jqf1=CGeoPoint:new_local(-2800,-300)--禁区防守点
local jqf2=CGeoPoint:new_local(-2800,300) --禁区防守点
local show =function()
	debugEngine:gui_debug_line(lj1,lj2,4)
	debugEngine:gui_debug_line(lj1,lj4,4)
	debugEngine:gui_debug_line(lj2,lj3,4)
	debugEngine:gui_debug_line(lj3,lj4,4)

	debugEngine:gui_debug_line(rj1,rj2,4)
	debugEngine:gui_debug_line(rj1,rj4,4)
	debugEngine:gui_debug_line(rj2,rj3,4)
	debugEngine:gui_debug_line(rj3,rj4,4)

	debugEngine:gui_debug_line(jq1,jq2,4)
	debugEngine:gui_debug_line(jq1,jq4,4)
	debugEngine:gui_debug_line(jq2,jq3,4)
	debugEngine:gui_debug_line(jq3,jq4,4)
	
end
----------------------------------------------------------
gPlayTable.CreatePlay{
firstState = "wait",
["wait"] = { 
switch =function()	
	if bufcnt(ball.velMod()>2000,2)  then---------------记得改
		return "inter"
	end
	show()
end,

    Kicker   = task.mydef(0.6),
	Tier     = task.marking(-4000,-2000,-2800,-1100,rjf),--右脚球区
	Middle   = task.marking(-4000,-2000,1100,2800,ljf),  --左脚球区
	Defender = task.marking(-3500,-1000,-1500,0,jqf1),   --禁区
	Receiver = task.marking(-3500,-1000,0,1500,jqf2),    --禁区
	Goalie   = task.goalie(),
     match = "{G}[KMTDR]"
},
["inter"] = { 
switch =function()	
	if bufcnt(ball.toPlayerDist("Kicker") < 300,25)  then---------------记得改
		return "ph"
	end
	show()
end,

    Kicker   = task.getballV2("Kicker"),
	Tier     = task.marking(-4000,-2000,-2800,-1100,rjf),--右脚球区
	Middle   = task.marking(-4000,-2000,1100,2800,ljf),  --左脚球区
	Defender = task.marking(-3500,-1000,-1500,0,jqf1),   --禁区
	Receiver = task.marking(-3500,-1000,0,1500,jqf2),    --禁区
	Goalie   = task.goalie(),

	match = "[KMTDR]{G}"
},
["ph"] = { 
switch =function()	
	if bufcnt(ball.toPlayerDist("Kicker") >200,40)  or ball.posX()>-1000  then---------------记得改
		return "finish"
	end
	show()
	debugEngine:gui_debug_x(CGeoPoint:new_local(-3500,-2500),5)
end,

    Kicker   = task.we_will_win ('Kicker'),
	Tier     = task.marking(-4000,-2000,-2800,-1100,rjf),--右脚球区
	Middle   = task.marking(-4000,-2000,1100,2800,ljf),  --左脚球区
	Defender = task.marking(-3500,-1000,-1500,0,jqf1),   --禁区
	Receiver = task.marking(-3500,-1000,0,1500,jqf2),    --禁区
	Goalie   = task.goalie(),

	match = "[KMTDR]{G}"
},


name = "Ref_BackDefV1",
applicable ={
	exp = "a",
	a   = true
},
attribute = "defense",
timeout   = 99999
}


--[[gPlayTable.CreatePlay{
firstState = "halt",
switch = function()
	return "halt"
end,
["halt"] = {
	["Leader"]   = task.stop(),
	["Special"]  = task.stop(),
	["Assister"] = task.stop(),
	["Defender"] = task.stop(),
	["Middle"]   = task.stop(),
	["Center"]   = task.stop(),
	["Breaker"]  = task.stop(),
	["Goalie"]   = task.stop(),
	match = "[LSADMCB]"
},

name = "Ref_BackDefV1",
applicable ={
	exp = "a",
	a   = true
},
attribute = "defense",
timeout   = 99999
}]]