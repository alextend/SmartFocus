# SmartFocus

Automatically detects important NPCs and Tanks in Delves/Dungeons/PVP and provides a secure button to set focus quickly.

---

<details>
<summary><b>🇨🇳 简体中文 (Chinese) - 点击展开/折叠</b></summary>

## 简介
**SmartFocus** 是一款轻量级的魔兽世界插件，旨在特定场景（如地下堡、大副本或 PVP）下，通过一个安全动作按钮快速锁定关键友方目标（如布莱恩·铜须或坦克职业）为焦点。

### ✨ 主要功能
- **智能目标检测**: 
  - 自动识别地下堡中的关键 NPC（如布莱恩）。
  - 在副本或团队中自动识别坦克职业。
  - 在 PVP 环境下优先识别坦克或特定职业。
- **安全动作按钮**: 遵循暴雪安全模板，确保战斗中点击依然有效。
- **场景化激活**: 可自定义在地下堡、五人本、团本或 PVP 场景中开启。
- **高度自定义**: 自由调整按钮位置（X/Y 偏移），支持按职业启用。

### 🚀 安装步骤
1. 下载插件压缩包。
2. 解压并将 `SmartFocus` 文件夹放入 `_retail_\Interface\AddOns\`。
3. 重启游戏或输入 `/reload`。

### 🛠 使用方法
- **命令行**: 输入 `/sf` 打开配置界面。
- **配置项**:
  - **启用职业**: 勾选允许运行该插件的职业。
  - **位置调整**: 在设置中通过滑块实时调整按钮位置。
  - **PVP 逻辑**: 可配置优先寻找坦克或特定的 DPS 职业。

</details>

<details>
<summary><b>🇺🇸 English - Click to Expand/Collapse</b></summary>

## Introduction
**SmartFocus** is a lightweight World of Warcraft addon designed to quickly set focus on key friendly targets (like Brann Bronzebeard or Tanks) via a secure action button in specific scenarios like Delves, Dungeons, or PVP.

### ✨ Key Features
- **Smart Detection**: 
  - Auto-identifies key NPCs in Delves (e.g., Brann).
  - Auto-identifies Tank roles in Dungeons or Raids.
  - Prioritizes Tanks or specific classes in PVP.
- **Secure Action Button**: Built using secure templates to ensure functionality during combat.
- **Scenario-Based Activation**: Can be enabled specifically for Delves, Dungeons, Raids, or PVP.
- **Highly Customizable**: Adjust button position (X/Y offsets) and enable/disable per character class.

### 🚀 Installation
1. Download the addon archive.
2. Extract and place the `SmartFocus` folder into `_retail_\Interface\AddOns\`.
3. Restart the game or type `/reload`.

### 🛠 Usage
- **Slash Command**: Type `/sf` to open the configuration menu.
- **Settings**:
  - **Enabled Classes**: Select which classes the addon should load for.
  - **Positioning**: Use sliders to move the button on your screen in real-time.
  - **PVP Logic**: Configure whether to prioritize Tanks or specific DPS classes.

</details>

---

## 📦 Directory Structure / 目录结构

```text
SmartFocus/
├── Libs/              # Dependencies (Ace3, etc.)
├── Locales/           # Localization files
├── Launcher.lua       # Entry point
├── SmartFocus.lua     # Core logic
├── Config.lua         # Options table and DB
├── Button.lua         # Secure button UI logic
└── SmartFocus.toc     # Addon metadata
```

## 📝 Developer / 开发者
- **Author**: Alextend
- **Framework**: Ace3

---

## 📄 License
This project is licensed under the MIT License.
