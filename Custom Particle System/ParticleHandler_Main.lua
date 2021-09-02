-- Get the Particle Module --
local ParticleModule = require(script.ParticleManager)

-- Get the DataStoreService so we can check for Owned Particles --
local DataStoreService = game:GetService("DataStoreService")
local OwnedParticles = DataStoreService:GetDataStore("OwnedParticles")
local EquippedParticle = DataStoreService:GetDataStore("EquippedParticle")

-- Get the RemoteFunction so we can handle requests --
local Remote1 = game:GetService("ReplicatedStorage").ArmParticleSystem:WaitForChild("GetParticle")
local Remote2 = game:GetService("ReplicatedStorage").ArmParticleSystem:WaitForChild("BuyParticle")

local function CheckIfPlayerOwnsParticle(Player, Type, ParticleName, ParticlePrice, AlreadyEquipped)
	if Type == "GetInfo" then

		if ParticleModule[ParticleName] then

			local success, failure = pcall(function()
				ReceivedData = OwnedParticles:GetAsync(Player.UserId)
			end)

			if failure then
				warn("Unable to check if the player owns the particle: '"..ParticleName.."' because we weren't able to reach the DataStore. Exception: "..failure)
			end

			if ReceivedData == nil then
				return false
			else
				if table.find(ReceivedData, ParticleName) then
					return true
				else
					return false
				end
			end

		end

	elseif Type == "Equip" then

		if ParticleModule[ParticleName] then

			local success, failure = pcall(function()
				ReceivedData2 = OwnedParticles:GetAsync(Player.UserId)
			end)

			if failure then
				warn("Unable to check if the player owns the particle: '"..ParticleName.."' because we weren't able to reach the DataStore. Exception: "..failure)
			end
			
			-- If the players data is empty, then don't run this code at all.
			if ReceivedData2 == nil then
				-- do nothing
				return false
			else
				
				-- Check to see if the Player has the particle in their saved particle list. If they do, then run the code below:
				if table.find(ReceivedData2, ParticleName) then
					
					-- Get the ParticleName by retrieving it from the DataStore --
					local ParticleStorage = game:GetService("ServerStorage"):WaitForChild("ParticleStorage")
					local ParticleToCopy = ParticleStorage[ParticleName]
					
					-- Get the Character so we can clone the effects
					local Character = Player.Character
					
					-- Prevent players from equipping the same particle twice!
					if Character["Left Arm"]:FindFirstChild(ParticleName) and Character["Right Arm"]:FindFirstChild(ParticleName) then
						-- Tell the client they cannot equip because they already have it equipped.
						return false
					else
						
						-- Copy the particle that the client told the server and give it to the player --
						ParticleToCopy:Clone().Parent = Character["Left Arm"]
						ParticleToCopy:Clone().Parent = Character["Right Arm"]

						EquippedParticle:SetAsync(Player.UserId, ParticleName)
						
						-- Tell the client that they were able to equip it just fine.
						return true

					end
					
				else
					
					-- The user doesn't have ANY data regarding the Particles name, then don't let them equip it, because they have nothing
					return false
				end

			end

		end

	end
end



Remote1.OnServerInvoke = CheckIfPlayerOwnsParticle



local function onParticleBought(Player, SelectedParticle)

	local success, failure = pcall(function()
		SavedTable = OwnedParticles:GetAsync(Player.UserId)
	end)

	if failure then
		warn("We weren't able to buy the item: '"..SelectedParticle.."' for the Player: "..Player.Name.." due to an error with DataStores. Exception: "..failure)
		return false
	end

	if ParticleModule[SelectedParticle] then
		if not table.find(SavedTable, SelectedParticle) then
			local ParticleToSave = ParticleModule[SelectedParticle]

			local TokenAmount = Player:WaitForChild("leaderstats").Tokens
			TokenAmount.Value = TokenAmount.Value - ParticleToSave.ServerPrice

			for i, v in pairs(SavedTable) do
				print(v)
			end

			table.insert(SavedTable, SelectedParticle)

			OwnedParticles:SetAsync(Player.UserId, SavedTable)

			return true
		else
			return false
		end
	end
end

Remote2.OnServerInvoke = onParticleBought