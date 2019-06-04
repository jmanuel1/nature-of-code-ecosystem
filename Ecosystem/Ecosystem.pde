/* Requires Processing 3.2.3+ */

class Person {
  final float WALKING_SPEED = 2.0f;
  int tiredness = 0;
  int remaining_rest_time = 0;
  PVector a, v, s; // acceleration, velocity, displacement
  PVector goal;

  int noiset = 0;
  
  Person() {
    s = new PVector(random(width), random(height));
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    goal = new PVector(random(width), random(height));
  }
  
  void update() {
    if (tiredness == 1000) {
      remaining_rest_time = (int) random(100, 1000);
      tiredness = 0;
      return;
    }
    
    if (remaining_rest_time > 0) {
      remaining_rest_time--;
    } else {
      PVector dir = PVector.sub(goal, s);
      
      if (dir.mag() < 16.0) {
        // Choose new goal
        goal.set(random(width), random(height));
        return;
      }
      dir.limit(0.5);
      a.add(dir);
      v.add(a);
      v.limit(WALKING_SPEED);
      
      s.add(v);
      
      // Wrap sides
      if (s.x <= 0 || s.x >= width) {
        s.x = min(max(s.x, 0), width);
        s.x = width - s.x;
      }
      
      if (s.y <= 0 || s.y >= height) {
        s.y = min(max(s.y, 0), height);
        s.y = height - s.y;
      }
      
      tiredness++;
      a.set(0, 0);
    }
  }
  
  void display() {
    ellipse(s.x, s.y, 10, 10);
  }
}

class Cafe {
  float w, h;
  PVector center;
  
  
  Cafe() {
    w = random(100, width/2);
    h = random(100, height/2);
    center = new PVector(random(width), random(height));
  }
  
  void attract(Person p) {
    PVector force = PVector.sub(p.s, center);
    
    // Max magnitude of 0.25 for force
    force.limit(0.25);
    // Ignore the idea of mass
    p.a.add(force);
    
    // Decrease tiredness
    if (p.s.x > center.x - w/2 && p.s.x < center.x + w/2 || p.s.y > center.y - h/2 && p.s.y < center.y + h/2) {
      p.tiredness = max(0, p.tiredness - 1);
    }
  }
  
  void display() {
    rectMode(CENTER);
    fill(255, 0);
    rect(center.x, center.y, w, h);
    rectMode(CORNER); // reset to default
    fill(0);
  }
}

Person p;
Cafe cafe;

void setup() {
  size(800, 600);
  background(255);
  stroke(0);
  fill(0);
  
  p = new Person();
  cafe = new Cafe();
}

void draw() {
  background(255);
  p.update();
  cafe.attract(p);
  p.display();
  cafe.display();
}