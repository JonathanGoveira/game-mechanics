extends CharacterBody2D

const PUSH_SPEED = 300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Aplica a gravidade à caixa
	velocity.y += gravity * delta
	
	# Move a caixa com a velocidade atual
	move_and_slide()

	# Reseta a velocidade horizontal após cada movimento
	velocity.x = 0

func slide_crate(direction):
	# Aplica uma força horizontal uma única vez
	velocity.x = direction * PUSH_SPEED

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		#print(body.name)
		# Verifica se o player está empurrando a caixa (ou seja, se ele está se movendo)
		if abs(body.velocity.x) > 0:
			#print("move")
			body.max_move_speed = 100.0
			slide_crate(sign(body.velocity.x))  # Usa o sinal da velocidade do player
