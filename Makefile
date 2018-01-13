######################################################################
# Makefile user configuration
######################################################################

# Path to nodemcu-uploader (https://github.com/kmpm/nodemcu-uploader)

FIRMWARE_FILE=firmware/nodemcu-master-10-modules-2017-10-28-13-21-45-integer.bin
NODEMCU_UPLOADER=nodemcu-uploader/nodemcu-uploader.py
ESPTOOL=esptool/esptool.py

# Serial port
PORT=/dev/ttyUSB0
SPEED=115200

NODEMCU-COMMAND=$(NODEMCU_UPLOADER) -b $(SPEED) --start_baud $(SPEED) -p $(PORT) upload
ESPTOOL-COMMAND=$(ESPTOOL) --port $(PORT) write_flash -fm dout 0 
ESPTOOL-ERASE=$(ESPTOOL) --port $(PORT) erase_flash

######################################################################

HTTP_FILES := $(wildcard http/*)
LUA_FILES := $(wildcard *.lua)

# Print usage
usage:
	@echo
	@echo "Usage:"
	@echo
	@echo "make clean                to erase flash"
	@echo "make install              to get server files and html files ready"
	@echo "make upload_firmware      to upload firmware for nodemcu"
	@echo "make upload_all           to upload all"
	@echo "make upload_server        to upload the server code and init.lua"
	@echo "make upload_http          to upload files to be served"
	@echo "make upload FILE:=<file>  to upload a specific file (i.e make upload FILE:=init.lua)"
	@echo

# Make Clean
clean:
	@python $(ESPTOOL-ERASE)

install:
	cp nodemcu-httpserver/*.lua ./
	cp conf/*.lua ./

# Upload firmware
upload_firmware:
	@python $(ESPTOOL-COMMAND) $(FIRMWARE_FILE)
	@echo
	@echo "Please wait for at least 15s for lua firmware to get ready"
	@echo

# Upload httpserver lua files (init and server module)
upload_server: $(LUA_FILES)
	@python $(NODEMCU-COMMAND) $(foreach f, $^, $(f))
	@echo
	@echo "Please reset your module now" 
	@echo

# Upload HTTP files only
upload_http: $(HTTP_FILES)
	@python $(NODEMCU-COMMAND) $(foreach f, $^, $(f))

# Upload all
upload_all: $(LUA_FILES) $(HTTP_FILES)
	@python $(NODEMCU-COMMAND) $(foreach f, $^, $(f))
	@echo
	@echo "Please reset your module now" 
	@echo

# Upload one files only
upload:
	@python $(NODEMCU-COMMAND) $(FILE)
