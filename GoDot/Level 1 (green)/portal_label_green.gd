extends Label

@onready var portal_label_green = %portal_label_green

func _ready():
	portal_label_green.visible = false

func _process(delta):
	if GameManager.ingredient_score == 10:
		portal_label_green.visible = true
