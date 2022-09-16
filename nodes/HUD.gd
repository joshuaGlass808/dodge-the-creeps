extends CanvasLayer

signal start_game

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over() -> void:
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
func show_start_game_message() -> void:
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	$StartButton.show()
	
func update_score(score: int):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed() -> void:
	$StartButton.hide()
	emit_signal("start_game")
	show_message("Get Ready!")
	yield($MessageTimer, "timeout")

func _on_MessageTimer_timeout() -> void:
	$Message.hide()
