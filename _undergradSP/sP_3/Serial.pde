void turnRelayOn() {
  port.write(255);
}

void turnRelayOff() {
  port.write(0);
}
