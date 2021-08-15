extends KinematicBody2D

export var gravity: float = 1500
export var speed: float = 5000
export var max_fall_speed: float = 500

var v_speed: float = 0
var h_dir: float = 1

var motion: Vector2 = Vector2.ZERO;

onready var ray_left: RayCast2D = $ray_left
onready var ray_right: RayCast2D = $ray_right
onready var area_left: Area2D = $area_left
onready var area_right: Area2D = $area_right
onready var area_top: Area2D = $area_top

func _ready():
    area_left.connect('body_entered', self, '_on_body_entered')
    area_right.connect('body_entered', self, '_on_body_entered')
    area_top.connect('body_entered', self, '_on_body_entered')

func _physics_process(delta):
    if not ray_right.is_colliding() or not ray_left.is_colliding():
        h_dir *= -1

    v_speed += gravity * delta
    v_speed = min(v_speed, max_fall_speed)

    motion.y = v_speed
    motion.x = h_dir * speed * delta

    motion = move_and_slide(motion, Vector2.UP)

func _on_body_entered(body):
    print('body entered ', body.is_in_group('player'))
