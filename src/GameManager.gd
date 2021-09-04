# class_name GameManager

extends Node

var total_colors: int = 2
var current_color: int = 0

func _process(_delta:float):
    if Input.is_action_just_pressed('jump'):
        current_color = (current_color + 1) % total_colors
        emit_color_change()

signal color_change()
func emit_color_change():
    emit_signal('color_change')
