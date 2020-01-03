extends Node2D

export (Color) var DRAW_COLOR
func _draw():
    var size = Vector2(64, 64)
    var rect = Rect2(-size / 2, size)
    draw_rect(rect, DRAW_COLOR, false)
