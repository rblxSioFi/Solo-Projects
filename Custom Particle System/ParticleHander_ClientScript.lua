-- Get our attribute variables + UI --
local Button = script.Parent

local Description = script:GetAttribute("Description")
local ImageId = script:GetAttribute("ImageId")
local ParticleName = script:GetAttribute("ParticleName")
local ParticlePrice = script:GetAttribute("ParticlePrice")
local ClickDelay = script:GetAttribute("ClickDelay")

-- Set the buttons name so we don't have to --
Button.Text = ParticleName
Button.Name = ParticleName

local SideBar = script.Parent.Parent.Parent:WaitForChild("SideBar")

-- Get the Sound Variables --
local SoundFolder = script.Parent.Parent.Parent:WaitForChild("Sounds")

local ClickSound = SoundFolder:WaitForChild("ClickSound")

-- Get the RemoteFunction so we can tell the server to return if we have the thing or not --
local Remote = game:GetService("ReplicatedStorage").ArmParticleSystem:WaitForChild("GetParticle")

-- Get the Debounce so we don't fire too many times --
local db = false

local Type = "GetInfo"

Button.MouseButton1Click:Connect(function()
	if not db then
		db = true
		
		-- Get the area that we need to update --
		local DescriptionBox = SideBar:WaitForChild("Description")
		local NameBox = SideBar:WaitForChild("ParticleName")
		local PriceBox = SideBar:WaitForChild("Price")
		local PreviewBox = SideBar:WaitForChild("Preview")
		
		-- Get the Buy and Equip Button --
		local EquipButton = SideBar:WaitForChild("Equip")
		local BuyButton = SideBar:WaitForChild("Buy")
		
		-- Get the SelectedParticle object so we can tell the Buy and Equip what to do --
		local SelectedParticle = SideBar:WaitForChild("SelectedParticle")
		SelectedParticle.Value = ParticleName
		
		-- Now update it when we click --
		ClickSound:Play()
		
		DescriptionBox.Text = Description
		NameBox.Text = ParticleName
		PriceBox.Text = "Price: "..ParticlePrice.." token(s)"
		PreviewBox.Image = "rbxassetid://"..ImageId
		
		local SentRequest = Remote:InvokeServer(Type, ParticleName, ParticlePrice)
		
		if SentRequest == false then
			
			-- Make the EquipButton grey if we don't have the selected particle
			EquipButton:WaitForChild("UIGradient").Color = ColorSequence.new(Color3.fromRGB(117, 117, 117), Color3.fromRGB(255, 255, 255))
			EquipButton:WaitForChild("CanEquip").Value = false
			-- Make the buy button show green so we can buy it --
			BuyButton:WaitForChild("UIGradient").Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 255))
			BuyButton:WaitForChild("CanBuy").Value = true
			
		elseif SentRequest == true then
			
			
			-- Make the EquipButton green because the server says we have it --
			EquipButton:WaitForChild("UIGradient").Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 255))
			EquipButton:WaitForChild("CanEquip").Value = true
			-- Make the buy button show grey so we cannot buy it again --
			BuyButton:WaitForChild("UIGradient").Color = ColorSequence.new(Color3.fromRGB(117, 117, 117), Color3.fromRGB(255, 255, 255))
			BuyButton:WaitForChild("CanBuy").Value = false
			
		end
		
		task.wait(ClickDelay)
		
		db = false
		
	end
end)