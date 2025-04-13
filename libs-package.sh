#!/bin/bash
# This script is used to download chrome & driver
# and repackage them into a zip file with different platforms.

# linux64, mac-arm64, mac-x64, win64

# https://storage.googleapis.com/chrome-for-testing-public/135.0.7049.84/{os}/chrome-{os}.zip
# https://storage.googleapis.com/chrome-for-testing-public/135.0.7049.84/{os}/chromedriver-{os}.zip

CHROME_VERSION="135.0.7049.84" # https://googlechromelabs.github.io/chrome-for-testing/#stable

chmod +x ./version.sh
bash ./version.sh # 生成 version.txt

# 下载指定系统名称的资源
download_resource() {
    local system_name=$1
    local base_url="https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}"
    local output_dir="downloads/${system_name}"

    # 创建输出目录
    mkdir -p "${output_dir}"

    # 下载 Chrome 和 Chromedriver
    curl -o "${output_dir}/chrome-${system_name}.zip" "${base_url}/${system_name}/chrome-${system_name}.zip"
    curl -o "${output_dir}/chromedriver-${system_name}.zip" "${base_url}/${system_name}/chromedriver-${system_name}.zip"

    echo "Resources for ${system_name} downloaded to ${output_dir}"
}

repackage_resource() {
    local system_name=$1
    local download_dir="downloads/${system_name}"
    local libs_dir="downloads/${system_name}/libs"
    local zip_file="libs-${system_name}.zip"

    mkdir -p "${libs_dir}"

    # unzip Chrome and Chromedriver
    unzip -q "${download_dir}/chrome-${system_name}.zip"
    unzip -q "${download_dir}/chromedriver-${system_name}.zip"

    # Move the files to the libs directory
    mv "chrome-${system_name}" "${libs_dir}/chrome"
    mv "chromedriver-${system_name}/chromedriver" "${libs_dir}/chromedriver"
    cp version.txt "${libs_dir}/version.txt"

    # Create a zip file with the libs directory
    zip -r "${zip_file}" "${libs_dir}"

    echo "Repackaged ${system_name} resources into ${zip_file}"
}

download_resource "linux64"
download_resource "win64"
download_resource "mac-arm64"
download_resource "mac-x64"

repackage_resource "linux64"
repackage_resource "win64"
repackage_resource "mac-arm64"
repackage_resource "mac-x64"

# Clean up
rm -rf downloads
