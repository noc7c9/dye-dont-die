extends Node

var color_bubble = preload("res://src/color-bubble-manager/color-bubble.tscn");

onready var player = $"../player";
onready var background = $background;

var hue: float = 0;
func get_hue_and_shift() -> float:
    var value = hue;
    hue += 180 + 3;
    return value

func _ready():
    background.material.set_shader_param("hue", get_hue_and_shift())

func _process(delta):
    if Input.is_action_just_pressed("jump"):
        var bubble = color_bubble.instance()
        bubble.material.set_shader_param("hue", get_hue_and_shift())
        bubble.global_position = player.global_position

        self.add_child(bubble)
