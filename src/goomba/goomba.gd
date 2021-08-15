extends KinematicBody2D

export var gravity: float = 1500
export var speed: float = 5000
export var max_fall_speed: float = 500

var v_speed: float = 0
var h_dir: float = 1

var motion: Vector2 = Vector2.ZERO;

onready var ray_left: RayCast2D = $ray_left
onready var ray_right: RayCast2D = $ray_right

func _physics_process(delta):
    if not ray_right.is_colliding() or not ray_left.is_colliding():
        h_dir *= -1


    v_speed += gravity * delta
    v_speed = min(v_speed, max_fall_speed)

    motion.y = v_speed
    motion.x = h_dir * speed * delta

    motion = move_and_slide(motion, Vector2.UP)
