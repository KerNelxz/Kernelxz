local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Kernelx", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("User Info")
local playerName = game.Players.LocalPlayer.Name

-- สร้าง label แสดงชื่อผู้เล่น
Section:NewLabel("ชื่อผู้เล่น: " .. playerName)
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
Section:NewButton("Discord", "Discord Link", function()
    print("https://discord.gg/4bY2Z3v3")
end)

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "แจ้งเตือน",
    Text = "โปรแกรมเริ่มรันแล้ว",
    Duration = 5,
})

local Tab = Window:NewTab("GOD")
local Section = Tab:NewSection("Player Teleport")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local selectedPlayer = nil

-- ฟังก์ชันแสดงการแจ้งเตือน
local function ShowNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3,
    })
end

-- ฟังก์ชันตรวจสอบการมีอยู่ของผู้เล่นและ character
local function IsPlayerValid(player)
    return player and player.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- ฟังก์ชันสร้างรายชื่อผู้เล่น
local function GetPlayerList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    table.sort(list)
    return list
end

-- ฟังก์ชัน teleport แบบทันที
local function InstantTeleport(targetPlayer)
    local localPlayer = Players.LocalPlayer
    
    if not IsPlayerValid(localPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของคุณได้")
        return false
    end
    
    if not IsPlayerValid(targetPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของผู้เล่นเป้าหมายได้")
        return false
    end
    
    -- เพิ่ม offset เล็กน้อยเพื่อไม่ให้ติดกัน
    local offset = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
    local targetPosition = targetPlayer.Character.HumanoidRootPart.CFrame + offset
    
    localPlayer.Character.HumanoidRootPart.CFrame = targetPosition
    ShowNotification("สำเร็จ", "Teleport ไปหา " .. targetPlayer.Name .. " แล้ว")
    return true
end

-- ฟังก์ชัน teleport แบบ smooth (ใช้ Tween)
local function SmoothTeleport(targetPlayer)
    local localPlayer = Players.LocalPlayer
    
    if not IsPlayerValid(localPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของคุณได้")
        return false
    end
    
    if not IsPlayerValid(targetPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของผู้เล่นเป้าหมายได้")
        return false
    end
    
    local humanoidRootPart = localPlayer.Character.HumanoidRootPart
    local offset = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
    local targetPosition = targetPlayer.Character.HumanoidRootPart.CFrame + offset
    
    local tweenInfo = TweenInfo.new(
        1, -- ระยะเวลา 1 วินาที
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetPosition})
    tween:Play()
    
    ShowNotification("กำลัง Teleport", "กำลัง Teleport ไปหา " .. targetPlayer.Name)
    
    tween.Completed:Connect(function()
        ShowNotification("สำเร็จ", "Teleport ไปหา " .. targetPlayer.Name .. " แล้ว")
    end)
    
    return true
end

-- สร้าง dropdown โดยใช้รายชื่อเริ่มต้น
Section:NewDropdown("เลือกผู้เล่นเพื่อ Teleport", "เลือกผู้เล่น", GetPlayerList(), function(selected)
    selectedPlayer = selected
    ShowNotification("เลือกแล้ว", "เลือกผู้เล่น: " .. selected)
end)

-- ปุ่ม Teleport แบบทันที
Section:NewButton("ไปหาผู้เล่นแบบ ทันที", "ไปหาผู้เล่นที่เลือกแบบทันที", function()
    if not selectedPlayer then
        ShowNotification("ข้อผิดพลาด", "กรุณาเลือกผู้เล่นก่อน")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    if targetPlayer then
        InstantTeleport(targetPlayer)
    else
        ShowNotification("ข้อผิดพลาด", "ไม่พบผู้เล่น " .. selectedPlayer)
        selectedPlayer = nil -- ล้างการเลือก
    end
end)

-- ปุ่ม Teleport แบบ Smooth
Section:NewButton("ไปหาผู้เล่น Smooth", "ไปหาผู้เล่นที่เลือกแบบนุ่มนวล", function()
    if not selectedPlayer then
        ShowNotification("ข้อผิดพลาด", "กรุณาเลือกผู้เล่นก่อน")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    if targetPlayer then
        SmoothTeleport(targetPlayer)
    else
        ShowNotification("ข้อผิดพลาด", "ไม่พบผู้เล่น " .. selectedPlayer)
        selectedPlayer = nil -- ล้างการเลือก
    end
end)

-- ปุ่มดึงผู้เล่นที่เลือกมาหา
Section:NewButton("ดึงผู้เล่นมาหา", "ดึงผู้เล่นที่เลือกมาหาคุณ", function()
    if not selectedPlayer then
        ShowNotification("ข้อผิดพลาด", "กรุณาเลือกผู้เล่นก่อน")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    local localPlayer = Players.LocalPlayer
    
    if not IsPlayerValid(localPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของคุณได้")
        return
    end
    
    if not IsPlayerValid(targetPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของผู้เล่นเป้าหมายได้")
        return
    end
    
    -- ดึงผู้เล่นมาหาตำแหน่งของเรา (เพิ่ม offset)
    local offset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
    local myPosition = localPlayer.Character.HumanoidRootPart.CFrame + offset
    
    targetPlayer.Character.HumanoidRootPart.CFrame = myPosition
    ShowNotification("สำเร็จ", "ดึง " .. targetPlayer.Name .. " มาหาคุณแล้ว")
end)

-- ปุ่มดึงผู้เล่นทั้งหมดมาหา
Section:NewButton("ดึงทุกคนมาหา", "ดึงผู้เล่นทั้งหมดในเซิร์ฟเวอร์มาหาคุณ", function()
    local localPlayer = Players.LocalPlayer
    
    if not IsPlayerValid(localPlayer) then
        ShowNotification("ข้อผิดพลาด", "ไม่สามารถหา Character ของคุณได้")
        return
    end
    
    local teleportedCount = 0
    local myPosition = localPlayer.Character.HumanoidRootPart.CFrame
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and IsPlayerValid(player) then
            -- สร้าง offset แบบวงกลมรอบๆ ตัวเรา
            local angle = (teleportedCount * (360 / math.max(1, #Players:GetPlayers() - 1))) * (math.pi / 180)
            local radius = 8 -- ระยะห่างจากตัวเรา
            local offset = Vector3.new(
                math.cos(angle) * radius,
                0,
                math.sin(angle) * radius
            )
            
            player.Character.HumanoidRootPart.CFrame = myPosition + offset
            teleportedCount = teleportedCount + 1
            wait(0.1) -- หน่วงเวลาเล็กน้อยเพื่อไม่ให้ lag
        end
    end
    
    if teleportedCount > 0 then
        ShowNotification("สำเร็จ", "ดึงผู้เล่น " .. teleportedCount .. " คนมาหาคุณแล้ว")
    else
        ShowNotification("ไม่มีผู้เล่น", "ไม่มีผู้เล่นอื่นในเซิร์ฟเวอร์")
    end
end)

-- ปุ่มแสดงรายชื่อผู้เล่นปัจจุบัน
Section:NewButton("แสดงรายชื่อผู้เล่น", "แสดงรายชื่อผู้เล่นทั้งหมดในเซิร์ฟเวอร์", function()
    local list = GetPlayerList()
    if #list > 0 then
        local names = table.concat(list, ", ")
        ShowNotification("ผู้เล่นในเซิร์ฟเวอร์", "จำนวน: " .. #list .. " คน", 7)
        print("ผู้เล่นในเซิร์ฟเวอร์: " .. names)
    else
        ShowNotification("ไม่มีผู้เล่น", "ไม่มีผู้เล่นอื่นในเซิร์ฟเวอร์")
    end
end)

-- Event listeners สำหรับผู้เล่นเข้า-ออก (ไม่แสดง notification)
Players.PlayerAdded:Connect(function(player)
    wait(2) -- รอให้ผู้เล่นโหลดเสร็จ
end)

Players.PlayerRemoving:Connect(function(player)
    -- ล้างการเลือกถ้าผู้เล่นที่เลือกออกไป
    if selectedPlayer == player.Name then
        selectedPlayer = nil
    end
end)
