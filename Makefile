PROFILES := profile profile-full profile-bw profile-bw-full
SIZES := 500 2500

IMGS := $(foreach profile,$(PROFILES),$(foreach size,$(SIZES),$(profile)-$(size).png))

.PHONY: all
all: $(IMGS)

.PHONY: nix-build
nix-build:
	nix build
	install -m644 $(addprefix result/,$(IMGS)) ./

.PHONY: clean
clean:
	rm -rf *.patched.svg *.png

%-bw.svg: %.svg
	sed -e 's/fill="#.\+"/fill="#fff"/' -e '/fill:/d' $^ > $@

%.patched.svg: %.svg
	sed -e "s/dx=\"0\"/dx=\"-$$(echo "$$(inkscape -I line2 -W $^) - $$(inkscape -I line1 -W $^)" | bc)\"/" $^ > $@

%-full-500.png: %.patched.svg
	inkscape --export-type=png --export-area=50:50:450:450 -w 400 -h 400 $^ -o $@
%-full-2500.png: %.patched.svg
	inkscape --export-type=png --export-area=50:50:450:450 -w 2000 -h 2000 $^ -o $@
%-500.png: %.patched.svg
	inkscape --export-type=png -w 500 -h 500 $^ -o $@
%-2500.png: %.patched.svg
	inkscape --export-type=png -w 2500 -h 2500 $^ -o $@
