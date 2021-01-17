pycoap=pycoap/.git
tradfricoap=tradfricoap/.git
plugin=IKEA-Tradfri-plugin/.git

platform=linux/amd64,linux/arm64,linux/arm/v7
target=push

tradfri_version=0.10.5

tradfri: $(plugin)
	docker buildx build --$(target) --platform=$(platform) -t moroen/domoticz-tradfri:$(tradfri_version) -t moroen/domoticz-tradfri:latest .

domoticz:
	docker buildx build --$(target) --platform=$(platform) -t moroen/domoticz:latest -f Dockerfile.domoticz .

$(pycoap):
	git submodule init
	git submodule update pycoap

$(tradfricoap):
	git submodule init
	git submodule update tradfricoap

$(plugin): $(pycoap) $(tradfricoap)
	git submodule init
	git submodule update IKEA-Tradfri-plugin