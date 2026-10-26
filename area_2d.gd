extends Area2D

@export var dias_para_caducar: int = 3

func esta_caducado() -> bool:
	return dias_para_caducar <= 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if esta_caducado():
			get_tree().current_scene.mostrar_mensaje("¡Este alimento está caducado!")
			return

		get_tree().current_scene.mostrar_mensaje("¡Alimento rescatado! +10 puntos")
		GameManager.sumar_puntos(10)
		GameManager.alimentos_rescatados += 1
		GameManager.comprobar_pedido()
		print("Puntos: ", GameManager.puntos)
		queue_free()

func actualizar_caducidad() -> void:
	if dias_para_caducar > 0:
		dias_para_caducar -= 1
	var etiqueta = get_node_or_null("Label")
	if etiqueta != null:
		etiqueta.text = "Días: " + str(dias_para_caducar)
	print("Días restantes: ", dias_para_caducar)
