function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand("cmd", func) -- ����� �� �������
    while true do
		wait(0)
	 end
end

function func()
	sampAddChatMessage("���", -1)
end
