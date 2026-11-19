extends Node2D

var nivel_terminado: bool = false

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
	mostrar_mensaje("¡Bienvenido a Conecta Alimentos!")
	$BotonNuevaPartida.pressed.connect(_on_boton_nueva_partida_pressed)
	$TemporizadorNivel.timeout.connect(_on_temporizador_nivel_timeout)
	$TemporizadorNivel.start()
	$CanvasLayer/BotonComprarVida.pressed.connect(_on_boton_comprar_vida_pressed)
	$CanvasLayer/ContenedorResultados/PanelResultados/BotonReiniciar.pressed.connect(_on_boton_reiniciar_pressed)
	$CanvasLayer/BotonPausa.pressed.connect(_on_boton_pausa_pressed)
	$CanvasLayer/PanelPausa/BotonContinuar.pressed.connect(_on_boton_continuar_pressed)
	$CanvasLayer/PanelPausa/BotonVolverMenu.pressed.connect(_on_boton_volver_menu_pressed)
	$CanvasLayer/PanelPausa/BotonInstruccionesPausa.pressed.connect(_on_boton_instrucciones_pausa_pressed)
	$CanvasLayer/PanelInstruccionesPausa/BotonVolverInstrucciones.pressed.connect(_on_boton_volver_instrucciones_pressed)

func _process(_delta: float) -> void:
	var tiempo_restante = int(ceil($TemporizadorNivel.time_left))
	var minutos = tiempo_restante / 60
	var segundos = tiempo_restante % 60
	$CanvasLayer/LabelTiempo.text = "%02d:%02d" % [minutos, segundos]

	var pedido = $LabelPedido

	$CanvasLayer/LabelVidas.text = "Vidas: " + str(GameManager.vidas)
	
	$CanvasLayer/LabelDinero.text = "Dinero: $" + str(GameManager.dinero)

	if GameManager.compras_vidas < GameManager.precios_vidas.size():
		var precio = GameManager.precios_vidas[GameManager.compras_vidas]
		$CanvasLayer/BotonComprarVida.text = "Comprar vida ($" + str(precio) + ")"
	else:
		$CanvasLayer/BotonComprarVida.text = "Sin más compras"

	if GameManager.pedido_completado() and not nivel_terminado:
		if GameManager.nivel_desbloqueado < 2:
			GameManager.nivel_desbloqueado = 2
			GameManager.guardar_progreso()

		pedido.text = "PEDIDO COMPLETADO"
		terminar_nivel("¡Felicidades! ¡Nivel completado!")

func _on_boton_nueva_partida_pressed() -> void:
	get_tree().paused = false
	GameManager.reiniciar_partida()
	get_tree().reload_current_scene()

func _on_temporizador_nivel_timeout() -> void:
	terminar_nivel("¡Se acabó el tiempo! Nivel perdido")

func terminar_nivel(mensaje: String) -> void:
	if nivel_terminado:
		return

	nivel_terminado = true
	$TemporizadorNivel.stop()
	$TemporizadorCaducidad.stop()

	$CanvasLayer/ContenedorResultados/PanelResultados/LabelTituloResultado.text = mensaje
	$CanvasLayer/ContenedorResultados/PanelResultados/LabelPuntosFinales.text = "Puntos: " + str(GameManager.puntos)
	$CanvasLayer/ContenedorResultados/PanelResultados/LabelDineroFinal.text = "Dinero: $" + str(GameManager.dinero)

	$CanvasLayer/ContenedorResultados/PanelResultados.visible = true

	get_tree().paused = true

func _on_boton_comprar_vida_pressed() -> void:
	if nivel_terminado:
		return

	var compra_exitosa = GameManager.comprar_vida()

	if compra_exitosa:
		mostrar_mensaje("¡Has comprado una vida!")
	else:
		mostrar_mensaje("No puedes comprar una vida")

func _on_boton_reiniciar_pressed() -> void:
	get_tree().paused = false
	GameManager.reiniciar_partida()
	get_tree().reload_current_scene()
func _on_boton_pausa_pressed() -> void:
	if nivel_terminado:
		return

	$CanvasLayer/PanelPausa.show()
	get_tree().paused = true


func _on_boton_continuar_pressed() -> void:
	$CanvasLayer/PanelPausa.hide()
	get_tree().paused = false


func _on_boton_volver_menu_pressed() -> void:
	get_tree().paused = false
	GameManager.reiniciar_partida()
	get_tree().change_scene_to_file("res://menu_principal.tscn")
func _on_boton_instrucciones_pausa_pressed() -> void:
	$CanvasLayer/PanelPausa.hide()
	$CanvasLayer/PanelInstruccionesPausa.show()


func _on_boton_volver_instrucciones_pressed() -> void:
	$CanvasLayer/PanelInstruccionesPausa.hide()
	$CanvasLayer/PanelPausa.show()
