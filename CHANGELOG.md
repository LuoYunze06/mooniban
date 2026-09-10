# 变更日志

## 0.1.0 - 2026-09-10

- 实现 ISO 13616 IBAN 规范化、字符集/长度检查、分块 mod-97 校验和 BBAN 模式匹配。
- 加入 72 个国家的长度、模式和银行/分行/账号切片登记表。
- 支持由国家代码与 BBAN 重建校验位，并输出稳定诊断码 IBAN001–IBAN011。
- 提供 CLI（含 `--file`）、三个可复现验收场景和样例文件。
- 增加 wasm-gc/wasm/js/native 的 CI，以及 readiness、smoke、package_check 脚本。
- 许可证为 Apache-2.0。本工作流不发布到 mooncakes.io。
