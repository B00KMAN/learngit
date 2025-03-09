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
local jq1=CGeoPoint:new_local(-4500,-3000)
local jq2=CGeoPoint:new_local(-4500,3000)
local jq3=CGeoPoint:new_local(-1500,3000)
local jq4=CGeoPoint:new_local(-1500,-3000)
local jqf1=CGeoPoint:new_local(-2600,-300)--禁区防守点
local jqf2=CGeoPoint:new_local(-2600,300)--禁区防守点
----------------------------------------------------------
gPlayTable.CreatePlay{
firstState = "wait",
["wait"] = {
switch = function()
debugEngine:gui_debug_line(jq1,jq2,4)
debugEngine:gui_debug_line(jq1,jq4,4)
debugEngine:gui_debug_line(jq2,jq3,4)
debugEngine:gui_debug_line(jq3,jq4,4)
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"MiddleDef ryq",8) 
    if bufcnt(ball.velMod()>800,2) or bufcnt(true,600) then
              return "md"
    end
end, 
        ["Kicker"]   = task.mydef(0.9),
        ["Middle"]   = task.goCmuRushB(CGeoPoint:new_local(2000,0)),
        ["Tier"]     = task.mydef(0.5),
        ["Receiver"] = task.marking(-4500,-1500,-3000,0,jqf1),   --禁区
        ["Defender"] = task.marking(-4500,-1500,0,3000,jqf2),    --禁区
        ["Goalie"]   = task.goalie(),
        match = "{G}[KMTRD]"
},
["md"] = {
switch = function()
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
    debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"MiddleDef ryq",8) 
    if bufcnt(ball.toPlayerDist("Kicker") < 200, 40) then
       return 'touch' 
   end
	if ball.posX()<-1000 or ball.posX()>1000 then
	return "exit"
    end
end,

    Kicker   = task.getballV2("Kicker"),
    Tier     = task.marking(-4000,-2000,-2500,-1100,rjf),--右脚球区
    Middle   = task.marking(-4000,-2000,1100,2500,ljf),  --左脚球区
    Defender = task.marking(-3500,-1500,-1000,0,jqf1),   --禁区
    Receiver = task.marking(-3500,-1500,0,1000,jqf2),    --禁区
    Goalie   = task.goalie(),
    match = "{G}[KMTRD]"
},
["touch"] = {
switch = function()
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
    debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"MiddleDef ryq",8) 
    if bufcnt(ball.toPlayerDist("Kicker") > 200, 40) then
       return 'finish'
       end 
    if ball.posX()<-1000 or ball.posX()>1000 then
    return "exit"
    end
end,

        ["Kicker"]   = task.smartshootV1('Kicker'),
        ["Middle"]   = task.mydef(0.4),
        ["Tier"]     = task.marking(-4000,-2700,-2500,-1100,rjf),--右脚球区
        ["Receiver"] = task.marking(-3200,-1500,-2000,2000,jqf1),
        ["Defender"] = task.marking(-4000,-2700,1100,2500,ljf), --左脚球区
        ["Goalie"]   = task.goalie(),
        match = "{G}[KMTRD]"
},

name = "Ref_MiddleDefV1",
applicable ={
	exp = "a",
	a   = true
},
attribute = "defense",
timeout   = 99999
}