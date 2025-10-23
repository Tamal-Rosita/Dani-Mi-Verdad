# VRM-NovelEngine

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Interactive Visual Novel engine based on Dialogic and VRM models. 

**Made in Godot.**

## Features

- Easily create VRM Characters with easy procedure and a unified template scene for player and NPCs.
- Enhanced Dialogic for our VRM (3D) Characters with custom events: Character3D. 
- Create Dialogic timelines and add (custom) Character3D event for character animations and expressions.

### TODO

- [ ] Implement an easy, open and light _Lip Sync_ solution for Characters using Dialogic Voice event(?).
  - [ ] Use current VRM _viseme_ animations as the lip sync processing output. 
  - [ ] Analyze mp3 audio tracks to create proper cues for triggering visemes.


## VRM Character creation

(Current version)

1. Import/Drag VRM file into Godot Engine.
2. Open VRM model _Import Window_ and select the **GeneralSkeleton** node.
3. Add a `BoneMap`: `HumanoidBoneMap` in the *Retarget* field on the right side.
4. Click _Reimport_.
5. Create an _Inherited Scene_ from the character `VRM` file.
6. Inside the new scene, add animation libraries for the character:
   1. Select the `AnimationPlayer` node and the **Animation panel** on the bottom should show up.
   2. Click on the **Animation** button inside the *Animation panel*.
   3. Then pick the *Manage Animations...* option.
   4. Load all necessary libraries. For instance, inside `(res://visual-novel/animations)`.
7. (Optional) Activate `UpdateOnEditor` checkbox to preview physics. 
8. Save inherited scene as a `.scn` file for saving space, or `.tscn` for debugging.

## Attributions

### 3D Models

#### Subway (Metro) scene

* [Lowpoly Berlin U-bahn Station](https://sketchfab.com/3d-models/lowpoly-berlin-u-bahn-station-2a02d3f2eccf4cd29bbaa1348787395e) with [CC Attribution](https://creativecommons.org/licenses/by/4.0/) license.
* Texture: https://www.poliigon.com/texture/plain-painted-plaster-texture-white/7664

#### Theatre scene

* [Viola Desmond - The Roseland Theatre](https://skfb.ly/oQM6V) with [CC Attribution](https://creativecommons.org/licenses/by/4.0/) license.
* [Coffin](https://skfb.ly/6WNFP) by [pityblithe](https://sketchfab.com/pityblithe) with [CC Attribution](https://creativecommons.org/licenses/by/4.0/) license.
* [Raja low poly table](https://skfb.ly/HHES) with [CC Attribution](https://creativecommons.org/licenses/by/4.0/) license.

### Audio

#### Voices
* [Google AI Studio Generate Speech](https://aistudio.google.com/generate-speech)