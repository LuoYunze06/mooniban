# MoonIBAN 示例

## 库验收

`examples/api-demo` 覆盖申报书中的三个可复现场景：

1. 德国收款账号拆出银行代码 `37040044`
2. 英国财务账号从 BBAN 重建校验位 `82`
3. 被改动过的德国 IBAN 被 mod-97 拒绝

```sh
moon run examples/api-demo --target wasm-gc
```

期望输出：

```text
CHECKOUT: compact=DE89370400440532013000 bank=37040044
TREASURY: rebuilt=GB82 WEST 1234 5698 7654 32
RISK: mutated DE IBAN rejected by mod-97
MoonIBAN acceptance: 3 scenarios passed
```

## CLI 与样例文件

`examples/sample-ibans.txt` 的第一行有效数据是德国公开样例。注释行以 `#` 开头，CLI 会跳过。

```sh
moon run cmd/mooniban --target wasm-gc -- validate --file examples/sample-ibans.txt
# valid DE89 3704 0044 0532 0130 00
```
