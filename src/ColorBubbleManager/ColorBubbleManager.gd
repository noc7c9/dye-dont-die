class_name ColorBubbleManager

extends Node

var color_bubble = preload("res://src/ColorBubbleManager/ColorBubble.tscn");

onready var player = GameManager.get_player()
onready var background = $Background;

const BUBBLE_SCALE_CUTOFF = 2000
var bubbles: Array = []

var hue_shift: float = 0
func get_hue_and_shift() -> float:
    var base = GameManager.current_color * (360.0 / GameManager.total_colors)
    var color = base + hue_shift
    hue_shift += 1
    return color

func _ready():
    background.material.set_shader_param("hue", get_hue_and_shift())
    assert(GameManager.connect('color_change', self, 'on_color_change') == OK)

func on_color_change():
    var new_bubble = color_bubble.instance()
    new_bubble.set_hue(get_hue_and_shift())
    new_bubble.global_position = player.global_position

    self.add_child(new_bubble)
    bubbles.append(new_bubble)

    # delete all bubbles that have scaled past the scale cutoff
    # forward iterate so that bubbles that were created later set the background
    # hue last
    # (ie. old bubble hues don't override newer hues)
    var i = 0
    while i < len(bubbles):
        var bubble = bubbles[i]
        if bubble.scale.x > BUBBLE_SCALE_CUTOFF:
            bubble.queue_free()
            bubbles[i] = null # mark for deletion
            background.material.set_shader_param("hue", bubble.hue)
        i += 1

    # reverse iterate and delete all bubbles that are marked for deletion
    i = len(bubbles) - 1
    while i >= 0:
        if bubbles[i] == null:
            bubbles.remove(i)
        i -= 1
