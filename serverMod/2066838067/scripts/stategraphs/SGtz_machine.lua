require("stategraphs/commonstates")

local actionhandlers = {}

local events = 
{
}


local states =
{   
	State{
		name = "idle",
		tags = {"idle"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle")
		end,
	},

	State{
		name = "spinning",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("use", false)
		end,

		timeline = 
		{
			TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("tz_machine/tz_machine/coinslot") end),
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("tz_machine/tz_machine/leverpull") end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("tz_machine/tz_machine/jumpup") end),
			TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("tz_machine/tz_machine/spin", "tzspin") end),
		},

		events = 
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("prize_"..inst.prizevalue) end),
		}
	},

	State{
		name = "prize_ok",
		tags = {""},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.prizevalue, false)
		end,

		timeline = 
		{
			TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:KillSound("tzspin") end),
			TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds[inst.prizevalue]) end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst:DoneSpinning()
			end),
		}
	},

	State{
		name = "prize_good",
		tags = {""},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.prizevalue, false)
		end,

		timeline = 
		{
			TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:KillSound("tzspin") end),
			TimeEvent(33*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds[inst.prizevalue]) end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst:DoneSpinning()
			end),
		}
	},

	State{
		name = "prize_bad",
		tags = {""},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation(inst.prizevalue, false)
		end,

		timeline = 
		{
			TimeEvent(31*FRAMES, function(inst) inst.SoundEmitter:KillSound("tzspin") end),
			TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds[inst.prizevalue]) end),
		},

		events = {
			EventHandler("animover", function(inst)
				inst:DoneSpinning()
			end),
		}
	},
}
	
return StateGraph("tz_machine", states, events, "idle", actionhandlers)
