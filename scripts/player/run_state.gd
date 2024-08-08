# RunState.gd
### RESUMO DO SCRIPT ###
### Estado que controla a corrida do player
### Aplica a aceleração
### Verifica as condições para mudar de estado
### Muda de estado mediante as condições

extends "res://scripts/player/state.gd"

func enter_state():
	pass

func physics_update_state(delta):
	player.input_direction = Input.get_axis("move_left", "move_right")  # Obtém a direção de movimento do jogador
	player.sprite.flip(player.input_direction)  # Realiza o flip do jogador
	# Realiza o calculo de interpolação entre o max_move_speed e aceleration
	player.velocity.x = lerp (
		player.velocity.x, 
		player.input_direction * player.max_move_speed, 
		player.aceleration * delta
		)
	if abs(player.velocity.x) > player.max_move_speed:
		player.velocity.x = sign(player.velocity.x) * player.max_move_speed

func update_state(delta):
	player.animation.animate("run")
	# Verifica se as teclas de movimento não estão sendo pressionadas
	if player.input_direction == 0:
		player.get_node("StateMachine").set_state("IdleState")  # Volta para o estado de repouso se não houver movimento
	
	# Verifica se a telca de pulo foi pressionada e se o player não está no chão e está dentro dos frames do coyote time
	elif (
			Input.is_action_just_pressed("jump") 
			and (
					player.is_on_floor() 
					or player.coyote_time_counter > 0
				)
		):
		player.get_node("StateMachine").set_state("JumpState")  # Muda para o estado de salto se a ação de salto for pressionada
	
	# Verifica se a tecla de dash foi pressionada
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		player.get_node("StateMachine").set_state("DashState")  # Muda para o estado de dash se a ação de dash for pressionada
	
	# Verifica se a tecla de agachar foi pressionada
	elif Input.is_action_pressed("crouch"):
		player.get_node("StateMachine").set_state("CrouchState")  # Muda para o estado de agachamento se a ação de agachamento for pressionada
