extends Button

func load_deck(filename):
	var file = File.new()
	file.open(filename, file.READ)
	var cards = "res://Cards/Scripts/S/Snapcaster_Mage.gd|res://Cards/Scripts/S/Swamp.gd" #file.get_line()
	get_tree().root.get_node("Game/Players/Player/Deck").from_string(cards)
	file.close()

func _pressed():
	load_deck("res://deck2.txt")
	get_tree().root.get_node("Game/NetworkManager").join_server()
	
	get_parent().hide()