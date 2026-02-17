extends Node

@warning_ignore_start("unused_signal")
# BULLET TIME
signal bullet_time_entered
signal bullet_time_exited
# CAMERA
signal snap_camera_to(screen: Screen)
# MAP
signal map_opened
signal map_closed
# MISC.
signal screen_entered(entered_screen: Screen)
signal screen_exited(exited_screen: Screen)
