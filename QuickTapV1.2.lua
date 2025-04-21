script_author('meTam')
script_name('Quick Tap')
script_version('2.0')

local imgui = require 'mimgui'
local fa = require 'fAwesome6'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

require 'lib.moonloader'


----==[��������������]==----
-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/qrlk/moonloader-script-updater/master/minified-example.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/qrlk/moonloader-script-updater/"
        end
    end
end



local new = imgui.new
local bNotf, notf = pcall(import, "imgui_notf.lua") 

local ini = inicfg.load({
	config ={
		acti = false,
		vza = false,
		arenda = false,
		dver = false,
		zaprav = false, 
		bizi = false,
		open = false,   
		hous = false, 
		ban = false,
		banOl = false,
		banLa = false,
		banSta = false,
		banKri = false,
		bannkom = false,
		mus = false,
		kvesti= false,
		fCar = false,
		edda = false,
		liftik = false,
		gar = false,
		lav = false,
		parking = false,
	}

}, 'Qtap.ini')

local renderWindow = imgui.new.bool(true)

---------=========[����������]=========---------
local tag ='{FF1493}[Quick Tap]{FFFFFF}'
local fun = 20 -- ���-�� �������
local version = 2.0
local tab = 99
--==[��������]==--
local active = new.bool(ini.config.acti)
local dveri = new.bool(ini.config.dver)
local vzaim = new.bool(ini.config.vza)
local arendeMop = new.bool(ini.config.arenda)
local otkril = new.bool(ini.config.open)
local fill = new.bool(ini.config.zaprav)
local biz = new.bool(ini.config.bizi)
local parkin = new.bool(ini.config.parking)
--==[���]==--
local house = new.bool(ini.config.hous)
local ylicha = true
local gara = false
local podval = false
local miningfer =  false
local garage = new.bool(ini.config.gar)
--==[����]==--
local bank = new.bool(ini.config.ban)
local bankOliga = new.bool(ini.config.banOl)
local bankLaOrag = new.bool(ini.config.banLa)
local bankStat = new.bool(ini.config.banSta)
local bankKripta = new.bool(ini.config.banKri)
local bankomat = new.bool(ini.config.bannkom)
--==[������]==--
local kvestChar = new.bool(ini.config.kvesti)
local musor = new.bool(ini.config.mus)
local famCar = new.bool(ini.config.fCar)
local edaPe = new.bool(ini.config.edda)
local lift = new.bool(ini.config.liftik)
local lavka = new.bool(ini.config.lav)
--==[�����������]==--
local tabli = {
	'����� ������',
	'������� 24/7',
	'��������/���',
	'������ ����',
	'���/������� ��������',
	'���',
	'����������',
	'�������',
	'������� ������',
	'���������� ������',
	--[['',
	'',
	'',
	'',]]

}

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	local config = imgui.ImFontConfig()
	config.MergeMode = true
	config.PixelSnapH = true
	iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
	imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 14, config, iconRanges)
	big = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 60.0, _, glyph_ranges)
    name = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 50, _, glyph_ranges)
	tema()
end)

local newFrame = imgui.OnFrame(
	function() return renderWindow[0] end,
	function(player)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 495, 403 --298- 216
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
		imgui.Begin('Main Window', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)

	--==[���� � ����]==--
	if tab == 1 then
		
		imgui.SetCursorPos(imgui.ImVec2(160,110))
	imgui.BeginChild('##3', imgui.ImVec2(328,236), true)
	--=> ��������
	imgui.ToggleButton(u8'##���������', active) -- � �� �����?
	imgui.SameLine(51)
		if active[0] then
			imgui.Text(u8'��������')
		else
			imgui.Text(u8'���������')
		end
	imgui.SameLine(140)
	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'�������� ������:')
	imgui.Checkbox(u8'��������������', vzaim)
	imgui.Hint('##vzaimod', u8'�������������.. ����������, ����� ���� �������� ������!')
	
	imgui.SameLine()
	imgui.Checkbox(u8'������ ������', arendeMop)
	imgui.Hint('##moped', u8'������������� ������������ �����')

	imgui.Checkbox(u8'����-��������', otkril)
	imgui.Hint('##shlag', u8'������������� ��������� ��������')

	imgui.SameLine()
	imgui.Checkbox(u8'��������', fill)
	imgui.Hint('##zaprav', u8'������������� ��������� ���� ��������, �� (����) �� ���������� ����')

	imgui.SameLine()
	imgui.Checkbox(u8'������', biz)
	imgui.Hint('##biz', u8'������������� ������� � ������� �� ������ �������')

	imgui.Checkbox(u8'��������� �������(no working)', parkin)
	imgui.Hint('##park', u8'������������� �������� � ��������� ������� �1 ')

	imgui.EndChild()

	end
	if tab == 2 then
		imgui.SetCursorPos(imgui.ImVec2(160,110))
	imgui.BeginChild('##2', imgui.ImVec2(328,236), true)
	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'���������� ������:')
	imgui.Checkbox(u8'�������� ���������� ����', bank)
	imgui.Hint('##������', u8'������������� ��������� ���� �������������� � ������ ') --������? 

	imgui.SameLine()
	imgui.Checkbox(u8'��������', bankomat)
	imgui.Hint('##��������', u8'������������� ��������� ���� ���������')

	imgui.Checkbox(u8'���������� ����������', bankStat)
	imgui.Hint('##��������', u8'������������� ��������� ���� (���������� ����������)')

	imgui.SameLine()
	imgui.Checkbox(u8'����� �����������', bankLaOrag)
	imgui.Hint('##���', u8'������������� �������� ����� �����������')

	imgui.Checkbox(u8'����� ��������', bankOliga)
	imgui.Hint('##olig', u8'������������� �������� ����� ��������')

	imgui.SameLine()
	imgui.Checkbox(u8'������������', bankKripta)
	imgui.Hint('##bitcoinSezonEgagaag', u8'������������� ��������� ���� �������������� � �������')

	imgui.EndChild()
	end
	if tab == 3 then
	imgui.SetCursorPos(imgui.ImVec2(160, 110))
	imgui.BeginChild('##5', imgui.ImVec2(328,236), true)
	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'House')

	imgui.Checkbox(u8'���', house)
	imgui.Hint('##�����', u8'������������� ������� � ��� � ������ �������� ������')
	imgui.SameLine()
	if imgui.RadioButtonBool(u8'�� �����',ylicha) then
		ylicha = not ylicha
		gara = false
		podval = false
		miningfer = false
	end
	imgui.SameLine()
	if imgui.RadioButtonBool(u8'� �����',gara) then
		gara = not gara
		ylicha = false
		podval= false
		miningfer= false
	end
	imgui.SameLine()
	if imgui.RadioButtonBool(u8'� ������',podval) then
		podval = not podval
		ylicha= false
		gara= false
		miningfer= false
	end

	if imgui.RadioButtonBool(u8'� �����',miningfer) then
		miningfer = not miningfer
		ylicha = false
		gara= false
		podval = false
	end

	imgui.Checkbox(u8'�����', garage)
	imgui.Hint('##�������', u8'������������� �������� � �����')

	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'�����������(����� �����)')

	imgui.Checkbox(u8'����������', edaPe)
	imgui.Hint('##�������', u8'������������� ��������� ���� �������� � ����')

    imgui.SameLine()
	imgui.Checkbox(u8'������� �����', dveri)
	imgui.Hint('##�����', u8'������������� ��������� ����� ��� ����� ����� �����')

    imgui.SameLine()
    imgui.Checkbox(u8'����', lift)
	imgui.Hint('##������', u8'������������� �������� ��� �� ������ ���� ��������')

	imgui.EndChild()
	end
	if tab == 4 then
	imgui.SetCursorPos(imgui.ImVec2(160, 110))
	imgui.BeginChild('##4', imgui.ImVec2(328,236), true)

	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'������')
  
	imgui.Checkbox(u8'��������� ���������', kvestChar)
	imgui.Hint('##�������������', u8'������������� ��������� ���� �������������� � ��������� ����������')

	imgui.SameLine()
	imgui.Checkbox(u8'�������', musor)
	imgui.Hint('##�������', u8'������������� ��������� ���� �������')

	imgui.Checkbox(u8'�������� ��������', famCar)
	imgui.Hint('##���������', u8'������������� ��������� ���� ��������� ���������')
	
	imgui.SameLine()
	imgui.Checkbox(u8'�����[��]', lavka)
	imgui.Hint('##�����', u8'������������� ��������� ���� �������')

	imgui.EndChild()
	end

	--==[Quick Tap]==--
	imgui.SetCursorPos(imgui.ImVec2(15,0))
    imgui.PushFont(big)
    local a = math.random(0.3, 0.4)
    imgui.TextColored(imgui.ImVec4(255, 0, 0, 0.9), u8'Q')
    imgui.SameLine(51)
    imgui.TextColored(imgui.ImVec4(255, 0, 0, 0.6), u8'uick')
	imgui.PopFont()
	imgui.SetCursorPos(imgui.ImVec2(45,55))
	imgui.PushFont(name)
    imgui.TextColored(imgui.ImVec4(192, 192, 192, a), u8'Tap')
    imgui.PopFont()

	if imgui.Button(u8'��������', imgui.ImVec2(150, 55)) then
		tab = 1
	end
	if imgui.Button(u8'����', imgui.ImVec2(150, 55)) then
		tab = 2
	end
	if imgui.Button(u8'���������', imgui.ImVec2(150, 55)) then
		tab = 3
	end
	if imgui.Button(u8'������', imgui.ImVec2(150, 55)) then
		tab = 4
	end

	imgui.SetCursorPos(imgui.ImVec2(30,370))
    imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.6), u8'Author:')
    imgui.SameLine()
    local a2 = math.random(0.85, 0.9)
    imgui.TextColored(imgui.ImVec4(1, 1, 1, a2), u8'meTam')

	imgui.SetCursorPos(imgui.ImVec2(470, 5))
	if imgui.Button(u8'##gfd1', imgui.ImVec2(20, 23)) then
		renderWindow[0] = not renderWindow[0]
	end
	imgui.SetCursorPos(imgui.ImVec2(448,5))
	if imgui.Button(u8'##gfd2', imgui.ImVec2(20, 23)) then
		thisScript():reload()
	end
	imgui.SetCursorPos(imgui.ImVec2(476, 10))
	imgui.Text(fa.XMARK)
	imgui.SetCursorPos(imgui.ImVec2(452,10))
	imgui.Text(fa.REPEAT)

	imgui.SetCursorPos(imgui.ImVec2(198, 52))
	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'� ������� ��������: ' .. fun .. u8' �������')
	imgui.SetCursorPos(imgui.ImVec2(200, 40))
	imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.65), u8'���������� ������ �������: 2.0' )--.. version)
	imgui.SetCursorPos(imgui.ImVec2(200,373))   
	if imgui.Button(u8'��������� ���������') then
		ini.config.acti = active[0]
		ini.config.vza = vzaim[0]
		ini.config.arenda = arendeMop[0]
		ini.config.bizi = biz[0]
		ini.config.open = otkril[0]
		ini.config.zaprav = fill[0]
		ini.config.ban = bank[0]
		ini.config.banOl = bankOliga[0]
		ini.config.banKri = bankKripta[0]
		ini.config.banSta = bankStat[0]
		ini.config.bannkom = bankomat[0]
		ini.config.banLa = bankLaOrag[0]
		ini.config.liftik = lift[0]
		ini.config.mus = musor[0]
		ini.config.edda = edaPe[0]
		ini.config.fCar = famCar[0]
		ini.config.kvesti = kvestChar[0]
		ini.config.dver = dveri[0]
		ini.config.hous = house[0]
		ini.config.gar = garage[0]
		ini.config.lav = lavka[0]

		inicfg.save(ini, 'Qtap.ini')
		notf.addNotification("��������� ������� ���������!", 4, 1)
		sampAddChatMessage(tag .. ' ��������� ������� ���������!', -1) -- �� � ��� ���� 
	end

	if tab == 99 then
		imgui.SetCursorPos(imgui.ImVec2(160, 110))
		imgui.BeginChild('##4', imgui.ImVec2(328,236), true)

		imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8'Quick')
		imgui.SameLine(39)
		imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), u8'Tap')
		imgui.SameLine()
		imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.8),  u8'- ������, ��������� ��� ������ �������.')
		imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.6), u8'� ���� �������� ��� ����� �� ����� ����� ������...')
		imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.6), u8'... ������ ������� �� ����������')

		imgui.TextColored(imgui.ImVec4(192, 192, 192, 0.9), u8'������ ��� ����� ��������������! <3')

		imgui.EndChild()
	end

		imgui.End()
	end
)

function main()
	while not isSampAvailable() do wait(0) end

	if not doesFileExist('moonloader/config/Qtap.ini') then inicfg.save(ini,'Qtap.ini') end

	sampRegisterChatCommand('fas', function()
		renderWindow[0] = not renderWindow[0]
	end)

	sampAddChatMessage(tag .. ' ������ ��������! by {FF1493}meTam', -1)
	sampAddChatMessage(tag .. ' ��������� {FF00FF}/fas{FFFFFF}' , -1)
	sampAddChatMessage(tag .. ' ������ �������:{FF00FF} 2.0' , -1)--.. version, -1)
	while true do
		wait(0)

	end
end

addEventHandler('onReceivePacket', function (id, bs)
	if id == 220 then
	  lua_thread.create(function ()
	  raknetBitStreamIgnoreBits(bs, 8)
		if (raknetBitStreamReadInt8(bs) == 17) then
			raknetBitStreamIgnoreBits(bs, 32)
			local length = raknetBitStreamReadInt16(bs)
			local encoded = raknetBitStreamReadInt8(bs)
			local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
				if active[0] then
					if vzaim[0] then
						if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('��������������') then
							setVirtualKeyDown(18, true)
							wait(10)
							setVirtualKeyDown(18, false)
						end
					end
				end
				if arendeMop[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('������ ������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
						wait(250)
						sampCloseCurrentDialogWithButton(1)
					end
				end
				if otkril[0] then
					if str:find("cef.modals.showModal") and str:find("H") and str:find("interactionSidebar") and str:find('�������') then 
						wait(500)
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
						wait(150)
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
						wait(150)
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
					end
				end
				if fill[0] then
					if str:find("cef.modals.showModal") and str:find("H") and str:find("interactionSidebar") and str:find('������������') then 
						wait(500)
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
						wait(150)
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
					end
				end
				if biz[0] then
					for k, v in pairs(tabli) do
						if str:find("cef.modals.showModal") and str:find("ALT") and str:find("businessInfo") and str:find(v) then
							setVirtualKeyDown(18, true)
							wait(10)
							setVirtualKeyDown(18, false)
						end 
						if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('����� �� �������') then
							setVirtualKeyDown(18, true)
							wait(10)
							setVirtualKeyDown(18, false)
					   end
					end
				end
				--==[����]==--
				if bank[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('������� ���� �����') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if bankLaOrag[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('�������� �����') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if bankOliga[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('�������� ����������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if bankStat[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('������� ����') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if bankKripta[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('�������� � �������������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if bankomat[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('������� ���� ���������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				--==[���]==--
				if house[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("businessInfo") and str:find('������� ���') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
					wait(200)
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('����� ��') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
						wait(100)
						if ylicha then
							sampSendDialogResponse(9989, 1 , 0, nil)
							wait(100)
							sampCloseCurrentDialogWithButton(0)
						end
						if gara then
							sampSendDialogResponse(9989, 1 , 3, nil)
							wait(100)
							sampCloseCurrentDialogWithButton(0)
						end
						if podval then
							sampSendDialogResponse(9989, 1 , 1, nil)
							wait(100)
							sampCloseCurrentDialogWithButton(0)
						end
						if miningfer then
							sampSendDialogResponse(9989, 1 , 2, nil)
							wait(100)
							sampCloseCurrentDialogWithButton(0)
						end
					end
				end
				if garage[0] then
					if str:find("cef.modals.showModal") and str:find("H") and str:find("interactionSidebar") and str:find('�����') then 
						wait(500)
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
					end
				end
				--==[������]==--
				if kvestChar[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('��������� ��������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if musor[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('�������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if famCar[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('�������� ��������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if dveri[0] then
					if str:find("cef.modals.showModal") and str:find("H") and str:find("interactionSidebar") and str:find('�������') then
						setVirtualKeyDown(72, true)
						wait(10)
						setVirtualKeyDown(72, false)
						wait(100)
						setVirtualKeyDown(72, true) -- ������ ��� �� ������ ������
						wait(10)
						setVirtualKeyDown(72, false)
					end
				end
				if edaPe[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('����������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
				if lift[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('������� ����') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
						wait(200)
						sampSendDialogResponse(27397, 1 , 0, nil)
						wait(200)
						sampCloseCurrentDialogWithButton(1)
						wait(500) -- ����� ������ ��������� ��� ���� CEF
					end
				end
				if lavka[0] then
					if str:find("cef.modals.showModal") and str:find("ALT") and str:find("interactionSidebar") and str:find('���� �������') then
						setVirtualKeyDown(18, true)
						wait(10)
						setVirtualKeyDown(18, false)
					end
				end
			end
		end)
	end
end)
--
function tema()
	imgui.SwitchContext()
	--==[ STYLE ]==--
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10
	imgui.GetStyle().GrabMinSize = 10

	--==[ BORDER ]==--
	imgui.GetStyle().WindowBorderSize = 1
	imgui.GetStyle().ChildBorderSize = 1
	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 1

	--==[ ROUNDING ]==--
	imgui.GetStyle().WindowRounding = 5
	imgui.GetStyle().ChildRounding = 5
	imgui.GetStyle().FrameRounding = 5
	imgui.GetStyle().PopupRounding = 5
	imgui.GetStyle().ScrollbarRounding = 5
	imgui.GetStyle().GrabRounding = 5
	imgui.GetStyle().TabRounding = 5

	--==[ ALIGN ]==--
	imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
	imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
	imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
	imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
	imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
	imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
	imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end

function imgui.ToggleButton(str_id, bool)
	local rBool = false

	if LastActiveTime == nil then
		LastActiveTime = {}
	end
	if LastActive == nil then
		LastActive = {}
	end

	local function ImSaturate(f)
		return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
	end

	local p = imgui.GetCursorScreenPos()
	local dl = imgui.GetWindowDrawList()

	local height = imgui.GetTextLineHeightWithSpacing()
	local width = height * 1.70
	local radius = height * 0.50
	local ANIM_SPEED = type == 2 and 0.10 or 0.15
	local butPos = imgui.GetCursorPos()

	if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
		bool[0] = not bool[0]
		rBool = true
		LastActiveTime[tostring(str_id)] = os.clock()
		LastActive[tostring(str_id)] = true
	end

	imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
	imgui.Text( str_id:gsub('##.+', '') )

	local t = bool[0] and 1.0 or 0.0

	if LastActive[tostring(str_id)] then
		local time = os.clock() - LastActiveTime[tostring(str_id)]
		if time <= ANIM_SPEED then
			local t_anim = ImSaturate(time / ANIM_SPEED)
			t = bool[0] and t_anim or 1.0 - t_anim
		else
			LastActive[tostring(str_id)] = false
		end
	end

	local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
	dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg]), height * 0.5)
	dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle)
	return rBool
end

function imgui.Hint(str_id, hint, delay)
	local hovered = imgui.IsItemHovered()
	local animTime = 0.2
	local delay = delay or 0.00
	local show = true

	if not allHints then allHints = {} end
	if not allHints[str_id] then
		allHints[str_id] = {
			status = false,
			timer = 0
		}
	end

	if hovered then
		for k, v in pairs(allHints) do
			if k ~= str_id and os.clock() - v.timer <= animTime  then
				show = false
			end
		end
	end

	if show and allHints[str_id].status ~= hovered then
		allHints[str_id].status = hovered
		allHints[str_id].timer = os.clock() + delay
	end

	if show then
		local between = os.clock() - allHints[str_id].timer
		if between <= animTime then
			local s = function(f)
				return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
			end
			local alpha = hovered and s(between / animTime) or s(1.00 - between / animTime)
			imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
			imgui.SetTooltip(hint)
			imgui.PopStyleVar()
		elseif hovered then
			imgui.SetTooltip(hint)
		end
	end
end
