extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.avanzar_dia()
		GameManager.actualizar_alimentos()
		print("Día actual: ", GameManager.dia_actual)

func mostrar_mensaje(texto: String) -> void:
	var etiqueta = $CanvasLayer/Label
	etiqueta.text = texto
	etiqueta.visible = true
	etiqueta.position.x = 0
	etiqueta.size.x = 1280
	etiqueta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _ready() -> void:
	GameManager.cargar_partida()
	call_deferred("_restaurar_alimentos")
	mostrar_mensaje("¡Bienvenido a Conecta Alimentos!")
	$BotonNuevaPartida.pressed.connect(_on_boton_nueva_partida_pressed)

func _restaurar_alimentos() -> void:
	GameManager.cargar_partida()

func _process(_delta: float) -> void:
	var pedido = $LabelPedido

	if GameManager.pedido_completado():
		pedido.text = "PEDIDO COMPLETADO"

		if Input.is_action_just_pressed("ui_accept"):
			GameManager.nuevo_pedido()
			get_tree().reload_current_scene()

func _on_boton_nueva_partida_pressed() -> void:
	GameManager.reiniciar_partida()
	get_tree().reload_current_scene()
