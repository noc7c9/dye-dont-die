# class_name GameManager

extends Node

var total_colors: int = 2
var current_color: int = 0

onready var player: Player = get_node("/root/Main/Player")
onready var player_dead: PlayerDead = get_node("/root/Main/PlayerDead")
onready var spawn_point: Node2D = get_node("/root/Main/SpawnPoint")

func _ready():
    randomize()

    assert(player.connect('death', self, '_on_player_death') == OK)

    player.global_position = spawn_point.global_position

func _process(_delta:float):
    if player.is_dead:
        if Input.is_key_pressed(KEY_ENTER):
            player_dead.despawn()
            player.revive(spawn_point.global_position)
        return

    if Input.is_action_just_pressed('jump'):
        current_color = (current_color + 1) % total_colors
        emit_color_change()

func _on_player_death():
    player_dead.spawn(player.global_position)

func get_player() -> Player:
    return player

signal color_change()
func emit_color_change():
    emit_signal('color_change')
