extends Node3D

var openedlink = 0

func _on_hide_controls_area_entered(area: Area3D) -> void:
	$"../HideControls/Controls".visible = !$"../HideControls/Controls".visible			#0

func _on_pig_sign_area_entered(area: Area3D) -> void:
	$"../../PigSign".position.y = 2.0
	
func _on_entrance_text_area_entered(area: Area3D) -> void:
	$"../EntranceText/HallwayText".visible = 1		#1
	$"../HallwayText/HallwayBanter".visible = 0		#2
	$"../TitleReference".visible = 0				#3

func _on_hallway_text_area_entered(area: Area3D) -> void:
	$"../EntranceText/HallwayText".visible = 0 		#1
	$"../HallwayText/HallwayBanter".visible = 1		#2
	$"../TitleReference".visible = 1				#3

func _on_hallway_confirm_area_entered(area: Area3D) -> void:
	$"../HallwayText/HallwayBanter".visible = 0			#2
	$"../TitleReference".visible = 0					#3
	$"../HallwayLeave/HallwayBanter".visible = 1		#4

func _on_hallway_link_area_entered(area: Area3D) -> void:
	$"../HallwayLeave/HallwayBanter".visible = 0		#4
	$"../HallwayLink/HallwayBanter".visible = 1			#5
	# dont spam the user tho
	if openedlink == 0:	
		await get_tree().create_timer(6).timeout
		OS.shell_open("https://itch.io/jam/finnish-college-jam-9/entries")
		openedlink = 1
		$"../HallwayLink/HallwayBanter".text = "Well you already opened the\nlink, and you're still here"

func _on_hallway_force_stop_area_entered(area: Area3D) -> void:
	$"../HallwayLink/HallwayBanter".visible = 0			#5
	$"../HallwayForceStop/HallwayBanter".visible = 1	#6

func _on_todl_you_so_area_entered(area: Area3D) -> void:
	$"../HallwayForceStop/HallwayBanter".visible = 0	#6
	$"../TodlYouSo/ToldYouSo".visible = 1				#7

func _on_trigger_void_area_entered(area: Area3D) -> void:
	$"../TodlYouSo/ToldYouSo".visible = 0				#7
	await get_tree().create_timer(3).timeout
	$"../../CanvasLayer/Label".visible = 1				#8

func _on_entrance_quit_area_entered(area: Area3D) -> void:
	await get_tree().create_timer(1).timeout
	get_tree().quit()
