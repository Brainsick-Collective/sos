extends Node2D

class_name Spawner

export (PackedScene) var scene

func _build_scene(player):
    print("build scene method not overridden")

func _on_area_entered(body):
    print("spawner collided")


