extends Label

func _process(_delta: float) -> void:
	text = "Puntos: " + str(GameManager.puntos) + " | Día: " + str(GameManager.dia_actual) + " | Dinero: $" + str(GameManager.dinero)
