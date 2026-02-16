class_name Enemy_Hitbox
extends Area2D
@export  var damage := 20


func _init() ->void:
	collision_layer = 3
	collision_mask = 0
	
