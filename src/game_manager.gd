extends Node

signal color_change()

var total_colors: int = 3
var current_color: int = 0

func _process(_delta:float):
    if Input.is_action_just_pressed('jump'):
        current_color = (current_color + 1) % total_colors
        emit_signal('color_change')

func get_current_real_color():
    return to_real_color(current_color)

func to_real_color(color: int):
    match color:
        0:
            return Color(0.5, 0, 0, 1)
        1:
            return Color(0, 0.5, 0, 1)
        2:
            return Color(0, 0, 0.5, 1)
        _:
            assert(false, "invalid color %d" % color)
            return Color(0, 0, 0, 1)
