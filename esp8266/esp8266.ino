#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <EEPROM.h>
#include <ArduinoJson.h>

const char* ssid = "GT_Dacha_2G";
const char* password = "67614134";

const char* voltage_topic = "home/voltage";
const char* consumption_topic = "home/consumption";
const char* request_topic = "device/request";
const char* response_topic = "device/response";
const char* serial_topic = "device/set_serial";
const char* info_request_topic = "device/info_request";
const char* info_response_topic = "device/info_response";

WiFiClientSecure espClient;
PubSubClient client(espClient);

String serialNumber = "";

void saveSerialToEEPROM(const String& serial) {
    EEPROM.begin(64);
    for (int i = 0; i < serial.length(); i++) {
        EEPROM.write(i, serial[i]);
    }
    EEPROM.write(serial.length(), '\0');
    EEPROM.commit();
    EEPROM.end();
}

String readSerialFromEEPROM() {
    EEPROM.begin(64);
    char buffer[32];
    for (int i = 0; i < 32; i++) {
        buffer[i] = EEPROM.read(i);
        if (buffer[i] == '\0') break;
    }
    EEPROM.end();
    return String(buffer);
}

void callback(char* topic, byte* payload, unsigned int length) {
    String msg;
    for (unsigned int i = 0; i < length; i++) {
        msg += (char)payload[i];
    }

    Serial.print("MQTT повідомлення [");
    Serial.print(topic);
    Serial.print("]: ");
    Serial.println(msg);

    DynamicJsonDocument doc(256);
    DeserializationError err = deserializeJson(doc, msg);

    if (err) {
        Serial.println("Помилка парсингу JSON");
        return;
    }

    if (String(topic) == request_topic) {
        String user = doc["user"];
        String pass = doc["pass"];

        DynamicJsonDocument response(128);
        if (user == mqtt_user && pass == mqtt_pass) {
            response["status"] = "success";
        } else {
            response["status"] = "fail";
        }

        String resStr;
        serializeJson(response, resStr);
        client.publish(response_topic, resStr.c_str());
        Serial.println("Відповідь на креденшинали: " + resStr);
    }

    else if (String(topic) == serial_topic) {
        String serial = doc["serial"];
        Serial.println("Отримано серійник: " + serial);
        serialNumber = serial;
        saveSerialToEEPROM(serialNumber);
        Serial.println("Серійник збережено в EEPROM");

        // Надіслати підтвердження назад
        DynamicJsonDocument response(128);
        response["serial"] = serialNumber;
        response["device"] = mqtt_user;
        String resStr;
        serializeJson(response, resStr);
        client.publish(response_topic, resStr.c_str());
    }

    else if (String(topic) == info_request_topic) {
        DynamicJsonDocument info(128);
        info["serial"] = serialNumber;
        info["device"] = mqtt_user;

        String infoStr;
        serializeJson(info, infoStr);
        client.publish(info_response_topic, infoStr.c_str());
        Serial.println("Надіслано info: " + infoStr);
    }
}

void setup_wifi() {
    delay(10);
    Serial.println("Підключення до Wi-Fi...");
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }

    Serial.println("");
    Serial.println("WiFi з'єднано");
    Serial.print("IP адреса: ");
    Serial.println(WiFi.localIP());
}

void reconnect() {
    while (!client.connected()) {
        Serial.print("Підключення до MQTT... ");
        String clientId = "ESP8266Client-" + String(random(0xffff), HEX);

        if (client.connect(clientId.c_str(), mqtt_user, mqtt_pass)) {
            Serial.println("успішно");

            client.subscribe(request_topic);
            client.subscribe(serial_topic);
            client.subscribe(info_request_topic);

        } else {
            Serial.print("Помилка, rc=");
            Serial.print(client.state());
            Serial.println(" повтор через 5 секунд");
            delay(5000);
        }
    }
}

void setup() {
    Serial.begin(115200);
    setup_wifi();

    espClient.setInsecure(); // ігнорування сертифікату SSL
    client.setServer(mqtt_server, mqtt_port);
    client.setCallback(callback);

    serialNumber = readSerialFromEEPROM();
    Serial.println("Серійник з EEPROM: " + serialNumber);
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
