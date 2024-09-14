extends Node

var stage_time_min: float = 0.0
var stage_time_sec: float = 0.0
var start_stage_time: float = 0.0
var end_stage_time: float = 7.0 # end in minutes
var phase_amount: float = 3
var current_phase: Array # [phase number,phase start time]
var phases: Array # Data structure: [[phase number,phase start time], [next phase,next phase time]
var timer_started: bool = false
var paused_start
var paused_resumed
var pause_adjustment = 0
var stored_sec = 0
var current_sec = 0

signal phase_changed(phase)
signal new_second

func start_timer():
	pause_adjustment = 0
	start_stage_time = float(Time.get_ticks_msec())/1000
	for phase in phase_amount:
		var phase_switch = end_stage_time*(phase/phase_amount)
		phases.append([phase+1,phase_switch])
	current_phase = phases.pop_front()
	timer_started = true

func _process(_delta):
	if timer_started:
		stage_time_sec = float(Time.get_ticks_msec())/1000 - start_stage_time - pause_adjustment
		current_sec = floori(stage_time_sec)
		if current_sec != stored_sec:
			new_second.emit()
			stored_sec = current_sec
		if stage_time_sec >= 60:
			stage_time_min += 1
			start_stage_time = float(Time.get_ticks_msec())/1000
			stage_time_sec = 0.0
		var fraction_of_minute = stage_time_sec/60
		if not phases.is_empty():
			if phases[0][1] <= stage_time_min + fraction_of_minute:
				current_phase = phases.pop_front()
				phase_changed.emit(current_phase)

func get_timer() -> String:
	var minute : String
	var sec : String
	if stage_time_min < 10:
		minute = "0" + str(stage_time_min)
	else:
		minute = str(stage_time_min)
	if stage_time_sec < 10:
		var to_int = floori(stage_time_sec)
		sec = "0" + str(to_int)
	else:
		var to_int = floori(stage_time_sec)
		sec = str(to_int)
	return minute+":"+sec

func pause_timer(paused:bool):
	if paused:
		paused_start = float(Time.get_ticks_msec())/1000
	else:
		paused_resumed = float(Time.get_ticks_msec())/1000
		pause_adjustment = paused_resumed - paused_start
