# JumpState.gd
### RESUMO DO SCRIPT ###
### Estado que controla as ações de pulo
### Pulo com altura variável conforme o tempo em que a tecla de pulo é pressionada
### Movimento horizontal durante o estado de pulo
### Muda de estado mediante as condições

extends "res://scripts/player/state.gd"
var jump_timer : float

func enter_state():
	#print("Entering Jump State")
	jump_timer = 0.0
	start_jump() # chama a função para adicionar força ao pulo ao entrar no estado jump
	
func physics_update_state(delta):
	animate()
	#coyote_time() # chama o coyote time
		
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		move_player_horizontally(delta)  # Aplica movimento horizontal no ar
	
	if Input.is_action_pressed("jump"): # verifica se a tecla jump está pressionada
		continue_jump(delta) # aplica uma força maior ao pulo
	
	elif player.is_on_floor(): # verifica se o player está no chão
		player.get_node("StateMachine").set_state("IdleState") # Retorna ao estado de repouso ao tocar o chão

func exit_state():
	player.jump_held = false
	#print("exit jump")
	
func move_player_horizontally(delta):
	player.input_direction = Input.get_axis("move_left", "move_right") # le o input de movimento horizontal
	player.velocity.x = player.input_direction * player.max_move_speed # Calcula movimento horizontal
	
		
func coyote_time():
	# a lógica do coyote time dentro da função do player seria verificar se o player
	# não está no chão e a tecla de pulo foi pressionada a x frames atrás
	# aí ele aplica a força de pulo.
	# essa verificação deve ser acionada na entrada do estado
	pass

func start_jump():
	player.velocity.y = player.jump_force # adiciona força ao pulo
	player.jump_held = true # está pulando
	
func continue_jump(delta):
	if player.jump_held and jump_timer < player.max_jump_time: # se está pulando e o tempo do pulo não chegou ao fim
		player.velocity.y += player.sustained_jump_force * delta # acrecenta uma força maior ao pulo
		#player.jump_timer += delta # acrescenta o tempo de pulo para chegar ao fim
		jump_timer += delta
		#print(player.jump_timer, " ", jump_timer)
	
func animate():
	if player.velocity.y < 0:
		player.animation.animate("jump")
	elif player.velocity.y < 0:
		player.animation.animate("fall")
