extends Node

@onready var fish_spawners: Node3D = $"../FishSpawns"

#Sets the goal for the level, in our game could set the amount of possible fishing spots at one time
@export var level_goal := 3
@export var fish_school: PackedScene

##Create two empty arrays outside of any function
var possible_fish_spawns := [
	
]
var fish_spawns := [
	
]


func _ready() -> void:
	##This line might be not needed for our game
	#set_objective_for_level(level_goal)
	##

	#Looks at spawner node group and appends all children into possible spawn array
	for spawner in fish_spawners.get_children():
		possible_fish_spawns.append(spawner)
	
	spawn_fish() #Call function

func spawn_fish() -> void:
	# for each spawner, pick a spawner randomly (up to the meat goal for the level)
	for i in level_goal: #this is where setting a fish spawn amount could have an affect in our game
		
		var new_spawn = possible_fish_spawns.pick_random() #Picks random spawn point in Possible Spawn array
		fish_spawns.append(new_spawn) #Appends it to spawn array
		possible_fish_spawns.erase(new_spawn) #Remove from list, so it can't be chosen again
		## ^ might have to be tweaked so it has a chance of spawning back here
	
	## For this I had another Node (regular white one) to store the actual meat objects    
	# instantiate a meat objective object at chosen point (parent under ObjectiveGoals node)
	for n in fish_spawns: #For however many spawns points were chosen, spawn meat there
		var new_fish = fish_school.instantiate() #Instantiate the meat scene
		
		#objective_goals.add_child(new_meat) #Make it a child of the empty Node
