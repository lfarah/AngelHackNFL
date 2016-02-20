#!/usr/bin/env bash

mkdir data
curl https://s3.amazonaws.com/ngs-hackathon/games/game-1/full/full-game-1.json > data/full-game-1.json
curl https://s3.amazonaws.com/ngs-hackathon/games/game-2/full/full-game-2.json > data/full-game-2.json
curl https://s3.amazonaws.com/ngs-hackathon/games/game-3/full/full-game-3.json > data/full-game-3.json
