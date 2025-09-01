local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Kernelx", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("User Info")
local playerName = game.Players.LocalPlayer.Name

-- สร้าง label แสดงชื่อผู้เล่น
Section:NewLabel("ชื่อผู้เล่น: " .. playerName)
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
Section:NewButton("Teleport ทันที", "Teleport ไปหาผู้เล่นที่เลือกแบบทันที", function()
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
Section:NewButton("Teleport แบบ Smooth", "Teleport ไปหาผู้เล่นที่เลือกแบบนุ่มนวล", function()
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

-- Event listeners สำหรับผู้เล่นเข้า-ออก
Players.PlayerAdded:Connect(function(player)
    wait(2) -- รอให้ผู้เล่นโหลดเสร็จ
    ShowNotification("ผู้เล่นเข้าร่วม", player.Name .. " เข้าร่วมเซิร์ฟเวอร์")
end)

Players.PlayerRemoving:Connect(function(player)
    ShowNotification("ผู้เล่นออกจากเซิร์ฟเวอร์", player.Name .. " ออกจากเซิร์ฟเวอร์")
    -- ล้างการเลือกถ้าผู้เล่นที่เลือกออกไป
    if selectedPlayer == player.Name then
        selectedPlayer = nil
        ShowNotification("แจ้งเตือน", "ผู้เล่นที่เลือกออกจากเซิร์ฟเวอร์แล้ว")
    end
end)