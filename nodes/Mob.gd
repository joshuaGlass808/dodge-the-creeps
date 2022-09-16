extends RigidBody2D

signal mob_hit

func _ready() -> void:
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	
func hide_mob() -> void:
	hide()
	print("hiding mob")

func _on_Area2D_body_entered(body: Node) -> void:
	if !("Player" in str(body) || "Mob" in str(body) || "Mobswim" in str(body)):
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("mob_hit")
