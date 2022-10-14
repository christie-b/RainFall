#!/bin/bash

docker build -t rainfall-clone .
docker run -ti -v $(pwd):/rainfall -w /rainfall rainfall-clone bash