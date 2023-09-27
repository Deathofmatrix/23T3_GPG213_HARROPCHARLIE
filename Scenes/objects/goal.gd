extends Area2D

@export var goal_index = 0

func _on_body_entered(body):
	Events.goal_scored.emit(goal_index)
	body.queue_free()
