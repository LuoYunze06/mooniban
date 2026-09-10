# MoonIBAN：ISO 13616 IBAN 规范化、校验与 BBAN 结构检查

**维护者 / 唯一贡献者：LuoYunze06**

MoonIBAN 用 MoonBit 实现国际银行账号（IBAN）的离线识别：去掉空格与连字符、检查字符集和国家长度、按 ISO 13616 做不依赖大整数的 mod-97 校验、按国家 BBAN 的 `n/a/c` 模式核对结构，并拆出银行/分行/账号字段。它面向支付、KYC 和表单校验作者，不是账本、债券定价、SWIFT 报文或银行网关。

```text
紧凑/分组文本 → 字符集与长度 → ISO 13616 重排 mod-97 → BBAN 模式
→ 银行/分行/账号字段、校验位重建、稳定诊断
```

## 安装与首次运行

需要 MoonBit 工具链。CLI 读文件依赖 `moonbitlang/x@0.5.4`，用 `moon update` 下载。验收脚本需要 Python 3。JS 目标需要 Node.js。本机若没有 C 编译器，不要把 native 运行时缺失当成通过。

```sh
git clone https://github.com/LuoYunze06/mooniban.git
cd mooniban
moon update
moon check --target wasm-gc --deny-warn
moon test --target wasm-gc --deny-warn
moon run examples/api-demo --target wasm-gc
```

本地验证工具链为 `moon 0.1.20260713` / `moonc v0.10.4+2cc641edf`。CI 使用 `.moonbit-version` 固定同一编译器。当前未发布到 mooncakes.io；查重完成不等于已经发布。

## 三个可复现使用场景

### 1. 结账页：德国收款账号拆出银行代码

结账系统收到带空格的德国 IBAN `DE89 3704 0044 0532 0130 00`。需要在不调用银行接口的情况下确认它通过 mod-97，并取出 8 位银行代码写入内部账户档案。

```sh
moon run cmd/mooniban -- validate "DE89 3704 0044 0532 0130 00"
# valid DE89 3704 0044 0532 0130 00
moon run cmd/mooniban -- parse "DE89 3704 0044 0532 0130 00"
# valid compact=DE89370400440532013000 pretty=DE89 3704 0044 0532 0130 00 country=DE check=89 bban=370400440532013000 bank=37040044 branch=- account=0532013000
```

库 API 得到 `bank=37040044`、`account=0532013000`。德国没有独立分行字段，`branch` 为空。

### 2. 财务录入：从英国 BBAN 重建校验位

财务人员只拿到国家代码 `GB` 和 BBAN `WEST12345698765432`，需要生成可提交的 IBAN，并按四位分组展示。

```sh
moon run cmd/mooniban -- build GB WEST12345698765432
# GB82 WEST 1234 5698 7654 32
```

`check_digits_for("GB", "WEST12345698765432")` 返回 `82`。若银行代码不是 4 个字母，构建会在 BBAN 模式阶段失败，而不是写出一个“看起来像 IBAN”的字符串。

### 3. 风控抽检：改动过的德国账号被 checksum 拒绝

风控任务把公开样例的校验位从 `89` 改成 `88`，得到 `DE88370400440532013000`。长度和国家模式都还正确，但 ISO 13616 余数不再是 1。

```sh
moon run cmd/mooniban -- validate DE88370400440532013000
# error: IBAN008: ISO 13616 checksum remainder is N, expected 1
moon run cmd/mooniban -- explain DE88370400440532013000
# invalid compact=DE88370400440532013000 IBAN008: ...
```

CLI 对校验失败以状态码 2 退出。`examples/api-demo` 把上述三个场景串成一次验收运行。

批量文件输入读取第一行非注释数据：

```sh
moon run cmd/mooniban -- validate --file examples/sample-ibans.txt
# valid DE89 3704 0044 0532 0130 00
```

## 库 API

在依赖方的 `moon.pkg` 中写入：

```moonbit
import {
  "LuoYunze06/mooniban",
}
```

对外签名以生成的 `pkg.generated.mbti` 为准。

| API | 用途 |
| --- | --- |
| `compact_text` / `pretty_groups` / `Iban::pretty` | 去掉空白与连字符并转大写；按四位分组 |
| `parse` / `validate` | 字符集、15–34 总长、国家长度、BBAN 模式、mod-97 |
| `checksum_remainder` | 只计算 ISO 13616 重排后的余数 |
| `build` / `check_digits_for` | 由国家代码 + BBAN 重建校验位 |
| `Iban::bank` / `branch` / `account` | 按国家登记表切片；无该字段时返回 `None` |
| `explain` / `IbanError::format` | 稳定诊断，错误码 `IBAN001`–`IBAN011` |
| `run_command` | CLI 同款命令，便于嵌入测试 |
| `registered_countries` / `country_spec` | 当前 72 个国家的长度与模式 |

- 校验算法把 IBAN 重排为 BBAN + 国家代码 + 校验位，再按字符分块对 97 取余，不引入大整数库。
- BBAN 模式使用公开的 `n`（数字）、`a`（字母）、`c`（字母或数字）描述，不是 SWIFT IBAN Registry 出版物的复制。
- 根库不依赖 `moonbitlang/x`；只有 CLI 读取本地文件并设置退出码。
- 本项目不查询银行、不发起支付、不验证账户是否真实存在。

## 测试、CI 与范围

```sh
moon test --target wasm-gc --deny-warn
python scripts/smoke.py --target wasm-gc
python scripts/readiness.py --skip-native-runtime
```

CI 在 Ubuntu 上对 wasm-gc、wasm、js、native 做 check/build/test，并运行真实 CLI 与 `examples/api-demo`。许可证为 Apache-2.0。第三方说明见 `THIRD_PARTY.md`，AI 使用见 `AI_USAGE.md`。
