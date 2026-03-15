extends Node2D

@export var next_level: PackedScene = null
@export var time: int = 30
@export var is_final_level: bool = false

@onready var start = $Start
@onready var exit = $Exit
@onready var deathzone = $Deathzone
@onready var ui = $UI
@onready var hud = $UI/HUD

var player = null
var timer_node = null
var time_left = time

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
	
	# Connect Trap signals
	for trap in get_tree().get_nodes_in_group("traps"):
		trap.touched_player.connect(_on_trap_touched_player)
	
	deathzone.body_entered.connect(_on_deathzone_body_entered)	
	exit.body_entered.connect(_on_exit_body_entered)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	hud.set_time_label(time_left)
	timer_node.start()

func _on_level_timer_timeout():
	time_left -= 1
	if time_left < 0:
		reset_player()
	hud.set_time_label(time_left)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body: Node2D) -> void:
	reset_player()

func _on_trap_touched_player() -> void:
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	time_left = time
	hud.set_time_label(time_left)
	AudioPlayer.play_sfx("hurt")

func _on_exit_body_entered(body):
	if body is Player:
		body.active = false
		exit.animate()
		timer_node.stop()
		await get_tree().create_timer(1.5).timeout
		
		if next_level != null:
			get_tree().change_scene_to_packed(next_level)
		
		if is_final_level:
			ui.show_win_screen(true)
