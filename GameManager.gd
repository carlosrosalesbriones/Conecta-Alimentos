extends Node

var puntos: int = 0
var dia_actual: int = 1
var alimentos_rescatados: int = 0
var dinero: int = 0
var pedido_pagado: bool = false

func sumar_puntos(cantidad: int) -> void:
	puntos += cantidad
	guardar_partida()
func avanzar_dia() -> void:
	dia_actual += 1
	guardar_partida()
func actualizar_alimentos() -> void:
	for alimento in get_tree().get_nodes_in_group("alimentos"):
		alimento.actualizar_caducidad()
func pedido_completado() -> bool:
	return alimentos_rescatados >= 2

func comprobar_pedido() -> void:
	if pedido_completado() and not pedido_pagado:
		pedido_pagado = true
		dinero += 100
		guardar_partida()
		print("Dinero actual: $", dinero)
		get_tree().current_scene.mostrar_mensaje("¡Pedido completado! +$100")
		print("Alimentos rescatados: ", alimentos_rescatados)

func nuevo_pedido() -> void:
	alimentos_rescatados = 0
	pedido_pagado = false

func guardar_partida() -> void:
	var alimentos_guardados = []

	for alimento in get_tree().get_nodes_in_group("alimentos"):
		alimentos_guardados.append({
			"dias_para_caducar": alimento.dias_para_caducar
		})

	var archivo = FileAccess.open("user://partida.save", FileAccess.WRITE)
	var datos = {
		"puntos": puntos,
		"dinero": dinero,
		"dia_actual": dia_actual,
		"alimentos": alimentos_guardados
	}

	archivo.store_var(datos)


func cargar_partida() -> void:
	if not FileAccess.file_exists("user://partida.save"):
		return

	var archivo = FileAccess.open("user://partida.save", FileAccess.READ)
	if archivo == null:
		return

	var datos = archivo.get_var()
	archivo.close()

	puntos = datos.get("puntos", 0)
	dinero = datos.get("dinero", 0)
	dia_actual = datos.get("dia_actual", 1)

	var alimentos_guardados = datos.get("alimentos", [])
	var alimentos = get_tree().get_nodes_in_group("alimentos")

	for i in range(min(alimentos.size(), alimentos_guardados.size())):
		alimentos[i].dias_para_caducar = alimentos_guardados[i].get("dias_para_caducar", 3)
		alimentos[i].get_node_or_null("Label").text = "Días: " + str(alimentos[i].dias_para_caducar)

func _ready() -> void:
	cargar_partida()

func reiniciar_partida() -> void:
	puntos = 0
	dinero = 0
	dia_actual = 1
	alimentos_rescatados = 0
	pedido_pagado = false

	for alimento in get_tree().get_nodes_in_group("alimentos"):
		if alimento.name == "Fruta1":
			alimento.dias_para_caducar = 1
		else:
			alimento.dias_para_caducar = 3

		var etiqueta = alimento.get_node_or_null("Label")
		if etiqueta != null:
			etiqueta.text = "Días: " + str(alimento.dias_para_caducar)

	guardar_partida()
