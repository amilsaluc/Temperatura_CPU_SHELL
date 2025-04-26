#!/bin/bash

export LC_NUMERIC=C

limite_sensor1=50
limite_sensor2=40

token="7728352689:AAGpD7xgNCK7XkhiIhxK39Pz_lf0JUGiWHo"

chat_id="1168329992"

enviar_telegram() {
	mensagem=$1
	curl -s -X POST "https://api.telegram.org/bot7728352689:AAGpD7xgNCK7XkhiIhxK39Pz_lf0JUGiWHo/sendMessage" \
		-d chat_id="$chat_id" \
		-d text="$mensagem"
}

while true; do	
	sensor1=$(sensors | grep "Sensor 1:" | awk '{print $3}' | sed 's/+//;s/°C//')
	sensor2=$(sensors | grep "Sensor 2:" | awk '{print $3}' | sed 's/+//;s/°C//')


	sensor1_inteiro=$(printf "%.0f" "$sensor1")
	sensor2_inteiro=$(printf "%.0f" "$sensor2")

	if [ "$sensor1_inteiro" -gt "$limite_sensor1" ]; then 
		mensagem="Alerta, o primeiro sensor detectou que o seu processador está aquecendo. Temperatura: ${sensor1_inteiro}°C "
		echo "$mensagem"
		enviar_telegram "$mensagem"
	fi

	if [ "$sensor2_inteiro" -gt "$limite_sensor2" ]; then
		mensagem="Alerta, o segundo sensor detectou que o seu processador está aquecendo. Temperatura: ${sensor2_inteiro}°C"
		echo "$mensagem"
		enviar_telegram "$mensagem"
	fi

	sleep 30m
done

