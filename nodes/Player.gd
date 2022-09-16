extends Area2D

signal hit

export(PackedScene) var bullet
export var speed = 10 # How fast the player will move (pixels/sec).
export var bullet_speed = 1000
var screen_size # Size of the game window.

func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.set_deferred("disabled", false)

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		fire()
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
		
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _on_Player_body_entered(body: Node) -> void:
	if !("Bullet" in str(body)):
		hide()
		emit_signal("hit")
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	
func fire() -> void:
	var b = bullet.instance()
	b.position = get_global_position()
	b.rotation = get_angle_to(get_global_mouse_position())
	b.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(b.rotation))
	get_tree().get_root().call_deferred("add_child", b)
