# randomThought: an annotated sketchbook for rebels with sensors

Welcome to the archive of Processing experiments, class demos, late-night prototypes, and general mischief. Every folder in here is a standalone sketch (or a cluster of them) from years of tinkering with vision systems, fluid sims, audio toys, and interactive performance tools. This README turns the chaos into a teaching aid so you can learn from the madness instead of getting lost in it.

## How to get rolling
1. **Install Processing.** These sketches were built across Processing 2.x and 3.x. Most run in modern Processing 4.x, but the Kinect and Hermes-based pieces are happiest in the older 2.x branch.
2. **Clone or download the repo** and point Processing at the folder of the sketch you want to run.
3. **Open the main `.pde`** (each folder lists its primaries below) and smash the ▶ button.
4. **Bring the right libraries.** Many sketches rely on additional Processing libraries:
   - [PixelFlow](https://github.com/diwi/PixelFlow) for the GPU fluid playground in `Fluid_WindTunnel_SS_AHM2`.
   - [Hermes](https://github.com/hermes-dev-team) for the physics and messaging system inside `Level0`.
   - [controlP5](https://sojamo.de/libraries/controlP5/) for GUI controls in fluid and motion projects.
   - [processing.video](https://processing.org/reference/libraries/video/) for capture/streaming work (`image_streaming`, `MiM_video`, several diary sketches).
   - Kinect stacks: `king.kinect`, `org.openkinect.processing`, and friends appear in `Sp`, `_undergradSP`, `sP_4`, `aParade`, and `jFireman_1`.
   - Audio goodness via `krister.Ess`, `Minim`, and custom `Sound.pde` helpers inside the `Sp` and `ns*` projects.
   - Networking helpers (`java.net.DatagramSocket`, `themidibus`, `processing.serial`) for interactive performance systems like `image_streaming`, `October2`, and `Ppong`.
5. **Read the sketch-level README files** (linked below) for walkthroughs, dependencies, and teaching prompts.

> ⚡ Punk note: the repo keeps historical exports (`application.*`, `web-export`, `.zip` bundles). They stay for posterity. Ignore them unless you want to see how Processing used to spit out apps.

## Guided tours
These playlists bundle sketches that vibe together. Follow them like a course syllabus or cherry-pick what thrills you.

### Sketch diary (Sep → Jan)
`September1`, `September2`, `September3`, `October1`, `October2`, `October3`, `Novermber1`, `Novermber1a`, `december1`, `december2`, `jan1`–`jan7`. Each folder is a single Processing sketch (some include captured frames or `sketch.properties`). Treat them as bite-sized studies in motion, image processing, or sound. Start here if you want manageable reading assignments.

### Movement, installations, and performance rigs
- **`MiM_1`, `MiM_2`, `MiM_video`** – modules from the Machines in Motion series; look for timing utilities (`StopWatchTimer.pde`) and projection-friendly assets.
- **`Ppong`** – OSC-driven “People Pong”. Explore `oscSpacePeoplePong` and the zipped client/server exports for multiplayer setups.
- **`twolefts_redux`, `rotator1`, `aParade`** – movement-reactive sketches; `aParade` ships with a Kinect tracker for parade-style visuals.
- **`algorithmicComp_presenceSum_ArduinoSensors`** – hybrid physical computing piece with Arduino sensor summing, audio instruments, and generative text.

### Sensor playgrounds & body interfaces
- **`Sp` and `_undergradSP`** – sprawling labs on Kinect depth, blob detection, OSC, and serial tests. Start with the local `README.md` for a map.
- **`sP_4`, `jFireman_1`, `nS2014`, `ns3`, `ns3_movie`, `serial_studioExperiment1`, `serial.studioExperiment2`, `studioExperiment3`** – variations on motion tracking, sound triggering, and serial-controlled visuals. These sketches mix Kinect trackers, video processing, and sound synthesis.

### Tools, utilities, and references
- **`Level0`** – a fully fledged level editor for electric-field puzzles. See `Level0/README.md` for a breakdown of its physics architecture.
- **`Fluid_WindTunnel_SS_AHM2`** – GPU fluid dynamics playground built on PixelFlow with custom shaders.
- **`image_streaming`** – UDP video sender/receiver demo with a threaded variant. The folder README walks through the workflow.
- **`TumblrP5`** – Tumblr API experiments; includes bundled Apache Commons jars.
- **`History/source`** – legacy code (e.g., `Sound.pde`, `ns3.java`) preserved for reference.

### Audio, texture, and atmospheric studies
`bitCrush_sketch1`, `fb18`, `panHEIZEN`, `scape`, `scape_`, `thesisLight`, `resetAfter___`, and the `nsProject` suite fold in sound synthesis, particle textures, and lighting research. Many rely on the `sound/` or `data/` folders for assets.

## Documented deep dives
- [`docs/README.md`](docs/README.md) – atlas of every folder, listing primary files and teaching cues.
- [`Level0/README.md`](Level0/README.md) – how the electric-field level editor is wired.
- [`Sp/README.md`](Sp/README.md) – Kinect, OSC, and serial experiments without the guesswork.
- [`image_streaming/README.md`](image_streaming/README.md) – instructions for the UDP video pipeline.

## Remixing and contributing
- Keep the sketches intact so future students can compare outputs. Add new experiments in fresh folders.
- When you add dependencies, note them in a README (go ahead, keep the punk energy alive).
- Commit exports only if they teach something—GIFs, recordings, or binaries that illustrate the results.

Stay curious, break things with intent, and document the wild ride.
