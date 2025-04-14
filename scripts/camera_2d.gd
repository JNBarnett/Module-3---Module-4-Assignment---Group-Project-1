extends Camera2D

func update_limit(level):
	if level == 1:
		limit_left =0
		limit_top =0
		limit_right =4600
		limit_bottom =3050
	elif level == 2:
		limit_left =0
		limit_top =0
		limit_right =4096
		limit_bottom =2560
	elif level == 3:
		limit_left =0
		limit_top =0
		limit_right =4096
		limit_bottom =2560
	
