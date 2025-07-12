name: Build AOSP ROM

on:
  push:
    branches:
      - termux-build
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build ROM for Redmi 12 5G

    steps:
      - name: Checkout source
        uses: actions/checkout@v3

      - name: Set up environment
        run: |
          sudo apt-get update
          sudo apt-get install -y \
            bc bison build-essential curl flex g++-multilib \
            gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev \
            lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev \
            libsdl1.2-dev libssl-dev libxml2 libxml2-utils \
            lzop pngcrush rsync schedtool squashfs-tools xsltproc zip \
            zlib1g-dev

      - name: Setup ccache
        run: |
          sudo apt install -y ccache
          export USE_CCACHE=1
          ccache -M 50G

      - name: Dummy Sync AOSP Source
        run: |
          echo "✅ AOSP source syncing simulated."
