extends Node

var score = 0 
var addscore = 0
@export var totalscore = 0

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var total_score_label_1 = %TotalScoreLabel1
@onready var total_score_label_2 = %TotalScoreLabel2
@onready var total_score_label_3 = %TotalScoreLabel3

func _ready():
	GameManager.ingredient_score = 0
	if GameManager.levels_completed == 1:
		total_score_label_2.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)
	if GameManager.levels_completed == 2:
		total_score_label_3.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)

func add_point():
	score += 1
	GameManager.ingredient_score += 1
	
	GameManager.current_level_score += 1
	GameManager.total_score += 1
	score_label.text = str(score).pad_zeros(2) + "/10"
	
	if GameManager.levels_completed == 0:
		total_score_label_1.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)
	if GameManager.levels_completed == 1:
		total_score_label_2.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)
	if GameManager.levels_completed == 2:
		total_score_label_3.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)

func add_extra_point():
	if GameManager.enemy_type == "Wormy":
		addscore += 6
		GameManager.current_level_score += 6
		GameManager.total_score += 6
	elif GameManager.enemy_type == "Bear":
		addscore += 11
		GameManager.current_level_score += 11
		GameManager.total_score += 11
	elif GameManager.enemy_type == "Crocodile":
		addscore += 15
		GameManager.current_level_score += 15
		GameManager.total_score += 15
		
	if GameManager.levels_completed == 0:
		total_score_label_1.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)
	if GameManager.levels_completed == 1:
		total_score_label_2.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)
	if GameManager.levels_completed == 2:
		total_score_label_3.text = "POINTS:" + str(GameManager.total_score).pad_zeros(3)
