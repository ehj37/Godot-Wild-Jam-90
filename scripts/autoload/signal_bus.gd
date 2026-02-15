extends Node

@warning_ignore_start("unused_signal")
# BULLET TIME
signal bullet_time_entered
signal bullet_time_exited
# MISC.
signal screen_entered(entered_screen: Screen)
signal screen_exited(exited_screen: Screen)
signal snap_camera_to(screen: Screen)
