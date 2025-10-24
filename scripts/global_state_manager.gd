extends Node

const MAX_NPC = 20
const MAX_NPC_PER_PLAYER = 5

var total_npcs := 0
var npcs_per_player := {}  # Dictionary: {player_id: [npc1, npc2, ...]}

signal npc_count_changed(total)
signal player_npc_count_changed(player_id, count)

# Called whesdn an NPC is spawned
func register_npc(npc: Node, player_id : Variant= null):
	total_npcs += 1
	emit_signal("npc_count_changed", total_npcs)
	
	if player_id != null:
		if not npcs_per_player.has(player_id):
			npcs_per_player[player_id] = []
		npcs_per_player[player_id].append(npc)
		emit_signal("player_npc_count_changed", player_id, npcs_per_player[player_id].size())

# Called when an NPC dies
func unregister_npc(npc: Node):
	for player_id in npcs_per_player.keys():
		npcs_per_player[player_id].erase(npc)
		emit_signal("player_npc_count_changed", player_id, npcs_per_player[player_id].size())
		
	total_npcs = max(total_npcs - 1, 0)
	emit_signal("npc_count_changed", total_npcs)

# When a player dies, free all their NPCs
func free_player_npcs(player_id: int):
	if not npcs_per_player.has(player_id):
		return
	for npc in npcs_per_player[player_id]:
		if is_instance_valid(npc):
			npc.die()
	npcs_per_player[player_id].clear()
	emit_signal("player_npc_count_changed", player_id, 0)
