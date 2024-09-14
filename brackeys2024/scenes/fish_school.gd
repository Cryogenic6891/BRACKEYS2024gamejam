extends Area3D

var player
@export var fish_game = preload("res://scenes/fish_game.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"): #If the ship enters the area, it's placed into the variable
		player = body


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"): #If the ship exits the area, it's removed from the variable
		player = null

func _process(_delta: float) -> void:
	if player: #If player exist in the area allow the interact input to be pressed
		if Input.is_action_just_pressed("ui_accept"):
			print("entering game")
			var new_fish_game = fish_game.instantiate()
			var subview_port = get_parent().get_node("%SubViewport")
			new_fish_game.position.x = subview_port.size.x / 2
			new_fish_game.position.y = subview_port.size.y / 2
			var game_view = subview_port.get_parent()
			game_view.visible = true
			subview_port.add_child(new_fish_game)
			queue_free()
	
			# these lines will be changed $Control/SubViewportContainer/SubViewportfor our game. It should call Raz' minigame
			#if player.objective_manager.meat_on_back.size() < 3: 
				#player.objective_manager.add_meat()
				#queue_free() #You won't need to queue_free the fish (I don't think)
