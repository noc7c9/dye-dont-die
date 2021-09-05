class_name ColorBubble

extends Sprite

const VELOCITY = 1250.0
const SCALE_PLAYER_BUFFER = 50.0

var hue: float = 0;

onready var player = GameManager.get_player()

func _ready():
    scale.x = 0
    scale.y = 0

func _process(delta):
    scale.x += VELOCITY * delta

    # keep the player inside the bubble
    var dist = get_player_dist_from_center()
    if dist > scale.x:
        scale.x = dist

    scale.y = scale.x

func get_player_dist_from_center() -> float:
    var dist = self.global_position.distance_to(player.global_position)
    return dist * 2.0 + SCALE_PLAYER_BUFFER

func get_player_dist_from_edge() -> float:
    var dist = get_player_dist_from_center()
    return scale.x - dist

func set_hue(new_hue: float):
    self.hue = new_hue;
    self.material.set_shader_param("hue", hue)
