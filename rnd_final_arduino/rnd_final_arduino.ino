#include <Arduino_LSM6DS3.h>

int sameReading = 0;
int threshold = 20;

float zero_threshold = 10.5;
float current_max;

bool startRecording = false;
int stable_count = 0;

void setup() {
  Serial.begin(9600);
  pinMode(7, OUTPUT);

  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (true)
      ;
  }
}

void loop() {
  //Serial.println(analogRead(7));

  float x, y, z;
  int orientation = -1;

  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(x, y, z);

    x = x * 10;
    y = y * 10;
    z = z * 10;

    if (stable_count >= 30) {
      if (current_max != 0.00) {
        Serial.print("current max is: ");
        Serial.println(current_max);
      }
      
      startRecording = false;
      current_max = 0.0;
    }

    if (abs(x) < zero_threshold && abs(y) < zero_threshold && abs(z) < zero_threshold) {
      stable_count += 1;
    }

    if (abs(x) >= zero_threshold || abs(y) >= zero_threshold || abs(z) >= zero_threshold) {
      startRecording = true;
      stable_count = 0;
    }

    if (startRecording) {
      if (abs(x) > current_max) {
        current_max = abs(x);
      } else if (abs(y) > current_max) {
        current_max = abs(y);
      } else if (abs(z) > current_max) {
        current_max = abs(z);
      }
    }

    // Serial.print("x: ");
    // Serial.print(x * 10);
    // Serial.print("y: ");
    // Serial.print(y * 10);
    // Serial.print("z: ");
    // Serial.println(z * 10);
  }
}
