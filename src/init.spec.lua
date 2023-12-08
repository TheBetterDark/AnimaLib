--# selene: allow(undefined_variable)
return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local InsertService = game:GetService("InsertService")

	local AnimaLib = require(ReplicatedStorage.Packages.AnimaLib)

	-- Insert Rig into workspace
	local workspace = game:GetService("Workspace")
	local model = InsertService:LoadAsset(15577562614)
	model.Parent = workspace

	-- Get Animator
	local animator = model.Rig.AnimationController.Animator

	local globalState = {}
	afterEach(function()
		if globalState.Animator then
			globalState.Animator:Destroy()
		end
		globalState.Animator = AnimaLib.new(animator)
	end)

	describe("AnimaLib.new", function()
		it("SHOULD return an AnimaLib instance", function()
			expect(function()
				globalState.Animator = AnimaLib.new(animator)
			end).to.never.throw()
		end)

		it("SHOULD error if the argument is not an Animator", function()
			expect(function()
				globalState.Animator = AnimaLib.new("not an animator")
			end).to.throw()
		end)
	end)

	describe("AnimaLib:LoadAnimation", function()
		it("SHOULD load an animation", function()
			expect(function()
				globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			end).to.never.throw()
		end)

		it("SHOULD error if the animation already exists", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")

			expect(function()
				globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			end).to.throw()
		end)

		it("SHOULD error if the animationId is not a string", function()
			expect(function()
				globalState.Animator:LoadAnimation("TestAnimation", 0)
			end).to.throw()
		end)

		it("SHOULD error if the animationId is not a valid AnimationId", function()
			expect(function()
				globalState.Animator:LoadAnimation("TestAnimation", "not an animation id")
			end).to.throw()
		end)

		it("SHOULD error if the animationId contains invalid characters", function()
			expect(function()
				globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://not a number")
			end).to.throw()
		end)

		it("SHOULD return an AnimationTrack", function()
			local animationTrack = globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			expect(animationTrack).to.be.ok()
			expect(animationTrack).to.be.a("userdata")
		end)

		it("SHOULD add the AnimationTrack to the LoadedAnimations table", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			expect(globalState.Animator.LoadedAnimations.TestAnimation).to.be.ok()
		end)
	end)

	describe("AnimaLib:GetAnimationTrack", function()
		it("SHOULD return an AnimationTrack", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			local animationTrack = globalState.Animator:GetAnimationTrack("TestAnimation")
			expect(animationTrack).to.be.ok()
			expect(animationTrack).to.be.a("userdata")
		end)

		it("SHOULD error if the animation does not exist", function()
			expect(function()
				globalState.Animator:GetAnimationTrack("TestAnimation")
			end).to.throw()
		end)
	end)

	describe("AnimaLib:PlayAnimation", function()
		it("SHOULD play an animation", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			expect(function()
				globalState.Animator:PlayAnimation("TestAnimation")
			end).to.never.throw()
		end)

		it("SHOULD error if the animation does not exist", function()
			expect(function()
				globalState.Animator:PlayAnimation("TestAnimation")
			end).to.throw()
		end)

		it("SHOULD error if the animation is already playing", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			globalState.Animator:PlayAnimation("TestAnimation")

			expect(function()
				globalState.Animator:PlayAnimation("TestAnimation")
			end).to.never.throw()
		end)

		it("SHOULD not error if the animation is already playing and ignorePlaying is true", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			globalState.Animator:PlayAnimation("TestAnimation")

			expect(function()
				globalState.Animator:PlayAnimation("TestAnimation", nil, true)
			end).to.never.throw()
		end)

		it("SHOULD set the AnimationTrack's properties to the given properties", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			local animationTrack = globalState.Animator:PlayAnimation("TestAnimation", {
				Speed = 2,
				Weight = 0.5,
				FadeIn = 1,
				FadeOut = 1,
				Looped = true,
				Priority = Enum.AnimationPriority.Action3,
			})

			expect(animationTrack.Speed).to.equal(2)
			expect(animationTrack.WeightTarget).to.equal(0.5)
			expect(globalState.Animator.PlayingAnimations.TestAnimation.Properties.FadeIn).to.equal(1)
			expect(globalState.Animator.PlayingAnimations.TestAnimation.Properties.FadeOut).to.equal(1)
			expect(animationTrack.Looped).to.equal(true)
			expect(animationTrack.Priority).to.equal(Enum.AnimationPriority.Action3)
		end)

		it("SHOULD add the animation to the PlayingAnimations table", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			globalState.Animator:PlayAnimation("TestAnimation", { Looped = true })
			expect(globalState.Animator.PlayingAnimations.TestAnimation).to.be.ok()
		end)

		it("SHOULD return an AnimationTrack", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			local animationTrack = globalState.Animator:PlayAnimation("TestAnimation")
			expect(animationTrack).to.be.ok()
			expect(animationTrack).to.be.a("userdata")
		end)
	end)

	describe("AnimaLib:StopAnimation", function()
		it("SHOULD stop an animation", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			globalState.Animator:PlayAnimation("TestAnimation")
			expect(function()
				globalState.Animator:StopAnimation("TestAnimation")
			end).to.never.throw()
		end)

		it("SHOULD error if the animation does not exist", function()
			expect(function()
				globalState.Animator:StopAnimation("TestAnimation")
			end).to.throw()
		end)

		it("SHOULD not error if the animation is not playing", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			expect(function()
				globalState.Animator:StopAnimation("TestAnimation")
			end).to.never.throw()
			expect(globalState.Animator.PlayingAnimations.TestAnimation).to.equal(nil)
		end)
	end)

	describe("AnimaLib:StopAllAnimations", function()
		it("SHOULD stop all animations", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			globalState.Animator:PlayAnimation("TestAnimation")
			expect(function()
				globalState.Animator:StopAllAnimations()
			end).to.never.throw()
			expect(globalState.Animator.PlayingAnimations.TestAnimation).to.equal(nil)
			expect(globalState.Animator.LoadedAnimations.TestAnimation).to.be.ok()
		end)
	end)

	describe("AnimaLib:Destroy", function()
		it("SHOULD destroy the AnimaLib instance", function()
			globalState.Animator:LoadAnimation("TestAnimation", "rbxassetid://507766388")
			globalState.Animator:PlayAnimation("TestAnimation")
			expect(function()
				globalState.Animator:Destroy()
			end).to.never.throw()
			expect(globalState.Animator.PlayingAnimations).to.equal(nil)
			expect(globalState.Animator.LoadedAnimations).to.equal(nil)
		end)
	end)
end
