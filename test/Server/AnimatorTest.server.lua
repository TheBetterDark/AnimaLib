local NPC = workspace:WaitForChild("Rig")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requring AnimaLib
local AnimaLib = require(ReplicatedStorage.AnimaLib)

--! Trying to create AnimaLib Object without Animator **ERROR**
-- local Animator = AnimaLib.new(nil)

--! Trying to create AnimaLib Object that isnt Animator **ERROR**
-- local Animator = AnimaLib.new(workspace:WaitForChild("Baseplate"))

-- Creating AnimaLib Object
local Animator = AnimaLib.new(NPC.AnimationController:WaitForChild("Animator"))

--! Trying to play animation that is not loaded **ERROR**
-- Animator:PlayAnimation("Idle")

--! Trying to stop animation that is not loaded **ERROR**
-- Animator:StopAnimation("Idle")

--! Trying to load animation that is already loaded **ERROR**
-- Animator:LoadAnimation("Idle", "rbxassetid://507766388")

--! Trying to load wthout animationName **ERROR**
-- Animator:LoadAnimation(nil, "rbxassetid://507766388")

--! Trying to load animationName that isnt a string **ERROR**
-- Animator:LoadAnimation(123, "rbxassetid://507766388")

--! Trying to load wthout animationId **ERROR**
-- Animator:LoadAnimation("Idle", nil)

--! Trying to load animationId that isnt a string **ERROR**
-- Animator:LoadAnimation("Idle", 123)

--! Trying to load animationId that doesnt start with "rbxassetid://" **ERROR**
-- Animator:LoadAnimation("Idle", "123")

--! Trying to load animationId that contains invaid characters after "rbxassetid://" **ERROR**
-- Animator:LoadAnimation("Idle", "rbxassetid://123a")

--! Trying to get animation wthout argument **ERROR**
-- Animator:GetAnimationTrack(nil)

--! Trying to get animation that isnt a string **ERROR**
-- Animator:GetAnimationTrack(123)

--! Trying to get animation that is not loaded **ERROR**
-- Animator:GetAnimationTrack("123")

-- Loading animation
Animator:LoadAnimation("Idle", "rbxassetid://507766388")

-- Getting animation
Animator:GetAnimationTrack("Idle")

-- Playing animation
Animator:PlayAnimation("Idle", { Looped = false })
task.wait(5)

--! Trying to play animation that is already playing **WARNING**
-- Animator:PlayAnimation("Idle", { Looped = true })

-- Stopping all animations
Animator:StopAllAnimations()

-- Playing animation (with custom properties)
Animator:PlayAnimation("Idle", {
	Looped = true,
	Speed = -1,
	FadeIn = 0.5,
	FadeOut = 0.5,
	Weight = 0.5,
})
task.wait(5)

-- Unloading animator
Animator:Destroy()
