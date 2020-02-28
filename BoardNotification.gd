extends Notification

class_name BoardNotification

var board_character

func initialize(target, newEffect, desc):
    _init()
    set_exclusive(true)
    effect = newEffect
    text = desc
    if target is Player:
        board_character = target.board_character
    elif target is BoardCharacter:
        target = board_character
# warning-ignore:return_value_discarded
    connect("about_to_show", self, "_screen_entered")
    
