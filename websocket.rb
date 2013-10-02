require 'em-websocket'
require 'json'

def emulator_control_pannel(command)
	sdk_root="/home/fazil/adt-bundle-linux-x86-20130219/sdk/platform-tools/"
	command_JSON = JSON.parse(command)
	device = command_JSON["device"]
	puts(command_JSON['action'])
	if(command_JSON['action'] == "click")
		parameters = command_JSON['x'] +" "+command_JSON['y']
		runC  = sdk_root+"adb -s "+device+" shell input tap "+parameters
		system(runC)
	end

	if (command_JSON['action'] == 'swipe')
		parameters = command_JSON["xi"] +" "+command_JSON["yi"]
		parameters = parameters + " " + command_JSON["xf"] + " " +command_JSON["yf"]
		command  = sdk_root+"adb -s "+device+" shell input swipe "+parameters
		system(command)
	end

	if(command_JSON['action'] == 'back')
		command  = sdk_root+"adb -s "+device+" shell input keyevent 4"
      	system(command)
	end

	if(command_JSON['action'] == 'unlock')
		command = sdk_root+"adb -s "+device+" shell input keyevent 82"
		system(command)
	end

	if(command_JSON["action"] == "install")
		url = "wget '"+ command_JSON["url"] + "' -O "+  sdk_root+"temp"+device+".apk "
		system(url)
		install_apk =   "cd "+sdk_root+" && ./adb -s "+device+" install temp"+device+".apk "
		puts(install_apk)
    	system(install_apk)
	end

end

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 5900) do |ws|
  ws.onopen    { ws.send "we are connect"}
  ws.onmessage do |msg|
  	emulator_control_pannel(msg)
  	ws.send "Pong: #{msg}" 
  end
  ws.onclose   { puts "WebSocket closed" }
end