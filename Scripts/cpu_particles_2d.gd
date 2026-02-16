extends Node2D

@onready var particles = $CPUParticles2D

func _ready():
	print("explosion")
	particles.restart()
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
