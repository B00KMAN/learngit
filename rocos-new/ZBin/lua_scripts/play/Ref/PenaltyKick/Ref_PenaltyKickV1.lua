
 ---------------------------------------------- 
--da dian qiu
local dqg = CGeoPoint:new_local(4500,0)

local dq1=CGeoPoint:new_local(3500,2500)
local dq2=CGeoPoint:new_local(3500,-2500)
local dq3=CGeoPoint:new_local(3500,-2200)
local dq4=CGeoPoint:new_local(3500,2200)
local dq5=CGeoPoint:new_local(3500,1000)



gPlayTable.CreatePlay{
firstState = "getball1",
["getball1"] = {
    switch = function()
        if cond.isNormalStart()  then
--         
            return"passball2"
        end
    end,
   ["Kicker"]   = task.goCmuRush(dq1),--to p32 middle
  ["Middle"]   = task.goCmuRush(dq2),
  ["Tier"]     = task.goCmuRush(dq3),
  ["Receiver"] = task.goCmuRush(dq4),                -- receive to paodian
  ["Defender"] = task.goCmuRush(dq5),
  ["Goalie"]   = task.goalie(),
  match = "{G}[KMTRD]"
},

["passball2"] = {
    switch = function()

    end,
   -- Leader   = task.passballV1('Leader',"Assister"),
  -- Assister = task.smartshoot('Assister'),
    Goalie = task.we_will_win('Goalie'),
    match = ""
    },


name = "Ref_PenaltyKickV1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
