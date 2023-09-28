extends ColorRect

signal goal_anim_over

@onready var animation_player = $AnimationPlayer
@onready var goal_label = %GoalLabel

func _ready():
	Events.goal_scored.connect(start_goal_anim)
	visible = false

func start_goal_anim(_goal_index):
	if _goal_index == 1:
		goal_label.modulate = Color.SEA_GREEN
	else:
		goal_label.modulate = Color.PURPLE
	visible = true
	animation_player.play("goal_anim")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "goal_anim":
		goal_anim_over.emit()
		visible = false
