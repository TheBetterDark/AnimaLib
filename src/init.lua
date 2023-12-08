export type AnimatorClass = {
	Animator: Animator | AnimationController,
	LoadedAnimations: { [string]: AnimationTrack },
	PlayingAnimations: { [string]: PlayingAnimation },

	LoadAnimation: (animationName: string, animationId: Animation) -> AnimationTrack,
	PlayAnimation: (animation: string, properties: AnimationProperties) -> AnimationTrack,
	StopAnimation: (animation: string, properties: AnimationProperties) -> AnimationTrack,
	StopAllAnimations: (properties: AnimationProperties) -> nil,
}

export type AnimationProperties = {
	Speed: number,
	Weight: number,
	FadeIn: number,
	FadeOut: number,
	Looped: boolean,
	Priority: Enum.AnimationPriority,
}

export type PlayingAnimation = {
	AnimationTrack: AnimationTrack,
	Properties: AnimationProperties,
}

local Janitor = require(script.Parent.Janitor)

local AnimaLib = {}
AnimaLib.__index = AnimaLib

function AnimaLib.new(animator: Animator | AnimationController, preferLodEnabled: boolean?): AnimatorClass
	assert(typeof(animator) == "Instance" and animator:IsA("Animator"), "AnimaLib: Expected animator to be an 'Animator' type")

	local self = {}
	self._animator = animator
	self._animator.PreferLodEnabled = preferLodEnabled == nil and true or preferLodEnabled

	self.LoadedAnimations = {}
	self.PlayingAnimations = {}

	return setmetatable(self, AnimaLib)
end

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

function AnimaLib:GetAnimationTrack(animationName: string): AnimationTrack
	assert(type(animationName) == "string", "AnimLib: Expected animationName to be a string.")
	assert(self.LoadedAnimations[animationName], string.format("AnimaLib: Unable to get animation '%s' because it is not loaded.", animationName))
	return self.LoadedAnimations[animationName]
end

function AnimaLib:PlayAnimation(animationName: string, properties: AnimationProperties, ignorePlaying: boolean)
	assert(self.LoadedAnimations[animationName], string.format("AnimaLib: Unable to play animation '%s' because it is not loaded.", animationName))

	if self.PlayingAnimations[animationName] and not ignorePlaying then
		warn(string.format("AnimaLib: '%s' is already playing.", animationName))
		return
	end

	local animationTrack: AnimationTrack = self.LoadedAnimations[animationName]
	properties.Speed = properties and properties.AdjustSpeed or 1
	properties.Weight = properties and properties.Weight or 1
	properties.FadeIn = properties and properties.FadeIn or 0
	properties.FadeOut = properties and properties.FadeOut or 0
	properties.Looped = properties and properties.Looped or false
	properties.Priority = properties and properties.Priority or Enum.AnimationPriority.Action

	animationTrack.Looped = properties.Looped
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

function AnimaLib:StopAnimation(animationName: string, overrideFadeOut)
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

function AnimaLib:StopAllAnimations()
	for animationName, _ in pairs(self.PlayingAnimations) do
		self:StopAnimation(animationName)
	end
	task.wait()
end

function AnimaLib:Destroy()
	self:StopAllAnimations()
	self.LoadedAnimations = nil
	self.PlayingAnimations = nil
end

return AnimaLib
