# Levels
## Problem
There is no concept of a level yet. The game state just contains a single canvas that is replaced on updates.

# Nested SVG
## Problem
The entire game is a single SVG. This makes it difficult and maybe impossible to fire events associated with a single sprite. 
Creating nested SVGs could allow us to fire more events, and maybe to animate the sprites. It is also just better code isolation.

# Scrolling Canvas
## Problem
Right now the canvas equals the size of the viewport in the UI. If we want interesting levels, we should make things where the UI shows a piece of a larger canvas and as you move the prtagonist, the canvas that is visible in the UI shifts.

# Sprites
## Problem 1 
Sprites are no longer just squares. We can specify which image is associated with the sprite. 
## Problem 2
State does not currently track collection of item sprites (items). We could start tracking.
## Problem 3
State does not currently track a "win" of the game, AKA when all items have been collected.
## Problem 4
Create enemy sprite. We don't currently have this concept. Easiest is probably that encountering the enemy automatically loses the game. Eventually, we will want encountering the enemy to open a whole new mode that looks similar to fighting in Pokemon and/or West of Loathing/Shadows Over Loathing. 

# Blue Mode
The whole concept of this game is that there will be times when you enter a "blue" mode and the background goes blue. In this mode new content will be visible that is not in the other mode. 
## Problem 1
Steps counter. Blue mode is triggered after n steps. 
## Problem 2
Blue mode canvas. We should be switching out the regular canvas for the blue mode one, but also retaining the state of the original. 
## Problem 3
Steps counter. Blue mode is ended after n steps. 

# JSON Export
## Problem
JSON currently exports always to the same file path. We would like to do this from user inputs text field.

## Designer Mode
## Problem
Currently designer mode works on buttons that say the name of what you are trying to do. Ideally it would be a more intuitive UI with an SVG icon of what you are trying to add (or eraser to delete) and a highlighted state to show which icon is currently active. 
