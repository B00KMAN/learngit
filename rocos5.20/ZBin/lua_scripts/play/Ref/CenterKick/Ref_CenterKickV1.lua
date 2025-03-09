gPlayTable.CreatePlay{
firstState = "halt",
switch = function()
    return "halt"
end,
["halt"] = {
    ["Goalie"]   = task.stop(),
    ["Kicker"]  = task.stop(),
    ["Receiver"] = task.stop(),
    ["Defender"] = task.stop(),
    ["Middle"]   = task.stop(),
    ["Tier"]   = task.stop(),
    
    match = "[GKRDMT]"
},

name = "Ref_CenterKickV1",
applicable ={
    exp = "a",
    a = true
},
attribute = "attack",
timeout = 99999
}
