extends Sprite

export var start_velocity: float = 1500
export var end_velocity: float = 500
export var deceleration: float = 250

var velocity: float = start_velocity
var hue: float = 0;

func _ready():
    scale.x = 0
    scale.y = 0

func _process(delta):
    scale.x += velocity * delta
    scale.y = scale.x

    velocity = clamp(velocity - deceleration * delta, end_velocity,
            start_velocity)

func set_hue(hue: float):
    self.hue = hue;
    self.material.set_shader_param("hue", hue)
