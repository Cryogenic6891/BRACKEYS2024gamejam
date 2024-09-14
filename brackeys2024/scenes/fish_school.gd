extends Area3D

var player
@export var fish_game: PackedScene

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"): #If the ship enters the area, it's placed into the variable
		player = body


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"): #If the ship exits the area, it's removed from the variable
		player = null

func _process(_delta: float) -> void:
	if player: #If player exist in the area allow the interact input to be pressed
		if Input.is_action_just_pressed("ui_accept"):
			fish_game.instantiate()
				
			# these lines will be changed for our game. It should call Raz' minigame
			#if player.objective_manager.meat_on_back.size() < 3: 
				#player.objective_manager.add_meat()
				#queue_free() #You won't need to queue_free the fish (I don't think)
