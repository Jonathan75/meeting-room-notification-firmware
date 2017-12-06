#include <ESP8266WiFi.h>
#include <FastLED.h>
#include "config.h"

// Update ssid and password in the config file 
const char* ssid = WIFI_SSID;
const char* password = WIFI_PASSWORD;

#define PIN 5
#define DATA_PIN 5
#define NUM_LEDS 31

CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<WS2811, DATA_PIN, GRB>(leds, NUM_LEDS);
  pulseWhite();
  Serial.begin(115200);
  delay(100);

  // We start by connecting to a WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  /* Explicitly set the ESP8266 to be a WiFi-client, otherwise, it by default,
     would try to act as both a client and an access-point and could cause
     network-issues with your other WiFi-devices on your WiFi-network. */
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
    pulseBlue();
  }

  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

const char* host = "meeting-room-notification.herokuapp.com";
int status = 0;

void loop() {
  // Use WiFiClient class to create TCP connections
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }

  String url = "/rooms/1.json";

  // This will send the request to the server
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n");
  unsigned long timeout = millis();
  while (client.available() == 0) {
    if (millis() - timeout > 5000) {
      Serial.println(">>> Client Timeout !");
      client.stop();
      return;
    }
  }
  
  // Read all the lines of the reply from server and print them to Serial
  while(client.available()){
    String line = client.readStringUntil('\r');
    Serial.println(line);  
    if (line.indexOf("status") >= 0){
      char status = line[line.indexOf(":")+1];
      Serial.println(status);  
      led(status);
    }
  }
}

void led(char status){
  
  switch (status) {
    case '0':
      led_show(CRGB::Black); // off
      break;
    case '1':
      showYellow(); // Yellow
      break;
    case '2':
      led_show(CRGB::Red); // Red
      break;
    case '3':
      pulseRed(); // Pulse Red
      break;      
    default: 
      led_show(CRGB::Black); // off
    break;
  }

}

void led_show(int color){
   for(int whiteLed = 0; whiteLed < NUM_LEDS; whiteLed = whiteLed + 1) {
      leds[whiteLed] = color;
   }
   FastLED.show();
}

void showYellow(){
  for(int led = 0; led < NUM_LEDS; led++) {
        leds[led] = CRGB(255,155,0);
   }
   FastLED.show();    
}

void pulseWhite() {
  for(int color = 0; color <= 255; color++) {
    for(int led = 0; led < NUM_LEDS; led++) {
      leds[led] = CRGB(color, color, color);
    }
    FastLED.show();
  }

  delay(500);

  for(int color = 255; color >= 0; color--) {
    for(int led = 0; led < NUM_LEDS; led++) {
      leds[led] = CRGB(color, color, color);
    }
    FastLED.show();
  }
}

void pulseBlue() {
  for(int pulse = 0; pulse < 2; pulse++) {
    for(int color = 0; color <= 255; color++) {
      for(int led = 0; led < NUM_LEDS; led++) {
        leds[led] = CRGB(0, 0, color);
      }
      FastLED.show();
    }
  
    delay(100);
  
    for(int color = 255; color >= 0; color--) {
      for(int led = 0; led < NUM_LEDS; led++) {
        leds[led] = CRGB(0, 0, color);
      }
      FastLED.show();
    }
  }
}

void pulseRed() {
  for(int pulse = 0; pulse < 2; pulse++) {
    for(int color = 0; color <= 255; color++) {
      for(int led = 0; led < NUM_LEDS; led++) {
        leds[led] = CRGB(color, 0, 0);
      }
      FastLED.show();
    }
  
    delay(100);
  
    for(int color = 255; color >= 0; color--) {
      for(int led = 0; led < NUM_LEDS; led++) {
        leds[led] = CRGB(color, 0, 0);
      }
      FastLED.show();
    }
  }
}
