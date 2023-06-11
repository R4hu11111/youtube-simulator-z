local start = tick()
local client = game:GetService('Players').LocalPlayer;
local set_identity = (type(syn) == 'table' and syn.set_thread_identity) or setidentity or setthreadcontext
local executor = identifyexecutor and identifyexecutor() or 'Unknown'

local function fail(r) return client:Kick(r) end

local usedCache = shared.__urlcache and next(shared.__urlcache) ~= nil

shared.__urlcache = shared.__urlcache or {}
local function urlLoad(url)
	local success, result

	if shared.__urlcache[url] then
		success, result = true, shared.__urlcache[url]
	else
		success, result = pcall(game.HttpGet, game, url)
	end

	if (not success) then
		return fail(string.format('Failed to GET url %q for reason: %q', url, tostring(result)))
	end

	local fn, err = loadstring(result)
	if (type(fn) ~= 'function') then
		return fail(string.format('Failed to loadstring url %q for reason: %q', url, tostring(err)))
	end

	local results = { pcall(fn) }
	if (not results[1]) then
		return fail(string.format('Failed to initialize url %q for reason: %q', url, tostring(results[2])))
	end

	shared.__urlcache[url] = result
	return unpack(results, 2)
end

if type(set_identity) ~= 'function' then return warn("Many features won't work due to your executor lacking the 'set_thread_identity' function") end

local UI = urlLoad("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua")
local themeManager = urlLoad("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua")

local metadata = urlLoad("https://raw.githubusercontent.com/bardium/youtube-simulator-z/main/metadata.lua")
local httpService = game:GetService('HttpService')

local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')
local virtualInputManager = game:GetService('VirtualInputManager')

local pressButton do
	function pressButton(button)
		if (typeof(button) ~= "Instance") or (not button:IsA("ImageButton")) then return end
		if set_identity then
			set_identity(2)
			require(game.ReplicatedStorage.Modules.Float).new(button):Click()
		else
			virtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + button.AbsoluteSize.X / 2, button.AbsolutePosition.Y + 50, 0, true, button, 1)
			virtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + button.AbsoluteSize.X / 2, button.AbsolutePosition.Y + 50, 0, false, button, 1)
		end
	end
end

do
	if shared._unload then
		pcall(shared._unload)
	end

	function shared._unload()
		if shared._id then
			pcall(runService.UnbindFromRenderStep, runService, shared._id)
		end

		UI:Unload()

		for i = 1, #shared.threads do
			coroutine.close(shared.threads[i])
		end

		for i = 1, #shared.callbacks do
			task.spawn(shared.callbacks[i])
		end
	end

	shared.threads = {}
	shared.callbacks = {}

	shared._id = httpService:GenerateGUID(false)

	if set_identity then
		set_identity(7)
	end
	if require(game.ReplicatedStorage.Modules.OPOP).PEE == nil then
		local clamScript = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("NewBideo"):WaitForChild("LocalScript")
		local clam = clamScript.CLAM:Clone()
		clam.N.Text = ""
		require(game.ReplicatedStorage.Modules.OPOP).PEE = clam
		require(game.ReplicatedStorage.Modules.OPOP).COPY = nil
		require(game.ReplicatedStorage.Modules.OPOP).COPY = (function()
			local clam = clamScript.CLAM:Clone()
			clam.N.Text = ""
		end)
	end
	local thread = task.spawn(function()
		while true do
			task.wait()
			if ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
				if client.PlayerGui.MainMenu.C.C.UIGradient.Offset.X < (-0.51 + ((Options.SDPercentage.Value) / 100)) and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
					if workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) then
						task.wait(1)
						client.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
						task.wait(1)
						if workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) then
							repeat
								if workspace.Studio.Items:FindFirstChild("Shop Teleporter") then
									game.Players.LocalPlayer.Character:PivotTo(workspace.Studio.Items:FindFirstChild("Shop Teleporter"):GetPivot() * CFrame.new(0, 7, 0))
									task.wait(.5)
								else
									if workspace.Studio:FindFirstChild("Door") then
										client.Character:PivotTo(workspace.Studio.Door.W:GetPivot())
									end
								end
								task.wait(0.1)
							until not workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
						end
					end
					if not client.Character:FindFirstChild("Handle") then
						repeat
							pressButton(client.PlayerGui.Camera.Fr.ImageButton)
							task.wait()
						until client.Character:FindFirstChild("Handle") or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
					end
					task.wait()
					repeat
						if set_identity then
							set_identity(7)
						end
						task.wait()
						virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
						task.wait()
						game:GetService("ReplicatedStorage").Remotes.Events.ThumbnailStart:FireServer()
						task.wait()
						game:GetService("ReplicatedStorage").Remotes.Events.ThumbnailEnd:FireServer({["Color"] = tonumber(string.format("%.3f", math.random(100, 600) * .001)), ["Pic"] = math.random(2, 7), ["Pose"] = math.random(3, 4), ["Arrow"] = math.random(1, 4)}, 'Thumbnail_1')
						task.wait()
						virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
						task.wait()
					until client.PlayerGui.MainMenu.C.C.UIGradient.Offset.X >= (-0.51 + ((Options.SDPercentage.Value) / 100)) or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
				end
				task.wait()
				if not workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
					game:GetService("ReplicatedStorage").Remotes.Events.ThumbnailStart:FireServer()
					task.wait()
					game:GetService("ReplicatedStorage").Remotes.Events.ThumbnailEnd:FireServer({["Color"] = tonumber(string.format("%.3f", math.random(100, 600) * .001)), ["Pic"] = math.random(2, 7), ["Pose"] = math.random(3, 4), ["Arrow"] = math.random(1, 4)}, 'Thumbnail_1')
					task.wait()
					repeat
						game.ReplicatedStorage.Events._EnterHouse:Fire()
						task.wait(1)
						client.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
						task.wait(0.1)
					until workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
					if set_identity then
						local replaceWithBest = nil
						for _, v in ipairs(client.PlayerGui:GetChildren()) do
							if v:IsA("BillboardGui") and v.Enabled == true and v.Name == "BillboardGui" and v:FindFirstChild("Frame") and v.Frame.Size == UDim2.new(1, 0, 1, 0) and v.Frame:FindFirstChild("ImageButton") and v.Frame.ImageButton:FindFirstChild("TextLabel") and string.lower(v.Frame.ImageButton.TextLabel.Text):match("replace with best") then
								replaceWithBest = v.Frame.ImageButton
							end
						end
						pressButton(replaceWithBest)
					end
				end
				task.wait()
				if client.PlayerGui.Computer.Frame.Visible == false and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
					repeat
						task.wait(1)
						client.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
						task.wait(1)
						if ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
							local Seat = workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true)
							if Seat and client.Character:FindFirstChildOfClass("Humanoid").Sit == false then
								local Chair = Seat:FindFirstAncestorWhichIsA("Model")
								for _, ChairInstance in ipairs(Chair:GetDescendants()) do
									if ChairInstance:IsA("BasePart") then
										ChairInstance.CanCollide = false
									end
								end
								if set_identity then
									local replaceWithBest = nil
									for _, v in ipairs(client.PlayerGui:GetChildren()) do
										if v:IsA("BillboardGui") and v.Enabled == true and v.Name == "BillboardGui" and v:FindFirstChild("Frame") and v.Frame.Size == UDim2.new(1, 0, 1, 0) and v.Frame:FindFirstChild("ImageButton") and v.Frame.ImageButton:FindFirstChild("TextLabel") and string.lower(v.Frame.ImageButton.TextLabel.Text):match("replace with best") then
											replaceWithBest = v.Frame.ImageButton
										end
									end
									pressButton(replaceWithBest)
								end
								repeat
									client.Character:PivotTo(Seat:GetPivot())
									task.wait(1)
									client.Character.PrimaryPart.Velocity = Vector3.new(50, 50, 50)
									task.wait(1)
									client.Character.PrimaryPart.Velocity = Vector3.new(-50, 50, -50)
									task.wait(1)
								until client.Character:FindFirstChildOfClass("Humanoid").Sit == true or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
								for _, ChairInstance in ipairs(Chair:GetDescendants()) do
									if ChairInstance:IsA("BasePart") then
										ChairInstance.CanCollide = true
									end
								end
							end
						end
						task.wait(.5)
					until client.PlayerGui.Computer.Frame.Visible == true or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
				end
				if client.PlayerGui.Computer.Frame.Visible == true and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
					task.wait()
					if ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
						local editingVideoGui
						if not client.PlayerGui:FindFirstChild("editingVideoGui") then
							editingVideoGui = Instance.new("ScreenGui", client.PlayerGui)
							editingVideoGui.Name = "editingVideoGui"
						else
							editingVideoGui = client.PlayerGui:FindFirstChild("editingVideoGui")
						end
						local editingVideoTL = Instance.new("TextLabel", editingVideoGui)
						editingVideoTL.Size = UDim2.new(0.25, 0, 0.075, 0)
						editingVideoTL.AnchorPoint = Vector2.new(0.5, 0.5)
						editingVideoTL.Position = UDim2.new(0.5, 0, 0.8, 0)
						editingVideoTL.TextScaled = true
						editingVideoTL.BackgroundTransparency = 0.5
						editingVideoTL.BorderSizePixel = 0
						editingVideoTL.Text = "Editing video."
						game:GetService("ReplicatedStorage").Remotes.Functions.BeginVIdeo:InvokeServer()
						task.wait(.1)
						local video = game.ReplicatedStorage.Remotes.Functions.BeginVIdeo:InvokeServer()
						local videoLength = 0
						if set_identity then
							set_identity(2)
						end
						local currentComptuer = require(game.ReplicatedStorage.Modules.Computers)[require(game.ReplicatedStorage.Modules.CurrentComputer).Computer]
						local currentComputerSDPer = require(game.ReplicatedStorage.Modules.Formula).SDPerComputer(currentComptuer)
						local SDnumber = game:GetService("ReplicatedStorage").Remotes.Functions.GetMoneyMode:InvokeServer()
						local SDname = SDnumber == 1 and "SD" or "SD" .. tostring(SDnumber)
						local SDestimation = client[SDname].Value
						if videoLength < math.ceil(SDestimation / currentComputerSDPer) then
							repeat
								videoLength = videoLength + 1
							until videoLength >= math.ceil(SDestimation / currentComputerSDPer)
						end
						local extends = {}
						local originalExtend
						if tostring((math.floor(videoLength/20))) ~= "0" then
							editingVideoTL.Text = "Editing video. Progress: 0/" .. tostring((math.floor(videoLength/20)))
						else
							editingVideoTL.Text = "Editing video. Progress: 0/1"
						end
						if videoLength >= 20 and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
							originalExtend = game.ReplicatedStorage.Remotes.Functions.ExtendVideo:InvokeServer(video)
							table.insert(extends, originalExtend)
						end
						editingVideoTL.Text = "Editing video. Progress: 1/" .. tostring((math.floor(videoLength/20)))
						if videoLength >= 40 then
							for extend = 0, (math.floor(videoLength/20) - 1) do
								if ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
									table.insert(extends, game.ReplicatedStorage.Remotes.Functions.ExtendVideo:InvokeServer(video, extends[#extends]))
									task.wait()
									editingVideoTL.Text = "Editing video. Progress: " .. tostring(extend + 1) .. "/" .. tostring((math.floor(videoLength/20)))
								end
							end
						end
						if tostring((math.floor(videoLength/20))) ~= "0" then
							editingVideoTL.Text = "Editing video. Progress: " .. tostring((math.floor(videoLength/20))) .. "/" .. tostring((math.floor(videoLength/20)))
						else
							editingVideoTL.Text = "Editing video. Progress: 1/1"
						end
						game.ReplicatedStorage.Remotes.Events.Export:FireServer(extends, video, videoLength, 'Video_1')
					end
					task.wait()
					game:GetService("ReplicatedStorage").Remotes.Events.Upload:FireServer('Video_1', 'Thumbnail_1', 'Video_1')
					task.wait(1)
					if client.PlayerGui:FindFirstChild("editingVideoGui") then
						client.PlayerGui:FindFirstChild("editingVideoGui"):Destroy()
					end
				end
			end
		end
	end)
	table.insert(shared.callbacks, function()
		pcall(task.cancel, thread)
	end)
end

local SaveManager = {} do
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = 'Toggle', idx = idx, value = object.Value } 
			end,
			Load = function(idx, data)
				if Toggles[idx] then 
					Toggles[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = 'Slider', idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		ColorPicker = {
			Save = function(idx, object)
				return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex() }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValueRGB(Color3.fromHex(data.value))
				end
			end,
		},
		KeyPicker = {
			Save = function(idx, object)
				return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue({ data.key, data.mode })
				end
			end,
		}
	}

	function SaveManager:Save(name)
		local fullPath = 'youtube_simulator_z_autofarm/configs/' .. name .. '.json'

		local data = {
			version = 2,
			objects = {}
		}

		for idx, toggle in next, Toggles do
			if self.Ignore[idx] then continue end
			table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
		end

		for idx, option in next, Options do
			if not self.Parser[option.Type] then continue end
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end 

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then
			return false, 'failed to encode data'
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Load(name)
		local file = 'youtube_simulator_z_autofarm/configs/' .. name .. '.json'
		if not isfile(file) then return false, 'invalid file' end

		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then return false, 'decode error' end
		if decoded.version ~= 2 then return false, 'invalid version' end

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				self.Parser[option.type].Load(option.idx, option)
			end
		end

		return true
	end

	function SaveManager.Refresh()
		local list = listfiles('youtube_simulator_z_autofarm/configs')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1, start - 1))
				end
			end
		end

		Options.ConfigList.Values = out;
		Options.ConfigList:SetValues()
		Options.ConfigList:Display()

		return out
	end

	function SaveManager:Delete(name)
		local file = 'youtube_simulator_z_autofarm/configs/' .. name .. '.json'
		if not isfile(file) then return false, string.format('Config %q does not exist', name) end

		local succ, err = pcall(delfile, file)
		if not succ then
			return false, string.format('error occured during file deletion: %s', err)
		end

		return true
	end

	function SaveManager:SetIgnoreIndexes(list)
		for i = 1, #list do 
			table.insert(self.Ignore, list[i])
		end
	end

	function SaveManager.Check()
		local list = listfiles('youtube_simulator_z_autofarm/configs')

		for _, file in next, list do
			if isfolder(file) then continue end

			local data = readfile(file)
			local success, decoded = pcall(httpService.JSONDecode, httpService, data)

			if success and type(decoded) == 'table' and decoded.version ~= 2 then
				pcall(delfile, file)
			end
		end
	end
end

local Window = UI:CreateWindow({
	Title = string.format('youtube simulator z autofarm - version %s | updated: %s', metadata.version, metadata.updated),
	AutoShow = true,

	Center = true,
	Size = UDim2.fromOffset(550, 627),
})

local Tabs = {}
local Groups = {}

Tabs.Main = Window:AddTab('Main')
Tabs.Miscellaneous = Window:AddTab('Miscellaneous')

Groups.AutoFarm = Tabs.Main:AddLeftGroupbox('AutoFarm')
Groups.AutoFarm:AddToggle('AutoFarm',			{ Text = 'AutoFarm' }):AddKeyPicker('AutoFarmBind', { Default = 'End', NoUI = true, SyncToggleState = true })
Groups.AutoFarm:AddSlider('SDPercentage',		{ Text = 'Video SD Percentage', Min = 2, Max = 100, Default = 100, Suffix = '%', Rounding = 0, Compact = true })

Groups.Configs = Tabs.Miscellaneous:AddRightGroupbox('Configs')
Groups.Credits = Tabs.Miscellaneous:AddRightGroupbox('Credits')
local function addRichText(label)
	label.TextLabel.RichText = true
end

addRichText(Groups.Credits:AddLabel('<font color="#0bff7e">Goose Better</font> - script'))
Groups.Credits:AddLabel('wally & Inori - ui library')


Groups.Misc = Tabs.Miscellaneous:AddRightGroupbox('Miscellaneous')
Groups.Misc:AddLabel(metadata.message or 'no message found!', true)

Groups.Misc:AddDivider()
Groups.Misc:AddButton('Unload script', function() pcall(shared._unload) end)
Groups.Misc:AddButton('Copy discord', function()
	if pcall(setclipboard, "https://wally.cool/discord") then
		UI:Notify('Successfully copied discord link to your clipboard!', 5)
	end
end)

Groups.Misc:AddLabel('Menu toggle'):AddKeyPicker('MenuToggle', { Default = 'Delete', NoUI = true })

UI.ToggleKeybind = Options.MenuToggle

if type(readfile) == 'function' and type(writefile) == 'function' and type(makefolder) == 'function' and type(isfolder) == 'function' then
	makefolder('youtube_simulator_z_autofarm')
	makefolder('youtube_simulator_z_autofarm\\configs')

	Groups.Configs:AddDropdown('ConfigList', { Text = 'Config list', Values = {}, AllowNull = true })
	Groups.Configs:AddInput('ConfigName',    { Text = 'Config name' })

	Groups.Configs:AddDivider()

	Groups.Configs:AddButton('Save config', function()
		local name = Options.ConfigName.Value;
		if name:gsub(' ', '') == '' then
			return UI:Notify('Invalid config name.', 3)
		end

		local success, err = SaveManager:Save(name)
		if not success then
			return UI:Notify(tostring(err), 5)
		end

		UI:Notify(string.format('Saved config %q', name), 5)
		task.defer(SaveManager.Refresh)
	end)

	Groups.Configs:AddButton('Load', function()
		local name = Options.ConfigList.Value
		local success, err = SaveManager:Load(name)
		if not success then
			return UI:Notify(tostring(err), 5)
		end

		UI:Notify(string.format('Loaded config %q', name), 5)
	end):AddButton('Delete', function()
		local name = Options.ConfigList.Value
		if name:gsub(' ', '') == '' then
			return UI:Notify('Invalid config name.', 3)
		end

		local success, err = SaveManager:Delete(name)
		if not success then
			return UI:Notify(tostring(err), 5)
		end

		UI:Notify(string.format('Deleted config %q', name), 5)

		task.spawn(Options.ConfigList.SetValue, Options.ConfigList, nil)
		task.defer(SaveManager.Refresh)
	end)

	Groups.Configs:AddButton('Refresh list', SaveManager.Refresh)

	task.defer(SaveManager.Refresh)
	task.defer(SaveManager.Check)
else
	Groups.Configs:AddLabel('Your exploit is missing file functions so you are unable to use configs.', true)
end

-- Themes
do
	local latestThemeIndex = 0
	for i, theme in next, themeManager.BuiltInThemes do
		if theme[1] > latestThemeIndex then
			latestThemeIndex = theme[1]
		end
	end

	latestThemeIndex = latestThemeIndex + 1

	local linoriaTheme = themeManager.BuiltInThemes.Default[2]
	local ytzTheme = table.clone(themeManager.BuiltInThemes.Default[2])

	ytzTheme.AccentColor = Color3.fromRGB(255, 100, 39):ToHex()

	themeManager.BuiltInThemes['Linoria'] = { latestThemeIndex, linoriaTheme }
	themeManager.BuiltInThemes['Default'] = { 1, ytzTheme }

	themeManager:SetLibrary(UI)
	themeManager:SetFolder('youtube_simulator_z_autofarm')
	themeManager:ApplyToGroupbox(Tabs.Miscellaneous:AddLeftGroupbox('Themes'))

	SaveManager:SetIgnoreIndexes({ 
		"BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", -- themes
		"ThemeManager_ThemeList", 'ThemeManager_CustomThemeList', 'ThemeManager_CustomThemeName', -- themes
	})
end

UI:Notify(string.format('Loaded script in %.4f second(s)!', tick() - start), 3)
