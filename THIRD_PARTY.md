# 第三方与规范来源

MoonIBAN 的数据模型、mod-97 实现、国家长度/模式表、CLI 和示例为原项目实现，不是对某一具体 IBAN 库的源码移植。

| 依赖或参考 | 用途 | 许可证与引入方式 |
| --- | --- | --- |
| MoonBit 标准库 `moonbitlang/core` | 字符串、数组、Result 以及 CLI 参数 | Apache-2.0，由工具链提供，不复制源文件 |
| `moonbitlang/x@0.5.4`，https://github.com/moonbitlang/x | 仅 CLI 使用 `fs` 读取样例文件、`sys` 设置退出状态 | Apache-2.0，通过模块清单下载，不提交 `.mooncakes` |
| ISO 13616 / IBAN 公开结构 | 重排、mod-97、国家长度和 BBAN `n/a/c` 模式的公开标识事实 | 规范文本本身不是源代码；本仓库独立编码这些事实，不复制 SWIFT IBAN Registry 出版物 |
| `actions/checkout`、`actions/setup-python` | CI 运行基础设施 | MIT，由 GitHub runner 使用，不进发布包 |

根库只依赖 core。CLI 才使用文件系统。native 目标可能链接工具链 C stub，不能把“能 check native”说成“本机已跑通 native 运行时”。示例 IBAN 均为公开样例，不是真实客户数据。

未使用其他项目的源代码。相邻项目只用于查重比较，见 `docs/competition/duplicate-check.md`。选择 Apache-2.0 不改变依赖许可证。
