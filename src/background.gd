extends ColorRect

onready var GameManager  =get_node('/root/GameManager')

func _ready():
    self.color = GameManager.get_current_real_color()
    GameManager.connect('color_change', self, '_on_color_change')

func _on_color_change():
    self.color = GameManager.get_current_real_color()
