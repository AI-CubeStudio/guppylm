"""
从 HuggingFace 下载 GuppyLM 训练数据集。

国内用户请通过 hf-mirror 镜像访问：
https://hf-mirror.com/datasets/arman-bd/guppylm-60k-generic
"""

import os

# 国内镜像：将 HF 请求转发到 hf-mirror.com
os.environ["HF_ENDPOINT"] = "https://hf-mirror.com"

from datasets import load_dataset

ds = load_dataset("arman-bd/guppylm-60k-generic")
print(f"已下载：训练集 {len(ds['train']):,} 条，测试集 {len(ds['test']):,} 条")