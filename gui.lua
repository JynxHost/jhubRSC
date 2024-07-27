local guis = game:GetObjects("rbxassetid://18670191514")
local userInputService = game:GetService("UserInputService")



local buttonElement = {}
buttonElement.__index = buttonElement

function buttonElement.new(parent, properties, onClick)
	local self = {}
	self.parent = parent

	setmetatable(self, buttonElement)
	
	local element = guis.Button:Clone()
	
	self.element = element
	self.properties = properties or {}
	self.onClick = typeof(onClick) == "function" and onClick or onClick.onClick
	self:refresh()
	
	element.Parent = parent.tabMenu
	
	element.Content.MouseButton1Click:Connect(function()
		if self.onClick then
			self.onClick()
		end
	end)
	
	return self
end

function buttonElement:refresh()
	local element = self.element
	local properties = self.properties
	element.Content.Title.Text = properties.Title or "Unknown title"
	element.Content.Title.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
	element.Content.Icon.Image = properties.Icon or element.Content.Icon.Image
	element.Content.Icon.ImageColor3 = properties.IconTint or Color3.new(1, 1, 1)
end

function buttonElement:setProperty(name, value)
	local properties = self.properties
	properties[name] = value
	self:refresh()
end

function buttonElement:getProperty(name)
	local properties = self.properties
	return properties[name]
end



local headerElement = {}
headerElement.__index = headerElement

function headerElement.new(parent, properties)
	local self = {}
	self.parent = parent

	setmetatable(self, headerElement)

	local element = guis.Header:Clone()

	self.element = element
	self.properties = properties or {}
	self:refresh()

	element.Parent = parent.tabMenu

	return self
end

function headerElement:refresh()
	local element = self.element
	local properties = self.properties
	element.Text = properties.Text or "Unknown title"
	element.TextColor3 = properties.TextColor or Color3.new(1, 1, 1)
	element.TextTransparency = properties.TextTransparency or 0
	local height = (properties.height or 0) + ((properties.lines or 1) * 32)
	element.Size = UDim2.new(1, 0, 0, height)
	if properties.Font then
		element.Font = properties.Font
	else
		element.FontFace = properties.FontFace or Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	end
	element.RichText = properties.RichText or false
	element.TextScaled = properties.TextScaled or true
	element.TextWrapped = properties.TextWrapped or true
	element.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Center
	element.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
	element.TextStrokeColor3 = properties.TextStrokeColor or Color3.new(0, 0, 0)
	element.TextStrokeTransparency = properties.TextStrokeTransparency or 1
end

function headerElement:setProperty(name, value)
	local properties = self.properties
	properties[name] = value
	self:refresh()
end

function headerElement:getProperty(name)
	local properties = self.properties
	return properties[name]
end



local inputElement = {}
inputElement.__index = inputElement

function inputElement.new(parent, properties, onEnter)
	local self = {}
	self.parent = parent

	setmetatable(self, inputElement)

	local element = guis.Input:Clone()

	self.element = element
	self.properties = properties or {}
	self.onClick = typeof(onEnter) == "table" and onEnter.onClick
	self.onEnter = typeof(onEnter) == "function" and onEnter or onEnter.onEnter
	self.onFocusLost = typeof(onEnter) == "table" and onEnter.onFocusLost
	self.onChange = typeof(onEnter) == "table" and onEnter.onChange
	self:refresh()

	element.Parent = parent.tabMenu

	element.Content.MouseButton1Click:Connect(function()
		if self.onClick then
			self.onClick()
		end
	end)
	
	element.Content.InputText.FocusLost:Connect(function(enter)
		local value = element.Content.InputText.Text
		self.properties.Value = value
		if self.onEnter and enter then
			self.onEnter(value)
		end
		if self.onFocusLost then
			self.onFocusLost(value, enter)
		end
	end)
	
	element.Content.InputText.Changed:Connect(function(property)
		local value = element.Content.InputText.Text
		if property == "Text" then
			self.properties.Value = value
			if self.onChange then
				self.onChange(value)
			end
		end
	end)

	return self
end

function inputElement:refresh()
	local element = self.element
	local properties = self.properties
	element.Content.Title.Text = properties.Title or "Unknown title"
	element.Content.Title.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
	element.Content.InputText.PlaceholderText = properties.Placeholder or ""
	element.Content.InputText.TextColor3 = properties.InputColor or Color3.new(1, 1, 1)
	element.Content.InputText.PlaceholderColor3 = properties.PlaceholderColor or element.Content.InputText.TextColor3
	element.Content.InputText.Text = properties.Value or ""
end

function inputElement:setProperty(name, value)
	local properties = self.properties
	properties[name] = value
	self:refresh()
end

function inputElement:getProperty(name)
	local properties = self.properties
	return properties[name]
end

function inputElement:getValue()
	local properties = self.properties
	return properties.Value
end

function inputElement:setValue(value)
	local properties = self.properties
	properties.Value = value
	self:refresh()
end



local numberInputElement = {}
numberInputElement.__index = numberInputElement

function numberInputElement.new(parent, properties, onEnter)
	local self = {}
	self.parent = parent

	setmetatable(self, numberInputElement)

	local element = guis.Input:Clone()

	self.element = element
	self.properties = properties or {}
	self.onClick = typeof(onEnter) == "table" and onEnter.onClick
	self.onEnter = typeof(onEnter) == "function" and onEnter or onEnter.onEnter
	self.onFocusLost = typeof(onEnter) == "table" and onEnter.onFocusLost
	self:refresh()

	element.Parent = parent.tabMenu

	element.Content.MouseButton1Click:Connect(function()
		if self.onClick then
			self.onClick()
		end
	end)

	element.Content.InputText.FocusLost:Connect(function(enter)
		local value = tonumber(element.Content.InputText.Text)
		if value then
			if self.properties.MaximumValue and value > self.properties.MaximumValue then
				value = self.properties.MaximumValue
			end
			if self.properties.MinimumValue and value < self.properties.MinimumValue then
				value = self.properties.MinimumValue
			end
			self.properties.Value = value
			if self.onEnter and enter then
				self.onEnter(value)
			end
		end
		self:refresh()
		if self.onFocusLost then
			self.onFocusLost(value, enter)
		end
	end)

	return self
end

function numberInputElement:refresh()
	local element = self.element
	local properties = self.properties
	element.Content.Title.Text = properties.Title or "Unknown title"
	element.Content.Title.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
	element.Content.InputText.PlaceholderText = properties.Placeholder or ""
	element.Content.InputText.TextColor3 = properties.InputColor or Color3.new(1, 1, 1)
	element.Content.InputText.PlaceholderColor3 = properties.PlaceholderColor or element.Content.InputText.TextColor3
	element.Content.InputText.Text = properties.Value or ""
end

function numberInputElement:setProperty(name, value)
	local properties = self.properties
	properties[name] = value
	self:refresh()
end

function numberInputElement:getProperty(name)
	local properties = self.properties
	return properties[name]
end

function numberInputElement:getValue()
	local properties = self.properties
	return properties.Value
end

function numberInputElement:setValue(value)
	local properties = self.properties
	properties.Value = value
	self:refresh()
end



local toggleElement = {}
toggleElement.__index = toggleElement

function toggleElement.new(parent, properties, onChange)
	local self = {}
	self.parent = parent

	setmetatable(self, toggleElement)

	local element = guis.Toggle:Clone()

	self.element = element
	self.properties = properties or {}
	self.onChange = typeof(onChange) == "function" and onChange or onChange.onChange
	self.onClick = typeof(onChange) == "table" and onChange.onClick
	self:refresh()

	element.Parent = parent.tabMenu

	element.Content.MouseButton1Click:Connect(function()
		local value = not self.properties.Value
		self:setProperty("Value", value)
		if self.onChange then
			self.onChange(value)
		end
		if self.onClick then
			self.onClick()
		end
	end)

	return self
end

function toggleElement:refresh()
	local element = self.element
	local properties = self.properties
	element.Content.Title.Text = properties.Title or "Unknown title"
	element.Content.Title.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
	if properties.Value then
		element.Content.Switch.State.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
		element.Content.Switch.State.Position = UDim2.new(1, -30, 0, 0)
	else
		element.Content.Switch.State.BackgroundColor3 = Color3.new(1, 0.5, 0.5)
		element.Content.Switch.State.Position = UDim2.new(0, 0, 0, 0)
	end
end

function toggleElement:setProperty(name, value)
	local properties = self.properties
	properties[name] = value
	self:refresh()
end

function toggleElement:getProperty(name)
	local properties = self.properties
	return properties[name]
end



local tab = {}
tab.__index = tab

function tab.new(parent, name, icon)
	local self = {}
	self.parent = parent

	setmetatable(self, tab)
	
	local menuContent = parent.parent.object.Content.Menu.Menu
	
	local side = guis.TemplateSide:Clone()
	side.Parent = parent.parent.object.Content.Menu.Sidebar
	self.side = side
	
	local tabMenu = guis.TemplateMenu:Clone()
	tabMenu.Parent = menuContent
	self.tabMenu = tabMenu
	
	tabMenu.Visible = #menuContent:GetChildren() == 1
	side.MouseButton1Click:Connect(function()
		for _, a in ipairs(menuContent:GetChildren()) do
			a.Visible = a == tabMenu
		end
	end)

	self:setName(name)
	if icon then
		self:setIcon(icon)
	end

	return self
end

function tab:setName(name)
	self.side.Title.Text = name
end

function tab:setIcon(icon)
	self.side.Icon.Image = icon
end

function tab:newButton(properties, callbacks)
	return buttonElement.new(self, properties, callbacks)
end

function tab:newInput(properties, callbacks)
	return inputElement.new(self, properties, callbacks)
end

function tab:newNumberInput(properties, callbacks)
	return numberInputElement.new(self, properties, callbacks)
end

function tab:newToggle(properties, callbacks)
	return toggleElement.new(self, properties, callbacks)
end

function tab:newHeader(properties)
	return headerElement.new(self, properties)
end



local menu = {}
menu.__index = menu

function menu.new(parent)
	local self = {}
	self.parent = parent
	
	setmetatable(self, menu)
	
	return self
end

function menu:addTab(name, icon)
	local newTab = tab.new(self, name, icon)
	
	return newTab
end



local module = {}
module.__index = module

module.new = function(authCallback)
	local guiHolder = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
	guiHolder.ResetOnSpawn = false
	guiHolder.IgnoreGuiInset = true

	local mainWindow = guis.MainWindow:Clone()
	mainWindow.Parent = guiHolder

	--Particle Handler
	task.spawn(function()
		local res = Vector2.new(600, 400)
		local size = 0.025
		local count = 64
		local speed = 50
		local maxdist = 150
		local maxtransparency = 0.9
		local unslow = 0.2

		local ratio = res.Y / res.X
		local dots = {}
		local mouse = game:GetService("Players").LocalPlayer:GetMouse()

		local function randomVel(dir)
			return (math.random(1, 5)) * (dir or ((math.random(0, 1) * 2) - 1)) * speed
		end

		local function makeDot()
			local dot = Instance.new("Frame", mainWindow.ParticleHolder)
			dot.Size = UDim2.new(ratio * size, 0, size, 0)
			dot.AnchorPoint = Vector2.one * 0.5
			dot.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
			dot.ZIndex = 0
			dot.BackgroundColor3 = Color3.new(1, 1, 1)
			dot:SetAttribute("velX", randomVel())
			dot:SetAttribute("velY", randomVel())
			local corner = Instance.new("UICorner", dot)
			corner.CornerRadius = UDim.new(1, 0)
			table.insert(dots, dot)
		end

		local function calcDist(pos1, pos2)
			return math.sqrt((pos2.Y - pos1.Y)^2 + (pos2.X - pos1.X)^2)
		end

		for _ = 1, count do
			makeDot()
		end

		local runService = game:GetService("RunService")

		runService.RenderStepped:Connect(function(dT)
			for i, dot in ipairs(dots) do
				local x = dot.Position.X.Scale * res.X
				local y = dot.Position.Y.Scale * res.Y
				local dist = calcDist(Vector2.new(mouse.X, mouse.Y), Vector2.new(dot.AbsolutePosition.X, dot.AbsolutePosition.Y))
				x = x + dot:GetAttribute("velX") * dT * math.min((dist / maxdist) + unslow, 1)
				y = y +dot:GetAttribute("velY") * dT * math.min((dist / maxdist) + unslow, 1)
				if x < 0 then
					dot:SetAttribute("velX", randomVel(1))
					x = 0
				end
				if x > res.X then
					dot:SetAttribute("velX", randomVel(-1))
					x = res.X
				end
				if y < 0 then
					dot:SetAttribute("velY", randomVel(1))
					y = 0
				end
				if y > res.Y then
					dot:SetAttribute("velY", randomVel(-1))
					y = res.Y
				end
				dot.Position = UDim2.new(x / res.X, 0, y / res.Y, 0)
				dist = calcDist(Vector2.new(mouse.X, mouse.Y), Vector2.new(dot.AbsolutePosition.X, dot.AbsolutePosition.Y))
				dot.BackgroundTransparency = math.min(dist / maxdist, maxtransparency)
			end
		end)
	end)
	
	local auth = mainWindow.Content.Auth
	local check = auth.Check
	local copy = auth.Copy
	local keyInput = auth.KeyInput
	
	local self = {}
	self.object = mainWindow
	self.changeAuthMessage = function(message)
		check.Text = message
	end
	
	setmetatable(self, module)
	
	local auto = authCallback("auto")
	if auto then
		self:loadMenu()
	else
		check.Text = "Check Key"
		copy.MouseButton1Click:Connect(function()
			authCallback("copylink")
		end)
		check.MouseButton1Click:Connect(function()
			if check.Text == "Check Key" and authCallback("check", keyInput.Text) then
				self:loadMenu()
			end
		end)
	end
	
	mainWindow.Close.Modal = true
	mainWindow.Close.MouseButton1Click:Connect(function()
		if self.object.Content.Auth.Visible then
			guiHolder:Destroy()
		else
			guiHolder.Enabled = false
		end
	end)
	
	local dragging = false
	local dragStart
	local guiStart
	
	mainWindow.Title.InputBegan:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inputObject.Position
			guiStart = mainWindow.Position
			inputObject.Changed:Connect(function()
				if inputObject.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	userInputService.InputChanged:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local delta = inputObject.Position - dragStart
				mainWindow.Position = guiStart + UDim2.new(0, delta.X, 0, delta.Y)
			end
		end
	end)
	
	userInputService.InputBegan:Connect(function(inputObject)
		if inputObject.KeyCode == Enum.KeyCode.Home then
			guiHolder.Enabled = not guiHolder.Enabled
		end
	end)
	
	self.menu = menu.new(self)
	
	return self
end

function module:loadMenu()
	self.object.Content.Auth.Visible = false
	self.object.Content.Menu.Visible = true
	self.object.Title.Text = "JynxHub Gui"
end

local frontend = {}
frontend.authCallback = function(message, arg)
	if message == "auto" then
		--check for automatic key
        return false
	elseif message == "copylink" then
		--copy link to clipboard
	elseif message == "check" then
		--return auth.verify(arg)
        return false
	end
end

frontend.win = module.new(function(...)
    return frontend.authCallback(...)
end)

return frontend
