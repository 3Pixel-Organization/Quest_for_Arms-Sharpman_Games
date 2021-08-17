extends CanvasLayer

var coins = 0

func _ready():
	$Coins.text = String(coins)

func _on_coin_coin_collected():
	coins = coins + 1
	_ready()

func _on_coin2_coin_collected():
	coins = coins + 1
	_ready()

func _on_coin3_coin_collected():
	coins = coins + 1
	_ready()

func _on_coin4_coin_collected():
	coins = coins + 1
	_ready()

func _on_coin5_coin_collected():
	coins = coins + 1
	_ready()
