getgenv().ESP = {
    Main = {
        Enabled = true,
        Name = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
        },
        Box = {
            Enabled = true,
            BoxColor = Color3.fromRGB(75, 175, 175),
            BoxFillColor = Color3.fromRGB(100, 75, 175),
        },
        HealthBar = {
            Enabled = true,
            Number = true,
            HighHealthColor = Color3.fromRGB(0, 255, 0),
            LowHealthColor = Color3.fromRGB(255, 0, 0),
        },
        Tool = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
        },
        Distance = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
        },
        Chams = false,
        AutomaticColor = true,
        Type = "AlwaysOnTop", --// "AlwaysOnTop", "Occluded"
    },
    Checks = {
        WallCheck = true,
        VisibleCheck = true,
        ForceField = true,
        AliveCheck = true,
    },
    Extra = {
        UseDisplayName = true,
        EspFadeOut = 400,
        PriorityOnly = true,
    }
}
-- // Tables
local Atlanta = {
    connections = {},   
    Safe = false,
    Locals = {
        PartSizes = {
            ["Head"] = Vector3.new(2, 1, 1),
            ["Torso"] = Vector3.new(2, 2, 1),
            ["Left Arm"] = Vector3.new(1, 2, 1),
            ["Right Arm"] = Vector3.new(1, 2, 1),
            ["Left Leg"] = Vector3.new(1, 2, 1),
            ["Right Leg"] = Vector3.new(1, 2, 1)
        }
    }
}
local Visuals = {
    Bases = {},
    Base = {}
}
local Color = {}
local Utility = {}
local Math = {
    Conversions = {}
}
local Priorities = {
    2794160137,
}
-- // Flags
Flags = getgenv().ESP
--
local ReplicatedStorage, RunService, Workspace, Players = game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Players")
local Client = Players.LocalPlayer
local SetMetatable, GetUpvalue = debug.setmetatable, debug.getupvalue
local RandomSeed, Random, Frexp, Floor, Atan2, Log10, Noise, Round, Ldexp, Clamp, Sinh, Sign, Asin, Acos, Fmod, Huge, Tanh, Sqrt, Atan, Modf, Ceil, Cosh, Deg, Min, Log, Cos, Exp, Max, Rad, Abs, Pow, Sin, Tan, Pi = math.randomseed, math.random, math.frexp, math.floor, math.atan2, math.log10, math.noise, math.round, math.ldexp, math.clamp, math.sinh, math.sign, math.asin, math.acos, math.fmod, math.huge, math.tanh, math.sqrt, math.atan, math.modf, math.ceil, math.cosh, math.deg, math.min, math.log, math.cos, math.exp, math.max, math.rad, math.abs, math.pow, math.sin, math.tan, math.pi
local Remove, Create, Find = table.remove, table.create, table.find
local PackSize, Reverse, SUnpack, Gmatch, Format, Lower, Split, Match, Upper, Byte, Char, Pack, Gsub, SFind, Rep, Sub, Len = string.packsize, string.reverse, string.unpack, string.gmatch, string.format, string.lower, string.split, string.match, string.upper, string.byte, string.char, string.pack, string.gsub, string.find, string.rep, string.sub, string.len
local Create, Resume = coroutine.create, coroutine.resume
local Wait = task.wait
function DestroyRenderObject(Obj)  Obj:Remove() end
function SetRenderProperty(Obj, Mod, Value) Obj[Mod] = Value end


--
do -- // Utility
    function Utility:Connection(connectionType, connectionCallback)
        local connection = connectionType:Connect(connectionCallback)
        Atlanta.connections[#Atlanta.connections + 1] = connection
        --
        return connection
    end
    --
    function Utility:ClampString(String, Length, Font)
        local Font = (Font or 2)
        local Split = String:split("\n")
        --
        local Clamped = ""
        --
        for Index, Value2 in pairs(Split) do
            if (Index * 13) <= Length then
                Clamped = Clamped .. Value2 .. (Index == #Split and "" or "\n")
            end
        end
        --
        return (Clamped ~= String and (Clamped == "" and "" or Clamped:sub(0, #Clamped - 1) .. " ...") or Clamped)
    end
    --
    function Utility:ThreadFunction(Func, Name, ...)
        local Func = Name and function()
            local Passed, Statement = pcall(Func)
            --
            if not Passed and not Atlanta.Safe then
                warn("Atlanta:\n", "              " .. Name .. ":", Statement)
            end
        end or Func
        local Thread = Create(Func)
        --
        Resume(Thread, ...)
        return Thread
    end
end
--
do -- Color
    function Color:Lerp(Value, MinColor, MaxColor)
        if Value <= 0 then return MaxColor end
        if Value >= 100 then return MinColor end
        --
        return Color3.new(
            MaxColor.R + (MinColor.R - MaxColor.R) * Value,
            MaxColor.G + (MinColor.G - MaxColor.G) * Value,
            MaxColor.B + (MinColor.B - MaxColor.B) * Value
        )
    end
end
--
do -- Math
    do -- Conversions
        Math.Conversions["Studs"] = {
            Conversion = function(Studs)
                return Studs
            end,
            Measurement = "st",
            Round = function(Number)
                return Round(Number)
            end
        }
        --
        Math.Conversions["Meters"] = {
            Conversion = function(Studs)
                return Studs * 0.28
            end,
            Measurement = "m",
            Round = function(Number)
                return Round(Number * 10) / 10
            end
        }
        --
        Math.Conversions["Centimeters"] = {
            Conversion = function(Studs)
                return Studs * 28
            end,
            Measurement = "cm",
            Round = function(Number)
                return Round(Number)
            end
        }
        --
        Math.Conversions["Kilometers"] = {
            Conversion = function(Studs)
                return Studs * 0.00028
            end,
            Measurement = "km",
            Round = function(Number)
                return Round(Number * 1000) / 1000
            end
        }
        --
        Math.Conversions["Millimeters"] = {
            Conversion = function(Studs)
                return Studs * 280
            end,
            Measurement = "mm",
            Round = function(Number)
                return Round(Number)
            end
        }
        --
        Math.Conversions["Micrometers"] = {
            Conversion = function(Studs)
                return Studs * 280000
            end,
            Measurement = "μm",
            Round = function(Number)
                return Round(Number)
            end
        }
        --
        Math.Conversions["Inches"] = {
            Conversion = function(Studs)
                return Studs * 11.0236224
            end,
            Measurement = [['']],
            Round = function(Number)
                return Round(Number)
            end
        }
        --
        Math.Conversions["Miles"] = {
            Conversion = function(Studs)
                return Studs * 0.000173983936
            end,
            Measurement = "mi",
            Round = function(Number)
                return Round(Number * 10000) / 10000
            end
        }
        --
        Math.Conversions["Nautical Miles"] = {
            Conversion = function(Studs)
                return Studs * 0399568
            end,
            Measurement = "nmi",
            Round = function(Number)
                return Round(Number * 10000) / 10000
            end
        }
        --
        Math.Conversions["Yards"] = {
            Conversion = function(Studs)
                return Studs * 0.30621164
            end,
            Measurement = "yd",
            Round = function(Number)
                return Round(Number * 10) / 10
            end
        }
        --
        Math.Conversions["Feet"] = {
            Conversion = function(Studs)
                return Studs * 0.9186352
            end,
            Measurement = "ft",
            Round = function(Number)
                return Round(Number)
            end
        }
    end
    --
    function Math:RotatePoint(Point, Radians)
        local Unit = Point.Unit
        --
        local Sine = Sin(Radians)
        local Cosine = Cos(Radians)
        --
        return Vector2.new((Cosine * Unit.X) - (Sine * Unit.Y), (Sine * Unit.X) + (Cosine * Unit.Y)).Unit * Point.Magnitude
    end
    --
    function Math:RoundVector(Vector)
        return Vector2.new(Round(Vector.X), Round(Vector.Y))
    end
    --
    function Math:Shift(Number)
        return Acos(Cos(Number * Pi)) / Pi
    end
    --
    function Math:Conversion(Studs, Conversion)
        local Conversion = Math.Conversions[Conversion]
        --
        local Converted = Conversion.Conversion(Studs)
        local Measurement = Conversion.Measurement
        local Rounded = Conversion.Round(Converted)
        --
        return Converted, Measurement, Rounded
    end
    --
    function Math:Random(Number)
        return Random(-Number, Number)
    end
    --
    function Math:RandomVec3(X, Y, Z)
        return Vector3.new(Math:Random(X), Math:Random(Y), Math:Random(Z))
    end
end      
--
do --// Functions
    function Atlanta:PlayerValid(Player, Function)
        if Player:IsA("Player") then
            if Function then return Function(Player) else return true end
        end
    end
    --
    function Atlanta:GetCharacter(Player)
        return Player.Character
    end
    --
    function Atlanta:GetHumanoid(Player, Character)
        return Character:FindFirstChildOfClass("Humanoid")
    end
    --
    function Atlanta:GetHealth(Player, Character, Humanoid)
        if Humanoid then
            return Clamp(Humanoid.Health, 0, Humanoid.MaxHealth), Humanoid.MaxHealth
        end
    end
    --
    function Atlanta:GetRootPart(Player, Character, Humanoid)
        return Humanoid.RootPart
    end
    --
    function Atlanta:GetIgnore(Unpacked)
        return
    end
    --
    function Atlanta:GetBodyParts(Character, RootPart, Indexes, Hitboxes)
        local Parts = {}
        local Hitboxes = Hitboxes or {"Head", "Torso", "Arms", "Legs"}
        --
        for Index, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") and Part ~= RootPart then
                if Find(Hitboxes, "Head") and Part.Name:lower():find("head") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Find(Hitboxes, "Torso") and Part.Name:lower():find("torso") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Find(Hitboxes, "Arms") and Part.Name:lower():find("arm") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Find(Hitboxes, "Legs") and Part.Name:lower():find("leg") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif (Find(Hitboxes, "Arms") and Part.Name:lower():find("hand")) or (Find(Hitboxes, "Legs ") and Part.Name:lower():find("foot")) then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                end
            end
        end
        --
        return Parts
    end
    --
    function Atlanta:ClientAlive(Player, Character, Humanoid)
        local Health, MaxHealth = Atlanta:GetHealth(Player, Character, Humanoid)
        --
        return (Health > 0)
    end
    --
    function Atlanta:ValidateClient(Player)
        local Object = Atlanta:GetCharacter(Player)
        local Humanoid = (Object and Atlanta:GetHumanoid(Player, Object))
        local RootPart = (Humanoid and Atlanta:GetRootPart(Player, Object, Humanoid))
        --
        return Object, Humanoid, RootPart
    end
    --
    function Atlanta:GetBoundingBox(BodyParts, RootPart)
        local Size = Vector3.new(0, 0, 0)
        --
        for Index, Value in pairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
            local Part = BodyParts[Value]
            local PartSize = (Part and Part.Size or Atlanta.Locals.PartSizes[Value])
            --
            if Value == "Head" then
                Size = (Size + Vector3.new(0, PartSize.Y, 0))
            elseif Value == "Torso" then
                Size = (Size + Vector3.new(PartSize.X, PartSize.Y, PartSize.Z))
            elseif Value == "Left Arm" then
                Size = (Size + Vector3.new(PartSize.X, 0, 0))
            elseif Value == "Right Arm" then
                Size = (Size + Vector3.new(PartSize.X, 0, 0))
            elseif Value == "Left Leg" then
                Size = (Size + Vector3.new(0, PartSize.Y, 0))
            elseif Value == "Right Leg" then
                Size = (Size + Vector3.new(0, PartSize.Y, 0))
            end
        end
        --
        return (RootPart.CFrame + Vector3.new(0, -0.125, 0)), Size
    end
    --
    function Atlanta:RayCast(Part, Origin, Ignore, Distance)
        local Ignore = Ignore or {}
        local Distance = Distance or 2000
        --
        local Cast = Ray.new(Origin, (Part.Position - Origin).Unit * Distance)
        local Hit = Workspace:FindPartOnRayWithIgnoreList(Cast, Ignore)
        --
        return (Hit and Hit:IsDescendantOf(Part.Parent)) == true, Hit
    end
    --
    function Atlanta:GetPlayers()
        return Players:GetPlayers()
    end
    --
    function Atlanta:PlayerAdded(Player)
        Visuals:Create({Player = Player})
    end
    --
    function Atlanta:GetUserID(Player)
        return Player.UserId
    end
    --
    function Atlanta:GetPlayerParent(Player)
        return Player.Parent
    end
end
--
do -- // Visuals
    function Visuals:Create(Properties)
        if Properties then
            if Properties.Player then
                local Self = setmetatable({
                    Player = Properties.Player,
                    Highlight = Instance.new("Highlight"),
                    Info = {
                        Tick = tick()
                    },
                    Renders = {
                        Flags = Drawing.new("Text"),
                        Weapon = Drawing.new("Text"),
                        Distance = Drawing.new("Text"),
                        HealthBarOutline = Drawing.new("Square"),
                        HealthBarInline = Drawing.new("Square"),
                        HealthBarValue = Drawing.new("Text"),
                        BoxFill = Drawing.new("Square"),
                        BoxOutline = Drawing.new("Square"),
                        BoxInline = Drawing.new("Square"),
                        Name = Drawing.new("Text"),
                        Arrow = Drawing.new("Triangle"),
                        ArrowOutline = Drawing.new("Triangle")
                    }
                }, {
                    __index = Visuals.Base
                })
                --
                Self.Highlight.Parent = Storage
                --
                do -- Renders.Name
                    SetRenderProperty(Self.Renders.Name, "Text", Self.Player.Name)
                    SetRenderProperty(Self.Renders.Name, "Size", 13)
                    SetRenderProperty(Self.Renders.Name, "Center", true)
                    SetRenderProperty(Self.Renders.Name, "Outline", true)
                    SetRenderProperty(Self.Renders.Name, "Font", 2)
                    SetRenderProperty(Self.Renders.Name, "Visible", false)
                end
                --
                do -- Renders.Box
                    -- Inline
                    SetRenderProperty(Self.Renders.BoxInline, "Thickness", 1.25)
                    SetRenderProperty(Self.Renders.BoxInline, "Filled", false)
                    SetRenderProperty(Self.Renders.BoxInline, "Visible", false)
                    -- Outline
                    SetRenderProperty(Self.Renders.BoxOutline, "Thickness", 2.5)
                    SetRenderProperty(Self.Renders.BoxOutline, "Filled", false)
                    SetRenderProperty(Self.Renders.BoxOutline, "Visible", false)
                    -- Fill
                    SetRenderProperty(Self.Renders.BoxFill, "Filled", true)
                    SetRenderProperty(Self.Renders.BoxFill, "Visible", false)
                end
                --
                do -- Renders.HealthBar
                    -- Inline
                    SetRenderProperty(Self.Renders.HealthBarInline, "Filled", true)
                    SetRenderProperty(Self.Renders.HealthBarInline, "Visible", false)
                    -- Outline
                    SetRenderProperty(Self.Renders.HealthBarOutline, "Filled", true)
                    SetRenderProperty(Self.Renders.HealthBarOutline, "Visible", false)
                    -- Value
                    SetRenderProperty(Self.Renders.HealthBarValue, "Size", 13)
                    SetRenderProperty(Self.Renders.HealthBarValue, "Center", false)
                    SetRenderProperty(Self.Renders.HealthBarValue, "Outline", true)
                    SetRenderProperty(Self.Renders.HealthBarValue, "Font", 2)
                    SetRenderProperty(Self.Renders.HealthBarValue, "Visible", false)
                end
                --
                do -- Renders.Flags
                    SetRenderProperty(Self.Renders.Flags, "Size", 13)
                    SetRenderProperty(Self.Renders.Flags, "Center", false)
                    SetRenderProperty(Self.Renders.Flags, "Outline", true)
                    SetRenderProperty(Self.Renders.Flags, "Font", 2)
                    SetRenderProperty(Self.Renders.Flags, "Visible", false)
                end
                --
                do -- Renders.Distance
                    SetRenderProperty(Self.Renders.Distance, "Size", 13)
                    SetRenderProperty(Self.Renders.Distance, "Center", true)
                    SetRenderProperty(Self.Renders.Distance, "Outline", true)
                    SetRenderProperty(Self.Renders.Distance, "Font", 2)
                    SetRenderProperty(Self.Renders.Distance, "Visible", false)
                end
                --
                do -- Renders.Weapon
                    SetRenderProperty(Self.Renders.Weapon, "Size", 13)
                    SetRenderProperty(Self.Renders.Weapon, "Center", true)
                    SetRenderProperty(Self.Renders.Weapon, "Outline", true)
                    SetRenderProperty(Self.Renders.Weapon, "Font", 2)
                    SetRenderProperty(Self.Renders.Weapon, "Visible", false)
                end
                --
                do -- Renders.Arrow
                    -- Inline
                    SetRenderProperty(Self.Renders.Arrow, "Filled", true)
                    SetRenderProperty(Self.Renders.Arrow, "Visible", false)
                    -- Outline
                    SetRenderProperty(Self.Renders.ArrowOutline, "Filled", false)
                    SetRenderProperty(Self.Renders.ArrowOutline, "Visible", false)
                    SetRenderProperty(Self.Renders.ArrowOutline, "Thickness", 1.5)
                end
                --
                Visuals.Bases[Properties.Player] = Self
                --
                return Self
            end
        end
    end
    --
    function Visuals:Unload()
        for Index, Value in pairs(Visuals.Bases) do
            Value:Remove()
        end
    end
    --
    function Visuals.Base:Remove()
        local Self = self
        --
        if Self then
            setmetatable(Self, {})
            --
            Visuals.Bases[Self.Player] = nil
            --
            Self.Object = nil
            --
            for Index, Value in pairs(Self.Renders) do
                DestroyRenderObject(Value)
            end
            --
            Self.Highlight:Remove()
            --
            Self.Renders = nil
            Self.Highlight = nil
            Self = nil
        end
    end
    --
    function Visuals.Base:Opacity(State, Table)
        local Self = self
        --
        if Self then
            local Renders = rawget(Self, "Renders")
            --
            for Index, Value in pairs(typeof(Table) == "table" and Table or Renders) do
                SetRenderProperty(typeof(Table) == "table" and Renders[Value] or Value, "Visible", State)
            end
            --
            Self.Highlight.Adornee = nil
            Self.Highlight.Enabled = false
            --
            if not State then
                Self.Info.RootPartCFrame = nil
                Self.Info.Health = nil
                Self.Info.MaxHealth = nil
                Self.Info.BoundingBox = nil
            end
        end
    end
    --
    function Visuals.Base:Update()
        local Self = self
        --
        if Self then
            local Renders = rawget(Self, "Renders")
            local Player = rawget(Self, "Player")
            local Info = rawget(Self, "Info")
            local Parent = Atlanta:GetPlayerParent(Player)
            --
            if (Player and Player ~= Client and Parent and Parent ~= nil) or (Info.RootPartCFrame and Info.Health and Info.MaxHealth) then
                if ESP.Main.Enabled then
                    local Object, Humanoid, RootPart = Atlanta:ValidateClient(Player)
                    local BodyParts = (RootPart and Atlanta:GetBodyParts(Object, RootPart, true))
                    local TransparencyMultplier = 1
                    --
                    if Object and Object.Parent and (Humanoid and RootPart and BodyParts) then
                        local Health, MaxHealth = Atlanta:GetHealth(Player, Object, Humanoid)
                        --
                        if (ESP.Checks.AliveCheck and not Atlanta:ClientAlive(Player, Character, Humanoid)) or (ESP.Checks.ForceField and Object:FindFirstChildOfClass("ForceField")) then 
                            Info.Pass = false
                        else
                            Info.Pass = true
                            Info.RootPartCFrame = RootPart.CFrame
                            Info.Health = Health
                            Info.MaxHealth = MaxHealth
                        end
                    else
                        Info.Pass = false
                    end
                    --
                    if Info.Pass then
                        Info.Tick = tick()
                    else
                        local FadeOut = ESP.Extra.EspFadeOut
                        local FadeTime = FadeOut / 1000
                        local Value = Info.Tick - tick()
                        --
                        if not FadeOut == 0 and Value <= FadeTime then
                            TransparencyMultplier = Clamp((Value + FadeTime) * 1 / FadeTime, 0, 1)
                        else
                            Info.RootPartCFrame = nil
                            Info.Health = nil
                            Info.MaxHealth = nil
                            Info.BoundingBox = nil
                        end
                    end
                    --
                    if Info.RootPartCFrame and Info.Health and Info.MaxHealth then
                        local Override = nil
                        local Orhue, Orsaturation, Orvalue = (Override or Color3.new()):ToHSV()
                        --
                        local Conversion = "Studs"
                        --
                        local Magnitude = (Workspace.CurrentCamera.CFrame.Position - Info.RootPartCFrame.Position).Magnitude
                        local Distance, Measurement, Rounded = Math:Conversion(Magnitude, Conversion)
                        local Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(Info.RootPartCFrame.Position)
                        --
                        local BoxSize
                        local BoxPosition 
                        --
                        if OnScreen then
                            local MaxDistance = 2501
                            --
                            if Magnitude <= MaxDistance then
                                local BoundingBox = (Info.Pass and {Atlanta:GetBoundingBox(BodyParts, RootPart)} or Info.BoundingBox)
                                local Width = (Workspace.CurrentCamera.CFrame - Workspace.CurrentCamera.CFrame.Position) * Vector3.new((Clamp(BoundingBox[2].X, 1, 10) + 0.5) / 2, 0, 0)
                                local Height = (Workspace.CurrentCamera.CFrame - Workspace.CurrentCamera.CFrame.Position) * Vector3.new(0, (Clamp(BoundingBox[2].Y, 1, 10) + 0.5) / 2, 0)
                                --
                                if Info.Pass then
                                    Info.BoundingBox = BoundingBox
                                end
                                --
                                local Middle = Workspace.CurrentCamera:WorldToViewportPoint(BoundingBox[1].Position)
                                Width = Abs(Workspace.CurrentCamera:WorldToViewportPoint(BoundingBox[1].Position + Width).X - Workspace.CurrentCamera:WorldToViewportPoint(BoundingBox[1].Position - Width).X)
                                Height = Abs(Workspace.CurrentCamera:WorldToViewportPoint(BoundingBox[1].Position + Height).Y - Workspace.CurrentCamera:WorldToViewportPoint(BoundingBox[1].Position - Height).Y)
                                --
                                BoxSize = Math:RoundVector(Vector2.new(Width, Height))
                                BoxPosition = Math:RoundVector(Vector2.new(Middle.X, Middle.Y) - (BoxSize / 2))
                                --
                                do -- Box
                                    if ESP.Main.Box.Enabled then
                                        local BoxColor1, BoxTransparency1 = Override or ESP.Main.Box.BoxColor, (1 - 0 * TransparencyMultplier)
                                        local BoxColor2, BoxTransparency2 = Override or ESP.Main.Box.BoxFillColor, (1 - 0.5 * TransparencyMultplier)
                                        -- Inline
                                        SetRenderProperty(Renders.BoxInline, "Size", BoxSize)
                                        SetRenderProperty(Renders.BoxInline, "Position", BoxPosition)
                                        SetRenderProperty(Renders.BoxInline, "Visible", true)
                                        SetRenderProperty(Renders.BoxInline, "Color", BoxColor1)
                                        SetRenderProperty(Renders.BoxInline, "Transparency", BoxTransparency1)
                                        -- Outline
                                        SetRenderProperty(Renders.BoxOutline, "Size", BoxSize)
                                        SetRenderProperty(Renders.BoxOutline, "Position", BoxPosition)
                                        SetRenderProperty(Renders.BoxOutline, "Visible", true)
                                        SetRenderProperty(Renders.BoxOutline, "Transparency", BoxTransparency1)
                                        -- Fill
                                        SetRenderProperty(Renders.BoxFill, "Size", BoxSize)
                                        SetRenderProperty(Renders.BoxFill, "Position", BoxPosition)
                                        SetRenderProperty(Renders.BoxFill, "Visible", true)
                                        SetRenderProperty(Renders.BoxFill, "Color", BoxColor2)
                                        SetRenderProperty(Renders.BoxFill, "Transparency", BoxTransparency2)
                                    else
                                        SetRenderProperty(Renders.BoxInline, "Visible", false)
                                        SetRenderProperty(Renders.BoxOutline, "Visible", false)
                                        SetRenderProperty(Renders.BoxFill, "Visible", false)
                                    end
                                end
                            end
                        end
                        --
                        do -- Chams
                            if ESP.Main.Chams then
                                local ChamsFill, ChamsFillTransparency = Override or Flags[Selection .. "ChamsFill"]:Get().Color, (1 - ((1 - Flags[Selection .. "ChamsFill"]:Get().Transparency) * TransparencyMultplier))
                                local ChamsOutline, ChamsOutlineTransparency = Flags[Selection .. "ChamsOutline"]:Get().Color, (1 - ((1 - Flags[Selection .. "ChamsOutline"]:Get().Transparency) * TransparencyMultplier))
                                local HighlightMode = Flags[Selection .. "HighlightMode"]:Get()
                                --
                                local ChamsAuto = Atlanta.Locals.SelectedPlayersSection ~= "Local" and Flags[Selection .. "ChamsAuto"]:Get()
                                local ChamsVisible, ChamsVisibleTransparency = ChamsAuto and Flags[Selection .. "ChamsVisible"]:Get().Color, ChamsAuto and (1 - ((1 - Flags[Selection .. "ChamsVisible"]:Get().Transparency) * TransparencyMultplier))
                                local ChamsHidden, ChamsHiddenTransparency = ChamsAuto and Flags[Selection .. "ChamsHidden"]:Get().Color, ChamsAuto and (1 - ((1 - Flags[Selection .. "ChamsHidden"]:Get().Transparency) * TransparencyMultplier))
                                --
                                local Visible = OnScreen and (RootPart ~= nil and Atlanta:RayCast(RootPart, Workspace.CurrentCamera.CFrame.Position, {Atlanta:GetCharacter(Client), Atlanta:GetIgnore(true)}))
                                --
                                if Info.Pass then
                                    Self.Highlight.Adornee = Object
                                end
                                --
                                Self.Highlight.FillColor = ChamsAuto and (Visible and ChamsVisible or ChamsHidden) or ChamsFill
                                Self.Highlight.FillTransparency = ChamsAuto and (Visible and ChamsVisibleTransparency or ChamsHiddenTransparency) or ChamsFillTransparency
                                Self.Highlight.OutlineColor = ChamsOutline
                                Self.Highlight.OutlineTransparency = ChamsOutlineTransparency
                                Self.Highlight.DepthMode = Enum.HighlightDepthMode[HighlightMode]
                                Self.Highlight.Enabled = true
                            else
                                Self.Highlight.Adornee = nil
                                Self.Highlight.Enabled = false
                            end
                        end
                        --
                        if BoxSize and BoxPosition then
                            do -- Name
                                local NameEnabled = ESP.Main.Name.Enabled
                                --
                                if NameEnabled then
                                    local NameColor, NameTransparency = Override or ESP.Main.Name.Color, ((1 - 0) * TransparencyMultplier)
                                    --
                                    local Text
                                    --
                                    if ESP.Extra.UseDisplayName then
                                        Text = ((Player.DisplayName ~= nil and Player.DisplayName ~= "" and Player.DisplayName ~= " ") and Player.DisplayName or Player.Name)
                                    else
                                        Text = Player.Name
                                    end
                                    --
                                    SetRenderProperty(Renders.Name, "Text", Text)
                                    SetRenderProperty(Renders.Name, "Position", BoxPosition + Vector2.new(BoxSize.X / 2, -(13 + 4)))
                                    SetRenderProperty(Renders.Name, "Visible", true)
                                    SetRenderProperty(Renders.Name, "Color", NameColor)
                                    SetRenderProperty(Renders.Name, "Transparency", NameTransparency)
                                else
                                    SetRenderProperty(Renders.Name, "Visible", false)
                                end
                            end 
                            --
                            do -- HeatlhBar
                                local HealthBarColor1, HealthBarTransparency = ESP.Main.HealthBar.HighHealthColor, ((1 - 0) * TransparencyMultplier)
                                local HealthBarColor2 = ESP.Main.HealthBar.LowHealthColor
                                local HealthBarEnabled
                                local HealthNumEnabled
                                --
                                HealthBarEnabled = ESP.Main.HealthBar.Enabled
                                HealthNumEnabled = ESP.Main.HealthBar.Number
                                --
                                local HealthSize = (Floor(BoxSize.Y * (Info.Health / Info.MaxHealth)))
                                local Color = Color:Lerp(Info.Health / Info.MaxHealth, HealthBarColor1, HealthBarColor2)
                                local Height = ((BoxPosition.Y + BoxSize.Y) - HealthSize)
                                --
                                if HealthBarEnabled then
                                    -- Inline
                                    SetRenderProperty(Renders.HealthBarInline, "Color", Color)
                                    SetRenderProperty(Renders.HealthBarInline, "Size", Vector2.new(2, HealthSize))
                                    SetRenderProperty(Renders.HealthBarInline, "Position", Vector2.new(BoxPosition.X - 5, Height))
                                    SetRenderProperty(Renders.HealthBarInline, "Visible", true)
                                    SetRenderProperty(Renders.HealthBarInline, "Transparency", HealthBarTransparency)
                                    -- Outline
                                    SetRenderProperty(Renders.HealthBarOutline, "Size", Vector2.new(4, BoxSize.Y + 2))
                                    SetRenderProperty(Renders.HealthBarOutline, "Position", Vector2.new(BoxPosition.X - 6, BoxPosition.Y - 1))
                                    SetRenderProperty(Renders.HealthBarOutline, "Visible", true)
                                    SetRenderProperty(Renders.HealthBarOutline, "Transparency", HealthBarTransparency)
                                else
                                    SetRenderProperty(Renders.HealthBarInline, "Visible", false)
                                    SetRenderProperty(Renders.HealthBarOutline, "Visible", false)
                                end
                                --
                                if HealthNumEnabled then
                                    -- Value
                                    local Text = Utility:ClampString(tostring(Round(Info.Health)), BoxSize.Y)
                                    --
                                    SetRenderProperty(Renders.HealthBarValue, "Text", Text)
                                    SetRenderProperty(Renders.HealthBarValue, "Color", Color)
                                    SetRenderProperty(Renders.HealthBarValue, "Position", Vector2.new(BoxPosition.X - (HealthBarEnabled and 8 or 4) - (#Text * 8), Clamp(Height, 0, Height + HealthSize - (HealthSize > 13 and 13 or 0))))
                                    SetRenderProperty(Renders.HealthBarValue, "Visible", true)
                                    SetRenderProperty(Renders.HealthBarValue, "Transparency", HealthBarTransparency)
                                else
                                    SetRenderProperty(Renders.HealthBarValue, "Visible", false)
                                end
                            end
                            --
                            local DistanceEnabled = ESP.Main.Distance.Enabled
                            local DistanceColor2 = ESP.Main.Distance.Color
                            --
                            do -- Distance
                                if DistanceEnabled then
                                    local DistanceColor, DistanceTransparency = Override or DistanceColor2, ((1 - 0) * TransparencyMultplier)
                                    --
                                    SetRenderProperty(Renders.Distance, "Text", ("%s%s"):format(Rounded, Measurement))
                                    SetRenderProperty(Renders.Distance, "Position", BoxPosition + Vector2.new(BoxSize.X / 2, (BoxSize.Y + 4)))
                                    SetRenderProperty(Renders.Distance, "Visible", true)
                                    SetRenderProperty(Renders.Distance, "Color", DistanceColor)
                                    SetRenderProperty(Renders.Distance, "Transparency", DistanceTransparency)
                                else
                                    SetRenderProperty(Renders.Distance, "Visible", false)
                                end
                            end
                            --
                            do -- Weapon
                                local WeaponEnabled = ESP.Main.Tool.Enabled
                                local ToolColor = ESP.Main.Tool.Color
                                --
                                if WeaponEnabled then
                                    local WeaponColor, WeaponTransparency = Override and Color3.fromHSV(Orhue, Orsaturation, Orvalue - 0.2) or ToolColor, ((1 - 0) * TransparencyMultplier)
                                    --
                                    local Tool = Object:FindFirstChildOfClass("Tool")
                                    --
                                    SetRenderProperty(Renders.Weapon, "Text", ("%s"):format((Tool and (Tool.Name:sub(0, 12)) or " ")))
                                    SetRenderProperty(Renders.Weapon, "Position", BoxPosition + Vector2.new(BoxSize.X / 2, (BoxSize.Y + 4 + (DistanceEnabled and 13 or 0))))
                                    SetRenderProperty(Renders.Weapon, "Visible", true)
                                    SetRenderProperty(Renders.Weapon, "Color", WeaponColor)
                                    SetRenderProperty(Renders.Weapon, "Transparency", WeaponTransparency)
                                else
                                    SetRenderProperty(Renders.Weapon, "Visible", false)
                                end
                            end
                            --
                            return
                        end
                    end
                end
                --
                return Self:Opacity(false)
            end
            --
            return Self:Remove()
        end
    end
end
--
do -- // Connections
    Utility:Connection(RunService.RenderStepped, function()
        for Index, Value in pairs(Visuals.Bases) do
            Utility:ThreadFunction(function()
                Value:Update()
            end, "3x02")
        end
    end)
    --
    Utility:Connection(Players.ChildAdded, function(Child)
        Atlanta:PlayerValid(Child, function(Validated) 
            Atlanta:PlayerAdded(Validated) 
        end)
    end)
end 
--
for Index, Player in pairs(Atlanta:GetPlayers()) do
     Atlanta:PlayerValid(Player, function(Validated) 
        Atlanta:PlayerAdded(Validated) 
    end)
end
