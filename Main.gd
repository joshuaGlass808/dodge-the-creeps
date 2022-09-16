extends Node

export(PackedScene) var mob_scene
export(PackedScene) var swim_mob_scene

var score

func _ready() -> void:
	randomize()
	
func hide_children(sname: String) -> void:
	var name
	for n in get_children():
		name = n.get_name()
		name = str(name.replace("@", "").replace(str(int(name)), ""))
		if name == sname:
			n.hide()
			
func remove_children(sname: String) -> void:
	var name
	for n in get_children():
		name = n.get_name()
		name = str(name.replace("@", "").replace(str(int(name)), ""))
		if name == sname:
			n.hide()
			n.queue_free()
			

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$SwimMobTimer.stop()
	hide_children("Mob")
	$HUD.show_game_over()
	hide_children("Mobswim")
	remove_children("Bullet")

func new_game() -> void:
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)

# Called when timer is reached.
func _on_MobTimer_timeout() -> void:
	createMob()
	
# Called when timer is reached.
func _on_SwimMobTimer_timeout() -> void:
	createSwimMob()
	
func createSwimMob() -> void:
	var mob = swim_mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(rand_range(250.0, 450.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)
	
func createMob() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(250.0, 450.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_ScoreTimer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout() -> void:
	$MobTimer.start()
	$SwimMobTimer.start()
	$ScoreTimer.start()

func _on_Mob_mob_hit() -> void:
	print("mob hit") # Replace with function body.

