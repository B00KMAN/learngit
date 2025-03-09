-- local TargetPosG  = CGeoPoint:new_local(-3500,-0)
-- local TargetPos1  = CGeoPoint:new_local(-3000,-1000)
-- local TargetPos2  = CGeoPoint:new_local(-3000,1000)
-- local TargetPos3  = CGeoPoint:new_local(-1300,-1600)
-- local TargetPos4  = CGeoPoint:new_local(-1300,1600)
-- local TargetPos5  = CGeoPoint:new_local(-2000, 0)
-- gPlayTable.CreatePlay{
-- firstState = "move",
-- ["move"] = {
-- 	switch = function ()
-- 		if cond.isNormalStart() then
-- 			return "shoot"
-- 		end
-- 	end,
-- 	Goalie   = task.goCmuRush(TargetPosG,0,_,flag.allow_dss),
-- 	Tier     = task.goCmuRush(TargetPos1,0,_,flag.allow_dss),
-- 	Middle   = task.goCmuRush(TargetPos3,0,_,flag.allow_dss),
-- 	Defender = task.goCmuRush(TargetPos4,0,_,flag.allow_dss),
-- 	Receiver = task.readyforshoot(),
-- 	Kicker   = task.goCmuRush(TargetPos2,0,_,flag.allow_dss),
	
-- 	match = "[KMTRD]{G}"
-- },

-- ["shoot"] = {
-- 	switch = function ()
-- 		if cond.isNormalStart() then
-- 			return "quit"
-- 		end
-- 	end,
-- 	Goalie   = task.goCmuRush(TargetPosG,0,_,flag.allow_dss),
-- 	Tier     = task.goCmuRush(TargetPos1,0,_,flag.allow_dss),
-- 	Middle   = task.goCmuRush(TargetPos3,0,_,flag.allow_dss),
-- 	Defender = task.goCmuRush(TargetPos4,0,_,flag.allow_dss),
-- 	Receiver = task.smartshootV1('Receiver'),
-- 	Kicker   = task.goCmuRush(TargetPos2,0,_,flag.allow_dss),
	
-- 	match = "[KMTRD]{G}"
-- },
-- ["quit"] = {
-- 	switch = function ()
-- 		if  ball.velMod()>1000 or bufcnt(true,180) then
-- 			return "finish"
-- 		end
-- 	end,
-- 	Goalie   = task.goCmuRush(TargetPosG,0,_,flag.allow_dss),
-- 	Tier     = task.goCmuRush(TargetPos1,0,_,flag.allow_dss),
-- 	Middle   = task.goCmuRush(TargetPos3,0,_,flag.allow_dss),
-- 	Defender = task.goCmuRush(TargetPos4,0,_,flag.allow_dss),
-- 	Receiver = task.smartshootV1('Receiver'),
-- 	Kicker   = task.goCmuRush(TargetPos2,0,_,flag.allow_dss),
	
-- 	match = "[KMTRD]{G}"
-- },

-- name = "Ref_KickOffV1",
-- applicable ={
-- 	exp = "a",
-- 	a = true
-- },
-- attribute = "attack",
-- timeout = 99999
-- }

function calPlayerCount()
    --local PlayerCount = 6
    local ActPlayerCount = 0
    for i=0,param.maxPlayer-1 do
        if player.valid(i) then
            ActPlayerCount = ActPlayerCount + 1   
        end  
    end
    return ActPlayerCount
end

local centerPos ={
CGeoPoint:new_local(2200,1800),
CGeoPoint:new_local(170,2500),
CGeoPoint:new_local(3200,1400),
CGeoPoint:new_local(1130,-1400),
CGeoPoint:new_local(2000,-1700),
CGeoPoint:new_local(800,2500),
CGeoPoint:new_local(700,-700),
}
local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
local bx2=CGeoPoint:new_local(-2700,-800)  --后场右边  baoxianwei
local bx3=CGeoPoint:new_local(-1800,1400)

local dq6=CGeoPoint:new_local(0,2500)
local dq7=CGeoPoint:new_local(0,-2500)

local max = 200
gPlayTable.CreatePlay{

firstState = "kaiqiu1",

["kaiqiu1"] = {
       switch = function()
       	if cond.isNormalStart() then
        -- if bufcnt(player.toTargetDist("Kicker")<200,20) then
            return "kaiqiu2"
--		    return "shoot"


        end
       end,
       Receiver = task.goCmuRushB(dq6),
       Kicker = task.readyforshoot(),--getballV1("Leader"),
       Middle = task.goCmuRushB(dq7),
       Tier = task.stop(),
       Defender = task.stop(),
       Goalie = task.goalie(),
       match = "{G}[KTDRM]"
},

["kaiqiu2"] = {
       switch = function()
       if calPlayerCount() > 5 then
              if bufcnt(player.toTargetDist("Kicker")<200,20) then
                     return "chuan"
    	       end
       else
              return "Lshoot"
       end
end,
       Receiver = task.goCmuRushB(dq6),
       Kicker = task.readyforshoot(),--getballV1("Leader"),
       Middle = task.goCmuRushB(dq7),
       Tier = task.stop(),
       Defender = task.stop(),
       Goalie = task.goalie(),
       match = ""
},


-- ["kaiqiu"] = {
--        switch = function()
--               if bufcnt(player.toTargetDist("Kicker")<200,20) then
--             return "paowei"
--                 elseif bufcnt(true,max) then
--             return "exit"
--      end
--        end,
--        Kicker = task.goCmuRushB(centerPos[2]),
--        Leader = task.getballV1("Leader"),
--        Middle = task.goCmuRushB(centerPos[4]),
--        Receiver = task.mydef(0.4),
--        Tier = task.marking(-3200,-1500,0,1000,bx2),
--        Goalie = task.goalie(),
--        match = "{G}[LTKRM]"
-- },
-- ["Kyrie"] = {
--        switch = function()
--               if bufcnt(player.toTargetDist("Kicker")<200,15) then
--             return "paowei"
--                 elseif bufcnt(true,max) then
--             return "exit"
--      end
--        end,
--        Kicker = task.goCmuRushB(centerPos[2]),
--        Leader = task.CrossOverKick("Leader",centerPos[7],150,flag),
--        Middle = task.goCmuRushB(centerPos[4]),
--        Receiver = task.mydef(0.4),
--        Tier = task.marking(-3200,-1500,0,1000,bx2),
--        Goalie = task.goalie(),
--        match = ""
-- },
-- ["paowei"] = {
--        switch = function()
--               if bufcnt(player.toTargetDist("Kicker")<10,20) then
--             return "chuan"
--                      elseif bufcnt(true,max) then
--             return "exit"
--      end
--        end,
--        Kicker = task.goCmuRushB(centerPos[1]),
--        Leader = task.readyforpass("Leader","Kicker"),
--        Middle = task.goCmuRushB(centerPos[4]),
--        Receiver = task.mydef(0.4),
--        Tier = task.marking(-3200,-1500,0,1000,bx2),
--        Goalie = task.goalie(),
--        match = ""
-- },
["chuan"] = {
       switch = function()
              if player.kickBall("Kicker")  or ball.velMod()>2000 then
            return "rec"
                     elseif bufcnt(true,max) then
            return "exit"
     end
       end,
       Receiver = task.goCmuRushB(dq6),
       Kicker = task.passballV1("Kicker","Receiver"),
       Middle = task.goCmuRushB(dq7),
       Defender = task.mydef(0.4),
       Tier = task.marking(-3200,-1500,0,1000,bx2),
       Goalie = task.goalie(),
       match = ""
},
["rec"] = {
       switch = function()
              if bufcnt(player.toBallDist("Receiver")<200,20) then
            return "pass"
               elseif bufcnt(true,max) then
            return "exit"
     end
       end,
       Receiver = task.recballV1("Receiver"),--touchKick(),
       Kicker = task.goCmuRushB(centerPos[3]),
       Middle = task.goCmuRushB(centerPos[5]),
       Defender = task.mydef(0.4),
       Tier = task.marking(-3200,-1500,0,1000,bx2),
       Goalie = task.goalie(),
       match = ""
},
["pass"] = {
       switch = function()
              if player.kickBall("Receiver") or ball.velMod()>2000 then
            return "rec2"
               elseif bufcnt(true,max) then
            return "exit"
     end
       end,
       Receiver = task.passballV1("Receiver","Middle"),--touchKick(player.pos("Middle")),--touchKick(),
       Kicker = task.goCmuRushB(centerPos[3]),
       Middle = task.goCmuRushB(centerPos[5]),--touchKick(),
       Defender = task.mydef(0.4),
       Tier = task.marking(-3200,-1500,0,1000,bx2),
       Goalie = task.goalie(),
       match = ""
},
["rec2"] = {
       switch = function()
              if bufcnt(player.toBallDist("Middle")<200,20) then
            return "shoot"
             elseif bufcnt(true,max) then
            return "exit"
     end
       end,
       Receiver = task.goCmuRushB(centerPos[6]),--touchKick(),
       Kicker = task.goCmuRushB(centerPos[3]),
       Middle = task.recballV1("Middle"),
       Defender = task.mydef(0.4),
       Tier = task.marking(-3200,-1500,0,1000,bx2),
       Goalie = task.goalie(),
       match = ""
},
["shoot"] = {
       switch = function()
              if player.kickBall("Middle") or ball.velMod()>2000 or bufcnt(true,max) then
            return "exit"
     end
       end,
       Receiver = task.goCmuRushB(centerPos[6]),--touchKick(),
       Kicker = task.goCmuRushB(centerPos[3]),
       Middle = task.smartshootV1("Middle"),
       Defender = task.mydef(0.4),
       Tier = task.marking(-3200,-1500,0,1000,bx2),
       Goalie = task.goalie(),
       match = ""
},

["Lshoot"] = {
       switch = function()
              if player.kickBall("Kicker") or ball.velMod()>2000 or bufcnt(true,max) then
                     return "exit"
              end
       end,
       Receiver = task.goCmuRushB(centerPos[6]),--touchKick(),
       Kicker = task.smartshootV1("Kicker"),
       Middle = task.goCmuRushB(centerPos[3]),
       Defender = task.mydef(0.4),
       Tier = task.marking(-3200,-1500,0,1000,bx2),
       Goalie = task.goalie(),
       match = ""
},

name = "Ref_KickOffV1",
applicable = {
       exp = "a",
       a = true
},
attribute = "attack",
timeout = 99999
}    