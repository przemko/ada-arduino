PROG=main
PORT=/dev/ttyACM0

all: compile dump upload

compile: $(PROG).elf

$(PROG).elf: $(PROG).adb $(PROG).gpr
	avr-gnatmake -p -XBOARD=arduino_uno -P$(PROG).gpr

dump: $(PROG).dump

$(PROG).dump: $(PROG).elf
	avr-objdump -d -S $(PROG).elf > $(PROG).dump

upload: $(PROG).hex
	avrdude -V -F -c arduino -p m328p  -P $(PORT) -b 115200  -U flash:w:$(PROG).hex
#	avrdude -v -v -v -v -v -F -c arduino -p m328p  -P $(PORT) -b 115200  -U flash:w:$(PROG).hex

$(PROG).hex: $(PROG).elf
	avr-objcopy -O ihex -R .eeprom $(PROG).elf $(PROG).hex

clean:
	rm -f *.hex *.dump *.elf *.o *.ali b~*.ad? *~

