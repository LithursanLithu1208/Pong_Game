# Tennis Pong Game

The game features a tennis court background with custom paddle textures and a tennis ball with characteristic curved lines.

## Installation

### Prerequisites

- [LÖVE2D](https://love2d.org/) (version 11.0 or later)

### Running the Game

1. Download or clone this repository
2. Install LÖVE2D on your system
3. Run the game by either:
   - Dragging the project folder onto the LÖVE2D executable
   - Using the command line: `love .` (from the project directory)

## How to Play

### Controls

**Player 1 (Left Paddle):**
- `W` - Move up
- `S` - Move down

**Player 2 (Right Paddle):**
- `↑` (Up Arrow) - Move up
- `↓` (Down Arrow) - Move down

**Game Controls:**
- `Enter` - Start game, serve ball, or restart after game over
- `+` or `=` - Increase ball speed
- `-` - Decrease ball speed
- `0` - Reset ball speed to default
- `Escape` - Quit game

### Gameplay

1. Press `Enter` to start the game
2. The serving player is indicated on screen
3. Press `Enter` again to serve the ball
4. Use your paddle to hit the ball back to your opponent
5. First player to reach 10 points wins
6. The ball speed increases slightly with each paddle hit
7. Ball bounces off the top and bottom walls

## Game States

- **Start**: Welcome screen - press Enter to begin
- **Serve**: Ball is positioned for serving - press Enter to serve
- **Play**: Active gameplay
- **Done**: Game over - winner announced, press Enter to restart


### Project Structure

```
Pong_Game/
├── main.lua          # Main game logic and loop
├── Ball.lua          # Ball physics and rendering
├── Paddle.lua        # Paddle movement and rendering
├── Assets.lua        # Asset management (images, sounds)
├── class.lua         # Class system for OOP
├── push.lua          # Screen scaling library
├── assets/           # Game assets
│   ├── table.jpg     # Tennis court background
│   └── pad.jpg       # Paddle texture
└── Press_Start_2P/   # Font files
    └── PressStart2P-Regular.ttf
```
