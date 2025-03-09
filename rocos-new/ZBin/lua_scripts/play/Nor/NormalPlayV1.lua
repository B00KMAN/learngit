--        1526-1740 以多打少
-- local mypasspower = 4000
-- -------------------------debug角球点1----------------------
-- local lj1=CGeoPoint:new_local(-2000,1100)
-- local lj2=CGeoPoint:new_local(-2000,2800)
-- local lj3=CGeoPoint:new_local(-4000,2800)
-- local lj4=CGeoPoint:new_local(-4000,1100)
-- local ljf=CGeoPoint:new_local(-2800,1100)--角球防守点

-- local rj1=CGeoPoint:new_local(-2000,-1100)
-- local rj2=CGeoPoint:new_local(-2000,-2800)
-- local rj3=CGeoPoint:new_local(-4000,-2800)
-- local rj4=CGeoPoint:new_local(-4000,-1100)
-- local rjf=CGeoPoint:new_local(-2800,-1100)--角球防守点
-- -----------------------baoxain-------------------------------------
-- local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
-- local bx2=CGeoPoint:new_local(-2700,-800)  --后场右边  baoxianwei

-- local bx3=CGeoPoint:new_local(700,1500)  --zhong chang zuo边 baoxianwei
-- local bx4=CGeoPoint:new_local(700,-1500)  --zhongchang youbian baoxianwei
-- -------------------------debug禁区前1-----------------------
-- local jq1=CGeoPoint:new_local(-3500,-1500)
-- local jq2=CGeoPoint:new_local(-3500,1500)
-- local jq3=CGeoPoint:new_local(-1000,1500)
-- local jq4=CGeoPoint:new_local(-1000,-1500)
-- local jqf1=CGeoPoint:new_local(-2800,-300)--禁区防守点
-- local jqf2=CGeoPoint:new_local(-2800,300) --禁区防守点
-- ---------------------212----------------------------------
-- local p1=CGeoPoint:new_local(3000,1500)  --前场右边
-- local p2=CGeoPoint:new_local(3000,-1500) --前场左边
-- local p3=CGeoPoint:new_local(2000,0)     --中场

-- local p31=CGeoPoint:new_local(1000,-2000) --中场1
-- local p32=CGeoPoint:new_local(1000,2000)  --中场2

-- local p4=CGeoPoint:new_local(-1000,-800) --后场左边
-- local p5=CGeoPoint:new_local(-1000,800)  --后场右边

-- local p6=CGeoPoint:new_local(2500,0)    --前场zhongjian

-- local rsl=CGeoPoint:new_local(3000,1000)  --后场左边
-- local rsr=CGeoPoint:new_local(3000,-1000)  --后场右边
-- ----------------------------bk---dianwei-----------
-- local pR1 = CGeoPoint:new_local(2500,-1500)     
-- local pR2 = CGeoPoint:new_local(1800,-1700)
-- local pR3 = CGeoPoint:new_local(2300,-2000)  

-- local pM1 = CGeoPoint:new_local(2500,1500)     
-- local pM2 = CGeoPoint:new_local(3000,1700)  
-- local pM3 = CGeoPoint:new_local(2300,2000)  

-- local pK1 = CGeoPoint:new_local(1800,0)  
-- local pK2 = CGeoPoint:new_local(2500,0)  
-- local pT1 = CGeoPoint:new_local(-2800,-2000)  
-- local pD1 = CGeoPoint:new_local(-2800,2000)  

-- local shootGen = function(dist)
--         return function()
--                 local goalPos = CGeoPoint(param.pitchLength/2,0)
--                 local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
--                 return pos
--         end
-- end
-- --------------------judge kick or def-------------------------
-- local judge =function()
--         local num =-1
--             for i=0,param.maxPlayer-1 do
--                 if ball.toPointDist(enemy.pos(i))<220 then 
--                          return i       
--                 end
--             end 
--       return num   
--         end

-- local judgeus =function()
--         local num =-1
--             for i=0,param.maxPlayer-1 do
--                 if ball.toPointDist(player.pos(i))<220 then 
--                          return i       
--                 end
--             end 
--       return num   
--         end        
-- ------------------------can pass shoot----------------------------------------
-- local checkpass= function(role1,role2)
--         local num =-1
--           for i = 0,param.maxPlayer-1 do     
--              local theirdist=function(role)
--                 return  math.sqrt(math.pow(enemy.posX(i)-player.posX(role),2)+math.pow(enemy.posY(i)-player.posY(role),2))
--              end 
--              local ourdist= function()
--                 return  player.toPlayerDist(role1,role2)
--              end
--                local length = function()
--                    if theirdist(role1)+ theirdist(role2) > 1.005* ourdist() then
--                       return false
--                    else 
--                       return true
--                 end
--                 end

--                 if enemy.valid(i) and length() then
--                       return i
--                 end 
--           end
--              return num
--         end

-- local checkshoot= function(role1)
--         local num =-1
--         local theirgoal = CGeoPoint:new_local(param.pitchLength/2.0,0)
--           for i = 0,param.maxPlayer-1 do 
--              local theirdir =function()
--               return  (enemy.pos(i)- theirgoal):dir()
--              end   
--              local ourdir =function()
--               return  (player.pos(role1)- theirgoal):dir()
--              end   
--              local theirdist=function()
--                 return  math.sqrt(math.pow(enemy.posX(i)-4500,2)+math.pow(enemy.posY(i),2))
--              end 
--              local ourdist= function()
--                 return  player.toTheirGoalDist(role1)
--              end
--              local length = function()
--                    if theirdist() < ourdist() and theirdist() > 1000 and math.abs(theirdir()-ourdir()) < 0.2 then
--                       return true
--                    else 
--                       return false
--                    end
--                 end

--                 if enemy.valid(i) and length() then
--                       return i
--                 end 
--           end
--              return num
--         end
-- ---------------------------------------------------------------------------------------------------------------
-- gPlayTable.CreatePlay{
-- firstState = "judge",
-- ["judge"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"judge is "..judge(),4)
-- if judge()>-1  then                
--         if ball.posX()>1000 then
--            return "fd" 
--         elseif ball.posX()<-1000 then 
--            return "bd" 
--         else   
--            return "md"  
--         end   
--  end
 
-- if judge()==-1 then   
--         if ball.posX()>1000 then
--            return "fk_judge_who" 
--         elseif ball.posX()<-1000 then 
--            return "bk_judge_who" 
--         else   
--            return "bk_judge_who"  
--         end        
--  end    
-- end,
--         ["Kicker"]   = task.stop(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.goCmuRushB(p2),
--         ["Receiver"] = task.goCmuRushB(p3),
--         ["Defender"] = task.goCmuRushB(p4),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },
-- ----------------------------------------------Def-------------------------------------------------------
-- ["fd"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"FrontDef",5) 
--    debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2800),"judgeus is"..judgeus(),4) 
--      debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2600),"infraredCount is"..player.infraredCount("Kicker"),4)
--         debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2400),"judge is"..judge(),4)  
-- if bufcnt(player.infraredCount("Kicker") > 1, 40)  or bufcnt (judge()==-1,80) and bufcnt(judgeus()~=-1,40) then
--          return "judge"
--         end               
--     if ball.posX()>1000 then
--            return "fd" 
--     elseif ball.posX()<-1000 then 
--            return "bd" 
--     else   
--            return "md"  
--     end          
-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(p6),
--         ["Tier"]     = task.mydef(0.5),
--         ["Receiver"] = task.marking(-3500,-1000,-3000,0,jqf1),   --禁区
--         ["Defender"] = task.marking(-3500,-1000,0,3000,jqf2),    --禁区
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },

-- ["md"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"MiddleDef",5) 
--    debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2800),"judgeus is"..judgeus(),4)
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2600),"infraredCount is"..player.infraredCount("Kicker"),4)
--        debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2400),"judge is"..judge(),4)   
-- if bufcnt(player.infraredCount("Kicker") > 1, 40)  or bufcnt (judge()==-1,80) and bufcnt(judgeus()~=-1,40) then
--          return "judge"
--         end           
--  if bufcnt (judge()>-1,5)  then                
--         if ball.posX()>1000 then
--            return "fd" 
--         elseif ball.posX()<-1000 then 
--            return "bd" 
--         else   
--            return "md"  
--         end   
--  end
          
--   end,         
--         ["Kicker"]   = task.getballV2("Kicker"),
--         ["Middle"]  = task.mydef(0.6),
--         ["Tier"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Receiver"] = task.mydef(0.4),
--         ["Defender"]  = task.marking(-3200,-1500,0,1000,bx2),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },

-- ["bd"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"BackDef",5) 
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2800),"judgeus is"..judgeus(),4) 
--      debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2600),"infraredCount is"..player.infraredCount("Kicker"),4) 
--         debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2400),"judge is"..judge(),4) 
--  if bufcnt(player.infraredCount("Kicker") > 1, 40)  or bufcnt (judge()==-1,80) and bufcnt(judgeus()~=-1,40) then
--          return "judge"
--         end       
--  if judge()>-1 then                
--         if ball.posX()>1000 then
--            return "fd" 
--         elseif ball.posX()<-1000 then 
--            return "bd" 
--         else   
--            return "md"  
--         end   
--  end
          
-- end,
--     Kicker   = task.smartshootV1("Kicker"),
--     Tier     = task.marking(-4000,-2000,-2800,-1100,rjf),--右脚球区
--     Middle   = task.marking(-4000,-2000,1100,2800,ljf),  --左脚球区
--     Defender = task.marking(-3500,-1000,-1500,0,jqf1),   --禁区
--     Receiver = task.marking(-3500,-1000,0,1500,jqf2),    --禁区
--     Goalie   = task.goalie(),
--     match = "{G}[KMTRD]"
-- },
-- ---------------------------------------------fk-------------------------------------------------------
-- ["fk_judge_who"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"fkjw",4)
--      if ball.posX() > 3000 then
--         return "Lucky_Shoot"
--     elseif ball.posY() > 0 then
--            return"MK2L"  
--         else
--            return "MK2R"    
--  end
-- end,
--         ["Kicker"]   = task.readyforshoot(),--to p1 front
--        -- ["Kicker"]   = task.readyforshoot(),--to 1 front
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },

-- ["Lucky_Shoot"] = {
-- switch = function()
-- if bufcnt(player.toBallDist("Kicker")<220,50) then
--      return "Judge_IsLucky"
--         end
-- if bufcnt(true, 200) then
--     return "judge"
-- end

-- end,
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),               
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
     
-- },

-- ["Judge_IsLucky"] = {
-- switch = function()
-- if checkshoot("Kicker") > -1  then
--     return "ready2"
-- else
--     return "Lucky_Shoot_Ready"
--  end


-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),               
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
     
-- },

-- ["Lucky_Shoot_Ready"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"?",4)
--  if bufcnt(player.infraredCount("Kicker") > 1,30) then 
--         return "Lucky_Shoot_End"
--   end   
--     if bufcnt(true, 400) then
--     return "judge"
-- end

-- end,
--         ["Kicker"]   =  task.smartshootV1("Kicker"),   
--         ["Middle"]   =  task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },

-- ["Lucky_Shoot_End"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking",4)
--  if ball.velMod() > 3000 then 
--         return "judge"
--   end   
--     if bufcnt(true, 120) then
--     return "judge"
-- end

-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),   
--         ["Middle"]   =  task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[MTRDK]"
-- },

-- ---------------------------------------------mk----------------------------------------------------------
-- ["mk_judge_who"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"mkjw",4)
--     if ball.posY() > 0 then
--            return"MK2L"  
--         else
--            return "MK2R"    
--  end

-- end,
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KDTRM]"
-- },
-- ["MK2L"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking1",4)
--     if bufcnt(player.toTargetDist("Kicker") < 270, 40) then 
--        return"MK2LL"
--     end  
-- end,
--         ["Kicker"]   = task.readyforshoot(),--to p1 front
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK2LL"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking21",4)
--     if checkshoot("Kicker") == -1 then 
--        return"MK9"
--    else
--         return "MK21L"
--     end 
-- end,
--         ["Kicker"]   = task.passballV1("Kicker","Middle"),--to p1 front
--        -- ["Kicker"]   = task.readyforshoot(),--to 1 front
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK21L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
--  if player.kickBall("Kicker") then 
--         return"MK3L"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end
-- end,
--         ["Kicker"]   = task.passballV1("Kicker","Middle"),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK3L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking3",4)
--      if bufcnt(true,120) then
--         return "finish"
--       end 
--       if bufcnt(player.infraredCount("Middle")>1,5) then
--         return "MK4L"
--       end 
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
--         ["Middle"]   = task.recballV1("Middle"),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK4L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking4",4)
--      if checkshoot("Middle") == -1 then
--         return "MK5L"
--     else
--         return "PassBallL"
--         end
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
--         ["Middle"]   = task.readyforshoot(),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["PassBallL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking5",4)
--  if player.kickBall("Middle") then 
--         return "MK6L"
--     end
--      if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    
--         ["Middle"]   = task.passballV1("Middle","Receiver"),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["PassBall1L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking6",4)
--  if player.kickBall("Receiver") then 
--         return "rkr"
--     end
--      if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),   
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.passballV1("Receiver","Kicker"),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["rkr"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking7",4)
     
--       if bufcnt(player.infraredCount("Kicker")>1,5) then
--         return "ks"
--       end 
--        if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.recballV1("Kicker"),    ---ding shang qv
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["ks"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking8",4)
--      if checkshoot("Kicker") == -1 then
--         return "MK9"
--     else
--         return "ready"
--      end
-- end,
--         ["Kicker"]   = task.readyforshoot(),   ---ding shang qv
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK6L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking9",4)
--       if bufcnt(player.infraredCount("Receiver")>1,5) then
--         return "MK7L"
--       end 
--     if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.recballV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK7L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking10",4)
--      if checkshoot("Receiver") == -1 then
--         return "MK8L"
--     else
--         return "PassBall1L"
--         end
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),   ---ding shang qv
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.readyforshoot(), 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK5L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking11",4)
--  if player.kickBall("Middle") then 
--         return "finish"
--   end   
-- if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
--         ["Middle"]   =  task.smartshootV1("Middle"),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK8L"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking12",4)
--  if player.kickBall("Receiver") then 
--         return "finish"
--   end   
--     if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),   ---ding shang qv
--         ["Middle"]   =  task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.smartshootV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK9"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking13",4)
--  if player.kickBall("Kicker") then 
--         return "finish"
--        --  return "finish"
--   end   
--     if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),   ---ding shang qv
--         ["Middle"]   =  task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["ready"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking14",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
-- if bufcnt(player.toBallDist("Kicker")<200,30) then
--                         return "ready2"
--                 end
-- if bufcnt(true, 100) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.getballV2("Kicker"),--to p32 middle"Kicker","Receiver"
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
     
-- },
-- ["ready2"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking15",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if bufcnt(player.toBallDist("Kicker")<200,30) then
--                         return "ready3"
--                 end
-- if bufcnt(true, 100) then
--     return "finish"
-- end

-- end,
       
--         ["Kicker"]   = task.readyforshoot(),--to p32 middle
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
       
-- },



-- ["MK2R"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking20",4)
--     if bufcnt(player.toTargetDist("Kicker") < 250, 40) then 
--        return"MK2RR"
--     end 
-- end,
--         ["Kicker"]   = task.readyforshoot(),--to p1 front
--        -- ["Kicker"]   = task.readyforshoot(),--to 1 front
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),           
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK2RR"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking21",4)
--     if checkshoot("Kicker") == -1 then 
--        return"MK9"
--    else
--         return "MK21R"
--     end 
-- end,
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),               
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK21R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking22",4)
--  if player.kickBall("Kicker") then 
--         return"MK3R"  
--  end
-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),               
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK3R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking23",4)
     
--      if bufcnt(true,120) then
--         return "finish"
--       end 
--       if bufcnt(player.infraredCount("Receiver")>1,5) then
--         return "MK4R"
--       end 
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.recballV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK4R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking24",4)
--      if checkshoot("Receiver") == -1 then
--         return "MK5R"
--     else
--         return "PassBallR"
--         end
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.readyforshoot(),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["PassBallR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking25",4)
--  if player.kickBall("Receiver") then 
--         return "MK6R"
--     end
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.smartshootV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["PassBall1R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking26",4)
--  if player.kickBall("Middle") then 
--         return "rkr"
--     end
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    
--         ["Middle"]   = task.passballV1("Middle","Kicker"),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK6R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking27",4)
--       if bufcnt(player.infraredCount("Middle")>1,5) then
--         return "MK7R"
--       end 
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),   
--         ["Middle"]   = task.recballV1("Middle"),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK7R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking28",4)
--      if checkshoot("Middle") == -1 then
--         return "MK8R"
--     else
--         return "PassBall1R"
--         end
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),   
--         ["Middle"]   = task.readyforshoot(),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK5R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking29",4)
--  if player.kickBall("Receiver") then 
--         return "finish"
--   end   
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),    
--         ["Middle"]   =  task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.smartshootV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["MK8R"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking30",4)
--  if player.kickBall("Middle") then 
--         return "finish"
--   end   
-- end,
--         ["Kicker"]   = task.goCmuRushB(p6),   
--         ["Middle"]   =  task.smartshootV1("Middle"),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },
-- --------------------------------------------------bk----------------------------------------------------

-- ["bk_judge_who"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking1",4)
--  if ball.posY() > 0  then 
--     return"bk_judge_IsPassL"  
--  else
--     return "bk_judge_IsPassR"    
--  end
-- end,
--         ["Kicker"]   = task.readyforpass("Kicker","Middle"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_judge_who"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking1",4)
--  if ball.posY() > 0  then 
--     return"bk_judge_IsPassL"  
--  else
--     return "bk_judge_IsPassR"    
--  end
-- end,                                                  
--         ["Kicker"]   = task.readyforpass("Kicker","Receiver"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_judge_IsPassL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking2",4)
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)

--  if checkpass("Kicker", "Receiver") > -1  then 
--     return"bk_BackPass_L1"  
--  else
--     return "bk2aL"    
--  end
-- if bufcnt(true, 180) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.readyforpass("Kicker","Receiver"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_L1"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking3",4)
--   debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)

--  if bufcnt(player.infraredCount("Kicker") > 1,5) then 
--         return "bk_BackPass_L2"
--    end
-- if bufcnt(true, 120) then
--     return "finish"
-- end
-- end,
--         ["Kicker"]   = task.passballV1("Kicker","Tier"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.goCmuRushB(pT1),
--         ["Receiver"] = task.goCmuRushB(pR1),               
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_L2"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking4",4)
--  if player.kickBall("Kicker") then 
--         return"bk_BackPass_L3"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,

--         ["Kicker"]   = task.passballV1("Kicker","Tier"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.goCmuRushB(pT1),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_L3"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking5",4)
--  if bufcnt(player.infraredCount("Tier") > 1,5) then 
--         return"bk_BackPass_L4"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,

--         ["Kicker"]   = task.goCmuRushB(pK1),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.recballV1("Tier"),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_L4"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking6",4)
--  if player.kickBall("Tier") then 
--         return"bk4aL"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,

--         ["Kicker"]   = task.goCmuRushB(pK1),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.passballV1("Tier","Receiver"),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_judge_IsPassR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking7",4)
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)

--  if checkpass("Kicker", "Middle") > -1  then 
--     return"bk_BackPass_R1"  
--  else
--     return "bk2aR"    
--  end
-- if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.readyforpass("Kicker","Middle"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_R1"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking8",4)
--   debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)

--  if bufcnt(player.infraredCount("Kicker") > 1,5) then 
--         return "bk_BackPass_R2"
--    end
-- if bufcnt(true, 120) then
--     return "finish"
-- end
-- end,
--         ["Kicker"]   = task.recballV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),               
--         ["Defender"] = task.goCmuRushB(pD1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_R2"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking9",4)
--  if player.kickBall("Kicker") then 
--         return"bk_BackPass_R3"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,

--         ["Kicker"]   = task.passballV1("Kicker","Defender"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.goCmuRushB(pD1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_R3"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking10",4)
--  if bufcnt(player.infraredCount("Defender") > 1,5) then 
--         return"bk_BackPass_R4"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,

--         ["Kicker"]   = task.goCmuRushB(pK1),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.recballV1("Defender"),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk_BackPass_R4"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,3000),"backkicking11",4)
--  if player.kickBall("Defender") then 
--         return"bk4aR"  
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,

--         ["Kicker"]   = task.goCmuRushB(pK1),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.passballV1("Defender","Middle"),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk2aL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking12",4)
--    if bufcnt(player.toTargetDist("Kicker") < 185, 20) then
--         return "bk3aL"
--    end
--    if bufcnt(true, 120) then
--     return "finish"
--    end
-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk3aL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking13",4)
--  if player.kickBall("Kicker") then 
--             return"bk4aL"  
--  end
-- if bufcnt(true, 120) then
--     return "finish"
--    end

-- end,

--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                 
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk4aL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking14",4)     
--       if bufcnt(player.infraredCount("Receiver") > 1,5) then
--         if checkshoot("Receiver") > -1  then
--             return "bk5aL_backpassToKicker"
--         else
--             return "bk5aL"
--       end
--   end
--     if bufcnt(true, 100) then
--     return "finish"
--    end
 
-- end,
--         ["Kicker"]   = task.goCmuRushB(pK1),   
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.recballV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk5aL_backpassToKicker"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking15",4)
--  if player.kickBall("Receiver") then 
--         return"bk5aL_backpassKicker_recball"  
--  end
-- if bufcnt(true, 90) then
--     return "finish"
--    end

-- end,

--         ["Kicker"]   = task.goCmuRushB(pK1),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.passballV1("Receiver","Kicker"),               
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk5aL_backpassKicker_recball"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking16",4)
--       if bufcnt(player.infraredCount("Kicker") > 1,5) then
--         return"ready3"  
--  end
-- if bufcnt(true, 90) then
--     return "finish"
--    end

-- end,

--         ["Kicker"]   = task.recballV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR3),              
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk5aL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking17",4)
--     if bufcnt(true,90) then
--         return"finish"
--     end
--     if bufcnt(player.toBallDist("Receiver")<180,30) then
--         return"bk6aL"
--         end
-- end,
--         ["Kicker"]   = task.goCmuRushB(pK1),    
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.readyforshoot(),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk6aL"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking18",4)
--  if player.kickBall("Receiver") then 
--         return "finish"
--   end   
--     if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(pK1),    
--         ["Middle"]   =  task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.smartshootV1("Receiver"),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },



-- ["bk2aR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking19",4)
--    if bufcnt(player.toTargetDist("Kicker") < 200, 20) then
--         return "bk3aR"
--    end
-- if bufcnt(true, 180) then
--     return "finish"
--    end

-- end,
--         ["Kicker"]   =  task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),               
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },


-- ["bk3aR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking20",4)
--  if player.kickBall("Kicker") then 
--         return"bk4aR"  
--  end
-- if bufcnt(true, 120) then
--     return "finish"
--    end

-- end,

--         ["Kicker"]   =  task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },


-- ["bk4aR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking21",4)
     
--       if bufcnt(player.infraredCount("Middle") > 1,5) then
--         if checkshoot("Middle") > -1  then
--             return "bk5aR_backpassToKicker"
--         else
--             return "bk5aR"
--       end
--   end
--     if bufcnt(true, 150) then
--     return "finish"
--    end
 
-- end,
--         ["Kicker"]   = task.goCmuRushB(pK1),    
--         ["Middle"]   = task.recballV1("Middle"),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk5aR_backpassToKicker"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking22",4)
--  if player.kickBall("Middle") then 
--         return"bk5aR_backpassKicker_recball"  
--  end
-- if bufcnt(true, 90) then
--     return "finish"
--    end

-- end,

--         ["Kicker"]   = task.goCmuRushB(pK1),
--         ["Middle"]   = task.passballV1("Middle","Kicker"),  
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),             
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk5aR_backpassKicker_recball"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking23",4)
--       if bufcnt(player.infraredCount("Kicker") > 1,5) then
--         return"ready3"  
--  end
-- if bufcnt(true, 90) then
--     return "finish"
--    end

-- end,

--         ["Kicker"]   = task.recballV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM3),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR3),              
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["bk5aR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking24",4)
--     if bufcnt(true,90) then
--         return"finish"
--     end
--     if bufcnt(player.toBallDist("Middle")<230,30) then
--         return"bk6aR"
--     end
-- end,
--         ["Kicker"]   = task.goCmuRushB(pK1),    
--         ["Middle"]   = task.readyforshoot(),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },
-- ["bk6aR"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking25",4)
--  if player.kickBall("Middle") then 
--         return "finish"
--        --  return "finish"
--   end   
--     if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,
--         ["Kicker"]   = task.goCmuRushB(pK1),    
--         ["Middle"]   =  task.smartshootV1("Middle"),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["ready3"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking26",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if ball.posY()>0   and  bufcnt(player.infraredCount("Kicker")>1,20) then   
--                         return"readyr"
--  end
-- if ball.posY()<=0   and  bufcnt(player.infraredCount("Kicker")>1,20) then   
--                         return"readyl"  
-- end   
--     if bufcnt(true, 120) then
--     return "judge"
-- end

-- end,
       
--         ["Kicker"]   = task.goCmuRush(shootGen(92),_,_,flag.dribbling),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
       
-- },

-- ["readyl"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking27",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if bufcnt(player.infraredCount("Kicker")>1,20) then
--                         return "shoot"
--                 end
-- end,
       
--         ["Kicker"]   = task.goCmuRush(rsl,_,1500,flag.dribbling),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
       
-- },

-- ["readyr"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking28",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if bufcnt(player.infraredCount("Kicker")>1,20) then
--                         return "shoot"
--                 end
-- end,
       
--         ["Kicker"]   = task.goCmuRush(rsr,_,1500,flag.dribbling),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["shoot"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking29",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if player.kickBall("Kicker") then 
--         return "finish"
-- end
-- end,
       
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
--  },

-- name = "NormalPlayV1",
-- applicable ={
--     exp = "a",
--     a = true
-- },
-- attribute = "attack",
-- timeout = 99999
-- }


-- -----------------------------------------------------------------------------------------------------------------------------------
-- local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
-- local bx2=CGeoPoint:new_local(-2700,-800)  --后场右边  baoxianwei


-- local p1=CGeoPoint:new_local(3000,1500)  --前场右边
-- local p2=CGeoPoint:new_local(3000,-1500) --前场左边
-- local p3=CGeoPoint:new_local(2000,0)     --中场

-- local pR1 = CGeoPoint:new_local(2500,-1500)     
-- local pR2 = CGeoPoint:new_local(1800,-1700)
-- local pR3 = CGeoPoint:new_local(2300,-2000)  

-- local pM1 = CGeoPoint:new_local(2500,1500)     
-- local pM2 = CGeoPoint:new_local(3000,1700)  
-- local pM3 = CGeoPoint:new_local(2300,2000)  

-- local pK1 = CGeoPoint:new_local(1800,0)  
-- local pK2 = CGeoPoint:new_local(2500,0)  

-- local pT1 = CGeoPoint:new_local(-2800,-2000)  
-- local pD1 = CGeoPoint:new_local(-2800,2000)  

-- local shootGen = function(dist)
--         return function()
--                 local goalPos = CGeoPoint(param.pitchLength/2,0)
--                 local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
--                 return pos
--         end
-- end

-- --------------------judge kick or def-------------------------
-- local judge =function()
--         local num =-1
--             for i=0,param.maxPlayer-1 do
--                 if ball.toPointDist(enemy.pos(i))<220 then 
--                          return i       
--                 end
--             end 
--       return num   
-- end
-- local judgeus =function()
--         local num =-1
--             for i=0,param.maxPlayer-1 do
--                 if ball.toPointDist(player.pos(i))<220 then 
--                          return i       
--                 end
--             end 
--       return num   
--         end  
-- ------------------------can pass shoot----------------------------------------
-- local checkpass= function(role1,role2)
--         local num =-1
--           for i = 0,param.maxPlayer-1 do     
--              local theirdist=function(role)
--                 return  math.sqrt(math.pow(enemy.posX(i)-player.posX(role),2)+math.pow(enemy.posY(i)-player.posY(role),2))
--              end 
--              local ourdist= function()
--                 return  player.toPlayerDist(role1,role2)
--              end
--                local length = function()
--                    if theirdist(role1)+ theirdist(role2) > 1.005* ourdist() then
--                       return false
--                    else 
--                       return true
--                 end
--                 end

--                 if enemy.valid(i) and length() then
--                       return i
--                 end 
--           end
--              return num
--         end

-- local checkshoot= function(role1)
--         local num =-1
--         local theirgoal = CGeoPoint:new_local(param.pitchLength/2.0,0)
--           for i = 0,param.maxPlayer-1 do 
--              local theirdir =function()
--               return  (enemy.pos(i)- theirgoal):dir()
--              end   
--              local ourdir =function()
--               return  (player.pos(role1)- theirgoal):dir()
--              end   
--              local theirdist=function()
--                 return  math.sqrt(math.pow(enemy.posX(i)-4500,2)+math.pow(enemy.posY(i),2))
--              end 
--              local ourdist= function()
--                 return  player.toTheirGoalDist(role1)
--              end
--              local length = function()
--                    if theirdist() < ourdist() and theirdist() > 1000 and math.abs(theirdir()-ourdir()) < 0.2 then
--                       return true
--                    else 
--                       return false
--                    end
--                 end

--                 if enemy.valid(i) and length() then
--                       return i
--                 end 
--           end
--              return num
--         end
-- ---------------------------------------------------------------------------------------------------------------

-- local judge_passball = function(role1,role2)
--     if ball.veldir() + math.pi/k > (player.pos(role2) - player.pos(role1)):dir() and ball.veldir() - math.pi/k < (player.pos(role2) - player.pos(role1)):dir() then
--   return true
--   else
--   return false
--   end
--         debugEngine:gui_debug_line(player.pos(role2), ball.pos(),4)

-- end
-- --------------------------------------------------------------------------------
-- gPlayTable.CreatePlay{
-- firstState = "judge_ctrl",
-- --firstState = "judge",
-- -----------------------------------------Def-------------------------------------------------------


-- ["judge_ctrl"] = {
-- switch = function()

--  if task.ball_is_ctrl() >= 0   then 
--     return"shoot0"  
--  else
--     return "getball"    
--  end
-- end,                                                 
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KTDRM]"
-- },

-- ["getball"] = {
-- switch = function()
--  if task.ball_is_ctrl() >= 0 then 
--     return"shoot0"     
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,                                                   
--         ["Kicker"]   = task.getballV2("Kicker"),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Receiver"] = task.goCmuRushB(pR1),
--         ["Goalie"]   = task.goalie(),
--       --  match = "{G}[KTD]"
--         match = "{G}[KTDRM]"
-- },


-- ["shoot0"] = {
-- switch = function()

--  if  bufcnt(player.toTargetDist("Kicker") < 200,10)then 
--     return "shoot1"    
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,                                                 
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KTDRM]"
-- },


-- ["shoot1"] = {
-- switch = function()

--  if  player.kickBall("Kicker") then 
--     return "finish"    
--  end
--  if bufcnt(true, 120) then
--     return "finish"
-- end

-- end,                                                 
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),               
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },


-- name = "NormalPlayV1",
-- applicable ={
--         exp = "a",
--         a = true
-- },
-- attribute = "attack",
-- timeout = 99999
-- }


----------------------------------------------------------------------------------------------------------------

local bx1=CGeoPoint:new_local(-3000,1500)  --后场zuo边 baoxianwei
local bx2=CGeoPoint:new_local(-3000,-1500)  --后场右边  baoxianwei


local p1=CGeoPoint:new_local(3000,1500)  --前场右边
local p2=CGeoPoint:new_local(3000,-1500) --前场左边
local p3=CGeoPoint:new_local(2000,0)     --中场

local pR1 = CGeoPoint:new_local(2500,-1500)     
local pR2 = CGeoPoint:new_local(1800,-1700)
local pR3 = CGeoPoint:new_local(2300,-2000)  

local pM1 = CGeoPoint:new_local(2500,1500)     
local pM2 = CGeoPoint:new_local(3000,1700)  
local pM3 = CGeoPoint:new_local(2300,2000)  

local pK1 = CGeoPoint:new_local(1800,0)  
local pK2 = CGeoPoint:new_local(2500,0)  

local pT1 = CGeoPoint:new_local(-2800,-2000)  
local pD1 = CGeoPoint:new_local(-2800,2000)  

local lj1=CGeoPoint:new_local(-4200,1200)
local lj2=CGeoPoint:new_local(-4200,2200)
local lj3=CGeoPoint:new_local(-2000,2200)
local lj4=CGeoPoint:new_local(-2000,1200)
local ljf=CGeoPoint:new_local(-2800,1100)--角球防守点

local rj1=CGeoPoint:new_local(-4200,-1200)
local rj2=CGeoPoint:new_local(-4200,-2200)
local rj3=CGeoPoint:new_local(-2000,-1200)
local rj4=CGeoPoint:new_local(-2000,-2200)
local rjf=CGeoPoint:new_local(-2800,-1100)--角球防守点
-------------------------debug禁区前-----------------------
local jq1=CGeoPoint:new_local(-3500,-1500)
local jq2=CGeoPoint:new_local(-3500,1500)
local jq3=CGeoPoint:new_local(-1000,1500)
local jq4=CGeoPoint:new_local(-1000,-1500)
local jqf1=CGeoPoint:new_local(-2800,-300)--禁区防守点
local jqf2=CGeoPoint:new_local(-2800,300) --禁区防守点

local shootGen = function(dist)
        return function()
                local goalPos = CGeoPoint(param.pitchLength/2,0)
                local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
                return pos
        end
end

--------------------judge kick or def-------------------------
local judge =function()
        local num =-1
            for i=0,param.maxPlayer-1 do
                if ball.toPointDist(enemy.pos(i))<220 then 
                         return i       
                end
            end 
      return num   
end
local judgeus =function()
        local num =-1
            for i=0,param.maxPlayer-1 do
                if ball.toPointDist(player.pos(i))<220 then 
                         return i       
                end
            end 
      return num   
        end  
------------------------can pass shoot----------------------------------------
local checkpass= function(role1,role2)
        local num =-1
          for i = 0,param.maxPlayer-1 do     
             local theirdist=function(role)
                return  math.sqrt(math.pow(enemy.posX(i)-player.posX(role),2)+math.pow(enemy.posY(i)-player.posY(role),2))
             end 
             local ourdist= function()
                return  player.toPlayerDist(role1,role2)
             end
               local length = function()
                   if theirdist(role1)+ theirdist(role2) > 1.005* ourdist() then
                      return false
                   else 
                      return true
                end
                end

                if enemy.valid(i) and length() then
                      return i
                end 
          end
             return num
        end

local checkshoot= function(role1)
        local num =-1
        local theirgoal = CGeoPoint:new_local(param.pitchLength/2.0,0)
          for i = 0,param.maxPlayer-1 do 
             local theirdir =function()
              return  (enemy.pos(i)- theirgoal):dir()
             end   
             local ourdir =function()
              return  (player.pos(role1)- theirgoal):dir()
             end   
             local theirdist=function()
                return  math.sqrt(math.pow(enemy.posX(i)-4500,2)+math.pow(enemy.posY(i),2))
             end 
             local ourdist= function()
                return  player.toTheirGoalDist(role1)
             end
             local length = function()
                   if theirdist() < ourdist() and theirdist() > 1000 and math.abs(theirdir()-ourdir()) < 0.2 then
                      return true
                   else 
                      return false
                   end
                end

                if enemy.valid(i) and length() then
                      return i
                end 
          end
             return num
        end
---------------------------------------------------------------------------------------------------------------

local judge_passball = function(role1,role2)
    if ball.veldir() + math.pi/k > (player.pos(role2) - player.pos(role1)):dir() and ball.veldir() - math.pi/k < (player.pos(role2) - player.pos(role1)):dir() then
  return true
  else
  return false
  end
        debugEngine:gui_debug_line(player.pos(role2), ball.pos(),4)

end

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
--------------------------------------------------------------------------------
gPlayTable.CreatePlay{
firstState = "judge_ctrl",
--firstState = "judge",
-----------------------------------------Def-------------------------------------------------------


["judge_ctrl"] = {
switch = function()
 if task.ball_is_ctrl() >= 0   then 
    return"shoot0"  
 else
    return "getball"    
 end
end,     
	    ["Kicker"]   = task.readyforshoot(),
		["Receiver"] = task.mydef2(0.5),                                            
        ["Middle"]   = task.mydef1(0.5),
        ["Tier"]     = task.marking(-4200,-2000,1200,2200,bx1),
        ["Defender"] = task.marking(-4200,-2000,-2200,-1200,bx2),
        ["Goalie"]   = task.goalie(),
        match = "{G}[KDTMR]"
},

["getball"] = {
switch = function()
	 --show()
 if task.ball_is_ctrl() >= 0 then 
    return"shoot0"     
 end
 if bufcnt(true, 120) then
    return "finish"
end

end,                                                   
        ["Kicker"]   = task.getballV2("Kicker"),
		["Receiver"] = task.mydef2(0.5),                                            
        ["Middle"]   = task.mydef1(0.5),
        ["Tier"]     = task.marking(-4200,-2000,1200,2200,bx1),
        ["Defender"] = task.marking(-4200,-2000,-2200,-1200,bx2),
        ["Goalie"]   = task.goalie(),
      --  match = "{G}[KTD]"
        match = "{G}[KDTMR]"
},


["shoot0"] = {
switch = function()

 if  bufcnt(player.toTargetDist("Kicker") < 200,10)then 
    return "shoot1"    
 end
 if bufcnt(true, 120) then
    return "finish"
end

end,                                                 
        ["Kicker"]   = task.readyforshoot(),
		["Receiver"] = task.mydef2(0.5),                                            
        ["Middle"]   = task.mydef1(0.5),
        ["Tier"]     = task.marking(-4200,-2000,1200,2200,bx1),
        ["Defender"] = task.marking(-4200,-2000,-2200,-1200,bx2),
        ["Goalie"]   = task.goalie(),
        match = ""
},


["shoot1"] = {
switch = function()

 if  player.kickBall("Kicker") then 
    return "finish"    
 end
 if bufcnt(true, 120) then
    return "finish"
end

end,                                                 
        ["Kicker"]   = task.smartshootV1("Kicker"),
		["Receiver"] = task.mydef2(0.5),                                            
        ["Middle"]   = task.mydef1(0.5),
        ["Tier"]     = task.marking(-4200,-2000,1200,2200,bx1),
        ["Defender"] = task.marking(-4200,-2000,-2200,-1200,bx2),
        ["Goalie"]   = task.goalie(),
        match = ""
},


name = "NormalPlayV1",
applicable ={
        exp = "a",
        a = true
},
attribute = "attack",
timeout = 99999
}











-----------------------------------------------------------------------------------------------------------------------------
-- ["judge"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"judge is "..judge(),4)
-- if judge()>-1  then                
--         if ball.posX()>1000 then
--            return "fd" 
--         elseif ball.posX()<-1000 then 
--            return "bd" 
--         else   
--            return "md"  
--         end   
--  end
 
-- if judge()==-1 then   
--         if ball.posX()>1000 then
--            return "judge_ctrl" 
--         elseif ball.posX()<-1000 then 
--            return "judge_ctrl" 
--         else   
--            return "judge_ctrl"  
--         end        
--  end    
-- end,
--         ["Kicker"]   = task.stop(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.goCmuRushB(p2),
--         ["Receiver"] = task.goCmuRushB(p3),
--         ["Defender"] = task.goCmuRushB(p4),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },
-- ----------------------------------------------Def-------------------------------------------------------
-- ["fd"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"FrontDef",5) 
--    debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2800),"judgeus is"..judgeus(),4) 
--      debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2600),"infraredCount is"..player.infraredCount("Kicker"),4)
--         debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2400),"judge is"..judge(),4)  
-- if bufcnt(player.infraredCount("Kicker") > 1, 40)  or bufcnt (judge()==-1,80) and bufcnt(judgeus()~=-1,40) then
--          return "judge"
--         end               
--     if ball.posX()>1000 then
--            return "fd" 
--     elseif ball.posX()<-1000 then 
--            return "bd" 
--     else   
--            return "md"  
--     end          
-- end,
--         ["Kicker"]   = task.smartshootV1("Kicker"),
--         ["Middle"]   = task.goCmuRushB(p6),
--         ["Tier"]     = task.mydef(0.5),
--         ["Receiver"] = task.marking(-3500,-1000,-3000,0,jqf1),   --禁区
--         ["Defender"] = task.marking(-3500,-1000,0,3000,jqf2),    --禁区
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },

-- ["md"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"MiddleDef",5) 
--    debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2800),"judgeus is"..judgeus(),4)
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2600),"infraredCount is"..player.infraredCount("Kicker"),4)
--        debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2400),"judge is"..judge(),4)   
-- if bufcnt(player.infraredCount("Kicker") > 1, 40)  or bufcnt (judge()==-1,80) and bufcnt(judgeus()~=-1,40) then
--          return "judge"
--         end           
--  if bufcnt (judge()>-1,5)  then                
--         if ball.posX()>1000 then
--            return "fd" 
--         elseif ball.posX()<-1000 then 
--            return "bd" 
--         else   
--            return "md"  
--         end   
--  end
          
--   end,         
--         ["Kicker"]   = task.getballV2("Kicker"),
--         ["Middle"]  = task.mydef(0.6),
--         ["Tier"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Receiver"] = task.mydef(0.4),
--         ["Defender"]  = task.marking(-3200,-1500,0,1000,bx2),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KMTRD]"
-- },

-- ["bd"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"BackDef",5) 
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2800),"judgeus is"..judgeus(),4) 
--      debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2600),"infraredCount is"..player.infraredCount("Kicker"),4) 
--         debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-2400),"judge is"..judge(),4) 
--  if bufcnt(player.infraredCount("Kicker") > 1, 40)  or bufcnt (judge()==-1,80) and bufcnt(judgeus()~=-1,40) then
--          return "judge"
--         end       
--  if judge()>-1 then                
--         if ball.posX()>1000 then
--            return "fd" 
--         elseif ball.posX()<-1000 then 
--            return "bd" 
--         else   
--            return "md"  
--         end   
--  end
          
-- end,
--     Kicker   = task.smartshootV1("Kicker"),
--     Tier     = task.marking(-4000,-2000,-2800,-1100,rjf),--右脚球区
--     Middle   = task.marking(-4000,-2000,1100,2800,ljf),  --左脚球区
--     Defender = task.marking(-3500,-1000,-1500,0,jqf1),   --禁区
--     Receiver = task.marking(-3500,-1000,0,1500,jqf2),    --禁区
--     Goalie   = task.goalie(),
--     match = "{G}[KMTRD]"
-- },