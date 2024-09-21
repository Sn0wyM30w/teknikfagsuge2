extends Label

@onready var portal_label_orange = %portal_label_orange

func _ready():
	portal_label_orange.visible = false

func _process(delta):
	if GameManager.ingredient_score == 10:
		portal_label_orange.visible = true
