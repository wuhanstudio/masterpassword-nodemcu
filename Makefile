######################################################################
# Makefile user configuration
######################################################################

# Path to nodemcu-uploader (https://github.com/kmpm/nodemcu-uploader)

FIRMWARE_FILE= 0 firmware/0x00000.bin 0x10000 firmware/0x10000.bin
NODEMCU_UPLOADER= esp8266-luaupload/luaupload.py
ESPTOOL=esptool/esptool.py

# Serial port
PORT=/dev/ttyUSB0
SPEED=9600

ESPTOOL-COMMAND=$(ESPTOOL) --port $(PORT) write_flash -fm dout  
ESPTOOL-ERASE=$(ESPTOOL) --port $(PORT) erase_flash

######################################################################

# Print usage
usage:
	@echo
	@echo "Usage:"
	@echo
	@echo "make clean                to erase flash"
	@echo "make upload_firmware      to upload firmware for nodemcu"
	@echo "make upload               to upload all"
	@echo

# Make Clean
clean:
	@python $(ESPTOOL-ERASE)

# Upload firmware
upload_firmware:
	@python $(ESPTOOL-COMMAND) $(FIRMWARE_FILE)
	@echo
	@echo "Please wait for at least 15s for lua firmware to get ready"
	@echo

# Upload one files only
upload:
	java -jar ESPlorer/ESPlorer.jar
	
