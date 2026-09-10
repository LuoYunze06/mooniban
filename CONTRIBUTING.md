# 贡献指南

当前维护者：**LuoYunze06**。

1. 先说明要改的 IBAN 行为及对应公开样例；不要把活账户查询、SWIFT 报文或支付发起混进本仓库。
2. 功能和对应回归测试作为一次完整提交。禁止为凑提交数拆无意义改动。
3. 执行 `python scripts/readiness.py`。本机缺少 C 编译器时使用 `--skip-native-runtime`，并查看 CI 的 native 结果。
4. 修改公开 API 后运行 `moon info`，核对接口差异，并更新 README、示例、边界说明和变更日志。
5. 不要提交 `_build`、`.mooncakes`、凭证文件、私人联系方式和申报书。只使用当前仓库的 Git 配置，不要改全局 `user.name` / `user.email`。
6. 提交作者必须能映射到实际使用的 GitHub 账号 LuoYunze06。

许可证为 Apache-2.0。新增依赖或参考来源必须同步 THIRD_PARTY.md，并保持实际许可证一致。
