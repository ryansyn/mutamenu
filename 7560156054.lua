-- Services
local UIS = game:GetService("UserInputService");
local RS = game:GetService("ReplicatedStorage");
local PS = game:GetService("Players");
local LS = game:GetService("Lighting");
local TS = game:GetService("TweenService");

local player = PS.LocalPlayer;

-- States
local gui_state = {
	["gui_open"] = true,
	["gui_debounce"] = false
};

local user_config = {
	["autoclicker"] = false,
    ["autorebirth"] = false
};

local previous_guis = {};

-- Create Gui
local components = {
	["createCorner"] = function(element)
		local ui_corner = Instance.new("UICorner", element);
		ui_corner.CornerRadius = UDim.new(0, 4);
	end,

	["createGridLayout"] = function(element)
		local ui_grid_layout = Instance.new("UIGridLayout", element);
		ui_grid_layout.CellPadding = UDim2.new(0, 6, 0, 6);
		ui_grid_layout.CellSize = UDim2.new(1, -1, 0, 32);
	end,

	["createCategoryButton"] = function(element, button_name, button_text)
		local button = Instance.new("TextButton", element);
		button.Name = button_name;
		button.BackgroundColor3 = Color3.new(40/255, 40/255, 40/255);
		button.BackgroundTransparency = 0.6;
		button.Font = Enum.Font.GothamSemiBold;
		button.TextColor3 = Color3.new(200/255, 200/255, 200/255);
		button.TextSize = 14;
		button.Text = button_text;
	end,

	["createOptionButton"] = function(element, button_name, button_text)
		local button = Instance.new("TextButton", element);
		button.Name = button_name;
		button.AutoButtonColor = false;
		button.BackgroundColor3 = Color3.new(40/255, 40/255, 40/255);
		button.BackgroundTransparency = 0.6;
		button.Text = "";
		local button_text_label = Instance.new("TextLabel", button);
		button_text_label.Name = "button_text";
		button_text_label.AnchorPoint = Vector2.new(0, 0.5);
		button_text_label.BackgroundTransparency = 1;
		button_text_label.Position = UDim2.new(0, 12, 0.5, 0);
		button_text_label.Size = UDim2.new(0, 200, 0, 20);
		button_text_label.Font = Enum.Font.GothamSemibold;
		button_text_label.TextColor3 = Color3.new(200/255, 200/255, 200/255);
		button_text_label.TextSize = 14;
		button_text_label.TextXAlignment = Enum.TextXAlignment.Left;
		button_text_label.Text = button_text;
		local button_status_label = Instance.new("TextLabel", button);
		button_status_label.Name = "button_status";
		button_status_label.AnchorPoint = Vector2.new(1, 0.5);
		button_status_label.BackgroundTransparency = 1;
		button_status_label.Position = UDim2.new(1, -12, 0.5, 0);
		button_status_label.Size = UDim2.new(0, 60, 0, 20);
		button_status_label.Font = Enum.Font.GothamSemibold;
		button_status_label.TextColor3 = Color3.new(200/255, 200/255, 200/255);
		button_status_label.TextSize = 14;
		button_status_label.TextXAlignment = Enum.TextXAlignment.Right;
		button_status_label.Text = "off";
		local ui_corner = Instance.new("UICorner", button);
		ui_corner.CornerRadius = UDim.new(0, 4);
	end
}

local blur = Instance.new("BlurEffect", LS);
blur.Size = 0;
local color_correction = Instance.new("ColorCorrectionEffect", LS);
color_correction.TintColor = Color3.new(255/255, 255/255, 255/255);

local screen_gui = Instance.new("ScreenGui", game.CoreGui);
screen_gui.Name = "muta_menu";
screen_gui.IgnoreGuiInset = true;
local menu = Instance.new("Frame", screen_gui);
menu.Name = "menu";
menu.AnchorPoint = Vector2.new(0.5, 0.5);
menu.BackgroundColor3 = Color3.new(40/255, 40/255, 40/255);
menu.BackgroundTransparency = 0.4;
menu.Position = UDim2.new(0.5, 0, 0.5, 0);
menu.Size = UDim2.new(0, 440, 0, 300);
components.createCorner(menu);
local menu_title = Instance.new("TextLabel", menu);
menu_title.Name = "menu_title";
menu_title.BackgroundTransparency = 1;
menu_title.Position = UDim2.new(0, 12, 0, 6);
menu_title.Size = UDim2.new(0, 100, 0, 20);
menu_title.Font = Enum.Font.GothamBold;
menu_title.TextColor3 = Color3.new(255/255, 255/255, 255/255);
menu_title.TextSize = 14;
menu_title.TextXAlignment = Enum.TextXAlignment.Left;
menu_title.Text = "muta menu";
local game_name = Instance.new("TextLabel", menu);
game_name.Name = "game_name";
game_name.AnchorPoint = Vector2.new(1, 0);
game_name.BackgroundTransparency = 1;
game_name.Position = UDim2.new(1, -12, 0, 6);
game_name.Size = UDim2.new(0, 200, 0, 20);
game_name.Font = Enum.Font.GothamBold;
game_name.TextColor3 = Color3.new(200/255, 200/255, 200/255);
game_name.TextSize = 14;
game_name.TextXAlignment = Enum.TextXAlignment.Right;
game_name.Text = "clicker simulator";
local divider = Instance.new("Frame", menu);
divider.BackgroundColor3 = Color3.new(40/255, 40/255, 40/255);
divider.BackgroundTransparency = 0.4;
divider.BorderSizePixel = 0;
divider.Position = UDim2.new(0, 0, 0, 30);
divider.Size = UDim2.new(1, 0, 0, 2);
local categories = Instance.new("ScrollingFrame", menu);
categories.AnchorPoint = Vector2.new(0, 1);
categories.BackgroundTransparency = 1;
categories.Position = UDim2.new(0, 6, 1, -6);
categories.Size = UDim2.new(0, 113, 0, 256);
categories.ScrollBarThickness = 0;
components.createGridLayout(categories);
local options = Instance.new("ScrollingFrame", menu);
options.AnchorPoint = Vector2.new(1, 1);
options.BackgroundTransparency = 1;
options.Position = UDim2.new(1, -6, 1, -6);
options.Size = UDim2.new(0, 309, 0, 256);
options.ScrollBarThickness = 0;
components.createGridLayout(options);

components.createOptionButton(options, "autoclicker_button", "auto clicker");
local autoclicker_button = options.autoclicker_button;

components.createOptionButton(options, "autorebirth_button", "auto rebirth");
local autorebirth_button = options.autorebirth_button;

screen_gui.Enabled = false;

-- Buttons

-- Autoclicker Button
autoclicker_button.MouseEnter:Connect(function ()
	TS:Create(autoclicker_button, TweenInfo.new(0.2), { BackgroundTransparency = 0.4 }):Play();
	TS:Create(autoclicker_button.button_text, TweenInfo.new(0.2), { TextColor3 = Color3.new(255/255, 255/255, 255/255) }):Play();
end)

autoclicker_button.MouseLeave:Connect(function ()
	TS:Create(autoclicker_button, TweenInfo.new(0.2), { BackgroundTransparency = 0.6 }):Play();
	TS:Create(autoclicker_button.button_text, TweenInfo.new(0.2), { TextColor3 = Color3.new(200/255, 200/255, 200/255) }):Play();
end)

autoclicker_button.MouseButton1Click:Connect(function ()
	if user_config.autoclicker then
		TS:Create(autoclicker_button.button_status, TweenInfo.new(0.2), { TextColor3 = Color3.new(200/255, 200/255, 200/255) }):Play();
		autoclicker_button.button_status.Text = "off";
		user_config.autoclicker = false;
	else
		TS:Create(autoclicker_button.button_status, TweenInfo.new(0.2), { TextColor3 = Color3.new(127/255, 200/255, 118/255) }):Play();
		autoclicker_button.button_status.Text = "on";
		user_config.autoclicker = true;
	end
end)


-- Autorebirth Button
autorebirth_button.MouseEnter:Connect(function ()
	TS:Create(autorebirth_button, TweenInfo.new(0.2), { BackgroundTransparency = 0.4 }):Play();
	TS:Create(autorebirth_button.button_text, TweenInfo.new(0.2), { TextColor3 = Color3.new(255/255, 255/255, 255/255) }):Play();
end)

autorebirth_button.MouseLeave:Connect(function ()
	TS:Create(autorebirth_button, TweenInfo.new(0.2), { BackgroundTransparency = 0.6 }):Play();
	TS:Create(autorebirth_button.button_text, TweenInfo.new(0.2), { TextColor3 = Color3.new(200/255, 200/255, 200/255) }):Play();
end)

autorebirth_button.MouseButton1Click:Connect(function ()
	if user_config.autorebirth then
		TS:Create(autorebirth_button.button_status, TweenInfo.new(0.2), { TextColor3 = Color3.new(200/255, 200/255, 200/255) }):Play();
		autorebirth_button.button_status.Text = "off";
		user_config.autorebirth = false;
	else
		TS:Create(autorebirth_button.button_status, TweenInfo.new(0.2), { TextColor3 = Color3.new(127/255, 200/255, 118/255) }):Play();
		autorebirth_button.button_status.Text = "on";
		user_config.autorebirth = true;
	end
end)

-- Functions
local function openMenu ()
	for i,v in ipairs(screen_gui:GetDescendants()) do
		if v:IsA("Frame") or v:IsA("TextButton") then
			v.BackgroundTransparency = 1;
		elseif v:IsA("TextLabel") then
			v.TextTransparency = 1;
		end
	end
	
	TS:Create(blur, TweenInfo.new(0.75), { Size = 18 }):Play();
	TS:Create(color_correction, TweenInfo.new(0.75), { TintColor = Color3.new(200/255, 200/255, 200/255) }):Play();
	
	screen_gui.Enabled = true;
	
	for i,v in ipairs(screen_gui:GetDescendants()) do
		if v:IsA("Frame") then
			TS:Create(v, TweenInfo.new(0.5), { BackgroundTransparency = 0.4 }):Play();
		elseif v:IsA("TextButton") then
			TS:Create(v, TweenInfo.new(0.5), { BackgroundTransparency = 0.6 }):Play();
		elseif v:IsA("TextLabel") then
			TS:Create(v, TweenInfo.new(0.5), { TextTransparency = 0 }):Play();
		end
	end
end

local function closeMenu ()
	TS:Create(blur, TweenInfo.new(0.5), { Size = 0 }):Play();
	TS:Create(color_correction, TweenInfo.new(0.5), { TintColor = Color3.new(255/255, 255/255, 255/255) }):Play();

	for i,v in ipairs(screen_gui:GetDescendants()) do
		if v:IsA("Frame") then
			TS:Create(v, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play();
		elseif v:IsA("TextButton") then
			TS:Create(v, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play();
		elseif v:IsA("TextLabel") then
			TS:Create(v, TweenInfo.new(0.25), { TextTransparency = 1 }):Play();
		end
	end
	
	wait(0.25);
	
	screen_gui.Enabled = false;
end

openMenu();

-- Player Usage
UIS.InputBegan:Connect(function (input, unsuccessful)
	if not unsuccessful and input then
		if input.KeyCode == Enum.KeyCode["P"] then
			if not gui_state.gui_debounce then
				if gui_state.gui_open then
					gui_state.gui_debounce = true;
					closeMenu()
					wait(0.25);
					gui_state.gui_open = false;
					gui_state.gui_debounce = false;
				else
					gui_state.gui_debounce = true;
					openMenu()
					wait(0.5);
					gui_state.gui_open = true;
					gui_state.gui_debounce = false;
				end
			end
		end
	end
end)

coroutine.wrap(function ()
	while true do
        if user_config.autoclicker then
            RS.Clickerr:InvokeServer({["manual"] = {["2"] = 100}});
        end
        wait(0.5)
    end
end)();

coroutine.wrap(function ()
	while true do
        if user_config.autorebirth then
            RS.Events.Client.requestRebirth:FireServer(1, false, false);
        end
        wait(0.5)
    end
end)();
