--// Stellar UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local UI = {}

local function New(class, properties, parent)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

function UI:CreateWindow(title)
    local Window = {}

    local Gui = New("ScreenGui", {
        Name = "Stellar",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })

    pcall(function()
        Gui.Parent = game:GetService("CoreGui")
    end)

    if not Gui.Parent then
        Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local Main = New("Frame", {
        Size = UDim2.fromOffset(620, 430),
        Position = UDim2.new(0.5, -310, 0.5, -215),
        BackgroundColor3 = Color3.fromRGB(8, 12, 23),
        BorderSizePixel = 0,
    }, Gui)

    New("UICorner", {
        CornerRadius = UDim.new(0, 12),
    }, Main)

    New("UIStroke", {
        Color = Color3.fromRGB(55, 150, 255),
        Thickness = 1,
        Transparency = 0.2,
    }, Main)

    local Top = New("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = Color3.fromRGB(11, 17, 31),
        BorderSizePixel = 0,
    }, Main)

    New("UICorner", {
        CornerRadius = UDim.new(0, 12),
    }, Top)

    local Title = New("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Text = "✦  " .. title,
        TextColor3 = Color3.fromRGB(90, 175, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Top)

    local Close = New("TextButton", {
        Size = UDim2.fromOffset(35, 35),
        Position = UDim2.new(1, -45, 0, 10),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Color3.fromRGB(180, 190, 205),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
    }, Top)

    Close.MouseButton1Click:Connect(function()
        Gui:Destroy()
    end)

    -- Dragging
    local dragging = false
    local dragStart
    local startPosition

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Sidebar
    local Sidebar = New("Frame", {
        Size = UDim2.new(0, 155, 1, -70),
        Position = UDim2.fromOffset(10, 65),
        BackgroundColor3 = Color3.fromRGB(11, 17, 31),
        BorderSizePixel = 0,
    }, Main)

    New("UICorner", {
        CornerRadius = UDim.new(0, 9),
    }, Sidebar)

    local TabLayout = New("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Sidebar)

    local TabPadding = New("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    }, Sidebar)

    local Pages = New("Frame", {
        Size = UDim2.new(1, -180, 1, -70),
        Position = UDim2.fromOffset(170, 65),
        BackgroundTransparency = 1,
    }, Main)

    local tabs = {}

    function Window:AddTab(name)
        local Page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
        }, Pages)

        local Layout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Page)

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 10),
            PaddingRight = UDim.new(5, 0),
        }, Page)

        local Button = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(17, 25, 42),
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Color3.fromRGB(170, 180, 200),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
        }, Sidebar)

        New("UICorner", {
            CornerRadius = UDim.new(0, 7),
        }, Button)

        tabs[name] = {
            Page = Page,
            Button = Button,
        }

        Button.MouseButton1Click:Connect(function()
            for _, tab in pairs(tabs) do
                tab.Page.Visible = false
                tab.Button.BackgroundColor3 =
                    Color3.fromRGB(17, 25, 42)
                tab.Button.TextColor3 =
                    Color3.fromRGB(170, 180, 200)
            end

            Page.Visible = true
            Button.BackgroundColor3 =
                Color3.fromRGB(30, 105, 180)
            Button.TextColor3 =
                Color3.fromRGB(255, 255, 255)
        end)

        return self:CreateSection(Page)
    end

    function Window:CreateSection(Page)
        local Section = {}

        function Section:Toggle(name, default, callback)
            local enabled = default or false

            local Button = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Color3.fromRGB(15, 23, 39),
                BorderSizePixel = 0,
                Text = "",
            }, Page)

            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }, Button)

            New("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(15, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Color3.fromRGB(225, 230, 240),
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, Button)

            local Status = New("TextLabel", {
                Size = UDim2.fromOffset(50, 46),
                Position = UDim2.new(1, -60, 0, 0),
                BackgroundTransparency = 1,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
            }, Button)

            local function Update()
                Status.Text = enabled and "ON" or "OFF"

                Status.TextColor3 = enabled
                    and Color3.fromRGB(75, 190, 255)
                    or Color3.fromRGB(120, 130, 150)

                if callback then
                    callback(enabled)
                end
            end

            Button.MouseButton1Click:Connect(function()
                enabled = not enabled
                Update()
            end)

            Update()

            return {
                Set = function(_, value)
                    enabled = value
                    Update()
                end,

                Get = function()
                    return enabled
                end,
            }
        end

        function Section:Slider(name, min, max, default, callback)
            local value = default

            local Holder = New("Frame", {
                Size = UDim2.new(1, 0, 0, 62),
                BackgroundColor3 = Color3.fromRGB(15, 23, 39),
                BorderSizePixel = 0,
            }, Page)

            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }, Holder)

            local Label = New("TextLabel", {
                Size = UDim2.new(1, -30, 0, 25),
                Position = UDim2.fromOffset(15, 3),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(220, 225, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, Holder)

            local Bar = New("Frame", {
                Size = UDim2.new(1, -30, 0, 5),
                Position = UDim2.fromOffset(15, 42),
                BackgroundColor3 = Color3.fromRGB(42, 51, 70),
                BorderSizePixel = 0,
            }, Holder)

            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, Bar)

            local Fill = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(55, 155, 255),
                BorderSizePixel = 0,
            }, Bar)

            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, Fill)

            local draggingSlider = false

            local function SetValue(newValue)
                value = math.clamp(newValue, min, max)

                local percent =
                    (value - min) / (max - min)

                Fill.Size =
                    UDim2.new(percent, 0, 1, 0)

                Label.Text =
                    string.format("%s: %.2f", name, value)

                if callback then
                    callback(value)
                end
            end

            local function Update(x)
                local percent = math.clamp(
                    (x - Bar.AbsolutePosition.X) /
                    Bar.AbsoluteSize.X,
                    0,
                    1
                )

                SetValue(
                    min + ((max - min) * percent)
                )
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1 then

                    draggingSlider = true
                    Update(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and
                    input.UserInputType ==
                    Enum.UserInputType.MouseMovement then

                    Update(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1 then

                    draggingSlider = false
                end
            end)

            SetValue(default)

            return {
                Set = function(_, newValue)
                    SetValue(newValue)
                end,

                Get = function()
                    return value
                end,
            }
        end

        function Section:Button(name, callback)
            local Button = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Color3.fromRGB(15, 23, 39),
                BorderSizePixel = 0,
                Text = name,
                TextColor3 = Color3.fromRGB(220, 225, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
            }, Page)

            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }, Button)

            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)

            return Button
        end

        return Section
    end

    -- First tab gets selected automatically.
    function Window:SelectTab(name)
        local tab = tabs[name]

        if tab then
            tab.Button:Activate()
        end
    end

    Window.Gui = Gui
    Window.Main = Main

    return Window
end

return UI
