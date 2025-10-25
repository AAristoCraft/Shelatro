extends Node

class_name ScoreManager

const CardsDataBase = preload("res://Scripts/CardsDataBase.gd")

static func get_card_points(card_id: String) -> int:
    if CardsDataBase.CARDS.has(card_id):
        var card_data = CardsDataBase.CARDS[card_id]
        if card_data.size() > 8:
            return int(card_data[8])
    return 0

static func calculate_score(card_ids: Array) -> int:
    var total := 0
    for id in card_ids:
        total += get_card_points(id)
    return total
