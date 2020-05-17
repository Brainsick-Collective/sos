extends TextureRect

class_name Portrait

export (Vector2) var left_offset = Vector2(400, 0)
export (Vector2) var right_offset = Vector2(400, 0)


func play(play_string):
    $AnimationPlayer.play(play_string)
    
func play_tween(play_string):
    var start_pos = Vector2(0,0)
    var end_pos = start_pos
    
    match play_string:
        "fadein_left":
            start_pos -= left_offset
        "fadeout_left":
            end_pos -= left_offset
        "fadein_right":
            start_pos += right_offset
        "fadeout_right":
            end_pos += right_offset
    
    $Tween.interpolate_property(self, "rect_position", start_pos, end_pos, 10.0, Tween.TRANS_BOUNCE)
