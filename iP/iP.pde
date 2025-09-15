float numberOfSlices;
StringBuffer nextStuff= new StringBuffer();
char currentAdd;

PFont font;

void setup() {
  size(displayWidth, displayHeight);
  font = loadFont("Serif-48");
  frameRate(4);
  textFont(font, 255);
  background(noise(0, 255), noise(0, 255), noise(0, 255));
}

void draw() {
  //background(random(0,255),random(0,255),random(0,255));
  numberOfSlices = int(nextStuff.toString());
  for(int i=0; i<numberOfSlices; i++) {
    noStroke();
    fill(random(0,255),random(0,255),random(0,255));
    rect(i* (width/numberOfSlices), 0, (width/numberOfSlices), height);
  }
  fill(random(0,255),random(0,255),random(0,255));
  textAlign(CENTER,CENTER);
  text(nextStuff.toString(), 0, 0, width, height);

  
  
  
  /*line(10, 100, 190, 100);
  print("69.59.145.218");
  print("69.59.145.219");    
  print("69.59.145.220");    
  print("69.59.145.221");    
  print("69.59.145.222");    
  print("69.59.145.223");    
  print("69.59.145.224");    
  print("69.59.145.225");    
  print("69.59.145.226");    
  print("69.59.145.227");    
  print("69.59.145.228");    
  print("69.59.145.229");    
  print("69.59.145.230");    
  print("69.59.145.231");    
  print("69.59.145.232");    
  print("69.59.145.233");    
  print("69.59.145.244");    
  print("69.59.145.245");    
  print("69.59.145.246");    
  print("69.59.145.247");    
  print("69.59.145.248");    
  print("69.59.145.249");    
  print("69.59.145.250");    
  print("69.59.145.251");    
  print("69.59.145.252");    
  print("69.59.145.253");    
  print("69.59.145.254");    
  print("69.59.145.255");    
  print("69.59.128.192");
  print("69.59.128.193");
  print("69.59.128.194");
  print("69.59.128.195");
  print("69.59.128.196");
  print("69.59.128.197");
  print("69.59.128.198");
  print("69.59.128.199");
  print("69.59.128.200");
  print("69.59.128.201");
  print("69.59.128.202");
  print("69.59.128.203");
  print("69.59.128.204");
  print("69.59.128.205");
  print("69.59.128.206");
  print("69.59.128.207");
  print("69.59.128.208");
  print("69.59.128.209");
  print("69.59.128.210");
  print("69.59.128.211");
  print("69.59.128.212");
  print("69.59.128.213");
  print("69.59.128.214");
  print("69.59.128.215");*/
};

 
void outputText() {
  background(random(0,255),random(0,255),random(0,255));
  fill(random(0,255),random(0,255),random(0,255));
  textAlign(CENTER,CENTER);
  //text(typedStuff.toString(), 0, 0, width, height);
  }
