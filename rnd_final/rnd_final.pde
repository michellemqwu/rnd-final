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

Sensor lightSensor;
LightListener lightSensorListener;

Sensor acceSensor;
AccelerometerListener acceSensorListener;
float ax, ay, az;
float current_max;
float acc_zero_threshold = 10.0;
boolean startRecording = false;
int stable_count = 0;

float l;
float prev_l;

KetaiCamera cam;

void setup() {
  fullScreen();
  
  context = getActivity();
  manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
  
  lightSensor = manager.getDefaultSensor(Sensor.TYPE_LIGHT);
  lightSensorListener = new LightListener();
  manager.registerListener(lightSensorListener, lightSensor, SensorManager.SENSOR_DELAY_GAME);
  
  acceSensor = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  acceSensorListener = new AccelerometerListener();
  manager.registerListener(acceSensorListener, acceSensor, SensorManager.SENSOR_DELAY_GAME);
  
  textFont(createFont("SansSerif", 40 * displayDensity));
 
  imageMode(CENTER);
  cam = new KetaiCamera(this, 320, 240, 24);
}

void draw() {
  background(0);
  
  image(cam, width/2, height/2);
  cam.start();
  
  //text("X: " + ax + "\nY: " + ay + "\nZ: " + az, 10, 10, width, height);
  text("L: " + l, 10, 10, width, height);
  
  if (stable_count >= 30) {
    println("current max is: ", current_max);
    startRecording = false;
    current_max = 0.0;
  }
  
  if (ax < acc_zero_threshold && ay < acc_zero_threshold && az < acc_zero_threshold) {
    stable_count += 1;
  }
  
  if (ax >= acc_zero_threshold || ay >= acc_zero_threshold || az >= acc_zero_threshold) {
    startRecording = true;
    stable_count = 0;
  }
  
  if (startRecording) {
    if (ax > current_max) {
      current_max = ax;
    } else if (ay > current_max) {
      current_max = ay;
    } else if (az > current_max) {
      current_max = az;
    }
  }
  
  if (prev_l > 100.0 && l <= 100.0) {
    cam.enableFlash();
    delay(100);
    cam.disableFlash();
    delay(100);
    cam.enableFlash();
    delay(100);
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

class AccelerometerListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    ax = event.values[0];
    ay = event.values[1];
    az = event.values[2];    
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}
