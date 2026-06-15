#!/usr/bin/env bash
# 从 HuggingFace 下载 model.onnx 与 tokenizer.json 到当前目录（docs/）。
#
# 国内默认使用 hf-mirror 镜像；可手动切换：
#   HF_MIRROR=https://huggingface.co bash download.sh   # 强制官方源
#   HF_MIRROR=https://hf-mirror.com bash download.sh    # 强制镜像（默认）

set -e

REPO="arman-bd/guppylm-9M"
# 国内镜像站，与 datasetDownload.py 中 HF_ENDPOINT 对应
HF_MIRROR="${HF_MIRROR:-https://hf-mirror.com}"
DIR="$(cd "$(dirname "$0")" && pwd)"

# 按顺序尝试下载：先镜像，失败再回退官方 HuggingFace
MIRRORS=(
  "${HF_MIRROR}"
  "https://huggingface.co"
)

download_file() {
  local filename="$1"
  local dest="${DIR}/${filename}"
  local last_err=""

  for base in "${MIRRORS[@]}"; do
    local url="${base}/${REPO}/resolve/main/${filename}"
    echo "  ${filename}  ←  ${url}"
    if curl -fSL --connect-timeout 15 --max-time 600 "${url}" -o "${dest}"; then
      echo "       ✓ $(du -h "${dest}" | cut -f1)"
      return 0
    fi
    last_err="${url}"
    rm -f "${dest}"
    echo "       ✗ 下载失败，尝试下一个源..."
  done

  echo "错误：无法下载 ${filename}（最后尝试：${last_err}）" >&2
  return 1
}

echo "Downloading from ${REPO}..."
echo "镜像优先级：${MIRRORS[*]}"
echo

download_file "model.onnx"
download_file "tokenizer.json"

echo
echo "Done. 启动本地演示："
echo "  cd ${DIR} && python -m http.server 8080"
echo "  浏览器打开 http://localhost:8080"
