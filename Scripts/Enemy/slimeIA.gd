class_name Slime
extends RefCounted

func update(_self: CharacterBody2D, target: Node, delta: float) -> void:
	if not target:
		return

	var enemy_pos: Vector2 = _self.global_position
	var target_pos: Vector2 = target.global_position
	var desired_dir: Vector2 = enemy_pos.direction_to(target_pos)

	# Lança um raio direto na física para testar se há parede à frente
	var avoidance_dir: Vector2 = check_obstacles(_self)

	# Se houver parede perto, desvia. Senão, vai direto para o jogador.
	var final_dir: Vector2 = (desired_dir + avoidance_dir * 1.5).normalized()

	# Aplica o movimento diretamente na propriedade do CharacterBody2D
	_self.velocity = _self.velocity.lerp(final_dir * 120.0, 10.0 * delta)
	_self.move_and_slide()

# Função que lança o raio por código (Direct Space State)
func check_obstacles(enemy: CharacterBody2D) -> Vector2:
	var space_state = enemy.get_world_2d().direct_space_state
	var avoidance: Vector2 = Vector2.ZERO

	# Testaremos 3 direções: frente, 45° esquerda, 45° direita
	var angles: Array[float] = [0.0, -0.8, 0.8]
	var ray_length: float = 50.0

	for angle in angles:
		var dir: Vector2 = enemy.velocity.normalized().rotated(angle)
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT # Direção padrão caso o inimigo esteja parado

		# Configura a query do raio
		var query = PhysicsRayQueryParameters2D.create(
			enemy.global_position,
			enemy.global_position + dir * ray_length
		)
		
		# Evita que o raio colida com o próprio inimigo
		query.exclude = [enemy.get_rid()]

		# Executa o raycast na física
		var result: Dictionary = space_state.intersect_ray(query)

		# Se atingiu algo (uma parede)
		if result:
			var normal: Vector2 = result.normal
			avoidance += normal # Acumula o vetor de repulsão da parede

	return avoidance.normalized()
