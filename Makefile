PKG_NAME := gb-nes-pdf-html-zip
CURRENTDIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

all:
	mkdir -p $(CURRENTDIR)bin; \
	mkdir -p $(CURRENTDIR)build/$(PKG_NAME); \
	cp Makefile build/$(PKG_NAME); \
	cp README.md build/$(PKG_NAME); \
	cp -r $(CURRENTDIR)src build/$(PKG_NAME); \
	cd $(CURRENTDIR)src/gb; \
	rgbasm -o../../build/$(PKG_NAME).obj $(PKG_NAME).asm; \
	cd ../../build; \
	rgblink -m$(PGK_NAME).map -n$(PKG_NAME).sym -opart.gb $(PKG_NAME).obj; \
	rgbfix -p0 -v part.gb; \
	cd $(CURRENTDIR)src/nes; \
	asm $(PKG_NAME).asm ../../build/part.nes; \
	cd $(CURRENTDIR)build; \
	zip part.zip -r $(PKG_NAME); \
	cd $(CURRENTDIR); \
	cp $(CURRENTDIR)src/pdf/part.pdf build; \
	cp $(CURRENTDIR)src/html/part.html build; \
	cd $(CURRENTDIR)build; \
	head -c 16 part.nes > part.bin; \
	tail -c +17 part.gb | head -c 96 >> part.bin; \
	head -c 4 part.html >> part.bin; \
	head -c 52 part.pdf >> part.bin; \
	tail -c +169 part.gb | head -c 168 >> part.bin; \
	tail -c +5 part.html | head -c -3 >> part.bin; \
	tail -c +52 part.pdf >> part.bin; \
	tail -c +2003 part.gb | head -c 558 >> part.bin; \
	tail -c +2561 part.nes | head -c 512 >> part.bin; \
	cat part.zip >> part.bin; \
	zip -F part.bin --out final.bin; \
	tail -c +$$(expr 3073 + $$(stat -L -c %s $(CURRENTDIR)build/part.zip)) part.nes >> final.bin; \
	rgbfix -p0 -v final.bin; \
	head -c -3 final.bin > $(PKG_NAME).gb; \
	tail -c 3 part.html >> $(PKG_NAME).gb; \
	rgbfix -p0 -v $(PKG_NAME).gb; \
	cp $(PKG_NAME).gb $(CURRENTDIR)bin/; \
	cp $(PKG_NAME).gb $(CURRENTDIR)bin/$(PKG_NAME).nes; \
	cp $(PKG_NAME).gb $(CURRENTDIR)bin/$(PKG_NAME).pdf; \
	cp $(PKG_NAME).gb $(CURRENTDIR)bin/$(PKG_NAME).html; \
	cp $(PKG_NAME).gb $(CURRENTDIR)bin/$(PKG_NAME).zip; \
	cd $(CURRENTDIR); \

clean:
	rm -rf $(CURRENTDIR)bin; \
	rm -rf $(CURRENTDIR)build; \
