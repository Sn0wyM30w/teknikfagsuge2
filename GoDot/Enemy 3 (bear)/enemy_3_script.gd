extends CharacterBody2D

@onready var bear = $AnimatedSprite2D
@onready var player = %Player
@onready var game_manager = %GameManager

@onready var edge_left = $edge_left
@onready var edge_right = $edge_right


var speed = 200
var bear_status = "sleeping"

var health = 2
var attack_cooldown = false
var player_inattack_zone = false 

func enemy():
	pass 

func _physics_process(delta):
	#collision boy yderst 
	deal_with_damage()
	
	if bear_status == "sleeping":
		bear.play("sleeping")
		
	elif bear_status == "wakeup":
		bear_status=""
		bear.play("waking_up")
		await get_tree().create_timer(1).timeout
		bear.play("idle")


	elif bear_status == "fall_asleep":
		bear_status=""
		bear.play("falling_asleep")
		await get_tree().create_timer(1).timeout
		bear.play("sleeping")
		bear_status="sleeping"
		
	#collision shape imellem 
	elif bear_status == "chase" and edge_left.is_colliding() and edge_right.is_colliding(): #and position.x <= (max x koordinat for platform) and position.x >= (min koordinat for platform)	
		#position.x += (player.position.x - position.x)/speed
		
		bear.play("walking")
		
		if player.position.x <= position.x:
			position.x-= 1
		else:
			position.x += 1
		
		var threshold = 0.5
		if abs(player.position.x - position.x) > threshold:
			if (player.position.x - position.x) > 0:
				bear.flip_h = true 
			elif (player.position.x - position.x) < 0:
				bear.flip_h = false 
		else:
			bear.play("idle")
	

	elif bear_status == "attack":
		var t = randf_range(0,1)
		if t<=0.05 : #5% change for at der angribes
			bear.play("attack")
			attack_cooldown = true
			GameManager.enemy_attack = true 
			GameManager.enemy_type = "Bear"
			await get_tree().create_timer(0.02).timeout
			GameManager.enemy_attack = false
			await get_tree().create_timer(1.2).timeout
			attack_cooldown = false

func _on_detection_area_body_entered(player):
	if bear_status=="":
		bear_status = "chase"

func _on_detection_area_body_exited(player):
		bear_status = ""
		bear.play("idle")
	
func _on_wakeup_area_body_entered(player):
	if bear_status == "sleeping":
		bear_status = "wakeup"

func _on_wakeup_area_body_exited(player):
	bear_status = "fall_asleep"

func _on_attack_area_body_entered(player):
	if attack_cooldown == false:
		bear_status = "attack"

func _on_attack_area_body_exited(player):
	bear_status = "chase"

func _on_bear_gets_die_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		print("player_inattack_zone = true")

func _on_bear_gets_die_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		print("player_inattack_zone = false")

func deal_with_damage():
	if GameManager.player_current_attack and player_inattack_zone == true:
		await get_tree().create_timer(0.2).timeout
		health = health - 1
		print("enemy health - 1")
		if health <= 0:
			GameManager.enemy_type = "Bear"
			game_manager.add_extra_point()
			self.queue_free()

