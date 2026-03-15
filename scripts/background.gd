extends Parallax2D

@export var bg_texture: CompressedTexture2D = preload("res://assets/textures/bg/Blue.png")

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = bg_texture
