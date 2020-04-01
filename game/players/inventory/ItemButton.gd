extends Button

var description = ""

func initialize(item, store = false):
    $Row/Name.text = item.display_name
    $Row/Amount.text = str(item.amount)
    $Row/Icon.texture = item.icon
    $Row/Cost.text = String(item.price) + " G"
    description = item.description
    if store:
        $Row/Amount.text = ""
    
    disabled = not item.usable
    
    item.connect("amount_changed", self, "_on_Item_amount_changed")
    item.connect("depleted", self, "queue_free")

func _on_Item_amount_changed(amount):
    $Row/Amount.text = str(amount)
