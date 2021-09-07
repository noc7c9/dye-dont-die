class_name Goomba

extends KinematicBody2D

const GRAVITY: float = 1500.0
const SPEED: float = 5000.0
const MAX_FALL_SPEED: float = 500.0

var v_speed: float = 0
var h_dir: float = 1

var motion: Vector2 = Vector2.ZERO;

onready var ray_left: RayCast2D = $RayLeft
onready var ray_right: RayCast2D = $RayRight
onready var area_left: Area2D = $AreaLeft
onready var area_right: Area2D = $AreaRight
onready var area_top: Area2D = $AreaTop

func _ready():
    assert(area_left.connect('body_entered', self, '_on_body_side_entered') == OK)
    assert(area_right.connect('body_entered', self, '_on_body_side_entered') == OK)
    assert(area_top.connect('body_entered', self, '_on_body_top_entered') == OK)

func _physics_process(delta):
    if not ray_right.is_colliding() or not ray_left.is_colliding():
        h_dir *= -1

    v_speed += GRAVITY * delta
    v_speed = min(v_speed, MAX_FALL_SPEED)

    motion.y = v_speed
    motion.x = h_dir * SPEED * delta

    motion = move_and_slide(motion, Vector2.UP)

func _on_body_side_entered(body):
    if not body.is_in_group('player'): return
    print('body side entered')

func _on_body_top_entered(body):
    if not body.is_in_group('player'): return
    print('body top entered')
