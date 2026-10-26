extends Timer

func _ready() -> void:
	timeout.connect(_al_caducar)

func _al_caducar() -> void:
	GameManager.avanzar_dia()
	GameManager.actualizar_alimentos()
