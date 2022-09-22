.PHONY: all
all: profile-500.png profile-2500.png

.PHONY: clean
clean:
	rm -rf profile-patched.svg profile-500.png profile-2500.png

profile-patched.svg: profile.svg
	sed -e "s/dx=\"0\"/dx=\"-$$(echo "$$(inkscape -I line2 -W profile.svg) - $$(inkscape -I line1 -W profile.svg)" | bc)\"/" $^ > $@

profile-2500.png: profile-patched.svg
	inkscape --export-type=png -w 500 -h 500 $^ -o $@

profile-500.png: profile-patched.svg
	inkscape --export-type=png -w 2500 -h 2500 $^ -o $@
