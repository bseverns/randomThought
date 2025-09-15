# image_streaming: UDP video in three bites

This folder contains a mini-lesson on transmitting camera frames across a network using raw UDP packets. It comes in three flavours:

1. `VideoSender/VideoSender.pde` – captures webcam frames, encodes them as JPEG, and fires the bytes out over UDP.
2. `VideoReceiver/VideoReceiver.pde` – listens for UDP packets, decodes them back into a `PImage`, and displays the stream. This version blocks the draw loop while it waits.
3. `VideoReceiverThread/` – wraps the receive/decode logic in a dedicated thread so the UI stays responsive.

## Dependencies
- Processing’s **Video** library (`processing.video.*`) for webcam capture on the sender.
- Core Java networking classes (`java.net.DatagramSocket`, `java.net.DatagramPacket`, `java.net.InetAddress`). These ship with the JRE.
- No third-party libraries—just Processing and the standard Java stack.

## Running the demos
1. **Start the receiver first.** Open `VideoReceiver/VideoReceiver.pde`, adjust `int port = 9100;` if you need a different port, and hit ▶. You should see the “Received datagram…” log messages when packets arrive.
2. **Optionally test the threaded build.** `VideoReceiverThread/VideoReceiverThread.pde` uses a separate `ReceiverThread.pde` class to pull frames without blocking `draw()`. Great conversation starter on concurrency.
3. **Launch the sender.** Open `VideoSender/VideoSender.pde`. Confirm `clientPort` and the target IP in `broadcast()` (defaults to `localhost`). When frames stream, the console reports packet sizes.
4. **Scale up.** Point the sender at a remote machine by changing `InetAddress.getByName("localhost")` to the receiver’s IP.

## Teaching prompts
- **Compression trade-offs:** `broadcast()` converts `PImage` → `BufferedImage` → JPEG bytes. Have students tweak JPEG quality or experiment with PNG for different latency/quality combos.
- **Threading:** compare the blocking receiver to the threaded variant. Discuss why UI freeze happens and how to guard against it.
- **Protocol design:** challenge learners to add simple headers (frame numbers, timestamps) before the JPEG payload so they can detect dropped packets.
- **Security / reliability:** talk about when UDP makes sense (fast, lossy scenarios) versus when TCP or WebRTC would be saner.

Now go stream some pixels and make the network sweat.
