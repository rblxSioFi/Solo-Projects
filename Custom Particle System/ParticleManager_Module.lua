local ParticleStorage = game:GetService("ServerStorage"):WaitForChild("ParticleStorage")

local Particles = {
	
	["Summer Fire"] = {
		
		ServerPrice = 1,
		FoundParticle = ParticleStorage:WaitForChild("Summer Fire")
		
	},
	
	-- Another particle goes here --

}

return Particles
