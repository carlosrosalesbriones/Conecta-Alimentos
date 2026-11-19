extends Control

func _ready() -> void:
	$BotonInstrucciones.pressed.connect(_on_boton_instrucciones_pressed)
	$Fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$BotonJugar.pressed.connect(_on_boton_jugar_pressed)
	$PanelInstrucciones/BotonVolver.pressed.connect(_on_boton_volver_pressed)
	$BotonCreditos.pressed.connect(_on_boton_creditos_pressed)
	$PanelCreditos/BotonVolver.pressed.connect(_on_boton_volver_creditos_pressed)

func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Principal.tscn")

func _on_boton_volver_pressed() -> void:
	$PanelInstrucciones.hide()
	$BotonJugar.show()
	$BotonInstrucciones.show()
	$BotonCreditos.show()

func _on_boton_instrucciones_pressed() -> void:
	$BotonJugar.hide()
	$BotonInstrucciones.hide()
	$BotonCreditos.hide()
	$PanelInstrucciones.show()

func _on_boton_creditos_pressed() -> void:
	$BotonJugar.hide()
	$BotonInstrucciones.hide()
	$BotonCreditos.hide()
	$PanelCreditos.show()

func _on_boton_volver_creditos_pressed() -> void:
	$PanelCreditos.hide()
	$BotonJugar.show()
	$BotonInstrucciones.show()
	$BotonCreditos.show()
