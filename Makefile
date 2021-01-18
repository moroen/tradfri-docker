pycoap=pycoap/.git
tradfricoap=tradfricoap/.git
plugin=IKEA-Tradfri-plugin/.git

platform=linux/amd64,linux/arm64,linux/arm/v7
target=push
cache=


current_tradfri_version=0.10.5


tradfri-local: platform=linux/amd64
tradfri-local: target=load
tradfri-local: tradfri-beta

tradfri-stable: branch=master
tradfri-stable: tag=latest
tradfri-stable: tradfri_version=$(current_tradfri_version)
tradfri-stable: tradfri-build

tradfri-beta: branch=development
tradfri-beta: tag=latest-beta
tradfri-beta: tradfri_version=$(current_tradfri_version)-beta
tradfri-beta: tradfri-build

domoticz-stable: branch=master
domoticz-stable: tag=latest
domoticz-stable: domoticz-build

domoticz-beta: branch=development
domoticz-beta: tag=latest-beta
domoticz-beta: domoticz-build

domoticz-beta-local: platform=linux/amd64
domoticz-beta-local: target=load
domoticz-beta-local: domoticz-beta

domoticz-stable-local: platform=linux/amd64
domoticz-stable-local: target=load
domoticz-stable-local: domoticz-stable

tradfri-build: $(plugin)
	cd IKEA-Tradfri-plugin; git checkout $(branch)
	docker buildx build $(cache) --$(target) --platform=$(platform) --build-arg DOMOTICZ_VERSION=$(tag) -t moroen/domoticz-tradfri:$(tradfri_version) -t moroen/domoticz-tradfri:$(tag) .

domoticz-build:
	docker buildx build $(cache) --$(target) --platform=$(platform) --build-arg DOMOTICZ_BRANCH=$(branch) -t moroen/domoticz:$(tag) -f Dockerfile.domoticz .

$(pycoap):
	git submodule init
	git submodule update pycoap

$(tradfricoap):
	git submodule init
	git submodule update tradfricoap

$(plugin): $(pycoap) $(tradfricoap)
	git submodule init
	git submodule update IKEA-Tradfri-plugin