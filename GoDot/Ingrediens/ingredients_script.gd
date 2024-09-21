extends Area2D

@onready var pickup_sound = %AudioStreamPlayer2D

@onready var game_manager = %GameManager

@onready var player = %Player

func _on_body_entered(player):
	game_manager.add_point()
	pickup_sound.play()
	queue_free()

#POINTS
