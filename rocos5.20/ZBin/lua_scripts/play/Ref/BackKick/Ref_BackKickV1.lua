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
-- firstState = "bk_judge_who",
-- ["bk_judge_who"] = {
-- switch = function()
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking1",4)
--  if ball.posY() > 0  then 
--     return"bk_judge_IsPassL"  
--  else
--     return "bk_judge_IsPassR"    
--  end
-- end,                                                   --"Kicker","Middle"
--         ["Kicker"]   = task.readyforpass("Kicker","Receiver"),
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                
--         ["Defender"] = task.marking(-3200,-1000,-2000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{G}[KTDRM]"
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
-- if bufcnt(true, 120) then
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

--         ["Kicker"]   = task.passballV1("Kicker","Tier"),--,kick.auto("Kicker","Middle")),  --pass to middle
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

--         ["Kicker"]   = task.passballV1("Kicker","Defender"),--,kick.auto("Kicker","Middle")),  --pass to middle
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
--         ["Kicker"]   = task.smartshootV1("Kicker"),--to p32 middle
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                -- receive to paodian
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

--         ["Kicker"]   = task.smartshootV1("Kicker"),--,kick.auto("Kicker","Middle")),  --pass to middle
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
--         ["Kicker"]   = task.goCmuRushB(pK1),    ---ding shang qv
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
-- if bufcnt(true, 120) then
--     return "finish"
--    end

-- end,
--         ["Kicker"]   =  task.smartshootV1("Kicker"),--to p32 middle
--        -- ["Kicker"]   = task.readyforshoot(),--to p32 middle
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                -- receive to paodian
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

--         ["Kicker"]   =  task.smartshootV1("Kicker"),--,kick.auto("Kicker","Middle")),  --pass to middle
--         ["Middle"]   = task.goCmuRushB(pM1),
--         ["Tier"]     = task.marking(-3200,-1000,0,2000,bx2),
--         ["Receiver"] = task.goCmuRushB(pR1),                 --paodian
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
--         ["Kicker"]   = task.goCmuRushB(pK1),    ---ding shang qv
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
--         ["Kicker"]   = task.goCmuRushB(pK1),    ---ding shang qv
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
--     return "finish"
-- end

-- --if bufcnt(true,100) then
--    --                     return "shoot"
--   --              end
-- end,
       
--         ["Kicker"]   = task.goCmuRush(shootGen(92),_,_,flag.dribbling),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
       
-- },

-- ["readyl"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking27",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if bufcnt(player.infraredCount("Kicker")>1,60) then
--                         return "shoot"
--                 end
-- end,
       
--         ["Kicker"]   = task.goCmuRush(rsl,_,1500,flag.dribbling),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
       
-- },

-- ["readyr"] = {
-- switch = function()
--     debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"backkicking28",4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,200),"can pass"..checkpass('Kicker','Receiver') ,4)
--  debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,600),'can shoot'..checkshoot('Kicker') ,4)
--  if bufcnt(player.infraredCount("Kicker")>1,60) then
--                         return "shoot"
--                 end
-- end,
       
--         ["Kicker"]   = task.goCmuRush(rsr,_,1500,flag.dribbling),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
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
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
--  },

-- name = "Ref_BackKickV1",
-- applicable ={
--         exp = "a",
--         a = true
-- },
-- attribute = "attack",
-- timeout = 99999
-- }


local dis =75 --所有拿球task的dist值 实地车拿不到球就改小 
local smartshootpow = 550
local passh =600
local passl =200--200    --测试给6000

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
-----------------------baoxain-------------------------------------
local bx1=CGeoPoint:new_local(-2700,800)  --后场zuo边 baoxianwei
local bx2=CGeoPoint:new_local(-2700,-800)  --后场右边  baoxianwei

local bx3=CGeoPoint:new_local(700,1500)  --zhong chang zuo边 baoxianwei
local bx4=CGeoPoint:new_local(700,-1500)  --zhongchang youbian baoxianwei
-------------------------debug禁区前1-----------------------
local jq1=CGeoPoint:new_local(-3500,-1500)
local jq2=CGeoPoint:new_local(-3500,1500)
local jq3=CGeoPoint:new_local(-1000,1500)
local jq4=CGeoPoint:new_local(-1000,-1500)
local jqf1=CGeoPoint:new_local(-2800,-300)--禁区防守点
local jqf2=CGeoPoint:new_local(-2800,300) --禁区防守点
---------------------212----------------------------------
local p1=CGeoPoint:new_local(3000,1500)  --前场右边
local p2=CGeoPoint:new_local(3000,-1500) --前场左边
local p3=CGeoPoint:new_local(2000,0)     --中场
local p11=CGeoPoint:new_local(2000,1700)
local p21=CGeoPoint:new_local(2000,-1700)

local p31=CGeoPoint:new_local(1000,-2000) --中场1
local p32=CGeoPoint:new_local(1000,2000)  --中场2

local p4=CGeoPoint:new_local(-1000,-800) --后场左边
local p5=CGeoPoint:new_local(-1000,800)  --后场右边

local p6=CGeoPoint:new_local(2200,300)    --前场zhongjian
local p61=CGeoPoint:new_local(2200,-300)

local rsl=CGeoPoint:new_local(3000,1000)  --后场左边
local rsr=CGeoPoint:new_local(3000,-1000)  --后场右边
----------------------------bk---dianwei-----------
local pR1 = CGeoPoint:new_local(2500,-1500)     
local pR2 = CGeoPoint:new_local(1800,-1700)
local pR3 = CGeoPoint:new_local(2300,-2000)  

local pM1 = CGeoPoint:new_local(2500,1500)     
local pM2 = CGeoPoint:new_local(3000,1700)  
local pM3 = CGeoPoint:new_local(2300,2000)  

local pK1 = CGeoPoint:new_local(1800,0)  
local pK2 = CGeoPoint:new_local(2500,0)  

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

function ball_is_ctrl()   --判断球是否被我方控制  判断条件 红外 距离 返回车号 
                        --  用法      if task.ball_is_ctrl()>=0 then
    local msgPos=CGeoPoint:new_local(0,-3400)
    local msgPos2=CGeoPoint:new_local(-300,-3600)
    local num=-1
    for i = 0, 15 do
        if  player.infraredOn(i)  then --player.toBallDist(i)< 200  and
            debugEngine:gui_debug_arc(player.pos(i),200,0,math.pi*2*100,4)
            --debugEngine:gui_debug_msg(msgPos,"Ball_Ctrl",4)
            num=i
        end
    end 
    debugEngine:gui_debug_msg(msgPos2," 我方    号控球" ,4)
    debugEngine:gui_debug_msg(msgPos2,"       "..num ,5)         
    return num     
end

function ball_is_danger() --判断球是否被敌方控制  判断条件 距离 返回车号 
                        --  用法      if task.ball_is_ctrl()>=0 then
    local msgPos=CGeoPoint:new_local(-0,-3300)
    local msgPos2=CGeoPoint:new_local(-300,-3300)
    local num=-1
    for i = 0,15 do
        if  (enemy.pos(i)-ball.pos()):mod() < 280  then
            debugEngine:gui_debug_arc(enemy.pos(i),200,0,math.pi*2*100,1)
            --debugEngine:gui_debug_msg(msgPos,"Ball_Ctrl",4)
            num=i
        end
    end 
    debugEngine:gui_debug_msg(msgPos2," 敌方    号控球" ,2)
    debugEngine:gui_debug_msg(msgPos2,"       "..num ,7)         
    return num     
end

function pass_is_break (role1,role2)   --判断是否被敌方挡住  判断条件 距离 返回车号 
                                        --  用法  if task.ball_is_break()>=0 then
                                        
    local msgPos=CGeoPoint:new_local(500,-3300)
    local msgPos2=CGeoPoint:new_local(800,-3500)
    local num=-1
    for i = 0,15 do
        local player_line = CGeoLine:new_local(player.pos(role1),(player.pos(role2) - player.pos(role1)):dir())
        local target_pos = player_line:projection(enemy.pos(i))
        local toLinedist = (enemy.pos(i) - target_pos):mod()
        local toPlayer1dist =(enemy.pos(i) - player.pos(role1)):mod()
        local toPlayer2dist =(enemy.pos(i) - player.pos(role2)):mod()
        local Playerdistsum =(player.pos(role1) - player.pos(role2)):mod()
        
        if  toLinedist < 200  and  toPlayer1dist+toPlayer2dist<Playerdistsum*1.05 then
            debugEngine:gui_debug_arc(enemy.pos(i),200,0,math.pi*2*100,8)
            debugEngine:gui_debug_msg(msgPos,"Enemy_Break "..num,4)
            --debugEngine:gui_debug_msg(msgPos,'1+1='..math.ceil (toPlayer1dist+toPlayer2dist))
           -- debugEngine:gui_debug_msg(msgPos2,'sum='..math.ceil(Playerdistsum))
            --debugEngine:gui_debug_msg(msgPos2,'k='..((toPlayer1dist+toPlayer2dist)/Playerdistsum))--改k比值
            num=i
        end
    end       
    return num     
end

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

gPlayTable.CreatePlay{
firstState = "MKtime",
["MKtime"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"Ref_MiddleKickV",4)
    if bufcnt(player.toTargetDist("Kicker") < 200,20) then 
       return "MK2LL"
    end  
end,
        ["Kicker"]   = task.readyforshoot(),
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = "{G}[KTDRM]"
},

["MK2LL"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking21",4)
--    if player.valid("Middle") and player.valid("Receiver") then --judge middle and receiver is valid
    if calPlayerCount() > 5 then
        if checkshoot("Kicker") == -1 then  --jian ce ziji neng bu neng she ,
        debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"calPlayerCount() > 5 mk9",4)
            return "MK9"
        elseif task.pass_is_break("Kicker","Middle") < 0 then  --you enemy
            return "MK2LLL"
        elseif task.pass_is_break("Kicker","Receiver") < 0 then
            return "MK2RRR"
        else
            return "SecondPass"
        end
    elseif calPlayerCount() == 5 then
        debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"calPlayerCount() == 5 mk9",4)
        return "MK9"
    elseif calPlayerCount() < 5 or checkshoot("Kicker") > -1 then
        return "MK10"
    end
end, 
        ["Kicker"]   = task.getballV2("Kicker"),
       -- ["Kicker"]   = task.readyforshoot(),--to 1 front
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK2RRR"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
    if bufcnt(player.toTargetDist("Kicker") > 50,20) then 
        return"MK6L"  
    end
    if bufcnt(true, 120) then
        return "finish"
    end
end,
        ["Kicker"]   = task.passballV1("Kicker","Receiver"),
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),                 
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK2LLL"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
    if player.kickBall("Kicker") then 
        return"MK3L"  
    end
    if bufcnt(true, 120) then
        return "finish"
    end
end,
        ["Kicker"]   = task.passballV1("Kicker","Middle"),
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),                 
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK3L"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking3",4)
    if bufcnt(true,200) then
        return "finish"
    end 
--    if bufcnt(player.infraredCount("Middle")>1,5) then
    if player.infraredCount("Middle") > 1 then
        return "MK4L"
    end 
end,
        ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
        ["Middle"]   = task.recballV1("Middle"),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK4L"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking4",4)
    if checkshoot("Middle") == -1 then
        return "MiddleShoot"
    elseif task.pass_is_break("Middle","Receiver") >= 0 then
        return "PBMiddleToKicker"
    else
        return "PBMiddleToReceiver"
    end
end,
        ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
        ["Middle"]   = task.readyforshoot(),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["PBMiddleToReceiver"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking5",4)
-- if bufcnt(player.toTargetDist("Middle") > 40,20) then 
    if player.kickBall("Middle") then 
        return "MK6L"
    end
     if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p6),    
        ["Middle"]   = task.passballV1("Middle","Receiver"),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["PBMiddleToKicker"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking5",4)
-- if bufcnt(player.toTargetDist("Middle") > 40,20) then 
    if player.kickBall("Middle") then 
        return "KickerRec"
    end
     if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p6),    
        ["Middle"]   = task.passballV1("Middle","Kicker"),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["RToK"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking6",4)
 if bufcnt(player.toTargetDist("Receiver") > 30,15) then 
        return "KickerRec"
    end
     if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p6),   
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.passballV1("Receiver","Kicker"),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["KickerRec"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking7",4)
     
      if bufcnt(player.infraredCount("Kicker")>1,5) then
        return "ks"
      end 
       if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.recballV1("Kicker"),    ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p11),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["ks"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking8",4)
     if checkshoot("Kicker") == -1 then
        return "MK9"
    else
        return "SecondPass"
     end
end,
        ["Kicker"]   = task.readyforshoot(),   ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["SecondPass"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking21",4)
    if checkshoot("Kicker") == -1 then  --jian ce ziji neng bu neng she ,-1 can
        return "MK9"
    elseif bufcnt(task.pass_is_break("Kicker","Middle") < 0,40) then  --you enemy
        return "SecKToM"
    elseif bufcnt(task.pass_is_break("Kicker","Receiver") < 0,40) then
        return "SecKToR"
    end
end, 
        ["Kicker"]   = task.readyforshoot(),   ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p11),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p21),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["SecKToM"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
    if player.kickBall("Kicker") then 
        return"SecMRec"  
    end
    if bufcnt(true, 120) then
        return "finish"
    end
end,
        ["Kicker"]   = task.passballV1("Kicker","Middle"),
        ["Middle"]   = task.goCmuRushB(p11),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p21),                 
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["SecKToR"] = {
switch = function()
debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
    if player.kickBall("Kicker") then 
        return"SecRRec"  
    end
    if bufcnt(true, 120) then
        return "finish"
    end
end,
        ["Kicker"]   = task.passballV1("Kicker","Receiver"),
        ["Middle"]   = task.goCmuRushB(p11),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p21),                 
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["SecMRec"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking3",4)
    if bufcnt(true,150) then
        return "finish"
    end 
    if bufcnt(player.infraredCount("Middle")>1,5) then
        return "SecMiddleShoot"
    end 
end,
        ["Kicker"]   = task.goCmuRushB(p61),    ---ding shang qv
        ["Middle"]   = task.recballV1("Middle"),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p21),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["SecMiddleShoot"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking11",4)
 if bufcnt(player.kickBall("Middle"),20) then 
        return "finish"
  end   
if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p61),    ---ding shang qv
        ["Middle"]   =  task.smartshootV1("Middle"),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p21),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["SecRRec"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking3",4)
    if bufcnt(true,120) then
        return "finish"
    end 
    if bufcnt(player.infraredCount("Receiver")>1,5) then
        return "ReceiverShoot"
    end 
end,
        ["Kicker"]   = task.goCmuRushB(p61),    ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p11),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.recballV1("Receiver"),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["ReceiverShoot"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking12",4)
 if bufcnt(player.kickBall("Receiver"),20) then 
        return "finish"
  end   
    if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p61),   ---ding shang qv
        ["Middle"]   =  task.goCmuRushB(p11),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.smartshootV1("Receiver"),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK6L"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking9",4)
    if bufcnt(player.infraredCount("Receiver")>1,5) then
        return "MK7L"
    end 
    if bufcnt(true, 200) then
        return "finish"
    end

end,
        ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.recballV1("Receiver"),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK7L"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking10",4)
    if checkshoot("Receiver") == -1 then
        return "ReceiverShoot"
    elseif bufcnt(task.pass_is_break("Receiver","Kicker") >= 0,20) then
        return "RToM"
    else
        return "RToK"
    end
end,
        ["Kicker"]   = task.goCmuRushB(p6),   ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.readyforshoot(), 
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MiddleShoot"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking11",4)
 if bufcnt(player.kickBall("Middle"),20) then 
        return "finish"
  end   
if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p6),    ---ding shang qv
        ["Middle"]   =  task.smartshootV1("Middle"),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["ReceiverShoot"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking12",4)
 if bufcnt(player.kickBall("Receiver"),20) then 
        return "finish"
  end   
    if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.goCmuRushB(p6),   ---ding shang qv
        ["Middle"]   =  task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.smartshootV1("Receiver"),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK9"] = {
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"mk9",4)
 if bufcnt(player.kickBall("Kicker"),20) then 
        return "finish"
       --  return "finish"
  end   
    if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.smartshootV1("Kicker"),   ---ding shang qv
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

["MK10"] = {           --kicker tiao she
switch = function()
 debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"mk10",4)
 if bufcnt(player.kickBall("Kicker"),20) then 
        return "finish"
       --  return "finish"
  end   
    if bufcnt(true, 120) then
    return "finish"
end

end,
        ["Kicker"]   = task.smartshootV1("Kicker"),   ---gai tiao she
        ["Middle"]   = task.goCmuRushB(p1),
        ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
        ["Receiver"] = task.goCmuRushB(p2),
        ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
        ["Goalie"]   = task.goalie(),
        match = ""
},

name = "Ref_BackKickV1",
applicable ={
    exp = "a",
    a   = true
},
attribute = "attack",
timeout = 99999
}

-- ["Ref_MiddleKickV0"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"Ref_MiddleKickV",4)
--     if ball.posX() < 0 and  calPlayerCount() < 5 then 
--        return "BKtime"
--     else
--         return "MKtime"
--     end  
-- end,
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = "{GK}[TDRM]"
-- },

-- ["BKtime"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"Ref_MiddleKickV",4)
--     if calPlayerCount() >= 5 then
--         return "ChipKToM"
--     else
--         return "ChipKAlone"
--     end
-- end,
--         ["Kicker"]   = task.readyforshoot(),
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                -- receive to paodian
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["ChipKToM"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
--     if player.kickBall("Kicker") then 
--         return"MK3L"  
--     end
--     if bufcnt(true, 120) then
--         return "finish"
--     end
-- end,
--         ["Kicker"]   = task.passballV1("Kicker","Middle"), --gai tiao chuan
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["ChipKAlone"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
--     if player.kickBall("Kicker") then 
--         return "KickerGet"  
--     end
--     if bufcnt(true, 120) then
--         return "finish"
--     end
-- end,
--         ["Kicker"]   = task.smartshoot("Kicker"), 
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

-- ["KickerGet"] = {
-- switch = function()
-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,-3000),"middlekicking2",4)
--     if bufcnt(player.infraredCount("Kicker")>1,5) then 
--         return "MK9"  
--     end
--     if bufcnt(true, 120) then
--         return "finish"
--     end
-- end,
--         ["Kicker"]   = task.getballV2("Kicker"), 
--         ["Middle"]   = task.goCmuRushB(p1),
--         ["Tier"]     = task.marking(-3200,-1500,0,1000,bx2),
--         ["Receiver"] = task.goCmuRushB(p2),                 
--         ["Defender"] = task.marking(-3200,-1500,-1000,0,bx1),
--         ["Goalie"]   = task.goalie(),
--         match = ""
-- },

