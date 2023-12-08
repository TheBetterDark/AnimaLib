local TestService = game:GetService("TestService")
local TestEZ = require(TestService.DevPackages.TestEZ)
TestEZ.TestBootstrap:run({
	game.ReplicatedStorage.Packages.AnimaLib,
})
