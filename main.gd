extends Node

@export var mob_scene: PackedScene
@export var berry_scene: PackedScene
var score
var collected

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func _on_collected():
	score = score + 10
	collected += 1
	if(collected > 6):
		$HUD.show_message("All berries collected!")
	$HUD.update_score(score)

func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("berries", "queue_free")
	collected = 0
	score = 0
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	var location = Vector2.ZERO
	for i in range(7):
		location.x = randf_range(0.15, 0.85) *  DisplayServer.window_get_size().x
		location.y = randf_range(0.15, 0.85) *  DisplayServer.window_get_size().y
		var berry = berry_scene.instantiate()
		berry.position = location
		add_child(berry)
		berry.collected.connect(_on_collected)
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(250.0, 350.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
func _ready():
	pass
