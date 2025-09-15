import oscP5.*;
import netP5.*;

OscP5 oscP5;
int myListeningPort = 8080;
NetAddress myRemoteLocation;

void initOsc()
{
  oscP5 = new OscP5(this, 8080);
  myRemoteLocation = new NetAddress("127.0.0.1", 8080);
  oscP5.plug(this, "foo", "/foo");
}

public void foo(int value)
{
  println("int received!!! = " + value);
}
