extends GridContainer

var equipment_dict

func set_equipment(equipment_dict : Dictionary):
    $Weapon.set_item(equipment_dict["weapon"])
    $OffHand.set_item(equipment_dict["off_hand"])
    $OffensiveMagic.set_item(equipment_dict["offensive_magic"])
    $DefenseMagic.set_item(equipment_dict["defensive_magic"])
