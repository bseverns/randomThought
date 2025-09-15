# Level0: electric-field puzzles with punk-grade physics

Level0 is a Processing + Hermes playground for teaching vector fields, collision systems, and user interface design. The sketch boots a custom level editor where you sculpt force fields and bounce a red ball into a goal. Use it as an advanced lesson on state management, object-oriented design, or as the backbone for your own physics-driven game.

## Setup checklist
1. Install **Processing 2.x** (Level0 leans on Hermes, which is happiest before Processing 3 rewrote the threading rules).
2. Install the [Hermes library](https://github.com/hermes-dev-team) and drop it into your Processing `libraries/` directory. Level0 imports `hermes.physics`, `hermes.animation`, `hermes.hshape`, and `hermes.postoffice`.
3. Open `Level0.pde` inside Processing and ensure the other `.pde` files live in the same sketch folder.
4. Hit ▶ and give the sketch a second to boot the Hermes `World` thread.

## File map
- `Level0.pde` – the Processing entry point; sets up the window, instantiates `LevelWorld`, and toggles between build/run/completed modes.
- `LevelWorld.pde` – extends `World` from Hermes; registers all beings (canvas, tools, buttons, ball, goal) and their subscriptions.
- `Canvas.pde` – builds the editable grid, manages vector fields (`Cell` objects), and handles hover/placement logic.
- `ToolBox.pde` – hosts the reusable tool templates (diamond, triangle, hexagon, circle, wedge) and the big zero label.
- `tools.pde` – defines the `Tool` hierarchy, rotation and elasticity controls, plus helper classes like `SelectedToolAttributeSwitcher`.
- `Ball.pde`, `Goal.pde`, `BallGoalCollider.pde` – the actors and collider that end the level when the ball hits the goal.
- `Bubble.pde` – lightweight visualisers that show the vector field when you run the simulation.
- `Cell.pde` – stores per-grid cell data: flow vectors, strength, and whether a tool occupies the space.
- `HelperFunctions.pde` – global helpers for mode switching, bubble creation, and tool factories.
- `RandomButton.pde`, `RunButton.pde` – UI controls that randomise the field and start/stop the simulation.
- `Zero.pde` – the cheeky toolbox label that doubles as a typography lesson.
- `constants.pde` – global configuration: window sizes, colours, physics parameters, keyboard bindings.
- `tools.pde` and `BallGoalCollider.pde` rely on Hermes messaging types (`KeyMessage`, `MouseMessage`, `Collider`, etc.), so confirm Hermes is installed before running.

## How to use the editor
1. **Build mode (`mode == BUILD`)** – drag tools from the toolbox onto the main grid. Rotate with `W`, cycle elasticity with `E`, and drag tools off the canvas to delete them.
2. **Randomise** – hit the star button or tap the space bar to randomise the flow field (Canvas.randomize uses a drunk-walk breadth-first traversal).
3. **Run mode (`mode == RUN`)** – press the play button to spawn the red ball and blue tracer bubbles. Watch how the vector field guides the ball.
4. **Win condition** – when the ball collides with the goal, `BallGoalCollider` flips the mode to `COMPLETED`. You can bounce back into build mode to iterate.

## Teaching angles
- **Vector fields** – have students read `Canvas.randomize()` and adjust the breadth-first traversal to see how flow direction changes affect motion.
- **State management** – `setMode()` in `HelperFunctions.pde` demonstrates a clean build/run/completed pipeline. Use it to discuss finite-state machines.
- **Tool design** – the `Tool` abstract class plus specific subclasses show how to create reusable, interactive assets. Try adding a new tool type as an assignment.
- **Collision systems** – `LevelWorld` registers groups and colliders explicitly. It’s an approachable intro to Hermes’ physics layer.

## Remix ideas
- Swap the Hermes collider for a custom implementation and discuss the trade-offs.
- Map tool placement to an external controller (MIDI, OSC) for an installation workshop.
- Replace the ball with multiple agents and let students profile performance.

May the electric fields treat you kindly—until you decide they shouldn’t.
