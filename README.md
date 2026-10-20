# opencode-remote

通过 Tailscale 在手机浏览器里使用 opencode（电脑当服务端，手机当客户端）。

## 原理

- 电脑运行 `opencode web`，监听 `0.0.0.0:4096`
- Tailscale 把电脑和手机放进同一个虚拟局域网
- 手机浏览器访问 `http://<电脑Tailscale IP>:4096`，和电脑共用同一份会话数据

## 前置条件

- 电脑：安装 [Tailscale](https://tailscale.com/download) 和 opencode CLI
- 手机：安装 Tailscale（App Store / Google Play / [GitHub APK](https://github.com/tailscale/tailscale-android/releases)）
- 两端登录同一个 Tailscale 账号

opencode CLI 的 Windows 包可在 [releases](https://github.com/anomalyco/opencode/releases) 下载，解压后把 `opencode.exe` 加入 PATH，或放到：

```
%LOCALAPPDATA%\Programs\opencode-cli\opencode.exe
```

## 使用

1. 把要作为项目的文件夹放到本目录下，或在项目目录中放一份本脚本
2. 双击 `start-opencode-web.bat`
3. 第一次会提示输入密码，输入后回车
4. 窗口里会显示手机访问地址，保持窗口开着
5. 手机开启 Tailscale，浏览器打开 `http://<显示的IP>:4096`
6. 用户名 `opencode`，密码是第 3 步输入的密码

## 密码

不想每次输入，可以在同目录建 `password.txt`，内容只写密码（已被 `.gitignore` 忽略，不会提交）。

## 防火墙

首次使用如果手机打不开，在管理员 PowerShell 执行一次：

```powershell
New-NetFirewallRule -DisplayName "OpenCode Web 4096" -Direction Inbound -Protocol TCP -LocalPort 4096 -Action Allow
```

## 常见问题

- `ServeError`：已有实例占用 4096，直接用旧窗口，或先关掉旧实例
- 手机打不开：确认 Tailscale 开关已打开、电脑在线、防火墙已放行
- 想换项目目录：把脚本放到目标文件夹运行，`cd /d "%~dp0"` 会以脚本所在目录作为项目

## 安全

- 不要把密码提交到仓库
- 服务监听 `0.0.0.0`，只应在可信网络 / Tailscale tailnet 内使用
- 不需要时关掉窗口，服务即停止
