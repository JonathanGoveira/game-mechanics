# Player.gd
### RESUMO DO SCRIPT ###
### Script que contém as variáveis do player
### Aplica a gravidade
### Aplica o coyote time

extends CharacterBody2D

@export var min_jump_height: float = 20 # altura do pulo em pixels
@export var max_move_speed: float = 200 # velocidade de movimento
@export var coyote_time_frames: int = 4  # Duração do coyote time
@export var max_jump_time: float = 0.2  # Tempo máximo que o pulo pode durar
@export var jump_force: float   # Força inicial do pulo
@export var sustained_jump_force: float  # Força adicional aplicada enquanto o botão é mantido pressionado
@export var aceleration: float = 50.0
@export var friction: float = 25.0
@onready var sprite: Sprite2D = get_node("Texture") # carrega a referência do nó de sprite
@onready var state_machine: Node = get_node("StateMachine")
@onready var animation = $Animation


#var jump_timer: float = 0 # contador do tempo do pulo
var jump_gravity: float # gravidade quando está pulando
var fall_gravity: float # gravidade quando está caindo
var input_direction = 0
var coyote_time_counter: int = 0 # contador do coyote time
var jump_held: bool = false # guarda o estado pulo realizado

var can_dash : bool = true

func _ready():
	jump_force -= (min_jump_height * 2) / max_jump_time # realiza o calculo da parabola do pulo (v = 2h/th) 
	sustained_jump_force -= (min_jump_height * 3) / (max_jump_time / 3) # acrescenta uma força ao pulo e diminui o tempo para chegar no ápice do pulo
	jump_gravity = (min_jump_height * 2) / pow(max_jump_time, 2) # realiza o calculo da gravidade em velocidade constante no ato do pulo (g = -2h/th^2)
	fall_gravity = jump_gravity * 2 # aumenta a velocidade de queda

func _physics_process(delta):
	move_and_slide() # move o player
	if not is_on_floor(): # verifica se o player não está no chão e não está no dash
		apply_gravity(delta) # aplica a fisica caso o player não esteja no chão e não está no dash (aéreo)
	coyote_time()
	
	
func apply_gravity(delta): # função para aplicar a gravidade
	if velocity.y > 0 and state_machine.get_state() != "DashState": # verifica se player está caindo
		velocity.y += fall_gravity * delta # aplica a velocidade de queda
	elif velocity.y <= 0 and state_machine.get_state() != "DashState": # Caso contrário o player está pulando
		velocity.y += jump_gravity * delta # aplica a gravidade do pulo

func coyote_time():
	if is_on_floor(): # verifica se o personagem está no chão
		coyote_time_counter = coyote_time_frames # o contador recebe o max de frames do coyote time
	else:
		coyote_time_counter -= 1 # diminui 1 frame do contador do coyote time
