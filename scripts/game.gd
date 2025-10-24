extends Node2D

@onready var tilemap: TileMapLayer = $TileMapLayer
const npc_scene = preload("uid://bxne8pbflgujx")

func _ready():
	spawn_initial_npcs()

func spawn_initial_npcs():
	while GlobalStateManager.total_npcs < GlobalStateManager.MAX_NPC:
		spawn_npc()

func spawn_npc(player_id: Variant = null):
	if GlobalStateManager.total_npcs >= GlobalStateManager.MAX_NPC:
		return
	
	var npc = npc_scene.instantiate()

	var used_rect = tilemap.get_used_rect()
	var world_min = tilemap.map_to_local(used_rect.position)
	var world_max = tilemap.map_to_local(used_rect.position + used_rect.size)
	
	var random_pos = Vector2(
		randf_range(world_min.x, world_max.x),
		randf_range(world_min.y, world_max.y)
	)
	
	npc.position = random_pos
	add_child(npc)

	GlobalStateManager.register_npc(npc, player_id)
	npc.connect("died", Callable(self, "_on_npc_died"))

func _on_npc_died():
	GlobalStateManager.unregister_npc(null)
	
	if GlobalStateManager.total_npcs < GlobalStateManager.MAX_NPC:
		spawn_npc()
