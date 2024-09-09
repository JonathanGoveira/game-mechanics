extends RigidBody2D



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		pass
		body.max_move_speed = 25.0
