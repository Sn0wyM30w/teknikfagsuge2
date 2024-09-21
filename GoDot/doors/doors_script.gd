extends Node

@onready var teleport_audio_main_tut = $"../../teleport_audio_main_tut"
@onready var teleport_audio_main1 = $"../teleport_audio_main"
@onready var teleport_audio_main2 = $"../teleport_audio_main"

@onready var teleport_audio_green = $"../teleport_audio_green"
@onready var teleport_audio_orange = $"../teleport_audio_orange"
@onready var teleport_audio_blue = $"../teleport_audio_blue"

@onready var total_score_end_big = $total_score_end_big
@onready var total_score_end_medium = $total_score_end_medium
@onready var total_score_end_small = $total_score_end_small

@onready var player = $"../Player"


static var levels_completed = 0

#LEVEL 1
static var entered_green_main = false
static var entered_green_level1 = false

#LEVEL 2
static var entered_orange_main = false
static var entered_orange_level2 = false

#LEVEL 3
static var entered_blue_main = false
static var entered_blue_level3 = false


func _process(delta):
	
	#### LEVEL 1 ####
	if entered_green_main == true and Input.is_action_just_pressed("enter"):
		#print(levels_completed)

		if levels_completed == 0 and not teleport_audio_main_tut.playing:
			print("entering level 1")
			teleport_audio_main_tut.play()
			await get_tree().create_timer(2.6).timeout
			
			if get_tree() == null:
				print("scene change")
			else:
				get_tree().change_scene_to_file("res://Level 1 (green)/Level 1.tscn")

	#### LEVEL 2 ####
	if entered_orange_main == true and Input.is_action_just_pressed("enter"):
		#print(levels_completed)
		
		if levels_completed == 1 and not teleport_audio_main1.playing:
			GameManager.current_level_score = 0
			print("entering level 2")
			teleport_audio_main1.play()
			await get_tree().create_timer(2.6).timeout
			
			if get_tree() == null:
				print("scene change")
			else:
				get_tree().change_scene_to_file("res://level 2 (fall)/Level 2.tscn")
	

	#### LEVEL 3 ####
	if entered_blue_main == true and Input.is_action_just_pressed("enter") and levels_completed == 2:
		#print(levels_completed)
		
		if levels_completed == 2 and not teleport_audio_main2.playing:
			GameManager.current_level_score = 0
			print("entering level 3")
			teleport_audio_main2.play()
			await get_tree().create_timer(2.6).timeout
			
			if get_tree() == null:
				print("scene change")
			else:
				get_tree().change_scene_to_file("res://Level 3 (winter)/level_3.tscn")

	#### Leaving a level ####
	if GameManager.ingredient_score == 10 and Input.is_action_just_pressed("enter"):
		#green	
		if entered_green_level1 == true and not teleport_audio_green.playing:
			print("going to main")
			teleport_audio_green.play()
			await get_tree().create_timer(2.6).timeout
		
			if get_tree() == null:
				print("get_tree() is null!")
			else:
				get_tree().change_scene_to_file("res://main_scenes/main_scene_1.tscn")

			if levels_completed == 0: #sikrer at det kun updaterer det én gang
				levels_completed = 1
				GameManager.levels_completed += 1
				print(levels_completed)

		#orange
		if entered_orange_level2 == true and not teleport_audio_orange.playing:
			print("going to main")
			teleport_audio_orange.play()
			await get_tree().create_timer(2.6).timeout
			get_tree().change_scene_to_file("res://main_scenes/main_scene_2.tscn")
			
			if levels_completed == 1: #sikrer at det kun updaterer det én gang
				levels_completed = 2
				GameManager.levels_completed += 1
				print(levels_completed)
		
		#blue
		if entered_blue_level3 == true and not teleport_audio_blue.playing:
			print("going to main end")
			teleport_audio_blue.play()
			await get_tree().create_timer(2.6).timeout
			
			if get_tree() == null:
				print("get_tree() is null!")

			elif GameManager.total_score <= 40 and GameManager.total_score >= 30:
				get_tree().change_scene_to_file("res://main_scenes/end_scene_small.tscn")

			elif GameManager.total_score <= 80  and GameManager.total_score > 40:
				get_tree().change_scene_to_file("res://main_scenes/end_scene_medium.tscn")

			elif GameManager.total_score >= 100 and GameManager.total_score > 80:
				get_tree().change_scene_to_file("res://main_scenes/end_scene_big.tscn")
			
			if levels_completed == 2: #sikrer at det kun updaterer det én gang
				levels_completed = 3
				print(levels_completed)

#### LEVEL 1 ####
#green door - main
func _on_area_2d_green_main_body_entered(body):
	if levels_completed == 0:
		entered_green_main = true

func _on_area_2d_green_main_body_exited(body):
		entered_green_main = false

#green door - level1
func _on_area_2d_green_level_1_body_entered(body):
	entered_green_level1 = true
func _on_area_2d_green_level_1_body_exited(body):
	entered_green_level1 = false


#### LEVEL 2 ####
#orange door - main
func _on_area_2d_orange_main_body_entered(body):
	if levels_completed == 1:
		entered_orange_main = true
func _on_area_2d_orange_main_body_exited(body):
	entered_orange_main = false

#orange door - level2
func _on_area_2d_orange_level_2_body_entered(body):
	entered_orange_level2 = true
func _on_area_2d_orange_level_2_body_exited(body):
	entered_orange_level2 = false


#### LEVEL 3 ####
#blue door - main
func _on_area_2d_blue_main_body_entered(body):
	if levels_completed == 2:
		entered_blue_main = true
func _on_area_2d_blue_main_body_exited(body):
	entered_blue_main = false

#blue door - level3
func _on_area_2d_blue_level_3_body_entered(body):
	entered_blue_level3 = true
func _on_area_2d_blue_level_3_body_exited(body):
	entered_blue_level3 = false
