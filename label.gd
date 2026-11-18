extends Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
func _process(_delta: float) -> void:
	text = "Puntos: " + str(GameManager.puntos) + " | Día: " + str(GameManager.dia_actual)
