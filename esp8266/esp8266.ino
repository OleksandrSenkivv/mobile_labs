#include <ESP8266WiFi.h>
#include <PubSubClient.h>

const char* ssid = "LOL";
const char* password = "dormroom732";

const char* mqtt_server = "d92fdeed0d5d48028f3ae826a28a79e0.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_user = "My_User";
const char* mqtt_pass = "MyPasword1234";

const char* voltage_topic = "home/voltage";
const char* consumption_topic = "home/consumption";

WiFiClientSecure espClient;
PubSubClient client(espClient);

void setup_wifi() {
    delay(10);
    Serial.println("Підключення до Wi-Fi...");
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }

    Serial.println("\nWiFi з'єднано");
    Serial.print("IP адреса: ");
    Serial.println(WiFi.localIP());
}

void reconnect() {
    while (!client.connected()) {
        Serial.print("Підключення до MQTT...");
        if (client.connect("ESP8266Client", mqtt_user, mqtt_pass)) {
            Serial.println("З'єднано");
        } else {
            Serial.print("Помилка: ");
            Serial.print(client.state());
            delay(5000);
        }
    }
}

void setup() {
    Serial.begin(115200);
    setup_wifi();
    espClient.setInsecure();
    client.setServer(mqtt_server, mqtt_port);
}

void loop() {
    if (!client.connected()) {
        reconnect();
    }
    client.loop();

    float voltage = random(2100, 2400) / 10.0;    // 210.0V - 240.0V
    float consumption = random(50, 200) + random(0, 10) / 10.0; // 50.0W - 200.9W

    Serial.print("Вольтаж: ");
    Serial.print(voltage);
    Serial.print(" V | Споживання: ");
    Serial.print(consumption);
    Serial.println(" W");

    client.publish(voltage_topic, String(voltage, 1).c_str(), true);
    client.publish(consumption_topic, String(consumption, 1).c_str(), true);

    delay(3000);
}
