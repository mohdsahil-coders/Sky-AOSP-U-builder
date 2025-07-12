name: Build AOSP ROM

on:
  push:
    branches:
      - termux-build
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build SkyOS (Android 15) for Redmi 12 5G

    steps:
      - name: 📦 Checkout Source
        uses: actions/checkout@v3

  
- name: ⚙️ Install Required Packages
  run: |
    sudo apt-get update
    sudo apt-get install -y bc bison build-essential curl flex g++-multilib \
    gcc-multilib git gnupg gperf imagemagick lib32z1-dev liblz4-tool \
    libncurses-dev lib32ncurses6-dev libsdl1.2-dev libssl-dev libxml2 \
    libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc \
    zip zlib1g-dev ccache

      - name: ⚙️ Setup ccache
        run: |
          export USE_CCACHE=1
          ccache -M 50G

      - name: 📁 Create Manifest Folder & Init Repo
        run: |
          mkdir ~/rom && cd ~/rom
          repo init -u https://github.com/aosp-mirror/platform_manifest -b android-15.0.0_r3
          cp -r ../rom/local_manifest.xml .repo/local_manifests/

      - name: 🔄 Sync Source Code (approx 30GB)
        run: |
          cd ~/rom
          repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune -j4

      - name: 🛠️ Setup Build Environment
        run: |
          cd ~/rom
          source build/envsetup.sh
          lunch aosp_fire-userdebug

      - name: 🧱 Build ROM
        run: |
          cd ~/rom
          make -j$(nproc) otapackage

      - name: 📦 Upload Flashable ZIP
        uses: actions/upload-artifact@v4
        with:
          name: SkyOS-AOSP15
          path: ~/rom/out/target/product/fire/*.zip
