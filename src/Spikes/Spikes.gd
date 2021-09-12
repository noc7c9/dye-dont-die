class_name Spikes

extends Area2D

const SPRITE_WIDTH: int = 64
const RECT_WIDTH: int = 10

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D

func init(width: int):
    collision_shape.shape.extents.x = width * RECT_WIDTH
    sprite.region_rect.end.x = width * SPRITE_WIDTH

func _ready():
    init(3)
    assert(connect('body_entered', self, '_on_body_entered') == OK)

func _on_body_entered(body):
    if not body.is_in_group('player'): return
    body.die()
