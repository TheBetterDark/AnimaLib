type AnimationProperties = {
	Name: string,
	AnimationId: string,
	AdjustSpeed: number?,
	Weight: number?,
	FadeIn: number?,
	FadeOut: number?,
	Looped: boolean?,
	Duration: number?,
}

type AnimatonType = {
	LoadAnimation: (name: string, animation: Animation) -> AnimationTrack,
	UnloadAnimation: (name: string) -> nil,
	PlayAnimation: (animation: string, properties: AnimationProperties) -> AnimationTrack,
	StopAnimation: (animation: string, properties: AnimationProperties) -> AnimationTrack,
	StopAllAnimations: (properties: AnimationProperties) -> nil,
}

local AnimaLib = {}
AnimaLib.__index = AnimaLib

function AnimaLib.new(humanoid: Humanoid): AnimatonType
	local self = setmetatable({}, AnimaLib)
	self.Humanoid = humanoid
	self.Animator = humanoid:FindFirstChildOfClass("Animator") or humanoid

	self.LoadedAnimations = {}
	self.PlayingAnimations = {}

	return self
end

function createAnimationInstance(animationId)
	local instance = Instance.new("Animation")
	instance.AnimationId = animationId
	return instance
end

function AnimaLib:LoadAnimation(animationName: string, animationId: number): AnimationTrack
	if self.LoadedAnimations[animationName] then
		warn("AnimaLib: '" .. animationName .. "' is already loaded.")
		return
	end

	-- Check if animationId is in the correct format
	if typeof(animationId) ~= "number" then
		error("AnimaLib: '" .. tostring(animationId) .. "' is not a valid AnimationId.")
	end

	local animation = createAnimationInstance(`rbxassetid://${animationId}`)
	self.LoadedAnimations[animationName] = self.Animator:LoadAnimation(animation)

	return self.LoadedAnimations[animationName.Name]
end

function AnimaLib:UnloadAnimation(name: string)
	if not self.LoadedAnimations[name] then
		error("AnimaLib: Unable to unload animation '" .. name .. "' because it is not loaded.")
	end
	self.LoadedAnimations[name] = nil
end

function AnimaLib:PlayAnimation(animationName: string, properties: AnimationProperties, ignorePlaying: boolean): AnimationTrack
	assert(self.LoadedAnimations[animationName], "AnimaLib: Unable to play animation '" .. animationName .. "' because it is not loaded.")

	if self.PlayingAnimations[animationName] and not ignorePlaying then
		warn("AnimaLib: '" .. animationName .. "' is already playing.")
		return
	end

	local animationTrack = self.LoadedAnimations[animationName]
	properties.AdjustSpeed = properties and properties.AdjustSpeed or 1
	properties.Weight = properties and properties.Weight or 1
	properties.FadeIn = properties and properties.FadeIn or 0
	properties.FadeOut = properties and properties.FadeOut or 0
	properties.Looped = properties and properties.Looped or false
	properties.Duration = properties and properties.Duration or false

	animationTrack:Play(properties.FadeIn, properties.Weight, properties.AdjustSpeed)
	animationTrack.Looped = properties.Looped

	self.PlayingAnimations[animationName] = {
		AnimationTrack = animationTrack,
		Properties = properties,
	}

	if properties.Duration then
		task.delay(properties.Duration, function()
			animationTrack:Stop(properties.FadeOut)
			self.PlayingAnimations[animationName] = nil
		end)
	else
		if not properties.Looped then
			task.delay(animationTrack.Length, function()
				animationTrack:Stop(properties.FadeOut)
				self.PlayingAnimations[animationName] = nil
			end)
		end
	end

	return animationTrack
end

function AnimaLib:StopAnimation(animationName: string): nil
	assert(self.PlayingAnimations[animationName], "AnimaLib: Unable to stop animation '" .. animationName .. "' because it is not playing.")

	local playingAnimation = self.PlayingAnimations[animationName]
	local animationTrack: AnimationTrack = playingAnimation.AnimationTrack
	local properties: AnimationProperties = playingAnimation.Properties

	if animationTrack.IsPlaying then
		animationTrack:Stop(properties.FadeOut)
	end
end

function AnimaLib:StopAllAnimations(): nil
	for animationName, playingAnimation in pairs(self.LoadedAnimations) do
		local AnimationTrack: AnimationTrack = playingAnimation.AnimationTrack
		local properties: AnimationProperties = playingAnimation.Properties

		if AnimationTrack.IsPlaying then
			AnimationTrack:Stop(properties.FadeOut)
			self.PlayingAnimations[animationName] = nil
		end
	end
end

return AnimaLib
