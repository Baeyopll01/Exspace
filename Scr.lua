Library = {}
SaveTheme = {}

local themes = {
	index = {"Dark", "Light"},
	Dark = {
		['Background'] = Color3.fromRGB(13, 13, 13),
		['Main'] = Color3.fromRGB(0, 0, 0),
		['Tab'] = Color3.fromRGB(15, 15, 15),
		['Title'] = Color3.fromRGB(255, 255, 255),
		['Icon'] = Color3.fromRGB(255, 255, 255),
		['Back'] = Color3.fromRGB(44, 46, 46),
		['Function'] = Color3.fromRGB(15, 15, 15),
		['Main Color'] = Color3.fromRGB(0, 104, 255),
		['UIStroke'] = Color3.fromRGB(255, 255, 255),
		['Background Dialog'] = Color3.fromRGB(44, 44, 44)
	},
	Light = {
		['Background'] = Color3.fromRGB(241, 241, 241),
		['Main'] = Color3.fromRGB(255, 255, 255),
		['Tab'] = Color3.fromRGB(241, 241, 241),
		['Title'] = Color3.fromRGB(0, 0, 0),
		['Icon'] = Color3.fromRGB(0, 0, 0),
		['Back'] = Color3.fromRGB(217, 217, 217),
		['Function'] = Color3.fromRGB(241, 241, 241),
		['Main Color'] = Color3.fromRGB(0, 104, 255),
		['UIStroke'] = Color3.fromRGB(0, 0, 0),
		['Background Dialog'] = Color3.fromRGB(0, 0, 0)
	}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = not game:GetService("RunService"):IsStudio() and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function addToTheme(name, obj)
	if not SaveTheme[name] then
		SaveTheme[name] = {}
	end
	table.insert(SaveTheme[name], obj)
end

function Library:setTheme(st)
	local function tw(info)
		return game:GetService("TweenService"):Create(info.v, TweenInfo.new(info.t, info.s, Enum.EasingDirection[info.d]), info.g)
	end

	for name, color in pairs(st) do
		if SaveTheme[name] then
			for _, obj in pairs(SaveTheme[name]) do
				if obj:IsA("Frame") or obj:IsA("CanvasGroup") then
					tw({v = obj, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {BackgroundColor3 = color}}):Play()
				elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
					tw({v = obj, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {TextColor3 = color}}):Play()
				elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					tw({v = obj, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {ImageColor3 = color}}):Play()
				elseif obj:IsA("ScrollingFrame") then
					tw({v = obj, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {ScrollBarImageColor3 = color}}):Play()
				elseif obj:IsA("UIStroke") then
					tw({v = obj, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {Color = color}}):Play()
				end
			end
		end
	end
end

function Library:GenerateWindow(option)
	local options = {
		Name = option.Name or 'Frosinsa',
		Theme = option.Theme or 'Light',
		Keybind = option.Keybind or Enum.KeyCode.LeftControl
	}
	local U, Tw =
		game:GetService("UserInputService"),
		game:GetService("TweenService")
	local R, HAA = false, false
	local HasChangeTheme = options.Theme
	local IsTheme = options.Theme
	
	local function gl(i)
		if type(i) == 'string' and not i:find('rbxassetid://') then
			return "rbxassetid://".. i
		elseif type(i) == 'number' then
			return "rbxassetid://".. i
		else
			return i
		end
	end
	local function tw(info)
		return Tw:Create(info.v,TweenInfo.new(info.t, info.s, Enum.EasingDirection[info.d]),info.g)
	end
	local function changecanvas(ScrollingFrame, UIListLayout, Plus)
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tw({v = ScrollingFrame, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + Plus or 5)}}):Play()
		end)
	end
	local function gs(side, pl, pr)
		if not side then
			return pl
		end

		local sideLower = string.lower(tostring(side))
		if sideLower == "r" or sideLower == "right" or side == 2 then
			return pr
		elseif sideLower == "l" or sideLower == "left" or side == 1 then
			return pl
		else
			return pl
		end
	end
	local function jc(c, p)
		local Mouse = game.Players.LocalPlayer:GetMouse()

		local relativeX = Mouse.X - c.AbsolutePosition.X
		local relativeY = Mouse.Y - c.AbsolutePosition.Y

		if relativeX < 0 or relativeY < 0 or relativeX > c.AbsoluteSize.X or relativeY > c.AbsoluteSize.Y then
			return
		end

		local ClickButtonCircle = Instance.new("Frame")
		ClickButtonCircle.Parent = p
		ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ClickButtonCircle.BackgroundTransparency = 0.7
		ClickButtonCircle.BorderSizePixel = 0
		ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		ClickButtonCircle.Position = UDim2.new(0, relativeX, 0, relativeY)
		ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
		ClickButtonCircle.ZIndex = 10

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = ClickButtonCircle

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local goal = {
			Size = UDim2.new(0, c.AbsoluteSize.X * 1.5, 0, c.AbsoluteSize.X * 1.5),
			BackgroundTransparency = 1
		}

		local expandTween = game:GetService("TweenService"):Create(ClickButtonCircle, tweenInfo, goal)

		expandTween.Completed:Connect(function()
			ClickButtonCircle:Destroy()
		end)

		expandTween:Play()
	end
	local function jcf(p, p2)
		local ClickButtonCircle = Instance.new("Frame")
		ClickButtonCircle.Parent = p
		ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ClickButtonCircle.BackgroundTransparency = 0.7
		ClickButtonCircle.BorderSizePixel = 0
		ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		ClickButtonCircle.Position = UDim2.new(0, p2.AbsolutePosition.X - p.AbsolutePosition.X + p2.AbsoluteSize.X / 2, 
			0, p2.AbsolutePosition.Y - p.AbsolutePosition.Y + p2.AbsoluteSize.Y / 2)
		ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
		ClickButtonCircle.ZIndex = 10

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = ClickButtonCircle

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local goal = {
			Size = UDim2.new(0, p2.AbsoluteSize.X * 5, 0, p2.AbsoluteSize.X * 5),
			BackgroundTransparency = 1
		}

		local expandTween = game:GetService("TweenService"):Create(ClickButtonCircle, tweenInfo, goal)

		expandTween.Completed:Connect(function()
			ClickButtonCircle:Destroy()
		end)

		expandTween:Play()
	end
	local function lak(o)
		local a, b, c, d
		local function u(i)
			local dt = i.Position - c
			tw({v = o, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {Position = UDim2.new(d.X.Scale, d.X.Offset + dt.X, d.Y.Scale, d.Y.Offset + dt.Y)}}):Play()
		end
		o.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then a = true c = i.Position d = o.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then a = false end end) end end)
		o.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then b = i end end)
		U.InputChanged:Connect(function(i) if i == b and a then u(i) end end)
	end
	local function lak2(t, o)
		local a, b, c, d
		local function u(i)
			local dt = i.Position - c
			tw({v = o, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {Position = UDim2.new(d.X.Scale, d.X.Offset + dt.X, d.Y.Scale, d.Y.Offset + dt.Y)}}):Play()
		end
		t.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then a = true c = i.Position d = o.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then a = false end end) end end)
		t.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then b = i end end)
		U.InputChanged:Connect(function(i) if i == b and a then u(i) end end)
	end
	local function click(p)
		local Click = Instance.new("TextButton")

		Click.Name = "Click"
		Click.Parent = p
		Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Click.BackgroundTransparency = 1.000
		Click.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Click.BorderSizePixel = 0
		Click.Size = UDim2.new(1, 0, 1, 0)
		Click.Font = Enum.Font.SourceSans
		Click.Text = ""
		Click.TextColor3 = Color3.fromRGB(0, 0, 0)
		Click.TextSize = 14.000
		
		return Click
	end
	local function background(p, t, d)
		local Toggle = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local TitleList_1 = Instance.new("Frame")
		local UIPadding_1 = Instance.new("UIPadding")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local Title_1 = Instance.new("TextLabel")

		Toggle.Name = "Toggle"
		Toggle.Parent = p
		Toggle.BackgroundColor3 = Color3.fromRGB(241,241,241)
		Toggle.BorderColor3 = Color3.fromRGB(0,0,0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(1, 0,0, 30)
		
		addToTheme('Function', Toggle)

		UICorner_1.Parent = Toggle

		TitleList_1.Name = "TitleList"
		TitleList_1.Parent = Toggle
		TitleList_1.AnchorPoint = Vector2.new(0, 0.5)
		TitleList_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TitleList_1.BackgroundTransparency = 1
		TitleList_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TitleList_1.BorderSizePixel = 0
		TitleList_1.Position = UDim2.new(0, 0,0.5, 0)
		TitleList_1.Size = UDim2.new(1, 0,0.800000012, 0)

		UIPadding_1.Parent = TitleList_1
		UIPadding_1.PaddingLeft = UDim.new(0,8)
		UIPadding_1.PaddingRight = UDim.new(0,50)

		UIListLayout_1.Parent = TitleList_1
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		Title_1.Name = "Title"
		Title_1.Parent = TitleList_1
		Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Title_1.BackgroundTransparency = 1
		Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Title_1.BorderSizePixel = 0
		Title_1.Size = UDim2.new(1, 0,0, 14)
		Title_1.Font = Enum.Font.GothamBold
		Title_1.RichText = true
		Title_1.Text = t
		Title_1.TextSize = 10
		Title_1.TextWrapped = true
		Title_1.TextXAlignment = Enum.TextXAlignment.Left
		Title_1.AutomaticSize = Enum.AutomaticSize.Y
		
		addToTheme('Title', Title_1)
		
		local Desc_1 = Instance.new("TextLabel")

		Desc_1.Name = "Desc"
		Desc_1.Parent = TitleList_1
		Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Desc_1.BackgroundTransparency = 1
		Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Desc_1.BorderSizePixel = 0
		Desc_1.LayoutOrder = 1
		Desc_1.Size = UDim2.new(1, 0,0, 14)
		Desc_1.Font = Enum.Font.GothamBold
		Desc_1.RichText = true
		Desc_1.Text = d
		Desc_1.TextSize = 9
		Desc_1.TextTransparency = 0.7
		Desc_1.TextWrapped = true
		Desc_1.TextXAlignment = Enum.TextXAlignment.Left
		Desc_1.TextYAlignment = Enum.TextYAlignment.Top
		Desc_1.AutomaticSize = Enum.AutomaticSize.Y
		Desc_1.Visible = false

		addToTheme('Title', Desc_1)
		
		if d and d ~= "" then
			Desc_1.Visible = true
			local function updateSize()
				task.defer(function()
					local newSize = UIListLayout_1.AbsoluteContentSize.Y + 15
					if Toggle.Size.Y.Offset ~= newSize then
						Toggle.Size = UDim2.new(1, 0, 0, newSize)
					end
				end)
			end

			UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

			updateSize()
		end
		
		return Toggle
	end
	
	local BackGround_1 = Instance.new("CanvasGroup")
	local UICorner_1 = Instance.new("UICorner")
	local Size_1 = Instance.new("TextButton")
	
	BackGround_1.Name = "BackGround"
	BackGround_1.Parent = ScreenGui
	BackGround_1.Active = true
	BackGround_1.AnchorPoint = Vector2.new(0.5, 0.5)
	BackGround_1.BackgroundColor3 = Color3.fromRGB(241,241,241)
	BackGround_1.BorderColor3 = Color3.fromRGB(0,0,0)
	BackGround_1.BorderSizePixel = 0
	BackGround_1.Position = UDim2.new(0.5, 0,0.5, 0)
	BackGround_1.Size = UDim2.new(0, 500,0, 350)
	BackGround_1.ClipsDescendants = true
	
	addToTheme('Background', BackGround_1)
	
	UICorner_1.Parent = BackGround_1

	Size_1.Name = "Size"
	Size_1.Parent = BackGround_1
	Size_1.Active = true
	Size_1.AnchorPoint = Vector2.new(1, 1)
	Size_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Size_1.BackgroundTransparency = 1
	Size_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Size_1.BorderSizePixel = 0
	Size_1.Position = UDim2.new(1, 0,1, 0)
	Size_1.Size = UDim2.new(0, 20,0, 20)
	Size_1.Font = Enum.Font.SourceSans
	Size_1.Text = ""
	Size_1.TextSize = 14
	
	local informationlist_1 = Instance.new("Frame")
	local Hub_1 = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local HubText_1 = Instance.new("TextLabel")
	local UIListLayout_3 = Instance.new("UIListLayout")
	local UIPadding_2 = Instance.new("UIPadding")
	
	UIListLayout_3.Parent = informationlist_1
	UIListLayout_3.Padding = UDim.new(0,8)
	UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

	UIPadding_2.Parent = informationlist_1
	UIPadding_2.PaddingLeft = UDim.new(0,110)
	UIPadding_2.PaddingTop = UDim.new(0,15)
	
	informationlist_1.Name = "informationlist"
	informationlist_1.Parent = BackGround_1
	informationlist_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	informationlist_1.BackgroundTransparency = 1
	informationlist_1.BorderColor3 = Color3.fromRGB(0,0,0)
	informationlist_1.BorderSizePixel = 0
	informationlist_1.Size = UDim2.new(1, 0,1, 0)

	Hub_1.Name = "Hub"
	Hub_1.Parent = informationlist_1
	Hub_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Hub_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Hub_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Hub_1.BorderSizePixel = 0
	Hub_1.Position = UDim2.new(0.157000005, 0,0.5, 0)
	Hub_1.Size = UDim2.new(0, 100,0, 40)
	
	addToTheme('Main', Hub_1)

	UICorner_4.Parent = Hub_1

	UIStroke_2.Parent = Hub_1
	UIStroke_2.Thickness = 1
	UIStroke_2.Transparency = 0.95
	
	addToTheme('UIStroke', UIStroke_2)

	HubText_1.Name = "HubText"
	HubText_1.Parent = Hub_1
	HubText_1.AnchorPoint = Vector2.new(0.5, 0.5)
	HubText_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	HubText_1.BackgroundTransparency = 1
	HubText_1.BorderColor3 = Color3.fromRGB(0,0,0)
	HubText_1.BorderSizePixel = 0
	HubText_1.Position = UDim2.new(0.5, 0,0.5, 0)
	HubText_1.Size = UDim2.new(0.800000012, 0,0.800000012, 0)
	HubText_1.Font = Enum.Font.GothamBold
	HubText_1.RichText = true
	HubText_1.Text = options.Name
	HubText_1.TextSize = 12
	HubText_1.TextWrapped = true
	
	addToTheme('Title', HubText_1)
	
	local information_1 = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local UIStroke_3 = Instance.new("UIStroke")
	local List_1 = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local PatinumText_1 = Instance.new("TextLabel")
	local Line_1 = Instance.new("Frame")
	local ProfileImage_1 = Instance.new("ImageLabel")
	local NameText_1 = Instance.new("TextLabel")
	local Line2_1 = Instance.new("Frame")
	local Clock_1 = Instance.new("ImageLabel")
	local Time_1 = Instance.new("TextLabel")
	
	information_1.Name = "information"
	information_1.Parent = informationlist_1
	information_1.AnchorPoint = Vector2.new(0.5, 0.5)
	information_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	information_1.BorderColor3 = Color3.fromRGB(0,0,0)
	information_1.BorderSizePixel = 0
	information_1.LayoutOrder = 1
	information_1.Position = UDim2.new(2.2349999, 0,0.5, 0)
	information_1.Size = UDim2.new(0, 225,0, 40)
	
	addToTheme('Main', information_1)

	UICorner_5.Parent = information_1

	UIStroke_3.Parent = information_1
	UIStroke_3.Thickness = 1
	UIStroke_3.Transparency = 0.95
	
	addToTheme('UIStroke', UIStroke_3)

	List_1.Name = "List"
	List_1.Parent = information_1
	List_1.AnchorPoint = Vector2.new(0.5, 0.5)
	List_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	List_1.BackgroundTransparency = 1
	List_1.BorderColor3 = Color3.fromRGB(0,0,0)
	List_1.BorderSizePixel = 0
	List_1.Position = UDim2.new(0.5, 0,0.5, 0)
	List_1.Size = UDim2.new(0.899999976, 0,0.800000012, 0)

	UIListLayout_2.Parent = List_1
	UIListLayout_2.Padding = UDim.new(0,5)
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

	PatinumText_1.Name = "PatinumText"
	PatinumText_1.Parent = List_1
	PatinumText_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	PatinumText_1.BackgroundTransparency = 1
	PatinumText_1.BorderColor3 = Color3.fromRGB(0,0,0)
	PatinumText_1.BorderSizePixel = 0
	PatinumText_1.Size = UDim2.new(0, 50,1, 0)
	PatinumText_1.Font = Enum.Font.GothamBold
	PatinumText_1.Text = "Platinum"
	PatinumText_1.TextSize = 11
	
	addToTheme('Title', PatinumText_1)

	Line_1.Name = "Line"
	Line_1.Parent = List_1
	Line_1.BackgroundColor3 = Color3.fromRGB(136,136,136)
	Line_1.BackgroundTransparency = 0.6
	Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Line_1.BorderSizePixel = 0
	Line_1.LayoutOrder = 1
	Line_1.Size = UDim2.new(0, 1,0.5, 0)

	ProfileImage_1.Name = "ProfileImage"
	ProfileImage_1.Parent = List_1
	ProfileImage_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ProfileImage_1.BackgroundTransparency = 1
	ProfileImage_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ProfileImage_1.BorderSizePixel = 0
	ProfileImage_1.LayoutOrder = 2
	ProfileImage_1.Size = UDim2.new(0, 15,0, 15)
	ProfileImage_1.Image = "rbxassetid://2790547157"
	ProfileImage_1.ImageColor3 = Color3.fromRGB(117, 117, 117)
	
	NameText_1.Name = "NameText"
	NameText_1.Parent = List_1
	NameText_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	NameText_1.BackgroundTransparency = 1
	NameText_1.BorderColor3 = Color3.fromRGB(0,0,0)
	NameText_1.BorderSizePixel = 0
	NameText_1.LayoutOrder = 3
	NameText_1.Position = UDim2.new(0.410958916, 0,0, 0)
	NameText_1.Size = UDim2.new(-0, 50,1, 0)
	NameText_1.Font = Enum.Font.GothamBold
	NameText_1.Text = game.Players.LocalPlayer.Name
	NameText_1.TextSize = 9
	NameText_1.TextTransparency = 0.4000000059604645
	NameText_1.TextXAlignment = Enum.TextXAlignment.Left
	NameText_1.TextTruncate = Enum.TextTruncate.AtEnd
	
	addToTheme('Title', NameText_1)

	Line2_1.Name = "Line2"
	Line2_1.Parent = List_1
	Line2_1.BackgroundColor3 = Color3.fromRGB(136,136,136)
	Line2_1.BackgroundTransparency = 0.6
	Line2_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Line2_1.BorderSizePixel = 0
	Line2_1.LayoutOrder = 4
	Line2_1.Size = UDim2.new(0, 1,0.5, 0)

	Clock_1.Name = "Clock"
	Clock_1.Parent = List_1
	Clock_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Clock_1.BackgroundTransparency = 1
	Clock_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Clock_1.BorderSizePixel = 0
	Clock_1.LayoutOrder = 5
	Clock_1.Size = UDim2.new(0, 15,0, 15)
	Clock_1.Image = "rbxassetid://13858985128"
	Clock_1.ImageColor3 = Color3.fromRGB(117, 117, 117)

	Time_1.Name = "Time"
	Time_1.Parent = List_1
	Time_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Time_1.BackgroundTransparency = 1
	Time_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Time_1.BorderSizePixel = 0
	Time_1.LayoutOrder = 6
	Time_1.Position = UDim2.new(0.410958916, 0,0, 0)
	Time_1.Size = UDim2.new(-0, 50,1, 0)
	Time_1.Font = Enum.Font.GothamBold
	Time_1.Text = "00:00:00"
	Time_1.TextSize = 9
	Time_1.TextTransparency = 0.4000000059604645
	Time_1.TextWrapped = true
	Time_1.TextXAlignment = Enum.TextXAlignment.Left
	
	addToTheme('Title', Time_1)
	
	task.spawn(function()
		while task.wait(1) do
			Time_1.Text = string.format("%02d:%02d:%02d", math.floor(workspace.DistributedGameTime / 3600), math.floor(workspace.DistributedGameTime / 60 % 60), math.floor(workspace.DistributedGameTime % 60))
		end
	end)
	
	local Theme_1 = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local UIStroke_4 = Instance.new("UIStroke")
	local ThemeIcon_1 = Instance.new("ImageLabel")
	local ThemeClick_1 = Instance.new("TextButton")
	
	Theme_1.Name = "Theme"
	Theme_1.Parent = informationlist_1
	Theme_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Theme_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Theme_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Theme_1.BorderSizePixel = 0
	Theme_1.LayoutOrder = 2
	Theme_1.Position = UDim2.new(0.157000005, 0,0.5, 0)
	Theme_1.Size = UDim2.new(0, 40,0, 40)
	
	addToTheme('Main', Theme_1)

	UICorner_6.Parent = Theme_1

	UIStroke_4.Parent = Theme_1
	UIStroke_4.Thickness = 1
	UIStroke_4.Transparency = 0.95

	ThemeIcon_1.Name = "ThemeIcon"
	ThemeIcon_1.Parent = Theme_1
	ThemeIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
	ThemeIcon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ThemeIcon_1.BackgroundTransparency = 1
	ThemeIcon_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ThemeIcon_1.BorderSizePixel = 0
	ThemeIcon_1.Position = UDim2.new(0.5, 0,0.5, 0)
	ThemeIcon_1.Size = UDim2.new(0.5, 0,0.5, 0)
	ThemeIcon_1.Image = "rbxassetid://14914742090"
	ThemeIcon_1.ImageColor3 = Color3.fromRGB(117, 117, 117)

	ThemeClick_1.Name = "ThemeClick"
	ThemeClick_1.Parent = Theme_1
	ThemeClick_1.Active = true
	ThemeClick_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ThemeClick_1.BackgroundTransparency = 1
	ThemeClick_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ThemeClick_1.BorderSizePixel = 0
	ThemeClick_1.Size = UDim2.new(1, 0,1, 0)
	ThemeClick_1.Font = Enum.Font.SourceSans
	ThemeClick_1.Text = ""
	ThemeClick_1.TextSize = 14
	
	local TabList_1 = Instance.new("Frame")
	local UIStroke_1 = Instance.new("UIStroke")
	local ScrollingFrame_1 = Instance.new("ScrollingFrame")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local UIPadding_1 = Instance.new("UIPadding")
	
	TabList_1.Name = "TabList"
	TabList_1.Parent = BackGround_1
	TabList_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TabList_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TabList_1.BorderSizePixel = 0
	TabList_1.Size = UDim2.new(0, 100,1, 0)
	
	addToTheme('Main', TabList_1)

	UIStroke_1.Parent = TabList_1
	UIStroke_1.Thickness = 1
	UIStroke_1.Transparency = 0.95
	
	addToTheme('UIStroke', UIStroke_1)

	ScrollingFrame_1.Name = "ScrollingFrame"
	ScrollingFrame_1.Parent = TabList_1
	ScrollingFrame_1.Active = true
	ScrollingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ScrollingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ScrollingFrame_1.BorderSizePixel = 0
	ScrollingFrame_1.Size = UDim2.new(1, 0,1, 0)
	ScrollingFrame_1.ClipsDescendants = true
	ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.None
	ScrollingFrame_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
	ScrollingFrame_1.CanvasPosition = Vector2.new(0, 0)
	ScrollingFrame_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	ScrollingFrame_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	ScrollingFrame_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ScrollingFrame_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
	ScrollingFrame_1.ScrollBarImageTransparency = 0
	ScrollingFrame_1.ScrollBarThickness = 0
	ScrollingFrame_1.ScrollingDirection = Enum.ScrollingDirection.XY
	ScrollingFrame_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
	ScrollingFrame_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ScrollingFrame_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	ScrollingFrame_1.BackgroundTransparency = 1

	UIListLayout_1.Parent = ScrollingFrame_1
	UIListLayout_1.Padding = UDim.new(0,8)
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	
	changecanvas(ScrollingFrame_1, UIListLayout_1, 5)
	
	UIPadding_1.Parent = TabList_1
	UIPadding_1.PaddingBottom = UDim.new(0,35)
	UIPadding_1.PaddingTop = UDim.new(0,35)
	
	local FramePage_1 = Instance.new("Frame")
	
	FramePage_1.Name = "FramePage"
	FramePage_1.Parent = BackGround_1
	FramePage_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	FramePage_1.BackgroundTransparency = 1
	FramePage_1.BorderColor3 = Color3.fromRGB(0,0,0)
	FramePage_1.BorderSizePixel = 0
	FramePage_1.Size = UDim2.new(1, 0,1, 0)
	
	Library.Tabs = {
		Value = false
	}
	
	function Library.Tabs:CreateTab(option)
		local options = {
			Title = option.Title or 'Tab',
			Icon = option.Icon
		}
		local Tab_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Title_1 = Instance.new("TextLabel")
		local Icon_1 = Instance.new("ImageLabel")
		local GlowDot_1 = Instance.new("ImageLabel")
		local Dot_1 = Instance.new("ImageLabel")
		local Dot_2 = Instance.new("ImageLabel")
		
		Tab_1.Name = "Tab"
		Tab_1.Parent = ScrollingFrame_1
		Tab_1.BackgroundColor3 = Color3.fromRGB(241,241,241)
		Tab_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Tab_1.BorderSizePixel = 0
		Tab_1.Size = UDim2.new(0, 70,0, 50)
		
		addToTheme('Tab', Tab_1)

		UICorner_2.Parent = Tab_1
		UICorner_2.CornerRadius = UDim.new(0,11)

		Title_1.Name = "Title"
		Title_1.Parent = Tab_1
		Title_1.AnchorPoint = Vector2.new(0, 1)
		Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Title_1.BackgroundTransparency = 1
		Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Title_1.BorderSizePixel = 0
		Title_1.Position = UDim2.new(0, 0,0.899999976, 0)
		Title_1.Size = UDim2.new(1, 0,0.300000012, 0)
		Title_1.Font = Enum.Font.GothamBold
		Title_1.Text = tostring(options.Title)
		Title_1.TextSize = 10
		Title_1.TextYAlignment = Enum.TextYAlignment.Top
		Title_1.TextTransparency = 0.7
		
		addToTheme('Title', Title_1)

		Icon_1.Name = "Icon"
		Icon_1.Parent = Tab_1
		Icon_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Icon_1.BackgroundTransparency = 1
		Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Icon_1.BorderSizePixel = 0
		Icon_1.Position = UDim2.new(0.5, 0,0.349999994, 0)
		Icon_1.Size = UDim2.new(0, 20,0, 20)
		Icon_1.Image = gl(options.Icon)
		Icon_1.ImageColor3 = Color3.fromRGB(0,0,0)
		Icon_1.ImageTransparency = 0.7
		
		addToTheme('Icon', Icon_1)

		GlowDot_1.Name = "GlowDot"
		GlowDot_1.Parent = Tab_1
		GlowDot_1.AnchorPoint = Vector2.new(1, 0)
		GlowDot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		GlowDot_1.BackgroundTransparency = 1
		GlowDot_1.BorderColor3 = Color3.fromRGB(0,0,0)
		GlowDot_1.BorderSizePixel = 0
		GlowDot_1.Position = UDim2.new(0.970000029, 0,0.0299999993, 0)
		GlowDot_1.Size = UDim2.new(0, 18,0, 18)
		GlowDot_1.Image = "rbxassetid://105506802034513"
		GlowDot_1.ImageColor3 = Color3.fromRGB(0,104,255)
		GlowDot_1.ImageTransparency = 1
		
		addToTheme('Main Color', GlowDot_1)

		Dot_1.Name = "Dot"
		Dot_1.Parent = GlowDot_1
		Dot_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Dot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Dot_1.BackgroundTransparency = 1
		Dot_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Dot_1.BorderSizePixel = 0
		Dot_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Dot_1.Size = UDim2.new(0, 11,0, 11)
		Dot_1.Image = "rbxassetid://82506792944073"
		Dot_1.ImageColor3 = Color3.fromRGB(217,217,217)
		Dot_1.ImageTransparency = 0
		
		addToTheme('Back', Dot_1)

		Dot_2.Name = "Dot"
		Dot_2.Parent = Dot_1
		Dot_2.AnchorPoint = Vector2.new(0.5, 0.5)
		Dot_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Dot_2.BackgroundTransparency = 1
		Dot_2.BorderColor3 = Color3.fromRGB(0,0,0)
		Dot_2.BorderSizePixel = 0
		Dot_2.Position = UDim2.new(0.5, 0,0.5, 0)
		Dot_2.Size = UDim2.new(0, 10,0, 10)
		Dot_2.Image = "rbxassetid://105506802034513"
		Dot_2.ImageColor3 = Color3.fromRGB(0,104,255)
		Dot_2.ImageTransparency = 1
		
		addToTheme('Main Color', Dot_2)
		
		local Page_1 = Instance.new("Frame")
		local PageIn_1 = Instance.new("Frame")
		local UIPadding_7 = Instance.new("UIPadding")
		local UIStroke_5 = Instance.new("UIStroke")
		local UICorner_9 = Instance.new("UICorner")

		Page_1.Name = "Page"
		Page_1.Parent = FramePage_1
		Page_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Page_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Page_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Page_1.BorderSizePixel = 0
		Page_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Page_1.Size = UDim2.new(1, 0,1, 0)
		Page_1.Visible = false
		
		addToTheme('Main', Page_1)

		PageIn_1.Name = "PageIn"
		PageIn_1.Parent = Page_1
		PageIn_1.AnchorPoint = Vector2.new(0.5, 0.5)
		PageIn_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		PageIn_1.BackgroundTransparency = 1
		PageIn_1.BorderColor3 = Color3.fromRGB(0,0,0)
		PageIn_1.BorderSizePixel = 0
		PageIn_1.Position = UDim2.new(0.5, 0,0.5, 0)
		PageIn_1.Size = UDim2.new(0.949999988, 0,0.949999988, 0)
		PageIn_1.ClipsDescendants = true
		
		UIPadding_7.Parent = FramePage_1
		UIPadding_7.PaddingBottom = UDim.new(0,8)
		UIPadding_7.PaddingLeft = UDim.new(0,110)
		UIPadding_7.PaddingRight = UDim.new(0,8)
		UIPadding_7.PaddingTop = UDim.new(0,65)
		
		UIStroke_5.Parent = Page_1
		UIStroke_5.Thickness = 1
		UIStroke_5.Transparency = 0.95
		
		addToTheme('UIStroke', UIStroke_5)

		UICorner_9.Parent = Page_1
		
		local PageLeft = Instance.new("ScrollingFrame")
		local UIListLayoutLeft = Instance.new("UIListLayout")
		local UIPaddingLeft = Instance.new("UIPadding")
		
		local PageRight = Instance.new("ScrollingFrame")
		local UIListLayoutRight = Instance.new("UIListLayout")
		local UIPaddingRight = Instance.new("UIPadding")
		
		PageLeft.Name = "PageLeft"
		PageLeft.Parent = PageIn_1
		PageLeft.Active = true
		PageLeft.BackgroundColor3 = Color3.fromRGB(255,255,255)
		PageLeft.BackgroundTransparency = 1
		PageLeft.BorderColor3 = Color3.fromRGB(0,0,0)
		PageLeft.BorderSizePixel = 0
		PageLeft.Size = UDim2.new(0.49000001, 0,1, 0)
		PageLeft.ClipsDescendants = true
		PageLeft.AutomaticCanvasSize = Enum.AutomaticSize.None
		PageLeft.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		PageLeft.CanvasPosition = Vector2.new(0, 0)
		PageLeft.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		PageLeft.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		PageLeft.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		PageLeft.ScrollBarImageColor3 = Color3.fromRGB(0, 104, 255)
		PageLeft.ScrollBarImageTransparency = 0
		PageLeft.ScrollBarThickness = 3
		PageLeft.ScrollingDirection = Enum.ScrollingDirection.XY
		PageLeft.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		PageLeft.VerticalScrollBarInset = Enum.ScrollBarInset.None
		PageLeft.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
		PageLeft.CanvasSize = UDim2.new(0, 0,0, 0)

		UIListLayoutLeft.Parent = PageLeft
		UIListLayoutLeft.Padding = UDim.new(0,5)
		UIListLayoutLeft.SortOrder = Enum.SortOrder.LayoutOrder

		UIPaddingLeft.Parent = PageLeft
		UIPaddingLeft.PaddingRight = UDim.new(0,7)
		
		PageRight.Name = "PageRight"
		PageRight.Parent = PageIn_1
		PageRight.Active = true
		PageRight.AnchorPoint = Vector2.new(1, 0)
		PageRight.BackgroundColor3 = Color3.fromRGB(255,255,255)
		PageRight.BackgroundTransparency = 1
		PageRight.BorderColor3 = Color3.fromRGB(0,0,0)
		PageRight.BorderSizePixel = 0
		PageRight.Size = UDim2.new(0.49, 0,1, 0)
		PageRight.Position = UDim2.new(1, 0,0 ,0)
		PageRight.ClipsDescendants = true
		PageRight.AutomaticCanvasSize = Enum.AutomaticSize.None
		PageRight.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		PageRight.CanvasPosition = Vector2.new(0, 0)
		PageRight.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		PageRight.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		PageRight.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		PageRight.ScrollBarImageColor3 = Color3.fromRGB(0, 104, 255)
		PageRight.ScrollBarImageTransparency = 0
		PageRight.ScrollBarThickness = 3
		PageRight.ScrollingDirection = Enum.ScrollingDirection.XY
		PageRight.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		PageRight.VerticalScrollBarInset = Enum.ScrollBarInset.None
		PageRight.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
		PageRight.CanvasSize = UDim2.new(0, 0,0, 0)
		
		addToTheme('Main Color', PageLeft)
		addToTheme('Main Color', PageRight)

		UIListLayoutRight.Parent = PageRight
		UIListLayoutRight.Padding = UDim.new(0,5)
		UIListLayoutRight.SortOrder = Enum.SortOrder.LayoutOrder

		UIPaddingRight.Parent = PageRight
		UIPaddingRight.PaddingRight = UDim.new(0,7)
		
		local Click = click(Tab_1)
		
		local function changetab()
			for i, v in pairs(FramePage_1:GetChildren()) do
				if v:IsA('Frame') then
					v.Visible = false
					v.PageIn.PageRight.Size = UDim2.new(0.49, 0,0, 0)
					v.PageIn.PageLeft.Size = UDim2.new(0.49, 0,0, 0)
				end
			end
			for i, v in pairs(ScrollingFrame_1:GetChildren()) do
				if v:IsA('Frame') then
					tw({v = v.Title, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.7}}):Play()
					tw({v = v.Icon, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0.7}}):Play()
					tw({v = v.GlowDot, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 1}}):Play()
					tw({v = v.GlowDot.Dot, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0}}):Play()
					tw({v = v.GlowDot.Dot.Dot, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 1}}):Play()
				end
			end
			Page_1.Visible = true
			tw({v = PageLeft, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0.49, 0,1, 0)}}):Play()
			tw({v = PageRight, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0.49, 0,1, 0)}}):Play()
			
			tw({v = Title_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0}}):Play()
			tw({v = Icon_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0}}):Play()
			tw({v = GlowDot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0.5}}):Play()
			tw({v = Dot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0.5}}):Play()
			tw({v = Dot_2, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0}}):Play()
		end
		
		Click.MouseButton1Click:Connect(changetab)
		
		delay(0.5, function()
			if not Library.Tabs.Value then
				changetab()
				Library.Tabs.Value = true
			end
		end)
		
		changecanvas(PageLeft, UIListLayoutLeft, 5)
		changecanvas(PageRight, UIListLayoutRight, 5)
		
		Library.Main = {}
		
		function Library.Main:CreateSection(option)
			local options = {
				Side = option.Side,
				Icon = option.Icon,
				Title = option.Title
			}
			local Section_1 = Instance.new("Frame")
			local ListFunc_1 = Instance.new("Frame")
			local Icon_3 = Instance.new("ImageLabel")
			local TextLabel_1 = Instance.new("TextLabel")
			local UIListLayout_5 = Instance.new("UIListLayout")
			local UIPadding_4 = Instance.new("UIPadding")
			local Line_2 = Instance.new("Frame")
			
			Section_1.Name = "Section"
			Section_1.Parent = gs(options.Side, PageLeft, PageRight)
			Section_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Section_1.BackgroundTransparency = 1
			Section_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Section_1.BorderSizePixel = 0
			Section_1.Size = UDim2.new(1, 0,0, 25)

			ListFunc_1.Name = "ListFunc"
			ListFunc_1.Parent = Section_1
			ListFunc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ListFunc_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ListFunc_1.BorderSizePixel = 0
			ListFunc_1.Size = UDim2.new(1, 0,1, 0)
			ListFunc_1.BackgroundTransparency = 1

			Icon_3.Name = "Icon"
			Icon_3.Parent = ListFunc_1
			Icon_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Icon_3.BorderColor3 = Color3.fromRGB(0,0,0)
			Icon_3.BorderSizePixel = 0
			Icon_3.Size = UDim2.new(0, 17,0, 17)
			Icon_3.Image = gl(options.Icon)
			Icon_3.ImageColor3 = Color3.fromRGB(0,0,0)
			Icon_3.BackgroundTransparency = 1
			
			addToTheme('Icon', Icon_3)

			TextLabel_1.Parent = ListFunc_1
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.LayoutOrder = 1
			TextLabel_1.Size = UDim2.new(0, 50,1, 0)
			TextLabel_1.Font = Enum.Font.GothamBold
			TextLabel_1.Text = tostring(option.Title)
			TextLabel_1.TextSize = 12
			TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
			
			addToTheme('Title', TextLabel_1)

			UIListLayout_5.Parent = ListFunc_1
			UIListLayout_5.Padding = UDim.new(0,5)
			UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_5.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPadding_4.Parent = ListFunc_1
			UIPadding_4.PaddingLeft = UDim.new(0,5)

			Line_2.Name = "Line"
			Line_2.Parent = Section_1
			Line_2.AnchorPoint = Vector2.new(0, 1)
			Line_2.BackgroundColor3 = Color3.fromRGB(136,136,136)
			Line_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Line_2.BorderSizePixel = 0
			Line_2.Position = UDim2.new(0, 0,1, 0)
			Line_2.Size = UDim2.new(1, 0,0, 1)
			Line_2.BackgroundTransparency = 0.6
			
			Library.Func = {}
			
			function Library.Func:CreateToggle(option)
				local Value = option.Value or false
				local Callback = option.Callback or function() end
				local Title = option.Title
				local Desc = option.Desc or ''
				
				local Toggle = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				
				local ListFunctionToggle = Instance.new("Frame")
				local ToggleBarO_1 = Instance.new("Frame")
				local GlowDot_1 = Instance.new("ImageLabel")
				local Dot_1 = Instance.new("ImageLabel")
				local UICorner_1 = Instance.new("UICorner")
				local UIPadding_1 = Instance.new("UIPadding")

				ListFunctionToggle.Name = "ListFunctionToggle"
				ListFunctionToggle.Parent = Toggle
				ListFunctionToggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionToggle.BackgroundTransparency = 1
				ListFunctionToggle.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionToggle.BorderSizePixel = 0
				ListFunctionToggle.Size = UDim2.new(1, 0,1, 0)

				ToggleBarO_1.Name = "ToggleBarO"
				ToggleBarO_1.Parent = ListFunctionToggle
				ToggleBarO_1.AnchorPoint = Vector2.new(1, 0.5)
				ToggleBarO_1.BackgroundColor3 = Color3.fromRGB(216,216,216)
				ToggleBarO_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ToggleBarO_1.BorderSizePixel = 0
				ToggleBarO_1.Position = UDim2.new(1, 0,0.5, 0)
				ToggleBarO_1.Size = UDim2.new(0, 30,0, 15)
				
				addToTheme('Back', ToggleBarO_1)

				GlowDot_1.Name = "GlowDot"
				GlowDot_1.Parent = ToggleBarO_1
				GlowDot_1.AnchorPoint = Vector2.new(0.5, 0.5)
				GlowDot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				GlowDot_1.BackgroundTransparency = 1
				GlowDot_1.BorderColor3 = Color3.fromRGB(0,0,0)
				GlowDot_1.BorderSizePixel = 0
				GlowDot_1.Position = UDim2.new(0.75, 0,0.5, 0)
				GlowDot_1.Size = UDim2.new(0, 14,0, 14)
				GlowDot_1.Image = "rbxassetid://105506802034513"
				GlowDot_1.ImageColor3 = Color3.fromRGB(0,104,255)
				GlowDot_1.ImageTransparency = 0.5
				
				addToTheme('Main Color', GlowDot_1)

				Dot_1.Name = "Dot"
				Dot_1.Parent = GlowDot_1
				Dot_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Dot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Dot_1.BackgroundTransparency = 1
				Dot_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Dot_1.BorderSizePixel = 0
				Dot_1.Position = UDim2.new(0.5, 0,0.5, 0)
				Dot_1.Size = UDim2.new(0, 8,0, 8)
				Dot_1.Image = "rbxassetid://105506802034513"
				Dot_1.ImageColor3 = Color3.fromRGB(0,104,255)

				UICorner_1.Parent = ToggleBarO_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				UIPadding_1.Parent = ListFunctionToggle
				UIPadding_1.PaddingRight = UDim.new(0,8)
				
				local Click = click(Toggle)
				
				Value = not Value

				local function change()
					Value = not Value
					Callback(Value)
					if Value then
						tw({v = Toggle.TitleList.Title, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0}}):Play()
						tw({v = GlowDot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Position = UDim2.new(0.75, 0,0.5, 0), ImageTransparency = 0.5}}):Play()
						tw({v = Dot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = GlowDot_1.ImageColor3, Size = UDim2.new(0, 8, 0, 8)}}):Play()
					else
						tw({v = Toggle.TitleList.Title, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.5}}):Play()
						tw({v = GlowDot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Position = UDim2.new(0.3, 0,0.5, 0), ImageTransparency = 1}}):Play()
						tw({v = Dot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(153, 153, 153), Size = UDim2.new(0, 10, 0, 10)}}):Play()	
					end
				end
				
				GlowDot_1:GetPropertyChangedSignal("ImageColor3"):Connect(function()
					if Value and GlowDot_1.ImageTransparency == 0.5 then
						Dot_1.ImageColor3 = GlowDot_1.ImageColor3
					end
				end)

				Click.MouseButton1Click:Connect(change)

				delay(0.1, change)
			end
			
			function Library.Func:CreateSlider(option)
				local Min = option.Min or 0
				local Max = option.Max or 10
				local Value = option.Value or Max/2
				local Callback = option.Callback or function() end
				local Title = option.Title
				local Desc = option.Desc or ''
				local Rounding = option.Rounding or 2

				local Slider = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				Slider.TitleList.UIPadding.PaddingRight = UDim.new(0, 110)
				if not Slider.TitleList.Desc.Visible then
					Slider.Size = UDim2.new(1, 0,0, 45)
				end
				
				local ListFunctionSlider = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local ListFunctionSlider_1 = Instance.new("Frame")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local SliderBar_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local SliderClick_1 = Instance.new("TextButton")
				local SliderBarValue_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local umbraShadow_1 = Instance.new("ImageLabel")
				local TextBox_1 = Instance.new("TextBox")
				local UICorner_3 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")

				ListFunctionSlider.Name = "ListFunctionSlider"
				ListFunctionSlider.Parent = Slider
				ListFunctionSlider.AnchorPoint = Vector2.new(1, 0)
				ListFunctionSlider.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionSlider.BackgroundTransparency = 1
				ListFunctionSlider.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionSlider.BorderSizePixel = 0
				ListFunctionSlider.Position = UDim2.new(1, 0,0, 0)
				ListFunctionSlider.Size = UDim2.new(0, 100,1, 0)

				UIPadding_1.Parent = ListFunctionSlider
				UIPadding_1.PaddingRight = UDim.new(0,8)

				ListFunctionSlider_1.Name = "ListFunctionSlider"
				ListFunctionSlider_1.Parent = ListFunctionSlider
				ListFunctionSlider_1.AnchorPoint = Vector2.new(0.5, 0.5)
				ListFunctionSlider_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionSlider_1.BackgroundTransparency = 1
				ListFunctionSlider_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionSlider_1.BorderSizePixel = 0
				ListFunctionSlider_1.Position = UDim2.new(0.5, 0,0.400000006, 0)
				ListFunctionSlider_1.Size = UDim2.new(1, 0,0, 5)

				UIListLayout_1.Parent = ListFunctionSlider_1
				UIListLayout_1.Padding = UDim.new(0,8)
				UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

				SliderBar_1.Name = "SliderBar"
				SliderBar_1.Parent = ListFunctionSlider_1
				SliderBar_1.BackgroundColor3 = Color3.fromRGB(217, 217, 217)
				SliderBar_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SliderBar_1.BorderSizePixel = 0
				SliderBar_1.Size = UDim2.new(1, 0,1, 0)
				
				addToTheme('Back', SliderBar_1)

				UICorner_1.Parent = SliderBar_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				SliderClick_1.Name = "SliderClick"
				SliderClick_1.Parent = SliderBar_1
				SliderClick_1.Active = true
				SliderClick_1.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderClick_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				SliderClick_1.BackgroundTransparency = 1
				SliderClick_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SliderClick_1.BorderSizePixel = 0
				SliderClick_1.Position = UDim2.new(0.5, 0,0.5, 0)
				SliderClick_1.Size = UDim2.new(1, 10,1, 10)
				SliderClick_1.Font = Enum.Font.SourceSans
				SliderClick_1.Text = ""
				SliderClick_1.TextSize = 14

				SliderBarValue_1.Name = "SliderBarValue"
				SliderBarValue_1.Parent = SliderBar_1
				SliderBarValue_1.BackgroundColor3 = Color3.fromRGB(0,104,255)
				SliderBarValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SliderBarValue_1.BorderSizePixel = 0
				SliderBarValue_1.LayoutOrder = 1
				SliderBarValue_1.Size = UDim2.new(0.800000012, 0,1, 0)
				
				addToTheme('Main Color', SliderBarValue_1)

				UICorner_2.Parent = SliderBarValue_1
				UICorner_2.CornerRadius = UDim.new(1,0)

				umbraShadow_1.Name = "umbraShadow"
				umbraShadow_1.Parent = SliderBarValue_1
				umbraShadow_1.AnchorPoint = Vector2.new(0.5, 0.5)
				umbraShadow_1.BackgroundColor3 = Color3.fromRGB(163,162,165)
				umbraShadow_1.BackgroundTransparency = 1
				umbraShadow_1.Position = UDim2.new(0.5, 0,0.5, 0)
				umbraShadow_1.Size = UDim2.new(1, 10,1, 10)
				umbraShadow_1.Image = "rbxassetid://1316045217"
				umbraShadow_1.ImageColor3 = Color3.fromRGB(0,104,255)
				umbraShadow_1.ScaleType = Enum.ScaleType.Slice
				umbraShadow_1.SliceCenter = Rect.new(10, 10, 118, 118)
				
				addToTheme('Main Color', umbraShadow_1)

				TextBox_1.Parent = ListFunctionSlider_1
				TextBox_1.Active = true
				TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.BackgroundTransparency = 1
				TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextBox_1.BorderSizePixel = 0
				TextBox_1.LayoutOrder = 1
				TextBox_1.Size = UDim2.new(0, 23,0, 10)
				TextBox_1.Font = Enum.Font.Gotham
				TextBox_1.PlaceholderText = ""
				TextBox_1.Text = Value
				TextBox_1.TextSize = 9
				
				addToTheme('Title', TextBox_1)

				UICorner_3.Parent = TextBox_1

				UIStroke_1.Parent = TextBox_1
				UIStroke_1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke_1.Thickness = 1
				UIStroke_1.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_1)
				
				local function roundToDecimal(value, decimals)
					local factor = 10 ^ decimals
					return math.floor(value * factor + 0.5) / factor
				end

				local function updateSlider(value)
					value = math.clamp(value, Min, Max)
					value = roundToDecimal(value, Rounding)
					tw({v = SliderBarValue_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)}}):Play()

					TextBox_1.Text = tostring(roundToDecimal(value, Rounding))
					
					tw({v = TextBox_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, TextBox_1.TextBounds.X + 20, 0, 10)}}):Play()

					pcall(Callback ,value)
				end

				updateSlider(Value or 0)

				TextBox_1.FocusLost:Connect(function()
					local value = tonumber(TextBox_1.Text) or Min
					updateSlider(value)
				end)

				local function move(input)
					local sliderBar = SliderBar_1
					local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
					local value = relativeX * (Max - Min) + Min
					updateSlider(value)
				end

				local dragging = false

				SliderClick_1.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						move(input)
					end
				end)

				SliderClick_1.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				U.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						move(input)
					end
				end)
			end
			
			function Library.Func:CreateDropdown(option)
				local List = option.List or {}
				local Value = option.Value or List[1]
				local Callback = option.Callback or function() end
				local Multi = option.Multi or false
				local Title = option.Title
				local Desc = option.Desc or ''

				local Dropdown = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				Dropdown.TitleList.UIPadding.PaddingRight = UDim.new(0, 72)
				
				local ListFunctionDropdown = Instance.new("Frame")
				local DropdownValue_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local TextLabelValue_1 = Instance.new("TextLabel")
				local UIPadding_1 = Instance.new("UIPadding")
				local ImageLabel_1 = Instance.new("ImageLabel")
				local UIPadding_2 = Instance.new("UIPadding")

				ListFunctionDropdown.Name = "ListFunctionDropdown"
				ListFunctionDropdown.Parent = Dropdown
				ListFunctionDropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionDropdown.BackgroundTransparency = 1
				ListFunctionDropdown.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionDropdown.BorderSizePixel = 0
				ListFunctionDropdown.Size = UDim2.new(1, 0,1, 0)

				DropdownValue_1.Name = "DropdownValue"
				DropdownValue_1.Parent = ListFunctionDropdown
				DropdownValue_1.AnchorPoint = Vector2.new(1, 0.5)
				DropdownValue_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
				DropdownValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				DropdownValue_1.BorderSizePixel = 0
				DropdownValue_1.Position = UDim2.new(1, 0,0.5, 0)
				DropdownValue_1.Size = UDim2.new(0, 65,0, 15)
				
				addToTheme('Back', DropdownValue_1)

				UICorner_1.Parent = DropdownValue_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				TextLabelValue_1.Parent = DropdownValue_1
				TextLabelValue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabelValue_1.BackgroundTransparency = 1
				TextLabelValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabelValue_1.BorderSizePixel = 0
				TextLabelValue_1.Size = UDim2.new(1, 0,1, 0)
				TextLabelValue_1.Font = Enum.Font.Gotham
				TextLabelValue_1.Text = "Select 1"
				TextLabelValue_1.TextSize = 9
				TextLabelValue_1.TextXAlignment = Enum.TextXAlignment.Left
				TextLabelValue_1.TextTruncate = Enum.TextTruncate.AtEnd
				
				addToTheme('Title', TextLabelValue_1)

				UIPadding_1.Parent = DropdownValue_1
				UIPadding_1.PaddingLeft = UDim.new(0,5)
				UIPadding_1.PaddingRight = UDim.new(0,3)

				ImageLabel_1.Parent = DropdownValue_1
				ImageLabel_1.AnchorPoint = Vector2.new(1, 0.5)
				ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ImageLabel_1.BackgroundTransparency = 1
				ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ImageLabel_1.BorderSizePixel = 0
				ImageLabel_1.Position = UDim2.new(1, 0,0.5, 0)
				ImageLabel_1.Size = UDim2.new(0, 10,0, 10)
				ImageLabel_1.Image = "rbxassetid://13858680846"
				ImageLabel_1.ImageColor3 = Color3.fromRGB(0,0,0)
				
				addToTheme('Title', ImageLabel_1)

				UIPadding_2.Parent = ListFunctionDropdown
				UIPadding_2.PaddingRight = UDim.new(0,8)
				
				local ClickDropdown = click(Dropdown)
				
				local DropdownSelect = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local FrameDrop = Instance.new("Frame")
				local ScrollingFrame_1 = Instance.new("ScrollingFrame")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local UIStroke_1 = Instance.new("UIStroke")
				local UIPadding_2 = Instance.new("UIPadding")
				local Line_1 = Instance.new("Frame")
				local UICornerLine_1 = Instance.new("UICorner")
				
				addToTheme('Back', DropdownSelect)

				DropdownSelect.Name = "DropdownSelect"
				DropdownSelect.Parent = ScreenGui
				DropdownSelect.BackgroundColor3 = Color3.fromRGB(217,217,217)
				DropdownSelect.BorderColor3 = Color3.fromRGB(0,0,0)
				DropdownSelect.BorderSizePixel = 0
				DropdownSelect.Size = UDim2.new(0, 120,0, 0)
				DropdownSelect.ClipsDescendants = true
				local targetX = DropdownValue_1.AbsolutePosition.X - DropdownSelect.Parent.AbsolutePosition.X + DropdownValue_1.Size.X.Offset - 140
				local targetY = DropdownValue_1.AbsolutePosition.Y - DropdownSelect.Parent.AbsolutePosition.Y + DropdownValue_1.Size.Y.Offset - 20
				DropdownSelect.Position = UDim2.new(0, targetX, 0, targetY)

				UICorner_1.Parent = DropdownSelect
				
				FrameDrop.Parent = DropdownSelect
				FrameDrop.BackgroundColor3 = Color3.fromRGB(255,255,255)
				FrameDrop.BackgroundTransparency = 1
				FrameDrop.BorderColor3 = Color3.fromRGB(0,0,0)
				FrameDrop.BorderSizePixel = 0
				FrameDrop.Size = UDim2.new(1, 0,1, 0)
				
				Line_1.Name = "Line"
				Line_1.Parent = FrameDrop
				Line_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Line_1.BorderSizePixel = 0
				Line_1.Size = UDim2.new(0, 3,1, 0)
				
				UICornerLine_1.Parent = Line_1
				
				local UIPadding = Instance.new("UIPadding")
				UIPadding.Parent = FrameDrop
				UIPadding.PaddingBottom = UDim.new(0, 30)
				
				addToTheme('Main', Line_1)

				ScrollingFrame_1.Name = "ScrollingFrame"
				ScrollingFrame_1.Parent = FrameDrop
				ScrollingFrame_1.Active = true
				ScrollingFrame_1.AnchorPoint = Vector2.new(1, 0)
				ScrollingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ScrollingFrame_1.BackgroundTransparency = 1
				ScrollingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ScrollingFrame_1.BorderSizePixel = 0
				ScrollingFrame_1.Size = UDim2.new(0.93, 0,1, 0)
				ScrollingFrame_1.ClipsDescendants = true
				ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.None
				ScrollingFrame_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
				ScrollingFrame_1.CanvasPosition = Vector2.new(0, 0)
				ScrollingFrame_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
				ScrollingFrame_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
				ScrollingFrame_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				ScrollingFrame_1.ScrollBarImageTransparency = 0
				ScrollingFrame_1.Position = UDim2.new(1, 0, 0, 0)
				ScrollingFrame_1.ScrollBarThickness = 0
				ScrollingFrame_1.ScrollingDirection = Enum.ScrollingDirection.XY
				ScrollingFrame_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
				ScrollingFrame_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
				ScrollingFrame_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

				UIListLayout_1.Parent = ScrollingFrame_1
				UIListLayout_1.Padding = UDim.new(0,3)
				UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

				UIPadding_2.Parent = DropdownSelect
				UIPadding_2.PaddingBottom = UDim.new(0,5)
				UIPadding_2.PaddingLeft = UDim.new(0,5)
				UIPadding_2.PaddingRight = UDim.new(0,5)
				UIPadding_2.PaddingTop = UDim.new(0,5)

				UIStroke_1.Parent = DropdownSelect
				UIStroke_1.Thickness = 1
				UIStroke_1.Transparency = 1
				addToTheme('UIStroke', UIStroke_1)
				
				local UIListLayoutDropSelect = Instance.new("UIListLayout")

				UIListLayoutDropSelect.Parent = DropdownSelect
				UIListLayoutDropSelect.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayoutDropSelect.Padding = UDim.new(0, 5)
				
				local Search = Instance.new("Frame")
				local UICornerSearch_1 = Instance.new("UICorner")
				local UIStrokeSearch_1 = Instance.new("UIStroke")
				local SearchBox_1 = Instance.new("TextBox")
				local IconSearch_1 = Instance.new("ImageLabel")
				local UIPadding_1 = Instance.new("UIPadding")

				Search.Name = "Search"
				Search.Parent = DropdownSelect
				Search.Active = true
				Search.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Search.BorderColor3 = Color3.fromRGB(0,0,0)
				Search.BorderSizePixel = 0
				Search.LayoutOrder = -1
				Search.Size = UDim2.new(1, 0,0, 25)

				UICornerSearch_1.Name = "UICornerSearch"
				UICornerSearch_1.Parent = Search
				UICornerSearch_1.CornerRadius = UDim.new(1,0)

				UIStrokeSearch_1.Name = "UIStrokeSearch"
				UIStrokeSearch_1.Parent = Search
				UIStrokeSearch_1.Thickness = 1
				UIStrokeSearch_1.Transparency = 0.95
				
				addToTheme('UIStroke', UIStrokeSearch_1)

				SearchBox_1.Name = "SearchBox"
				SearchBox_1.Parent = Search
				SearchBox_1.Active = true
				SearchBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				SearchBox_1.BackgroundTransparency = 1
				SearchBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SearchBox_1.BorderSizePixel = 0
				SearchBox_1.CursorPosition = -1
				SearchBox_1.Size = UDim2.new(1, 0,1, 0)
				SearchBox_1.Font = Enum.Font.Gotham
				SearchBox_1.PlaceholderColor3 = Color3.fromRGB(140,140,140)
				SearchBox_1.PlaceholderText = "Search"
				SearchBox_1.Text = ""
				SearchBox_1.TextSize = 10

				IconSearch_1.Name = "IconSearch"
				IconSearch_1.Parent = Search
				IconSearch_1.AnchorPoint = Vector2.new(1, 0.5)
				IconSearch_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				IconSearch_1.BackgroundTransparency = 1
				IconSearch_1.BorderColor3 = Color3.fromRGB(0,0,0)
				IconSearch_1.BorderSizePixel = 0
				IconSearch_1.Position = UDim2.new(1, 0,0.5, 0)
				IconSearch_1.Size = UDim2.new(0, 10,0, 10)
				IconSearch_1.Image = "rbxassetid://14897613248"
				IconSearch_1.ImageColor3 = Color3.fromRGB(0,0,0)
				IconSearch_1.ImageTransparency = 0.5
				
				addToTheme('Icon', IconSearch_1)

				UIPadding_1.Parent = Search
				UIPadding_1.PaddingLeft = UDim.new(0,5)
				UIPadding_1.PaddingRight = UDim.new(0,5)
				
				addToTheme('Main', Search)
				addToTheme('Title', SearchBox_1)
				
				local isopen = false
				
				local function updateDropdownSize()
					if not isopen then return end
					
					local visibleCount = 0
					for i, v in pairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") and v.Visible then
							visibleCount = visibleCount + 1
						end
					end

					local contentHeight = (UIListLayout_1.AbsoluteContentSize.Y + 40)
					if contentHeight > 130 then
						contentHeight = 130
					end

					tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 120, 0, contentHeight)}}):Play()
				end

				SearchBox_1.Changed:Connect(function()
					local SearchT = string.lower(SearchBox_1.Text)
					for i, v in pairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") then
							if SearchT ~= "" and v:FindFirstChild("TextLabel") then
								if string.find(string.lower(v.TextLabel.Text), SearchT) then
									v.Visible = true
								else
									v.Visible = false
								end
							else
								v.Visible = true
							end
						end
					end
					updateDropdownSize()
				end)
				
				local function open()
					local targetX = DropdownValue_1.AbsolutePosition.X - DropdownSelect.Parent.AbsolutePosition.X + DropdownValue_1.Size.X.Offset - 119
					local targetY = DropdownValue_1.AbsolutePosition.Y - DropdownSelect.Parent.AbsolutePosition.Y + DropdownValue_1.Size.Y.Offset + 5
					local contentHeight = UIListLayout_1.AbsoluteContentSize.Y + 40
					if contentHeight <= 130 then
						tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 120, 0, contentHeight), Position = UDim2.new(0, targetX, 0, targetY)}}):Play()
					else
						tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 120, 0, 130), Position = UDim2.new(0, targetX, 0, targetY)}}):Play()
					end
					tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 0.95}}):Play()
					isopen = true	
				end
				
				local function close()
					isopen = false
					tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 120,0, 0)}}):Play()
					tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 1}}):Play()
				end
				
				U.InputBegan:Connect(function(A)
					if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
						local B, C = DropdownSelect.AbsolutePosition, DropdownSelect.AbsoluteSize
						if game:GetService "Players".LocalPlayer:GetMouse().X < B.X or game:GetService "Players".LocalPlayer:GetMouse().X > B.X + C.X or game:GetService "Players".LocalPlayer:GetMouse().Y < (B.Y - 20 - 1) or game:GetService "Players".LocalPlayer:GetMouse().Y > B.Y + C.Y then
							close()
						end
					end
				end)
				
				ClickDropdown.MouseButton1Click:Connect(function()
					if not isopen then
						open()
					else
						close()
					end
				end)
				
				local itemslist = {}
				local selectedValues = {}
				local selectedItem

				function itemslist:Clear(a)
					local function shouldClear(v)
						if a == nil then
							return true
						elseif type(a) == "string" then
							return v:FindFirstChild("TextLabel") and v.TextLabel.Text == a
						elseif type(a) == "table" then
							for _, name in ipairs(a) do
								if v:FindFirstChild("TextLabel") and v.TextLabel.Text == name then
									return true
								end
							end
						end
						return false
					end

					if Multi then
						selectedValues = {}
						TextLabelValue_1.Text = ""
						pcall(Callback ,selectedValues)
					end

					for _, v in ipairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") and shouldClear(v) then
							if selectedItem and v:FindFirstChild("TextLabel") and v.TextLabel.Text == selectedItem then
								selectedItem = nil
								TextLabelValue_1.Text = ""
								pcall(Callback, TextLabelValue_1.Text)
							end
							v:Destroy()
						end
					end

					if selectedItem == a or TextLabelValue_1.Text == a then
						selectedItem = nil
						TextLabelValue_1.Text = ""
					end

					if a == nil then
						selectedItem = nil
						TextLabelValue_1.Text = ""
					end

					Value = nil
				end

				function itemslist:Add(text)
					local Item_1 = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local TextLabel_1 = Instance.new("TextLabel")
					local UIPadding_1 = Instance.new("UIPadding")
					local GlowDot_1 = Instance.new("ImageLabel")
					local Dot_1 = Instance.new("ImageLabel")
					
					Item_1.Name = "Item"
					Item_1.Parent = ScrollingFrame_1
					Item_1.BackgroundColor3 = themes[IsTheme]['Main']
					Item_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Item_1.BorderSizePixel = 0
					Item_1.Size = UDim2.new(1, 0,0, 18)
					
					addToTheme('Main', Item_1)

					UICorner_2.Parent = Item_1

					TextLabel_1.Parent = Item_1
					TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					TextLabel_1.BackgroundTransparency = 1
					TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
					TextLabel_1.BorderSizePixel = 0
					TextLabel_1.Size = UDim2.new(1, 0,1, 0)
					TextLabel_1.Font = Enum.Font.Gotham
					TextLabel_1.Text = text
					TextLabel_1.TextSize = 9
					TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel_1.TextTransparency = 0.5
					TextLabel_1.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel_1.TextColor3 = themes[IsTheme]['Title']
					
					addToTheme('Title', TextLabel_1)

					UIPadding_1.Parent = Item_1
					UIPadding_1.PaddingLeft = UDim.new(0,3)
					UIPadding_1.PaddingRight = UDim.new(0,2)

					GlowDot_1.Name = "GlowDot"
					GlowDot_1.Parent = Item_1
					GlowDot_1.AnchorPoint = Vector2.new(1, 0.5)
					GlowDot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					GlowDot_1.BackgroundTransparency = 1
					GlowDot_1.BorderColor3 = Color3.fromRGB(0,0,0)
					GlowDot_1.BorderSizePixel = 0
					GlowDot_1.Position = UDim2.new(1, 0,0.5, 0)
					GlowDot_1.Size = UDim2.new(0, 14,0, 14)
					GlowDot_1.Image = "rbxassetid://105506802034513"
					GlowDot_1.ImageColor3 = themes[IsTheme]['Main Color']
					GlowDot_1.ImageTransparency = 1
					
					addToTheme('Main Color', GlowDot_1)

					Dot_1.Name = "Dot"
					Dot_1.Parent = GlowDot_1
					Dot_1.AnchorPoint = Vector2.new(0.5, 0.5)
					Dot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Dot_1.BackgroundTransparency = 1
					Dot_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Dot_1.BorderSizePixel = 0
					Dot_1.Position = UDim2.new(0.5, 0,0.5, 0)
					Dot_1.Size = UDim2.new(0, 8,0, 8)
					Dot_1.Image = "rbxassetid://105506802034513"
					Dot_1.ImageColor3 = Color3.fromRGB(153, 153, 153)
					
					local ClickItem = click(Item_1)
					local function unselect()
						tw({v = TextLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.5}}):Play()
						tw({v = GlowDot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 1}}):Play()
						tw({v = Dot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(153, 153, 153)}}):Play()
					end
					local function hasselect()
						tw({v = TextLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0}}):Play()
						tw({v = GlowDot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0.5}}):Play()
						tw({v = Dot_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = GlowDot_1.ImageColor3}}):Play()	
					end
					
					ClickItem.MouseButton1Click:Connect(function()
						if Multi then
							if selectedValues[text] then
								selectedValues[text] = nil
								unselect()
							else
								selectedValues[text] = true
								hasselect()
							end
							local selectedList = {}
							for i, v in pairs(selectedValues) do
								table.insert(selectedList, i)
							end
							if #selectedList > 0 then
								TextLabelValue_1.Text = table.concat(selectedList, ", ")
							else
								TextLabelValue_1.Text = ""
							end
							pcall(Callback, selectedList)
						else
							for i,v in pairs(ScrollingFrame_1:GetChildren()) do
								if v:IsA("Frame") then
									tw({v = v.TextLabel, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.5}}):Play()
									tw({v = v.GlowDot, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 1}}):Play()
									tw({v = v.GlowDot.Dot, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(153, 153, 153)}}):Play()
								end
							end
							hasselect()
							Value = text
							TextLabelValue_1.Text = text
							pcall(Callback, TextLabelValue_1.Text)
						end
					end)
					
					local function isValueInTable(val, tbl)
						if type(tbl) ~= "table" then
							return false
						end

						for _, v in pairs(tbl) do
							if v == val then
								return true
							end
						end
						return false
					end
					
					GlowDot_1:GetPropertyChangedSignal("ImageColor3"):Connect(function()
						if isValueInTable(text, Value) then
							Dot_1.ImageColor3 = GlowDot_1.ImageColor3
						end
						if text == Value then
							Dot_1.ImageColor3 = GlowDot_1.ImageColor3
						end
					end)

					delay(0,function()
						if Multi then
							if isValueInTable(text, Value) then
								hasselect()
								selectedValues[text] = true
								local selectedList = {}
								for i, v in pairs(selectedValues) do
									table.insert(selectedList, i)
								end
								if #selectedList > 0 then
									TextLabelValue_1.Text = table.concat(selectedList, ", ")
								else
									TextLabelValue_1.Text = ""
								end
								pcall(function()
									Callback(selectedList)
								end)
							end
						else
							if text == Value then
								hasselect()
								Value = text
								TextLabelValue_1.Text = text
								Callback(TextLabelValue_1.Text)
							end
						end
					end)
				end
				
				for i, v in ipairs(List) do
					itemslist:Add(v, i)
				end

				changecanvas(ScrollingFrame_1, UIListLayout_1, 5)

				return itemslist
			end
			
			function Library.Func:CreateLabel(option)
				local Title = option.Title
				local Desc = option.Desc or ''

				local Label = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				Label.TitleList.UIPadding.PaddingRight = UDim.new(0, 8)
				
				local NewColor = {}

				function NewColor:SetTitle(t)
					Label.TitleList.Title.Text = t
				end
				function NewColor:SetDesc(t)
					if #Label.TitleList.Desc.Text > 0 then
						Label.Visible = true
						Label.TitleList.Desc.Text = t
					else
						Label.Visible = false
					end
				end

				return NewColor
			end
			
			function Library.Func:CreateButton(option)
				local Title = option.Title
				local Desc = option.Desc or ''
				local Callback = option.Callback or function() end

				local Button = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				Button.TitleList.UIPadding.PaddingRight = UDim.new(0, 25)
				Button.ClipsDescendants = true
				
				local UIPadding = Instance.new("UIPadding")
				local Icon = Instance.new("ImageLabel")

				UIPadding.Parent = Button
				UIPadding.PaddingRight = UDim.new(0,5)
				
				Icon.Name = "Icon"
				Icon.Parent = Button
				Icon.AnchorPoint = Vector2.new(1, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Icon.BackgroundTransparency = 1
				Icon.BorderColor3 = Color3.fromRGB(0,0,0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(1, 0,0.5, 0)
				Icon.Size = UDim2.new(0, 20,0, 20)
				Icon.Image = "rbxassetid://14923747331"
				Icon.ImageColor3 = Color3.fromRGB(0,0,0)
				
				addToTheme('Title', Icon)
				
				local Click = click(Button)
				Click.MouseButton1Click:Connect(function()
					jc(Click, Button)
					pcall(Callback)
				end)
			end
			
			function Library.Func:CreateKeybind(option)
				local Title = option.Title
				local Desc = option.Desc or ''
				local Value = option.Value or false
				local Key = option.Key or Enum.KeyCode.E
				local Callback = option.Callback or function() end

				local Keybind = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				Keybind.TitleList.UIPadding.PaddingRight = UDim.new(0, 60)
				
				local Title_1 = Keybind.TitleList.Title
				
				local ListFunctionKeybind = Instance.new("Frame")
				local BarValue_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local TextLabel_1 = Instance.new("TextLabel")
				local UIStroke_1 = Instance.new("UIStroke")
				local UIPadding_1 = Instance.new("UIPadding")

				ListFunctionKeybind.Name = "ListFunctionKeybind"
				ListFunctionKeybind.Parent = Keybind
				ListFunctionKeybind.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionKeybind.BackgroundTransparency = 1
				ListFunctionKeybind.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionKeybind.BorderSizePixel = 0
				ListFunctionKeybind.Size = UDim2.new(1, 0,1, 0)

				BarValue_1.Name = "BarValue"
				BarValue_1.Parent = ListFunctionKeybind
				BarValue_1.AnchorPoint = Vector2.new(1, 0.5)
				BarValue_1.BackgroundColor3 = Color3.fromRGB(216,216,216)
				BarValue_1.BackgroundTransparency = 1
				BarValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				BarValue_1.BorderSizePixel = 0
				BarValue_1.Position = UDim2.new(1, 0,0.5, 0)
				BarValue_1.Size = UDim2.new(0, 20,0, 15)
				BarValue_1.ClipsDescendants = true

				UICorner_1.Parent = BarValue_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				TextLabel_1.Parent = BarValue_1
				TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_1.BackgroundTransparency = 1
				TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_1.BorderSizePixel = 0
				TextLabel_1.Size = UDim2.new(1, 0,1, 0)
				TextLabel_1.Font = Enum.Font.Gotham
				TextLabel_1.Text = tostring(Key):gsub("Enum.KeyCode.", "")
				TextLabel_1.TextSize = 9
				
				addToTheme('Title', TextLabel_1)

				UIStroke_1.Parent = BarValue_1
				UIStroke_1.Thickness = 1
				UIStroke_1.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_1)

				UIPadding_1.Parent = ListFunctionKeybind
				UIPadding_1.PaddingRight = UDim.new(0,8)
				
				local Click = click(Keybind)
				local changeing = false
				
				local function adjustBoxBindSize()
					local textSize = game:GetService("TextService"):GetTextSize(TextLabel_1.Text, TextLabel_1.TextSize, TextLabel_1.Font, Vector2.new(1000, 1000))
					tw({v = BarValue_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, textSize.X + 10, 0, 15)}}):Play()
				end

				adjustBoxBindSize()

				local function changeKey()
					changeing = true
					TextLabel_1.Text = "..."
					local inputConnection
					tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 0.5}}):Play()
					inputConnection = U.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							Key = input.KeyCode
							TextLabel_1.Text = tostring(Key):gsub("Enum.KeyCode.", "")
							adjustBoxBindSize()
							inputConnection:Disconnect()
							Callback(Key, Value)
							tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 0.75}}):Play()
							task.wait(.1)
							changeing = false
						end
					end)
				end

				U.InputBegan:Connect(function(input, gameProcessed)
					if input.KeyCode == Key and not changeing then
						Value = not Value
						if Value then
							tw({v = Title_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0}}):Play()
						else
							tw({v = Title_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.5}}):Play()
						end
						Callback(Key, Value)
					end
				end)

				delay(0, function()
					Callback(Key, Value)
				end)

				Click.MouseButton1Click:Connect(function()
					changeKey()
				end)
			end
			
			function Library.Func:CreateTextbox(option)
				local Title = option.Title
				local Desc = option.Desc or ''
				local Value = option.Value or ''
				local Placeholder = option.Placeholder or 'Paste Your Text'
				local ClearText = option.ClearText or option.ClearTextOnFocus or false
				local Callback = option.Callback or function() end

				local Textbox = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				Textbox.TitleList.UIPadding.PaddingRight = UDim.new(0, 90)
				
				local ListFunctionTextbox = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local BarValue_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local TextLabel_1 = Instance.new("TextBox")

				ListFunctionTextbox.Name = "ListFunctionTextbox"
				ListFunctionTextbox.Parent = Textbox
				ListFunctionTextbox.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionTextbox.BackgroundTransparency = 1
				ListFunctionTextbox.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionTextbox.BorderSizePixel = 0
				ListFunctionTextbox.Size = UDim2.new(1, 0,1, 0)

				UIPadding_1.Parent = ListFunctionTextbox
				UIPadding_1.PaddingRight = UDim.new(0,8)

				BarValue_1.Name = "BarValue"
				BarValue_1.Parent = ListFunctionTextbox
				BarValue_1.AnchorPoint = Vector2.new(1, 0.5)
				BarValue_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
				BarValue_1.BackgroundTransparency = 1
				BarValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				BarValue_1.BorderSizePixel = 0
				BarValue_1.Position = UDim2.new(1, 0,0.5, 0)
				BarValue_1.Size = UDim2.new(0, 80,0, 20)

				UICorner_1.Parent = BarValue_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				UIStroke_1.Parent = BarValue_1
				UIStroke_1.Thickness = 1
				UIStroke_1.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_1)

				TextLabel_1.Name = "TextLabel"
				TextLabel_1.Parent = BarValue_1
				TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_1.BackgroundTransparency = 1
				TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_1.BorderSizePixel = 0
				TextLabel_1.Size = UDim2.new(1, 0,1, 0)
				TextLabel_1.Font = Enum.Font.Gotham
				TextLabel_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextLabel_1.PlaceholderText = Placeholder
				TextLabel_1.Text = Value
				TextLabel_1.TextSize = 9
				TextLabel_1.TextTruncate = Enum.TextTruncate.AtEnd
				TextLabel_1.ClearTextOnFocus = not ClearText
				
				addToTheme('Title', TextLabel_1)
				
				local function o()
					if #TextLabel_1.Text > 0 then
						pcall(Callback, TextLabel_1.Text)
					end
				end

				TextLabel_1.FocusLost:Connect(o)

				delay(0, o)
			end
			
			function Library.Func:CreateColorPicker(option)
				local Title = option.Title
				local Desc = option.Desc or ''
				local Value = option.Value or Color3.fromRGB(255, 255, 255)
				local Callback = option.Callback or function() end

				local ColorPicker = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				
				local ListFunctionColorPicker = Instance.new("Frame")
				local Picker_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local GlowDot_1 = Instance.new("ImageLabel")
				local Picker_2 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UIPadding_1 = Instance.new("UIPadding")

				ListFunctionColorPicker.Name = "ListFunctionColorPicker"
				ListFunctionColorPicker.Parent = ColorPicker
				ListFunctionColorPicker.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionColorPicker.BackgroundTransparency = 1
				ListFunctionColorPicker.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionColorPicker.BorderSizePixel = 0
				ListFunctionColorPicker.Size = UDim2.new(1, 0,1, 0)

				Picker_1.Name = "Picker"
				Picker_1.Parent = ListFunctionColorPicker
				Picker_1.AnchorPoint = Vector2.new(1, 0.5)
				Picker_1.BackgroundColor3 = Value
				Picker_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Picker_1.BorderSizePixel = 0
				Picker_1.Position = UDim2.new(1, 0,0.5, 0)
				Picker_1.Size = UDim2.new(0, 20,0, 20)

				UICorner_1.Parent = Picker_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				GlowDot_1.Name = "GlowDot"
				GlowDot_1.Parent = Picker_1
				GlowDot_1.AnchorPoint = Vector2.new(0.5, 0.5)
				GlowDot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				GlowDot_1.BackgroundTransparency = 1
				GlowDot_1.BorderColor3 = Color3.fromRGB(0,0,0)
				GlowDot_1.BorderSizePixel = 0
				GlowDot_1.Position = UDim2.new(0.5, 0,0.5, 0)
				GlowDot_1.Size = UDim2.new(1.5, 0,1.5, 0)
				GlowDot_1.Image = "rbxassetid://105506802034513"
				GlowDot_1.ImageColor3 = Value
				GlowDot_1.ImageTransparency = 0.2

				Picker_2.Name = "Picker"
				Picker_2.Parent = GlowDot_1
				Picker_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Picker_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Picker_2.BorderColor3 = Color3.fromRGB(0,0,0)
				Picker_2.BorderSizePixel = 0
				Picker_2.Position = UDim2.new(0.5, 0,0.5, 0)
				Picker_2.Size = UDim2.new(0, 12,0, 12)

				UICorner_2.Parent = Picker_2
				UICorner_2.CornerRadius = UDim.new(1,0)

				UIPadding_1.Parent = ListFunctionColorPicker
				UIPadding_1.PaddingRight = UDim.new(0,10)
				
				local ColorpickBar = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local UIPadding_1 = Instance.new("UIPadding")
				local Color_1 = Instance.new("ImageLabel")
				local ColorCorner_1 = Instance.new("UICorner")
				local ColorSelection_1 = Instance.new("ImageLabel")
				local Hue_1 = Instance.new("ImageLabel")
				local HueCorner_1 = Instance.new("UICorner")
				local HueGradient_1 = Instance.new("UIGradient")
				local HueSelection_1 = Instance.new("ImageLabel")
				
				lak(ColorpickBar)

				ColorpickBar.Name = "ColorpickBar"
				ColorpickBar.Parent = ScreenGui
				ColorpickBar.BackgroundColor3 = Color3.fromRGB(217,217,217)
				ColorpickBar.BorderColor3 = Color3.fromRGB(0,0,0)
				ColorpickBar.BorderSizePixel = 0
				ColorpickBar.Size = UDim2.new(0, 120,0, 0)
				ColorpickBar.ClipsDescendants = true
				local targetX = Picker_1.AbsolutePosition.X - ColorpickBar.Parent.AbsolutePosition.X + Picker_1.Size.X.Offset - 100
				local targetY = Picker_1.AbsolutePosition.Y - ColorpickBar.Parent.AbsolutePosition.Y + Picker_1.Size.Y.Offset - 20
				ColorpickBar.Position = UDim2.new(0, targetX, 0, targetY)
				
				addToTheme('Back', ColorpickBar)

				UICorner_1.Parent = ColorpickBar
				UICorner_1.CornerRadius = UDim.new(0, 6)

				UIStroke_1.Parent = ColorpickBar
				UIStroke_1.Thickness = 1
				UIStroke_1.Transparency = 1

				UIPadding_1.Parent = ColorpickBar
				UIPadding_1.PaddingBottom = UDim.new(0,5)
				UIPadding_1.PaddingLeft = UDim.new(0,10)
				UIPadding_1.PaddingRight = UDim.new(0,10)
				UIPadding_1.PaddingTop = UDim.new(0,5)

				Color_1.Name = "Color"
				Color_1.Parent = ColorpickBar
				Color_1.AnchorPoint = Vector2.new(0, 0)
				Color_1.BackgroundColor3 = Color3.fromRGB(39,39,39)
				Color_1.Position = UDim2.new(0, 0,0, 25)
				Color_1.Size = UDim2.new(0, 80,0, 80)
				Color_1.ZIndex = 10
				Color_1.Image = "rbxassetid://4155801252"

				ColorCorner_1.Name = "ColorCorner"
				ColorCorner_1.Parent = Color_1
				ColorCorner_1.CornerRadius = UDim.new(0,3)

				ColorSelection_1.Name = "ColorSelection"
				ColorSelection_1.Parent = Color_1
				ColorSelection_1.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorSelection_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ColorSelection_1.BackgroundTransparency = 1
				ColorSelection_1.Size = UDim2.new(0, 12,0, 12)
				ColorSelection_1.Image = "http://www.roblox.com/asset/?id=4805639000"
				ColorSelection_1.ScaleType = Enum.ScaleType.Fit

				Hue_1.Name = "Hue"
				Hue_1.Parent = ColorpickBar
				Hue_1.AnchorPoint = Vector2.new(0, 0)
				Hue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Hue_1.Position = UDim2.new(0.47, 0,0, 25)
				Hue_1.Size = UDim2.new(0, 10,0, 80)

				HueCorner_1.Name = "HueCorner"
				HueCorner_1.Parent = Hue_1
				HueCorner_1.CornerRadius = UDim.new(1,0)

				HueGradient_1.Name = "HueGradient"
				HueGradient_1.Parent = Hue_1
				HueGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.2, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 4))}
				HueGradient_1.Rotation = 270

				HueSelection_1.Name = "HueSelection"
				HueSelection_1.Parent = Hue_1
				HueSelection_1.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				HueSelection_1.BackgroundTransparency = 1
				HueSelection_1.Position = UDim2.new(0.5, 0,1, 0)
				HueSelection_1.Size = UDim2.new(0, 12,0, 12)
				HueSelection_1.Image = "http://www.roblox.com/asset/?id=4805639000"
				
				local TitleColorPicker = Instance.new("TextLabel")

				TitleColorPicker.Name = "TitleColorPicker"
				TitleColorPicker.Parent = ColorpickBar
				TitleColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TitleColorPicker.BackgroundTransparency = 1.000
				TitleColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TitleColorPicker.BorderSizePixel = 0
				TitleColorPicker.Size = UDim2.new(1, 0, 0, 27)
				TitleColorPicker.Font = Enum.Font.GothamBold
				TitleColorPicker.Text = Title
				TitleColorPicker.TextColor3 = Color3.fromRGB(0, 0, 0)
				TitleColorPicker.TextSize = 12.000
				TitleColorPicker.TextXAlignment = Enum.TextXAlignment.Left
				
				addToTheme('Title', TitleColorPicker)
				
				local BoxColor = Instance.new("Frame")
				local Hax_1 = Instance.new("Frame")
				local BarValueHax_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_11 = Instance.new("UIStroke")
				local TextLabel_1 = Instance.new("TextBox")
				local TextLabel_2 = Instance.new("TextLabel")
				local UIListLayoutBoxColor_1 = Instance.new("UIListLayout")
				local Red_1 = Instance.new("Frame")
				local BarValueRed_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UIStroke_2 = Instance.new("UIStroke")
				local TextLabel_3 = Instance.new("TextBox")
				local TextLabel_4 = Instance.new("TextLabel")
				local Green_1 = Instance.new("Frame")
				local BarValueGreen_1 = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local UIStroke_3 = Instance.new("UIStroke")
				local TextLabel_5 = Instance.new("TextBox")
				local TextLabel_6 = Instance.new("TextLabel")
				local Blue_1 = Instance.new("Frame")
				local BarValueBlue_1 = Instance.new("Frame")
				local UICorner_4 = Instance.new("UICorner")
				local UIStroke_4 = Instance.new("UIStroke")
				local TextLabel_7 = Instance.new("TextBox")
				local TextLabel_8 = Instance.new("TextLabel")

				BoxColor.Name = "BoxColor"
				BoxColor.Parent = ColorpickBar
				BoxColor.AnchorPoint = Vector2.new(1, 0)
				BoxColor.BackgroundColor3 = Color3.fromRGB(255,255,255)
				BoxColor.BackgroundTransparency = 1
				BoxColor.BorderColor3 = Color3.fromRGB(0,0,0)
				BoxColor.BorderSizePixel = 0
				BoxColor.Position = UDim2.new(1, 0,0, 25)
				BoxColor.Size = UDim2.new(0, 80,0, 80)

				Hax_1.Name = "Hax"
				Hax_1.Parent = BoxColor
				Hax_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Hax_1.BackgroundTransparency = 1
				Hax_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Hax_1.BorderSizePixel = 0
				Hax_1.Size = UDim2.new(1, 0,0, 21)

				BarValueHax_1.Name = "BarValueHax"
				BarValueHax_1.Parent = Hax_1
				BarValueHax_1.AnchorPoint = Vector2.new(0, 0.5)
				BarValueHax_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
				BarValueHax_1.BackgroundTransparency = 1
				BarValueHax_1.BorderColor3 = Color3.fromRGB(0,0,0)
				BarValueHax_1.BorderSizePixel = 0
				BarValueHax_1.Position = UDim2.new(0, 0,0.5, 0)
				BarValueHax_1.Size = UDim2.new(0.600000024, 0,0, 15)

				UICorner_1.Parent = BarValueHax_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				UIStroke_11.Parent = BarValueHax_1
				UIStroke_11.Thickness = 1
				UIStroke_11.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_11)

				TextLabel_1.Name = "TextLabel"
				TextLabel_1.Parent = BarValueHax_1
				TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_1.BackgroundTransparency = 1
				TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_1.BorderSizePixel = 0
				TextLabel_1.Size = UDim2.new(1, 0,1, 0)
				TextLabel_1.Font = Enum.Font.Gotham
				TextLabel_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextLabel_1.PlaceholderText = "#FFFFFF"
				TextLabel_1.Text = "#FFFFFF"
				TextLabel_1.TextSize = 9
				TextLabel_1.TextTruncate = Enum.TextTruncate.AtEnd
				
				addToTheme('Title', TextLabel_1)

				TextLabel_2.Parent = Hax_1
				TextLabel_2.AnchorPoint = Vector2.new(1, 0.5)
				TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_2.BackgroundTransparency = 1
				TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_2.BorderSizePixel = 0
				TextLabel_2.Position = UDim2.new(0.980000019, 0,0.5, 0)
				TextLabel_2.Size = UDim2.new(0, 20,0, 20)
				TextLabel_2.Font = Enum.Font.Gotham
				TextLabel_2.Text = "Hax"
				TextLabel_2.TextSize = 9
				TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
				
				addToTheme('Title', TextLabel_2)

				UIListLayoutBoxColor_1.Name = "UIListLayoutBoxColor"
				UIListLayoutBoxColor_1.Parent = BoxColor
				UIListLayoutBoxColor_1.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayoutBoxColor_1.VerticalAlignment = Enum.VerticalAlignment.Center

				Red_1.Name = "Red"
				Red_1.Parent = BoxColor
				Red_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Red_1.BackgroundTransparency = 1
				Red_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Red_1.BorderSizePixel = 0
				Red_1.LayoutOrder = 1
				Red_1.Size = UDim2.new(1, 0,0, 21)

				BarValueRed_1.Name = "BarValueRed"
				BarValueRed_1.Parent = Red_1
				BarValueRed_1.AnchorPoint = Vector2.new(0, 0.5)
				BarValueRed_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
				BarValueRed_1.BackgroundTransparency = 1
				BarValueRed_1.BorderColor3 = Color3.fromRGB(0,0,0)
				BarValueRed_1.BorderSizePixel = 0
				BarValueRed_1.Position = UDim2.new(0, 0,0.5, 0)
				BarValueRed_1.Size = UDim2.new(0.600000024, 0,0, 15)

				UICorner_2.Parent = BarValueRed_1
				UICorner_2.CornerRadius = UDim.new(1,0)

				UIStroke_2.Parent = BarValueRed_1
				UIStroke_2.Thickness = 1
				UIStroke_2.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_2)

				TextLabel_3.Name = "TextLabel"
				TextLabel_3.Parent = BarValueRed_1
				TextLabel_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_3.BackgroundTransparency = 1
				TextLabel_3.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_3.BorderSizePixel = 0
				TextLabel_3.Size = UDim2.new(1, 0,1, 0)
				TextLabel_3.Font = Enum.Font.Gotham
				TextLabel_3.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextLabel_3.PlaceholderText = "255"
				TextLabel_3.Text = "255"
				TextLabel_3.TextSize = 9
				TextLabel_3.TextTruncate = Enum.TextTruncate.AtEnd
				
				addToTheme('Title', TextLabel_3)

				TextLabel_4.Parent = Red_1
				TextLabel_4.AnchorPoint = Vector2.new(1, 0.5)
				TextLabel_4.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_4.BackgroundTransparency = 1
				TextLabel_4.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_4.BorderSizePixel = 0
				TextLabel_4.Position = UDim2.new(0.980000019, 0,0.5, 0)
				TextLabel_4.Size = UDim2.new(0, 20,0, 20)
				TextLabel_4.Font = Enum.Font.Gotham
				TextLabel_4.Text = "Red"
				TextLabel_4.TextSize = 9
				TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
				
				addToTheme('Title', TextLabel_4)

				Green_1.Name = "Green"
				Green_1.Parent = BoxColor
				Green_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Green_1.BackgroundTransparency = 1
				Green_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Green_1.BorderSizePixel = 0
				Green_1.LayoutOrder = 2
				Green_1.Size = UDim2.new(1, 0,0, 21)

				BarValueGreen_1.Name = "BarValueGreen"
				BarValueGreen_1.Parent = Green_1
				BarValueGreen_1.AnchorPoint = Vector2.new(0, 0.5)
				BarValueGreen_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
				BarValueGreen_1.BackgroundTransparency = 1
				BarValueGreen_1.BorderColor3 = Color3.fromRGB(0,0,0)
				BarValueGreen_1.BorderSizePixel = 0
				BarValueGreen_1.Position = UDim2.new(0, 0,0.5, 0)
				BarValueGreen_1.Size = UDim2.new(0.600000024, 0,0, 15)

				UICorner_3.Parent = BarValueGreen_1
				UICorner_3.CornerRadius = UDim.new(1,0)

				UIStroke_3.Parent = BarValueGreen_1
				UIStroke_3.Thickness = 1
				UIStroke_3.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_3)

				TextLabel_5.Name = "TextLabel"
				TextLabel_5.Parent = BarValueGreen_1
				TextLabel_5.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_5.BackgroundTransparency = 1
				TextLabel_5.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_5.BorderSizePixel = 0
				TextLabel_5.Size = UDim2.new(1, 0,1, 0)
				TextLabel_5.Font = Enum.Font.Gotham
				TextLabel_5.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextLabel_5.PlaceholderText = "255"
				TextLabel_5.Text = "255"
				TextLabel_5.TextSize = 9
				TextLabel_5.TextTruncate = Enum.TextTruncate.AtEnd
				
				addToTheme('Title', TextLabel_5)

				TextLabel_6.Parent = Green_1
				TextLabel_6.AnchorPoint = Vector2.new(1, 0.5)
				TextLabel_6.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_6.BackgroundTransparency = 1
				TextLabel_6.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_6.BorderSizePixel = 0
				TextLabel_6.Position = UDim2.new(0.980000019, 0,0.5, 0)
				TextLabel_6.Size = UDim2.new(0, 20,0, 20)
				TextLabel_6.Font = Enum.Font.Gotham
				TextLabel_6.Text = "Green"
				TextLabel_6.TextSize = 9
				TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
				
				addToTheme('Title', TextLabel_6)

				Blue_1.Name = "Blue"
				Blue_1.Parent = BoxColor
				Blue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Blue_1.BackgroundTransparency = 1
				Blue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Blue_1.BorderSizePixel = 0
				Blue_1.LayoutOrder = 3
				Blue_1.Size = UDim2.new(1, 0,0, 21)

				BarValueBlue_1.Name = "BarValueBlue"
				BarValueBlue_1.Parent = Blue_1
				BarValueBlue_1.AnchorPoint = Vector2.new(0, 0.5)
				BarValueBlue_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
				BarValueBlue_1.BackgroundTransparency = 1
				BarValueBlue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				BarValueBlue_1.BorderSizePixel = 0
				BarValueBlue_1.Position = UDim2.new(0, 0,0.5, 0)
				BarValueBlue_1.Size = UDim2.new(0.600000024, 0,0, 15)

				UICorner_4.Parent = BarValueBlue_1
				UICorner_4.CornerRadius = UDim.new(1,0)

				UIStroke_4.Parent = BarValueBlue_1
				UIStroke_4.Thickness = 1
				UIStroke_4.Transparency = 0.75
				
				addToTheme('UIStroke', UIStroke_4)

				TextLabel_7.Name = "TextLabel"
				TextLabel_7.Parent = BarValueBlue_1
				TextLabel_7.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_7.BackgroundTransparency = 1
				TextLabel_7.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_7.BorderSizePixel = 0
				TextLabel_7.Size = UDim2.new(1, 0,1, 0)
				TextLabel_7.Font = Enum.Font.Gotham
				TextLabel_7.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextLabel_7.PlaceholderText = "255"
				TextLabel_7.Text = "255"
				TextLabel_7.TextSize = 9
				TextLabel_7.TextTruncate = Enum.TextTruncate.AtEnd
				
				addToTheme('Title', TextLabel_7)

				TextLabel_8.Parent = Blue_1
				TextLabel_8.AnchorPoint = Vector2.new(1, 0.5)
				TextLabel_8.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_8.BackgroundTransparency = 1
				TextLabel_8.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_8.BorderSizePixel = 0
				TextLabel_8.Position = UDim2.new(0.980000019, 0,0.5, 0)
				TextLabel_8.Size = UDim2.new(0, 20,0, 20)
				TextLabel_8.Font = Enum.Font.Gotham
				TextLabel_8.Text = "Blue"
				TextLabel_8.TextSize = 9
				TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
				
				addToTheme('Title', TextLabel_8)
				
				local Shower = Instance.new("Frame")
				local UICornerShow = Instance.new("UICorner")
				local GlowDotShow = Instance.new("ImageLabel")

				Shower.Name = "Shower"
				Shower.Parent = ColorpickBar
				Shower.AnchorPoint = Vector2.new(1, 0)
				Shower.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				Shower.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Shower.BorderSizePixel = 0
				Shower.Position = UDim2.new(1, 0, 0.0500000007, 0)
				Shower.Size = UDim2.new(0, 40, 0, 15)

				UICornerShow.CornerRadius = UDim.new(1, 0)
				UICornerShow.Name = "UICornerShow"
				UICornerShow.Parent = Shower

				GlowDotShow.Name = "GlowDotShow"
				GlowDotShow.Parent = Shower
				GlowDotShow.AnchorPoint = Vector2.new(0.5, 0.5)
				GlowDotShow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				GlowDotShow.BackgroundTransparency = 1.000
				GlowDotShow.BorderColor3 = Color3.fromRGB(0, 0, 0)
				GlowDotShow.BorderSizePixel = 0
				GlowDotShow.Position = UDim2.new(0.5, 0, 0.5, 0)
				GlowDotShow.Size = UDim2.new(1.25, 0, 1.5, 0)
				GlowDotShow.Image = "rbxassetid://105506802034513"
				GlowDotShow.ImageColor3 = Color3.fromRGB(255, 0, 0)
				GlowDotShow.ImageTransparency = 0.200
				
				local Click = click(ColorPicker)
				local ClickColor = click(Color_1)
				local ClickHue = click(Hue_1)
				local isopen = false
				
				local ColorH, ColorS, ColorV = 1, 1, 1
				local lastColorH = -1
				local ColorInput = nil
				local HueInput = nil
				local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
				local lastColor = nil
				local ColorInput = nil
				local HueInput = nil
				local isTouchDevice = U.TouchEnabled
				
				local function open()
					local targetX = Picker_1.AbsolutePosition.X - ColorpickBar.Parent.AbsolutePosition.X + Picker_1.Size.X.Offset - 145
					local targetY = Picker_1.AbsolutePosition.Y - ColorpickBar.Parent.AbsolutePosition.Y + Picker_1.Size.Y.Offset - 50
					tw({v = ColorpickBar, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 200,0, 125), Position = UDim2.new(0, targetX, 0, targetY)}}):Play()
					tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 0.95}}):Play()
				end
				local function close()
					isopen = false
					tw({v = ColorpickBar, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 200,0, 0)}}):Play()
					tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 1}}):Play()
				end
				
				U.InputBegan:Connect(function(A)
					if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
						local B, C = ColorpickBar.AbsolutePosition, ColorpickBar.AbsoluteSize
						if game:GetService "Players".LocalPlayer:GetMouse().X < B.X or game:GetService "Players".LocalPlayer:GetMouse().X > B.X + C.X or game:GetService "Players".LocalPlayer:GetMouse().Y < (B.Y - 20 - 1) or game:GetService "Players".LocalPlayer:GetMouse().Y > B.Y + C.Y then
							close()
						end
					end
				end)
				
				Click.MouseButton1Click:Connect(function()
					isopen = not isopen
					if isopen then
						open()
					else
						close()
					end
				end)
				
				local function UpdateColorPicker(nope)
					Picker_1.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					GlowDot_1.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color_1.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					
					Shower.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					GlowDotShow.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)

					local r, g, b = Picker_1.BackgroundColor3.R * 255, Picker_1.BackgroundColor3.G * 255, Picker_1.BackgroundColor3.B * 255

					TextLabel_3.Text = tostring(math.floor(r))
					TextLabel_5.Text = tostring(math.floor(g))
					TextLabel_7.Text = tostring(math.floor(b))

					local hex = string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
					TextLabel_1.Text = hex

					ColorH, ColorS, ColorV = Color3.toHSV(Picker_1.BackgroundColor3)

					if ColorS ~= 0 and ColorV ~= 0 then
						tw({v = ColorSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)}}):Play()
					end
					if lastColorH ~= ColorH and ColorS ~= 0 and ColorV ~= 0 and ColorS ~= 255 and ColorV ~= 255 then
						lastColorH = ColorH
						tw({v = HueSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.5, 0, 1 - ColorH, 0)}}):Play()
					end
					
					if lastColor ~= Picker_1.BackgroundColor3 then
						lastColor = Picker_1.BackgroundColor3
						pcall(Callback, math.floor(r), math.floor(g), math.floor(b))
					end
				end

				local function HexToRGB(hex)
					if hex:sub(1, 1) == "#" then
						hex = hex:sub(2)
					end

					if #hex == 6 then
						local r = tonumber(hex:sub(1, 2), 16) / 255
						local g = tonumber(hex:sub(3, 4), 16) / 255
						local b = tonumber(hex:sub(5, 6), 16) / 255
						return r, g, b
					else
						return 0, 0, 0
					end
				end

				local function UpdateColorFromText()
					local hex = TextLabel_1.Text:match("^#[%x]+$")
					if hex then
						local r, g, b = HexToRGB(hex)
						r = math.clamp(r, 0, 1)
						g = math.clamp(g, 0, 1)
						b = math.clamp(b, 0, 1)

						local h, s, v = Color3.toHSV(Color3.new(r, g, b))
						ColorH, ColorS, ColorV = h, s, v
						UpdateColorPicker(true)
					else
						local r = tonumber(TextLabel_3.Text) or 0
						local g = tonumber(TextLabel_5.Text) or 0
						local b = tonumber(TextLabel_7.Text) or 0

						r = math.clamp(r, 0, 255) / 255
						g = math.clamp(g, 0, 255) / 255
						b = math.clamp(b, 0, 255) / 255

						local h, s, v = Color3.toHSV(Color3.new(r, g, b))
						ColorH, ColorS, ColorV = h, s, v
						UpdateColorPicker(true)
					end
				end

				TextLabel_3.FocusLost:Connect(UpdateColorFromText)
				TextLabel_5.FocusLost:Connect(UpdateColorFromText)
				TextLabel_7.FocusLost:Connect(UpdateColorFromText)
				TextLabel_1.FocusLost:Connect(UpdateColorFromText)


				ColorH = 1 - (math.clamp(HueSelection_1.AbsolutePosition.Y - Hue_1.AbsolutePosition.Y, 0, Hue_1.AbsoluteSize.Y) / Hue_1.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection_1.AbsolutePosition.X - Color_1.AbsolutePosition.X, 0, Color_1.AbsoluteSize.X) / Color_1.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(ColorSelection_1.AbsolutePosition.Y - Color_1.AbsolutePosition.Y, 0, Color_1.AbsoluteSize.Y) / Color_1.AbsoluteSize.Y)

				Picker_1.BackgroundColor3 = Value
				Color_1.BackgroundColor3 = Value

				ClickColor.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then
							ColorInput:Disconnect()
						end

						ColorInput = game:GetService("RunService").RenderStepped:Connect(function()
							local ColorX = (math.clamp(Mouse.X - Color_1.AbsolutePosition.X, 0, Color_1.AbsoluteSize.X) /Color_1.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color_1.AbsolutePosition.Y, 0, Color_1.AbsoluteSize.Y) /Color_1.AbsoluteSize.Y)

							tw({v = ColorSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(ColorX, 0, ColorY, 0)}}):Play()
							ColorS = ColorX
							ColorV = 1 - ColorY

							UpdateColorPicker(true)
						end)
					end
				end)

				ClickColor.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then
							ColorInput:Disconnect()
						end
					end
				end)

				ClickHue.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then
							HueInput:Disconnect()
						end

						HueInput = game:GetService("RunService").RenderStepped:Connect(function()
							local HueY = (math.clamp(Mouse.Y - Hue_1.AbsolutePosition.Y, 0, Hue_1.AbsoluteSize.Y) /Hue_1.AbsoluteSize.Y)
							tw({v = HueSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.5, 0, HueY, 0)}}):Play()
							ColorH = 1 - HueY

							UpdateColorPicker(true)
						end)
					end
				end)

				ClickHue.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then
							HueInput:Disconnect()
						end
					end
				end)

				if isTouchDevice then
					Color_1.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							if ColorInput then
								ColorInput:Disconnect()
							end

							ColorInput = game:GetService("RunService").RenderStepped:Connect(function()
								local ColorX = (math.clamp(Mouse.X - Color_1.AbsolutePosition.X, 0, Color_1.AbsoluteSize.X) / Color_1.AbsoluteSize.X)
								local ColorY = (math.clamp(Mouse.Y - Color_1.AbsolutePosition.Y, 0, Color_1.AbsoluteSize.Y) / Color_1.AbsoluteSize.Y)

								ColorSelection_1.Position = UDim2.new(ColorX, 0, ColorY, 0)
								ColorS = ColorX
								ColorV = 1 - ColorY

								UpdateColorPicker(true)
							end)
						end
					end)

					Color_1.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							if ColorInput then
								ColorInput:Disconnect()
							end
						end
					end)

					Hue_1.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							if HueInput then
								HueInput:Disconnect()
							end

							HueInput = game:GetService("RunService").RenderStepped:Connect(function()
								local HueY = (math.clamp(Mouse.Y - Hue_1.AbsolutePosition.Y, 0, Hue_1.AbsoluteSize.Y) / Hue_1.AbsoluteSize.Y)

								HueSelection_1.Position = UDim2.new(0.48, 0, HueY, 0)
								ColorH = 1 - HueY

								UpdateColorPicker(true)
							end)
						end
					end)

					Hue_1.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							if HueInput then
								HueInput:Disconnect()
							end
						end
					end)
				end

				delay(0,function()
					ColorH, ColorS, ColorV = Color3.toHSV(Picker_1.BackgroundColor3)
					UpdateColorPicker(true)
					local r, g, b = Picker_1.BackgroundColor3.R * 255, Picker_1.BackgroundColor3.G * 255, Picker_1.BackgroundColor3.B * 255
					pcall(Callback, math.floor(r), math.floor(g), math.floor(b))
				end)

				local NewColor = {}

				function NewColor:SetColor(colorTable)
					local r = colorTable.R or Picker_1.BackgroundColor3.R * 255
					local g = colorTable.G or Picker_1.BackgroundColor3.G * 255
					local b = colorTable.B or Picker_1.BackgroundColor3.B * 255

					if r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
						local newColor = Color3.fromRGB(r, g, b)

						Picker_1.BackgroundColor3 = newColor
						Color_1.BackgroundColor3 = newColor

						local h, s, v = Color3.toHSV(newColor)
						ColorH, ColorS, ColorV = h, s, v

						ColorSelection_1.Position = UDim2.new(s, 0, 1 - v, 0)
						HueSelection_1.Position = UDim2.new(0.48, 0, 1 - h, 0)
						pcall(Callback, r, g, b)
					end
				end

				return NewColor
			end
			
			function Library.Func:CreateSpawn(option)
				local Title = option.Title
				local Desc = option.Desc or ''
				local TrueText = option.TrueText or 'Spawn'
				local FalseText = option.FalseText or 'Not Spawn'
				local Value = option.Value or false

				local SpawnF = background(
					gs(options.Side, PageLeft, PageRight),
					Title, Desc
				)
				SpawnF.TitleList.UIPadding.PaddingRight = UDim.new(0, 85)
				
				local ListFunctionStatus = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local Glow_1 = Instance.new("ImageLabel")
				local Glow_2 = Instance.new("ImageLabel")
				local Glow_3 = Instance.new("ImageLabel")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local Spawn_1 = Instance.new("Frame")
				local UIPageLayout_1 = Instance.new("UIPageLayout")
				local True_1 = Instance.new("TextLabel")
				local False_1 = Instance.new("TextLabel")

				ListFunctionStatus.Name = "ListFunctionStatus"
				ListFunctionStatus.Parent = SpawnF
				ListFunctionStatus.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ListFunctionStatus.BackgroundTransparency = 1
				ListFunctionStatus.BorderColor3 = Color3.fromRGB(0,0,0)
				ListFunctionStatus.BorderSizePixel = 0
				ListFunctionStatus.Size = UDim2.new(1, 0,1, 0)

				UIPadding_1.Parent = ListFunctionStatus
				UIPadding_1.PaddingRight = UDim.new(0,8)

				Glow_1.Name = "Glow"
				Glow_1.Parent = ListFunctionStatus
				Glow_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Glow_1.BackgroundTransparency = 1
				Glow_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Glow_1.BorderSizePixel = 0
				Glow_1.LayoutOrder = 1
				Glow_1.Size = UDim2.new(0, 20,0, 20)
				Glow_1.Image = "rbxassetid://105506802034513"
				Glow_1.ImageColor3 = Color3.fromRGB(52,255,21)
				Glow_1.ImageTransparency = 0.5

				Glow_2.Name = "Glow"
				Glow_2.Parent = Glow_1
				Glow_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Glow_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Glow_2.BackgroundTransparency = 1
				Glow_2.BorderColor3 = Color3.fromRGB(0,0,0)
				Glow_2.BorderSizePixel = 0
				Glow_2.Position = UDim2.new(0.5, 0,0.5, 0)
				Glow_2.Size = UDim2.new(0, 10,0, 10)
				Glow_2.Image = "rbxassetid://82506792944073"
				Glow_2.ImageColor3 = Color3.fromRGB(52,255,21)

				Glow_3.Name = "Glow"
				Glow_3.Parent = Glow_2
				Glow_3.AnchorPoint = Vector2.new(0.5, 0.5)
				Glow_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Glow_3.BackgroundTransparency = 1
				Glow_3.BorderColor3 = Color3.fromRGB(0,0,0)
				Glow_3.BorderSizePixel = 0
				Glow_3.Position = UDim2.new(0.5, 0,0.5, 0)
				Glow_3.Size = UDim2.new(0, 6,0, 6)
				Glow_3.Image = "rbxassetid://82506792944073"

				UIListLayout_1.Parent = ListFunctionStatus
				UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

				Spawn_1.Name = "Spawn"
				Spawn_1.Parent = ListFunctionStatus
				Spawn_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Spawn_1.BackgroundTransparency = 1
				Spawn_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Spawn_1.BorderSizePixel = 0
				Spawn_1.Size = UDim2.new(0, 50,0, 30)
				Spawn_1.ClipsDescendants = true

				UIPageLayout_1.Parent = Spawn_1
				UIPageLayout_1.EasingStyle = 'Exponential'
				UIPageLayout_1.VerticalAlignment = Enum.VerticalAlignment.Top
				UIPageLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIPageLayout_1.Circular = true
				UIPageLayout_1.TweenTime = 0.5
				--UIPageLayout_1.FillDirection = Enum.FillDirection.Vertical
				UIPageLayout_1.GamepadInputEnabled = false
				UIPageLayout_1.ScrollWheelInputEnabled = false
				UIPageLayout_1.TouchInputEnabled = false

				True_1.Name = "True"
				True_1.Parent = Spawn_1
				True_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				True_1.BackgroundTransparency = 1
				True_1.BorderColor3 = Color3.fromRGB(0,0,0)
				True_1.BorderSizePixel = 0
				True_1.Size = UDim2.new(1, 0,1, 0)
				True_1.Font = Enum.Font.GothamBold
				True_1.Text = TrueText
				True_1.TextColor3 = Color3.fromRGB(52,255,21)
				True_1.TextSize = 9
				True_1.TextWrapped = true

				False_1.Name = "False"
				False_1.Parent = Spawn_1
				False_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				False_1.BackgroundTransparency = 1
				False_1.BorderColor3 = Color3.fromRGB(0,0,0)
				False_1.BorderSizePixel = 0
				False_1.Size = UDim2.new(1, 0,1, 0)
				False_1.Font = Enum.Font.GothamBold
				False_1.Text = FalseText
				False_1.TextColor3 = Color3.fromRGB(255,0,0)
				False_1.TextSize = 9
				False_1.TextWrapped = true
				
				local function up(v)
					if v then
						UIPageLayout_1:JumpTo(True_1)
						tw({v = Glow_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(52, 255, 21)}}):Play()
						tw({v = Glow_2, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(52, 255, 21)}}):Play()
					else
						UIPageLayout_1:JumpTo(False_1)
						tw({v = Glow_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(255, 0, 0)}}):Play()
						tw({v = Glow_2, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageColor3 = Color3.fromRGB(255, 0, 0)}}):Play()
					end
				end
				
				delay(0.1, function()
					up(Value)
				end)
				
				local New = {}
				
				function New:Set(v)
					up(v)
				end
				
				return New
			end
			
			return Library.Func
		end
		
		return Library.Main
	end

	function Library.Tabs:CreateDialog(option)
		local Title = option.Title or ''
		local Desc = option.Desc or ''
		local Callback = option.Callback or function() end
		
		for i, v in pairs(BackGround_1:GetChildren()) do
			if v.Name == 'Dialog' then
				return
			end
		end
		
		local Dialog = Instance.new("Frame")
		local Frame_1 = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local TextLabel_1 = Instance.new("TextLabel")
		local Line_1 = Instance.new("Frame")
		local ListButton_1 = Instance.new("Frame")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local Button_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local TextLabel_2 = Instance.new("TextLabel")
		local UIGradient_1 = Instance.new("UIGradient")
		local Button_2 = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local TextLabel_3 = Instance.new("TextLabel")
		local UIGradient_2 = Instance.new("UIGradient")
		local Description_1 = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local UIStroke_1 = Instance.new("UIStroke")
		local ImageLabel_1 = Instance.new("ImageLabel")
		local ImageLabel_2 = Instance.new("Frame")
		local UICorner_5 = Instance.new("UICorner")
		local TextLabel_4 = Instance.new("TextLabel")
		local UIPadding_1 = Instance.new("UIPadding")

		Dialog.Name = "Dialog"
		Dialog.Parent = BackGround_1
		Dialog.BackgroundColor3 = themes[IsTheme]['Background Dialog']
		Dialog.BackgroundTransparency = 1
		Dialog.BorderColor3 = Color3.fromRGB(0,0,0)
		Dialog.BorderSizePixel = 0
		Dialog.Size = UDim2.new(1, 0,1, 0)
		
		local Esc = click(Dialog)
		
		addToTheme('Background Dialog', Dialog)

		Frame_1.Parent = Dialog
		Frame_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame_1.BackgroundColor3 = TabList_1.BackgroundColor3
		Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_1.BorderSizePixel = 0
		Frame_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Frame_1.Size = UDim2.new(0, 270,0, 170)
		
		addToTheme('Main', Frame_1)

		UICorner_1.Parent = Frame_1

		TextLabel_1.Parent = Frame_1
		TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.BackgroundTransparency = 1
		TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_1.BorderSizePixel = 0
		TextLabel_1.Size = UDim2.new(1, 0,0, 30)
		TextLabel_1.Font = Enum.Font.Gotham
		TextLabel_1.Text = Title
		TextLabel_1.TextSize = 14
		TextLabel_1.TextColor3 = Time_1.TextColor3
		
		addToTheme('Title', TextLabel_1)

		Line_1.Name = "Line"
		Line_1.Parent = TextLabel_1
		Line_1.AnchorPoint = Vector2.new(0.5, 1)
		Line_1.BackgroundColor3 = Frame_1.BackgroundColor3
		Line_1.BackgroundTransparency = 0.75
		Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Line_1.BorderSizePixel = 0
		Line_1.Position = UDim2.new(0.5, 0,1, 0)
		Line_1.Size = UDim2.new(0.899999976, 0,0, 1)
		
		addToTheme('Main', Line_1)

		ListButton_1.Name = "ListButton"
		ListButton_1.Parent = Frame_1
		ListButton_1.AnchorPoint = Vector2.new(0.5, 1)
		ListButton_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ListButton_1.BackgroundTransparency = 1
		ListButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ListButton_1.BorderSizePixel = 0
		ListButton_1.Position = UDim2.new(0.5, 0,1, 0)
		ListButton_1.Size = UDim2.new(0, 100,0, 50)

		UIListLayout_1.Parent = ListButton_1
		UIListLayout_1.Padding = UDim.new(0,5)
		UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		Button_1.Name = "Button"
		Button_1.Parent = ListButton_1
		Button_1.BackgroundColor3 = Color3.fromRGB(0,172,235)
		Button_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Button_1.BorderSizePixel = 0
		Button_1.Size = UDim2.new(0, 110,0, 30)
		Button_1.ClipsDescendants = true

		UICorner_2.Parent = Button_1
		UICorner_2.CornerRadius = UDim.new(0,11)

		TextLabel_2.Parent = Button_1
		TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.BackgroundTransparency = 41
		TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_2.BorderSizePixel = 0
		TextLabel_2.Size = UDim2.new(1, 0,1, 0)
		TextLabel_2.Font = Enum.Font.GothamBold
		TextLabel_2.Text = "Confirm"
		TextLabel_2.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.TextSize = 14

		UIGradient_1.Parent = Button_1
		UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 106, 255))}
		UIGradient_1.Rotation = 90

		Button_2.Name = "Button"
		Button_2.Parent = ListButton_1
		Button_2.BackgroundColor3 = Color3.fromRGB(211,0,0)
		Button_2.BorderColor3 = Color3.fromRGB(0,0,0)
		Button_2.BorderSizePixel = 0
		Button_2.Size = UDim2.new(0, 110,0, 30)
		Button_2.ClipsDescendants = true

		UICorner_3.Parent = Button_2
		UICorner_3.CornerRadius = UDim.new(0,11)

		TextLabel_3.Parent = Button_2
		TextLabel_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_3.BackgroundTransparency = 41
		TextLabel_3.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_3.BorderSizePixel = 0
		TextLabel_3.Size = UDim2.new(1, 0,1, 0)
		TextLabel_3.Font = Enum.Font.GothamBold
		TextLabel_3.Text = "Cancel"
		TextLabel_3.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_3.TextSize = 14

		UIGradient_2.Parent = Button_2
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(144, 0, 0))}
		UIGradient_2.Rotation = 90

		Description_1.Name = "Description"
		Description_1.Parent = Frame_1
		Description_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Description_1.BackgroundColor3 = themes[IsTheme]['Back']
		Description_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Description_1.BorderSizePixel = 0
		Description_1.Position = UDim2.new(0.5, 0,0.460000008, 0)
		Description_1.Size = UDim2.new(0, 220,0, 65)
		
		addToTheme('Back', Description_1)

		UICorner_4.Parent = Description_1

		UIStroke_1.Parent = Description_1
		UIStroke_1.Thickness = 1
		UIStroke_1.Transparency = 0.75

		ImageLabel_1.Parent = Description_1
		ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_1.BackgroundTransparency = 1
		ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_1.BorderSizePixel = 0
		ImageLabel_1.Position = UDim2.new(0.0299999993, 0,-0.0199999996, 0)
		ImageLabel_1.Size = UDim2.new(0, 20,0, 20)
		ImageLabel_1.Image = "rbxassetid://14921812394"
		ImageLabel_1.ImageColor3 = themes[IsTheme]['Icon']
		
		addToTheme('Icon', ImageLabel_1)

		ImageLabel_2.Name = "ImageLabel"
		ImageLabel_2.Parent = ImageLabel_1
		ImageLabel_2.AnchorPoint = Vector2.new(0, 0.5)
		ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255,0,0)
		ImageLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_2.BorderSizePixel = 0
		ImageLabel_2.Position = UDim2.new(0.699999988, 0,0.200000003, 0)
		ImageLabel_2.Size = UDim2.new(0, 7,0, 7)

		UICorner_5.Parent = ImageLabel_2
		UICorner_5.CornerRadius = UDim.new(1,0)

		TextLabel_4.Parent = Description_1
		TextLabel_4.AnchorPoint = Vector2.new(1, 1)
		TextLabel_4.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_4.BackgroundTransparency = 1
		TextLabel_4.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_4.BorderSizePixel = 0
		TextLabel_4.Position = UDim2.new(1, 0,1, 0)
		TextLabel_4.Size = UDim2.new(0, 180,1, 0)
		TextLabel_4.Font = Enum.Font.Gotham
		TextLabel_4.RichText = true
		TextLabel_4.Text = Desc
		TextLabel_4.TextSize = 12
		TextLabel_4.TextWrapped = true
		TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel_4.TextYAlignment = Enum.TextYAlignment.Top
		
		TextLabel_4.TextColor3 = Time_1.TextColor3

		addToTheme('Title', TextLabel_4)

		UIPadding_1.Parent = Description_1
		UIPadding_1.PaddingTop = UDim.new(0,5)
		
		tw({v = Dialog, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 0.2}}):Play()
		tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 250,0, 150)}}):Play()
		local close = tw({v = Dialog, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 1}})
		local close2 = tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 270,0, 170)}})
		local function closef(a, b)
			local p = tw({v = a, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 225,0, 30)}})
			p:Play()
			tw({v = b, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 0,0, 30)}}):Play()
			return p
		end
		local Confirm = click(Button_1)
		local Cancel = click(Button_2)
		
		Cancel.MouseButton1Click:Connect(function()
			closef(Button_2, Button_1).Completed:Wait()
			close:Play()
			close2:Play()
			close.Completed:Wait()
			Dialog:Destroy()
		end)
		
		Confirm.MouseButton1Click:Connect(function()
			pcall(Callback)
			Confirm:Destroy()
			closef(Button_1, Button_2).Completed:Wait()
			close:Play()
			close2:Play()
			close.Completed:Wait()
			Dialog:Destroy()
		end)
		
		Esc.MouseButton1Click:Connect(function()
			close:Play()
			close2:Play()
			close.Completed:Wait()
			Dialog:Destroy()
		end)
	end

	local Notification = Instance.new("Frame")
	local UIListLayoutNotify_1 = Instance.new("UIListLayout")

	Notification.Name = "Notification"
	Notification.Parent = ScreenGui
	Notification.AnchorPoint = Vector2.new(1, 1)
	Notification.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Notification.BackgroundTransparency = 1
	Notification.BorderColor3 = Color3.fromRGB(0,0,0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(0.99000001, 0,1, 0)
	Notification.Size = UDim2.new(0, 100,0.800000012, 0)

	UIListLayoutNotify_1.Name = "UIListLayoutNotify"
	UIListLayoutNotify_1.Parent = Notification
	UIListLayoutNotify_1.Padding = UDim.new(0,3)
	UIListLayoutNotify_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayoutNotify_1.SortOrder = Enum.SortOrder.LayoutOrder

	function Library.Tabs:CreateNotify(option)
		local Title = option.Title or 'Notification'
		local Icon = option.Icon or 14921843905
		local Time = option.Time or 5
		local NotifyTemple_1 = Instance.new("Frame")
		local UICornerNotify_1 = Instance.new("UICorner")
		local TextNotify_1 = Instance.new("Frame")
		local TextLabelNotify_1 = Instance.new("TextLabel")
		local UIPaddingNotify_1 = Instance.new("UIPadding")
		local IconNotify_1 = Instance.new("Frame")
		local UIPaddingNotify_2 = Instance.new("UIPadding")
		local iconNotify_1 = Instance.new("ImageLabel")
		
		NotifyTemple_1.Name = "NotifyTemple"
		NotifyTemple_1.Parent = Notification
		NotifyTemple_1.BackgroundColor3 = TabList_1.BackgroundColor3 
		NotifyTemple_1.BorderColor3 = Color3.fromRGB(0,0,0)
		NotifyTemple_1.BorderSizePixel = 0
		NotifyTemple_1.Size = UDim2.new(0, 0,0, 30)
		NotifyTemple_1.AnchorPoint = Vector2.new(0.5, 0.5)
		NotifyTemple_1.ClipsDescendants = true
		
		addToTheme('Main', NotifyTemple_1)

		UICornerNotify_1.Name = "UICornerNotify"
		UICornerNotify_1.Parent = NotifyTemple_1

		TextNotify_1.Name = "TextNotify"
		TextNotify_1.Parent = NotifyTemple_1
		TextNotify_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextNotify_1.BackgroundTransparency = 1
		TextNotify_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextNotify_1.BorderSizePixel = 0
		TextNotify_1.Size = UDim2.new(1, 0,1, 0)

		TextLabelNotify_1.Name = "TextLabelNotify"
		TextLabelNotify_1.Parent = TextNotify_1
		TextLabelNotify_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabelNotify_1.BackgroundTransparency = 1
		TextLabelNotify_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabelNotify_1.BorderSizePixel = 0
		TextLabelNotify_1.Size = UDim2.new(1, 0,1, 0)
		TextLabelNotify_1.Font = Enum.Font.Gotham
		TextLabelNotify_1.RichText = true
		TextLabelNotify_1.Text = Title
		TextLabelNotify_1.TextSize = 12
		TextLabelNotify_1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabelNotify_1.TextColor3 = Time_1.TextColor3
		
		addToTheme('Title', TextLabelNotify_1)

		UIPaddingNotify_1.Name = "UIPaddingNotify"
		UIPaddingNotify_1.Parent = TextNotify_1
		UIPaddingNotify_1.PaddingLeft = UDim.new(0,40)

		IconNotify_1.Name = "IconNotify"
		IconNotify_1.Parent = NotifyTemple_1
		IconNotify_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		IconNotify_1.BackgroundTransparency = 1
		IconNotify_1.BorderColor3 = Color3.fromRGB(0,0,0)
		IconNotify_1.BorderSizePixel = 0
		IconNotify_1.Size = UDim2.new(1, 0,1, 0)

		UIPaddingNotify_2.Name = "UIPaddingNotify"
		UIPaddingNotify_2.Parent = IconNotify_1
		UIPaddingNotify_2.PaddingLeft = UDim.new(0,10)

		iconNotify_1.Name = "iconNotify"
		iconNotify_1.Parent = IconNotify_1
		iconNotify_1.AnchorPoint = Vector2.new(0, 0.5)
		iconNotify_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		iconNotify_1.BackgroundTransparency = 1
		iconNotify_1.BorderColor3 = Color3.fromRGB(0,0,0)
		iconNotify_1.BorderSizePixel = 0
		iconNotify_1.Position = UDim2.new(0, 0,0.5, 0)
		iconNotify_1.Size = UDim2.new(0, 20,0, 20)
		iconNotify_1.Image = gl(Icon)
		iconNotify_1.ImageColor3 = Time_1.TextColor3
		
		addToTheme('Icon', iconNotify_1)
		
		task.spawn(function()
			for i = Time,1,-1 do
				TextLabelNotify_1.Text = Title .. ' - <font size="9"><b>[ ' .. i .. 's ]</b></font>'
				tw({v = NotifyTemple_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, TextLabelNotify_1.TextBounds.X + 50 ,0, 30)}}):Play()
				task.wait(1)
			end
			local p = tw({v = NotifyTemple_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 0,0, 30)}})
			p:Play()
			p.Completed:Wait()
			local j = tw({v = NotifyTemple_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 0,0, 0)}})
			j:Play()
			j.Completed:Wait()
			NotifyTemple_1:Destroy()
		end)
	end

	do
		Size_1.MouseButton1Down:Connect(function()
			R = true
		end)

		if not HAA then
			local AP, PAZ = BackGround_1.AbsolutePosition, BackGround_1.Parent.AbsoluteSize
			local NP = UDim2.new((AP.X / PAZ.X),
				BackGround_1.Position.X.Offset,
				(AP.Y / PAZ.Y),
				BackGround_1.Position.Y.Offset)

			BackGround_1.AnchorPoint = Vector2.new(0, 0)
			BackGround_1.Position = NP
			HAA = true
		end

		U.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				R = false
			end
		end)

		U.InputChanged:Connect(function(i)
			if R and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local nW = math.max(500, i.Position.X - BackGround_1.AbsolutePosition.X)
				local nH = math.max(200, i.Position.Y - BackGround_1.AbsolutePosition.Y)
				local nZ = UDim2.new(0, nW, 0, nH)
				tw({v = BackGround_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = nZ}}):Play()
			end
		end)
		
		lak2(BackGround_1, BackGround_1)
		local cTw
		local isclick = false
		
		local function changeTheme()
			if isclick then
				return
			end
			isclick = true
			if cTw then
				cTw:Cancel()
			end
			cTw = tw({v = ThemeIcon_1, t = 0.25, s = Enum.EasingStyle.Linear, d = "InOut", g = {Rotation = ThemeIcon_1.Rotation - 180}})
			cTw:Play()

			local Load = Instance.new("Frame")
			local TextLabel_1 = Instance.new("TextLabel")
			local LoadImage_1 = Instance.new("ImageLabel")

			Load.Name = "Load"
			Load.Parent = BackGround_1
			Load.BackgroundColor3 = Color3.fromRGB(0,0,0)
			Load.BackgroundTransparency = 1
			Load.BorderColor3 = Color3.fromRGB(0,0,0)
			Load.BorderSizePixel = 0
			Load.Size = UDim2.new(1, 0,1, 0)

			TextLabel_1.Parent = Load
			TextLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.Position = UDim2.new(0.5, 0,0.5, 0)
			TextLabel_1.Size = UDim2.new(0, 200,0, 50)
			TextLabel_1.Font = Enum.Font.GothamBold
			TextLabel_1.Text = "Loading"
			TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.TextSize = 12

			LoadImage_1.Name = "LoadImage"
			LoadImage_1.Parent = Load
			LoadImage_1.AnchorPoint = Vector2.new(0.5, 0.5)
			LoadImage_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			LoadImage_1.BackgroundTransparency = 1
			LoadImage_1.BorderColor3 = Color3.fromRGB(0,0,0)
			LoadImage_1.BorderSizePixel = 0
			LoadImage_1.Position = UDim2.new(0.5, 0,0.5, 0)
			LoadImage_1.Size = UDim2.new(0, 100,0, 100)
			LoadImage_1.Image = "rbxassetid://86678925156329"

			tw({v = Load, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 0.2}}):Play()
			tw({v = LoadImage_1, t = 5, s = Enum.EasingStyle.Linear, d = "Out", g = {Rotation = 720}}):Play()

			delay(.5, function()
				local tW = tw({v = Load, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 1}})
				tW:Play()
				tW.Completed:Wait()
				Load:Destroy()
				
				local themeNames = themes.index
				local currentThemeIndex = table.find(themeNames, HasChangeTheme)
				IsTheme = HasChangeTheme
				Library:setTheme(themes[themeNames[currentThemeIndex]])
				local nextThemeIndex = (currentThemeIndex % #themeNames) + 1
				HasChangeTheme = themeNames[nextThemeIndex]
				
				isclick = false
			end)
		end
		
		ThemeClick_1.MouseButton1Click:Connect(changeTheme)
		delay(0, changeTheme)
		
		local Frame = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local ImageLabel_1 = Instance.new("ImageLabel")

		Frame.Parent = ScreenGui
		Frame.AnchorPoint = Vector2.new(0.5, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.5, 0,0, 0)
		Frame.Size = UDim2.new(0, 70,0, 25)
		
		addToTheme('Main', Frame)

		UICorner_1.Parent = Frame
		UICorner_1.CornerRadius = UDim.new(1,0)

		ImageLabel_1.Parent = Frame
		ImageLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_1.BackgroundTransparency = 1
		ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_1.BorderSizePixel = 0
		ImageLabel_1.Position = UDim2.new(0.5, 0,0.5, 0)
		ImageLabel_1.Size = UDim2.new(0, 15,0, 15)
		ImageLabel_1.Image = "rbxassetid://14942474023"
		ImageLabel_1.ImageColor3 = Color3.fromRGB(0, 0, 0)
		
		addToTheme('Icon', ImageLabel_1)
		
		local Click = click(Frame)
		
		lak2(Click, Frame)
		
		local isopen = false
		local close = tw({v = BackGround_1, t = 0.25, s = Enum.EasingStyle.Linear, d = "InOut", g = {GroupTransparency = 1}})
		local function closeui()
			isopen = not isopen

			if isopen then
				close:Play()
				close.Completed:Wait()
				BackGround_1.Visible = false
			else
				if close then
					close:Cancel()
				end
				BackGround_1.Visible = true  
				local open = tw({v = BackGround_1, t = 0.25, s = Enum.EasingStyle.Linear, d = "InOut", g = {GroupTransparency = 0}})
				open:Play()
			end
		end

		Click.MouseButton1Click:Connect(closeui)

		U.InputBegan:Connect(function(i)
			if i.KeyCode == options.Keybind then
				local focusedTextBox = U:GetFocusedTextBox()

				if not focusedTextBox then
					closeui()
				end
			end
		end)
	end
	
	return Library.Tabs
end

return Library
--ใช้ต่อพ่อตาย
