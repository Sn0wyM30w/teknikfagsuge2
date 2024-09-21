extends Label

@onready var portal_label_blue = %portal_label_blue

func _ready():
	portal_label_blue.visible = false

func _process(delta):
	if GameManager.ingredient_score == 10:
		portal_label_blue.visible = true
