local start = tick()
local client = game:GetService('Players').LocalPlayer;
local set_identity = (type(syn) == 'table' and syn.set_thread_identity) or setidentity or setthreadcontext
local getsenv = getsenv
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

if type(set_identity) ~= 'function' then return fail('Unsupported exploit (missing "set_thread_identity")') end
if type(getsenv) ~= 'function' then return fail('Unsupported exploit (missing "getsenv")') end

local getinfo = debug.getinfo or getinfo;
local getupvalues = debug.getupvalues or getupvalues;

if type(getupvalues) ~= 'function' then return fail('Unsupported exploit (missing "debug.getupvalues")') end

local UI = urlLoad("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua")
local themeManager = urlLoad("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua")

local metadata = urlLoad("https://raw.githubusercontent.com/bardium/youtube-simulator-z/main/metadata.lua")
local httpService = game:GetService('HttpService')

local clickEvent = nil
local counter = 0

while true do
	set_identity(7)

	for _, v in pairs(getsenv(client.PlayerGui.Camera.LocalScript)) do
		if typeof(v) == "function" then
			for l, z in pairs(getupvalues(v)) do
				if typeof(z) == "table" then
					for x, y in pairs(z) do
						if typeof(y) == "Instance" and y:IsA("BindableEvent") then
							clickEvent = y
						end
					end
				end
			end
		end
	end

	local clamScript = client.PlayerGui:WaitForChild("NewBideo"):WaitForChild("LocalScript")
	local clam = clamScript.CLAM:Clone()
	clam.N.Text = ""
	require(game.ReplicatedStorage.Modules.OPOP).PEE = clam
	require(game.ReplicatedStorage.Modules.OPOP).COPY = nil
	require(game.ReplicatedStorage.Modules.OPOP).COPY = (function()
		local clam = clamScript.CLAM:Clone()
		clam.N.Text = ""
	end)
	
	if (require(game.ReplicatedStorage.Modules.OPOP).PEE ~= nil and typeof(clickEvent) == "Instance") then
		break
	end

	counter = counter + 1
	if counter > 6 then
		fail(string.format('Failed to load game dependencies. Details: %s, %s', typeof((require(game.ReplicatedStorage.Modules.OPOP).PEE)), typeof(clickEvent)))
	end
end

local runService = game:GetService('RunService')
local virtualInputManager = game:GetService('VirtualInputManager')

local pressButton do
	function pressButton(button)
		if (typeof(button) ~= "Instance") or (not button:IsA("ImageButton")) then return end
		set_identity(2)
		require(game.ReplicatedStorage.Modules.Float).new(button):Click()
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

	set_identity(7)
	local thread = task.spawn(function()
		while true do
			task.wait()
			if ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
				if client.PlayerGui.MainMenu.C.C.UIGradient.Offset.X < (-0.51 + ((Options.VideoSDPercentage.Value) / 100)) and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
					if workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) then
						task.wait(1)
						client.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
						task.wait(1)
						if workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) then
							if workspace.Studio.Items:FindFirstChild("Shop Teleporter") then
								client.Character:PivotTo(workspace.Studio.Items:FindFirstChild("Shop Teleporter"):GetPivot() * CFrame.new(0, 7, 0))
								set_identity(7)
								repeat task.wait() until (workspace.Upgrades.Cameras:FindFirstChild("X", true) and workspace.Upgrades.Computers:FindFirstChild("X", true)) or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
							else
								if workspace.Studio:FindFirstChild("Door") then
									repeat
										client.Character:PivotTo(workspace.Studio.Door.W:GetPivot())
										task.wait()
									until (not workspace.Studio:FindFirstChild("Door")) or (((getsenv(client.PlayerScripts.Ads)).isOutside()) == true)
									repeat
										game.ReplicatedStorage.Events._EnterUpgrades:Fire()
										task.wait()
									until (((getsenv(client.PlayerScripts.Ads)).isOutside()) == false)
								end
							end
						end
					end
					task.wait(.1)
					set_identity(2)
					local SDnumber = game.ReplicatedStorage.Remotes.Functions.GetMoneyMode:InvokeServer()
					local moneyName = SDnumber == 1 and "Money" or "Money" .. tostring(SDnumber)
					local moneyValue = client:FindFirstChild(moneyName)
					local nextFloorPrice = math.huge
					require(game.ReplicatedStorage.Modules.Upgrades)["Display"](SDnumber)
					require(game.ReplicatedStorage.Modules.Elevator)["Floor"] = (SDnumber)
					for _, camera in ipairs(workspace.Upgrades.Cameras:GetChildren()) do
						local cameraNumber = (20 * tonumber(SDnumber - 1) + tonumber(camera.Name))
						if camera.a.BrickColor == BrickColor.new("Cyan") then
							if workspace.Upgrades.Cameras:FindFirstChild(tostring((tonumber(camera.Name) + 1))) then
								local betterCamera = workspace.Upgrades.Cameras:FindFirstChild(tostring((tonumber(camera.Name) + 1)))
								if betterCamera.a.BrickColor == BrickColor.new("Persimmon") then
									local ownedCamera = game.ReplicatedStorage.Remotes.Functions.BuyUpgrade:InvokeServer(cameraNumber, true);
									if not require(game.ReplicatedStorage.Modules.OwnedCameras).Owned[tostring(cameraNumber)] and ownedCamera then
										require(game.ReplicatedStorage.Modules.OwnedCameras).new(cameraNumber)
									end
									game.ReplicatedStorage.Events.UpdateCam:Fire(tonumber(cameraNumber))
								end
							else
								local ownedCamera = game.ReplicatedStorage.Remotes.Functions.BuyUpgrade:InvokeServer(cameraNumber, true);
								if not require(game.ReplicatedStorage.Modules.OwnedCameras).Owned[tostring(cameraNumber)] and ownedCamera then
									require(game.ReplicatedStorage.Modules.OwnedCameras).new(cameraNumber)
								end
								game.ReplicatedStorage.Events.UpdateCam:Fire(tonumber(cameraNumber))
							end
						elseif camera.Name == "20" and camera.a.BrickColor == BrickColor.new("Bright green") then
							nextFloorPrice = 0
							set_identity(2)
							nextFloorPrice += tonumber(require(game.ReplicatedStorage.Modules.Formula).PricePerCamera(cameraNumber + 1))
						end
					end

					for _, computer in ipairs(workspace.Upgrades.Computers:GetChildren()) do
						local computerNumber = (20 * tonumber(SDnumber - 1) + tonumber(computer.Name))
						if computer.a.BrickColor == BrickColor.new("Cyan") then
							if workspace.Upgrades.Computers:FindFirstChild(tostring((tonumber(computer.Name) + 1))) then
								local betterComputer = workspace.Upgrades.Computers:FindFirstChild(tostring((tonumber(computer.Name) + 1)))
								if betterComputer.a.BrickColor == BrickColor.new("Persimmon") then
									game.ReplicatedStorage.Remotes.Functions.BuyUpgrade:InvokeServer(computerNumber, false);
								end
							else
								game.ReplicatedStorage.Remotes.Functions.BuyUpgrade:InvokeServer(computerNumber, false);
							end
						elseif computer.Name == "20" and computer.a.BrickColor == BrickColor.new("Bright green") then
							set_identity(2)
							nextFloorPrice += tonumber(require(game.ReplicatedStorage.Modules.Formula).PricePerComputer(computerNumber + 1))
						end
					end

					if moneyValue.Value > nextFloorPrice and (Options.FloorToStop.Value) ~= 1 then
						if SDnumber ~= 8 and ((SDnumber) < (Options.FloorToStop.Value)) then
							set_identity(2)

							require(game.ReplicatedStorage.Modules.Upgrades)["Display"](SDnumber + 1)
							require(game.ReplicatedStorage.Modules.Elevator)["Floor"] = (SDnumber + 1)
							SDnumber = game.ReplicatedStorage.Remotes.Functions.GetMoneyMode:InvokeServer() + 1

							local cameraNumber = (20 * tonumber(SDnumber - 1) + 1)
							local ownedCamera = game.ReplicatedStorage.Remotes.Functions.BuyUpgrade:InvokeServer(cameraNumber, true);
							if not require(game.ReplicatedStorage.Modules.OwnedCameras).Owned[tostring(cameraNumber)] and ownedCamera then
								require(game.ReplicatedStorage.Modules.OwnedCameras).new(cameraNumber)
							end
							game.ReplicatedStorage.Events.UpdateCam:Fire(tonumber(cameraNumber))

							local computerNumber = (20 * tonumber(SDnumber - 1) + 1)
							game.ReplicatedStorage.Remotes.Functions.BuyUpgrade:InvokeServer(computerNumber, false);
						end
					end
					SDnumber = game.ReplicatedStorage.Remotes.Functions.GetMoneyMode:InvokeServer()
					game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BUYSD"):InvokeServer(((Options.SDPercentageToBuy.Value)/100), SDnumber)
					task.wait()
					set_identity(2)
					task.wait()
					if (not client.Character:FindFirstChild("Handle")) then
						repeat
							pressButton(client.PlayerGui.Camera.Fr.ImageButton)
							task.wait()
						until client.Character:FindFirstChild("Handle")
					end
					task.wait()
					set_identity(7)
					repeat
						task.spawn(function()
							game.ReplicatedStorage.Remotes.Events.ThumbnailStart:FireServer()
							task.wait()
							game.ReplicatedStorage.Remotes.Events.ThumbnailEnd:FireServer({["Color"] = tonumber(string.format("%.3f", math.random(100, 600) * .001)), ["Pic"] = math.random(2, 7), ["Pose"] = math.random(3, 4), ["Arrow"] = math.random(1, 4)}, 'Thumbnail_1')
						end)
						task.spawn(function()
							if Options.InputMode.Value == 'virtual input' then
								virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
								virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
							else
								clickEvent:Fire({["UserInputType"] = Enum.UserInputType.Keyboard, ["KeyCode"] = Enum.KeyCode.E})
							end
						end)
						task.wait(Options.ClickDelay.Value)
					until client.PlayerGui.MainMenu.C.C.UIGradient.Offset.X >= (-0.51 + ((Options.VideoSDPercentage.Value) / 100)) or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
				end
				task.wait()
				if not workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) and ((Toggles.AutoFarm) and (Toggles.AutoFarm.Value)) then
					game.ReplicatedStorage.Remotes.Events.ThumbnailStart:FireServer()
					task.wait()
					game.ReplicatedStorage.Remotes.Events.ThumbnailEnd:FireServer({["Color"] = tonumber(string.format("%.3f", math.random(100, 600) * .001)), ["Pic"] = math.random(2, 7), ["Pose"] = math.random(3, 4), ["Arrow"] = math.random(1, 4)}, 'Thumbnail_1')
					task.wait()
					repeat
						game.ReplicatedStorage.Events._EnterHouse:Fire()
						task.wait(0.1)
					until workspace.Studio.Items:FindFirstChildWhichIsA("Seat", true) or ((not Toggles.AutoFarm) or (not Toggles.AutoFarm.Value))
					local replaceWithBest = nil
					for _, v in ipairs(client.PlayerGui:GetChildren()) do
						if v:IsA("BillboardGui") and v.Enabled == true and v.Name == "BillboardGui" and v:FindFirstChild("Frame") and v.Frame.Size == UDim2.new(1, 0, 1, 0) and v.Frame:FindFirstChild("ImageButton") and v.Frame.ImageButton:FindFirstChild("TextLabel") and string.lower(v.Frame.ImageButton.TextLabel.Text):match("replace with best") then
							replaceWithBest = v.Frame.ImageButton
						end
					end
					pressButton(replaceWithBest)
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
								local replaceWithBest = nil
								for _, v in ipairs(client.PlayerGui:GetChildren()) do
									if v:IsA("BillboardGui") and v.Enabled == true and v.Name == "BillboardGui" and v:FindFirstChild("Frame") and v.Frame.Size == UDim2.new(1, 0, 1, 0) and v.Frame:FindFirstChild("ImageButton") and v.Frame.ImageButton:FindFirstChild("TextLabel") and string.lower(v.Frame.ImageButton.TextLabel.Text):match("replace with best") then
										replaceWithBest = v.Frame.ImageButton
									end
								end
								pressButton(replaceWithBest)
								set_identity(2)
								for _, v in ipairs(workspace.Studio.Items:GetChildren()) do
									if v.Name:match("Computer_") then
										getsenv(client.PlayerGui.Computer.Frame.LocalScript)["turnOn"](v.Name)
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
						game.ReplicatedStorage.Remotes.Functions.BeginVIdeo:InvokeServer()
						task.wait(.1)
						local video = game.ReplicatedStorage.Remotes.Functions.BeginVIdeo:InvokeServer()
						local videoLength = 0
						set_identity(2)
						local currentComptuer = require(game.ReplicatedStorage.Modules.Computers)[require(game.ReplicatedStorage.Modules.CurrentComputer).Computer]
						local currentComputerSDPer = require(game.ReplicatedStorage.Modules.Formula).SDPerComputer(currentComptuer)
						local SDnumber = game.ReplicatedStorage.Remotes.Functions.GetMoneyMode:InvokeServer()
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
					game.ReplicatedStorage.Remotes.Events.Upload:FireServer('Video_1', 'Thumbnail_1', 'Video_1')
					task.wait(1)
					if client.PlayerGui:FindFirstChild("editingVideoGui") then
						client.PlayerGui:FindFirstChild("editingVideoGui"):Destroy()
					end
					set_identity(2)
					for _, v in ipairs(workspace.Studio.Items:GetChildren()) do
						if v.Name:match("Computer_") then
							getsenv(client.PlayerGui.Computer.Frame.LocalScript)["turnOff"](v.Name)
						end
					end
				end
			end
		end
	end)
	table.insert(shared.callbacks, function()
		pcall(task.cancel, thread)
	end)
end

-- Auto chest opener
do
	local thread = task.spawn(function()
		while true do
			task.wait()
			if ((Toggles.AutoOpenChests) and (Toggles.AutoOpenChests.Value)) then
				UI:Notify("Started opening chests! (make sure to have chest gui open)", 5)
				local startTime = tick()

				local chestGui = nil
				for _, v in ipairs(client.PlayerGui:GetChildren()) do
					if v.Name == "Chest" and v:FindFirstChild("b") and v:FindFirstChild("C") then
						chestGui = v
					end
				end
				local openChestButton = chestGui:WaitForChild("b"):WaitForChild("ImageButton")

				if chestGui.C.C.TextLabel.TextLabel.TextLabel.Text ~= "0" then
					set_identity(2)
					repeat
						pressButton(openChestButton)
						task.wait()
					until chestGui.C.C.TextLabel.TextLabel.TextLabel.Text == "0" or ((not Toggles.AutoOpenChests) or (not Toggles.AutoOpenChests.Value))
					set_identity(7)
				end
				Toggles.AutoOpenChests:SetValue(false)
				UI:Notify(string.format('Finished opening chests in %.4f second(s)!', tick() - startTime), 5)
			end
		end
	end)
	table.insert(shared.callbacks, function()
		pcall(task.cancel, thread)
	end)
end

-- Auto press E
do
	local thread = task.spawn(function()
		while true do
			task.wait()
			if ((Toggles.AutoPressE) and (Toggles.AutoPressE.Value)) then
				task.spawn(function()
					virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
					virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
				end)
			end
		end
	end)
	table.insert(shared.callbacks, function()
		pcall(task.cancel, thread)
	end)
end

-- Auto clicker
do
	local thread = task.spawn(function()
		local centerFrame = client.PlayerGui:WaitForChild("RebirthOptions"):WaitForChild("Frame")
		while true do
			task.wait()
			if ((Toggles.AutoClick) and (Toggles.AutoClick.Value)) then
				task.spawn(function()
					virtualInputManager:SendMouseButtonEvent((centerFrame.AbsoluteSize.X - centerFrame.AbsolutePosition.X)/2, (centerFrame.AbsoluteSize.Y - centerFrame.AbsolutePosition.Y)/2, 0, true, game,1)
					virtualInputManager:SendMouseButtonEvent((centerFrame.AbsoluteSize.X - centerFrame.AbsolutePosition.X)/2, (centerFrame.AbsoluteSize.Y - centerFrame.AbsolutePosition.Y)/2, 0, false, game,1)
				end)
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
	Groups.AutoFarm:AddDropdown('InputMode', {
		Text = 'Input mode', 
		Compact = true, 
		Default = 'virtual input', 
		Values = { 'virtual input', 'event fire' }, 
		Tooltip = 'Input method used to click for camera.\n* virtual input: emulates key presses.\n* event fire: fires the click event directly. use if "virtual input" does not work.', 
	})
	Groups.AutoFarm:AddSlider('ClickDelay',			{ Text = 'Click delay', Min = 0.000, Max = 1.000, Default = 0.000, Rounding = 3, Compact = true, Suffix = 's' })
	Groups.AutoFarm:AddSlider('VideoSDPercentage',		{ Text = 'Video SD Percentage', Min = 2.000, Max = 100.000, Default = 100.000, Suffix = '%', Rounding = 3, Compact = true })
	Groups.AutoFarm:AddSlider('SDPercentageToBuy',		{ Text = 'SD Percentage To Buy', Min = 0.000, Max = 100.000, Default = 10.000, Suffix = '%', Rounding = 3, Compact = true })
	Groups.AutoFarm:AddSlider('FloorToStop',			{ Text = 'Floor To Stop At', Min = 1, Max = 8, Default = 8, Rounding = 0, Compact = true, HideMax = true })

Groups.Misc = Tabs.Main:AddRightGroupbox('Misc')
	Groups.Misc:AddToggle('AutoOpenChests', { Text = 'Auto open chests' })
	Groups.Misc:AddToggle('AutoClick', { Text = 'Auto click' }):AddKeyPicker('AutoClickBind', { Default = 'Nine', NoUI = true, SyncToggleState = true })
	Groups.Misc:AddToggle('AutoPressE', { Text = 'Auto press E' }):AddKeyPicker('AutoPressBind', { Default = 'Zero', NoUI = true, SyncToggleState = true })

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
