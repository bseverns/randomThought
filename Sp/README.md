# Sp: the sensor playground

The `Sp` folder (and its sibling `_undergradSP`) is a raw, punk-spirited lab for teaching computer vision, depth sensing, OSC, and serial communication. Use it to prototype interactive installations, unpack Kinect pipelines, and show students how to wrangle messy sensor data.

## Required libraries
Install these Processing libraries before diving in:
- **OpenKinect**: `org.openkinect.processing.*` (for Kinect depth/video access in the `backgroundSubOK*`, `depthThreshold*`, `triangleDepthoK`, and `pcloud_2_` sketches).
- **KingKinect**: `king.kinect.*` (used by the top-level `kinect.pde`).
- **SimpleOpenNI / FLOB**: `s373.flob.*` in `nsProject/` for blob tracking.
- **Audio**: `krister.Ess.*` and Minim for sound-reactive experiments (`nsProject/`, `ns3/`).
- **OSC**: `oscP5` + `netP5` (see `maxOSC/`).
- **Serial**: `processing.serial.*` for Arduino bridges in `simpleArduinoSerial/`, `test_1/`, `test_2/`.
- **Video**: `processing.video.*` everywhere—nearly every sketch captures or processes frames.

> Tip: duplicate `Sp` before running workshops so you can hand students a fresh copy (`_undergradSP` is exactly that).

## Folder highlights
- `kinect.pde` – Minimal NativeKinect demo showing RGB + depth side-by-side.
- `backgroundSubOK/`, `backgroundSubOK_/`, `backgroundSubOK__/`, `bgsubOK/`, `bgsubOK1/` – Iterations of depth-based background subtraction. Compare thresholds and offsets to discuss calibration.
- `depthThreshold/`, `depthThresholdTest/`, `depthdbsubOK/`, `triangleDepthoK/` – Thresholding experiments for isolating performers at different distances.
- `movingAvgBg/` – Rolling background average to smooth noisy depth feeds.
- `nsProject/` – Blob detection with `s373.flob`, plus audio synthesis in `Sound.pde` using `krister.Ess`.
- `ns2/` – A starter sketch for extending the Kinect pipeline; duplicate it when launching new experiments.
- `ns3/` – A follow-up study that connects motion energy to audio output.
- `pcloud_2_/` – Point cloud visualisation for teaching 3D mapping.
- `sP_1/`, `sP_2/`, `sP_3/`, `sP_4/` – Packaged lesson plans; `sP_4.pde` shares its `KinectTracker.pde` with other performance sketches.
- `maxOSC/` – Quick OSC send/receive harness; perfect for bridging to Max/MSP or SuperCollider.
- `simpleArduinoSerial/`, `test_1/`, `test_2/` – Serial I/O exercises for physical computing.
- `trackerTest/` – Sandbox for tweaking the Kinect tracker before using it in other sketches.
- `uds_exper/`, `spTest/`, `sProject/` – Miscellaneous experiments on presence sums, blob overlays, and installations in progress.
- `P52MAX/` – Reference assets and patches for the Processing → Max pipeline.
- `sP_4 2.zip`, `sP_1.zip`, `trackerTest.zip` – Frozen exports of earlier iterations; unzip them if you want the exact workshop handouts.

## Suggested learning path
1. **Start simple:** run `kinect.pde` to verify drivers and get students comfortable with the Kinect resolution.
2. **Background subtraction:** compare `backgroundSubOK` variants. Ask learners to tune `frontThreshold` / `backThreshold` and align RGB offsets.
3. **Blob + audio integration:** open `nsProject/nsProject.pde` and connect the blob centroids to the audio streams defined in `Sound.pde`.
4. **Network it:** introduce `maxOSC` once visuals feel solid so participants can pass motion data into other environments.
5. **Hardware mashups:** finish with `simpleArduinoSerial` or `test_1` to send threshold hits back into motors, lights, or whatever hardware you have on deck.

## Teaching notes
- Keep a spare Kinect on hand; swapping hardware is faster than debugging USB dropouts mid-class.
- The audio sketches assume you have speakers or headphones ready. The `Sound.pde` recorder writes `.aif` files—perfect for homework analysis.
- Encourage students to comment their calibration values (thresholds, offsets) so the next crew can reuse the setups.

Rip into these sketches, remix them, and let the sensors sing.
