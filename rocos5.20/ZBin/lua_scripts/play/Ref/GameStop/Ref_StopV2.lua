-------------------------debug角球点----------------------
local lj1=CGeoPoint:new_local(-2700,1100)
local lj2=CGeoPoint:new_local(-2700,2500)
local lj3=CGeoPoint:new_local(-4000,2500)
local lj4=CGeoPoint:new_local(-4000,1100)
local ljf=CGeoPoint:new_local(-2900,900)--角球防守点

local rj1=CGeoPoint:new_local(-2700,-1100)
local rj2=CGeoPoint:new_local(-2700,-2500)
local rj3=CGeoPoint:new_local(-4000,-2500)
local rj4=CGeoPoint:new_local(-4000,-1100)
local rjf=CGeoPoint:new_local(-2900,-900)--角球防守点
-----------------------baoxain-------------------------------------
local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
local bx2=CGeoPoint:new_local(-2700,-800)  --后场右边  baoxianwei
local bx3=CGeoPoint:new_local(700,1500)  --zhong chang zuo边 baoxianwei
local bx4=CGeoPoint:new_local(700,-1500)  --zhongchang youbian baoxianwei
-------------------------debug禁区前-----------------------
local jq1=CGeoPoint:new_local(-3500,-1100)
local jq2=CGeoPoint:new_local(-3500,1100)
local jq3=CGeoPoint:new_local(-1500,1100)
local jq4=CGeoPoint:new_local(-1500,-1100)
local jqf1=CGeoPoint:new_local(-2900,-500)--禁区防守点
local jqf2=CGeoPoint:new_local(-2900,500)--禁区防守点
---------------------------------------------------------------
local goaliePos = CGeoPoint:new_local(-param.pitchLength/2+param.playerRadius,0)
local middlePos = function()
  local ballPos = ball.pos()
  local idir = (pos.ourGoal() - ballPos):dir()
  local pos = ballPos + Utils.Polar2Vector(650,idir)
  return pos
end

local checkdq = function(xmin,ymin,xmax,ymax)
  local between = function(a,min,max)
      if a > min and a < max then
        return true
      end
          return false        
        end     
    if between(ball.posX(),xmin,xmax) and between(ball.posY(),ymin,ymax) then
         return true
      end
    return false
  end

gPlayTable.CreatePlay {
firstState = "start",
["start"] = {
  switch = function()
    debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
    debugEngine:gui_debug_line(player.pos('Kicker'),ball.pos(),8)
    debugEngine:gui_debug_msg(player.pos('Kicker')+Utils.Polar2Vector(500,math.pi),math.ceil((player.pos('Kicker')-ball.pos()):mod()),8)
    if cond.isGameOn() then
      return "exit"
    end
    --if checkdq(-3600,-1500,-2000,1500) then 
     -- return "dq"
    --end
  end,

  Kicker   = task.goCmuRush(middlePos,dir.playerToBall,600),
  Middle   = task.mydef(0.6,500),
  Tier     = task.goCmuRush(jqf1,dir.playerToBall,600),
  Goalie   = task.goalie(),
  Defender = task.goCmuRush(jqf2,dir.playerToBall,600),
  Receiver = task.mydef(0.5,500),
   match = "{G}[KMTRD]"
 },
 ["dq"] = {
  switch = function()
    debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
    -- if cond.isGameOn() then
    --   return "exit"
    -- end
    
  end,

  Kicker   = task.mydef(0.6,500),
  Middle   = task.goCmuRush(bx1,dir.playerToBall,600),
  Tier     = task.goCmuRush(rjf,dir.playerToBall,600),
  Goalie   = task.goalie(),
  Defender = task.goCmuRush(ljf,dir.playerToBall,600),
  Receiver = task.goCmuRush(bx2,dir.playerToBall,600),
   match = "{G}[KMTRD]"
 },

name = "Ref_StopV2",
applicable = {
  exp = "a",
  a = true
},
attribute = "attack",
timeout = 99999
}