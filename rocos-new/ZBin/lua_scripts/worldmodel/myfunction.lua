local checkpass= function(role1,role2)-------------check chuan qiu lu xian shang you mei you di fang che liang 
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


	local checkdadianqiu= function(role1)-----da dian qiu
        local num =-1
          for i = 0,param.maxPlayer-1 do     
             local theirdist=function()
	        return  math.sqrt(math.pow(enemy.posX(i)-4500,2)+math.pow(enemy.posY(i),2))
	     end 
	     local ourdist= function()
	        return  player.toTheirGoalDist(role1)
             end
               local length = function()
                   if theirdist() < ourdist() and theirdist() > 1000   then
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