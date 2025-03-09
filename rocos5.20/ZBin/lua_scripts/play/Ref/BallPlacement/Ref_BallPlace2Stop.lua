--jiaonangti 
local goaliePos = CGeoPoint:new_local(-param.pitchLength/2+param.playerRadius,0)
local ballPos = ball.pos()
local p1=ball.placementPos()
local px=p1:x()
local py=p1:y()
---------------------------------------------------------------------
local showspace = function()------展示出胶囊体
    local placementPos={
        ball.pos()+Utils.Polar2Vector(500,(ball.pos()-p1):dir()+math.pi/2.0),
        ball.placementPos()+Utils.Polar2Vector(500,(p1-ball.pos()):dir()-math.pi/2.0),
        ball.placementPos()+Utils.Polar2Vector(500,(p1-ball.pos()):dir()+math.pi/2.0),
        ball.pos()+Utils.Polar2Vector(500,(ball.pos()-p1):dir()-math.pi/2.0)
    }
    local de =function()
        debugEngine:gui_debug_line(placementPos[1],placementPos[2],4)
        debugEngine:gui_debug_line(placementPos[3],placementPos[4],4)
        debugEngine:gui_debug_arc(ball.pos(),500,0,math.pi*200,4)
        debugEngine:gui_debug_arc(ball.placementPos(),500,0,math.pi*200,4)
    end
    de()    
end
-------------------------------------------------------------------------

local standPos = CGeoPoint:new_local(0,0)
local p =CGeoPoint:new_local(ball.placementPos())
local dir=player.pos("Assister")-player.pos("Kicker")
local shootGen = function(dist)
    return function()
        local goalPos = CGeoPoint(param.pitchLength/2,0)
        local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - p1):dir())
        return pos
    end
end
local shootGen2 = function(dist)
    return function()
        local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

        local pos = ball.pos() + Utils.Polar2Vector(dist,-math.pi/2.0)
        return pos
    end
end
local shootGen3 = function(dist)
    return function()
        local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

        local pos = ball.pos() + Utils.Polar2Vector(dist,math.pi/2.0)
        return pos
    end
end
local shootGen4 = function(dist)
    return function()
        local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

        local pos = ball.pos() + Utils.Polar2Vector(dist,0)
        return pos
    end
end
local shootGen5 = function(dist)
    return function()
        local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

        local pos = ball.pos() + Utils.Polar2Vector(dist,math.pi)
        return pos
    end
end
local shootGenG = function(dist)
    return function()
        local goalPos = CGeoPoint(param.pitchLength/2,0)
        local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
        return pos
    end
end
--------------------------------------------flag config-------------------------------------------
local DSS_FLAG = flag.allow_dss + flag.dodge_ball+ flag.avoid_their_ballplacement_area          --
local BallPlace0=flag.dribbling+flag.our_ball_placement                                         --
--------------------------------------------------------------------------------------------------
local JUDGE = {
    BallInField = function()
        local x = ball.posX()
        local y = ball.posY()
        local mx = param.pitchLength
        local my = param.pitchWidth
        if not ball.valid() then
            return false
        end
        if x > mx or x < -mx or y > my or y < -my then
            return false
        end
        if math.abs(y) < param.penaltyWidth/2 and x > (param.pitchLength/2 - param.penaltyDepth) then
            return false
        end
        return true 
    end,
}
local p2 = CGeoPoint:new_local(ball.placementPos():x(),2800)
local dydir = function(pos1,pos2)
    return function()
        return (pos1 - pos2):dir()
    end
end

gPlayTable.CreatePlay{
-------------------------------------------------------------------------theirplacement----------------------------------------------------------------------------------------------------------
firstState = "jiaonangtiorplace",

["jiaonangtiorplace"]= {
    switch = function()
        if cond.theirBallPlace()
            then
                return"jnt2"
        end
        if
            cond.ourBallPlace()
            then 
                return"choosestate"
        end
    end,
    
    Leader  = task.stop(),
    Goalie  = task.stop(),
    Tier    = task.stop(),
    Receiver= task.stop(),
    Defender= task.stop(),
    Middle  = task.stop(),  
    match   = "[LTRDM]"
},

["jnt2"] = {          --youfa xiayou zuofa zuoxia
  switch = function()
  showspace()
  end,
  Leader    = task.Judge_inBallplacement("Leader"),
  Defender  = task.Judge_inBallplacement("Defender"),
  Receiver  = task.Judge_inBallplacement("Receiver"),
  Middle    = task.Judge_inBallplacement("Middle"),
  Tier      = task.Judge_inBallplacement("Tier"),
  Goalie    = task.Judge_inBallplacement("Goalie"),
  match    = "{GLTRDM}"

},
-------------------------------------------------------------------ourplacement-----------------------------------------------------------------------------------------------------s
["choosestate"] = {
    switch = function()
        if ball.valid() then
            return "run_to_ball"
        else 
            return 'goback'
        end
    end,
    Leader = task.stop(),
    Goalie = task.stop(),
    Tier   = task.stop(),
    Receiver= task.stop(),
    Defender= task.stop(),
    Middle = task.stop(),   

     match = "{L}[DRMT]"
},
-----------------------------------------------rtb---------------------------------
["run_to_ball"] = {
    switch = function()
        if bufcnt(player.infraredOn("Leader"),30) then
            return "placeball"
        end
        if bufcnt(not ball.valid(),5) then
            return "gostraight"
        end
        if bufcnt(true,380) then
            return "gostraight"
        end
    end,
   -- Leader = task.goCmuRush(shootGen(-85),dydir(ballPos,p1),_,BallPlace0),
    Leader   = task.getballV1("Leader"),
    Goalie   = task.goCmuRush(goaliePos),
    Tier     = task.stop(),
    Receiver =task.stop(),
    Defender =task.stop(),
     Middle  =task.stop(),
     match   = "{L}[DRMT]"
},

-------------------------------------------td-------------------------------------------
-- ["try_dribble"] = {
--     switch = function()
--         if player.infraredCount("Leader")>60 then
--         --  return "try_keep"
--         return "placeball"
--         end
--         if bufcnt(not JUDGE.BallInField(),50) then
--             return "choosestate"
--         end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "run_to_ball"
--         end
--         if bufcnt(true,360) then
--             return "run_to_ball"
--         end
--     end,
--     Leader = task.goCmuRush(shootGen(-89),dydir(ballPos,standPos),_,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--   Middle=task.stop(),
--     match = "{L}DRMT"
-- },

---5.20
-----------------------------------------------vision unable-------------------------
["gostraight"] = {
    switch = function()
        if bufcnt(player.infraredOn("Leader"),5) then
            return "goback"
        end
        if bufcnt(true,180) then
            return "choosestate"
        end
    end,
    Leader   = task.openSpeed(80),
    Goalie   = task.goCmuRush(goaliePos),
    Tier     = task.stop(),
    Receiver =task.stop(),
    Defender =task.stop(),
     Middle  =task.stop(),
     match   = "{L}[DRMT]"
    },

["goback"] = {
    switch = function()
        if bufcnt(JUDGE.BallInField(),20) then
            return "placeball"
        end
        if bufcnt(true,100) then
            return "placeball"
        end
    end,
    Leader   = task.goCmuRush(standPos,dydir(standPos,player.pos('Leader')),300,BallPlace0),
    Goalie   = task.goCmuRush(goaliePos),
    Tier     = task.stop(),
    Receiver =task.stop(),
    Defender =task.stop(),
     Middle  =task.stop(),
     match   = "{L}[DRMT]"
},
     -----------------------------------------------bp--------------------------------
["placeball"] = {
    switch = function()
        debugEngine:gui_debug_msg(ball.placementPos(),ball.toPointDist(ball.placementPos()),4)
        if bufcnt( player.toTargetDist("Leader")<150,40)  then
            return "gobbb"
        end
        if bufcnt( player.toBallDist("Leader")>250,10) then
            return "choosestate"
        end
    end,
    Leader= task.goCmuRush(p1,dydir(p1,player.pos('Leader')),300,BallPlace0),
    Goalie =task.goCmuRush(goaliePos),
    Tier   =task.stop(),
    Receiver =task.stop(),
    Defender=task.stop(),
     Middle=task.stop(),
    match = "{L}DRMT"
},
["gobbb"] = {
    switch = function()
        if bufcnt((ball.pos()-ball.placementPos()):mod()> 150,10) then
            return "choosestate"
        else 
            return 'leaveball'
        end
    end,
    Leader= task.openSpeed(-100,0,0),
    Goalie =task.goCmuRush(goaliePos),
    Tier   =task.stop(),
    Receiver =task.stop(),
    Defender=task.stop(),
     Middle=task.stop(),
    match = "{L}DRMT"
},

["leaveball"] = {
    switch = function()
    debugEngine:gui_debug_msg(standPos,ball.toPointDist(ball.placementPos()))
    if bufcnt((ball.pos()-ball.placementPos()):mod()> 150,10) then
            return "choosestate"
    end
    end,    
   Leader = task.goCmuRush(shootGenG(500),player.toTheirGoalDir("Leader"),300,flag.dodge_ball),
   Goalie = task.goCmuRush(goaliePos),
     Tier   = task.stop(),
    Receiver= task.stop(),
    Defender= task.stop(),
     Middle = task.stop(),
    match   =  "{L}DRMT"
},



name = "Ref_BallPlace2Stop",
applicable ={
    exp = "a",
    a = true
},
attribute = "attack",
timeout = 99999
}

--jiaonangti 
-- local goaliePos = CGeoPoint:new_local(-param.pitchLength/2+param.playerRadius,0)
-- local msgPos = CGeoPoint:new_local(0,0)
-- local ballPos = ball.pos()
-- local p1=ball.placementPos()
-- local px=p1:x()
-- local py=p1:y()
-- local jntPos1 = function()
--   local idir = ((p1 - ballPos):dir()) - math.pi/1.7
--   local pos = p1 + Utils.Polar2Vector(800+param.playerFrontToCenter,idir)
--   return pos
-- end
-- local jntPos2 = function()
--   local idir = ((p1 - ballPos):dir()) - math.pi/2.3
--   local pos = p1 + Utils.Polar2Vector(800+param.playerFrontToCenter,idir)
--   return pos
-- end
-- local jntPos3 = function()
--   local idir = ((p1 - ballPos):dir()) + math.pi/1.7
--   local pos = p1 + Utils.Polar2Vector(800+param.playerFrontToCenter,idir)
--   return pos
-- end
-- local jntPos4 = function()
--   local idir = ((p1 - ballPos):dir()) + math.pi/2.3
--   local pos = p1 + Utils.Polar2Vector(800+param.playerFrontToCenter,idir)
--   return pos
-- end
-- local standPos = CGeoPoint:new_local(0,0)
-- local p =CGeoPoint:new_local(ball.placementPos())
-- local dir=player.pos("Assister")-player.pos("Kicker")
-- local shootGen = function(dist)
--     return function()
--         local goalPos = CGeoPoint(param.pitchLength/2,0)
--         local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - p1):dir())
--         return pos
--     end
-- end
-- local shootGen2 = function(dist)
--     return function()
--         local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

--         local pos = ball.pos() + Utils.Polar2Vector(dist,-math.pi/2.0)
--         return pos
--     end
-- end
-- local shootGen3 = function(dist)
--     return function()
--         local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

--         local pos = ball.pos() + Utils.Polar2Vector(dist,math.pi/2.0)
--         return pos
--     end
-- end
-- local shootGen4 = function(dist)
--     return function()
--         local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

--         local pos = ball.pos() + Utils.Polar2Vector(dist,0)
--         return pos
--     end
-- end
-- local shootGen5 = function(dist)
--     return function()
--         local bianjiePos = CGeoPoint(0,param.pitchWidth/2)

--         local pos = ball.pos() + Utils.Polar2Vector(dist,math.pi)
--         return pos
--     end
-- end
-- local shootGenG = function(dist)
--     return function()
--         local goalPos = CGeoPoint(param.pitchLength/2,0)
--         local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
--         return pos
--     end
-- end
-- --local DSS_FLAG = flag.allow_dss + flag.dodge_ball
-- local showspace = function()------展示出胶囊体
--     local placementPos={
--         ball.pos()+Utils.Polar2Vector(500,(ball.pos()-p1):dir()+math.pi/2.0),
--         ball.placementPos()+Utils.Polar2Vector(500,(p1-ball.pos()):dir()-math.pi/2.0),
--         ball.placementPos()+Utils.Polar2Vector(500,(p1-ball.pos()):dir()+math.pi/2.0),
--         ball.pos()+Utils.Polar2Vector(500,(ball.pos()-p1):dir()-math.pi/2.0)
--     }
--     local de =function()
--         debugEngine:gui_debug_line(placementPos[1],placementPos[2],4)
--         debugEngine:gui_debug_line(placementPos[3],placementPos[4],4)
--         debugEngine:gui_debug_arc(ball.pos(),500,0,math.pi*200,4)
--         debugEngine:gui_debug_arc(ball.placementPos(),500,0,math.pi*200,4)
--     end
--     de()    
-- end
-- -------------------------------------------------------------------------



-- --------------------------------------------flag config-------------------------------------------
-- local DSS_FLAG = flag.allow_dss + flag.dodge_ball+ flag.avoid_their_ballplacement_area          --
-- local BallPlace0=flag.dribbling+flag.our_ball_placement                                         --

-- local JUDGE = {
--     BallInField = function()
--         local x = ball.posX()
--         local y = ball.posY()
--         local mx = param.pitchLength
--         local my = param.pitchWidth
--         if not ball.valid() then
--             return false
--         end
--         if x > mx or x < -mx or y > my or y < -my then
--             return false
--         end
--         if math.abs(y) < param.penaltyWidth/2 and x > (param.pitchLength/2 - param.penaltyDepth) then
--             return false
--         end
--         return true 
--     end,
-- }
-- ------------------------------config----------------------------------------
-- local dist =60


-- -----------------------------------------------------------------------

-- gPlayTable.CreatePlay{
-- -------------------------------------------------------------------------theirplacement----------------------------------------------------------------------------------------------------------
-- firstState = "jud",

-- ["jud"]= {
--     switch = function()
--         if cond.theirBallPlace() then
            
--                 return"jnt2"
--          end
--         if   cond.ourBallPlace()      then 
--                  return"choosestate"
--          end
--      end,
    
--     Leader  = task.stop(),
--     Goalie  = task.stop(),
--     Tier    = task.stop(),
--     Receiver= task.stop(),
--     Defender= task.stop(),
--     Assister  = task.stop(),  
--     match   = "{G}[LTRDA]"
-- },

-- ["jnt2"] = {--youfa xiayou zuofa zuoxia
--   switch = function()
--   showspace()
--   end,
--   Leader    = task.Judge_inBallplacement("Leader"),
--   Defender  = task.Judge_inBallplacement("Defender"),
--   Receiver  = task.Judge_inBallplacement("Receiver"),
--   Assister    = task.Judge_inBallplacement("Assister"),
--   Tier      = task.Judge_inBallplacement("Tier"),
--   Goalie    = task.Judge_inBallplacement("Goalie"),
--   match    = "{GLTRDA}"
-- },
-- -------------------------------------------------------------------ourplacement-----------------------------------------------------------------------------------------------------

-- ["choosestate"] = {
--     switch = function()
--         if bufcnt(JUDGE.BallInField(),10) then
--             return "run_to_ball"
--         else
--             if   ball.posX()<-4500 then
--                  return "run_to_ball2"
--             end
--             if   ball.posX()> 4500 then
--                 return "run_to_ball5"
--             end
--             if   ball.posY()<-3000 then  
--                 return "run_to_ball3"
--             end
--             if  ball.posY()> 3000 then
--                 return "run_to_ball4"
--             end

--         end
--     end,
--     Leader = task.stop(),
--     Goalie = task.goCmuRush(goaliePos),
--     Tier   = task.stop(),
--     Receiver = task.stop(),
--     Defender = task.stop(),
--      Middle = task.stop(),  

--      match = "{L}[DRMT]"
-- },
-- -----------------------------------------------rtb---------------------------------
-- ["run_to_ball"] = {
--     switch = function()
--         if bufcnt(player.toTargetDist("Leader")<20,10) then
--             return "try_dribble"
--         end
--     end,
--     Leader   = task.goCmuRushB(shootGen(-120), _, BallPlace0),
--     Goalie   = task.goCmuRush(goaliePos),
--     Tier     = task.stop(),
--     Receiver =task.stop(),
--     Defender =task.stop(),
--      Middle  =task.stop(),
--      match   = "{L}[DRMT]"
-- },

-- ["run_to_ball2"] = {
--     switch = function()
--         if bufcnt(player.toTargetDist("Leader")<20,10) then
--             return "try_dribble2"
--         end
        
--     end,
--     Leader   = task.goCmuRush(shootGen5(-150),math.pi, _, BallPlace0),
--     Goalie   =task.goCmuRush(goaliePos),
--     Tier     =task.stop(),
--     Receiver =task.stop(),
--     Defender =task.stop(),
--      Middle  =task.stop(),
--     match = "{L}[DRMT]"
-- },

-- ["run_to_ball3"] = {
--     switch = function()
--         if bufcnt(player.toTargetDist("Leader")<20,10) then
--             return "try_dribble3"
--         end
        
--     end,
--     Leader = task.goCmuRush(shootGen2(-150), -math.pi/2.0, _, BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}[DRMT]"
-- },

-- ["run_to_ball4"] = {
--     switch = function()
--         if bufcnt(player.toTargetDist("Leader")<20,10) then
--             return "try_dribble4"
--         end
       
--     end,
--     Leader = task.goCmuRush(shootGen3(-150), math.pi/2.0, _, BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
-- },

-- ["run_to_ball5"] = {
--     switch = function()
--         if bufcnt(player.toTargetDist("Leader")<20,10) then
--             return "try_dribble5"
--         end
        
--     end,
--     Leader = task.goCmuRush(shootGen4(-150),0 , _, BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
-- },

-- -------------------------------------------td-------------------------------------------
-- ["try_dribble"] = {
--     switch = function()
--         if bufcnt( task.ball_is_ctrl(),20) then
--             return "placeball"
--         end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "run_to_ball"
--         end
--         if not ball.valid() and task.ball_is_ctrl() then
--             return "go"
--         end
--         debugEngine:gui_debug_msg(msgPos,"getball_dis:"..math.ceil(player.toBallDist('Leader')),5)
--     end,
--     Leader   =task.goCmuRushB(shootGen(-dist),500,BallPlace0),
--     Goalie   =task.goCmuRush(goaliePos),
--     Tier     =task.stop(),
--     Receiver =task.stop(),
--     Defender =task.stop(),
--     Middle   =task.stop(),
--     match   = "{L}DRMT"
-- },

-- ["try_dribble2"] = {
--     switch = function()
--         if player.infraredCount("Leader")>10 then
--             return "placeball"
--         end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "run_to_ball2"
--         end
--         if not ball.valid() and task.ball_is_ctrl() then
--             return "go"
--         end
--         task.getball_dis()
--     end,
--     Leader = task.goCmuRush(shootGen5(-dist),math.pi,500,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
-- },

-- ["try_dribble3"] = {
--     switch = function()
--         if bufcnt( task.ball_is_ctrl(),10) then
--             return "placeball"
        
--         end
--         --if bufcnt(not JUDGE.BallInField(),5) then
--             --return "run_to_zero2"
--         --end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "run_to_ball3"
--         end
--         debugEngine:gui_debug_msg(msgPos,"getball_dis:"..math.ceil(player.toBallDist('Leader')),5)
--     end,
--     Leader = task.goCmuRush(shootGen2(-dist),-math.pi/2.0,300,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
-- },

-- ["try_dribble4"] = {
--     switch = function()
--         if player.infraredCount("Leader")>10 then
--             return "placeball"
        
--         end
--         --if bufcnt(not JUDGE.BallInField(),5) then
--             --return "run_to_zero2"
--         --end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "run_to_ball4"
--         end
--     end,
--     Leader = task.goCmuRush(shootGen3(-dist),math.pi/2.0,300,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
--     },

--     ["try_dribble5"] = {
--     switch = function()
--         if player.infraredCount("Leader")>10 then
--             return "placeball"
        
--         end
--         --if bufcnt(not JUDGE.BallInField(),5) then
--             --return "run_to_zero2"
--         --end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "run_to_ball5"
--         end
--     end,
--     Leader= task.goCmuRush(shootGen4(-dist),0,300,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
--     },

--     ["try_dribble6"] = {
--     switch = function()
--         if player.infraredCount("Leader")>10 then
--             return "placeball"
        
--         end
--         --if bufcnt(not JUDGE.BallInField(),5) then
--             --return "run_to_zero2"
--         --end
--         if bufcnt(player.toBallDist("Leader")>300,30) then
--             return "run_to_ball6"
--         end
--     end,
--     Leader= task.goCmuRush(shootGen4(-89),0,300,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
--     },
-- ---------------------------------------------vision unable--------------------

-- ["go"] = {
--     switch = function()
--         if player.infraredCount("Leader")>10 or bufcnt(true,180) then
--             return "back"
--         end
--         if ball.valid() then
--             return "choosestate"
--         end
--         task.getball_dis()
--     end,
--     Leader = task.openSpeed(100,0,0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = ""
-- },
--     ["back"] = {
--     switch = function()
--         if ball.valid() then
--             return "choosestate"
--         end
--         if bufcnt(true,100) then
--             return "choosestate"
--         end
--     end,
--     Leader = task.goCmuRush(standPos,((msgPos-player.pos('Leader')):dir()) ,500,BallPlace0),
--     --Leader = task.goCmuRush(shootGen5(-dist),((msgPos-player.pos('Leader')):dir()) ,500,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = ""
-- },
-- -----------------------------------------------pb-------------------------
-- ["placeball"] = {
--     switch = function()
--         if bufcnt( player.toTargetDist("Leader")<50,50) then
--             return "leaveball"
--         end
--         if bufcnt( player.toBallDist("Leader")>300,30) then
--             return "choosestate"
--         end
--         debugEngine:gui_debug_msg(msgPos,'place dis：'..math.ceil(ball.toPointDist(ball.placementPos())),4)
--         task.getball_dis()
--     end,
--     Leader= task.goCmuRushB(p1,300,BallPlace0),
--     Goalie =task.goCmuRush(goaliePos),
--     Tier   =task.stop(),
--     Receiver =task.stop(),
--     Defender=task.stop(),
--      Middle=task.stop(),
--     match = "{L}DRMT"
-- },

-- ["leaveball"] = {
--     switch = function()
--     if   bufcnt(player.toBallDist("Leader")>150,100)  or bufcnt(true,180) then
--         return "finish"
--     end
--    -- task.getball_dis()
--     debugEngine:gui_debug_msg(msgPos,'place dis：'..math.ceil(ball.toPointDist(ball.placementPos())),4)
--     end,    
--    Leader = task.goCmuRush(shootGenG(300),player.toTheirGoalDir("Leader"),_,flag.dodge_ball),
--    Goalie = task.goCmuRush(goaliePos),
--      Tier   = task.stop(),
--     Receiver= task.stop(),
--     Defender= task.stop(),
--      Middle = task.stop(),
--     match   =  "{L}DRMT"
-- },



-- name = "Ref_BallPlace2Stop",
-- applicable ={
--     exp = "a",
--     a = true
-- },
-- attribute = "attack",
-- timeout = 99999
-- }

