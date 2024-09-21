extends Node2D

#til hitbox - skal den ligge på et tag-skade-layer?

const SPEED = 30

var direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var edge_right = $edgeRight
@onready var edge_left = $edgeLeft

@onready var game_manager = %GameManager


var health = 1
var player_inattack_zone = false
var enemy_attack_cooldown = true
var wormy_die_zone = false

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

	position.x += direction * SPEED * delta 
	
func enemy():
	pass 

func _on_worm_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_worm_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func _on_wormy_gets_die_body_entered(body):
	if body.has_method("player"):
		wormy_die_zone = true

func _on_wormy_gets_die_body_exited(body):
	if body.has_method("player"):
		wormy_die_zone = false

func enemy_attack():
	if player_inattack_zone and enemy_attack_cooldown == true:
		GameManager.enemy_type = "Wormy" 
		GameManager.enemy_attack = true 
		enemy_attack_cooldown = false 
		await get_tree().create_timer(0.02).timeout #til at sikre, at vi dør ikke konstant
		GameManager.enemy_attack = false
		await get_tree().create_timer(1).timeout
		enemy_attack_cooldown = true

func deal_with_damage():
	if wormy_die_zone and GameManager.player_current_attack == true:
		health = health - 1
		await get_tree().create_timer(0.5).timeout #her dør den ikke med det samme
		print("enemy health - 1")
		if health <= 0: 
			GameManager.enemy_type = "Wormy"
			game_manager.add_extra_point()
			self.queue_free()

