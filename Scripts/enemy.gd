extends CharacterBody2D
@export var target: CharacterBody2D
@export var speed = 50
var gravity = 900
@export var health = 50
@export var damage = 20
var DeathExplosionScene = preload("res://Scenes/death_explosion.tscn")
@onready var player = get_parent().get_node("CharacterBody2D")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed
	
	move_and_slide()


func take_damage(amount:int) -> void:
	print("Damage:",amount)
	health = health - amount
	if health <= 0:
		var explosion = DeathExplosionScene.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		queue_free()

func _on_hit_area_area_entered(area: Area2D) -> void:
	print("player damaged")
	player.take_damage(damage)
