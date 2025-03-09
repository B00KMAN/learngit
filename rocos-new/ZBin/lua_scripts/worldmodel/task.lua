
module(..., package.seeall)

--~		Play中统一处理的参数（主要是开射门）
--~		1 ---> task, 2 ---> matchpos, 3---->kick, 4 ---->dir,
--~		5 ---->pre,  6 ---->kp,       7---->cp,   8 ---->flag
------------------------------------- 射门相关的skill ---------------------------------------
-- TODO
-------------------------------------------config -------------------------------------
--用于改全局变量 
local dis =75 --所有拿球task的dist值 实地车拿不到球就改小 
local smartshootpow = 450
local passh =550
local passl =200--200    --测试给6000

local cppow = 2000 





--       -- test
-- local dis =75 --所有拿球task的dist值 实地车拿不到球就改小 
-- local smartshootpow = 5500
-- local passh =6000
-- local passl =200--200    --测试给6000


--------------------------------------Judge函数 ---------------------------------------------
function ball_is_ctrl()   --判断球是否被我方控制  判断条件 红外 距离 返回车号 
                        --  用法      if task.ball_is_ctrl()>=0 then
    local msgPos=CGeoPoint:new_local(0,-3400)
    local msgPos2=CGeoPoint:new_local(-300,-3600)
    local num=-1
    for i = 0, 15 do
        if    player.infraredOn(i)  then --player.toBallDist(i)< 200  and
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

Goalienum =function()--得到对方门将车号      返回车号
	local num =-1
	for i=0,param.maxPlayer-1 do
	    if enemy.isGoalie(i)  and enemy.valid(i) then
	       	debugEngine:gui_debug_msg(CGeoPoint:new_local(3900,-3300),'门将是   号',1)
	        debugEngine:gui_debug_msg(CGeoPoint:new_local(3900,-3300),'          '..i,2) 
	    	return i	
	    end
	end 
    return num   
end

function ball_vel()--判断是否超速，超速变红                               
    local msgPos=CGeoPoint:new_local(1000,-3300)
    local msgPos2=CGeoPoint:new_local(800,-3500)
    debugEngine:gui_debug_msg(msgPos,'球速： '..math.ceil( ball.velMod())	,5)
        if ball.velMod()>6500 then
            debugEngine:gui_debug_arc(ball.pos(),500,0,400,1)
            debugEngine:gui_debug_msg(ball.pos(),'超速',1)
        end          
end

function getball_dis()   --打印每次的拿球距离
	get_dis = {}
	local s = 1
	local dissum=0
	local msgPos2=CGeoPoint:new_local(800,3500)
	for j = 0,15 do
		if player.infraredOn(j) then
			get_dis[s] = player.toBallDist(j)
			s = s + 1
		end
	end 
	--local enemy_min = math.max(unpack(enemy_dis))
	for i = 1,#get_dis do 
		dissum =dissum +get_dis[i]
	end
	local  dis_ave = dissum/#get_dis
	 debugEngine:gui_debug_msg(msgPos2,"getball_dis:"..math.ceil(dis_ave),5)
end
------------------------------------- skill测试区 ---------------------------------------

-----------------------------------------V1系列--------------------------------------------
function getballV1(role)	--拿球 若球旁无敌方车则直接拿 有则抢球（避免撞车）
 	return function()		--拿球 
 		--local dis = 70  		--实地拿不到球可以改这里的dis
    	local msgPos=CGeoPoint:new_local(0,0)
    	local msgPos2=CGeoPoint:new_local(300,0)
    	local idir = function()
    			return dir.playerToBall(role)      
			end
		if ball_is_danger()>=0  then
			--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)
			debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getaball抢球',1)
			local ipos=function() 
    			return function ()
        			return ball.pos()+ Utils.Polar2Vector(dis,(ball.pos()-enemy.pos(ball_is_danger())):dir())
        		end
			end
    		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
    	else 
			local ipos=function() 
    			return function ()
        			return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role) - ball.pos()):dir())
        		end
			end
			--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)
    		debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getball拿球',4)
    		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
		end
	end
end

function getballV2(role)	--对面别想拿球 若球旁无敌方车则直接拿 有则抢球（避免撞车）
 	return function()		--拿球 
 		--local dis = 70  		--实地拿不到球可以改这里的dis
    	local msgPos=CGeoPoint:new_local(0,1000)
    	local msgPos2=CGeoPoint:new_local(300,0)
    	local msgPos3=CGeoPoint:new_local(0,500)
    	-- local idir = function()
    	-- 		return dir.playerToBall(role)      
		-- 	end
		local todir = math.abs(player.dir(role)-enemy.dir(ball_is_danger()))*57.3
		local todis = (player.pos(role)-enemy.pos(ball_is_danger())):mod()
		
		if ball_is_danger()>=0  then
			local ipos=function() 
    			return function ()
        			return ball.pos()+ Utils.Polar2Vector(dis,(ball.pos()-enemy.pos(ball_is_danger())):dir())
        		end
			end
			debugEngine:gui_debug_msg(msgPos2,'dir'..todir)
			debugEngine:gui_debug_msg(msgPos3,'dis'..todis)	
			
			local idir = function()
				if  todir <200 and not player.infraredOn(role) then  --todis < 200 and 
					debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getaball抢球21',1)
    				return dir.playerToBall(role) 
    			--end
    			else 
    					debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getaball抢球22',1)  
    				return (player.pos(role) - enemy.pos(ball_is_danger())):dir()
    			end
			end
			
			
    		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
    	else 
    		local idir1 = function()
    				return dir.playerToBall(role) 
			end
			local ipos=function() 
    			return function ()
        			return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role) - ball.pos()):dir())
        		end
			end
			--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)
    		debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getball拿球',4)
    		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir1, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
		end
	end
end

function passballV1(role1,role2) --传球 1给2 当没球时会先拿球 敌方车挡路会挑射
	return function()
		--local dis = 100 --实地拿不到球可以改这里的dis
		local msgPos2=CGeoPoint:new_local(300,0)
		
		local ipower =function() --game 300 test 3000
			return function()
				return passl+ (passh-passl)*(player.pos(role1)-player.pos(role2)):mod()/10800 --待改进动态力			
			end				
		end	
		
		local idir = function()
       		return player.toPlayerDir(role1,role2)
		end 	
		local ipos = function()
			return function()
		    	return ball.pos() + Utils.Polar2Vector(-dis,idir())
   		 	end
   		end	
   		
   		if player.infraredOn(role1)  then 
   			-- if pass_is_break(role1,role2) >=0 then 	
			-- 	local mexe, mpos = GoCmuRush{pos = ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
			-- 	debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'passball挑传',4)
			-- 	return {mexe, mpos, kick.chip, idir, pre.middle,ipower(),ipower(), flag.dribbling}--实地调参
			-- else
				local mexe, mpos = GoCmuRush{pos = ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
				debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'passball平传',4)
				return {mexe, mpos, kick.flat, idir, pre.middle,ipower(),ipower(), flag.dribbling}--实地调参
			--end
		else
			local idir2 = function()
    			return dir.playerToBall(role1)      
			end
			local ipos2=function() 
    			return function ()
        			return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role1) - ball.pos()):dir())
        		end
			end
			debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role1)),2)
    		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'passball拿球',4)
    		local mexe, mpos = GoCmuRush{pos =ipos2(), dir = idir2, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
		end		
	end
end

function quickpass(role1,role2)
	return function()
		--local dis=100
		local msgPos2=CGeoPoint:new_local(300,0)
		local ipos=function() 
    		return function ()
        		return player.pos(role2)
        	end
		end
		local idir = function()
			return (player.pos(role2)-player.pos(role1)):dir()
		end
		local ipower =function() --game 300 test 3000
				return function()
					if (player.pos(role1)-player.pos(role2)):mod()>3000 then --待改进动态力度
						return  350
					else 
						return	200
					end			
				end	
			end	
		if player.infraredOn(role1) then  
			debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'quickpass传球',4)
			local mexe, mpos = Touch{pos = ipos(), useInter = false}
			return {mexe, mpos, kick.flat, idir, pre.low, ipower(), cp.full, flag.dribbling}
		else
			local idir2 = function()
	    		return dir.playerToBall(role1)      
			end
			local ipos2=function() 
	    		return function ()
	        		return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role1) - ball.pos()):dir())
	        	end
			end
			debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role1)),2)
	    	debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'quickpass拿球',4)
	    	local mexe, mpos = GoCmuRush{pos =ipos2(), dir = idir2, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
		end
	end	 --快速传球 
end

function goCmuRushB(p,a, f,r, v)

	local idir=function(runner)
	 return  dir.playerToBall(runner)
	end

	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end


function smartshootV1(role) --射门 球不在嘴边就绕到球后
	return function()
		--local dis =100 
		local msgPos2=CGeoPoint:new_local(300,0)
		local goalPos = CGeoPoint:new_local(4500,0)
		local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
		local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)            
		local ipower =function() --game 300 test 3000
			return function()
				debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(30,math.pi),math.ceil(ball.velMod()),6) --实地改力度
				return smartshootpow 
			end
		end	
	    local shootP = function()
			return function()
				local goalPos = CGeoPoint(param.pitchLength/2,0)
				return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
			 end
	    end 
	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
 		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
		if dir_cond < 0.02  and  dis_cond < 300 and dis_cond > 0 then  --精度改 dir_cond
			local idir =function()
			 	if Goalienum() >=0 then		
					if  dir_shoot_l >= dir_shoot_r then 
						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
						return dir.playerToPoint(shootPos_l,role)
					end
						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
			   			return dir.playerToPoint(shootPos_r,role)
			   	else 
			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
			   		return (goalPos-player.pos(role)):dir()	
			   	end		          	    
			end  	
			local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = f,rec = r,vel = v}
			return {mexe, mpos, kick.flat, idir, pre.middle, ipower(), ipower(), flag.dribble}
		else		
    		local idir =function() 
    		-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,1)
			-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,1)
    		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(1000,math.pi),'smartshoot绕球',4)	
		    return dir.playerToPoint(ball.pos(),role)          	    
			end
    		local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = flag.dodge_ball + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
		end	
	end	
end
function smartshootV1_tiao(role) --射门 球不在嘴边就绕到球后
	return function()
		--local dis =100 
		local msgPos2=CGeoPoint:new_local(300,0)
		local goalPos = CGeoPoint:new_local(4500,0)
		local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
		local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)            
		local ipower =function() --game 300 test 3000
			return function()
				debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(30,math.pi),math.ceil(ball.velMod()),6) --实地改力度
				return smartshootpow 
			end
		end	
	    local shootP = function()
			return function()
				local goalPos = CGeoPoint(param.pitchLength/2,0)
				return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
			 end
	    end 
	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
 		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
		if dir_cond < 0.02  and  dis_cond < 300 and dis_cond > 0 then  --精度改 dir_cond
			local idir =function()
			 	if Goalienum() >=0 then		
					if  dir_shoot_l >= dir_shoot_r then 
						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
						return dir.playerToPoint(shootPos_l,role)
					end
						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
			   			return dir.playerToPoint(shootPos_r,role)
			   	else 
			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
			   		return (goalPos-player.pos(role)):dir()	
			   	end		          	    
			end  	
			local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = f,rec = r,vel = v}
			return {mexe, mpos, kick.chip, idir, pre.low, cp.specified(cppow), cp.specified(cppow), flag.dribble}
		else		
    		local idir =function() 
    		-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,1)
			-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,1)
    		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(1000,math.pi),'smartshoot绕球',4)	
		    return dir.playerToPoint(ball.pos(),role)          	    
			end
    		local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = flag.dodge_ball + flag.allow_dss,rec = r,vel = v}
			return {mexe, mpos}
		end	
	end	
end

function recballV1(role) --接球
	return function ()
		msgPos=CGeoPoint:new_local(500,-3000)
		msgPos2=CGeoPoint:new_local(300,-2700)
		local idir=function()
	   		return  dir.playerToBall(role)
		end
    	local ipos=function()
    		if ball.valid() then
    			 debugEngine:gui_debug_msg(msgPos,'ball_dir'..math.ceil(ball.velDir()))
    			 debugEngine:gui_debug_msg(msgPos2,'player_dir'..math.ceil(dir.playerToBall(role)))
				if ball.velMod() >1000   then     --判断方向是否一致--and   ball.velDir()*dir.playerToBall(role)<0
	       			local k1=math.tan(ball.velDir()) 
	       			local k2=-1/k1
	       			local x=(k1*ball.posX() - k2*player.posX(role) + player.posY(role) - ball.posY())/(k1-k2)
	      			local y=k1*(x-ball.posX())+ball.posY()
	          		return  CGeoPoint:new_local(x,y)
	   			else
	          		return  ball.pos() + Utils.Polar2Vector(-dis,idir())
       		 	end
   			else 
         		return CGeoPoint:new_local(0,0)  
    		end
	end
	local mexe, mpos = GoCmuRush{pos =ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, kick.none, idir, pre.low, kp.specified(0), cp.full, flag.dribbling}
	end --接球，改动不大 添加了方向判断 
end

function marking(xmin,xmax,ymin,ymax,p)------区域防守,适合角球防守--区域无人就回p点
	local num = 0
	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)

	local checkNum = function()
	local between = function(a,min,max)
		if a > min and a < max then
			return true
		end
			return false		    
	end  
	local num = -1
	for i = 0,param.maxPlayer-1 do
		if enemy.valid(i) and between(enemy.posX(i),xmin,xmax) and between(enemy.posY(i),ymin,ymax) then
			return i
		end
	end
		return num
	end
	local ipos = function()
		local num = checkNum()
		local enemyPos = enemy.pos(num)
		if num < 0 then
			--enemyPos  = CGeoPoint:new_local((xmin + xmax)/5.0,(ymin + ymax)/2.0)
			enemyPos  = p
		end
		local res
		local l = (ourGoal - enemyPos):mod()*0.3
		res = enemyPos + Utils.Polar2Vector(l,(ourGoal - enemyPos):dir())
		return res
	end
	local idir = function(runner)
		local num = checkNum()
		local res
		local enemyPos = enemy.pos(num)
		if num < 0 then
	   	 enemyPos  = p
	  	 -- enemyPos  = CGeoPoint:new_local((xmin + xmax)/5.0,(ymin + ymax)/2.0)
		end
		res = (enemyPos - ourGoal):dir()	   
		return res
	end
	local ff= flag.allow_dss

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = ff,rec = r,vel = v}
	return {mexe, mpos}
end

function mydef1(k)
	return function()
		local msgPos=CGeoPoint:new_local(500,-500)
		local theirGoal = CGeoPoint:new_local(param.pitchLength/2.0,0)
		local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
		local ipos =function()
	   		local res
	   		local l= 750+((ourGoal- ball.pos()):mod()-500)*k
	    	res = ourGoal + Utils.Polar2Vector(l,(ball.pos()-ourGoal):dir()-math.pi/50)
	    	return res 
		end    
		local idir	= function()	
      		local res
      		res = (ball.pos() - ourGoal):dir()
      		return res 
    	end
    	--local  xmax = -3000
    	--local  ymax = 1500
    	-- if ball.posX() < xmax  and  math.abs(ball.posY())> ymax then
    	-- debugEngine:gui_debug_line(CGeoPoint:new_local(xmax,ymax),CGeoPoint:new_local(-4500,ymax))
    	-- debugEngine:gui_debug_line(CGeoPoint:new_local(xmax,-ymax),CGeoPoint:new_local(xmax,ymax))
    	-- debugEngine:gui_debug_line(CGeoPoint:new_local(xmax,-ymax),CGeoPoint:new_local(-4500,-ymax))

    	-- debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'盯球',4)

  			local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f, rec = r, vel = v}
 			return {mexe, mpos}
 		-- else
 		-- 	local idir2 = function()
       	-- 		local res
      	-- 		res = (ball.pos() - ourGoal):dir()
      	-- 		return res 
    	-- 	end
		-- 	local ipos2 = function()
		-- 		return function()
		--     		return ball.pos() + Utils.Polar2Vector(-dis,idir())
   		--  		end
   		-- 	end
   		-- 	local mexe, mpos = GoCmuRush{pos = ipos2(), dir = idir2(), acc = a, flag = f,rec = r,vel = v}
		-- 	 	debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'清球',4)
		-- 	 	return {mexe, mpos, kick.chip, idir, pre.middle,cp.specified(cppow),cp.specified(cppow), flag.dribbling}
		--end	


 	end
end
function mydef2(k)
	local theirGoal = CGeoPoint:new_local(param.pitchLength/2.0,0)
	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
	local ipos =function()
	   local res
	   local l= 750+((ourGoal- ball.pos()):mod()-700)*k
	    res = ourGoal + Utils.Polar2Vector(l,(ball.pos()-ourGoal):dir()+math.pi/50)
	    return res 
	end    
	local idir	= function()	
      local res
      res = (ball.pos() - ourGoal):dir()
      return res 
    end
  	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f, rec = r, vel = v}
 	return {mexe, mpos}
end

function mydef(k,a)
	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
	local ipos =function()
	   local res
	   local l= ( ourGoal- ball.pos()):mod()*k
	    res = ourGoal + Utils.Polar2Vector(l,(ball.pos()-ourGoal):dir())
	    return res 
	end    
	local idir	= function()	
      local res
      res = (ball.pos() - ourGoal):dir()
      return res 
    end
  	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f, rec = r, vel = v}
 	return {mexe, mpos}
end


function inter()
	local ipos = function()
		local res
		if ball.velMod() < 1000 then
			str = '22'
			res = ball.pos() + Utils.Polar2Vector(-98,ball.toTheirGoalDir())
		else
			str = '33'
			res = ball.pos() + Utils.Polar2Vector(0.4 * ball.velMod(),ball.vel():dir())
		end
		--debugEngine:gui_debug_msg(CGeoPoint:new_local(0,200),"dpos!". str,3)
		return res
	end
	local idir = function(runner)
		local res 
		local str = '11'
		if ball.velMod() < 500 then
			str = '22'
			res = ball.toTheirGoalDir()
		else
			str = '33'
			res = (ball.pos() - player.pos(runner)):dir()
		end

		return res 
	end
	local mexe,mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f, rec = r, vel = v}
	return {mexe,mpos}
end

--------------------------------------------------任意球----------------------------------------------------------------

function readyforshoot()   --
	local idir = dir.shoot()
	local shootGen = function()
	return function()
		local goalPos = CGeoPoint(param.pitchLength/2,0)
		local pos = ball.pos() + Utils.Polar2Vector(150,(ball.pos() - goalPos):dir())
		return pos
	   end
    end
	local mexe, mpos = SmartGoto{pos = shootGen(), dir = idir, flag = flag.dodge_ball, acc = a}
	return {mexe, mpos}
end

function readyforpass(role1,role2)
	local idir = function()
		return player.toPlayerDir(role1,role2)
	end
	local shootGen = function()
		return function()
			local playerPos = function()
				return player.pos(role2)
			end
		local pos = ball.pos() + Utils.Polar2Vector(-180,(CGeoPoint:new_local(0,0)-ball.pos()):dir())--CGeoPoint:new_local(0,0))dir.ballToPoint(playerPos())
		return pos
		end
	end
	local mexe, mpos = SmartGoto{pos = shootGen(), dir = idir, flag = flag.dodge_ball, acc = a}
	return {mexe, mpos}
end
-------------------------------------------------点球-------------------------------------------------------------------
function we_will_win(role)----------点球决胜 
	return function()  
		--local dis = 75   
		local msgPos=CGeoPoint:new_local(0,0)
		debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)                            
        local num = -1
        ball_vel()
        function goalie0()
			for i = 0,param.maxPlayer-1 do
				if enemy.valid(i)  and enemy.posX(i)>2000 then
					debugEngine:gui_debug_msg(msgPos,'门将 ：'..i,4)
					num=i
				end
				return num
			end
		end  
		local idir=function()   ------带球
            	return player.toTheirGoalDir(role)         
        	end
    	local ipos=function() 
            	return function()
                return ball.pos()+Utils.Polar2Vector(-dis,idir())
    		end
    	end    
    	if  player.posX(role)>0 then
    		local idir2 =function()
	 			local goalPos = CGeoPoint:new_local(4500,0)
				local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
				local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
				local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
				local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
				local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
				local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)  
			 	if Goalienum() >=0 then		
					if  dir_shoot_l >= dir_shoot_r then 
						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
						return dir.playerToPoint(shootPos_l,role)
					end
						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
			   			return dir.playerToPoint(shootPos_r,role)
			   	else 
			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
			   		return (CGeoPoint:new_local(4500,-200)-player.pos(role)):dir()	
			   	end		          	    
			end  	
	 		 local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir2, acc = a, flag = f,rec = r,vel = v}
			return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(smartshootpow),  kp.specified(smartshootpow), flag.dribbling}	 		
	 	else	  			
	 		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
	 		return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(160),kp.specified(160), flag.dribbling} 

	 		
			  
		end 
	end
end

function smartshoot_penalty(role) --点球射门
	return function()
		--local dis =85 
		local msgPos2=CGeoPoint:new_local(300,0)
		local goalPos = CGeoPoint:new_local(4500,0)
		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2) 
		ball_vel()
		getball_dis()


		local idir =function()
			 	if Goalienum() >=0 then		
					if  dir_shoot_l > dir_shoot_r then 
						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
						return dir.playerToPoint(shootPos_l,role)
					end
						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
			   			return dir.playerToPoint(shootPos_r,role)
			   	else 
			   		return (goalPos-player.pos(role)):dir()	
			   	end		          	    
			end  	  
		local ipos =function()
			 	if Goalienum() >=0 then		
					if  dir_shoot_l > dir_shoot_r then 
						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
						return ball.pos() +Utils.Polar2Vector(dis,(ball.pos()-shootPos_l):dir())
					end
						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
			   			return ball.pos() +Utils.Polar2Vector(dis,(ball.pos()-shootPos_r):dir())
			   	else 
			   			debugEngine:gui_debug_line(goalPos,player.pos(role),7)
			   		return ball.pos() +Utils.Polar2Vector(dis,(ball.pos()-goalPos):dir())	
			   	end		          	    
		end  	        
	    -- local ipos = function()
		-- 	return function()
		-- 		local goalPos = CGeoPoint(param.pitchLength/2,0)
		-- 		return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
		-- 	 end
	    -- end 
	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
 		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
			local fff=flag.dribbling  + flag.our_ball_placement -- flag.force_kick
			local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = fff,rec = r,vel = v}
			return {mexe, mpos, kick.flat, idir, pre.middle, kp.specified(smartshootpow), kp.specified(smartshootpow),fff}
	end	
end
----------------------------------------------------放球------------------------------------------------------------------

function getball_placeball(role)  	--拿球                                     
	local idir = function()
    	return dir.playerToBall(role)      
	end
	local ipos=function() 
    	return function ()
        	return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role) - ball.pos()):dir())
        end
	end      
	local ff=flag.dribbling+flag.allow_dss+flag.our_ball_placement
	local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = ff,rec = r,vel = v}
	return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(0), cp.full, ff}--不吸球的话就改dribbling 
end

function Judge_inBallplacement(role) --------胶囊体 自动走出
	return function()
		local ball_line = CGeoLine:new_local(ball.pos(),(ball.pos() - ball.placementPos()):dir())
		local target_pos = ball_line:projection(player.pos(role))
		local toLinedist = (player.pos(role) - target_pos):mod()
		local dir3 =(player.pos(role)-ball.pos()):dir()*(player.pos(role)-ball.placementPos()):dir()
		local toBalldist = (player.pos(role) - ball.pos()):mod()  --到球距离 
		local toPlacedist = (player.pos(role) - ball.placementPos()):mod() --到放球点距离
		
		-- local pos = function(role)
		-- 	return function()		
		-- 		return target_pos + Utils.Polar2Vector(650 + param.playerRadius,(target_pos - player.pos(role)):dir() + math.pi )
		-- 	end
		-- end

		local pos1 = function(role)		
			return target_pos + Utils.Polar2Vector(650 + param.playerRadius,(target_pos - player.pos(role)):dir() + math.pi )
		end


		debugEngine:gui_debug_x(pos1(role)) 

		local pos2 = function(role)
			return function()		
				return target_pos + Utils.Polar2Vector(650 + param.playerRadius,(target_pos - player.pos(role)):dir() - math.pi )
			end
		end
		--debugEngine:gui_debug_x(target_pos)
		--debugEngine:gui_debug_x(player.pos(role) + Utils.Polar2Vector(500,(target_pos - player.pos(role)):dir()  + math.pi),3)
		if toLinedist < 650 and dir3 < 0  or  toBalldist < 600  or toPlacedist < 600 then
			local   fffff= flag.our_ball_placement + flag.avoid_their_ballplacement_area
			local mexe, mpos = GoCmuRush{pos = pos1(role), dir = idir, acc = a, flag =fffff,rec = r,vel = v}
			return {mexe, mpos}
		else
			local mexe, mpos = Stop{}
			return {mexe, mpos}
		end
	end
end

function getball_ballplace(role)  	--拿球(放球)                                     
	local idir = function()
    	return dir.playerToBall(role)      
	end
	local ipos=function() 
    	return function ()
        	return ball.pos()+ Utils.Polar2Vector(100,(player.pos(role) - ball.pos()):dir())
        end
	end     
	local ff= flag.dribbling +flag.allow_dss + flag.our_ball_placement
	local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = ff,rec = r,vel = v}
	return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(0), cp.full, ff}--不吸球的话就改dribbling 
end



--~ p为要走的点,d默认为射门朝向
function goalie()
	local mexe, mpos = Goalie()
	return {mexe, mpos}
end
function touch()
	local ipos = pos.ourGoal()
	local mexe, mpos = Touch{pos = ipos}
	return {mexe, mpos}
end
function touchKick(p,ifInter)
	local ipos = p or pos.theirGoal()
	local idir = function(runner)
		return (ipos - player.pos(runner)):dir()
	end
	local mexe, mpos = Touch{pos = ipos, useInter = ifInter}
	return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(200), kp.specified(200), flag.nothing}
end
function goSpeciPos(p, d, f, a) -- 2014-03-26 增加a(加速度参数)
	local idir
	local iflag
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end

	if f ~= nil then
		iflag = f
	else
		iflag = 0
	end

	local mexe, mpos = SmartGoto{pos = p, dir = idir, flag = iflag, acc = a}
	return {mexe, mpos}
end

function goSimplePos(p, d, f)
	local idir
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end

	if f ~= nil then
		iflag = f
	else
		iflag = 0
	end

	local mexe, mpos = SimpleGoto{pos = p, dir = idir, flag = iflag}
	return {mexe, mpos}
end

function runMultiPos(p, c, d, idir, a)
	if c == nil then
		c = false
	end

	if d == nil then
		d = 20
	end

	if idir == nil then
		idir = dir.shoot()
	end

	local mexe, mpos = RunMultiPos{ pos = p, close = c, dir = idir, flag = flag.not_avoid_our_vehicle, dist = d, acc = a}
	return {mexe, mpos}
end

--~ p为要走的点,d默认为射门朝向
function goCmuRush(p, d, a, f, r, v)
	local idir
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function forcekick(p,d,chip,power)
	local ikick = chip and kick.chip or kick.flat
	local ipower = power and power or 8000
	local idir = d and d or dir.shoot()
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.force_kick}
end

function shoot(p,d,chip,power)
	local ikick = chip and kick.chip or kick.flat
	local ipower = power and power or 8000
	local idir = d and d or dir.shoot()
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.nothing}
end
------------------------------------ 防守相关的skill ---------------------------------------
-- TODO
----------------------------------------- 其他动作 --------------------------------------------

-- p为朝向，如果p传的是pos的话，不需要根据ball.antiY()进行反算
function goBackBall(p, d)
	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = flag.dodge_ball}
	return {mexe, mpos}
end

-- 带避车和避球
function goBackBallV2(p, d)
	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = bit:_or(flag.allow_dss,flag.dodge_ball)}
	return {mexe, mpos}
end

function stop()
	local mexe, mpos = Stop{}
	return {mexe, mpos}
end

function continue()
	return {["name"] = "continue"}
end

------------------------------------ 测试相关的skill ---------------------------------------

function openSpeed(vx, vy, vdir)
	local spdX = function()
		return vx
	end

	local spdY = function()
		return vy
	end
	
	local spdW = function()
		return vdir
	end

	local mexe, mpos = OpenSpeed{speedX = spdX, speedY = spdY, speedW = spdW}
	return {mexe, mpos}
end

function speed(vx, vy, vdir)
	local spdX = function()
		return vx
	end

	local spdY = function()
		return vy
	end
	
	local spdW = function()
		return vdir
	end

	local mexe, mpos = Speed{speedX = spdX, speedY = spdY, speedW = spdW}
	return {mexe, mpos}
end

-------------------------------湖-----------------
function enemymsg_lr(role)
		local enemy_Y = {}
		local count = 1
		local grade_l = 0
		local grade_r = 0
		local y = player.posY(role)
		for i = 0,param.maxPlayer,1 do
			if (enemy.valid(i)) then
				enemy_Y[count] = enemy.posY(i)
				count = count + 1
			end
		end
		for i = 1,count - 1 do
			if(enemy_Y[i] > y) then
				grade_l = grade_l + 1
			else
				grade_r = grade_r + 1
			end
		end
		if(grade_l > grade_r) then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0),"l",1)
			return 'l'
		else 
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0),"r",1)
			return 'r'
		end
end

function CrossOverKick(role,p,time,flag)--变向运球过人
		local flag_ = enemymsg_lr(role)
		local p1 = p
		if type(p) == 'function' then
		  	p1 = p()
		else
		  	p1 = p
		end
	return function()
		if(player.infraredCount(role) < time) then
			if flag_ == 'l' then
					local pp = ball.pos() + Utils.Polar2Vector(-200,((player.pos(role) - ball.pos()):rotate(math.pi / 2)):dir())
					-- local idir
					local mexe, mpos = GoCmuRush{pos = pp, dir = dir.shoot(), acc = 1800, flag = 0x00000100,rec = r,vel = v}
					return {mexe, mpos}
			else
					local pp = ball.pos() + Utils.Polar2Vector(-200,((player.pos(role) - ball.pos()):rotate(-math.pi / 2)):dir())
					-- local idir
					local mexe, mpos = GoCmuRush{pos = pp, dir = dir.shoot(), acc = 1800, flag = 0x00000100,rec = r,vel = v}
					return {mexe, mpos}
			end
		elseif(player.infraredCount(role) <=  1.7 * time and player.infraredCount(role) >= time) then
			if flag == 'r' then
					local pp = ball.pos() + Utils.Polar2Vector(-200,((player.pos(role) - ball.pos()):rotate(-math.pi / 2)):dir())
					-- local idir
					local mexe, mpos = GoCmuRush{pos = pp, dir = dir.shoot(), acc = 1800, flag = 0x00000100,rec = r,vel = v}
					return {mexe, mpos}
			else
					local pp = ball.pos() + Utils.Polar2Vector(-200,((player.pos(role) - ball.pos()):rotate(math.pi / 2)):dir())
					-- local idir
					local mexe, mpos = GoCmuRush{pos = pp, dir = dir.shoot(), acc = 1800, flag = 0x00000100,rec = r,vel = v}
					return {mexe, mpos}
			end
		else
			local p1
			if type(p) == 'function' then
			  	p1 = p()
			else
			  	p1 = p
			end
			px = p1:x()
			py = p1:y()
			local ipos = p1 or pos.theirGoal()
			local idir = function(runner)
				return (ipos - player.pos(runner)):dir()
			end
			local error__ = function()
				return 180 * math.pi / 180.0
			end
			local mexe, mpos = Touch{pos = p, useInter = ifInter}
			return {mexe, mpos, kick.flat, idir, error__, kp.specified(smartshootpow), kp.specified(smartshootpow), 0x00000000}

		end
	end
end
-- module(..., package.seeall)

-- --~		Play中统一处理的参数（主要是开射门）
-- --~		1 ---> task, 2 ---> matchpos, 3---->kick, 4 ---->dir,
-- --~		5 ---->pre,  6 ---->kp,       7---->cp,   8 ---->flag
-- -------------------------------------------config -------------------------------------
-- --用于改全局变量 
-- local dis =75 --所有拿球task的dist值 实地车拿不到球就改小 
-- local smartshootpow = 5000
-- local passh =600
-- local passl =6000--200    --测试给6000


-- --------------------------------------Judge函数 ---------------------------------------------
-- function ball_is_ctrl()   --判断球是否被我方控制  判断条件 红外 距离 返回车号 
--                         --  用法      if task.ball_is_ctrl()>=0 then
--     local msgPos=CGeoPoint:new_local(0,-3400)
--     local msgPos2=CGeoPoint:new_local(-300,-3600)
--     local num=-1
--     for i = 0, 15 do
--         if    player.infraredOn(i)  then --player.toBallDist(i)< 200  and
--             debugEngine:gui_debug_arc(player.pos(i),200,0,math.pi*2*100,4)
--             --debugEngine:gui_debug_msg(msgPos,"Ball_Ctrl",4)
--             num=i
--         end
--     end 
--     debugEngine:gui_debug_msg(msgPos2," 我方    号控球" ,4)
--     debugEngine:gui_debug_msg(msgPos2,"       "..num ,5)         
--     return num     
-- end


-- function ball_is_danger() --判断球是否被敌方控制  判断条件 距离 返回车号 
--                         --  用法      if task.ball_is_ctrl()>=0 then
--     local msgPos=CGeoPoint:new_local(-0,-3300)
--     local msgPos2=CGeoPoint:new_local(-300,-3300)
--     local num=-1
--     for i = 0,15 do
--         if  (enemy.pos(i)-ball.pos()):mod() < 280  then
--             debugEngine:gui_debug_arc(enemy.pos(i),200,0,math.pi*2*100,1)
--             --debugEngine:gui_debug_msg(msgPos,"Ball_Ctrl",4)
--             num=i
--         end
--     end 
--     debugEngine:gui_debug_msg(msgPos2," 敌方    号控球" ,2)
--     debugEngine:gui_debug_msg(msgPos2,"       "..num ,7)         
--     return num     
-- end

-- function pass_is_break (role1,role2)   --判断是否被敌方挡住  判断条件 距离 返回车号 
-- 										--  用法  if task.ball_is_break()>=0 then
                                        
--     local msgPos=CGeoPoint:new_local(500,-3300)
--     local msgPos2=CGeoPoint:new_local(800,-3500)
--     local num=-1
--     for i = 0,15 do
--         local player_line = CGeoLine:new_local(player.pos(role1),(player.pos(role2) - player.pos(role1)):dir())
--         local target_pos = player_line:projection(enemy.pos(i))
--         local toLinedist = (enemy.pos(i) - target_pos):mod()
--         local toPlayer1dist =(enemy.pos(i) - player.pos(role1)):mod()
--         local toPlayer2dist =(enemy.pos(i) - player.pos(role2)):mod()
--         local Playerdistsum =(player.pos(role1) - player.pos(role2)):mod()
        
--         if  toLinedist < 200  and  toPlayer1dist+toPlayer2dist<Playerdistsum*1.05 then
--             debugEngine:gui_debug_arc(enemy.pos(i),200,0,math.pi*2*100,8)
--             debugEngine:gui_debug_msg(msgPos,"Enemy_Break "..num,4)
--             --debugEngine:gui_debug_msg(msgPos,'1+1='..math.ceil (toPlayer1dist+toPlayer2dist))
--            -- debugEngine:gui_debug_msg(msgPos2,'sum='..math.ceil(Playerdistsum))
--             --debugEngine:gui_debug_msg(msgPos2,'k='..((toPlayer1dist+toPlayer2dist)/Playerdistsum))--改k比值
--             num=i
--         end
--     end       
--     return num     
-- end

-- Goalienum =function()--得到对方门将车号      返回车号
-- 	local num =-1
-- 	for i=0,param.maxPlayer-1 do
-- 	    if enemy.isGoalie(i)  and enemy.valid(i) then
-- 	       	debugEngine:gui_debug_msg(CGeoPoint:new_local(3900,-3300),'门将是   号',1)
-- 	        debugEngine:gui_debug_msg(CGeoPoint:new_local(3900,-3300),'          '..i,2) 
-- 	    	return i	
-- 	    end
-- 	end 
--     return num   
-- end

-- function ball_vel()--判断是否超速，超速变红                               
--     local msgPos=CGeoPoint:new_local(1000,-3300)
--     local msgPos2=CGeoPoint:new_local(800,-3500)
--     debugEngine:gui_debug_msg(msgPos,'球速： '..math.ceil( ball.velMod())	,5)
--         if ball.velMod()>6500 then
--             debugEngine:gui_debug_arc(ball.pos(),500,0,400,1)
--             debugEngine:gui_debug_msg(ball.pos(),'超速',1)
--         end          
-- end

-- function getball_dis()   --打印每次的拿球距离
-- 	get_dis = {}
-- 	local s = 1
-- 	local dissum=0
-- 	local msgPos2=CGeoPoint:new_local(800,3500)
-- 	for j = 0,15 do
-- 		if player.infraredOn(j) then
-- 			get_dis[s] = player.toBallDist(j)
-- 			s = s + 1
-- 		end
-- 	end 
-- 	--local enemy_min = math.max(unpack(enemy_dis))
-- 	for i = 1,#get_dis do 
-- 		dissum =dissum +get_dis[i]
-- 	end
-- 	local  dis_ave = dissum/#get_dis
-- 	 debugEngine:gui_debug_msg(msgPos2,"getball_dis:"..math.ceil(dis_ave),5)
-- end
-- ------------------------------------- skill测试区 ---------------------------------------

-- -----------------------------------------V1系列--------------------------------------------
-- function getballV1(role)	--拿球 若球旁无敌方车则直接拿 有则抢球（避免撞车）
--  	return function()		--拿球 
--  		--local dis = 70  		--实地拿不到球可以改这里的dis
--     	local msgPos=CGeoPoint:new_local(0,0)
--     	local msgPos2=CGeoPoint:new_local(300,0)
--     	local idir = function()
--     			return dir.playerToBall(role)      
-- 			end
-- 		if ball_is_danger()>=0  then
-- 			--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)
-- 			debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getaball抢球',1)
-- 			local ipos=function() 
--     			return function ()
--         			return ball.pos()+ Utils.Polar2Vector(dis,(ball.pos()-enemy.pos(ball_is_danger())):dir())
--         		end
-- 			end
--     		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
--     	else 
-- 			local ipos=function() 
--     			return function ()
--         			return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role) - ball.pos()):dir())
--         		end
-- 			end
-- 			--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)
--     		debugEngine:gui_debug_msg(msgPos+Utils.Polar2Vector(500,math.pi),'getball拿球',4)
--     		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		end
-- 	end
-- end

-- function passballV1(role1,role2) --传球 1给2 当没球时会先拿球 敌方车挡路会挑射
-- 	return function()
-- 		--local dis = 100 --实地拿不到球可以改这里的dis
-- 		local msgPos2=CGeoPoint:new_local(300,0)
		
-- 		local ipower =function() --game 300 test 3000
-- 			return function()
-- 				return passl+ (passh-passl)*(player.pos(role1)-player.pos(role2)):mod()/10800 --待改进动态力			
-- 			end				
-- 		end	
		
-- 		local idir = function()
--        		return player.toPlayerDir(role1,role2)
-- 		end 	
-- 		local ipos = function()
-- 			return function()
-- 		    	return ball.pos() + Utils.Polar2Vector(-dis,idir())
--    		 	end
--    		end	
   		
--    		if player.infraredOn(role1)  then 
--    			-- if pass_is_break(role1,role2) >=0 then 	
-- 			-- 	local mexe, mpos = GoCmuRush{pos = ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 			-- 	debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'passball挑传',4)
-- 			-- 	return {mexe, mpos, kick.chip, idir, pre.middle,ipower(),ipower(), flag.dribbling}--实地调参
-- 			-- else
-- 				local mexe, mpos = GoCmuRush{pos = ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 				debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'passball平传',4)
-- 				return {mexe, mpos, kick.flat, idir, pre.middle,ipower(),ipower(), flag.dribbling}--实地调参
-- 			--end
-- 		else
-- 			local idir2 = function()
--     			return dir.playerToBall(role1)      
-- 			end
-- 			local ipos2=function() 
--     			return function ()
--         			return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role1) - ball.pos()):dir())
--         		end
-- 			end
-- 			debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role1)),2)
--     		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'passball拿球',4)
--     		local mexe, mpos = GoCmuRush{pos =ipos2(), dir = idir2, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		end		
-- 	end
-- end

-- function quickpass(role1,role2)
-- 	return function()
-- 		--local dis=100
-- 		local msgPos2=CGeoPoint:new_local(300,0)
-- 		local ipos=function() 
--     		return function ()
--         		return player.pos(role2)
--         	end
-- 		end
-- 		local idir = function()
-- 			return (player.pos(role2)-player.pos(role1)):dir()
-- 		end
-- 		local ipower =function() --game 300 test 3000
-- 				return function()
-- 					if (player.pos(role1)-player.pos(role2)):mod()>3000 then --待改进动态力度
-- 						return  350
-- 					else 
-- 						return	200
-- 					end			
-- 				end	
-- 			end	
-- 		if player.infraredOn(role1) then  
-- 			debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'quickpass传球',4)
-- 			local mexe, mpos = Touch{pos = ipos(), useInter = false}
-- 			return {mexe, mpos, kick.flat, idir, pre.low, ipower(), cp.full, flag.dribbling}
-- 		else
-- 			local idir2 = function()
-- 	    		return dir.playerToBall(role1)      
-- 			end
-- 			local ipos2=function() 
-- 	    		return function ()
-- 	        		return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role1) - ball.pos()):dir())
-- 	        	end
-- 			end
-- 			debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role1)),2)
-- 	    	debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(500,math.pi),'quickpass拿球',4)
-- 	    	local mexe, mpos = GoCmuRush{pos =ipos2(), dir = idir2, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		end
-- 	end	 --快速传球 
-- end

-- function smartshootV1(role) --射门 球不在嘴边就绕到球后
-- 	return function()
-- 		--local dis =100 
-- 		local msgPos2=CGeoPoint:new_local(300,0)
-- 		local goalPos = CGeoPoint:new_local(4500,0)
-- 		local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
-- 		local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
-- 		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- 		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- 		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- 		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)            
-- 		local ipower =function() --game 300 test 3000
-- 			return function()
-- 				debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(30,math.pi),math.ceil(ball.velMod()),6) --实地改力度
-- 				return smartshootpow 
-- 			end
-- 		end	
-- 	    local shootP = function()
-- 			return function()
-- 				local goalPos = CGeoPoint(param.pitchLength/2,0)
-- 				return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
-- 			 end
-- 	    end 
-- 	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
--  		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
-- 		if dir_cond < 0.02  and  dis_cond < 300 and dis_cond > 0 then  --精度改 dir_cond
-- 			local idir =function()
-- 			 	if Goalienum() >=0 then		
-- 					if  dir_shoot_l >= dir_shoot_r then 
-- 						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
-- 						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
-- 						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
-- 						return dir.playerToPoint(shootPos_l,role)
-- 					end
-- 						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- 						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
-- 						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
-- 						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
-- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
-- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
-- 	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
-- 			   			return dir.playerToPoint(shootPos_r,role)
-- 			   	else 
-- 			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
-- 			   		return (goalPos-player.pos(role)):dir()	
-- 			   	end		          	    
-- 			end  	
-- 			local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 			return {mexe, mpos, kick.flat, idir, pre.middle, ipower(), ipower(), flag.dribble}
-- 		else		
--     		local idir =function() 
--     		-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,1)
-- 			-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,1)
--     		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(1000,math.pi),'smartshoot绕球',4)	
-- 		    return dir.playerToPoint(ball.pos(),role)          	    
-- 			end
--     		local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = flag.dodge_ball + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		end	
-- 	end	
-- end

-- function recballV1(role) --接球
-- 	return function ()
-- 		msgPos=CGeoPoint:new_local(500,-3000)
-- 		msgPos2=CGeoPoint:new_local(300,-2700)
-- 		local idir=function()
-- 	   		return  dir.playerToBall(role)
-- 		end
--     	local ipos=function()
--     		if ball.valid() then
--     			 debugEngine:gui_debug_msg(msgPos,'ball_dir'..math.ceil(ball.velDir()))
--     			 debugEngine:gui_debug_msg(msgPos2,'player_dir'..math.ceil(dir.playerToBall(role)))
-- 				if ball.velMod() >1000   then     --判断方向是否一致--and   ball.velDir()*dir.playerToBall(role)<0
-- 	       			local k1=math.tan(ball.velDir()) 
-- 	       			local k2=-1/k1
-- 	       			local x=(k1*ball.posX() - k2*player.posX(role) + player.posY(role) - ball.posY())/(k1-k2)
-- 	      			local y=k1*(x-ball.posX())+ball.posY()
-- 	          		return  CGeoPoint:new_local(x,y)
-- 	   			else
-- 	          		return  ball.pos() + Utils.Polar2Vector(-dis,idir())
--        		 	end
--    			else 
--          		return CGeoPoint:new_local(0,0)  
--     		end
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos =ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos, kick.none, idir, pre.low, kp.specified(0), cp.full, flag.dribbling}
-- 	end --接球，改动不大 添加了方向判断 
-- end


-- function marking(xmin,xmax,ymin,ymax,p)------区域防守,适合角球防守--区域无人就回p点
-- 	local num = 0
-- 	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
-- 	local checkNum = function()
-- 		local between = function(a,min,max)
-- 			if a > min and a < max then
-- 				return true
-- 			end
-- 			    return false		    
-- 		    end  
-- 		local num = -1
-- 		for i = 0,param.maxPlayer-1 do
-- 			if enemy.valid(i) and between(enemy.posX(i),xmin,xmax) and between(enemy.posY(i),ymin,ymax) then
-- 				return i
-- 			end
-- 		end
-- 		return num
-- 	end

-- 	local ipos = function()
-- 		local num = checkNum()
-- 		local enemyPos = enemy.pos(num)
-- 		if num < 0 then
-- 		--enemyPos  = CGeoPoint:new_local((xmin + xmax)/5.0,(ymin + ymax)/2.0)
-- 		enemyPos  = p
-- 		end
-- 		local res
-- 		local l = (ourGoal - enemyPos):mod()*0.3
-- 		res = enemyPos + Utils.Polar2Vector(l,(ourGoal - enemyPos):dir())
-- 		return res
-- 	end
-- 	local idir = function(runner)
-- 		local num = checkNum()
-- 		local res
-- 		local enemyPos = enemy.pos(num)
-- 		if num < 0 then
-- 	    enemyPos  = p
-- 	   -- enemyPos  = CGeoPoint:new_local((xmin + xmax)/5.0,(ymin + ymax)/2.0)
-- 		end
-- 		res = (enemyPos - ourGoal):dir()	   
-- 		return res
-- 	end

-- local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end

-- function mydef(k,a)
-- 	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
-- 	local ipos =function()
-- 	   local res
-- 	   local l= ( ourGoal- ball.pos()):mod()*k
-- 	    res = ourGoal + Utils.Polar2Vector(l,(ball.pos()-ourGoal):dir())
-- 	    return res 
-- 	end    
-- 	local idir	= function()	
--       local res
--       res = (ball.pos() - ourGoal):dir()
--       return res 
--     end
--   local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f, rec = r, vel = v}
--   return {mexe, mpos}
-- end

-- function inter()
-- 	local ipos = function()
-- 		local res
-- 		if ball.velMod() < 1000 then
-- 			str = '22'
-- 			res = ball.pos() + Utils.Polar2Vector(-98,ball.toTheirGoalDir())
-- 		else
-- 			str = '33'
-- 			res = ball.pos() + Utils.Polar2Vector(0.4 * ball.velMod(),ball.vel():dir())
-- 		end
-- 		--debugEngine:gui_debug_msg(CGeoPoint:new_local(0,200),"dpos!". str,3)
-- 		return res
-- 	end
-- 	local idir = function(runner)
-- 		local res 
-- 		local str = '11'
-- 		if ball.velMod() < 500 then
-- 			str = '22'
-- 			res = ball.toTheirGoalDir()
-- 		else
-- 			str = '33'
-- 			res = (ball.pos() - player.pos(runner)):dir()
-- 		end

-- 		return res 
-- 	end
-- 	local mexe,mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f, rec = r, vel = v}
-- 	return {mexe,mpos}
-- end
-- -------------------------------------------------点球-------------------------------------------------------------------
-- function we_will_win(role)----------点球决胜 
-- 	return function()  
-- 		--local dis = 75   
-- 		local msgPos=CGeoPoint:new_local(0,0)
-- 		debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role)),2)                            
--         local num = -1
--         ball_vel()
--         function goalie0()
-- 			for i = 0,param.maxPlayer-1 do
-- 				if enemy.valid(i)  and enemy.posX(i)>2000 then
-- 					debugEngine:gui_debug_msg(msgPos,'门将 ：'..i,4)
-- 					num=i
-- 				end
-- 				return num
-- 			end
-- 		end  
-- 		local idir=function()   ------带球
--             	return player.toTheirGoalDir(role)         
--         	end
--     	local ipos=function() 
--             	return function()
--                 return ball.pos()+Utils.Polar2Vector(-dis,idir())
--     		end
--     	end    
--     	if goalie0()<0 or player.posX(role)>1000 then

--     		local idir2 =function()
-- 	 			local goalPos = CGeoPoint:new_local(4500,0)
-- 				local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
-- 				local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
-- 				local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- 				local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- 				local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- 				local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)  
-- 			 	if Goalienum() >=0 then		
-- 					if  dir_shoot_l >= dir_shoot_r then 
-- 						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
-- 						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
-- 						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
-- 						return dir.playerToPoint(shootPos_l,role)
-- 					end
-- 						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- 						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
-- 						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
-- 						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
-- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
-- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
-- 	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
-- 			   			return dir.playerToPoint(shootPos_r,role)
-- 			   	else 
-- 			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
-- 			   		return (goalPos-player.pos(role)):dir()	
-- 			   	end		          	    
-- 			end  	
-- 	 		 local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir2, acc = a, flag = f,rec = r,vel = v}
-- 			return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(350), cp.specified(500), flag.dribbling}
	 		
-- 	 	else	
    			
-- 	 		local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	 		return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(120), cp.full, flag.dribbling} 

	 		
			  
-- 		end 
-- 	end
-- end

-- function smartshoot_penalty(role) --点球射门
-- 	return function()
-- 		--local dis =85 
-- 		local msgPos2=CGeoPoint:new_local(300,0)
-- 		local goalPos = CGeoPoint:new_local(4500,0)
-- 		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- 		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- 		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- 		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2) 
-- 		ball_vel()
-- 		getball_dis()


-- 		local idir =function()
-- 			 	if Goalienum() >=0 then		
-- 					if  dir_shoot_l > dir_shoot_r then 
-- 						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
-- 						return dir.playerToPoint(shootPos_l,role)
-- 					end
-- 						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- 			   			return dir.playerToPoint(shootPos_r,role)
-- 			   	else 
-- 			   		return (goalPos-player.pos(role)):dir()	
-- 			   	end		          	    
-- 			end  	  
-- 		local ipos =function()
-- 			 	if Goalienum() >=0 then		
-- 					if  dir_shoot_l > dir_shoot_r then 
-- 						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
-- 						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
-- 						return ball.pos() +Utils.Polar2Vector(dis,(ball.pos()-shootPos_l):dir())
-- 					end
-- 						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- 						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
-- 			   			return ball.pos() +Utils.Polar2Vector(dis,(ball.pos()-shootPos_r):dir())
-- 			   	else 
-- 			   			debugEngine:gui_debug_line(goalPos,player.pos(role),7)
-- 			   		return ball.pos() +Utils.Polar2Vector(dis,(ball.pos()-goalPos):dir())	
-- 			   	end		          	    
-- 		end  	        
-- 	    -- local ipos = function()
-- 		-- 	return function()
-- 		-- 		local goalPos = CGeoPoint(param.pitchLength/2,0)
-- 		-- 		return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
-- 		-- 	 end
-- 	    -- end 
-- 	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
--  		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
-- 			local fff=flag.dribbling  + flag.our_ball_placement -- flag.force_kick
-- 			local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = fff,rec = r,vel = v}
-- 			return {mexe, mpos, kick.flat, idir, pre.middle, kp.specified(smartshootpow), kp.specified(smartshootpow),fff}
-- 	end	
-- end

-- ------------------------------------ 跑位相关的skill ---------------------------------------
-- --~ p为要走的点,d默认为射门朝向
-- function goalie()
-- 	local mexe, mpos = Goalie()
-- 	return {mexe, mpos}
-- end
-- function touch()
-- 	local ipos = pos.ourGoal()
-- 	local mexe, mpos = Touch{pos = ipos}
-- 	return {mexe, mpos}
-- end
-- function touchKick(p,ifInter)
-- 	local ipos = p or pos.theirGoal()
-- 	local idir = function(runner)
-- 		return (ipos - player.pos(runner)):dir()
-- 	end
-- 	local mexe, mpos = Touch{pos = ipos, useInter = ifInter}
-- 	return {mexe, mpos, kick.flat, idir, pre.low, cp.full, cp.full, flag.nothing}
-- end
-- function goSpeciPos(p, d, f, a) -- 2014-03-26 增加a(加速度参数)
-- 	local idir
-- 	local iflag
-- 	if d ~= nil then
-- 		idir = d
-- 	else
-- 		idir = dir.shoot()
-- 	end

-- 	if f ~= nil then
-- 		iflag = f
-- 	else
-- 		iflag = 0
-- 	end

-- 	local mexe, mpos = SmartGoto{pos = p, dir = idir, flag = iflag, acc = a}
-- 	return {mexe, mpos}
-- end

-- function goSimplePos(p, d, f)
-- 	local idir
-- 	if d ~= nil then
-- 		idir = d
-- 	else
-- 		idir = dir.shoot()
-- 	end

-- 	if f ~= nil then
-- 		iflag = f
-- 	else
-- 		iflag = 0
-- 	end

-- 	local mexe, mpos = SimpleGoto{pos = p, dir = idir, flag = iflag}
-- 	return {mexe, mpos}
-- end

-- function runMultiPos(p, c, d, idir, a)
-- 	if c == nil then
-- 		c = false
-- 	end

-- 	if d == nil then
-- 		d = 20
-- 	end

-- 	if idir == nil then
-- 		idir = dir.shoot()
-- 	end

-- 	local mexe, mpos = RunMultiPos{ pos = p, close = c, dir = idir, flag = flag.not_avoid_our_vehicle, dist = d, acc = a}
-- 	return {mexe, mpos}
-- end

-- --~ p为要走的点,d默认为射门朝向
-- function goCmuRush(p, d, a, f, r, v)
-- 	local idir
-- 	if d ~= nil then
-- 		idir = d
-- 	else
-- 		idir = dir.shoot()
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end

-- function forcekick(p,d,chip,power)
-- 	local ikick = chip and kick.chip or kick.flat
-- 	local ipower = power and power or 350
-- 	local idir = d and d or dir.shoot()
-- 	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.forcekick}
-- end

-- function shoot(p,d,chip,power)
-- 	local ikick = chip and kick.chip or kick.flat
-- 	local ipower = power and power or 350
-- 	local idir = d and d or dir.shoot()
-- 	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos, ikick, idir, pre.middle, kp.specified(ipower), cp.full, flag.nothing}
-- end
-- ------------------------------------ 防守相关的skill ---------------------------------------
-- -- TODO
-- ----------------------------------------- 其他动作 --------------------------------------------

-- -- p为朝向，如果p传的是pos的话，不需要根据ball.antiY()进行反算
-- function goBackBall(p, d)
-- 	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = flag.dodge_ball}
-- 	return {mexe, mpos}
-- end

-- -- 带避车和避球
-- function goBackBallV2(p, d)
-- 	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = bit:_or(flag.allow_dss,flag.dodge_ball)}
-- 	return {mexe, mpos}
-- end

-- function stop()
-- 	local mexe, mpos = Stop{}
-- 	return {mexe, mpos}
-- end

-- function continue()
-- 	return {["name"] = "continue"}
-- end
-- ------------------------------------ 测试相关的skill ---------------------------------------
-- function openSpeed(vx, vy, vdir)
-- 	local spdX = function()
-- 		return vx
-- 	end

-- 	local spdY = function()
-- 		return vy
-- 	end
	
-- 	local spdW = function()
-- 		return vdir
-- 	end

-- 	local mexe, mpos = OpenSpeed{speedX = spdX, speedY = spdY, speedW = spdW}
-- 	return {mexe, mpos}
-- end
-- function speed(vx, vy, vdir)
-- 	local spdX = function()
-- 		return vx
-- 	end

-- 	local spdY = function()
-- 		return vy
-- 	end
	
-- 	local spdW = function()
-- 		return vdir
-- 	end

-- 	local mexe, mpos = Speed{speedX = spdX, speedY = spdY, speedW = spdW}
-- 	return {mexe, mpos}
-- end


-- function getball_placeball(role)  	--拿球（最简单的拿球，笨）                                     
-- 	local idir = function()
--     	return dir.playerToBall(role)      
-- 	end
-- 	local ipos=function() 
--     	return function ()
--         	return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role) - ball.pos()):dir())
--         end
-- 	end      
-- 	local ff=flag.dribbling+flag.allow_dss+flag.our_ball_placement
-- 	local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = ff,rec = r,vel = v}
-- 	return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(0), cp.full, ff}--不吸球的话就改dribbling 
-- end
-- ----------------------------------------------传球------------------------------------------------------------
-- function getball(role)  	--拿球（最简单的拿球，笨）                                     
-- 	local idir = function()
--     	return dir.playerToBall(role)      
-- 	end
-- 	local ipos=function() 
--     	return function ()
--         	return ball.pos()+ Utils.Polar2Vector(100,(player.pos(role) - ball.pos()):dir())
--         end
-- 	end      
-- 	local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(0), cp.full, flag.dribble+flag.allow_dss}--不吸球的话就改dribbling 
-- end
-- function passball(role1,role2) --传球 1给2 当没球时会先拿球
-- 	return function()
-- 		local dis = 100 --实地拿不到球可以改这里的dis
-- 		local ikick = chip and kick.chip or kick.flat
-- 		local ipower =function() --game 300 test 3000
-- 			return function()
-- 				if (player.pos(role1)-player.pos(role2)):mod()>3000 then --待改进动态力度
-- 					return  350
-- 				else 
-- 					return	200
-- 				end				
-- 			end	
-- 		end	
-- 		--local ipower = power and power or 200
-- 		local idir = function()
--        		return player.toPlayerDir(role1,role2)
-- 		end 	
-- 		local ipos = function()
-- 			return function()
-- 		    	return ball.pos() + Utils.Polar2Vector(-dis,idir())
--    		 	end
--    		end	

--    		if player.infraredOn(role1) then  	
-- 			local mexe, mpos = GoCmuRush{pos = ipos(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 			return {mexe, mpos, ikick, idir, pre.middle,ipower(),cp.specified(ipower), flag.dribbling}--kp.specified(ipower)
-- 		else
-- 			local idir2 = function()
--     			return dir.playerToBall(role1)      
-- 			end
-- 			local ipos2=function() 
--     			return function ()
--         			return ball.pos()+ Utils.Polar2Vector(dis,(player.pos(role1) - ball.pos()):dir())
--         		end
-- 			end
-- 			debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),math.ceil(player.toBallDist(role1)),2)
--     		debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(500,math.pi),'拿球',4)
--     		local mexe, mpos = GoCmuRush{pos =ipos2(), dir = idir2, acc = a, flag = flag.dribbling + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		end		
-- 	end
-- end

-- function smartshoot(role) --射门 球不在嘴边就绕到球后
-- 	return function()
-- 		--local dis =100 
-- 		local msgPos2=CGeoPoint:new_local(300,0)
-- 		local goalPos = CGeoPoint:new_local(4500,0)
-- 		local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
-- 		local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
-- 		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- 		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- 		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- 		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)            
-- 		local ipower =function() --game 300 test 3000
-- 			return function()
-- 				debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(30,math.pi),math.ceil(ball.velMod()),6) --实地改力度
-- 				return smartshootpow 
-- 			end
-- 		end	
-- 	    local shootP = function()
-- 			return function()
-- 				local goalPos = CGeoPoint(param.pitchLength/2,0)
-- 				return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
-- 			 end
-- 	    end 
-- 	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
--  		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
-- 		if dir_cond < 0.02  and  dis_cond < 300 and dis_cond > 0 then  --精度改 dir_cond
-- 			local idir =function()
-- 			 	if Goalienum() >=0 then		
-- 					if  dir_shoot_l >= dir_shoot_r then 
-- 						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
-- 						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
-- 						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
-- 						return dir.playerToPoint(shootPos_l,role)
-- 					end
-- 						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- 						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
-- 						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
-- 						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
-- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
-- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
-- 	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
-- 			   			return dir.playerToPoint(shootPos_r,role)
-- 			   	else 
-- 			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
-- 			   		return (goalPos-player.pos(role)):dir()	
-- 			   	end		          	    
-- 			end  	
-- 			local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 			return {mexe, mpos, kick.flat, idir, pre.middle, ipower(), ipower(), flag.dribble}
-- 		else		
--     		local idir =function() 
--     		-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,1)
-- 			-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,1)
--     		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(1000,math.pi),'smartshoot绕球',4)	
-- 		    return dir.playerToPoint(ball.pos(),role)          	    
-- 			end
--     		local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = flag.dodge_ball + flag.allow_dss,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		end	
-- 	end	
-- end
-- function goCmuRushB(p,a, f, r, v)

-- 	local idir=function(runner)
-- 	 return  dir.playerToBall(runner)
-- 	end

-- 	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end
-- function recball()
-- 	local ipos = p or ball.pos()
-- 	local idir = function(runner)
-- 		return (ball.pos() - player.pos(runner)):dir()
-- 	end
-- 	local mexe, mpos = Touch{pos = ipos, useInter = ifInter}
-- 	return {mexe, mpos, kick.none, idir, pre.low, cp.full, cp.full, flag.dribbling}
-- end
-- function recball2(runner)
-- 	local idir=function()
-- 	   return  dir.playerToBall(runner)
-- 	end
--     local ipos=function()
--    		if ball.valid() then
-- 			if ball.velMod() >1000 then
-- 	      		local k1=math.tan(ball.velDir()) 
-- 	       		local k2=-1/k1
-- 	       		local x=(k1*ball.posX() - k2*player.posX(runner) + player.posY(runner) - ball.posY())/(k1-k2)
-- 	       		local y=k1*(x-ball.posX())+ball.posY()
-- 	         	return  CGeoPoint:new_local(x,y)
-- 	   		else
-- 	          	return  ball.pos() + Utils.Polar2Vector(-93,idir())
--         	end
--    		else 
--          	return CGeoPoint:new_local(-1000,0)  
--     	end
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos =ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos, kick.none, idir, pre.low, kp.specified(0), cp.full, flag.dribbling}
-- end

-- -----------------------------fangshou--------------------------------------------------------


-- -- function smartshoot_penalty(role) --射门 球不在嘴边就绕到球后
-- -- 	return function()
-- -- 		local dis =85 
-- -- 		local msgPos2=CGeoPoint:new_local(300,0)
-- -- 		local goalPos = CGeoPoint:new_local(4500,0)
-- -- 		local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 1
-- -- 		local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  --距离判断
-- -- 		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- -- 		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- -- 		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- -- 		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)            
-- -- 	    local shootP = function()
-- -- 			return function()
-- -- 				local goalPos = CGeoPoint(param.pitchLength/2,0)
-- -- 				return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
-- -- 			 end
-- -- 	    end 
-- -- 	    debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
-- --  		debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4) 	
-- -- 		if dir_cond < 0.02  and  dis_cond < 300 and dis_cond > 0 then  --精度改 dir_cond
-- -- 			local idir =function()
-- -- 			 	if Goalienum() >=0 then		
-- -- 					if  dir_shoot_l >= dir_shoot_r then 
-- -- 						local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2) 
-- -- 						--debugEngine:gui_debug_msg(ball.pos(),'左边',7)
-- -- 						debugEngine:gui_debug_line(shootPos_l,player.pos(role),7)
-- -- 						return dir.playerToPoint(shootPos_l,role)
-- -- 					end
-- -- 						local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- -- 						--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
-- -- 						--debugEngine:gui_debug_msg(ball.pos(),'右边',7)
-- -- 						debugEngine:gui_debug_line(shootPos_r,player.pos(role),7)
							
-- -- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,2)
-- -- 						-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,2)
-- -- 	    				--debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(1000,math.pi),'射门',1)
-- -- 			   			return dir.playerToPoint(shootPos_r,role)
-- -- 			   	else 
-- -- 			   		debugEngine:gui_debug_line(goalPos,player.pos(role),7)
-- -- 			   		return (goalPos-player.pos(role)):dir()	
-- -- 			   	end		          	    
-- -- 			end  	
-- -- 			local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- -- 			return {mexe, mpos, kick.flat, idir, pre.middle, kp.specified(3000), cp.full, flag.dribbling + flag.our_ball_placement}
-- -- 		else		
-- --     		local idir =function() 
-- --     		-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),dir_cond,1)
-- -- 			-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond) ,1)
-- --     		debugEngine:gui_debug_msg(msgPos2+Utils.Polar2Vector(1000,math.pi),'smartshoot绕球',4)	
-- -- 		    return dir.playerToPoint(ball.pos(),role)          	    
-- -- 			end
-- --     		local mexe, mpos = GoCmuRush{pos =shootP(), dir = idir, acc = a, flag =f,rec = r,vel = v}
-- -- 			return {mexe, mpos,kick.flat, idir, pre.high, kp.specified(0), cp.full, flag.our_ball_placement}
-- -- 		end	
-- -- 	end	
-- -- end
-- -----------------------------------------paodian-----------------------------------------------------------------------

-- function readyforshoot()   --
-- 	local idir = dir.shoot()
-- 	local shootGen = function()
-- 	return function()
-- 		local goalPos = CGeoPoint(param.pitchLength/2,0)
-- 		local pos = ball.pos() + Utils.Polar2Vector(150,(ball.pos() - goalPos):dir())
-- 		return pos
-- 	   end
--     end
-- 	local mexe, mpos = SmartGoto{pos = shootGen(), dir = idir, flag = flag.dodge_ball, acc = a}
-- 	return {mexe, mpos}
-- end

-- function readyforpass(role1,role2)
-- 	local idir = function()
-- 		return player.toPlayerDir(role1,role2)
-- 	end
-- 	local shootGen = function()
-- 	return function()
-- 		local playerPos = function()
-- 			return player.pos(role2)
-- 		end
-- 		local pos = ball.pos() + Utils.Polar2Vector(-180,(CGeoPoint:new_local(0,0)-ball.pos()):dir())--CGeoPoint:new_local(0,0))dir.ballToPoint(playerPos())
-- 		return pos
-- 	end
-- end
-- 	local mexe, mpos = SmartGoto{pos = shootGen(), dir = idir, flag = flag.dodge_ball, acc = a}
-- 	return {mexe, mpos}
-- end

-- -------------------------------------------自动放球----------------------------------
-- function Judge_inBallplacement(role) --------胶囊体 自动走出
-- 	return function()
-- 		local ball_line = CGeoLine:new_local(ball.pos(),(ball.pos() - ball.placementPos()):dir())
-- 		local target_pos = ball_line:projection(player.pos(role))
-- 		local toLinedist = (player.pos(role) - target_pos):mod()
-- 		--debugEngine:gui_debug_x(target_pos)
-- 		--debugEngine:gui_debug_x(player.pos(role) + Utils.Polar2Vector(600,(target_pos - player.pos(role)):dir()  + math.pi),3)
-- 		local pos = function(role)
-- 			return function()
-- 				return target_pos + Utils.Polar2Vector(500+param.playerRadius,(target_pos - player.pos(role)):dir() + math.pi)
-- 			end
-- 		end
-- 		if toLinedist < 500 then
-- 			local mexe, mpos = GoCmuRush{pos = pos(role), dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 			return {mexe, mpos}
-- 		else
-- 			local mexe, mpos = Stop{}
-- 			return {mexe, mpos}
-- 		end
-- 	end
-- end

-- function getball_ballplace(role)  	--拿球(放球)                                     
-- 	local idir = function()
--     	return dir.playerToBall(role)      
-- 	end
-- 	local ipos=function() 
--     	return function ()
--         	return ball.pos()+ Utils.Polar2Vector(100,(player.pos(role) - ball.pos()):dir())
--         end
-- 	end     
-- 	local ff= flag.dribbl+flag.allow_dss + flag.our_ball_placement
-- 	local mexe, mpos = GoCmuRush{pos =ipos(), dir = idir, acc = a, flag = ff,rec = r,vel = v}
-- 	return {mexe, mpos, kick.flat, idir, pre.low, kp.specified(0), cp.full, ff}--不吸球的话就改dribbling 
-- end

-- --------------------------------no--use--------------------------------------------
-- -- function quickKick()
-- -- 	local pos.theirGoal()
-- -- 	local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- -- 	local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- -- 	local idir = function(runner)
-- -- 		return (ipos - player.pos(runner)):dir()
-- -- 	end
-- -- 	local ipower =function() --game 300 test 3000
-- -- 			return function()
-- -- 				debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(30,math.pi),math.ceil(ball.velMod()),6) --实地改力度
-- -- 				return 400  
-- -- 			end
-- -- 		end	
-- -- 	local mexe, mpos = Touch{pos = pos.theirGoal(), useInter = false}
-- -- 	return {mexe, mpos, kick.flat, idir, pre.low, ipower(), cp.full, flag.dribbling}
-- -- end
-- -- function cshoot(role) --射门
-- -- 	return function()
-- -- 		local dis =100 
-- -- 		local goalPos = CGeoPoint:new_local(4500,0)
-- -- 		local dir_cond1 =1-(math.abs(math.abs((goalPos-player.pos(role)):dir()) - math.pi/4)*57.3)/45 --角度判度 1
-- -- 		local dis_cond1 = (player.pos(role) - goalPos):mod()  --距离判断 
-- -- 		Goalienum()
-- -- 		local dir_shoot_l = math.abs((player.pos(role)-CGeoPoint:new_local(4500,500)):dir()-(player.pos(role)-enemy.pos(Goalienum())):dir())*57.3
-- -- 		local dir_shoot_r = math.abs((player.pos(role)-CGeoPoint:new_local(4500,-500)):dir()-(player.pos(role)- enemy.pos(Goalienum())):dir())*57.3
-- -- 		function drawcycle()
-- -- 			for i = 0,4 do
-- -- 				debugEngine:gui_debug_arc(goalPos,i*800,57.3+math.pi/6*53.7,57.3*3+math.pi/8*53.7,3)
-- -- 				--debugEngine:gui_debug_line(CGeoPoint:new_local(600*i,500*i), CGeoPoint:new_local(4500,500*i),3)
-- -- 				--debugEngine:gui_debug_line(CGeoPoint:new_local(600*i,-500*i), CGeoPoint:new_local(4500,-500*i),3)
-- -- 				debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,500),4)
-- -- 				debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,-500),4)
-- -- 				debugEngine:gui_debug_line(enemy.pos(Goalienum()), player.pos(role),1)


-- -- 				debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),  math.ceil(dir_shoot_l ),1)
-- -- 				debugEngine:gui_debug_msg(CGeoPoint:new_local(0,200), math.ceil(dir_shoot_r) ,1)

-- -- 				-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(200,0),  'dir:'..dir_cond1,1)
-- -- 				-- debugEngine:gui_debug_msg(ball.pos()+Utils.Polar2Vector(400,200),'dis:'..math.ceil(dis_cond1) ,1)	
-- -- 			end
-- -- 		end
-- -- 		drawcycle()	
-- -- 		local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- -- 		local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- -- 		if enemy.valid(Goalienum()) and  dir_shoot_l >= dir_shoot_r then  
-- -- 			debugEngine:gui_debug_msg(ball.pos(),'左边',7)
-- -- 			local shootPos_l = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()+500)/2)
-- -- 			debugEngine:gui_debug_x(shootPos_l,7)
-- -- 		else
-- -- 			--debugEngine:gui_debug_line(player.pos(role), CGeoPoint:new_local(4500,1.5*enemy.posY(Goalienum())),7)
-- -- 			debugEngine:gui_debug_msg(ball.pos(),'右边',7)
-- -- 			local shootPos_r = CGeoPoint:new_local((enemy.pos(Goalienum()):x()+4500)/2,(enemy.pos(Goalienum()):y()-500)/2)
-- -- 			debugEngine:gui_debug_x(shootPos_r,7)
-- -- 		end	

-- -- 		local mexe, mpos = Stop{}
-- -- 		return {mexe, mpos}	
-- -- 	end	
-- -- end
-- -- function runshoot(role)
-- -- 	return function()
-- -- 		local dis =100 
-- -- 		local goalPos = CGeoPoint:new_local(4500,0)
-- -- 		local dir_cond =math.abs((goalPos-player.pos(role)):dir()-(goalPos-ball.pos()):dir())*57.3/180 --角度判度 归一
-- -- 		local dis_cond= ((player.pos(role) - goalPos):mod() -(ball.pos()- goalPos):mod() )  
-- -- 		local ipower =function() --game 300 test 3000
-- -- 			return function()
-- -- 				debugEngine:gui_debug_msg(ball.pos(),math.ceil(ball.velMod()),6) --实地改力度
-- -- 				return 4000  
-- -- 			end
-- -- 		end	
-- -- 	    local shootP = function()
-- -- 			return function()
-- -- 				local goalPos = CGeoPoint(param.pitchLength/2,0)
-- -- 				return ball.pos() + Utils.Polar2Vector(dis,(ball.pos() - goalPos):dir())
-- -- 			 end
-- -- 	    end
-- -- 		            --距离判断 
		
-- -- 	if dir_cond < 0.015 and dis_cond < 300 and dis_cond > 0 then
-- -- 		-- debugEngine:gui_debug_msg(ball.pos()+Utils.Po