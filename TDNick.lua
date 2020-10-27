local sampev = require 'lib.samp.events'

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	if sampGetCurrentServerAddress() ~=  "176.32.37.62" then thisScript():unload() end
    while true do
		wait(0)
	  end
end
function sampev.onShowTextDraw(id, data)
	if id == 2 then
		data.text = 'SIRIUS'
		data.letterColor = '0x792113FF'
		data.style = '1'
		return {id, data}
	end
	if id == 3 then
		data.text = 'MURPHY'
		data.letterColor = '0xFFFFFFFF'
		return {id, data}
	end
end