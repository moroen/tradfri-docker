pycoap=pycoap/.git
tradfricoap=tradfricoap/.git
plugin=IKEA-Tradfri-plugin/.git

platform=linux/amd64,linux/arm64,linux/arm/v7
target=push
cache=

current_tradfri_version=0.10.5


tradfri-local: platform=linux/amd64
tradfri-local: target=load
tradfri-local: tradfri-master

tradfri-master: branch=master
tradfri-master: channel=stable
tradfri-master: tradfri_version=$(current_tradfri_version)
tradfri-master: tradfri-build

tradfri-development: branch=development
tradfri-development: channel=beta
tradfri-development: tradfri_version=$(current_tradfri_version)-dev
tradfri-development: tradfri-build

domoticz-stable: channel=release
domoticz-stable: tag=stable
domoticz-stable: domoticz-build

domoticz-beta: channel=beta
domoticz-beta: tag=beta
domoticz-beta: domoticz-build

domoticz-beta-local: platform=linux/amd64
domoticz-beta-local: target=load
domoticz-beta-local: domoticz-beta

domoticz-stable-local: platform=linux/amd64
domoticz-stable-local: target=load
domoticz-stable-local: domoticz-stable

tradfri-build: $(plugin)
	cd IKEA-Tradfri-plugin; git checkout $(branch)
	cd tradfricoap; git checkout $(branch)
	docker buildx build $(cache) --$(target) --platform=$(platform) --build-arg DOMOTICZ_VERSION=$(channel) -t moroen/domoticz-tradfri:latest -t moroen/domoticz-tradfri:$(tradfri_version) .

domoticz-build:
	docker buildx build $(cache) --$(target) --platform=$(platform) --build-arg DOMOTICZ_VERSION=$(channel) -t moroen/domoticz:$(tag) -f Dockerfile.domoticz .

$(pycoap):
	git submodule init
	git submodule update pycoap

$(tradfricoap):
	git submodule init
	git submodule update tradfricoap

$(plugin): $(pycoap) $(tradfricoap)
	git submodule init
	git submodule update IKEA-Tradfri-plugin