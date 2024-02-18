extends Node

signal sig_hour_advanced
signal sig_day_advanced
signal sig_month_advanced
signal sig_year_advanced

signal sig_salary_day

var current = {
	"year": 1,
	"month": 1,
	"day": 1,
	"dayInWeek": 1,
	"hour": 0,
}
var gameTimeCycles = {"monthMax": 12, "dayMax": 7, "hourMax": 24, "salaryDay": 5, "salaryHour": 12}


func get_day_in_week():
	match current["dayInWeek"]:
		1:
			return "Mon"
		2:
			return "Tue"
		3:
			return "Wed"
		4:
			return "Thu"
		5:
			return "Fri"
		6:
			return "Sat"
		7:
			return "Sun"


func get_day_padded():
	return str(current["day"]).pad_zeros(2)


func get_month_padded():
	return str(current["month"]).pad_zeros(2)


func get_day():
	return current["day"]


func get_hour():
	return current["hour"]


func hour_percentage():
	return float(current["hour"]) / float(gameTimeCycles["hourMax"]) * 100.0


func calendar_update():
	current["hour"] += 1
	emit_signal("sig_hour_advanced")

	if current["hour"] < gameTimeCycles["hourMax"]:
		return

	current["day"] += 1
	if current["dayInWeek"] < 7:
		current["dayInWeek"] += 1
	else:
		current["dayInWeek"] = 1

	current["hour"] = 0

	handle_salary_day()
	emit_signal("sig_hour_advanced")
	emit_signal("sig_day_advanced")

	if current["day"] <= gameTimeCycles["dayMax"]:
		return

	current["day"] = 1
	current["month"] += 1
	emit_signal("sig_hour_advanced")
	emit_signal("sig_day_advanced")
	emit_signal("sig_month_advanced")

	if current["month"] < gameTimeCycles["monthMax"]:
		return

	current["month"] = 1
	current["year"] += 1
	emit_signal("sig_hour_advanced")
	emit_signal("sig_day_advanced")
	emit_signal("sig_month_advanced")
	emit_signal("sig_year_advanced")


func handle_salary_day():
	if (
		GlobalDateTime.current["day"]
		== min(gameTimeCycles["dayMax"] - 1, GlobalDateTime.gameTimeCycles["salaryDay"])
	):
		emit_signal("sig_salary_day")
