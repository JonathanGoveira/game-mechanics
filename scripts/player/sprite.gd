extends Sprite2D

# função para realizar o flip
func flip(direction: float) -> void:
	if direction > 0:
		flip_h = false
	elif direction < 0:
		flip_h = true
