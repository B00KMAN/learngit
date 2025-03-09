-------------------------debug角球点----------------------
local lj1=CGeoPoint:new_local(-2000,1100)
local lj2=CGeoPoint:new_local(-2000,2800)
local lj3=CGeoPoint:new_local(-4000,2800)
local lj4=CGeoPoint:new_local(-4000,1100)
local ljf=CGeoPoint:new_local(-1000,200)--角球防守点

local rj1=CGeoPoint:new_local(-2000,-1100)
local rj2=CGeoPoint:new_local(-2000,-2800)
local rj3=CGeoPoint:new_local(-4000,-2800)
local rj4=CGeoPoint:new_local(-4000,-1100)
local rjf=CGeoPoint:new_local(-1000,-200)--角球防守点
-------------------------debug禁区前-----------------------
local jq1=CGeoPoint:new_local(-4500,-3000)
local jq2=CGeoPoint:new_local(-4500,3000)
local jq3=CGeoPoint:new_local(-1500,3000)
local jq4=CGeoPoint:new_local(-1500,-3000)
local jqf1=CGeoPoint:new_local(-2600,-250)--禁区防守点
local jqf2=CGeoPoint:new_local(-2600,250)--禁区防守点
----------------------------------------------------------
gPlayTable.CreatePlay{
firstState = "wait1",
["wait1"] = {
switch = function()
	if cond.isNormalStart() then
      return "wait2"
    end
end,
	Kicker   = task.mydef(0.8),
    Tier     = task.marking(-4000,-2000,-2500,-1100,rjf),--右脚球区
    Middle   = task.marking(-4000,-2000,1100,2500,ljf),  --左脚球区
    Defender = task.marking(-3500,-1500,-1000,0,jqf1),   --禁区
    Receiver = task.marking(-3500,-1500,0,1000,jqf2),    --禁区
    Goalie   = task.goalie(),
    match = "{G}[KMTRD]"
},

["wait2"] = {
switch = function()
	if ball.velMod()>1000 then
      return "exit"
    end
end,
	Kicker   = task.mydef(0.8),
    Tier     = task.marking(-4000,-2000,-2500,-1100,rjf),--右脚球区
    Middle   = task.marking(-4000,-2000,1100,2500,ljf),  --左脚球区
    Defender = task.marking(-3500,-1500,-1000,0,jqf1),   --禁区
    Receiver = task.marking(-3500,-1500,0,1000,jqf2),    --禁区
    Goalie   = task.goalie(),
    match = "{G}[KMTRD]"
},


name = "Ref_KickOffDefV1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
