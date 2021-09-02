extends Node

var color_bubble = preload("res://src/color-bubble-manager/color-bubble.tscn");

onready var player = $"../player";
onready var background = $background;

const BUBBLE_SCALE_CUTOFF = 2000
var bubbles: Array = []

var hue: float = 0;
func get_hue_and_shift() -> float:
    var value = hue;
    hue += 180 + 1;
    return value

func _ready():
    set_background_hue(get_hue_and_shift())

func _process(delta):
    if Input.is_action_just_pressed("jump"):
        var bubble = color_bubble.instance()
        bubble.set_hue(get_hue_and_shift())
        bubble.global_position = player.global_position

        self.add_child(bubble)
        bubbles.append(bubble)

    var test = [1, 2, 3, 4, 5, 6]
    var j = 0
    while j < len(test):
        test.remove(j)
        j += 1

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
            set_background_hue(bubble.hue)
        i += 1

    # reverse iterate and delete all bubbles that are marked for deletion
    i = len(bubbles) - 1
    while i >= 0:
        if bubbles[i] == null:
            bubbles.remove(i)
        i -= 1

func set_background_hue(hue: float):
    background.material.set_shader_param("hue", hue)
