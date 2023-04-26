#include <Arduino_LSM6DS3.h>
#include <FastLED.h>

#define NUM_LEDS 5
#define DATA_PIN 2

CRGB leds[NUM_LEDS];

int sameReading = 0;
int threshold = 20;

float zero_threshold = 13.0;
float current_max;

bool startRecording = false;
int stable_count = 0;

void setup() {
  Serial.begin(9600);
  pinMode(7, OUTPUT);

  FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, NUM_LEDS);

  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (true)
      ;
  }
}

void loop() {

  int photoCellReading = analogRead(7);

  if (photoCellReading > 200) {
    Serial.println(photoCellReading);
    photoCellLEDEffect();
    photoCellLEDEffect();
    photoCellLEDEffect();
    photoCellLEDEffect();
    photoCellLEDEffect();

  }

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
        if (current_max <= 15.00) {
          weakestLEDEffect();
        } else if (current_max <= 30.00) {
          mediumLEDEffect();
        } else {
          strongLEDEffect();
        }
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

  }
}

void photoCellLEDEffect() {
  for (int i = 0; i <= NUM_LEDS; i++) {
    leds[i] = CRGB(0, 0, 0); 
    FastLED.show();
  }
  delay(100);
  for (int i = 0; i <= NUM_LEDS; i++) {
    leds[i] = CRGB(0, 255, 0); 
    FastLED.show();
  }
  delay(100);
}

void weakestLEDEffect() {
  for (int i = 0; i <= NUM_LEDS; i++) {
    leds[i] = CRGB(60, 100, 0); 
    FastLED.show();
  }
}

void mediumLEDEffect() {
  for (int i = 0; i <= NUM_LEDS; i++) {
    leds[i] = CRGB(30, 255, 0); 
    FastLED.show();
  }
}

void strongLEDEffect() {
  for (int i = 0; i <= NUM_LEDS; i++) {
    leds[i] = CRGB(0, 255, 0); 
    FastLED.show();
  }
}
