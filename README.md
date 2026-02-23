# skyland_auto_checkin 森空岛自动签到

***适用于青龙面板的森空岛统一签到脚本（支持同时签到 `明日方舟` 和 `终末地`）***

![Python](https://img.shields.io/badge/Python-3.7+-blue?logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-青龙面板-blue?logo=linux)

---

**原项目**：
- https://github.com/sjtt2/endfield_auto_sign
- https://github.com/Zerolouis/skyland_auto_sign_qinglong
- https://gitee.com/FancyCabbage/skyland-auto-sign

---

## 重构优化

此版本在原项目的基础上进行了全面重构，主要改进如下：

### 代码合并重构
- 合并 [终末地签到](https://github.com/sjtt2/endfield_auto_sign) 和 [森空岛签到](https://github.com/Zerolouis/skyland_auto_sign_qinglong) 的代码逻辑
- 使用 `GAME_CONFIG` 字典配置不同游戏，方便后续扩展，实现统一签到入口
- 目前支持同时为明日方舟和终末地进行签到

### 代码结构优化
- 模块化设计，职责分离
- 规范函数命名，避免歧义

### 全局变量重构
- 创建 `SkylandCheckin` 核心类封装所有状态和方法
- `run_message` 和 `sign_token` 全局变量改为实例属性

### 环境变量封装
- 创建 `Config` 数据类封装环境变量获取逻辑
- 使用 `Config.from_env()` 方法统一加载环境变量
- 配置获取逻辑集中管理，便于后续扩展

### HTTP 重试机制
- 添加 `create_session()` 函数，复用 HTTP 会话连接
- 配置重试机制，针对 500/502/503/504 状态码自动重试
- 提高网络请求稳定性

### 签到结果格式化
- 改进输出格式，使用固定宽度和制表符对齐
- 中文字符宽度智能计算（中文宽度为 2，英文为 1）
- 日志输出更整齐美观（~绝不是强迫症的原因~）

---

## 获取 Token

1. 登录 [森空岛](https://www.skland.com/)

2. 登录成功后再访问：https://web-api.skland.com/account/info/hg

    接口会返回如下数据：

    ```json
    {
        "code": 0,
        "data": {
            "content": "token"
        },
        "msg": "接口会返回您的鹰角网络通行证账号的登录凭证，此凭证可以用于鹰角网络账号系统校验您登录的有效性。泄露登录凭证属于极度危险操作，为了您的账号安全，请勿将此凭证以任何形式告知他人！"
    }
    ```

    其中 `data.content` 中的字符串即为 `token`

## 使用

### 在青龙面板中运行

1. **依赖安装**

    脚本运行需要 `requests` 库，若运行报错，请在青龙面板进行如下操作：
    1. 进入 `依赖管理` -> `Python3`
    2. 点击 `创建依赖`
    3. `名称` 输入 `requests` 并点击确定

2. 添加环境变量 *（支持多账号）*

    名称: `SKYLAND_TOKEN`

    值: `token1;token2;token3;`

    如果需要配置多个账号，请在 `SKYLAND_TOKEN` 环境变量中使用 `;` 分隔多个 `token`

3. 青龙面板创建订阅

    链接: `https://github.com/devnakx/skyland_auto_checkin.git`

    分支: `main`

    白名单: `main.py`

    定时规则: `4 5 * * *`

4. 运行订阅

5. 脚本默认定时 `31 8 * * *`，即每天上午 8:31 运行

### 在 Linux 中独立运行（使用 `crontab` 配置定时任务）

1. 克隆项目到本地并进入项目文件夹：

    ```sh
    git clone https://github.com/devnakx/skyland_auto_checkin.git
    cd skyland_auto_checkin
    ```

2. 创建虚拟环境并安装依赖库：

    1. 若系统未安装 `python3-venv`，请先安装（以 Debian/Ubuntu 为例）：

    ```sh
    sudo apt install python3-venv
    ```

    2. 创建虚拟环境并激活：

    ```bash
    python3 -m venv venv && source venv/bin/activate
    ```

    3. 安装依赖：

    ```sh
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    ```

3. 配置 Token：

    1. `nano task.sh` 编辑任务脚本
    2. 修改 `SKYLAND_TOKEN` 环境变量，将 `token1;token2;token3;` 替换为实际的 `token`
    3. 完成后按 `Ctrl+X` 保存并退出

4. 添加任务脚本执行权限并手动测试运行：

    ```sh
    chmod +x task.sh && ./task.sh
    ```

    ~没有报错就算成功~

5. 确认运行正常后再配置定时任务：

    `crontab -e`，添加如下内容：

    ```sh
    31 8 * * * /bin/bash /path/to/skyland_auto_checkin/task.sh
    ```

    其中 `/path/to/skyland_auto_checkin` 请替换为实际项目路径

### 在 Windows 中独立运行（使用 `任务计划程序` 配置定时任务）

1. 下载安装 Python

    https://www.python.org/ftp/python/3.14.3/python-3.14.3-amd64.exe

    安装中一定要勾选添加环境变量

    <img width="664" height="426" alt="image" src="https://github.com/user-attachments/assets/59235f0c-796b-41c7-abdf-eaad652e017e" />

2. 下载完整源码文件

    <img width="415" height="364" alt="image" src="https://github.com/user-attachments/assets/e406501c-477d-49c2-91fd-3826bfab20ad" />

3. 解压压缩包中的 `main.py`、`requirements.txt`、`task.bat`

4. 在解压后的文件夹打开终端，并安装依赖

    在文件夹路径输入 `cmd`，回车，即可打开

    <img width="704" height="233" alt="image" src="https://github.com/user-attachments/assets/6ee0024f-efd0-4865-aa76-3b1181def6a9" />

    输入命令进行依赖安装

    ```cmd
    pip install -r requirements.txt
    ```

    等待依赖安装完成

5. 编辑 `task.bat`，填写 `token`

    修改 `SKYLAND_TOKEN` 环境变量，将**引号**内 `token1;token2;token3;` 替换为实际的 `token`

    <img width="753" height="419" alt="image" src="https://github.com/user-attachments/assets/4be53f9e-8979-464a-bf1b-bd4d2f33d157" />

    <img width="476" height="354" alt="image" src="https://github.com/user-attachments/assets/fa1c9149-99d8-47aa-867b-a7b7c94a9865" />

6. 手动执行一次确保 `token` 配置正确

    在刚才安装依赖的 cmd 窗口执行

    ```cmd
    .\task.bat
    ```

    看到提示账号签到成功即可

7. 配置任务计划

    1. 在开始菜单搜索 `任务计划程序`，打开

        <img width="781" height="783" alt="image" src="https://github.com/user-attachments/assets/b35a542f-c77b-4fa0-94c1-520bb766b8f1" />

    2. 在右侧选择新建任务

        <img width="394" height="297" alt="image" src="https://github.com/user-attachments/assets/163d5fd0-8674-4e49-81e1-caba4d0744cc" />

    3. 常规

        <img width="632" height="540" alt="image" src="https://github.com/user-attachments/assets/6bc81879-bb1c-42d4-9437-a9dc50ec0dfb" />

    4. 触发器，选择新建，根据自己想要执行的时间进行配置

        <img width="877" height="536" alt="image" src="https://github.com/user-attachments/assets/fdd07472-8ffe-466b-a7b7-f5ee45efb756" />

    5.  操作，选择新建，然后浏览，选择自己前边解压出来的 `task.bat`

        <img width="1034" height="508" alt="image" src="https://github.com/user-attachments/assets/aa54c17e-76da-4c9c-bb9d-b5cae95e4dd6" />

    6. 点击确定进行保存，在弹出的框中输入电脑开机密码，授予权限

> [!TIP]
> 使用计划任务运行需要保证电脑处于开机状态，建议部署到 Windows 服务器或自己平时不关机的二奶机

### 接入 MAA 或 MaaEnd，在每日前进行自动签到

1. 完成上述 Windows 部署的 1-6 步

2. 打开 MAA 或 MaaEnd，两个配置一个即可，不需要重复配置

    #### MaaEnd

    在你设置的每日任务最前边添加前置程序即可

    <img width="1002" height="620" alt="image" src="https://github.com/user-attachments/assets/38f08daf-5340-43a9-af1b-78fe4dafcb21" />

    <img width="1107" height="356" alt="image" src="https://github.com/user-attachments/assets/1b02acd1-bb32-4cfd-b623-6f3bc262561d" />

    #### MAA

    在设置-运行设置-开始前脚本，填写 `task.bat` 的路径（若不知道怎么填写，可对着 `task.bat` 文件右键，选择复制文件路径，填入）

    <img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/8ba2bdb8-768e-40d3-b54d-76eaf8edb7c3" />

> [!TIP]
> 独立运行时不支持下面青龙面板的通知推送功能

## 通知推送（可选）

适配了青龙面板的多平台推送

1. **在青龙面板添加环境变量**

    名称：`SKYLAND_NOTIFY`

    值：`true`（该值为空或其它值时均禁用推送）

2. **配置推送渠道**

    在青龙面板 `配置文件` 中的 `config.sh` 中填入相对应的推送 API 的环境变量即可

### 支持的推送方式

以下内容在青龙面板的 `config.sh` 中配置，不需要自己创建环境变量

| 推送方式 | 需要配置的环境变量 |
| :--- | :--- |
| **Server 酱** | `PUSH_KEY` |
| **Bark (iOS)** | `BARK_PUSH` |
| **Telegram** | `TG_BOT_TOKEN`, `TG_USER_ID` |
| **钉钉机器人** | `DD_BOT_TOKEN`, `DD_BOT_SECRET` |
| **企业微信机器人** | `QYWX_KEY` |
| **企业微信应用** | `QYWX_AM` |
| **iGot 聚合** | `IGOT_PUSH_KEY` |
| **Push Plus** | `PUSH_PLUS_TOKEN` |
| **微加机器人** | `WE_PLUS_BOT_TOKEN` |
| **go-cqhttp** | `GOBOT_URL`, `GOBOT_TOKEN` |
| **Gotify** | `GOTIFY_URL`, `GOTIFY_TOKEN` |
| **PushDeer** | `DEER_KEY` |
| **Synology Chat** | `CHAT_URL`, `CHAT_TOKEN` |
| **智能微秘书** | `AIBOTK_KEY` |
| **CHRONOCAT** | `CHRONOCAT_URL`, `CHRONOCAT_TOKEN` |
| **SMTP 邮件** | `SMTP_SERVER`, `SMTP_EMAIL`, `SMTP_PASSWORD` |
| **PushMe** | `PUSHME_KEY` |
| **飞书机器人** | `FSKEY` |
| **Qmsg 酱** | `QMSG_KEY` |
| **Ntfy** | `NTFY_TOPIC`, `NTFY_URL` |
| **wxPusher** | `WXPUSHER_APP_TOKEN`, `WXPUSHER_UIDS` |
| **自定义 Webhook** | `WEBHOOK_URL`, `WEBHOOK_METHOD` |

未充分测试，如有问题请反馈

> [!TIP]
> 详细的变量名称和推送方式支持，请直接参考 `config.sh`
