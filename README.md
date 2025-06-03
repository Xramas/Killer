````markdown
# Killer Tools

Killer 是一个为 Debian 系统量身打造的 Linux 工具箱，支持自动初始化系统源、智能判断地理位置、并提供交互式终端工具选择界面。

## ✨ 特性

- ✅ 自动识别系统版本（Debian 11 / 12）
- ✅ 自动识别是否为中国大陆 IP
- ✅ 根据地理和版本条件自动配置最优 APT 源（清华镜像或官方源）
- ✅ 自动执行 `apt update`
- ✅ 初始化完成后进入清爽的交互式菜单界面
- ✅ 脚本可直接通过 Bash 在线执行

## 🚀 快速开始

无须克隆仓库，直接一条命令开始使用：

```bash
bash <(curl -sL https://raw.githubusercontent.com/Xramas/Killer/refs/heads/master/bash.sh)
````

## 📋 示例功能菜单（初始化后）

```text
初始化完成
欢迎使用 Killer Tools!
----------------------------
1) 功能1
2) 功能2
3) 功能3
4) 退出
```

> 注：功能模块可根据你的实际需求扩展，欢迎 PR 或 Issue！

## 📂 项目结构

```
Killer/
├── bash.sh          # 主执行脚本
├── README.md        # 项目说明文件
```

## 💡 适用环境

* 系统：Debian 11 / Debian 12
* 权限：需要 root 权限执行（建议用 `sudo`）

## 📬 联系作者

如有建议或 bug 回报，欢迎通过 GitHub Issue 联系我！

---

```
