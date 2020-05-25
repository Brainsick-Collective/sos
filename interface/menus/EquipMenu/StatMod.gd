extends HBoxContainer


func initialize(stat_string, old, new):
    $OldAmount/Label.text = String(old)
    $NewAmount/Label.text = String(new)
    $Stat/Label.text = stat_string
    if old < new:
        $NewAmount/Label.set("custom_colors/font_color", Color.green)
    elif old > new:
        $NewAmount/Label.set("custom_colors/font_color", Color.red)

