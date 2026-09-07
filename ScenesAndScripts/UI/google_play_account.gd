extends TextureRect

@onready var play_games_players_client: PlayGamesPlayersClient = $PlayGamesPlayersClient

var play_games_player: PlayGamesPlayer


func _ready() -> void:
	play_games_players_client.current_player_loaded.connect(_on_current_player_loaded)
	play_games_players_client.load_current_player(true)

func _on_current_player_loaded(current_player : PlayGamesPlayer) -> void:
	SaveLoad.data.player_id = current_player.player_id
	if current_player:
		play_games_player = current_player
		_set_up_display()
	else:
		hide()

func _set_up_display() -> void:
	GodotPlayGameServices.image_stored.connect(func(file_path: String) -> void:
		if file_path == play_games_player.hi_res_image_uri and not texture:
			_display_avatar()
	)
	_display_avatar()

func _display_avatar() -> void:
	GodotPlayGameServices.display_image_in_texture_rect(
		self,
		play_games_player.hi_res_image_uri
	)
