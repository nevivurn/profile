PROFILES := profile profile-full
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
	rm -rf profile-patched.svg $(IMGS)

profile-patched.svg: profile.svg
	sed -e "s/dx=\"0\"/dx=\"-$$(echo "$$(inkscape -I line2 -W profile.svg) - $$(inkscape -I line1 -W profile.svg)" | bc)\"/" $^ > $@

profile-500.png: profile-patched.svg
	inkscape --export-type=png -w 500 -h 500 $^ -o $@

profile-2500.png: profile-patched.svg
	inkscape --export-type=png -w 2500 -h 2500 $^ -o $@

profile-full-500.png: profile-patched.svg
	inkscape --export-type=png --export-area=50:50:450:450 -w 400 -h 400 $^ -o $@

profile-full-2500.png: profile-patched.svg
	inkscape --export-type=png --export-area=50:50:450:450 -w 2000 -h 2000 $^ -o $@
