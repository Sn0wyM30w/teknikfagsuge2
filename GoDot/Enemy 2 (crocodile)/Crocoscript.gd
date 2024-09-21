extends CharacterBody2D

const speed_norm = 30
const speed_chase = 60
var direction = 1
var chase = false
var player = null

var health = 3
var player_inattack_zone = false
var enemy_attack_cooldown = true
var croc_die_zone = false

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var edge_right = $edgeRight
@onready var edge_left = $edgeLeft
@onready var animated_sprite = $AnimatedSprite2D

@onready var game_manager = %GameManager

func enemy():
	pass

func _physics_process(delta):
	deal_with_damage()
	enemy_attack()


func _process(delta):
	if ray_cast_right.is_colliding() or edge_right.is_colliding() == false:
		direction = -1
		animated_sprite.flip_h = false
	if ray_cast_left.is_colliding() or edge_left.is_colliding() == false:
		direction = 1
		animated_sprite.flip_h = true
	if chase and edge_left.is_colliding() and edge_right.is_colliding():
		position.x += ((player.position.x - position.x)/speed_chase)
		if player.position.x < position.x:
			animated_sprite.flip_h = false
		elif player.position.x > position.x:
			animated_sprite.flip_h = true
	else:
		position.x += direction * speed_norm * delta 


func _on_area_2d_body_entered(body):
	chase = true
	player = body
	print("you're being hunted")

func _on_area_2d_body_exited(body):
	chase = false
	player = null

func _on_croco_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_croco_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func _on_croc_gets_die_body_entered(body):
	if body.has_method("player"):
		croc_die_zone = true

func _on_croc_gets_die_body_exited(body):
	if body.has_method("player"):
		croc_die_zone = false

func enemy_attack():		
	if player_inattack_zone and enemy_attack_cooldown == true:
		var t = randf_range(0,1)
		if t<=0.10 : #5% change for at der angribes
			GameManager.enemy_type = "Crocodile" 
			GameManager.enemy_attack = true 
			animated_sprite.play("chomp")
			enemy_attack_cooldown = false 
			await get_tree().create_timer(0.02).timeout #til at sikre, at vi dør ikke konstant
			GameManager.enemy_attack = false
			await get_tree().create_timer(1).timeout
			enemy_attack_cooldown = true
		elif player_inattack_zone == false:
			animated_sprite.play("Walk")

func deal_with_damage():
	if croc_die_zone and GameManager.player_current_attack == true:
		health = health - 1
		await get_tree().create_timer(0.02).timeout #her dør den ikke med det samme
		print("enemy health - 1")
		if health <= 0: 
			GameManager.enemy_type = "Crocodile"
			game_manager.add_extra_point()
			self.queue_free()
