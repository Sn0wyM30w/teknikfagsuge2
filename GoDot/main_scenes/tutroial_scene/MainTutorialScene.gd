extends Node2D

@onready var label_door = $txt/Label_door
@onready var label_jump = $txt/Label_jump
@onready var label_mission = $txt/Label_mission
@onready var label_mission_2 = $txt/Label_mission2
@onready var timer = $Timer
@onready var block = $Doors/Block
@onready var arrow_1 = $arrow1
@onready var arrow_2 = $arrow2

var BlockDoor = true
# Called when the node enters the scene tree for the first time.
func _ready():
	label_door.visible = false
	label_jump.visible = false
	label_mission.visible = false
	label_mission_2.visible = false
	arrow_1.visible = false
	arrow_2.visible = false

#E to door
func _on_area_2d_body_entered(body):
	label_door.visible = true
func _on_area_2d_body_exited(body):
	label_door.visible = false
#space to jump
func _on_jump_body_entered(body):
	label_jump.visible = true
	await get_tree().create_timer(0.7).timeout
	arrow_1.visible = true
func _on_jump_body_exited(body):
	arrow_1.visible = false
#mission
func _on_mission_body_entered(body):
	label_mission.visible = true
	timer.start(0.4)
	if BlockDoor == true:
		block.queue_free()
		BlockDoor = false
	await timer.timeout
	label_mission_2.visible = true
	arrow_2.visible = true
	#lav noget med pile
func _on_mission_body_exited(body):
		label_mission.visible = false
		label_mission_2.visible = false
		arrow_2.visible = false
