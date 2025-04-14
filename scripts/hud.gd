extends CanvasLayer

var hlife 

func update_life(life):
	hlife = life
	
func update_hud():
	if hlife == 3:
		$GameplayHUD/Life1.visible = true
		$GameplayHUD/Life2.visible = true
		$GameplayHUD/Life3.visible = true
	elif hlife == 2:
		$GameplayHUD/Life1.visible = true
		$GameplayHUD/Life2.visible = true
		$GameplayHUD/Life3.visible = false
	elif hlife == 1:
		$GameplayHUD/Life1.visible = true
		$GameplayHUD/Life2.visible = false
		$GameplayHUD/Life3.visible = false
	else:
		$GameplayHUD/Life1.visible = false
		$GameplayHUD/Life2.visible = false
		$GameplayHUD/Life3.visible = false
		
func _on_button_pressed() -> void:
	await get_tree().process_frame
	call_deferred("call_load")
	$StartMenu.visible = false
	$GameplayHUD.visible = true
	$Fail.visible = false
	$Success.visible = false
	await get_tree().process_frame

func win() -> void:
	$Success.visible = true
	
func _on_player_life_changed(life: int) -> void:
	update_life(life)	
	update_hud()

func call_load():
	$"..".load_level(1)


func _on_player_game_over() -> void:
	$Fail.visible = true
