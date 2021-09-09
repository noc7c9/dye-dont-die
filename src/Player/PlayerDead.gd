class_name PlayerDead

extends RigidBody2D

const OFFSCREEN = Vector2(100000, 100000)

const ANGULAR_VELOCITY: float = 15.0
const LINEAR_VELOCITY: Vector2 = Vector2(0, -300)
const GRAVITY_SCALE: float = 6.0

var spin_dir: float = 1
var change_position = OFFSCREEN

func _ready():
    self.visible = false
    self.gravity_scale = GRAVITY_SCALE

func _process(_delta):
    if self.visible:
        self.angular_velocity = ANGULAR_VELOCITY * spin_dir

func _integrate_forces(state):
    if change_position != null:
        state.transform.origin = change_position
        change_position = null

func spawn(position: Vector2):
    change_position = position
    spin_dir = 1.0 if randf() > 0.5 else -1.0
    self.linear_velocity = LINEAR_VELOCITY
    self.rotation = 0
    self.visible = true

func despawn():
    # move out of the way so that it won't be visible when spawning
    change_position = OFFSCREEN
    self.visible = false
