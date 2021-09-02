-- This script simply checks to see if the player made their OwnedParticlesTable yet, and if they haven't, we add it then save it.

local DataStoreService = game:GetService("DataStoreService")
local OwnedParticles = DataStoreService:GetDataStore("OwnedParticles")
local EquippedParticle = DataStoreService:GetDataStore("EquippedParticle")

game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		
		local success, failure = pcall(function()
			if OwnedParticles:GetAsync(Player.UserId) == nil then

				local OwnedParticlesTable = {}

				OwnedParticles:SetAsync(Player.UserId, OwnedParticlesTable)

				warn("Owned Particles Table didn't exist, so we made it for the player.")

			else
				warn(Player.Name.." already has OwnedParticleTable in their DataStore: "..OwnedParticles.Name)

				local success, failure = pcall(function()

					if EquippedParticle:GetAsync(Player.UserId) == nil then
						-- don't do it
					else
						local RetrievedParticleName = EquippedParticle:GetAsync(Player.UserId)
						local FoundParticle = game:GetService("ServerStorage").ParticleStorage[RetrievedParticleName]

						FoundParticle:Clone().Parent = Character["Left Arm"]
						FoundParticle:Clone().Parent = Character["Right Arm"]
					end

				end)

				if failure then
					warn("Unable to load Particle from DataStore: "..EquippedParticle.Name..". Exception: "..failure)
				end

			end
		end)
		
	end)
end)