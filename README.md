# MacHelpdesk

把原本要找 IT 處理的 Mac 問題交給 agent：網路怪怪的慢、印表機找不到、換地方要重新設定。

每個工具都照同一個順序做事：先量測，再判讀，最後才動手。量不到的就說量不到，不猜。

這個 repo 是 MacHelpdesk 的入口：Claude Code plugin marketplace 的索引，加上整個系列共用的規則。每個工具有自己的 repo。

## 工具

| 工具 | 做什麼 | 形式 |
|---|---|---|
| [`mac-printer-setup`](https://github.com/MacHelpdesk/mac-printer-setup) | 連不到網路印表機時，找出它在網路的哪一層並修好佇列；依目前連得到哪台印表機自動切換預設印表機 | Claude Code plugin、bash 腳本 |
| [`mac-network-test`](https://github.com/MacHelpdesk/mac-network-test) | 網路瓶頸診斷：慢在 Wi-Fi、閘道還是上游；是被限速還是被塞住 | Swift CLI |
| [`mac-trackpad-test`](https://github.com/MacHelpdesk/mac-trackpad-test) | 觸控板檢測：死區、點按、Force Touch、捲動、手勢 | Swift |

## 安裝 plugin

```bash
/plugin marketplace add MacHelpdesk/mac-helpdesk
/plugin install mac-printer-setup@mac-helpdesk
```

目前透過 marketplace 安裝的只有 `mac-printer-setup`。另外兩個工具照各自 repo 的 README 編譯使用。

## 結構

```
mac-helpdesk/                          # 這個 repo
├── .claude-plugin/marketplace.json    # 索引：每個 plugin 指向該工具 repo 的 plugin/ 子目錄
├── scripts/clone-tools.sh             # 把所有工具 repo clone 進 tools/
└── tools/                             # 各工具的 repo（這個 repo 不追蹤 tools/）
    ├── mac-printer-setup/
    ├── mac-network-test/
    └── mac-trackpad-test/
```

要一次拿到整個系列的原始碼：

```bash
git clone https://github.com/MacHelpdesk/mac-helpdesk.git
cd mac-helpdesk
scripts/clone-tools.sh
```

每個工具 repo 用同一個形狀：根目錄放說明、測試與原始碼，`plugin/` 放被安裝進 Claude Code 的部分。

## 你自己的資料放哪裡

這些工具量到的和設定的，都是你的環境：位址、網段、Wi-Fi 名稱、裝置序號、量測的時間地點。公開的 repo 只放方法與工具，不放這些。

你自己的設定與紀錄放在 `~/.config/<工具>/`，例如 `~/.config/mac-printer-setup/`，不放在任何 repo 的資料夾裡。想留修改紀錄，就在那個資料夾 `git init`，只留在本機就好；紀錄重做不出來、丟了會可惜時，才推到你個人的 private repo。

回報問題時，先把位址換成 `192.0.2.x` 這類範例位址，拿掉 Wi-Fi 名稱與序號。

## 回報問題

問題回報到對應工具的 repo。跨工具的事（共同規則、marketplace 索引）回報到這裡。

## License

MIT
