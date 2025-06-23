extends Node2D

var currency : int = 10

const CardScene = preload("res://Scenes/Card.tscn")
const CardsDataBase = preload("res://Scripts/CardsDataBase.gd")

var buy_slot
var sell_slot
var buy_button
var sell_button
var currency_label
var player_hand

const RARITY_PRICES = {
    "Обычная": 1,
    "Редкая": 3,
    "Эпическая": 5,
    "Легендарная": 8,
    "Реликтовая": 13
}

func _ready() -> void:
    buy_slot = $BuySlot
    sell_slot = $SellSlot
    buy_button = $BuyButton
    sell_button = $SellButton
    currency_label = $CurrencyLabel
    player_hand = get_parent().get_node("PlayerHand")

    buy_button.pressed.connect(_on_buy_button_pressed)
    sell_button.pressed.connect(_on_sell_button_pressed)
    update_currency_label()
    _spawn_shop_card()

func _spawn_shop_card():
    if buy_slot.get_child_count() > 0:
        return
    var card_id = CardsDataBase.CARDS.keys()[randi() % CardsDataBase.CARDS.size()]
    var card = CardScene.instantiate()
    card.card_id = card_id
    buy_slot.add_child(card)
    card.position = Vector2.ZERO
    buy_slot.card_in_slot = true

func _on_buy_button_pressed() -> void:
    if buy_slot.get_child_count() == 0:
        return
    var card = buy_slot.get_child(0)
    var price = _get_card_price(card.card_id)
    if currency >= price:
        currency -= price
        buy_slot.card_in_slot = false
        buy_slot.remove_child(card)
        player_hand.add_card_to_hand(card)
        update_currency_label()
        _spawn_shop_card()

func _on_sell_button_pressed() -> void:
    if sell_slot.get_child_count() == 0:
        return
    var card = sell_slot.get_child(0)
    var price = _get_card_price(card.card_id)
    currency += price
    sell_slot.card_in_slot = false
    sell_slot.remove_child(card)
    player_hand.remove_card_from_hand(card)
    card.queue_free()
    update_currency_label()

func _get_card_price(card_id: String) -> int:
    if CardsDataBase.CARDS.has(card_id):
        var rarity = CardsDataBase.CARDS[card_id][4]
        if RARITY_PRICES.has(rarity):
            return RARITY_PRICES[rarity]
    return 1

func update_currency_label():
    if currency_label:
        currency_label.text = "Currency: %d" % currency
