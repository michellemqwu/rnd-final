/*
https://developer.android.com/reference/android/hardware/Sensor#TYPE_LIGHT
*/

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import ketai.camera.*;

Context context;
SensorManager manager;
Sensor sensor;
LightListener listener;
float l;
float prev_l;

int progress;

int rectX = 700;
int rectY = 700; 
int rectW = 300;
int rectH = 200;

boolean showButton = false;

KetaiCamera cam;

void setup() {
  fullScreen();
  
  context = getActivity();
  manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
  sensor = manager.getDefaultSensor(Sensor.TYPE_LIGHT);
  listener = new LightListener();
  manager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME);
  
  textFont(createFont("SansSerif", 40 * displayDensity));
 
  imageMode(CENTER);
  cam = new KetaiCamera(this, 320, 240, 24);
}

void draw() {
  background(0);
  
  image(cam, width/2, height/2);
  cam.start();
  
  text("L: " + l, 10, 10, width, height);
  text(progress + "/10", 300, 300, width, height);
  
  if (showButton) {
   rect(rectX, rectY, rectW, rectH);
   fill(255); 
  }
  
  if (prev_l > 45.0 && l <= 45.0) {
    progress++;
    cam.enableFlash();
    delay(100);
    cam.disableFlash();
    delay(100);
    cam.enableFlash();
    delay(100);
    cam.disableFlash();
    delay(100);
    println(progress);
  }
  
  if (progress == 10) {
    showButton = true;
    cam.enableFlash();
    delay(300);
    cam.disableFlash();
    delay(100);
    cam.enableFlash();
    delay(300);
    cam.disableFlash();
    delay(100);
  }
  
  prev_l = l;
  
}

class LightListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    l = event.values[0];
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}

boolean overButton() {
  if (mouseX >= rectX && mouseX <= rectX + rectW && mouseY >= rectY && mouseY <= rectY + rectH) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (overButton()) {
    showButton = false;
    progress = 0;
  }
}
