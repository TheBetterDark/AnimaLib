"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[957],{24747:n=>{n.exports=JSON.parse('{"functions":[{"name":"new","desc":"This creates a new AnimaLib instance.\\n```lua\\nlocal AnimaLib = AnimaLib.new(Animator)\\n```\\n:::tip\\nYou can set preferLodEnabled to false if you want to disable the animator\'s PreferLodEnabled property. To find out more about PreferLodEnabled, check out the [roblox api reference](https://developer.roblox.com/en-us/api-reference/property/Animator/PreferLodEnabled).\\n:::","params":[{"name":"animator","desc":"","lua_type":"Animator"},{"name":"preferLodEnabled","desc":"","lua_type":"boolean?"}],"returns":[{"desc":"","lua_type":"AnimatorClass"}],"function_type":"static","source":{"line":96,"path":"src/init.lua"}},{"name":"LoadAnimation","desc":"This function will load an animation and return an AnimationTrack.\\n```lua\\nlocal AnimaLib = AnimaLib.new(Animator)\\nlocal AnimationTrack = AnimaLib:LoadAnimation(\\"AnimationName\\", \\"rbxassetid://123456789\\")\\n```\\n\\n:::warning\\nYou can\'t load animations with the same name more than once. If you try to load an animation with the same name more than once, it will throw an error.\\n:::","params":[{"name":"animationName","desc":"","lua_type":"string"},{"name":"animationId","desc":"","lua_type":"number"}],"returns":[{"desc":"","lua_type":"AnimationTrack"}],"function_type":"method","source":{"line":124,"path":"src/init.lua"}},{"name":"GetAnimationTrack","desc":"This function will return an AnimationTrack.\\n\\n:::tip\\nYou can use this to connect to events on the AnimationTrack.\\n```lua\\nlocal AnimaLib = AnimaLib.new(Animator)\\nlocal AnimationTrack = AnimaLib:GetAnimationTrack(\\"AnimationName\\")\\n\\nAnimationTrack.Stopped:Connect(function()\\n\\tprint(\\"Animation stopped!\\")\\nend)\\n```\\n:::","params":[{"name":"animationName","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"AnimationTrack"}],"function_type":"method","source":{"line":165,"path":"src/init.lua"}},{"name":"PlayAnimation","desc":"This function will play an animation.\\n```lua\\nlocal AnimaLib = AnimaLib.new(Animator)\\nlocal AnimationTrack = AnimaLib:PlayAnimation(\\"AnimationName\\", {\\n\\tSpeed = 1,\\n\\tWeight = 1,\\n\\tFadeIn = 0,\\n\\tFadeOut = 0,\\n\\tLooped = false,\\n\\tPriority = Enum.AnimationPriority.Action,\\n})\\n```\\n::info\\nIf you load an animation onto a rig then change the parent of the rig, it will becomme unplayable. Please avoid doing this to prevent tears.\\n::\\n:::caution\\nYou can only play animations that have been loaded using [AnimaLib:LoadAnimation](#LoadAnimation).\\n:::\\n:::warning\\nRoblox enforces a limit on how many tracks can be playing at once. This limit is 256. If you try to play more than 256 animations at once, it will not play. See [this](https://devforum.roblox.com/t/is-there-a-way-to-unload-animations/1525525/12) devforum post for more information.\\n:::","params":[{"name":"animationName","desc":"","lua_type":"string"},{"name":"properties","desc":"","lua_type":"AnimationProperties?"},{"name":"ignorePlaying","desc":"","lua_type":"boolean?"}],"returns":[{"desc":"","lua_type":"AnimationTrack"}],"function_type":"method","source":{"line":199,"path":"src/init.lua"}},{"name":"StopAnimation","desc":"This function will stop an animation.","params":[{"name":"animationName","desc":"","lua_type":"string"},{"name":"overrideFadeOut","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","source":{"line":241,"path":"src/init.lua"}},{"name":"StopAllAnimations","desc":"This function will stop all animations.\\n\\n:::caution\\nThis will only stop animations in the scope of the AnimaLib instance. If you have multiple AnimaLib instances, you will need to call this function on each instance.\\n:::","params":[],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","source":{"line":266,"path":"src/init.lua"}},{"name":"Destroy","desc":"This function will destroy the AnimaLib instance.\\n\\n:::caution\\nThis will only destroy the AnimaLib instance. If you have multiple AnimaLib instances, you will need to call this function on each instance.\\n:::","params":[],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"method","source":{"line":286,"path":"src/init.lua"}}],"properties":[],"types":[{"name":"AnimatorClass","desc":"AnimatorClass is a table that contains the Animator, LoadedAnimations, and PlayingAnimations tables. It also contains functions that you can use to interact with the Animator & AnimationTracks. This is returned when you create a new AnimaLib instance.","fields":[{"name":"Animator","lua_type":"Animator","desc":""},{"name":"LoadedAnimations","lua_type":"{string: AnimationTrack}","desc":""},{"name":"PlayingAnimations","lua_type":"{string: PlayingAnimation}","desc":""},{"name":"LoadAnimation(string,","lua_type":"number) -> AnimationTrack","desc":""},{"name":"GetAnimationTrack(string)","lua_type":"-> AnimationTrack","desc":""},{"name":"PlayAnimation(string,","lua_type":"AnimationProperties, boolean?) -> AnimationTrack","desc":""},{"name":"StopAnimation(string,","lua_type":"number?) -> nil","desc":""},{"name":"StopAllAnimations()","lua_type":"-> nil","desc":""},{"name":"Destroy()","lua_type":"-> nil","desc":""}],"source":{"line":18,"path":"src/init.lua"}},{"name":"AnimationProperties","desc":"AnimationProperties is a table that contains properties that you can used to influence how an animation is played.","fields":[{"name":"Speed","lua_type":"number?","desc":""},{"name":"Weight","lua_type":"number?","desc":""},{"name":"FadeIn","lua_type":"number?","desc":""},{"name":"FadeOut","lua_type":"number?","desc":""},{"name":"Looped","lua_type":"boolean?","desc":""},{"name":"Priority","lua_type":"Enum.AnimationPriority?","desc":""}],"source":{"line":42,"path":"src/init.lua"}},{"name":"PlayingAnimation","desc":"PlayingAnimation is a table that contains an AnimationTrack and AnimationProperties. This is returned when you play an animation.","fields":[{"name":"AnimationTrack","lua_type":"AnimationTrack","desc":""},{"name":"Properties","lua_type":"AnimationProperties","desc":""}],"source":{"line":60,"path":"src/init.lua"}}],"name":"AnimaLib","desc":"This is the API documentation for AnimaLib module. This includes all the API functions and properties that you can use.\\n```lua\\nlocal AnimaLib = require(somePath.AnimaLib)\\nlocal Animator = someInstance.Animator\\n\\nlocal AnimaLib = AnimaLib.new(Animator)\\n```","realm":["Client","Server"],"source":{"line":80,"path":"src/init.lua"}}')}}]);