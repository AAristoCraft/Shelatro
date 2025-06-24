extends RefCounted
class_name Player

## Simple data holder for player state
## Stores player name, currency, card list and score
var name: String
var money: int = 0
var hand: Array = []
var score: int = 0

func _init(p_name: String, start_money: int = 0):
    name = p_name
    money = start_money

## Adds a card node to the player's hand
func add_card(card: Node) -> void:
    hand.append(card)

## Calculates score based on current hand size
## Here we simply count the cards but later this can
## incorporate card effects and multipliers
func calculate_score() -> void:
    score = hand.size()
