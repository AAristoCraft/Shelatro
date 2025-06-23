extends Node2D


# Константы для масок столкновений: карты и слоты для карт
const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2


# Размер экрана, текущая перетаскиваемая карта и флаг наведения
var screen_size
var card_being_dragged
var is_hovering_on_card
var player_hand_reference


# Получаем размер экрана при старте
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_clicked", self.on_left_click_released)


# Обновляем позицию перетаскиваемой карты при движении мыши
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = mouse_pos
		# Ограничиваем движение карты рамками экрана
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
		clamp(mouse_pos.y, 0, screen_size.y))


# Обработка ввода мыши
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			# При нажатии ЛКМ проверяем, наведена ли мышь на карту
			var card = check_click_card()
			if card:
				start_drag(card)  # Начинаем перетаскивание
		else:
			if card_being_dragged:
				finish_drag()  # Завершаем перетаскивание


# Начинаем перетаскивание карты
func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)  # Сбрасываем масштаб до нормального


# Завершаем перетаскивание
func finish_drag():
	card_being_dragged.scale = Vector2(1.1, 1.1)  # Немного увеличиваем карту
	var card_slot_found = check_click_card_slot()
	# Если слот найден и в нём ещё нет карты
	if card_slot_found and not card_slot_found.card_in_slot:
		card_being_dragged.position = card_slot_found.position  # Перемещаем карту в слот
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true  # Отключаем коллизию
		card_slot_found.card_in_slot = true  # Отмечаем, что слот занят
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged)
	card_being_dragged = null  # Сбрасываем перетаскивание


# Подключаем сигналы карты (например, наведение мыши)
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_left_click_released():
	if card_being_dragged:
		finish_drag()


# Обработка наведения курсора на карту
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)

# Обработка ухода курсора с карты
func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_hovered = check_click_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false


# Визуально выделяем/снимаем выделение с карты
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.1, 1.1)  # Увеличиваем масштаб
		card.z_index = 2  # Поднимаем по Z-индексу, чтобы была "выше" других
	else:
		card.scale = Vector2(1, 1)  # Возвращаем обычный масштаб
		card.z_index = 1  # Обычный Z-индекс


# Проверка, наведена ли мышь на карту
func check_click_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		# Возвращаем карту с наибольшим z_index, если несколько под курсором
		return get_card_with_highest_z_index(result)
	else:
		return null


# Проверка, наведена ли мышь на слот для карты
func check_click_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null


# Возвращает карту с наибольшим z_index среди всех найденных
func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
