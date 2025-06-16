extends Area2D
signal collected

func _ready():
	var berry_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = berry_types.pick_random()
	$AnimatedSprite2D.play()

func _on_area_entered(_body): 
	collected.emit()
	queue_free()
