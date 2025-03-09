--三车互相传球，无限循环，供大家采纳   叶哥作

 local testPos  = {
    CGeoPoint:new_local(-2000,2000),
    CGeoPoint:new_local(2000,-2000),
    CGeoPoint:new_local(2000,2000),
    CGeoPoint:new_local(2000,3000)
}

gPlayTable.CreatePlay{

firstState = "run1",

["run1"] = {
    switch = function()
        if bufcnt(player.toTargetDist("Leader")<20 and player.toTargetDist("Assister")<20 and  player.toTargetDist("Receiver")<20,10)  then
             return"getball"
        end
    end,
    Assister = task.goCmuRush(testPos[1]),
    Leader   = task.goCmuRush(testPos[2]),
    Receiver = task.goCmuRush(testPos[3]),
    match  = "{LAR}"
},
["getball"] = {
    switch = function()
        if bufcnt(player.toBallDist("Assister")<200,20) then
            return "passball"
        end
    end,
    Assister = task.getballV1("Assister"),
    Leader   = task.goCmuRushB(testPos[2]),
    match = ""
},
["getball2"] = {
    switch = function()
        if bufcnt(player.toBallDist("Receiver")<200,20) then
            return "passball"
        end
    end,
    Receiver = task.getballV1("Receiver"),
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
    Receiver = task.goCmuRushB(testPos[3]),
    match = ""
},   
["recball"] = {
    switch = function()
        if  bufcnt(player.toBallDist("Leader")<200,10) then
            return "getball"
        elseif bufcnt(true,500) then
            return "passball2"
        end
    end,
    Assister = task.goCmuRushB(testPos[1]),
    Leader   = task.recballV1('Leader'),
    Receiver = task.goCmuRushB(testPos[3]),
    match = ""
},


name = "TestSkill",
applicable ={
    exp = "a",
    a = true
},
attribute = "attack",
timeout = 99999
}

