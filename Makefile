ZFLAG=:z  # Set to empty if running on non-selinux host

IMAGE_NAME=freecad_fedora_build_environment
CONTAINER_NAME=build_freecad
CONTAINER_WORKDIR=/work
DOCKER_RUN=docker run --name=$(CONTAINER_NAME) -v "$(PWD)":$(CONTAINER_WORKDIR)$(ZFLAG) -w $(CONTAINER_WORKDIR) $(IMAGE_NAME)

.PHONY: all
all: prepare build_ctr build_freecad

.PHONY: build-docker-image
build_ctr:
	docker build -t $(IMAGE_NAME) .

build_freecad: build_ctr
	git submodule update --init
	$(DOCKER_RUN) ./build-fedora.sh

prepare:
	@echo "Cloning remaining source, including submodules"
	@git submodule update --init
	@cd FreeCAD && git submodule update --init
	@stat FreeCAD/CMakeLists.txt 1>&1 2>/dev/null || echo "FreeCAD source seems not complete"

clean:
	@echo "docker rm -v ${CONTAINER_NAME}"
	@docker rm -v ${CONTAINER_NAME} >/dev/null || echo "Container removed already"
	@echo docker rmi ${IMAGE_NAME}:latest 
	@docker rmi ${IMAGE_NAME}:latest 2>/dev/null || echo "Image removed already"

logs:
	docker logs -f ${CONTAINER_NAME}

shell:
	docker exec -it ${CONTAINER_NAME} /bin/bash

stop:
	docker stop ${CONTAINER_NAME}

rm:
	docker kill ${CONTAINER_NAME}
	docker rm -f ${CONTAINER_NAME}
