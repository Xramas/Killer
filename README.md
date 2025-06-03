## 🧠 Killer - 面向 Debian 的终端工具箱

Killer 是一个专为 Debian 12 / 11 打造的终端工具集合，旨在自动化系统初始化、软件安装、网络配置、安全防护和服务管理。

> 📦 结构模块化、插件化，纯 Bash 实现，一条命令即可开始。

---

## 🚀 快速开始

### ✅ 推荐方式（自动换源 + 自动依赖安装 + 自动启动）

```
bash <(curl -sL https://k.xramas.eu.org)
```

```
bash <(curl -sL https://raw.githubusercontent.com/Xramas/Killer/master/start.sh)
```

---

### 🛠 调试专用（禁用 GitHub 缓存）

```
bash <(curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/start.sh?$(date +%s)")
```

---

## 📁 项目结构

```
Killer/
├── start.sh             # 启动入口（自动判断区域、换源、装依赖、解压项目）
├── function.sh          # 主菜单逻辑
├── sources.sh           # 智能更换 Debian 源（按系统版本与区域）
├── essential.sh         # 安装 unzip、curl 等基础依赖
├── area.sh              # 判断是否处于中国大陆网络
├── cleanup.sh           # 清理临时脚本与下载缓存
├── requirements.sh      # 检测/安装插件依赖（插件自声明）
├── /custom              # 自定义插件
├── /installer           # 软件安装模块
├── /network             # 网络工具模块
├── /optimize            # 优化清理模块
├── /security            # 安全策略模块
├── /services            # 系统服务管理模块
└── /sysinfo             # 系统信息查看模块
```

---

## 🧩 插件架构说明

* 每个模块目录下为独立插件脚本，文件命名为 `序号_功能.sh`

* 插件脚本中需注明：

  ```
  # Name: 插件功能名称
  # Require: curl unzip ...（可选）
  ```

* 主程序自动识别所有模块与插件，无需手动注册

---

## 🧼 清理说明

自动清理逻辑已内置于 `start.sh` 与主程序退出流程中。如需手动执行：

```
bash cleanup.sh all      # 清理所有临时脚本与缓存
bash cleanup.sh init     # 仅清理初始化脚本
```

---

## 📦 依赖说明

运行需环境支持：

* Debian 11 / 12
* `bash`, `curl`, `wget`, `unzip`, `ufw`（部分功能）

插件依赖将由 `requirements.sh` 自动扫描并提示安装。

---

## 🧱 支持区域自动识别

`area.sh` 会根据外网 IP 自动判断是否来自中国大陆，并决定是否使用加速源（gh-proxy）。

---

## 💡 示例功能

* 智能配置软件源
* 一键同步 Cloudflare IP 并配置 UFW
* 查看系统信息
* 安装常用软件
* 清理系统缓存
* 管理 systemd 服务状态
* 扫描网络、测速等工具

---

## 📬 联系我

由 [@Xramas](https://github.com/Xramas) 构建维护。

欢迎 issue、fork 和 PR。
