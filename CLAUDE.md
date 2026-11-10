# CLAUDE.md

MacHelpdesk 的 umbrella repo：Claude Code plugin marketplace 的索引，加上整個系列共用的規則。工具本身各有自己的 repo。

## 目錄

```
mac-helpdesk/
├── .claude-plugin/marketplace.json   # 索引，marketplace 名稱是 mac-helpdesk
├── scripts/clone-tools.sh            # clone 所有工具 repo 到 tools/
├── README.md、CLAUDE.md、SECURITY.md、LICENSE
└── tools/                            # 各工具 repo 的本機 clone，這個 repo 用 .gitignore 忽略
```

`tools/<工具>/` 是獨立的 git repo（或指向別處 clone 的捷徑）。在這個 repo 裡 `git status` 看不到它們的變動；要改某個工具，進它的目錄，照它自己的 CLAUDE.md 做，commit 也在那裡。

## 個人的設定與紀錄：`~/.config/<工具>/`

這個系列的工具量到的、設定的，都是某個人的環境：位址、網段、Wi-Fi 名稱、裝置的序號與 UUID、量測的時間與地點。公開 repo 只放方法與工具。**公開 repo 要保持乾淨，前提是私人的內容有固定的地方放。** 那個地方是 `~/.config/<工具>/`，例如 `~/.config/mac-printer-setup/`。

- 不放在這個專案或任何工具 repo 的目錄樹裡。工具裝的背景程式會讀那裡的設定檔，專案資料夾怎麼搬都不該影響它；私人內容不在公開 repo 的目錄樹裡，也比靠 `.gitignore` 擋更保險。
- 開發者和一般使用者用同一個位置。一般使用者不會 clone 這個 repo。
- 裡面放工具的設定檔，以及 `records/`（一次量測或一次設定變更一個檔案，檔名 `YYYY-MM-DDTHHMM±HHMM_<地點>.md`）。
- 要留修改紀錄，就在那個資料夾 `git init`。預設只留本機、不加 remote。只有紀錄重做不出來、丟了會可惜時，才推到個人帳號的 private repo，不推到這個 organization。
- 公開 repo 的文件、測試、issue 要引用那裡的內容時，先拿掉所有識別資訊，改用規則 1 列的範例位址與佔位名稱。
- 在公開 repo 工作時讀到的實際輸出（位址、佇列、量測結果）要留存，就寫進 `~/.config/<工具>/records/`，不寫進公開 repo 的任何檔案，也不貼進 issue。

## 每個工具 repo 的形狀

```
<工具>/
├── plugin/                     # 被安裝進 Claude Code 的部分
│   ├── .claude-plugin/plugin.json
│   ├── skills/<skill>/SKILL.md
│   └── scripts/
├── tests/
├── README.md、CLAUDE.md、CHANGELOG.md、LICENSE
└── Package.swift、Sources/     # 只有 Swift 工具有
```

根目錄給人看與開發用，`plugin/` 以外的檔案不會被安裝。還沒有 plugin 的工具（目前的 `mac-network-test`、`mac-trackpad-test`）沒有 `plugin/`，也不列進索引。

## 索引怎麼寫

`marketplace.json` 的每個 plugin 用 `git-subdir` 來源指向工具 repo 的 `plugin/`：

```json
{
  "name": "<工具>",
  "description": "…",
  "source": { "source": "git-subdir", "url": "https://github.com/MacHelpdesk/<工具>.git", "path": "plugin" },
  "category": "productivity"
}
```

- 索引不寫 `version`。版本只在工具 repo 的 `plugin/.claude-plugin/plugin.json`，寫兩處就會不同步。
- `description` 與工具 repo 的 `plugin.json` 相同；工具那邊改了，這裡跟著改。
- 改完跑 `claude plugin validate .`。

## 整個系列共用的四條規則

1. **公開 repo，不寫任何人的環境。** 位址、Wi-Fi 名稱、裝置序號與 UUID、帳號、本機路徑都不進任何檔案。範例位址只用 RFC 5737 的 `192.0.2.x`、`198.51.100.x`、`203.0.113.x`。使用者自己的設定與紀錄放在 `~/.config/<工具>/`（見上一節），不放在任何 repo 的目錄樹裡，也不放進 `tools/`。
2. **只寫實測過的行為。** 每個工具的文件分清楚「已實測」與「未驗證」，並寫出實測的 macOS 版本。改了程式就重測，沒測的不要標成已實測。
3. **量測與判讀可以直接做，會改設定的動作要寫明界線。** 每個 skill 用封閉列舉寫出：哪些直接做、哪些先問、哪些不做。不要寫一句總括的判準再補例子。
4. **腳本維持 macOS 內建 `/bin/bash` 3.2 相容**，並且不解析會跟著系統語言改變的文字輸出；要取名稱或數值時，找不受語言影響的來源。

## Git 流程（這個 repo 與每個工具 repo 都一樣）

**分支**

- 長期存在的分支只有 `main`，永遠是可發布狀態。
- 工作在短分支 `idd/<issue 編號>-<簡述>`，開 PR，squash merge。`main` 上一個 issue 一個 commit。
- `main` 禁止 force push 與刪除，要求線性歷史。

**版本與發布（工具 repo）**

- 版本只寫在 `plugin/.claude-plugin/plugin.json`。
- 發布是同一個 PR 裡的三件事：bump version、更新 `CHANGELOG.md`、合併後在 `main` 打 tag `vX.Y.Z`。
- Claude Code 只在版本字串改變時給使用者新的內容。改了 `plugin/` 卻沒 bump，已安裝的人拿不到，新安裝的人卻會拿到掛著舊版號的新內容。工具的 CI 會擋這種 PR。

**索引追 `main`，不釘版本**

- `marketplace.json` 的來源不寫 `ref`，所以使用者拿到的是工具 repo `main` 的最新版本。
- 要改成釘版本的時機，只有這兩種：某個工具開始有不認識的外部使用者；或要做破壞性改動、想分批放出。做法是在該工具的來源加 `"ref": "vX.Y.Z"`，之後每次發布多一個這裡的 commit。

**commit 訊息**

- Conventional Commits：`feat:`、`fix:`、`docs:`、`test:`、`chore:`、`refactor:`、`ci:`。
- issue 編號放在標題結尾 `(#N)`，或內文寫 `Refs #N`。不寫會讓 GitHub 自動關閉 issue 的字眼加編號。

**issue**

- 問題開在對應工具的 repo。
- 一件事牽涉兩個以上的工具時，在這個 repo 開一張 `Tracking: <目標>` 的 issue，列出各工具的子 issue，並在每張子 issue 留言指回來。

**每個工具的 CI**

五項，缺一不可：`/bin/bash -n`、測試、manifest 是合法 JSON、隱私字串檢查、PR 上的版本檢查。跑在 macOS 機器上，因為要驗的是系統內建的 bash 3.2。新工具從 `mac-printer-setup` 複製 `.github/workflows/ci.yml` 與 `scripts/check-*.sh` 再調整。

## 新增工具

1. 在 MacHelpdesk 建立 `mac-<功能>` repo，照上面的形狀放檔案。
2. 在 `scripts/clone-tools.sh` 的清單加一行。
3. 在 `README.md` 的工具表加一列。
4. 工具有 `plugin/` 時，在 `marketplace.json` 加一筆，並確認 `claude plugin validate .` 通過。
5. 照 `SECURITY.md` 的基線設定新 repo。
6. 工具會產生或讀取個人的設定與紀錄時，一律用 `~/.config/<工具>/`，在工具的 `.gitignore` 擋掉那些檔名，並在 README 寫明「這個 repo 只放方法與工具」。
