extends ColorRect

signal goal_anim_over

@onready var animation_player = $AnimationPlayer

func _ready():
	Events.goal_scored.connect(start_goal_anim)
	visible = false

func start_goal_anim(_goal_index):
	print("anim")
	visible = true
	animation_player.play("goal_anim")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "goal_anim":
		goal_anim_over.emit()
		visible = false
