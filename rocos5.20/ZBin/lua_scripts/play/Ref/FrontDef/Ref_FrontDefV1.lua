-----------------------baoxain-------------------------------------
local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
local bx2=CGeoPoint:new_local(-2700,-800) --后场右边  baoxianwei

local bx3=CGeoPoint:new_local(700,1500)  --zhong chang zuo边 baoxianwei
local bx4=CGeoPoint:new_local(700,-1500) --zhong chang youbian baoxianwei
-------------------------debug禁区前-----------------------
local jq1=CGeoPoint:new_local(-3500,-1100)
local jq2=CGeoPoint:new_local(-3500,1100)
local jq3=CGeoPoint:new_local(-1500,1100)
local jq4=CGeoPoint:new_local(-1500,-1100)
local jqf1=CGeoPoint:new_local(-2900,-150)--禁区防守点
local jqf2=CGeoPoint:new_local(-2900,150)--禁区防守点
---------------------212----------------------------------
local p1=CGeoPoint:new_local(3000,1500)  --前场右边
local p2=CGeoPoint:new_local(3000,-1500) --前场左边
local p3=CGeoPoint:new_local(2000,0)     --中场

local p31=CGeoPoint:new_local(1000,-2000)     --中场1
local p32=CGeoPoint:new_local(1000,2000)     --中场2

local p4=CGeoPoint:new_local(-1000,-800) --后场左边
local p5=CGeoPoint:new_local(-1000,800)  --后场右边

local p6=CGeoPoint:new_local(2500,0)  --前场zhongjian


gPlayTable.CreatePlay{
firstState = "wait",
["wait"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"FrontDef ryq",8) 
       if bufcnt(ball.velMod()>800,2) then
              return "fd"
       end
end, 
        ["Kicker"]   = task.mydef(0.8),
        ["Middle"]   = task.goCmuRushB(p6),
        ["Tier"]     = task.mydef(0.5),
        ["Receiver"] = task.marking(-3500,-1000,-3000,0,jqf1),   --禁区
        ["Defender"] = task.marking(-3500,-1000,0,3000,jqf2),    --禁区
        ["Goalie"]   = task.goalie(),
        match = "{G}[KMTRD]"
},
["fd"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"FrontDef ryq",8) 
       if bufcnt(ball.toPlayerDist("Kicker") < 220,30)  then
		return "shoot"
	end
	-- if bufcnt( ball.posX()<1000,20) then
	-- 	return "finish"
	-- end
end, 
        ["Kicker"]   = task.getballV2("Kicker"),
        ["Middle"]   = task.goCmuRushB(p6),
        ["Tier"]     = task.mydef(0.5),
        ["Receiver"] = task.marking(-3500,-1000,-3000,0,jqf1),   --禁区
        ["Defender"] = task.marking(-3500,-1000,0,3000,jqf2),    --禁区
        ["Goalie"]   = task.goalie(),
        match = "{G}[KMTRD]"
},

["shoot"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"FrontDef ryq",5) 
       if bufcnt(ball.toPlayerDist("Kicker") > 400,25)  then---------------记得改
		return "exit"
	end
	-- if bufcnt( ball.posX()<1000,20) then
	-- 		return "finish"
	-- end
end,
        ["Kicker"]   = task.smartshootV1('Kicker'),
        ["Middle"]   = task.goCmuRushB(p6),
        ["Tier"]     = task.mydef(0.5),
        ["Receiver"] = task.marking(-3500,-1000,-3000,0,jqf1),   --禁区
        ["Defender"] = task.marking(-3500,-1000,0,3000,jqf2),    --禁区
        ["Goalie"]   = task.goalie(),
        match = "{G}[KMTRD]"
 },

name = "Ref_FrontDefV1",
applicable ={
	exp = "a",
	a   = true
},
attribute = "defense",
timeout   = 99999
}