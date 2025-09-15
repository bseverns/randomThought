# Project atlas & teaching prompts

This atlas is the cheat-sheet you want open while rummaging through the sketchbook. It lists the main `.pde` files, highlights notable support assets, and suggests how to frame each folder in a lesson or workshop.

## Sketch diary (September → January)
- **September1** – `September1.pde` tracks the brightest pixel in a live `Capture` stream; the `output/` folder stores captured frames for reflection and critique.
- **September2** – `September2.pde` uses frame differencing to spawn and retire `Particle` instances based on motion energy.
- **September3** – `September3.pde` performs bright-spot tracking with variable stroke weights; great for demonstrating smoothing and decay techniques.
- **October1** – `October1.pde` repeats the frame differencing study with adjustable timers and recording toggles.
- **October2** – `October2.pde` teams up with `midiCV4_serial.pde` to bridge camera-driven motion data into MIDI and serial hardware; the `data/` folder holds support assets and `Corsiva.ttc` supplies custom typography.
- **October3** – `October3.pde` experiments with multi-colour quadrant analysis on the webcam feed.
- **Novermber1** – `Novermber1.pde` performs real-time brightest-pixel tracking across a full-screen display and includes `sketch.properties` for Processing settings.
- **Novermber1a** – `Novermber1a.pde` extends the November study and writes renders into `output/` for documentation.
- **december1** – `december1.pde` fuses webcam input with `ddf.minim` audio analysis to colour long-tail line trails.
- **december2** – `december2.pde` applies motion-triggered rectangular reveals; the numbered JPEGs in the folder are sample renders for critique.
- **jan1** – `jan1.pde` listens to live audio (Minim) to activate 3D cell structures.
- **jan2** – `jan2.pde` combines bright-spot tracking with a swarm of `NewParticle` objects; `Particle.pde` defines the particle behaviour.
- **jan3** – `jan3.pde` integrates a custom `Blade` class (`cut.pde`) with frame differencing for kinetic slicing visuals.
- **jan4** – `jan4.pde` draws flowing trails using the brightest webcam pixel and dynamic colour cycling.
- **jan5** – `jan5.pde` is a cellular automata playground that renders to `output/CA_001-###.PNG` for later assembly.
- **jan6** – `jan6.pde` maps bright-pixel tracking into 3D rotations (run it with the `P3D` renderer).
- **jan7** – `jan7.pde` couples background subtraction with breathing animations; it sets up max-presence thresholds for audio-responsive work.

## Movement, performance, and installation kits
- **MiM_1** – `MiM_1.pde` demonstrates frame differencing wired to serial output for Arduino-driven installations.
- **MiM_2** – `MiM_2.pde` extends the MiM toolkit with Minim audio playback triggered by motion thresholds.
- **MiM_video** – `MiM_video.pde` is a surveillance-inspired capture piece with on-screen prompts; look in `data/` for font assets.
- **Ppong** – `oscSpacePeoplePong/oscSpacePeoplePong.pde` shows OSC send/receive basics; zipped `ppClient` and `ppServer` exports document the deployed build.
- **twolefts_redux** – `twolefts_redux.pde` translates live audio input into generative drawing (Minim + random walks).
- **rotator1** – `rotator1.pde` uses frame differencing and rotation maths to create spinning silhouettes.
- **aParade** – Pair `aParade.pde` with `KinectTracker.pde` for multi-depth presence tracking suitable for parade visuals.
- **algorithmicComp_presenceSum_ArduinoSensors** – Three sketches (`algorithmicComp_presenceSum_ArduinoSensors.pde`, `peanutsSentencer.pde`, `peanutsSyllableInstrument.pde`) demonstrate combining Arduino sensor sums with audio and text generation.

## Sensor playgrounds & body interfaces
- **Sp** – A full lab of Kinect, OSC, and blob detection experiments. Highlights include `kinect.pde` (NativeKinect video/depth split), background subtraction variants (`backgroundSubOK/`, `bgsubOK1/`), blob tracking via `s373.flob` (`nsProject/`), and Arduino serial bridges (`simpleArduinoSerial/`). Start with the local README.
- **_undergradSP** – Mirrors `Sp` for undergraduate coursework; use it when you need a clean copy of the sensor experiments.
- **sP_4** – `sP_4.pde` plus `KinectTracker.pde` offer a tighter Kinect workflow for class demos.
- **jFireman_1** – `jFireman_1.pde` integrates `KinectTracker.pde` with a `sketch.properties` tuned for projection.
- **nS2014** – `nS2014.pde` and `Video.pde` tie webcam motion into colour-mapped outputs for Arduino-controlled lighting.
- **ns3** – `ns3.pde` couples motion analysis with Minim sawtooth synthesis (`sound` logic lives in the same folder).
- **ns3_movie** – `ns3_movie.pde` processes prerecorded video via Minim audio synthesis; `sound.pde` defines the custom `PSaw` instrument.
- **serial_studioExperiment1** – Serial input visualiser that maps raw values directly to polar drawings.
- **serial.studioExperiment2** – Alternative serial testbed (note the dot in the folder name) that adds easing to analog signals.
- **studioExperiment3** – Minimal random test harness you can repurpose for quick serial sanity checks.

## Networked + data-driven utilities
- **image_streaming** – `VideoSender/VideoSender.pde`, `VideoReceiver/VideoReceiver.pde`, and `VideoReceiverThread/` demonstrate UDP-based image streaming with and without threading. See the folder README for step-by-step usage.
- **October2/midiCV4_serial.pde** & **fb18/fb18.pde** – Real-time bridges between video motion, MIDI, and serial (Arduino) control. Perfect for lessons on hybrid instrument design.
- **TumblrP5** – `TumblrP5.pde` and `Main.pde` use Apache Commons libraries to post to Tumblr; the `code/` folder ships the required jars.
- **History/source** – Legacy snapshots, including `ns3.java` and a reusable `Sound.pde` audio helper.

## Audio, texture, and atmospheric studies
- **bitCrush_sketch1** – `bitCrush_sketch1.pde` with companions `one.pde` and `two.pde` experiment with Minim UGens and band-pass filtering; `data/` stores note sequences.
- **iP** – `iP.pde` mixes randomised typography with user input assembled via a `StringBuffer`.
- **panHEIZEN** – `panHEIZEN.pde` randomly triggers video playback using `Movie` clips for ambient installations.
- **scape** & **scape_** – Audio-reactive landscapes that rely on Minim input and the images in their respective `data/` folders.
- **resetAfter___** – Audio-driven automatic drawing referencing Levente Sandor's doodler template.
- **thesisLight** – Motion-triggered serial output for lighting installations; pairs `processing.video` with `processing.serial`.
- **Fluid_WindTunnel_SS_AHM2** – PixelFlow fluid sim with custom GLSL additions in `data/` and a companion `Velocity.pde` shader helper.

## Export-heavy “mIP” builds
- **mIP**, **mIP2**, **mIP3**, **mIP4**, **mIP5_final_**, **mIP6** – Progressive Minim-based installations. The later folders (`mIP5_final_`, `mIP6`) include exported desktop apps (`application.*`), `web-export/` bundles, and curated image captures for critique.

## Odds & ends worth bookmarking
- **Ppong/osc_2** – Additional OSC sketches for multi-computer play.
- **History/source/ns3** – A Java variant of the `ns3` sketch for deeper reference.
- **Fluid_WindTunnel_SS_AHM2/data/** – GLSL shader snippets (`addVelocity.frag`, `addDensity.frag`) ready for shader deep dives.
- **TumblrP5/code/** – Apache Commons jars (HTTP client, codec, logging) packaged with the sketch.

### Teaching tip
When you dive into any folder, peek for a `sketch.properties` file—Processing stores window size, renderer, and preferences there. It’s a great prompt for students to document their own performance settings.
