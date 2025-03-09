local testPos  = {
    CGeoPoint:new_local(-2800,-2200),
    CGeoPoint:new_local(-2800,-2800),
    CGeoPoint:new_local(-2200,-2200),
    CGeoPoint:new_local(2000,2800)
}
local testPos1  = {
    CGeoPoint:new_local(2000,2800),
    CGeoPoint:new_local(-2800,2200),
    CGeoPoint:new_local(2800,-2800),
    CGeoPoint:new_local(2200,2200)
}
local n=0
local judget =20    --
local judgedis=200  --
local maxtime=300   -- 
----------------------------------------------------------------------------start---------------------------------------------------------------
gPlayTable.CreatePlay{
firstState = "run1",

["run1"] = {
    switch = function()
             return"getball"
    end,
    Assister = task.stop(),
    
    match  = "{A}"
},

------------------------------------------------------------------------getball---------------------------------

["getball"] = {
    switch = function()
        if player.infraredCount('Assister')>50 or bufcnt(true,200) then
           -- return "passball"

        end
    end,
   Assister = task.getballV2("Assister"),
    -- Assister = task.stop("Assister"),
    
    match = "{A}"
},

-----------------------------------------------------------------------passball-----------------------------------
["passball"] = {
    switch = function()
        if bufcnt(true,200)then
            return "passball1"
        end
    end,
    Assister = task.goCmuRush(testPos[1],math.pi+(player.pos('Assister')-testPos1[1]):dir(),2000,flag.dribbling),
   
    match = "{A}"
},   

---------------------------------------------------------------------recball----------------------------------------
["passball1"] = {
    switch = function()
        if bufcnt(true,200)then
            return 'passball2'
        end
    end,
    Assister = task.goCmuRush(testPos[2],math.pi+(player.pos('Assister')-testPos1[2]):dir(),2000,flag.dribbling),
   
    match = ""
},   

["passball2"] = {
    switch = function()
        if bufcnt(true,200)then
            return 'passball2'
        end
    end,
    Assister = task.goCmuRush(testPos[3],math.pi+(player.pos('Assister')-testPos1[3]):dir(),2000,flag.dribbling),
   
    match = ""
},


name = "testrun",
applicable ={
    exp = "a",
     a = true
},
attribute = "attack",
timeout = 99999
}