extends MarginContainer


@onready var version: Label = $Version
@onready var google_play_account: TextureRect = $MarginContainer/GooglePlayAccount

@onready var play_games_players_client: PlayGamesPlayersClient = $MarginContainer/GooglePlayAccount/PlayGamesPlayersClient

var play_games_player: PlayGamesPlayer


func _ready() -> void:
	version.text = "Version " + ProjectSettings.get("application/config/version") + " <3"
	
	play_games_players_client.current_player_loaded.connect(_on_current_player_loaded)
	play_games_players_client.load_current_player(true)

func _on_current_player_loaded(current_player : PlayGamesPlayer) -> void:
	if current_player:
		print("giocatore caricato")
		play_games_player = current_player
		_set_up_display()
	else:
		print("caricamento fallito")

func _set_up_display() -> void:
	GodotPlayGameServices.image_stored.connect(func(file_path: String) -> void:
		if file_path == play_games_player.hi_res_image_uri and not google_play_account.texture:
			_display_avatar()
	)
	_display_avatar()

func _display_avatar() -> void:
	GodotPlayGameServices.display_image_in_texture_rect(
		google_play_account,
		play_games_player.hi_res_image_uri
	)
	print("image applied")
