# MoonIBAN 验收证据

更新日期：2026-09-30

| 验收项 | 项目证据 |
| --- | --- |
| MoonBit 为主要语言，`moonc >= 0.10.14` | 核心库、CLI、示例与 22 项测试均为 MoonBit；`.moonbit-version` 固定 `0.10.14+7d59c7ec9`，`scripts/check_toolchain.py` 在本地和 CI 强制最低版本。 |
| GitHub 公开、历史清晰 | 公开仓库 `LuoYunze06/mooniban`；按模型、算法、登记表、CLI、测试、文档和验收基线分阶段提交。 |
| 结构清晰、核心功能可用 | 根包实现规范化、国家长度/BBAN 模式、mod-97、字段拆分、校验位重建和诊断；`cmd/mooniban` 提供七个命令。 |
| README 可复现 | `README.md` 包含目标、环境要求、安装、命令、API 和三个带输入/结果的场景。 |
| CI 覆盖检查/构建/测试 | `.github/workflows/ci.yml` 调用 `scripts/readiness.py`，覆盖 wasm-gc、wasm、js、native 的 check/build/test、CLI 冒烟和示例。 |
| 可运行示例 | `examples/api-demo` 连续验证结账拆字段、英国 BBAN 重建和 checksum 拒绝；`examples/sample-ibans.txt` 验证文件输入。 |
| 完整测试 | 22 项 MoonBit 测试覆盖公开样例、72 国登记表往返、构建/解析、边界、错误码与命令分发；Python 测试覆盖工具链与包审计。 |
| MoonCakes | `LuoYunze06/mooniban@0.1.0` 已发布；本次源代码版本为 0.1.1，后续 MoonCakes 发布由维护者手动执行。 |
| OSI 开源许可证 | 根目录 `LICENSE` 为 Apache-2.0；`THIRD_PARTY.md` 记录依赖和公开规范参考，没有移植第三方源码。 |

## 一键工程验收

```sh
moon update
python scripts/readiness.py
```

没有本地 C 编译器时可用 `--skip-native-runtime` 做其余本地检查；这只记录 native 运行阶段被跳过，不能替代 CI 的 native 结果。`scripts/package_check.py` 只生成并审计 MoonCakes ZIP，不登录也不发布。
