
local testPos  = {
    CGeoPoint:new_local(0,0),
    CGeoPoint:new_local(2000,-2000),
    CGeoPoint:new_local(-2000,2000),
    CGeoPoint:new_local(2000,-2000)
}
    
gPlayTable.CreatePlay{

firstState = "run1",

["run1"] = {
    switch = function()
        task.ball_is_danger()
        task.ball_is_ctrl()
        task.ball_vel()
        task.Goalienum()

        if bufcnt(player.toTargetDist("Leader")<20 and player.toTargetDist("Assister")<20,10)  then
             return"getball"  
        end
    end,
    Assister = task.goCmuRush(testPos[3]),
    Leader   = task.goCmuRush(testPos[2]),
    
    match  = "{LA}"
},
["getball"] = {
    switch = function()
        task.ball_is_danger()
        task.ball_vel()
            

        if task.ball_is_ctrl() then
            return "passball"
        end
    end,
    Assister = task.getballV1("Assister"),
    Leader   = task.goCmuRushB(testPos[2]),
    match = ""
},
["passball"] = {
    switch = function()
        if player.kickBall("Assister") then
            return "recball"
        elseif bufcnt(true,500) then
            return "getball"
        end
    end,
    Assister = task.passballV1("Assister","Leader"),
    Leader   = task.goCmuRushB(testPos[2]),
    match = ""
},
["recball"] = {
    switch = function()
        
        if bufcnt(task.ball_is_ctrl(),30) then
            return "getball"
        elseif  bufcnt(true,500) then
            return "passball2" 
        end
    end,
    Assister = task.goCmuRushB(testPos[3]),
    Leader   = task.recballV1('Leader'),
    match = ""
},
["passball2"] = {
    switch = function()
        if player.kickBall("Leader") then
            return "recball2"
        elseif bufcnt(true,500) then
            return "getball"
        end
    end,
    Leader = task.passballV1("Leader","Assister"),
    Assister   = task.goCmuRushB(testPos[3]),
    match = ""

},
["recball2"] = {
    switch = function()
        if bufcnt(task.ball_is_ctrl(),30) then
            return "getball"
        elseif bufcnt(true,500)  then
            return "getball" 
        end
    end,
    Assister = task.recballV1('Assister'),
    Leader   = task.goCmuRushB(testPos[3]),
    match = ""
},


["passball"] = {
    switch = function()
        task.ball_vel()
        if bufcnt(player.kickBall("Assister")) then
            return "recball"
        elseif bufcnt(true,500) then
            return "getball"
        end
    end,
    Assister = task.passballV1("Assister","Leader"),
    Leader   = task.goCmuRushB(testPos[2]),
    match = ""
},
["recball"] = {
    switch = function()
        task.ball_vel()
        if bufcnt(true,500) then
            return "getball"
        elseif bufcnt(task.ball_is_ctrl(),30)  then
            return "passball2" 
        end
    end,
    Assister = task.goCmuRushB(testPos[3]),
    Leader   = task.recballV1('Leader'),
    match = ""
},
["passball2"] = {
    switch = function()
        task.ball_vel()
        if bufcnt(player.kickBall("Leader")) then
            return "recball2"
        elseif bufcnt(true,500) then
            return "getball"
        end
    end,
    Leader = task.passballV1("Leader","Assister"),
    Assister   = task.goCmuRushB(testPos[3]),
    match = ""

},
["recball2"] = {
    switch = function()
        task.ball_vel()
        if bufcnt(true,500) then
            return "getball"
        elseif bufcnt(task.ball_is_ctrl(),30)  then
            return "smart" 
        end
    end,
    Assister = task.recballV1('Assister'),
    Leader   = task.goCmuRushB(testPos[2]),
    match = ""
},

["smart"] = {
    switch = function()
        task.ball_vel()
        if bufcnt(true,500) then
            return "getball"
        end
    end,
    Assister = task.smartshootV1('Assister'),
    Leader   = task.goCmuRushB(testPos[2]),
    match = ""
},
name = "hqy",
applicable ={
    exp = "a",
    a = true
},
attribute = "attack",
timeout = 99999
}