extends Node

export (Dictionary) var Characters
export (String) var file_path = "res://game/Kabuki"
var char_directory : Directory

# Kabuki handles all info about the story progression and any info needed for cutscenes
# needs to be extended to handle save and load of player characters, and game state

### CONSTANTS ###
var colors = {
    "black" : "[`0]",
    "dark blue" : "[`1]", 
    "dark green" : "[`2]", 
    "dark aqua" : "[`3]",
    "dark red" : "[`4]",
    "dark purple" : "[`5]", 
    "gold" : "[`6]",
    "gray" : "[`7]",
    "dark gray" : "[`8]",
    "blue" : "[`9]",
    "green" : "[`a]",
    "aque" : "[`b]",
    "red" : "[`c]",
    "light purple" : "[`d]",
    "yellow" : "[`e]",
    "white" : "[`f]",
    "reset" : "[`r]",
    "new line" : "[`#]"
}
var speed = {
    "fastest" : "[*1]",
    "fast" : "[*2]",
    "normal" : "[*3]",
    "slow" : "[*4]",
    "slowest" : "[*5]",
    "instant" : "[*i]",
    "reset" : "[*r]",
   }
var effects = {
    "tispy" : "[^t]",
    "drunk" : "[^d]",
    "Vibrate" :"[^v]",
    "reset" : "[^r]"
}
var pause = {
    "seconds" : "[s",
    "ticks" : "[t"
}

var board

func _ready():
    var dir = Directory.new()
    var char_directory_path = file_path + "/Characters"
    dir.open(char_directory_path)
    dir.list_dir_begin()
    
    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            var character = load(char_directory_path.plus_file(file))
            assert(character is Character)
            Characters[character.actor_name] = character
        
func add_character(character_name, character):
    Characters["character_name"] = character
    
func get_color(char_name):
    return Characters[char_name].color

func has_character(char_name):
    return Characters.has(char_name)
func get_portrait(char_name, expression):
    return Characters[char_name].get(expression)
func save():
    pass
    
func load_game():
    pass

func map_move(keyword):
    board.move_camera(keyword)

### DIALOG METHODS

func add_speed(speed, string):
    return speed[speed] + string + speed["reset"]

func add_effect(effect, string):
    return effects[effect] + string + effects["reset"]
    
func add_color(color, string):
    return colors[color] + string + colors["reset"]
