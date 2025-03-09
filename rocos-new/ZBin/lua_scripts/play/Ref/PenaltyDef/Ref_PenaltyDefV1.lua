
--da dian qiu
local dqg = CGeoPoint:new_local(-4500,0)

local dq1=CGeoPoint:new_local(3500,2500)
local dq2=CGeoPoint:new_local(3500,-2500)
local dq3=CGeoPoint:new_local(3500,-2200)
local dq4=CGeoPoint:new_local(3500,2200)
local dq5=CGeoPoint:new_local(3500,1700)
local dq6=CGeoPoint:new_local(0,2500)
local dq7=CGeoPoint:new_local(0,2500)

gPlayTable.CreatePlay{
firstState = "ready000",


["ready000"] = {
switch = function()
  if cond.isNormalStart() then
    return "ready1111"
  end
end,
  ["Kicker"]   = task.goCmuRush(dq1),--to p32 middle
  ["Middle"]   = task.goCmuRush(dq2),
  ["Tier"]     = task.goCmuRush(dq3),
  ["Receiver"] = task.goCmuRush(dq4),                -- receive to paodian
  ["Defender"] = task.goCmuRush(dq5),
  ["Goalie"]   = task.goCmuRush(dqg,_,_,flag.our_ball_placement),
  match = "{G}[KMTRD]"
},
["ready1111"] = {
switch = function()
  if bufcnt (cond.ballMoved(),10)  then
    return "check attack"
  end
end,
  ["Kicker"]   = task.goCmuRush(dq1),--to p32 middle
  ["Middle"]   = task.goCmuRush(dq2),
  ["Tier"]     = task.goCmuRush(dq3),
  ["Receiver"] = task.goCmuRush(dq4),                -- receive to paodian
  ["Defender"] = task.goCmuRush(dq5),
  ["Goalie"]   = task.goCmuRush(dqg,_,_,flag.our_ball_placement),
  match = "{G}[KMTRD]"
},

["check attack"] = {
switch = function()
  if bufcnt (ball.posX() < 0 and ball.velMod() < 2000,5) then
    return "def"
  end
end,

  ["Kicker"]   = task.stop("Kicker"),
  ["Middle"]   = task.stop("Middle"),
  ["Tier"]     = task.stop("Tier"),
  ["Receiver"] = task.stop("Receiver"),               
  ["Defender"] = task.stop("Defender"),
  ["Goalie"]   = task.goalie(),
  match = ""
},


["def"] = {
switch = function()
if cond.ballMoved() then
   
  end
end,
  ["Kicker"]   = task.stop("Kicker"),
  ["Middle"]   = task.stop("Middle"),
  ["Tier"]     = task.stop("Tier"),
  ["Receiver"] = task.stop("Receiver"),                
  ["Defender"] = task.stop("Defender"),
  ["Goalie"]   = task.getballV1("Goalie"),
  match = ""
},
name = "Ref_PenaltyDefV1",
applicable = {
  exp = "a",
  a = true
},
attribute = "attack",
timeout = 99999
}

