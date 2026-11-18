extends Control

func _ready() -> void:
	$BotonInstrucciones.pressed.connect(_on_boton_instrucciones_pressed)
	$Fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$BotonJugar.pressed.connect(_on_boton_jugar_pressed)
	$PanelInstrucciones/BotonVolver.pressed.connect(_on_boton_volver_pressed)

func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Principal.tscn")

func _on_boton_volver_pressed() -> void:
	$PanelInstrucciones.visible = false

func _on_boton_instrucciones_pressed() -> void:
	$PanelInstrucciones.visible = true
