--[=[
	@interface AnimatorClass
	@within AnimaLib

	.Animator Animator
	.LoadedAnimations {string: AnimationTrack}
	.PlayingAnimations {string: PlayingAnimation}

	.LoadAnimation(string, number) -> AnimationTrack
	.GetAnimationTrack(string) -> AnimationTrack
	.PlayAnimation(string, AnimationProperties, boolean?) -> AnimationTrack
	.StopAnimation(string, number?) -> nil
	.StopAllAnimations() -> nil
	.Destroy() -> nil

	AnimatorClass is a table that contains the Animator, LoadedAnimations, and PlayingAnimations tables. It also contains functions that you can use to interact with the Animator & AnimationTracks. This is returned when you create a new AnimaLib instance.
]=]
export type AnimatorClass = {
	Animator: Animator | AnimationController,
	LoadedAnimations: { [string]: AnimationTrack },
	PlayingAnimations: { [string]: PlayingAnimation },

	LoadAnimation: (animationName: string, animationId: Animation) -> AnimationTrack,
	PlayAnimation: (animation: string, properties: AnimationProperties) -> AnimationTrack,
	StopAnimation: (animation: string, properties: AnimationProperties) -> AnimationTrack,
	StopAllAnimations: (properties: AnimationProperties) -> nil,
}

--[=[
	@interface AnimationProperties
	@within AnimaLib

	.Speed number?
	.Weight number?
	.FadeIn number?
	.FadeOut number?
	.Looped boolean?
	.Priority Enum.AnimationPriority?

	AnimationProperties is a table that contains properties that you can used to influence how an animation is played.
]=]
export type AnimationProperties = {
	Speed: number,
	Weight: number,
	FadeIn: number,
	FadeOut: number,
	Looped: boolean,
	Priority: Enum.AnimationPriority,
}

--[=[
	@interface PlayingAnimation
	@within AnimaLib

	.AnimationTrack AnimationTrack
	.Properties AnimationProperties

	PlayingAnimation is a table that contains an AnimationTrack and AnimationProperties. This is returned when you play an animation.
]=]
export type PlayingAnimation = {
	AnimationTrack: AnimationTrack,
	Properties: AnimationProperties,
}

local Janitor = require(script.Parent.Janitor)

--[=[
	@class AnimaLib
	@server
	@client

	This is the API documentation for AnimaLib module. This includes all the API functions and properties that you can use.
	```lua
	local AnimaLib = require(somePath.AnimaLib)
	local Animator = someInstance.Animator

	local AnimaLib = AnimaLib.new(Animator)
	```
]=]
local AnimaLib = {}
AnimaLib.__index = AnimaLib

--[=[
	@param animator Animator
	@param preferLodEnabled boolean?
	@return AnimatorClass

	This creates a new AnimaLib instance.
	```lua
	local AnimaLib = AnimaLib.new(Animator)
	```
	:::tip
	You can set preferLodEnabled to false if you want to disable the animator's PreferLodEnabled property. To find out more about PreferLodEnabled, check out the [roblox api reference](https://developer.roblox.com/en-us/api-reference/property/Animator/PreferLodEnabled).
	:::
]=]
function AnimaLib.new(animator: Animator, preferLodEnabled: boolean?): AnimatorClass
	assert(typeof(animator) == "Instance" and animator:IsA("Animator"), "AnimaLib: Expected animator to be an 'Animator' type")

	local self = {}
	self._animator = animator
	self._animator.PreferLodEnabled = preferLodEnabled == nil and true or preferLodEnabled

	self.LoadedAnimations = {}
	self.PlayingAnimations = {}

	return setmetatable(self, AnimaLib)
end

--[=[
	@param animationName string
	@param animationId number
	@return AnimationTrack

	This function will load an animation and return an AnimationTrack.
	```lua
	local AnimaLib = AnimaLib.new(Animator)
	local AnimationTrack = AnimaLib:LoadAnimation("AnimationName", "rbxassetid://123456789")
	```

	:::warning
	You can't load animations with the same name more than once. If you try to load an animation with the same name more than once, it will throw an error.
	:::
]=]
function AnimaLib:LoadAnimation(animationName: string, animationId: number): AnimationTrack
	assert(type(animationName) == "string", "AnimLib: Expected animationName to be a string.")
	assert(type(animationId) == "string", "AnimLib: Expected animationId to be a string.")

	if self.LoadedAnimations[animationName] then
		error(string.format("AnimaLib: Unable to load animation. '%s' already exists.", animationName))
	end

	if animationId:sub(1, 13) ~= "rbxassetid://" then
		error(string.format("AnimaLib: '%s' is not a valid AnimationId.", tostring(animationId)))
	end

	if tonumber(animationId:sub(14, #animationId)) == nil then
		error(string.format("AnimaLib: AnimationId contains invalid characters > '%s'", tostring(animationId)))
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = animationId

	self.LoadedAnimations[animationName] = self._animator:LoadAnimation(animation)
	return self.LoadedAnimations[animationName]
end

--[=[
	@param animationName string
	@return AnimationTrack

	This function will return an AnimationTrack.

	:::tip
	You can use this to connect to events on the AnimationTrack.
	```lua
	local AnimaLib = AnimaLib.new(Animator)
	local AnimationTrack = AnimaLib:GetAnimationTrack("AnimationName")

	AnimationTrack.Stopped:Connect(function()
		print("Animation stopped!")
	end)
	```
	:::
]=]
function AnimaLib:GetAnimationTrack(animationName: string): AnimationTrack
	assert(type(animationName) == "string", "AnimLib: Expected animationName to be a string.")
	assert(self.LoadedAnimations[animationName], string.format("AnimaLib: Unable to get animation '%s' because it is not loaded.", animationName))
	return self.LoadedAnimations[animationName]
end

--[=[
	@param animationName string
	@param properties AnimationProperties?
	@param ignorePlaying boolean?
	@return AnimationTrack

	This function will play an animation.
	```lua
	local AnimaLib = AnimaLib.new(Animator)
	local AnimationTrack = AnimaLib:PlayAnimation("AnimationName", {
		Speed = 1,
		Weight = 1,
		FadeIn = 0,
		FadeOut = 0,
		Looped = false,
		Priority = Enum.AnimationPriority.Action,
	})
	```

	:::caution
	You can only play animations that have been loaded using [AnimaLib:LoadAnimation](#LoadAnimation).
	:::
	:::warning
	Roblox enforces a limit on how many tracks can be playing at once. This limit is 256. If you try to play more than 256 animations at once, it will not play. See [this](https://devforum.roblox.com/t/is-there-a-way-to-unload-animations/1525525/12) devforum post for more information.
	:::
]=]
function AnimaLib:PlayAnimation(animationName: string, properties: AnimationProperties, ignorePlaying: boolean): AnimationTrack
	assert(self.LoadedAnimations[animationName], string.format("AnimaLib: Unable to play animation '%s' because it is not loaded.", animationName))

	if self.PlayingAnimations[animationName] and not ignorePlaying then
		return
	end

	local animationTrack: AnimationTrack = self.LoadedAnimations[animationName]

	properties = properties or {}
	properties.Speed = properties and properties.Speed or 1
	properties.Weight = properties and properties.Weight or 1
	properties.FadeIn = properties and properties.FadeIn or 0
	properties.FadeOut = properties and properties.FadeOut or 0
	properties.Looped = properties and properties.Looped or false
	properties.Priority = properties and properties.Priority or Enum.AnimationPriority.Action

	animationTrack.Looped = properties.Looped
	animationTrack.Priority = properties.Priority
	animationTrack:Play(properties.FadeIn, properties.Weight, properties.Speed)

	self.PlayingAnimations[animationName] = {
		AnimationTrack = animationTrack,
		Properties = properties,
	}

	local janitor = Janitor.new()
	janitor:Add(animationTrack.Stopped:Connect(function()
		janitor:Destroy()
		self.PlayingAnimations[animationName] = nil
	end))

	return animationTrack
end

--[=[
	@param animationName string
	@param overrideFadeOut number?
	@return nil

	This function will stop an animation.
]=]
function AnimaLib:StopAnimation(animationName: string, overrideFadeOut: number?)
	assert(self.LoadedAnimations[animationName], string.format("AnimaLib: Unable to stop animation '%s' because it is not loaded.", animationName))

	local playingAnimation: PlayingAnimation = self.PlayingAnimations[animationName]
	if not playingAnimation then
		return
	end

	local animationTrack = playingAnimation.AnimationTrack
	local FadeOut = overrideFadeOut or playingAnimation.Properties.FadeOut

	if animationTrack.IsPlaying then
		animationTrack:Stop(FadeOut)
	end
end

--[=[
	@return nil

	This function will stop all animations.

	:::caution
	This will only stop animations in the scope of the AnimaLib instance. If you have multiple AnimaLib instances, you will need to call this function on each instance.
	:::
]=]
function AnimaLib:StopAllAnimations()
	if not self.PlayingAnimations then
		return
	end

	for animationName, _ in pairs(self.PlayingAnimations) do
		self:StopAnimation(animationName)
	end
	task.wait()
end

--[=[
	@return nil

	This function will destroy the AnimaLib instance.

	:::caution
	This will only destroy the AnimaLib instance. If you have multiple AnimaLib instances, you will need to call this function on each instance.
	:::
]=]
function AnimaLib:Destroy()
	self:StopAllAnimations()
	self.LoadedAnimations = nil
	self.PlayingAnimations = nil
end

return AnimaLib
