extends HBoxContainer


func initialize(stat_string, old, new):
    $OldAmount/Label.text = String(old)
    $NewAmount/Label.text = String(new)
    $Stat/Label.text = stat_string

