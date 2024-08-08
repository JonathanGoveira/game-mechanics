# StateMachine.gd
### RESUMO DO SCRIPT ###
### Maquina de estado
### Transita entre os estados

extends Node

var state_name : String
var current_state : State = null # Variável para armazenar o estado atual do estado da máquina

# Declaração da variável player que será exportada para ser configurada no editor da Godot
@export var player : CharacterBody2D = null

func _ready():
	
	set_state("IdleState")  # Define o estado inicial como IdleState ao iniciar a máquina de estados

# Função para definir o estado atual
func set_state(_state_name: String):
	if current_state:
		current_state.exit_state()  # Sai do estado atual, se houver um estado atual ativo
	#if not player:
	#	print("player nulo")  # Imprime uma mensagem se a referência do jogador não estiver configurada

	current_state = get_node(_state_name)  # Obtém o novo estado com base no nome fornecido
	current_state.player = player  # Passa a referência do jogador para o estado atual
	current_state.enter_state()  # Entra no novo estado definido
	state_name = _state_name

func get_state() -> String:
	return state_name
	
# Processa lógica de jogo no processo principal
func _process(delta):
	#print(current_state)
	if current_state:
		current_state.update_state(delta)  # Chama a função de atualização de estado no estado atual

# Processa lógica de física no processo de física
func _physics_process(delta):
	if current_state:
		current_state.physics_update_state(delta)  # Chama a função de atualização física de estado no estado atual
