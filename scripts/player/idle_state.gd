# IdleState.gd
### RESUMO DO SCRIPT ###
### Estado que controla as ações de idle
### Aplica a fricção
### Muda de estado mediante as condições

extends "res://scripts/player/state.gd"

func enter_state():
	pass
	#player.animation.animate("Idle")
	
func physics_update_state(delta):
	player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)
	if abs(player.velocity.x) < 0.1:
		player.velocity.x = 0  # Para completamente o jogador quando a velocidade é muito baixa
	
		
func update_state(delta):
	player.animation.animate("idle") # chama a animação de idle
	# Transições de estado baseadas nas ações do jogador
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		player.get_node("StateMachine").set_state("RunState")#Transita para o estado de corrida se movendo para a esquerda ou direita.
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.get_node("StateMachine").set_state("JumpState")#Transita para o estado de pulo se pressionar 'jump' e estiver no chão.
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		player.get_node("StateMachine").set_state("DashState")#Transita para o estado de dash se pressionar 'dash'.
	elif Input.is_action_pressed("crouch"):
		player.get_node("StateMachine").set_state("CrouchState") #Transita para o estado de agachamento se pressionar 'crouch'.

