
local centerPosD ={
CGeoPoint:new_local(4500,0),
CGeoPoint:new_local(0,0),
CGeoPoint:new_local(1000,2000),
CGeoPoint:new_local(2300,1800),
CGeoPoint:new_local(3400,-1000),
CGeoPoint:new_local(2000,-900),
CGeoPoint:new_local(1000,0),
}

local centerPos ={
CGeoPoint:new_local(4500,0),
CGeoPoint:new_local(0,0),
CGeoPoint:new_local(1000,-2000),
CGeoPoint:new_local(2300,-1800),
CGeoPoint:new_local(3400,1000),
CGeoPoint:new_local(2000,900),
CGeoPoint:new_local(1000,0),
}
local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
local bx2=CGeoPoint:new_local(-2700,-800)  --后场右边  baoxianwei
local bx3=CGeoPoint:new_local(-1800,1400)

angle = 90
radius = 2500
speed = 1/40
local tiancai = function(n,pos)
     return function()
        ipos = pos
        if type(pos) == 'function' then
            ipos = pos()
        else
            ipos = pos
        end
        local centerX = ipos:x()
        local centerY = ipos:y()
        return CGeoPoint:new_local(centerX + radius * math.cos(angle+ n*math.pi*2),centerY + radius * math.sin(angle+ n*math.pi*2))
     end
 end
 local PosIn = function(R,angle)
    return function()
       return CGeoPoint:new_local(4500 - R * math.sin(angle),R * math.cos(angle))
    end
 end
 local i = function(p)
   return function()
    return ball.pos() + Utils.Polar2Vector(100, math.pi/4)
   end
end
gPlayTable.CreatePlay{

firstState = "judge_pos",

["judge_pos"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"fkjw",4)
     if  ball.posY() > 0 then
           return"1U"  
        else
           return "1D"    
 end
end,
       Kicker   = task.goCmuRushB(PosIn(radius,120)),
       Leader   = task.goCmuRushB(i(player.pos("Leader"))),
       Middle   = task.goCmuRushB(centerPos[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = "{G}[LKTRM]"
},

["1U"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
              if bufcnt(player.toTargetDist("Leader")<200,20) then
            return "2"
     end
     angle = angle +math.pi*2/60*speed
       end,
       Kicker   = task.goCmuRushB(PosIn(radius,120)),
       Leader   = task.goCmuRushB(i(player.pos("Leader"))),
       Middle   = task.goCmuRushB(centerPos[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},

["2"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
              if bufcnt(player.toTargetDist("Leader") < 200 and player.toTargetDist("Kicker")<200,20) then
            return "big"
              elseif bufcnt(true,200) then
            return "exit"
     end
     angle = angle +math.pi*2/60*speed
       end,
       Kicker = task.goCmuRushB(tiancai(1,centerPos[1])),
       Leader = task.goCmuRushB(i(player.pos("Leader"))),
       Middle = task.goCmuRushB(centerPos[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["big"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3) > 150 then


            -- elseif bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") > -1,15 ) then
            --     return "8"
        --     end
        --   -- if bufcnt(checkshoot("Kicker") > -1,15 ) then
        --   --       return "9"--8"
        --   --   end
        -- --radius = radius + 80
            return "5"
         -- elseif bufcnt(true,300) then
         --    return "exit"
        end
        --  -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") == -1,15 ) then
        --  --        return "5"
         -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1,15) then --and checkshoot("Kicker") > -1,15 ) then
         --        return "8"
         --    end
        -- elseif bufcnt(true,120) then
        --     return "exit"
        -- end
        angle = angle +math.pi*2/60*speed
    end,

       Kicker = task.goCmuRushB(tiancai(1,centerPos[1])),
       Leader = task.getballV2("Leader"),
       Middle = task.goCmuRushB(centerPos[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["4"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3) < 120 then
         -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") == -1,15 ) then
         --        return "5"
         -- elseif bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") > -1,15 ) then
         --        return "8"
         --    end
           -- if bufcnt(checkshoot("Kicker") > -1,15 ) then
           --      return "9"--8"
           --  end
          --radius = radius + 80
            return "8"
        --  elseif bufcnt(true,120) then
        --     return "exit"
        -- end
        -- if task.pass_is_break("Kicker","Leader") == -1 then
        --     return "5"
        -- elseif bufcnt(true,300) then
        --     return "exit"
          end
        -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1,15) then-- and checkshoot("Kicker") > -1,15 ) then
        --         return "8"
        --     end
        angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(tiancai(1,centerPos[1])),
       Leader = task.getballV2("Leader"),
       Middle = task.goCmuRushB(centerPos[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},

["5"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Leader") or ball.velMod()>2000 then
         -- if bufcnt(checkshoot("Kicker") == -1,15 ) then -- task.pass_is_break("Kicker","Leader") == -1 and
         --        return "6"
            -- if bufcnt(checkshoot("Kicker") > -1,15 ) then
            --     return "9"--8"
            -- end
            return "9"
        elseif bufcnt(true,120) then
            return "exit"
        end
    end,
       Kicker = task.stop(),--goCmuRushB(player.pos("Kicker")),--touchKick(PosOut("Kicker"),false),
       Leader = task.passballV1("Leader","Kicker"),
       Middle = task.goCmuRushB(centerPos[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["9"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toBallDist("Kicker")<200,20) then
            return "99"
        elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle + math.pi*2/60*speed
    end,
       Kicker = task.recballV1("Kicker"),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--"Defender"))),
       Middle = task.goCmuRushB(centerPos[4]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["99"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Kicker") or bufcnt(ball.velMod()>2000,5) then--task.pass_is_break("Kicker","Leader") == -1 and judge("Kicker",centerPos[1]) == 0 then
            return "10"
        elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.passballV1("Kicker","Middle"),--getballV2("Kicker"),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--task.goCmuRushB(tiancai(1,player.pos("Kicker"))),
       Middle = task.goCmuRushB(centerPos[4]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["10"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toBallDist("Middle")<200,20) then
            return "11"
         elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(centerPos[6]),--quickpass("Kicker","Leader"),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.recballV1("Middle"),--goCmuRushB(centerPos[4]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["11"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toBallDist("Middle")<200,20) then
            return "12"
        elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(centerPos[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.getballV2("Middle"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["12"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Middle") or bufcnt(ball.velMod()>2000,5) then--player.kickBall("Kicker") or ball.velMod()>2000 then
            return "13"
          elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(centerPos[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.passballV1("Middle","Kicker"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["13"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt( player.toBallDist("Kicker")<200,20) then
            return "14"
        elseif bufcnt(true,200) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.recballV1("Kicker"),--touchKick(),--goCmuRushB(centerPos[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.goCmuRushB(centerPos[1]),--passballV1("Middle","Kicker"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["14"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Middle") or ball.velMod()>2000 or bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.smartshootV1("Kicker"),--touchKick(),--goCmuRushB(centerPos[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.goCmuRushB(centerPos[1]),--passballV1("Middle","Kicker"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["1D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPosD[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
              if bufcnt(player.toTargetDist("Leader")<200,20) then
            return "2D"
     end
     --angle = angle +math.pi*2/60*speed
       end,
       Kicker   = task.goCmuRushB(PosIn(radius,150)),
       Leader   = task.goCmuRushB(i(player.pos("Leader"))),--readyforpass("Leader","Kicker"),--goCmuRushB(i(player.pos("Leader"))),
       Middle   = task.goCmuRushB(centerPosD[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = "{G}[LTKRM]"
},

["2D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
              if bufcnt(player.toTargetDist("Leader") < 200 and player.toTargetDist("Kicker")<200,20) then
            return "bigD"
              elseif bufcnt(true,200) then
            return "exit"
     end
     angle = angle + math.pi*2/60*speed
       end,
       Kicker = task.goCmuRushB(tiancai(1,centerPosD[1])),
       Leader = task.readyforpass("Leader","Kicker"),--goCmuRushB(i(player.pos("Leader"))),
       Middle = task.goCmuRushB(centerPosD[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["bigD"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if math.ceil((player.pos("Kicker") - centerPosD[1]):dir()*57.3) > 170 then 


            -- elseif bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") > -1,15 ) then
            --     return "8"
        --     end
        --   -- if bufcnt(checkshoot("Kicker") > -1,15 ) then
        --   --       return "9"--8"
        --   --   end
        -- --radius = radius + 80
            return "4D"
         -- elseif bufcnt(true,300) then
         --    return "exit"
        end
        --  -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") == -1,15 ) then
        --  --        return "5"
         -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1,15) then --and checkshoot("Kicker") > -1,15 ) then
         --        return "8"
         --    end
        -- elseif bufcnt(true,120) then
        --     return "exit"
        -- end
        angle = angle - math.pi*2/60*speed
    end,

       Kicker = task.goCmuRushB(tiancai(1,centerPosD[1])),
       Leader = task.readyforpass("Leader","Kicker"),--getballV2("Leader"),
       Middle = task.goCmuRushB(centerPosD[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["4D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toTargetDist("Kicker")<200,20) then 
         -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") == -1,15 ) then
         --        return "5"
         -- elseif bufcnt( task.pass_is_break("Kicker","Leader") == -1 and checkshoot("Kicker") > -1,15 ) then
         --        return "8"
         --    end
           -- if bufcnt(checkshoot("Kicker") > -1,15 ) then
           --      return "9"--8"
           --  end
         --radius = radius + 80
            return "5D"
        --  elseif bufcnt(true,120) then
        --     return "exit"
        -- end
        -- if task.pass_is_break("Kicker","Leader") == -1 then
        --     return "5"
        -- elseif bufcnt(true,300) then
        --     return "exit"
         end
        -- if bufcnt( task.pass_is_break("Kicker","Leader") == -1,15) then-- and checkshoot("Kicker") > -1,15 ) then
        --         return "8"
        --     end
        --angle = angle + math.pi*2/60*speed
    end,
       Kicker = task.goCmuRush(centerPosD[6]),--tiancai(1,centerPos[1])),
       Leader = task.getballV2("Leader"),
       Middle = task.goCmuRushB(centerPosD[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},

["5D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Leader") or ball.velMod()>2000 then 
         -- if bufcnt(checkshoot("Kicker") == -1,15 ) then -- task.pass_is_break("Kicker","Leader") == -1 and 
         --        return "6"
            -- if bufcnt(checkshoot("Kicker") > -1,15 ) then
            --     return "9"--8"
            -- end
            return "9D"
        elseif bufcnt(true,120) then
            return "exit"
        end
    end,
       Kicker = task.goCmuRushB(centerPosD[6]),--stop(),--goCmuRushB(player.pos("Kicker")),--touchKick(PosOut("Kicker"),false),
       Leader = task.passballV1("Leader","Kicker"),
       Middle = task.goCmuRushB(centerPosD[3]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["9D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toBallDist("Kicker")<200,20) then 
            return "99D"
        elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle + math.pi*2/60*speed
    end,
       Kicker = task.recballV1("Kicker"),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--"Defender"))),
       Middle = task.goCmuRushB(centerPosD[4]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["99D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Kicker") or bufcnt(ball.velMod()>2000,5) then--task.pass_is_break("Kicker","Leader") == -1 and judge("Kicker",centerPos[1]) == 0 then 
            return "10D"
        elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.passballV1("Kicker","Middle"),--getballV2("Kicker"),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--task.goCmuRushB(tiancai(1,player.pos("Kicker"))),
       Middle = task.goCmuRushB(centerPosD[4]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["10D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toBallDist("Middle")<200,20) then 
            return "11D"
         elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(centerPosD[6]),--quickpass("Kicker","Leader"),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.recballV1("Middle"),--goCmuRushB(centerPos[4]),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["11D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt(player.toBallDist("Middle")<200,20) then 
            return "12D"
        elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(centerPosD[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.getballV2("Middle"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["12D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Middle") or bufcnt(ball.velMod()>2000,5) then--player.kickBall("Kicker") or ball.velMod()>2000 then 
            return "13D"
          elseif bufcnt(true,120) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.goCmuRushB(centerPosD[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.passballV1("Middle","Kicker"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["13D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if bufcnt( player.toBallDist("Kicker")<200,20) then 
            return "14D"
        elseif bufcnt(true,200) then
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.recballV1("Kicker"),--touchKick(),--goCmuRushB(centerPos[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.goCmuRushB(centerPosD[1]),--passballV1("Middle","Kicker"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
["14D"] = {
       switch = function()
        debugEngine:gui_debug_line(player.pos("Kicker"),centerPos[1])
        debugEngine:gui_debug_msg(centerPos[2],math.ceil((player.pos("Kicker") - centerPos[1]):dir()*57.3))
        debugEngine:gui_debug_msg(centerPos[3],math.ceil(player.toPointDist("Kicker",centerPos[1])))
        if player.kickBall("Middle") or ball.velMod()>2000 or bufcnt(true,120) then 
            return "exit"
        end
         angle = angle - math.pi*2/60*speed
    end,
       Kicker = task.smartshootV1("Kicker"),--touchKick(),--goCmuRushB(centerPos[6]),
       Leader = task.goCmuRushB(tiancai(1,enemy.pos(0))),--player.pos("Kicker"))),
       Middle = task.goCmuRushB(centerPosD[1]),--passballV1("Middle","Kicker"),
       Receiver = task.mydef(0.4),
       Tier     = task.marking(-3200,-1500,0,1000,bx2),
       Goalie   = task.goalie(),
       match = ""
},
name = "Ref_CornerKickV0",
applicable = {
       exp = "a",
       a = true
},
attribute = "attack",
timeout = 99999
}       