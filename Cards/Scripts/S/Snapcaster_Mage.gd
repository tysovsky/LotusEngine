extends Card

func _init():
	Name = "Snapcaster Mage"
	CMC = "B1"
	ImageName = "isd-78-snapcaster-mage.jpg"
	CardText = "Flash\nWhen Snapcaster Mage enters the battlefield, target instant or sorcery card in your graveyard gains flashback until end of turn. The flashback cost is equal to its mana cost. (You may cast that card from your graveyard for its flashback cost. Then exile it.)"
	Type = [MTG.Type.Creature]
	SubType = MTG.SubType.Human
	SubType = MTG.SubType.Wizard