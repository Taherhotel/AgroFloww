#include <Wire.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <LiquidCrystal_I2C.h>
#include <Adafruit_NeoPixel.h>
#include <ESP32Servo.h>
#include <CytronMotorDriver.h>
#include <WiFiClientSecure.h>

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>


#include "pins.h"

const char* WIFI_SSID = "Taher iPhone";
const char* WIFI_PASS = "1234567890";

/******** FIREBASE ********/
/* IMPORTANT:
   Use database URL only
   DO NOT add ?auth=API_KEY
*/
const char* FIREBASE_HOST =
  "https://agroflow-52f2e-default-rtdb.firebaseio.com";

/******** Firebase timing ********/
unsigned long lastFirebaseSend = 0;
const unsigned long FIREBASE_INTERVAL_MS = 1UL * 60UL * 1000UL; // 5 min


/* =========================================================
   WIFI CONNECT
   ========================================================= */

void connectWiFi() {

  if (WiFi.status() == WL_CONNECTED)
    return;

  Serial.print("Connecting WiFi");

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi Connected!");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
}


/* =========================================================
   FIREBASE SEND FUNCTION  (FIXED + STABLE)
   ========================================================= */

void sendToFirebase(float tempC,
                    float ph,
                    float tds,
                    float ntu,
                    bool probesDown) {

  if (WiFi.status() != WL_CONNECTED)
    return;

  /* HTTPS client for Firebase */
  WiFiClientSecure client;
  client.setInsecure();   // skip SSL cert check (needed for ESP32)

  HTTPClient http;

  String url = String(FIREBASE_HOST) +
               "/hydroponics/mint/latest.json";

  StaticJsonDocument<256> doc;

  doc["temperature_C"] = tempC;
  doc["probes_down"]   = probesDown;
  doc["timestamp"]     = millis();

  if (probesDown) {
    doc["pH"]       = ph;
    doc["tds_ppm"]  = tds;
    doc["turb_ntu"] = ntu;
  }

  String payload;
  serializeJson(doc, payload);

  Serial.println("\nSending to Firebase:");
  Serial.println(payload);

  http.begin(client, url);
  http.addHeader("Content-Type", "application/json");

  int httpCode = http.PUT(payload);

  Serial.print("HTTP Code: ");
  Serial.println(httpCode);

  if (httpCode > 0) {
    Serial.println(http.getString());
  } else {
    Serial.println("Firebase send failed");
  }

  http.end();
}


/* =========================================================
   CONFIGURATION CONSTANTS
   ========================================================= */

// ---- Dosing pump direction (flip HIGH/LOW to reverse) ----
const bool PUMP1_DIR = HIGH;   // pH dosing pump
const bool PUMP2_DIR = HIGH;   // Nutrient dosing pump

// ---- Servo angles ----
const int SERVO_UP_ANGLE   = 180;
const int SERVO_DOWN_ANGLE = 0;

// ---- ADC ----
const float ADC_REF = 3.3;
const int ADC_RES = 4095;

// ---- Display / update timing ----
const unsigned long UPDATE_INTERVAL_MS = 500;

// ---- Probe dipping schedule ----
const unsigned long DIP_INTERVAL_MS = 1UL * 60UL * 1000UL;   // 30 min
const unsigned long DIP_DURATION_MS = 20UL * 1000UL;         // 20 sec

// ---- Manual button ----
const unsigned long LONG_PRESS_MS = 3000;
const unsigned long BUTTON_DEBOUNCE_MS = 200;

// ---- Dissolved oxygen (constant placeholder) ----
const float DO_IDEAL = 6.0;   // mg/L (ideal for mint)

/* =========================================================
   OBJECTS
   ========================================================= */
// Cytron motor objects (DIR, PWM)
CytronMD motorPump1(PWM_DIR, PIN_MOTOR1_PWM, PIN_MOTOR1_DIR);
CytronMD motorPump2(PWM_DIR, PIN_MOTOR2_PWM, PIN_MOTOR2_DIR);
// Pump direction (flip sign to reverse)
const int PUMP1_SPEED = 200;   // + = forward, - = reverse
const int PUMP2_SPEED = 200;

LiquidCrystal_I2C lcd(0x27, 16, 2);

OneWire oneWire(PIN_DS18B20_DATA);
DallasTemperature tempSensor(&oneWire);

Adafruit_NeoPixel leds(WS2812_LED_COUNT, PIN_WS2812_DATA, NEO_GRB + NEO_KHZ800);

Servo servo1, servo2, servo3;

/* =========================================================
   GLOBAL STATE
   ========================================================= */

// ---- UI ----
uint8_t page = 0;

// ---- Timing ----
unsigned long lastUpdate = 0;

// ---- Button ----
unsigned long buttonPressStart = 0;
bool longPressTriggered = false;

// ---- Probe state ----
enum ProbeState { PROBE_UP, PROBE_DOWN };
ProbeState probeState = PROBE_UP;

unsigned long lastDipTime = 0;
unsigned long dipStartTime = 0;

/* =========================================================
   HELPER FUNCTIONS
   ========================================================= */

float readVoltage(uint8_t pin) {
  return (analogRead(pin) * ADC_REF) / ADC_RES;
}

float voltageToPH(float voltage) {
  // Calibrated for your probe + board
  const float PH_AT_VOLTAGE = 6.5;     // known solution pH
  const float VOLTAGE_AT_PH = 1.85;    // measured voltage

  const float SLOPE = -3.0;            // typical for pH modules

  return PH_AT_VOLTAGE + SLOPE * (voltage - VOLTAGE_AT_PH);
}


float voltageToTDS(float voltage, float temperature) {
  float compensation = 1.0 + 0.02 * (temperature - 25.0);
  float v = voltage / compensation;
  return (133.42 * v * v * v - 255.86 * v * v + 857.39 * v);
}

float voltageToNTU(float voltage) {
  float ntu = -1120.4 * voltage * voltage
            + 5742.3 * voltage
            - 4352.9;
  return (ntu < 0) ? 0 : ntu;
}

void setLED(uint8_t r, uint8_t g, uint8_t b) {
  for (uint8_t i = 0; i < WS2812_LED_COUNT; i++) {
    leds.setPixelColor(i, leds.Color(r, g, b));
  }
  leds.show();
}

/* =========================================================
   SERVO CONTROL
   ========================================================= */

void servos_up() {
  servo1.write(SERVO_UP_ANGLE);
  servo2.write(SERVO_UP_ANGLE);
  servo3.write(SERVO_UP_ANGLE);
}

void servos_down() {
  servo1.write(SERVO_DOWN_ANGLE);
  servo2.write(SERVO_DOWN_ANGLE);
  servo3.write(SERVO_DOWN_ANGLE);
}

/* =========================================================
   MANUAL DOSING (LONG PRESS)
   ========================================================= */
bool manualDosingActive = false;
void manualDoseBothPumps() {

  manualDosingActive = true;

  motorPump1.setSpeed(PUMP1_SPEED);
  motorPump2.setSpeed(PUMP2_SPEED);

  setLED(255, 0, 255);   // Purple
  lcd.clear();
  lcd.print("Manual Dosing");

  delay(1000);

  motorPump1.setSpeed(0);
  motorPump2.setSpeed(0);

  manualDosingActive = false;
}



/* =========================================================
   BUTTON HANDLING
   ========================================================= */

void updateButton() {
  static unsigned long lastShortPress = 0;

  bool pressed = (digitalRead(PIN_PUSHBUTTON) == LOW);

  if (pressed && buttonPressStart == 0) {
    buttonPressStart = millis();
    longPressTriggered = false;
  }

  if (pressed && !longPressTriggered) {
    if (millis() - buttonPressStart >= LONG_PRESS_MS) {
      manualDoseBothPumps();
      longPressTriggered = true;
    }
  }

  if (!pressed && buttonPressStart != 0) {
    if (!longPressTriggered &&
        millis() - lastShortPress > BUTTON_DEBOUNCE_MS) {

      page = (page + 1) % 4;
      lcd.clear();
      setLED(0, 0, 255);   // Blue
      lastShortPress = millis();
    }
    buttonPressStart = 0;
  }
}

/* =========================================================
   PROBE DIPPING SCHEDULER
   ========================================================= */

void updateProbeCycle() {
  unsigned long now = millis();

  if (probeState == PROBE_UP && now - lastDipTime >= DIP_INTERVAL_MS) {
    servos_down();
    probeState = PROBE_DOWN;
    dipStartTime = now;
    lastDipTime = now;

    lcd.clear();
    lcd.print("Probes DOWN");
  }

  if (probeState == PROBE_DOWN && now - dipStartTime >= DIP_DURATION_MS) {
    servos_up();
    probeState = PROBE_UP;

    lcd.clear();
    lcd.print("Probes UP");
  }
}

/* =========================================================
   SETUP
   ========================================================= */

void setup() {
  Serial.begin(115200);

  pinMode(PIN_PUSHBUTTON, INPUT_PULLUP);
  pinMode(PIN_UV_LED, OUTPUT);

  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);

  lcd.begin();
  lcd.backlight();

  tempSensor.begin();

  analogReadResolution(12);
  analogSetAttenuation(ADC_11db);

  leds.begin();
  leds.setBrightness(10);
  setLED(0, 255, 0);

  servo1.attach(PIN_SERVO_1);
  servo2.attach(PIN_SERVO_2);
  servo3.attach(PIN_SERVO_3);

  servos_up();   delay(1000);
  servos_down(); delay(1000);
  servos_up();   delay(1000);

  lcd.print("System Ready");
  delay(1200);
  lcd.clear();

  motorPump1.setSpeed(0);
  motorPump2.setSpeed(0);

}

/* =========================================================
   LOOP
   ========================================================= */

void loop() {
  connectWiFi();
  if (manualDosingActive) {
  return;   // pause normal UI & logic
  }
  updateButton();
  updateProbeCycle();

  if (millis() - lastUpdate >= UPDATE_INTERVAL_MS) {
    lastUpdate = millis();

    tempSensor.requestTemperatures();
    float tempC = tempSensor.getTempCByIndex(0);

    float phValue = NAN;
    float tdsValue = NAN;
    float ntuValue = NAN;

    if (probeState == PROBE_DOWN) {
      phValue  = voltageToPH(readVoltage(PIN_PH));
      tdsValue = voltageToTDS(readVoltage(PIN_TDS), tempC);
      ntuValue = voltageToNTU(readVoltage(PIN_TURBIDITY));
    }

    if (millis() - lastFirebaseSend >= FIREBASE_INTERVAL_MS) {
      lastFirebaseSend = millis();
      sendToFirebase(tempC,phValue,tdsValue,ntuValue,(probeState == PROBE_DOWN));
    }


    lcd.setCursor(0, 0);

    if (probeState == PROBE_UP) {
      lcd.print("Temp & DO      ");
      lcd.setCursor(0, 1);
      lcd.print(tempC, 1);
      lcd.print("C  DO:");
      lcd.print(DO_IDEAL, 1);
      return;
    }

    setLED(0, 255, 0);

    switch (page) {
      case 0:
        lcd.print("Temperature    ");
        lcd.setCursor(0, 1);
        lcd.print(tempC, 1);
        lcd.print(" C        ");
        break;

      case 1:
        lcd.print("TDS            ");
        lcd.setCursor(0, 1);
        lcd.print(tdsValue, 0);
        lcd.print(" ppm     ");
        break;

      case 2:
        lcd.print("pH Value       ");
        lcd.setCursor(0, 1);
        lcd.print(phValue, 2);
        lcd.print("          ");
        break;

      case 3:
        lcd.print("Turbidity      ");
        lcd.setCursor(0, 1);
        lcd.print(ntuValue, 0);
        lcd.print(" NTU     ");
        break;
    }
  }
}