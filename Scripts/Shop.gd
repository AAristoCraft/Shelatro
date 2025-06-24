extends Node2D

# Simple shop that sells one card per round for a fixed price
const CARD_PRICE := 1

var deck: Node

func _ready() -> void:
    deck = $"../Deck"

## Attempt to buy a card for the given player
## The card is drawn from the common deck
func buy_card(player):
    if player.money >= CARD_PRICE:
        player.money -= CARD_PRICE
        var card = deck.draw_card()
        if card:
            player.add_card(card)
            print("%s bought a card" % player.name)
    else:
        print("%s can't afford a card" % player.name)
