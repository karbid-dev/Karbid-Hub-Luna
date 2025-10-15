-- Wait for the game to load
repeat task.wait(1) until game:IsLoaded()

-- Services
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local LogService = game:GetService("LogService")
local TextService = game:GetService("TextService")
local VirtualUser = game:GetService("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local GameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local Players = game:GetService("Players")

-- Player and game info
local Plr = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId
local GuiParent = CoreGui
if gethui then
	GuiParent = gethui()
end

if GuiParent:FindFirstChild("KarbidConsole") then
	GuiParent:FindFirstChild("KarbidConsole"):Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KarbidConsole"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = -1
ScreenGui.Parent = GuiParent

-- Create main Frame (black cover)
local Frame = Instance.new("Frame")
Frame.Name = "BlackCover"
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0
Frame.Size = UDim2.fromScale(1, 1)
Frame.Position = UDim2.fromScale(0, 0)
Frame.ZIndex = 1
Frame.Visible = true
Frame.Parent = ScreenGui

-- Click blocker to prevent interactions
local ClickBlocker = Instance.new("TextButton")
ClickBlocker.Name = "ClickBlocker"
ClickBlocker.Text = ""
ClickBlocker.Size = UDim2.fromScale(1, 1)
ClickBlocker.Position = UDim2.fromScale(0, 0)
ClickBlocker.BackgroundTransparency = 1
ClickBlocker.BorderSizePixel = 0
ClickBlocker.ZIndex = 2
ClickBlocker.Visible = Frame.Visible
ClickBlocker.Parent = Frame
ClickBlocker.MouseButton1Click:Connect(function() end)

-- Show/Hide button
local ShowHide = Instance.new("ImageButton")
ShowHide.Name = "ShowHideButton"
ShowHide.Size = UDim2.new(0, 30, 0, 30)
ShowHide.Position = UDim2.new(0, 5, 1, -5)
ShowHide.AnchorPoint = Vector2.new(0, 1)
ShowHide.BackgroundTransparency = 1
ShowHide.Image = "rbxassetid://89692386948022"
ShowHide.HoverImage = "rbxassetid://128566822005111"
ShowHide.ZIndex = 3
ShowHide.Parent = ScreenGui

-- Rejoin button
local RejoinButton = Instance.new("ImageButton")
RejoinButton.Name = "RejoinButton"
RejoinButton.Size = UDim2.new(0, 30, 0, 30)
RejoinButton.Position = UDim2.new(0, 40, 1, -5)
RejoinButton.AnchorPoint = Vector2.new(0, 1)
RejoinButton.BackgroundTransparency = 1
RejoinButton.Image = "rbxassetid://71400177604484"
RejoinButton.HoverImage = "rbxassetid://112459852629690"
RejoinButton.ZIndex = 3
RejoinButton.Parent = ScreenGui

-- Shutdown button
local ShutdownButton = Instance.new("ImageButton")
ShutdownButton.Name = "ShutdownButton"
ShutdownButton.Size = UDim2.new(0, 30, 0, 30)
ShutdownButton.Position = UDim2.new(0, 75, 1, -5)
ShutdownButton.AnchorPoint = Vector2.new(0, 1)
ShutdownButton.BackgroundTransparency = 1
ShutdownButton.Image = "rbxassetid://88584538441815"
ShutdownButton.HoverImage = "rbxassetid://127744286728142"
ShutdownButton.ZIndex = 3
ShutdownButton.Parent = ScreenGui

-- Game name label at the top
local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Name = "GameNameLabel"
GameNameLabel.Size = UDim2.new(1, 0, 0, 20)
GameNameLabel.Position = UDim2.new(0, 7, 0, 0)
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.TextColor3 = Color3.fromRGB(63, 195, 128)
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.TextYAlignment = Enum.TextYAlignment.Top
GameNameLabel.TextWrapped = false
GameNameLabel.TextSize = 16
GameNameLabel.Font = Enum.Font.SourceSansBold
GameNameLabel.RichText = false
GameNameLabel.ZIndex = 5
GameNameLabel.Text = "Game : "..GameName
GameNameLabel.Parent = Frame

-- Console scrolling frame
local ConsoleFrame = Instance.new("ScrollingFrame")
ConsoleFrame.Name = "ConsoleFrame"
ConsoleFrame.Size = UDim2.new(1, 0, 1, -20)
ConsoleFrame.Position = UDim2.new(0, 0, 0, 20)
ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleFrame.ScrollBarThickness = 8
ConsoleFrame.BackgroundTransparency = 1
ConsoleFrame.ZIndex = 5
ConsoleFrame.Parent = Frame

-- Text label for console output
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "ConsoleText"
TextLabel.Size = UDim2.new(1, -10, 0, 0)
TextLabel.Position = UDim2.new(0, 5, 0, 5)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Top
TextLabel.TextWrapped = true
TextLabel.TextSize = 14
TextLabel.Font = Enum.Font.Code
TextLabel.RichText = true
TextLabel.ZIndex = 5
TextLabel.Text = ""
TextLabel.Parent = ConsoleFrame

-- Function to toggle frame visibility
local function toggleVisibility()
	Frame.Visible = not Frame.Visible
	ClickBlocker.Visible = Frame.Visible
end

-- Function to rejoin the game
local function rejoinGame()
	warn("Rejoining...")
	local success, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Plr)
	end)
	if not success then
		TeleportService:Teleport(PlaceId)
	end
end

-- Function to shutdown the game
local function shutdownGame()
	game:Shutdown()
end

-- Function to format log messages
local function formatMessage(msg, msgType)
	local time = os.date("%H:%M:%S")
	local prefix = ""
	local color = "#FFFFFF" -- Default color
	if msgType == Enum.MessageType.MessageOutput then
		prefix = "[📢] " 
		color = "#B0C4DE"
	elseif msgType == Enum.MessageType.MessageWarning then
		prefix = "[⚠️] "
		color = "#FFD966"
	elseif msgType == Enum.MessageType.MessageError then
		prefix = "[🚨] "
		color = "#FF6666"
	end
	local fullMsg = string.format("[%s] %s%s", time, prefix, msg)
	return string.format("<font color='%s'>%s</font>", color, fullMsg)
end

-- Connect button events
ShowHide.MouseButton1Click:Connect(toggleVisibility)
RejoinButton.MouseButton1Click:Connect(rejoinGame)
ShutdownButton.MouseButton1Click:Connect(shutdownGame)

-- Connect log service to update console
LogService.MessageOut:Connect(function(msg, msgType)
	local formatted = formatMessage(msg, msgType)
	TextLabel.Text = formatted .. "\n" .. TextLabel.Text

	local textSize = TextService:GetTextSize(
		TextLabel.Text,
		TextLabel.TextSize,
		TextLabel.Font,
		Vector2.new(ConsoleFrame.AbsoluteSize.X - 10, math.huge)
	)
	TextLabel.Size = UDim2.new(1, -10, 0, textSize.Y)
	ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 10)
	ConsoleFrame.CanvasPosition = Vector2.new(0, 0)
end)

-- Anti-AFK functionality
_G.ConsoleAntiAFK = true
task.spawn(function()
	while _G.ConsoleAntiAFK do
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
		task.wait(60)
	end
end)

-- Set FPS cap if available
if setfpscap then
	setfpscap(180)
end

-- Cleanup
if _G.ConsoleAntiAFK then
	_G.ConsoleAntiAFK = false
	task.wait(0.1)
end

if _G.ConsoleLogConnection then
	_G.ConsoleLogConnection:Disconnect()
	_G.ConsoleLogConnection = nil
end
