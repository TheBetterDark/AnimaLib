# About

AnimaLib is a animation module designed to streamline the process of scripting animations in Roblox. It handles the creation of [Animations](https://developer.roblox.com/en-us/api-reference/class/Animation) and [AnimationTracks](https://developer.roblox.com/en-us/api-reference/class/AnimationTrack) taking the hassle out of scripting animations.

## Why AnimaLib?

- **Simple**: AnimaLib is built with simplicity in mind. It provides an intuitive API that makes creating and managing animations in your Roblox games a straightforward process.
- **Versatile**: AnimaLib allows you the freedom to integrate it seamlessly into your game or utilise it as a foundation for crafting your personalised animation module.
- **Scalable**: Whether you're creating a small indie game or a large-scale multiplayer experience, AnimaLib scales effortlessly to meet your project's demands.

## Getting Started

### Installation

Installing AnimaLib is as simple as dropping the module into your game. You can also be used with a [Rojo](https://rojo.space/) workflow.

#### Roblox Studio

1. Download the latest release of AnimaLib from [Roblox](https://www.roblox.com/library/0/AnimaLib).
2. Insert AnimaLib into ReplicatedStorage.

#### Rojo/Wally

1. Add AnimaLib to your `wally.toml` dependencies: `AnimaLib = "Animalib = "thebetterdark/animalib@^0.2"`
2. Run `wally update` to install the new dependency.
3. Require AnimaLib like any other module from Wally.

### Basic Usage

The following example demonstrates how to create an animation and play it on a [Humanoid](https://developer.roblox.com/en-us/api-reference/class/Humanoid).

```lua
local AnimaLib = require(game:GetService("ReplicatedStorage").Packages.AnimaLib)
local humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid

local animator = AnimaLib.new(humanoid.Animator)
animator:LoadAnimation("TestAnimation", "rbxassetid://123456789")
animator:PlayAnimation("TestAnimation")
```

You are also able to use AnimaLib with a [AnimationController](https://developer.roblox.com/en-us/api-reference/class/AnimationController) by passing the controller as the first argument to `AnimaLib.new()`.

```lua
local AnimaLib = require(game:GetService("ReplicatedStorage").Packages.AnimaLib)
local animationController = somePath.AnimationController

local animator = AnimaLib.new(animationController.Animator)
animator:LoadAnimation("TestAnimation", "rbxassetid://123456789")
animator:PlayAnimation("TestAnimation")
```

## Contributing

Contributions to Animalib are welcome! To contribute, please fork the repository and submit a pull request with your changes. Before submitting a pull request, please ensure that your code is following [Roblox Lua Style Guide](https://roblox.github.io/lua-style-guide/).
