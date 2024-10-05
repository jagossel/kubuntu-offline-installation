#!/bin/bash

docker run -d \
	--publish 3000:8080 \
	--name open-webui \
	--volume ollama:/root/.ollama \
	--volume open-webui:/app/backend/data \
	--restart=unless-stopped \
	ghcr.io/open-webui/open-webui:ollama
