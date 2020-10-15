script_name("NSB Helper | Engine")
script_authors("Sirius | Ruben")
script_version("0.1 [B]")

require 'lib.moonloader'
local sampev = require 'samp.events'
local vkeys = require 'vkeys'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
local memory = require 'memory'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local as_action = require('moonloader').audiostream_state
local imgui = require 'imgui'
imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey
imgui.Spinner = require('imgui_addons').Spinner
imgui.BufferingBar = require('imgui_addons').BufferingBar
local dlstatus = require('moonloader').download_status
local fontsize = nil
local fa = require 'fAwesome5'
local fa_font = nil
local LogoFont = nil
local SloganFont = nil
local versFont = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
local console = import ("console")

local w, h = getScreenResolution()
local null = 0.0
local one = 0.0
local two = 0.0
local three = 0.0
local four = 0.0
local five = 0
local six = 0.0

local updateversion = "2.1" 
local allowupdate = false

local moveInfo = false
local moveCH = false

local ShowListId = 0

local logoimg = imgui.CreateTextureFromFile(getGameDirectory() .. '\\moonloader\\NSBHelp\\logotype.png')

local Config = inicfg.load({
    MAIN = {
        InfoBar = false,
        HP100 = true,
        HP160 = false,
        ArmourHUD = true,
        chHelper = true,
        dmgKololol = 50,
        LightEnabled = false,
    },
	OPTIONS = {
        InfoBarX = 19,
		InfoBarY = 458
    },

}, '..\\NSBHelp\\Settings.ini')

local desktop = true
local ooc = false
local features = false
local commands = false
local settings = false


local Notebook_state = imgui.ImBool(false)

------------- [ MAIN ] -------------
local InfoBar_state = imgui.ImBool(Config.MAIN.InfoBar)
local hphud_bttn = imgui.ImBool(Config.MAIN.HP100)
local hp2hud_bttn = imgui.ImBool(Config.MAIN.HP160)
local armhud_btnn = imgui.ImBool(Config.MAIN.ArmourHUD)
local chhelp_bttn = imgui.ImBool(Config.MAIN.chHelper)
local dmg_volume = imgui.ImFloat(Config.MAIN.dmgKololol)
--local isLight = imgui.ImBool(Config.MAIN.LightEnabled)

------------- [ OPTIONS ] -------------
local InfoBarX = Config.OPTIONS.InfoBarX
local InfoBarY = Config.OPTIONS.InfoBarY
local chHelpX = Config.OPTIONS.chHelpPosX
local chHelpY = Config.OPTIONS.chHelpPosY

--local notebook = loadAudioStream("moonloader/NSBHelp/note.mp3")
local notebook = loadAudioStream("https://raw.githubusercontent.com/Gayranyan/NSBHelp/main/note.mp3")
local notf = import 'NSBHelp/imgui_notf'

targetid = -1

local ffi = require("ffi")
ffi.cdef[[
	short GetKeyState(int nVirtKey);
	bool GetKeyboardLayoutNameA(char* pwszKLID);
	int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
	
	typedef void *PVOID;
	typedef uint8_t BYTE;
	typedef uint16_t WORD;
	typedef uint32_t DWORD;
	typedef char CHAR;
	typedef CHAR *PCHAR;

	typedef void(__thiscall *HOOK_DIALOG)(PVOID this, WORD wID, BYTE iStyle, PCHAR szCaption, PCHAR szText, PCHAR szButton1, PCHAR szButton2, bool bSend);
	int GetLocaleInfoA(int Locale, int LCType, PCHAR lpLCData, int cchData);
]]
local BuffSize = 32
local KeyboardLayoutName = ffi.new("char[?]", BuffSize)
local LocalInfo = ffi.new("char[?]", BuffSize)
FontName = "Segoe UI"
FontRazmer = 10
FontFlag = 5

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/NSBHelp/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
    if LogoFont == nil then
        LogoFont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/NSBHelp/fonts/BebasNeueBold.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
    end
    if SloganFont == nil then
        SloganFont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/NSBHelp/fonts/BebasNeueBold.ttf', 13.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
    end
    if versFont == nil then
        versFont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/NSBHelp/fonts/BebasNeueBold.ttf', 18.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
    end
end
function imgui.TextQuestion(text)
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        local p = imgui.GetCursorScreenPos()
        imgui.SetCursorScreenPos(imgui.ImVec2(p.x + 14,p.y + 14))
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        local p = imgui.GetCursorScreenPos()
        local obrez = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize,450,450,text).x
        imgui.SetCursorScreenPos(imgui.ImVec2(p.x + obrez + 28,p.y + 14))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end
function imgui.Hint(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        local p = imgui.GetCursorScreenPos()
        imgui.SetCursorScreenPos(imgui.ImVec2(p.x + 14,p.y + 14))
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        local p = imgui.GetCursorScreenPos()
        local obrez = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize,450,450,text).x
        imgui.SetCursorScreenPos(imgui.ImVec2(p.x + obrez + 28,p.y + 14))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end
function imgui.CenterText(text) 
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextColoredRGB(text)
end
function imgui.RenderMenuItems()
    imgui.BeginGroup()
            imgui.PushFont(LogoFont)
                imgui.SetCursorPos(imgui.ImVec2(20,20))
                imgui.TextColoredRGB("{6666FF}NATIONAL SECURITY BRANCH")
            imgui.PopFont()
            imgui.SameLine(nil, 510)
            imgui.PushFont(versFont)
                getvers = string.format("{ffffff}Текущая версия ПО:  {4bd600}%s", thisScript().version)
                imgui.TextColoredRGB(getvers)
            imgui.PopFont()
			if oldVersion then
				imgui.SetCursorPos(imgui.ImVec2(770,50))
				imgui.PushFont(versFont)
					getNewVers = string.format("{cc0000}Обнаружена версия:  {850000}%s", updateversion)
					imgui.TextColoredRGB(getNewVers)
				imgui.PopFont()
				imgui.SameLine(nil, 5)
                imgui.TextColored(imgui.ImColor(204, 0, 0):GetVec4(), fa.ICON_SYNC_ALT)
                if imgui.IsItemClicked() then
                    Notebook_state.v = not Notebook_state.v
                    --setAudioStreamState(notebook, as_action.PLAY)
                    setAudioStreamVolume(notebook, 50)
                    sampSetChatDisplayMode(2)
                    lua_thread.create(autoupdate)
                end
				imgui.SameLine(nil, 10)
				imgui.TextQuestion(u8"Чтобы обновится нажмите на иконку.")
			else
				imgui.SetCursorPos(imgui.ImVec2(820,50))
				imgui.PushFont(versFont)
					imgui.TextColoredRGB("{00DD00}Обновлений нет")
				imgui.PopFont()
				imgui.SameLine(nil, 5)
				imgui.TextColored(imgui.ImColor(0, 221, 0):GetVec4(), fa.ICON_CHECK)
			end
            imgui.NewLine()
            imgui.PushFont(SloganFont)
            imgui.SetCursorPos(imgui.ImVec2(40,50))
                imgui.TextColored(imgui.ImColor(224, 224, 224):GetVec4(), u8"Утилита профессиональных киллеров")
            imgui.PopFont()
			
            ---
            local pos = imgui.GetCursorScreenPos()
            local menu_colors = {
                    u_left = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg]),
                    u_right = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg]),
                    b_right = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg]),
                    b_left = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg])
                }
            imgui.GetWindowDrawList():AddRectFilledMultiColor(imgui.ImVec2(pos.x - 1000, pos.y + 330), imgui.ImVec2(pos.x+1000, pos.y + 400), menu_colors.u_left:GetU32(),menu_colors.u_right:GetU32(),menu_colors.b_right:GetU32(),menu_colors.b_left:GetU32())
            imgui.SetCursorPos(imgui.ImVec2(30,420))
            imgui.Text(fa.ICON_HOME)
			if imgui.IsItemClicked() then ShowListId = 0 end
			imgui.SameLine(nil, 5); imgui.Text(">"); imgui.SameLine(nil, 5)
			if ShowListId == 1 then
				imgui.Text(u8"Информация о скрипте")
				imgui.SameLine(nil, 5); imgui.Text(">")
			end
			if ShowListId == 2 then
				imgui.Text(u8"Новости")
				imgui.SameLine(nil, 5); imgui.Text(">")
			end
			if ShowListId == 3 then
				imgui.Text(u8"Горячие клавиши")
				imgui.SameLine(nil, 5); imgui.Text(">")
			end
			if ShowListId == 4 then
				imgui.Text(u8"Список команд")
				imgui.SameLine(nil, 5); imgui.Text(">")
			end
			if ShowListId == 5 then
				imgui.Text(u8"Настройки")
				imgui.SameLine(nil, 5); imgui.Text(">")
			end
			if ShowListId == 6 then
				imgui.Text(u8"Прочее")
				imgui.SameLine(nil, 5); imgui.Text(">")
			end
            --[[imgui.SameLine(nil, 800)
            imgui.Text(fa.ICON_PALETTE)
            imgui.SameLine(nil, 5)
            imgui.Text("DARK")
            imgui.SameLine(nil, 5)
			if imgui.ToggleButton("Test##1", isLight) then
				--
			end
			imgui.SameLine(nil, 5)
			imgui.Text("LIGHT")]]--
	imgui.EndGroup()
end
function imgui.CreatePaddingX(padding_custom)
	padding_custom = padding_custom or 8 
	imgui.SetCursorPosX(imgui.GetCursorPos().x + padding_custom)
end
function imgui.CreatePaddingY(padding_custom)
	padding_custom = padding_custom or 8
	imgui.SetCursorPosY(imgui.GetCursorPos().y + padding_custom)
end
function imgui.CreatePadding(padding_custom,padding_custom2)
	padding_custom, padding_custom2 = padding_custom or 8, padding_custom2 or 8
	imgui.CreatePaddingX(padding_custom)
	imgui.CreatePaddingY(padding_custom2)
end
function sampGetDistanceLocalPlayerToPlayerByPlayerId(playerId)
    local playerId = tonumber(playerId, 10)
    if not playerId then return end
    local res, han = sampGetCharHandleBySampPlayerId(playerId)
    if res then
        local x, y, z = getCharCoordinates(playerPed)
        local xx, yy, zz = getCharCoordinates(han)
        return true, getDistanceBetweenCoords3d(x, y, z, xx, yy, zz)
    end
    return false
end
function note_dark_style()
	imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
    
	style.WindowPadding = ImVec2(15, 10)
    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 80.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

	colors[clr.Text] = imgui.ImColor(194, 194, 194):GetVec4()
	colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.06, 0.06, 0.06, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
	colors[clr.Button] = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
--[[
function note_light_style()
    local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	style.WindowRounding = 5.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 10.0
	style.ScrollbarRounding = 1
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0

    colors[clr.Text] = ImVec4(0.23, 0.23, 0.23, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.23, 0.23, 0.23, 1.00)
    colors[clr.WindowBg] = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PopupBg] = ImVec4(1.00, 1.00, 1.00, 0.94)
    colors[clr.Border]= ImVec4(0.00, 0.00, 0.00, 0.39)
    colors[clr.BorderShadow] = ImVec4(1.00, 1.00, 1.00, 0.10)
    colors[clr.FrameBg] = ImVec4(1.00, 1.00, 1.00, 0.94)
    colors[clr.FrameBgHovered]= ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.TitleBg] = ImVec4(0.96, 0.96, 0.96, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 1.00, 1.00, 0.51)
    colors[clr.TitleBgActive] = ImVec4(0.82, 0.82, 0.82, 1.00)
    colors[clr.MenuBarBg] = imgui.ImColor(38, 153, 250):GetVec4()
    colors[clr.ScrollbarBg] = ImVec4(0.98, 0.98, 0.98, 0.53)
    colors[clr.ScrollbarGrab] = ImVec4(0.69, 0.69, 0.69, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.59, 0.59, 0.59, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.49, 0.49, 0.49, 1.00)
    colors[clr.ComboBg] = ImVec4(0.86, 0.86, 0.86, 0.99)
    colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button]= ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header]= ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.50)
    colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.CloseButton] = ImVec4(0.59, 0.59, 0.59, 0.50)
    colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines] = ImVec4(0.39, 0.39, 0.39, 1.00)
    colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]= ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.35)
end]]--
--[[function setNoteStyle()
	if isLight.v == true then note_light_style() end
	if isLight.v == false then note_dark_style() end
end]]--

function info_imgui_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 10)
    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 80.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.FrameBgHovered]         = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.FrameBgActive]          = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.TitleBg]                = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.TitleBgActive]          = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.TitleBgCollapsed]       = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = imgui.ImColor(79, 75, 81, 230):GetVec4()
    colors[clr.SeparatorHovered]       = imgui.ImColor(79, 75, 81, 230):GetVec4()
    colors[clr.SeparatorActive]        = imgui.ImColor(79, 75, 81, 230):GetVec4()
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = imgui.ImColor(194, 194, 194):GetVec4()
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = imgui.ImColor(0, 0, 0, 96):GetVec4()
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function checkUpdates()
	local dlstatus = require('moonloader').download_status
	local json_url = 'https://raw.githubusercontent.com/Gayranyan/NSBHelp/main/NSBHelperUPDATE.json'
	local json = getWorkingDirectory() .. '\\NSBHelperUPDATE.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	  function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					updateversion = info.latest
					f:close()
					os.remove(json)
					if updateversion ~= thisScript().version then
						oldVersion = true
					end
				end
			 end
		end
	end)
end

function main()
	updater()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(15000) end
    checkUpdates()
    chHelp_font = renderCreateFont(--[[string]] FontName, --[[int]] FontRazmer, --[[int]] FontFlag)
    sampRegisterChatCommand("nsbnote", nsb_notebook)
    sampRegisterChatCommand("fd",find)
    sampRegisterChatCommand("kcc", clearchat)
    sampRegisterChatCommand("krec", reconnect)
    sampRegisterChatCommand("cl", setcolor)
    sampRegisterChatCommand("/colinfo", colinfo)
    sampRegisterChatCommand("fb", oocf)
    sampRegisterChatCommand("ub", oocu)
    sampRegisterChatCommand("rb", oocr)
    sampRegisterChatCommand("db", oocd)
    sampRegisterChatCommand("cb", oocc)
    sampRegisterChatCommand("id", customid)
    local pircelEnabled = false
    local nightEnabled = false
    local infraredEnabled = false
    lua_thread.create(function()
        while true do wait(0) 
            if ifddd == true then 
                sampSendChat(string.format("/find %d", ifdd)) 
                targetid = ifdd
                wait(3000)
            end 
        end 
    end)
    while true do wait(0)
        hp()
        hp2()
        armour()
        get_fps()
		chHelp()
        eight = math.ceil(six)
        fps = tostring(eight)
		imgui.Process = Notebook_state.v or InfoBar_state.v
        imgui.ShowCursor = false
        local weapon = getCurrentCharWeapon(playerPed)
		if wasKeyPressed(VK_L) and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then sampSendChat('/lock') end
        if res then
            sampDisconnectWithReason(quit)
            wait(time*1000)
            sampSetGamestate(1)
            res = false
        end
		if isKeyDown(VK_RBUTTON) then
			if moveInfo then
				lockPlayerControl(false)
				showCursor(false, false)
				moveInfo = false
				imgui.ShowCursor = false
				InfoBarX = InfoBarNewX
				InfoBarY = InfoBarNewY
				Config.OPTIONS.InfoBarX = InfoBarX
				Config.OPTIONS.InfoBarY = InfoBarY
				notf.addNotification(string.format("Вы успешно сохранили позицию Killer панеля."), 3, 2)
			end
		end
        --------------------------- [ PRICEL ] ---------------------------
        if weapon ~= 0 then
            if isKeyDown(VK_LMENU) and isKeyJustPressed(VK_RBUTTON) and not isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
                pircelEnabled = not pircelEnabled
                if pircelEnabled == true then
                    notf.addNotification(string.format("Вы успешно активировали постоянный прицел."), 3, 2)
                end
                if pircelEnabled == false then
                    notf.addNotification(string.format("Вы успешно деактивировали постоянный прицел."), 3, 2)
                end
            end
            if pircelEnabled == true then
                setGameKeyState(6, 255)
            end
        end
                                    -- [  SNIPER  ] --
        if weapon == 34 then
			if isKeyDown(VK_RBUTTON) or pircelEnabled == true then
				-------------------------- [ N-VISION ] --------------------------
				if isKeyJustPressed(VK_1) and not isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
					nightEnabled = not nightEnabled
					if nightEnabled == true then
						notf.addNotification(string.format("Вы успешно активировали прибор ночного видения снайперской винтовки."), 3, 2)
						setInfraredVision(false)
						infraredEnabled = false
						setNightVision(true)
						nightEnabled = true
					end
					if nightEnabled == false then
						notf.addNotification(string.format("Вы успешно деактивировали прибор ночного видения снайперской винтовки."), 3, 2)
						setInfraredVision(false)
						infraredEnabled = false
						setNightVision(false)
						nightEnabled = false
					end
				end
				-------------------------- [ I-VISION ] --------------------------
				if isKeyJustPressed(VK_2) and not isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
					infraredEnabled = not infraredEnabled
					if infraredEnabled == true then
						notf.addNotification(string.format("Вы успешно активировали тепловизор снайперской винтовки."), 3, 2)
						setNightVision(false)
						nightEnabled = false
						setInfraredVision(true)
						infraredEnabled = true
					end
					if infraredEnabled == false then
						notf.addNotification(string.format("Вы успешно деактивировали тепловизор снайперской винтовки."), 3, 2)
						setNightVision(false)
						nightEnabled = false
						setInfraredVision(false)
						infraredEnabled = false
					end
				end
			end
		end
    end
end
function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x101 then
		if wparam == 0x1B and not isPauseMenuActive() then
			if Notebook_state.v then
				consumeWindowMessage(true, false)
				if msg == 0x101 then
                        Notebook_state.v = false
                        setAudioStreamState(notebook, as_action.PLAY)
                        setAudioStreamVolume(notebook, 50)
                        sampSetChatDisplayMode(2)
                end
            end
        end
    end
end
function imgui.OnDrawFrame()
    if Notebook_state.v then
        note_dark_style()
        local iScreenWidth, iScreenHeight = getScreenResolution()
        sampSetChatDisplayMode(0)
        imgui.LockPlayer = true
        imgui.ShowCursor = true
		imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth/2 , iScreenHeight/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1000, 450), imgui.Cond.FirstUseEver)
		imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(0,0))
        imgui.Begin("Notebook", Notebook_state, imgui.WindowFlags.NoTitleBar +  imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.HorizontalScrollbar)
        local pos = imgui.GetCursorScreenPos()
		local menu_colors = {
            u_left = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg]), 
            u_right = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg]),
            b_right = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg]),
            b_left = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.MenuBarBg])
        }
        imgui.GetWindowDrawList():AddRectFilledMultiColor(imgui.ImVec2(pos.x, pos.y), imgui.ImVec2(pos.x+1000, pos.y + 90), menu_colors.u_left:GetU32(),menu_colors.u_right:GetU32(),menu_colors.b_right:GetU32(),menu_colors.b_left:GetU32())
		imgui.SetCursorPos(imgui.ImVec2(25,10))
		imgui.RenderMenuItems()
		imgui.SetCursorPos(imgui.ImVec2(0,60))
        imgui.BeginGroup()
            if ShowListId == 0 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.SetCursorPosX((imgui.GetWindowWidth() - 820)/2)
                if imgui.Button(fa.ICON_TV.."  "..u8"ИНФОРМАЦИЯ", imgui.ImVec2(260, 100)) then ShowListId = 1 end
                imgui.SameLine(nil, 20)
                if imgui.Button(fa.ICON_NEWSPAPER.."  "..u8"ЧТО НОВОГО?", imgui.ImVec2(260, 100)) then ShowListId = 2 end
                imgui.SameLine(nil, 20)
                if imgui.Button(fa.ICON_KEYBOARD.."  "..u8"ГОРЯЧИЕ КЛАВИШИ", imgui.ImVec2(260, 100)) then ShowListId = 3 end
                imgui.CreatePaddingY(20)
                imgui.SetCursorPosX((imgui.GetWindowWidth() - 820)/2)
                if imgui.Button(fa.ICON_TERMINAL.."  "..u8"КОМАНДЫ", imgui.ImVec2(260, 100)) then ShowListId = 4 end
                imgui.SameLine(nil, 20)
                if imgui.Button(fa.ICON_COG.."  "..u8"НАСТРОЙКИ", imgui.ImVec2(260, 100)) then ShowListId = 5 end
                imgui.SameLine(nil, 20)
                if imgui.Button(fa.ICON_CARET_SQUARE_DOWN.."  "..u8"ПРОЧЕЕ", imgui.ImVec2(260, 100)) then ShowListId = 6 end
            end
            if ShowListId == 1 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.CenterText(u8"Скоро")
            end
            if ShowListId == 2 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.CenterText(u8"Скоро")
            end
            if ShowListId == 3 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.Columns(2)
                imgui.Separator()
                imgui.SetColumnWidth(-1, imgui.GetWindowWidth()/2); imgui.CenterColumnText('Команда [Аргумент]'); imgui.NextColumn()
                imgui.SetColumnWidth(-1, imgui.GetWindowWidth()/2); imgui.CenterColumnText('Описание'); imgui.NextColumn()
                imgui.Separator()
                imgui.CenterColumnText("/nsbnote")
                imgui.NextColumn()
                imgui.CenterColumnText("Меню скрипта.")
                imgui.Separator()
                imgui.NextColumn()
                imgui.CenterColumnText("/fd [ID жертвы]")
                imgui.NextColumn()
                imgui.CenterColumnText("Автоматический поиск жертвы.")
                imgui.CenterColumnText("(Выполняется раз в 3 секунд)")
                imgui.NextColumn()
                imgui.Separator()
                imgui.CenterColumnText("/kcc")
                imgui.NextColumn()
                imgui.CenterColumnText("Очистка чата.")
                imgui.CenterColumnText("(Не работает если установлен MImgUi Chat)")
                imgui.NextColumn()
                imgui.Separator()
                imgui.CenterColumnText("/krec [1-15 сек.]")
                imgui.NextColumn()
                imgui.CenterColumnText("Реконнект")
                imgui.Separator()
            end
            if ShowListId == 4 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.CenterText(u8"Скоро")
            end
            if ShowListId == 5 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.CenterText(u8"Скоро")
            end
            if ShowListId == 6 then
                imgui.NewLine()
                imgui.CreatePaddingY(50)
                imgui.CenterText(u8"Скоро")
            end 
		imgui.EndGroup()
		imgui.End()
		imgui.PopStyleVar(1)
	end
    if InfoBar_state.v then -- #INFO-BAR
		info_imgui_style()
		imgui.SetMouseCursor(imgui.MouseCursor.None)
		imgui.SetNextWindowPos(imgui.ImVec2(InfoBarX , InfoBarY), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(164,138),  imgui.Cond.FirstUseEver)
		imgui.Begin(fa.ICON_CROSS..u8" Информация "..fa.ICON_CROSS, infobar_window, moveInfo and imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoMove + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse or imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
        
		if moveInfo then
			imgui.ShowCursor = true
			pos = imgui.GetWindowPos()
			InfoBarNewX = pos.x
			InfoBarNewY = pos.y
		end
		
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(fa.ICON_CROSS..u8" Информация "..fa.ICON_CROSS).x)/2)
		imgui.TextColored(imgui.ImColor(217, 43, 43):GetVec4(), fa.ICON_CROSS..u8" Информация "..fa.ICON_CROSS)
		imgui.Separator()
        local _, playerid = sampGetPlayerIdByCharHandle(playerPed)
        local color = sampGetPlayerColor(playerid)
        local colorname = string.format("{%0.6x}%s", bit.band(color,0xffffff), sampGetPlayerNickname(playerid))
        imgui.TextColored(imgui.ImColor(217, 43, 43):GetVec4(), fa.ICON_USER_TIE)
        imgui.SameLine(nil, 5)
        imgui.TextColoredRGB(colorname.."{c2c2c2} ["..playerid.."]")
        local x, y, z = getCharCoordinates(PLAYER_PED)
        if getCityPlayerIsIn(playerid) == 0 then city = string.format("Вне города [%s]", getKvadrat()) end
        if getCityPlayerIsIn(playerid) == 1 then city = string.format("Los Santos [%s]", getKvadrat()) end
        if getCityPlayerIsIn(playerid) == 2 then city = string.format("San Fiero [%s]", getKvadrat()) end
        if getCityPlayerIsIn(playerid) == 3 then city = string.format("Las Venturas [%s]", getKvadrat()) end
        if calculateZone(x,y,z) == "Неизвестно" then city = string.format("Неизвестно") end
        zone = string.format("{c2c2c2}%s", city)
        imgui.TextColored(imgui.ImColor(217, 43, 43):GetVec4(), fa.ICON_LOCATION_ARROW)
        imgui.SameLine(nil, 5)
        if calculateZone(x,y,z) == "Неизвестно" then
            imgui.CenterTextColoredRGB("{c2c2c2}Вы в интерьере")
        else imgui.TextColoredRGB(zone) end
        if calculateZone(x,y,z) ~= "Неизвестно" then
            imgui.CenterTextColoredRGB("{c2c2c2}"..calculateZone(x,y,z))
        else imgui.CenterTextColoredRGB("{c2c2c2}Нет") end

        ping = sampGetPlayerPing(playerid)
        indicators = string.format("{cc0000}PING: %s {514f52}| {cc0000}FPS: %s", getStrByPing(ping), getStrByFps(fps))
        imgui.CenterTextColoredRGB(indicators)

        if targetid ~= -1 then
            imgui.Separator()
            local isinst, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(targetid)
            target = string.format("{%0.6x}%s[%s]", bit.band(sampGetPlayerColor(targetid),0xffffff), sampGetPlayerNickname(targetid), targetid)
            imgui.TextColored(imgui.ImColor(217, 43, 43):GetVec4(), fa.ICON_CROSSHAIRS)
            imgui.SameLine(nil, 5)
            imgui.TextColoredRGB(target)
			if isinst then
                if sampIsPlayerPaused(targetid) then
                    target2 = string.format("Дист.: {c2c2c2}%s м. {ff0000}AFK", math.floor(rasst))
                else
                    target2 = string.format("Дист.: {c2c2c2}%s м.", targetid, math.floor(rasst))
				end
				imgui.CenterTextColoredRGB(target2)
			end
        end

        imgui.Separator()
        local datetime = string.format("%s {514f52}| {c2c2c2}%s", os.date("%d.%m.%Y"), os.date("%H:%M:%S"))
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(datetime).x)/2)
        imgui.CenterTextColoredRGB("{c2c2c2}"..datetime)
        imgui.End()
    end
end

function chHelp()
    chat = sampIsChatInputActive()
	if moveCH then
		sampToggleCursor(true)
		mouseX, mouseY = getCursorPos()
	end
    if chhelp_bttn.v then
		if chat == true or moveCH == true then 
			in1 = sampGetInputInfoPtr()
			in1 = getStructElement(in1, 0x8, 4)
			in2 = getStructElement(--[[int]] in1, --[[int]] 0x8, --[[int]] 4)
			in3 = getStructElement(--[[int]] in1, --[[int]] 0xC, --[[int]] 4)
			fib = in3 + 40
			fib2 = in2 + 15
			_, pID = sampGetPlayerIdByCharHandle(playerPed)
			name = sampGetPlayerNickname(--[[int]] pID)
			score = sampGetPlayerScore(--[[int]] pID)
			capsState = ffi.C.GetKeyState(20)
			numState = ffi.C.GetKeyState(144)
			success = ffi.C.GetKeyboardLayoutNameA(KeyboardLayoutName)
			errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(KeyboardLayoutName), 16), 0x00000002, LocalInfo, BuffSize)
			localName = ffi.string(LocalInfo)
			text = string.format("{0088ff} ** {ffffff}Ваш Ник: {0088ff}%s {ffffff}| Ваш ID: {0088ff}%d {ffffff}| Ваш LvL: {0088ff}%d {ffffff}| Num Lock: {0088ff}%s {ffffff}| Caps Lock: {0088ff}%s {ffffff}| Клавиатура: {0088ff}%s", name, pID, score, getStrByState(numState), getStrByState(capsState), localName)
			if moveCH then
				renderDrawLine(chHelpX, chHelpY, mouseX, mouseY, 2, 0xFFFB4343)
				renderFontDrawText(chHelp_font, text, mouseX, mouseY, -1)
				if wasKeyPressed(VK_RBUTTON) then
						moveCH = false
						chHelpX = mouseX
						chHelpY = mouseY
						sampToggleCursor(false)
						notf.addNotification(string.format("Вы успешно сохранили позицию Chat Helper."), 3, 2)
				end
			else renderFontDrawText(chHelp_font, text, chHelpX, chHelpY, -1) end
		end
	end
end

function hp()
	if hphud_bttn.v == true then
		useRenderCommands(true)
		setTextCentre(true) 
		setTextScale(0.2, 0.9)
		setTextColour(255, 255, 255, 255)
		setTextEdge(1, 0, 0, 0, 255)
		displayTextWithNumber(578.0, 66.5, 'NUMBER', getCharHealth(PLAYER_PED))
	end
end

function hp2()
	if hp2hud_bttn.v == true then
		useRenderCommands(true)
		setTextCentre(true) 
		setTextScale(0.2, 0.9)
		setTextColour(255, 255, 255, 255)
		setTextEdge(1, 0, 0, 0, 255)
		displayTextWithNumber(560.0, 75.0, 'NUMBER', getCharHealth(PLAYER_PED))
	end
end

function armour()
	if armhud_btnn.v == true then
        if getCharArmour(PLAYER_PED) > 0 then
            setTextCentre(true)
            setTextScale(0.2, 0.9)
            setTextColour(255, 255, 255, 255)
            setTextEdge(1, 0, 0, 0, 255)
            displayTextWithNumber(578.0, 44.5, 'NUMBER', getCharArmour(PLAYER_PED))
        end
	end
end

function nsb_notebook()
    Notebook_state.v = not Notebook_state.v
    setAudioStreamState(notebook, as_action.PLAY)
    setAudioStreamVolume(notebook, 50)
    sampSetChatDisplayMode(2)
end
function find(param) 
    local id = string.match(param, '(%d+)') 
        if ifddd ~= true then 
            if id ~= nil then
				if sampIsPlayerConnected(id) then
					ifdd = id 
					ifddd = true
					targetid = ifdd
					sampAddChatMessage("** Диспетчер: {333333}Понял агент. Я буду отправить тебе координаты жертвы {550000}раз в 3 секунд{333333}. {cc0000}**", 0xcc0000)
				else
					sampAddChatMessage("** Диспетчер: {333333}Агент, такого человека не существует в штате... {cc0000}**", 0xcc0000) end
			else 
                sampAddChatMessage("** Диспетчер: {333333}Агент, прошу уточнить запрос {550000}[ /fd ID жертвы ] {cc0000}**", 0xcc0000) 
            end 
        else 
            ifddd = false
            targetid = -1
            sampAddChatMessage("** Диспетчер: {333333}Хорошо, я больше не буду отправить тебе координаты жертвы {cc0000}**", 0xcc0000) 
        end 
end

function clearchat()
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end
function reconnect(param)
    time = tonumber(param)
    if time ~= nil and time >= 5 and time <= 15 then
        res = true
    else
        notf.addNotification(string.format(" • Вы не указали один или несколько параметров\n\n /krec секунды(5-20)"), 3, 3)
    end
end
function sampev.onSendGiveDamage(playerID, damage, weapon, bodyPart)
    --local kolokol = loadAudioStream('moonloader/NSBHelp/damage.wav')
	local kolokol = loadAudioStream('https://raw.githubusercontent.com/Gayranyan/NSBHelp/main/damage.wav')
    setAudioStreamVolume(kolokol, math.floor(dmg_volume.v))
    setAudioStreamState(kolokol, 1)
end
function sampev.onDisplayGameText (style, time, text)
	if style == 6 and ifddd == true then 
		return false
	end
end
console.regcmd('fps', fps, 'sampfuncs-like FPS counter')

function getStrByState(keyState)
	if keyState == 0 then
		return "{FF0000}OFF"
	end
	return "{00DD00}ON"
end
function get_fps()
null = null + 1.0
seven = readMemory(0xB7CB84, 4, false)
eight = seven
seven = seven - five
   if seven > 240 then
       four = three
       three = two
       two = one
       one = null
       one = one * 4.0
       six = one
       six = six + two
       six = six + three
       six = six + four
       six = six / 4.0
       null = 0.0
       five = eight
   end 
end
function getStrByPing(ping)
    if ping < 100 then
        return string.format("{008800}%d", ping)
    elseif ping < 150 then
        return string.format("{ff8000}%d", ping)
    end
    return string.format("{ff0000}%d", ping)
end
function getStrByFps(fps)
    if tonumber(fps) < 30 then
        return string.format("{ff0000}%d", fps)
    elseif tonumber(fps) < 60 then
        return string.format("{ff8000}%d", fps)
    end
    return string.format("{008800}%d", fps)
end
function getKvadrat()
    local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end
function calculateZone(x, y, z)
    local streets = {
        {"Avispa Country Club", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Easter Bay Airport", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Avispa Country Club", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Easter Bay Airport", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Garcia", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Shady Cabin", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"East Los Santos", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"LVA Freight Depot", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Blackfield Intersection", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Avispa Country Club", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Temple", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Unity Station", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"LVA Freight Depot", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Los Flores", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Starfish Casino", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Easter Bay Chemicals", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Downtown Los Santos", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Esplanade East", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Market Station", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Linden Station", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Montgomery Intersection", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Frederick Bridge", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Yellow Bell Station", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Downtown Los Santos", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Jefferson", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Mulholland", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Avispa Country Club", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Jefferson", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Julius Thruway West", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Jefferson", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Julius Thruway North", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Rodeo", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Cranberry Station", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Downtown Los Santos", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Redsands West", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Little Mexico", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Blackfield Intersection", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Los Santos International", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Beacon Hill", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Rodeo", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Richman", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Downtown Los Santos", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"The Strip", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Downtown Los Santos", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Blackfield Intersection", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Conference Center", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Montgomery", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Foster Valley", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"Blackfield Chapel", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Los Santos International", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Mulholland", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Yellow Bell Gol Course", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"The Strip", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Jefferson", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Mulholland", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Aldea Malvada", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Las Colinas", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Las Colinas", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Richman", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"LVA Freight Depot", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Julius Thruway North", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Willowfield", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Julius Thruway North", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Temple", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Little Mexico", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Queens", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Las Venturas Airport", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Richman", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Temple", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"East Los Santos", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Julius Thruway East", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Willowfield", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Las Colinas", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Julius Thruway East", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Rodeo", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Las Brujas", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Julius Thruway East", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Rodeo", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Vinewood", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Rodeo", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Julius Thruway North", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Downtown Los Santos", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Rodeo", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Jefferson", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Hampton Barns", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Temple", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Kincaid Bridge", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Verona Beach", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Commerce", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Mulholland", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Rodeo", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Mulholland", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Mulholland", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Julius Thruway South", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Idlewood", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Ocean Docks", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Commerce", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Julius Thruway North", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Temple", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Glen Park", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Easter Bay Airport", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Martin Bridge", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"The Strip", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Willowfield", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Marina", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Las Venturas Airport", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Idlewood", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Esplanade East", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Downtown Los Santos", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"The Mako Span", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Rodeo", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Pershing Square", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Mulholland", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Gant Bridge", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Las Colinas", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Mulholland", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Julius Thruway North", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Commerce", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Rodeo", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Roca Escalante", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Rodeo", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Market", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Las Colinas", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Mulholland", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"King's", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Redsands East", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Downtown", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Conference Center", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Richman", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Ocean Flats", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Greenglass College", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Glen Park", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"LVA Freight Depot", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Regular Tom", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Verona Beach", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"East Los Santos", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Caligula's Palace", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Idlewood", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Pilgrim", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Idlewood", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Queens", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Downtown", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Commerce", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"East Los Santos", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Marina", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Richman", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Vinewood", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"East Los Santos", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Rodeo", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Easter Tunnel", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Rodeo", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Redsands East", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"The Clown's Pocket", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Idlewood", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Montgomery Intersection", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Willowfield", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Temple", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Prickle Pine", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Los Santos International", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Garver Bridge", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Garver Bridge", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Kincaid Bridge", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Kincaid Bridge", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Verona Beach", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Verdant Bluffs", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Vinewood", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Vinewood", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Commerce", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Market", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Rockshore West", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Julius Thruway North", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"East Beach", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Fallow Bridge", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Willowfield", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"Chinatown", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"El Castillo del Diablo", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Ocean Docks", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Easter Bay Chemicals", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"The Visage", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Ocean Flats", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Richman", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Green Palms", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Richman", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Starfish Casino", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"East Beach", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Jefferson", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Downtown Los Santos", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Downtown Los Santos", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Garver Bridge", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Julius Thruway South", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"East Los Santos", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Greenglass College", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Las Colinas", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Mulholland", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Ocean Docks", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"East Los Santos", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Ganton", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Avispa Country Club", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Willowfield", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Esplanade North", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"The High Roller", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Ocean Docks", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Last Dime Motel", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Bayside Marina", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"King's", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"El Corona", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"Blackfield Chapel", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"The Pink Swan", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Julius Thruway West", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Los Flores", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"The Visage", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Prickle Pine", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Verona Beach", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Robada Intersection", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Linden Side", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Ocean Docks", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Willowfield", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"King's", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Commerce", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Mulholland", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Marina", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Battery Point", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"The Four Dragons Casino", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Blackfield", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Julius Thruway North", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Yellow Bell Gol Course", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Idlewood", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Redsands West", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Doherty", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Hilltop Farm", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Las Barrancas", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Pirates in Men's Pants", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"City Hall", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Avispa Country Club", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"The Strip", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Hashbury", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Los Santos International", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Whitewood Estates", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Sherman Reservoir", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"El Corona", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Downtown", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Foster Valley", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Las Payasadas", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Valle Ocultado", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Blackfield Intersection", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Ganton", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Easter Bay Airport", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Redsands East", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Esplanade East", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Caligula's Palace", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Royal Casino", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Richman", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Starfish Casino", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Mulholland", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Downtown", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Hankypanky Point", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"K.A.C.C. Military Fuels", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Harry Gold Parkway", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Bayside Tunnel", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Ocean Docks", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Richman", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Randolph Industrial Estate", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"East Beach", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Flint Water", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Blueberry", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Linden Station", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Glen Park", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Downtown", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Redsands West", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Richman", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Gant Bridge", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Lil' Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Flint Intersection", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Las Colinas", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Sobell Rail Yards", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"The Emerald Isle", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"El Castillo del Diablo", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Santa Flora", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Playa del Seville", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Market", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Queens", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Pilson Intersection", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Spinybed", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Pilgrim", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Blackfield", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"'The Big Ear'", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Dillimore", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"El Quebrados", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Esplanade North", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Easter Bay Airport", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Fisher's Lagoon", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Mulholland", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"East Beach", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"San Andreas Sound", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Shady Creeks", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Market", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Rockshore West", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Prickle Pine", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"Easter Basin", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Leafy Hollow", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"LVA Freight Depot", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Prickle Pine", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Blueberry", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"El Castillo del Diablo", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Downtown", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Rockshore East", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"San Fierro Bay", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Paradiso", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"The Camel's Toe", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Old Venturas Strip", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Juniper Hill", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Juniper Hollow", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Roca Escalante", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Julius Thruway East", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Verona Beach", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Foster Valley", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Arco del Oeste", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"Fallen Tree", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"The Farm", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"The Sherman Dam", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Esplanade North", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Financial", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Garcia", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Montgomery", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Creek", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Los Santos International", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Santa Maria Beach", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Mulholland Intersection", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Angel Pine", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Verdant Meadows", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Octane Springs", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Come-A-Lot", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Redsands West", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Santa Maria Beach", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Verdant Bluffs", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Las Venturas Airport", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Flint Range", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Verdant Bluffs", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Palomino Creek", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Ocean Docks", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Easter Bay Airport", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Whitewood Estates", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Calton Heights", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"Easter Basin", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Los Santos Inlet", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Doherty", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Mount Chiliad", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Fort Carson", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Foster Valley", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Ocean Flats", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Fern Ridge", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Bayside", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Las Venturas Airport", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Blueberry Acres", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Palisades", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"North Rock", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Hunter Quarry", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Los Santos International", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Missionary Hill", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"San Fierro Bay", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Restricted Area", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Mount Chiliad", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Mount Chiliad", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Easter Bay Airport", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"The Panopticon", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Shady Creeks", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Back o Beyond", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Mount Chiliad", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Tierra Robada", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Flint County", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Whetstone", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"Bone County", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"Tierra Robada", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"San Fierro", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"Las Venturas", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"Red County", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"Los Santos", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Неизвестно'
end

function setcolor(param)
	local lenght = string.len(param)
	local frak = tonumber(param)
	--local frak_text
	if lenght ~= 0 and frak ~= 0 then
		if frak == 1 or frak == 11 or frak == 21 then sampSendChat("/me прикрепил(a) значок полицейского.") end -- Police Departaments
		if frak == 2 then sampSendChat("/me прикрепил(а) бейджик.") end -- FBI
		if frak == 3 or frak == 24 or frak == 25 then sampSendChat("/me надел(a) каску.") end -- NGSA
		if frak == 4 then sampSendChat("/me прикрепил(а) бейджик.") end -- MZ
		if frak == 5 then sampSendChat("/me надел(a) перстень Cosa Nostra.") end -- CN
		if frak == 6 then sampSendChat("/me надел(a) перстень Yakuza Mafia.") end --  YM
		if frak == 7 then sampSendChat("/me прикрепил(а) бейджик.") end -- Goverment
		if frak == 9 then sampSendChat("/me прикрепил(а) бейджик.") end -- CNN
		if frak == 10 then sampSendChat("/me надел(a) перстень Triada Mafia.") end -- TM
		if frak == 12 then sampSendChat("/me надел(a) перстень Russian Mafia.") end -- RM
		if frak == 13 then sampSendChat("/me надел(a) бандану Grove Street Gang.") end -- Grove
		if frak == 14 then sampSendChat("/me надел(a) бандану Ballas Gang.") end -- Ballas
		if frak == 15 then sampSendChat("/me надел(a) бандану Los Santos Vagos Gang.") end -- Vagos
		if frak == 16 then sampSendChat("/me надел(a) бандану Los Aztecas Gang.") end -- Aztecas
		if frak == 17 then sampSendChat("/me надел(a) бандану San Fiero Rifa Gang.") end --  Rifa
		if frak == 18 then sampSendChat("/me надел(a) перстень Arabian Mafia.") end -- AM
		--if frak == 19 then sampSendChat("/me ") end -- Street Racers
		--if frak == 20 then sampSendChat("/me ") end -- Bikers
		if frak == 22 then sampSendChat("/me надел(a) берет.") end -- SWAT
		if frak == 23 then sampSendChat("/me надел(а) фурашку.") end -- Priziv
		sampSendChat("/setcolor "..param)
	else 
		notf.addNotification(string.format("Подсказка:\n\nЧтобы посмотреть список доступных цветов используйте: //colinfo"), 8, 2) 
		notf.addNotification(string.format("Не указаны один или несколько параметров..\n\nИспользуйте: /cl [1-25]"), 8, 3) 
	end
end

function colinfo()
  local cinfo = [[
{ffffff}• {0088ff}________________________________________________________________________________ {ffffff}•
{ffffff}
{ffffff}	• {0066FF}/setcolor 1 {ffffff} -{0066FF}  LSPD
{ffffff}	• {6666FF}/setcolor 2 {ffffff} -{6666FF}  FBI
{ffffff}	• {F4A460}/setcolor 3 {ffffff} -{F4A460}  Army
{ffffff}	• {F4A460}/setcolor 4 {ffffff} -{FF6666}  Мин. Здрав
{ffffff}	• {CCCC00}/setcolor 5 {ffffff} -{CCCC00}  Cosa Nostra
{ffffff}	• {990000}/setcolor 6 {ffffff} -{990000}  Yakuza
{ffffff}	• {FFFFFF}/setcolor 7 {ffffff} -{FFFFFF}  Правительство
{ffffff}	• {6e6e6e}/setcolor 8 {ffffff} -{6e6e6e}  Hitman's Agency [ маскировка невозможна ]
{ffffff}	• {FFCC66}/setcolor 9 {ffffff} -{FFCC66}  CNN
{ffffff}	• {003366}/setcolor 10 {ffffff} -{003366}  Triada
{ffffff}	• {122FAA}/setcolor 11 {ffffff} -{122FAA}  SFPD
{ffffff}	• {333333}/setcolor 12 {ffffff} -{333333}  Russian Mafia
{ffffff}	• {00CC00}/setcolor 13 {ffffff} -{00CC00}  Grove  Street
{ffffff}	• {9900CC}/setcolor 14 {ffffff} -{9900CC}  Ballas Gang
{ffffff}	• {FFCC33}/setcolor 15 {ffffff} -{FFCC33}  Vagos Gang
{ffffff}	• {00FFFF}/setcolor 16 {ffffff} -{00FFFF}  Aztecas Gang
{ffffff}	• {339999}/setcolor 17 {ffffff} -{339999}  Rifa Gang
{ffffff}	• {808000}/setcolor 18 {ffffff} -{808000}  Arabian Mafia
{ffffff}	• {CCCC99}/setcolor 19 {ffffff} -{CCCC99}  Street Racers
{ffffff}	• {996666}/setcolor 20 {ffffff} -{996666}  Bikers
{ffffff}	• {2B6CC4}/setcolor 21 {ffffff} -{2B6CC4}  LVPD
{ffffff}	• {191970}/setcolor 22 {ffffff} -{191970}  SWAT
{ffffff}	• {333300}/setcolor 23 {ffffff} -{333300}  Призывник
{ffffff}	• {00CC99}/setcolor 24 {ffffff} -{00CC99}  ВВС
{ffffff}	• {339966}/setcolor 25 {ffffff} -{339966}  ВМФ
{ffffff}
{ffffff}• {0088ff}________________________________________________________________________________ {ffffff}•
]]
  sampShowDialog(247844, "          {FFFFFF}Маскировка: {0088ff}/cl", cinfo, "{ffffff}*", "", 0)
end
function oocf(param) 
	local text = string.match(param, '%s*(.+)') 
		if text ~= nil then 
			sampSendChat(string.format("/f // %s", text)) 
	else 
		notf.addNotification(string.format("Рация фракции. | OOC\n\nИспользуйте: /fb Текст"), 5, 3) 
    end
end
function oocu(param) 
	local text = string.match(param, '%s*(.+)') 
		if text ~= nil then 
			sampSendChat(string.format("/u // %s", text)) 
	else 
        notf.addNotification(string.format("Рация банд и мафий. | OOC\n\nИспользуйте: /ub Текст"), 5, 3) 
    end
end
function oocr(param) 
	local text = string.match(param, '%s*(.+)') 
		if text ~= nil then 
			sampSendChat(string.format("/r // %s", text)) 
	else 
        notf.addNotification(string.format("Канал фракции. | OOC\n\nИспользуйте: /rb Текст"), 5, 3) 
    end
end
function oocd(param) 
	local text = string.match(param, '%s*(.+)') 
		if text ~= nil then 
		sampSendChat(string.format("/d // %s", text)) 
	else 
        notf.addNotification(string.format("Канал департамента. | OOC\n\nИспользуйте: /db Текст"), 5, 3) 
    end
end
function oocc(param) 
	local text = string.match(param, '%s*(.+)') 
		if text ~= nil then 
			sampSendChat(string.format("/c // %s", text)) 
	else 
        notf.addNotification(string.format("Рация семьи. | OOC\n\nИспользуйте: /сb Текст"), 5, 3) 
    end
end
function customid(param)
	local lenght = string.len(param)
	local parasha = nil
	local nick = nil
	if lenght ~= 0 then
		local playerId = tonumber(param)
		if playerId ~= nil  then
			if sampIsPlayerConnected(playerId) then
				--sampAddChatMessage("** Диспетчер: {333333}Вот что я смог найти во твоему запросу: {cc0000}**", 0xcc0000)
				local name = sampGetPlayerNickname(playerId)
				local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(playerId)))
				local level = sampGetPlayerScore(playerId)
				local ping = sampGetPlayerPing(playerId)
				sampAddChatMessage("** Имя: {"..color.."}"..name.."["..playerId.."] {cc0000}| Уровень: {333333}"..level.." {cc0000}| Пинг: {333333}"..ping.." {cc0000}**", 0xcc0000)
			else
				sampAddChatMessage("** Диспетчер: {333333}Я не могу нечего найти. {cc0000}**", 0xcc0000)
			end
		else
			if lenght >= 3 then
				--sampAddChatMessage("** Диспетчер: {333333}Вот что я смог найти во твоему запросу: {cc0000}**", 0xcc0000)
				for i = 0, sampGetMaxPlayerId(false) do
					if sampIsPlayerConnected(i)   then
						nick = sampGetPlayerNickname(i)
						if string.find(nick:upper(), param:upper(), 1, true) ~= nil then
							local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(i)))
							local level = sampGetPlayerScore(i)
							local ping = sampGetPlayerPing(i)
							sampAddChatMessage("** Имя: {"..color.."}"..nick.."["..i.."] {cc0000}| Уровень: {333333}"..level.." {cc0000}| Пинг: {333333}"..ping.." {cc0000}**", 0xcc0000)
							parasha = 1
						end
					end
				end
				if parasha == nil then sampAddChatMessage("** Диспетчер: {333333}Я не могу нечего найти. {cc0000}**", 0xcc0000) end
			else sampAddChatMessage("** Диспетчер: {333333}Слишком мало информации [больше 3-ёх символов]. {cc0000}**", 0xcc0000) end
			parasha = nil
		end
	else
		notf.addNotification(string.format(" • Вы не указали один или несколько параметров\n\n /krec ID/NickName"), 3, 3)
		return false
	end
end

function autoupdate(json_url, prefix, url)
    local json_url = "https://raw.githubusercontent.com/Gayranyan/NSBHelp/main/NSBHelperUPDATE.json"
    local url = "vk.com/rgayranyan"
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\NSBHelperUPDATE.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  sampAddChatMessage("** Диспетчер: {333333}Пытаюсь обновиться c {850000}"..thisScript().version.." {333333}на версию {850000}"..updateversion.." **", 0xcc0000)
                  wait(250)
                    downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                            if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                print(string.format('Загружено %d из %d.', p13, p23))
                            elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                print('Загрузка обновления завершена.')
                                sampAddChatMessage("** Диспетчер: {333333}Обновление програмного обеспечения завершено. {850000}**", 0xcc0000)
                                goupdatestatus = true
                                allowupdate = false
                                lua_thread.create(function() wait(500) thisScript():reload() end)
                            end
                            if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                if goupdatestatus == nil then
                                        sampAddChatMessage("** Диспетчер: {333333}Обновление ПО провалено. Запускаю устаревшую версию. {850000}**", 0xcc0000)
                                update = false
                                end
                            end
                        end
                        )
                  end, prefix
                )
              else
                update = false
                print("{0088ff}"..thisScript().version..' {ffffff}| {00dd00}Обновление не требуется.')
              end
            end
          else
            print("{0088ff}"..thisScript().version..' {ffffff} | {ff0000}Не могу проверить обновление. Обратитесь в тех. поддержку: {0088ff}'..url)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
  end


function updater()
    if not doesDirectoryExist('moonloader\\NSBHelp') then
        createDirectory('moonloader\\NSBHelp')
    elseif not doesFileExist('moonloader\\NSBHelp\\imgui_notf.lua') then
        sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ NSBHelp/imgui_notf.lua ] **", 0xcc0000)
		sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
		thisScript():unload()
    elseif not doesFileExist('moonloader\\NSBHelp\\damage.wav') then
        sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ NSBHelp/damage.wav ] **", 0xcc0000)
		sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
		thisScript():unload()
	elseif not doesFileExist('moonloader\\NSBHelp\\logotype.png') then
        sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ NSBHelp/logotype.png ] **", 0xcc0000)
		sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
		thisScript():unload()
    elseif not doesFileExist('moonloader\\NSBHelp\\note.mp3') then
       sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ NSBHelp/note.mp3 ] **", 0xcc0000)
	   sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
	   thisScript():unload()
    elseif not doesFileExist('moonloader\\NSBHelp\\fonts\\fa-solid-900.ttf') then
        sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ NSBHelp/fonts/fa-solid-900.ttf ] **", 0xcc0000)
		sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
		thisScript():unload()
    elseif not doesFileExist('moonloader\\lib\\fontawesome-webfont.ttf') then
        sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ lib/fontawesome-webfont.ttf ] **", 0xcc0000)
		sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
     elseif not doesFileExist('moonloader\\lib\\fAwesome5.lua') then
        sampAddChatMessage("** Диспетчер: {333333}Не найден файл {cc0000}[ lib/fAwesome5.lua ] **", 0xcc0000)
		sampAddChatMessage("** Диспетчер: {333333}Пожалуйста скачивайте полный архив со скриптом... {cc0000}**", 0xcc0000)
		thisScript():unload()
	 else sampAddChatMessage("** Диспетчер: {4d4d4d}С подключением, агент! Открой ноутбук {6666FF}[ /nsbnote ] **", 0x6666FF) end
end

function save()
	------------- [ MAIN ] -------------
    Config.MAIN.InfoBar = InfoBar_state.v
    Config.MAIN.HP100 = hphud_bttn.v
    Config.MAIN.HP160 = hp2hud_bttn.v
    Config.MAIN.ArmourHUD = armhud_btnn.v
    Config.MAIN.chHelper = chhelp_bttn.v
    Config.MAIN.dmgKololol = dmg_volume.v
    --Config.MAIN.LightEnabled = isLight.v
	
	------------- [ OPTIONS ] -------------
    Config.OPTIONS.InfoBarX = InfoBarX
    Config.OPTIONS.InfoBarY = InfoBarY
    Config.OPTIONS.chHelpPosX = chHelpX
    Config.OPTIONS.chHelpPosY = chHelpY

    if inicfg.save(Config, '..\\NSBHelp\\Settings.ini') then 
        notf.addNotification(string.format("Вы успешно сохранили настройки скрипта."), 3, 2)
    else
        notf.addNotification(string.format("Ошибка при созранении настроек скрипта."), 3, 3)
    end
end
function ARGBtoRGB(color)
	local a = bit.band(bit.rshift(color, 24), 0xFF)
	local r = bit.band(bit.rshift(color, 16), 0xFF)
	local g = bit.band(bit.rshift(color, 8), 0xFF)
	local b = bit.band(color, 0xFF)
	local rgb = b
	rgb = bit.bor(rgb, bit.lshift(g, 8))
	rgb = bit.bor(rgb, bit.lshift(r, 16))
	return rgb
end
function onScriptTerminate(script, quitGame)
    if script == thisScript() then
		sampSetChatDisplayMode(2)
        lockPlayerControl(false)
        showCursor(false, false)
        setNightVision(false)
        setInfraredVision(false)
		save()
    end
end