extends CharacterBody2D

#player hitbox - hvor skal den lede?

const SPEED = 150.0
const JUMP_VELOCITY = -320.0

var enemy_inattack_range = false 
var health = 6
var player_alive = true 
var attack_ip = false 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var bonk = $hit
@onready var jump = $jump



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	enemy_attack()
	attack()
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump.play()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	#flips sprite based on diretion
	if direction > 0:
			animated_sprite_2d.flip_h = false
	elif direction < 0:
			animated_sprite_2d.flip_h = true 
	
	#plays animation 
	if is_on_floor():
		if direction == 0:
			if attack_ip == false:
				animated_sprite_2d.play("idle")
		else:
			if attack_ip == false:
				animated_sprite_2d.play("run")
	else: 
		if attack_ip == false:
			animated_sprite_2d.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func player():
	pass

func _ready():
	health_bar.value = health 

#determines if enemy is within attack range
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if GameManager.enemy_attack == true:
		if GameManager.enemy_type == "Wormy":
			health = health - 1
			print("health - 1")
			health_bar.value = health
		elif GameManager.enemy_type == "Bear":
			health = health - 2
			print("health - 2")
			health_bar.value = health
		elif GameManager.enemy_type == "Crocodile":
			health = health - 3
			print("health - 3")
			health_bar.value = health
	if health <= 0:
		GameManager.enemy_attack = false
		GameManager.total_score = GameManager.total_score - GameManager.current_level_score 
		GameManager.current_level_score = 0
		get_tree().reload_current_scene()

func attack():
	if Input.is_action_just_pressed("attack"):
		GameManager.player_current_attack = true 
		attack_ip = true 
		await get_tree().create_timer(0.02).timeout
		GameManager.player_current_attack = false
		$AnimatedSprite2D.play("hit") 
		bonk.play()
		await get_tree().create_timer(1.2).timeout
		attack_ip = false 
		
		

