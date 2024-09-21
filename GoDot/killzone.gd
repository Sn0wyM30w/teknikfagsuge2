extends Area2D

@onready var timer = $Timer


func _on_body_entered(body):
	print ("You died!")
	timer.start()

func _on_timer_timeout():
	get_tree().reload_current_scene()
	GameManager.total_score = GameManager.total_score - GameManager.current_level_score 
	GameManager.current_level_score = 0
