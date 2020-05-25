extends AudioStreamPlayer

var bg1 = preload("res://assets/sounds/april_10_1_1_video_game_music.wav")
var foggy = preload("res://assets/sounds/POL-foggy-forest-short.wav")
var woodland = preload("res://assets/sounds/POL-across-woodland-short.wav")
var server = preload("res://assets/sounds/electrical_server_room.wav")

func play_on_loop(sound):
    stream = get(sound)
    
    play()
