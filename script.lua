-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "1234",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "X GUI HUB"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!")





--// RGB GUI + AIMBOT + ESP + WALL CHECK + TEAM CHECK

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local IMAGE_ID = "rbxassetid://90419183136038"

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThisAreNotCheat"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

--==================================================
-- MAIN GUI
--==================================================

local Main = Instance.new("ImageLabel")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.fromOffset(350, 260)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)

Main.BackgroundTransparency = 1
Main.Image = IMAGE_ID
Main.ScaleType = Enum.ScaleType.Stretch
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 4
MainStroke.Parent = Main

local MainScale = Instance.new("UIScale")
MainScale.Scale = 0.05
MainScale.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.fromOffset(15, 10)
Title.Font = Enum.Font.GothamBold
Title.Text = "X GUI AIMBOT++"
Title.TextSize = 18
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextStrokeTransparency = 0.4
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.BackgroundTransparency = 1
Subtitle.Size = UDim2.new(1, -30, 0, 20)
Subtitle.Position = UDim2.fromOffset(15, 38)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "HACK FEATURES"
Subtitle.TextSize = 11
Subtitle.TextColor3 = Color3.fromRGB(220, 220, 220)
Subtitle.Parent = Main

--==================================================
-- TOGGLE VARIABLES
--==================================================

local AimbotEnabled = false
local ESPEnabled = false
local WallCheckEnabled = false
local TeamCheckEnabled = false

--==================================================
-- TOGGLE CREATOR
--==================================================

local ToggleButtons = {}

local function CreateToggle(text, y)

	local button = Instance.new("TextButton")
	button.Name = text:gsub(" ", "")
	button.Size = UDim2.new(1, -40, 0, 36)
	button.Position = UDim2.fromOffset(20, y)

	button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	button.BackgroundTransparency = 0.15

	button.AutoButtonColor = false
	button.Text = text .. "  [ OFF ]"

	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.TextColor3 = Color3.new(1, 1, 1)

	button.Parent = Main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Parent = button

	ToggleButtons[text] = {
		Button = button,
		Stroke = stroke
	}

	return button
end

local AimButton = CreateToggle("Aimbot", 65)
local ESPButton = CreateToggle("ESP", 105)
local WallButton = CreateToggle("Wall Check", 145)
local TeamButton = CreateToggle("Team Check", 185)

--==================================================
-- TOGGLE VISUAL
--==================================================

local function UpdateToggle(button, enabled)

	if enabled then
		button.Text = button.Name == "WallCheck"
			and "Wall Check  [ ON ]"
			or button.Name == "TeamCheck"
			and "Team Check  [ ON ]"
			or button.Name .. "  [ ON ]"
	else
		button.Text = button.Name == "WallCheck"
			and "Wall Check  [ OFF ]"
			or button.Name == "TeamCheck"
			and "Team Check  [ OFF ]"
			or button.Name .. "  [ OFF ]"
	end

end

--==================================================
-- TEAM CHECK
--==================================================

local function IsEnemy(otherPlayer)

	if not otherPlayer then
		return false
	end

	if otherPlayer == player then
		return false
	end

	if TeamCheckEnabled then

		if player.Team ~= nil
			and otherPlayer.Team ~= nil
			and player.Team == otherPlayer.Team then

			return false

		end

	end

	return true
end

--==================================================
-- CHARACTER CHECK
--==================================================

local function GetCharacter(playerObject)

	if not playerObject then
		return nil
	end

	local character = playerObject.Character

	if not character then
		return nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or humanoid.Health <= 0 or not root then
		return nil
	end

	return character
end

--==================================================
-- WALL CHECK
--==================================================

local function CanSeeCharacter(character)

	if not character then
		return false
	end

	if not WallCheckEnabled then
		return true
	end

	local root = character:FindFirstChild("HumanoidRootPart")

	if not root then
		return false
	end

	local origin = camera.CFrame.Position
	local direction = root.Position - origin

	local params = RaycastParams.new()

	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		player.Character
	}

	params.IgnoreWater = true

	local result = workspace:Raycast(
		origin,
		direction,
		params
	)

	if not result then
		return true
	end

	return result.Instance:IsDescendantOf(character)
end

--==================================================
-- FIND TARGET
--==================================================

local function GetClosestTarget()

	local closestPlayer = nil
	local closestDistance = math.huge

	local viewportSize = camera.ViewportSize
	local screenCenter = Vector2.new(
		viewportSize.X / 2,
		viewportSize.Y / 2
	)

	for _, otherPlayer in ipairs(Players:GetPlayers()) do

		if IsEnemy(otherPlayer) then

			local character = GetCharacter(otherPlayer)

			if character and CanSeeCharacter(character) then

				local head = character:FindFirstChild("Head")
				local root = character:FindFirstChild("HumanoidRootPart")

				local targetPart = head or root

				if targetPart then

					local screenPosition, visible =
						camera:WorldToViewportPoint(targetPart.Position)

					if visible and screenPosition.Z > 0 then

						local distanceFromCenter =
							(Vector2.new(
								screenPosition.X,
								screenPosition.Y
							) - screenCenter).Magnitude

						if distanceFromCenter < closestDistance then

							closestDistance = distanceFromCenter
							closestPlayer = otherPlayer

						end

					end

				end

			end

		end

	end

	return closestPlayer
end

--==================================================
-- AIMBOT
--==================================================

RunService.RenderStepped:Connect(function()

	if not AimbotEnabled then
		return
	end

	local targetPlayer = GetClosestTarget()

	if not targetPlayer then
		return
	end

	local character = GetCharacter(targetPlayer)

	if not character then
		return
	end

	local targetPart =
		character:FindFirstChild("Head")
		or character:FindFirstChild("HumanoidRootPart")

	if not targetPart then
		return
	end

	local cameraPosition = camera.CFrame.Position

	local targetCFrame = CFrame.lookAt(
		cameraPosition,
		targetPart.Position
	)

	-- Langsung mengarah ke target
	camera.CFrame = targetCFrame

end)

--==================================================
-- ESP
--==================================================

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ThisGameESP"
ESPFolder.Parent = ScreenGui

local function RemoveESP(otherPlayer)

	local highlight = ESPFolder:FindFirstChild(
		"ESP_" .. otherPlayer.UserId
	)

	if highlight then
		highlight:Destroy()
	end

end

local function CreateESP(otherPlayer)

	if otherPlayer == player then
		return
	end

	local character = GetCharacter(otherPlayer)

	if not character then
		RemoveESP(otherPlayer)
		return
	end

	if not IsEnemy(otherPlayer) then
		RemoveESP(otherPlayer)
		return
	end

	if WallCheckEnabled and not CanSeeCharacter(character) then
		RemoveESP(otherPlayer)
		return
	end

	local name = "ESP_" .. otherPlayer.UserId

	local highlight = ESPFolder:FindFirstChild(name)

	if not highlight then

		highlight = Instance.new("Highlight")
		highlight.Name = name
		highlight.Adornee = character

		highlight.FillTransparency = 0.65
		highlight.OutlineTransparency = 0

		highlight.DepthMode = Enum.HighlightDepthMode.Occluded

		highlight.Parent = ESPFolder

	end

	highlight.Adornee = character

end

local function UpdateESP()

	for _, otherPlayer in ipairs(Players:GetPlayers()) do

		if ESPEnabled then
			CreateESP(otherPlayer)
		else
			RemoveESP(otherPlayer)
		end

	end

end

--==================================================
-- BUTTON EVENTS
--==================================================

AimButton.Activated:Connect(function()

	AimbotEnabled = not AimbotEnabled

	UpdateToggle(AimButton, AimbotEnabled)

end)

ESPButton.Activated:Connect(function()

	ESPEnabled = not ESPEnabled

	UpdateToggle(ESPButton, ESPEnabled)

	UpdateESP()

end)

WallButton.Activated:Connect(function()

	WallCheckEnabled = not WallCheckEnabled

	UpdateToggle(WallButton, WallCheckEnabled)

	UpdateESP()

end)

TeamButton.Activated:Connect(function()

	TeamCheckEnabled = not TeamCheckEnabled

	UpdateToggle(TeamButton, TeamCheckEnabled)

	UpdateESP()

end)

--==================================================
-- ESP UPDATE
--==================================================

task.spawn(function()

	while ScreenGui.Parent do

		if ESPEnabled then
			UpdateESP()
		end

		task.wait(0.15)

	end

end)

Players.PlayerRemoving:Connect(function(otherPlayer)

	RemoveESP(otherPlayer)

end)

--==================================================
-- RGB STROKE
--==================================================

local hue = 0

RunService.RenderStepped:Connect(function(dt)

	hue = (hue + dt * 0.18) % 1

	local rgb = Color3.fromHSV(
		hue,
		1,
		1
	)

	MainStroke.Color = rgb
	ButtonStroke.Color = rgb

	for _, data in pairs(ToggleButtons) do
		data.Stroke.Color = rgb
	end

end)

--==================================================
-- DRAG FUNCTION
--==================================================

local function MakeDraggable(object)

	local dragging = false
	local dragStart
	local startPosition

	local targetPosition = object.Position
	local currentPosition = object.Position

	object.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true

			dragStart = input.Position
			startPosition = object.Position

		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart

			targetPosition = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,

				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)

		end

	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false

		end

	end)

	RunService.RenderStepped:Connect(function(dt)

		if dragging then

			currentPosition = currentPosition:Lerp(
				targetPosition,
				math.clamp(dt * 22, 0, 1)
			)

			object.Position = currentPosition

		end

	end)

end

--==================================================
-- OPEN / CLOSE BUTTON
--==================================================

local OpenButton = Instance.new("ImageButton")

OpenButton.Name = "OpenCloseButton"

OpenButton.AnchorPoint = Vector2.new(0, 0.5)

OpenButton.Size = UDim2.fromOffset(58, 58)

OpenButton.Position = UDim2.new(
	0,
	18,
	0.5,
	0
)

OpenButton.BackgroundColor3 =
	Color3.fromRGB(0, 0, 0)

OpenButton.BackgroundTransparency = 0

OpenButton.Image = IMAGE_ID

OpenButton.ScaleType =
	Enum.ScaleType.Crop

OpenButton.AutoButtonColor = false
OpenButton.Active = true

OpenButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 14)
ButtonCorner.Parent = OpenButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Thickness = 4
ButtonStroke.Parent = OpenButton

local ButtonScale = Instance.new("UIScale")
ButtonScale.Scale = 1
ButtonScale.Parent = OpenButton

--==================================================
-- DRAG BOTH GUI ELEMENTS
--==================================================

MakeDraggable(Main)
MakeDraggable(OpenButton)

--==================================================
-- MAIN APPEAR ANIMATION
--==================================================

Main.ImageTransparency = 1

task.wait(0.15)

local appearScale = TweenService:Create(
	MainScale,

	TweenInfo.new(
		0.6,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	),

	{
		Scale = 1
	}
)

local appearFade = TweenService:Create(
	Main,

	TweenInfo.new(
		0.4,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	),

	{
		ImageTransparency = 0
	}
)

appearScale:Play()
appearFade:Play()

--==================================================
-- OPEN / CLOSE
--==================================================

local opened = true

local function OpenGUI()

	opened = true

	Main.Visible = true

	MainScale.Scale = 0.05
	Main.ImageTransparency = 1

	local scaleTween = TweenService:Create(
		MainScale,

		TweenInfo.new(
			0.55,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),

		{
			Scale = 1
		}
	)

	local fadeTween = TweenService:Create(
		Main,

		TweenInfo.new(
			0.35,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),

		{
			ImageTransparency = 0
		}
	)

	scaleTween:Play()
	fadeTween:Play()

end

local function CloseGUI()

	opened = false

	local scaleTween = TweenService:Create(
		MainScale,

		TweenInfo.new(
			0.3,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.In
		),

		{
			Scale = 0.05
		}
	)

	local fadeTween = TweenService:Create(
		Main,

		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),

		{
			ImageTransparency = 1
		}
	)

	scaleTween:Play()
	fadeTween:Play()

	scaleTween.Completed:Connect(function()

		if not opened then
			Main.Visible = false
		end

	end)

end

--==================================================
-- OPEN BUTTON
--==================================================

OpenButton.Activated:Connect(function()

	if opened then
		CloseGUI()
	else
		OpenGUI()
	end

end)

--==================================================
-- BUTTON PRESS ANIMATION
--==================================================

OpenButton.MouseButton1Down:Connect(function()

	local tween = TweenService:Create(
		ButtonScale,

		TweenInfo.new(
			0.1,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),

		{
			Scale = 0.82
		}
	)

	tween:Play()

end)

OpenButton.MouseButton1Up:Connect(function()

	local tween = TweenService:Create(
		ButtonScale,

		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),

		{
			Scale = 1
		}
	)

	tween:Play()

end)

--==================================================
-- BUTTON IDLE ANIMATION
--==================================================

task.spawn(function()

	while OpenButton.Parent do

		local grow = TweenService:Create(
			ButtonScale,

			TweenInfo.new(
				1,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),

			{
				Scale = 1.04
			}
		)

		grow:Play()
		grow.Completed:Wait()

		local shrink = TweenService:Create(
			ButtonScale,

			TweenInfo.new(
				1,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),

			{
				Scale = 1
			}
		)

		shrink:Play()
		shrink.Completed:Wait()

	end

end)

--==================================================
-- INITIAL STATE
--==================================================

UpdateToggle(AimButton, false)
UpdateToggle(ESPButton, false)
UpdateToggle(WallButton, false)
UpdateToggle(TeamButton, false)
