extends Node

export var speed: float = 100;
export var fast_speed: float = 300;

onready var camera = $Camera2D

onready var lSlider = $CanvasLayer/LSlider
onready var lValue = $CanvasLayer/LSlider/Value
onready var cSlider = $CanvasLayer/CSlider
onready var cValue = $CanvasLayer/CSlider/Value
onready var hSlider = $CanvasLayer/HSlider
onready var hValue = $CanvasLayer/HSlider/Value

onready var bubble1 = $Camera2D/ColorBubble1
onready var bubble2 = $Camera2D/ColorBubble2
onready var bubble3 = $Camera2D/ColorBubble3
onready var bubble4 = $Camera2D/ColorBubble4
onready var bubble5 = $Camera2D/ColorBubble5
onready var bubble6 = $Camera2D/ColorBubble6

var l;
var c;
var h = 0;

func _ready():
    l = bubble5.material.get_shader_param("uniform_l");
    c = bubble5.material.get_shader_param("uniform_c");

    lSlider.value = l;
    cSlider.value = c;

func _process(delta):
    h = mod(h + delta * 15, 360)

    var w = 1 if Input.is_key_pressed(KEY_W) else 0
    var a = 1 if Input.is_key_pressed(KEY_A) else 0
    var s = 1 if Input.is_key_pressed(KEY_S) else 0
    var d = 1 if Input.is_key_pressed(KEY_D) else 0

    var xy = Vector2(d - a, s - w)

    var final_speed = fast_speed if Input.is_key_pressed(KEY_SHIFT) else speed

    camera.position += xy * final_speed * delta

    l = lSlider.value;
    c = cSlider.value;

    var h1 = mod(h - 120, 360);
    var h2 = h;
    var h3 = mod(h + 120, 360);

    var h4 = mod(h1 + 30, 360);
    var h5 = mod(h2 + 30, 360);
    var h6 = mod(h3 + 30, 360);

    print('h = ', h1, ',', h2, ',', h3);

    bubble1.material.set_shader_param("uniform_h", h1);
    bubble2.material.set_shader_param("uniform_h", h2);
    bubble3.material.set_shader_param("uniform_h", h3);

    bubble4.material.set_shader_param("uniform_h", h4);
    bubble5.material.set_shader_param("uniform_h", h5);
    bubble6.material.set_shader_param("uniform_h", h6);

    bubble4.material.set_shader_param("uniform_l", l);
    bubble4.material.set_shader_param("uniform_c", c);
    bubble5.material.set_shader_param("uniform_l", l);
    bubble5.material.set_shader_param("uniform_c", c);
    bubble6.material.set_shader_param("uniform_l", l);
    bubble6.material.set_shader_param("uniform_c", c);

    lValue.text = "%.2f" % l;
    cValue.text = "%.2f" % c;

    hSlider.value = h;
    hValue.text = "%.2f" % h;


func mod(x: float, y: float) -> float:
    return x - y * floor(x / y)
