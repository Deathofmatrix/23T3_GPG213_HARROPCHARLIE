extends Area2D
class_name KickHitBox

func _process(_delta):
	if monitoring == true:
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false
