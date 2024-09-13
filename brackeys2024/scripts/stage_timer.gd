extends Node

var stage_time_min: float = 0.0
var stage_time_sec: float = 0.0
var start_stage_time: float = 0.0
var end_stage_time: float = 7.0 # end in minutes
var phase_amount: float = 3
var current_phase: Array # [phase number,phase start time]
var phases: Array # Data structure: [[phase number,phase start time], [next phase,next phase time]
var timer_started: bool = false

func start_timer():
	start_stage_time = Time.get_ticks_msec()/1000
	for phase in phase_amount:
		var phase_switch = end_stage_time*(phase/phase_amount)
		phases.append([phase+1,phase_switch])
	current_phase = phases.pop_front()
	timer_started = true

func _process(delta):
	if timer_started:
		stage_time_sec = Time.get_ticks_msec()/1000 - start_stage_time
		if stage_time_sec >= 60:
			stage_time_min += 1
			start_stage_time = Time.get_ticks_msec()/1000
			stage_time_sec = 0.0
		var fraction_of_minute = stage_time_sec/60
		if not phases.is_empty():
			if phases[0][1] <= stage_time_min + fraction_of_minute:
				current_phase = phases.pop_front()
		print(get_timer())

func get_timer() -> String:
	var min : String
	var sec : String
	if stage_time_min < 10:
		min = "0" + str(stage_time_min)
	else:
		min = str(stage_time_min)
	if stage_time_sec < 10:
		sec = "0" + str(stage_time_sec)
	else:
		sec = str(stage_time_sec)
	return min+":"+sec
