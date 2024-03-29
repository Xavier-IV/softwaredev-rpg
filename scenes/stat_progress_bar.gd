extends ProgressBar

@onready var parent = get_parent().get_parent()
@onready var style = StyleBoxFlat.new()


func _ready():
	style.set_corner_radius_all(parent.progress_bar_radius)
	style.set_bg_color(parent.progress_bar_color)
	add_theme_stylebox_override("fill", style)

	# value = GlobalStat.stats[parent.progress_stat_name]
	GlobalStat.connect("sig_stats_changed", _on_stats_changed)
	_on_stats_changed(parent.progress_stat_name)


func _on_stats_changed(stat_name):
	if stat_name != parent.progress_stat_name:
		return

	value = GlobalStat.stats[stat_name]
