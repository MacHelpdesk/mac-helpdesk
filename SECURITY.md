# Security

## 回報弱點

請用 GitHub 的私下回報功能：到受影響的工具 repo → Security → Report a vulnerability。不要開公開的 issue。

這些工具會在使用者的 Mac 上讀取網路狀態、修改列印設定、安裝 launchd agent。下列情況都算弱點：工具做了文件沒寫的改動、把使用者環境的資訊送出本機、或讓別人能藉由它執行指令。

## 每個 repo 的基線

MacHelpdesk 是 free tier 的 organization，新 repo 不會自動套用安全設定。每個公開 repo 建立後要有：

- Secret scanning 與 push protection 開啟
- Dependabot alerts 開啟
- 私下弱點回報（private vulnerability reporting）開啟
- `main` 分支禁止 force push 與刪除

## 這些工具不做的事

- 不蒐集、不上傳使用者的網路位址、Wi-Fi 名稱或裝置識別資訊。
- 不讀取、不要求 Wi-Fi 密碼或其他憑證。
- 掃描只限使用者自己管的私有網段，界線寫在各工具的 skill 裡。
