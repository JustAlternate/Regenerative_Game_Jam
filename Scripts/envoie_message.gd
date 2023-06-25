extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_pressed():
	
	if len($LineEdit.text) > 3 and len($LineEdit2.text) > 3:
		var json = JSON.stringify({"name":$LineEdit.text,"message":$LineEdit2.text})
		var headers = ["Content-Type: application/json"]
		var error = $HTTPRequest.request("https://justalternate.fr:8081/message", headers, HTTPClient.METHOD_POST, json)
		if error == OK:
			$success.visible = true
			$fail.visible = false
			$LineEdit.text = ""
			$LineEdit2.text = ""
			await get_tree().create_timer(4).timeout
			$success.visible = false
		else:
			$success.visible = false
			$fail.visible = true
			await get_tree().create_timer(4).timeout
			$fail.visible = false
	else:
		$success.visible = false
		$fail.visible = true
		await get_tree().create_timer(4).timeout
		$fail.visible = false
