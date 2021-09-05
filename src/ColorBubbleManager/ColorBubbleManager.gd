class_name ColorBubbleManager

extends Node

var color_bubble = preload("res://src/ColorBubbleManager/ColorBubble.tscn");

onready var player = GameManager.get_player()
onready var background = $Background;

const BUBBLE_SCALE_CUTOFF = 3000
const BUBBLE_PLAYER_EDGE_MIN_DIST = 1200

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

func _process(_delta: float):
    if len(bubbles) == 0: return

    # delete the oldest bubble if it has scaled past the scale cutoff
    var bubble = bubbles[0]
    var dist_from_edge = bubble.get_player_dist_from_edge()
    if (bubble.scale.x > BUBBLE_SCALE_CUTOFF
            && dist_from_edge > BUBBLE_PLAYER_EDGE_MIN_DIST):
        bubble.queue_free()
        bubbles.remove(0)
        background.material.set_shader_param("hue", bubble.hue)

func on_color_change():
    var new_bubble = color_bubble.instance()
    new_bubble.set_hue(get_hue_and_shift())
    new_bubble.global_position = player.global_position

    self.add_child(new_bubble)
    bubbles.append(new_bubble)
