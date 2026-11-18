extends Node

var puntos: int = 0
var dia_actual: int = 1
var alimentos_rescatados: int = 0
var dinero: int = 0
var pedido_pagado: bool = false
var vidas: int = 3
var compras_vidas: int = 0
var nivel_desbloqueado: int = 1
var precios_vidas: Array[int] = [100, 250, 500, 850, 1300]

func sumar_puntos(cantidad: int) -> void:
	puntos += cantidad

func avanzar_dia() -> void:
	dia_actual += 1


func perder_vida() -> void:
	if vidas <= 0:
		return

	vidas -= 1
	print("Vidas restantes: ", vidas)

	if vidas == 0:
		get_tree().current_scene.terminar_nivel("¡Te has quedado sin vidas! Nivel perdido")

func actualizar_alimentos() -> void:
	print("Alimentos encontrados: ", get_tree().get_nodes_in_group("alimentos").map(func(a): return a.name))
	for alimento in get_tree().get_nodes_in_group("alimentos"):
		alimento.actualizar_caducidad()
func pedido_completado() -> bool:
	return alimentos_rescatados >= 3

func comprobar_pedido() -> void:
	if pedido_completado() and not pedido_pagado:
		pedido_pagado = true
		dinero += 100
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
		"alimentos": alimentos_guardados,
		"nivel_desbloqueado": nivel_desbloqueado
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
	nivel_desbloqueado = datos.get("nivel_desbloqueado", 1)

	var alimentos_guardados = datos.get("alimentos", [])
	var alimentos = get_tree().get_nodes_in_group("alimentos")

	for i in range(min(alimentos.size(), alimentos_guardados.size())):
		alimentos[i].dias_para_caducar = alimentos_guardados[i].get("dias_para_caducar", 3)
		alimentos[i].get_node_or_null("Label").text = "Días: " + str(alimentos[i].dias_para_caducar)

func _ready() -> void:
	cargar_progreso()
	print("Nivel desbloqueado al iniciar: ", nivel_desbloqueado)

func reiniciar_partida() -> void:
	puntos = 0
	dinero = 0
	dia_actual = 1
	alimentos_rescatados = 0
	pedido_pagado = false
	vidas = 3
	compras_vidas = 0

	for alimento in get_tree().get_nodes_in_group("alimentos"):
		alimento.dias_para_caducar = randi_range(1, 3)

		var etiqueta = alimento.get_node_or_null("Label")
		if etiqueta != null:
			etiqueta.text = "Días: " + str(alimento.dias_para_caducar)


func comprar_vida() -> bool:
	if vidas >= 3:
		return false

	if compras_vidas >= precios_vidas.size():
		return false

	var precio = precios_vidas[compras_vidas]

	if dinero < precio:
		return false

	dinero -= precio
	vidas += 1
	compras_vidas += 1


	print("Vida comprada. Vidas: ", vidas)
	print("Dinero restante: $", dinero)

	return true
func guardar_progreso() -> void:
	var archivo = FileAccess.open("user://progreso.save", FileAccess.WRITE)

	if archivo == null:
		push_error("No se pudo guardar el progreso")
		return

	var datos = {
		"nivel_desbloqueado": nivel_desbloqueado
	}

	archivo.store_var(datos)
	archivo.close()
func cargar_progreso() -> void:
	if not FileAccess.file_exists("user://progreso.save"):
		nivel_desbloqueado = 1
		return

	var archivo = FileAccess.open("user://progreso.save", FileAccess.READ)

	if archivo == null:
		push_error("No se pudo cargar el progreso")
		return

	var datos = archivo.get_var()
	archivo.close()

	if datos is Dictionary:
		nivel_desbloqueado = max(1, int(datos.get("nivel_desbloqueado", 1)))
