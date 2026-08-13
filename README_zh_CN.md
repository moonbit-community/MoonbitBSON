# 📦 MoonBitBSON: MoonBit 轻量级 BSON 编/解码库

[English](https://github.com/moonbit-community/MoonBitBSON/blob/main/README.md) | [简体中文](https://github.com/moonbit-community/MoonBitBSON/blob/main/README_zh_CN.md)

[![Build Status](https://img.shields.io/github/actions/workflow/status/moonbit-community/MoonBitBSON/bsonlite-ci.yml)](https://github.com/moonbit-community/MoonBitBSON/actions)
[![License](https://img.shields.io/github/license/moonbit-community/MoonBitBSON)](LICENSE)

**MoonBitBSON** 是一个基于 MoonBit 言语的轻量级 BSON 工具库，支持基础类型的 BSON 编码和解码，包括字符串、整数、布尔、数组、字典等。库设计简洁，调用简单，适合学习、工程实验和辅助转换等场景。

---

## 🚀 功能特性

* 支持 BSON 核心类型：Double、String、Int32、Int64、Bool、Document、Array
* 封装类 Rust-like 的 `BsonValue` 进行类型表示
* 支持嵌套文档和数组编解码
* 用户可维护字典、数组接口进行结构
* 简洁编/解码 API，自动处理结构长度
* 已分类编码错误，类型无效、缺少结束符、无效长度等均有包括
* 提供完备测试样例

---

## 📆 安装方式

```bash
moon add moonbit-community/MoonbitBSON
```

或编辑 `moon.mod`：

```moonbit
import {
  "moonbit-community/MoonbitBSON",
}
```


## 🧭 支持的 BSON 类型

| 枚举成员       | 负载类型                     | 备注   |
| ---------- | ------------------------ | ---- |
| `Double`   | `Double`                 | 0x01 |
| `String`   | `String`                 | 0x02 |
| `Document` | `Map[String, BsonValue]` | 0x03 |
| `Array`    | `Array[BsonValue]`       | 0x04 |
| `Boolean`  | `Bool`                   | 0x08 |
| `Null`     | `-`                      | 0x0A |
| `Int32`    | `Int`                    | 0x10 |
| `Int64`    | `Int64`                  | 0x12 |

> **未覆盖**：Binary、ObjectId、UTC datetime、Regex、Timestamp、Decimal128 等扩展类型当前未实现。

## 🚀 快速上手

### 构造 → 编码 → 解码

```moonbit
use moonbit-community/MoonbitBSON

let user = bson_document()
  .set("name", bson_string("Ada"))
  .set("age",  bson_int32(30))
  .set("tags", bson_array().push(bson_string("engineer")).push(bson_string("math")))

let bin  = to_bson(user)           // 编码为 Bytes
let back = from_bson(bin)          // 从 Bytes 解码回 BsonValue

assert(back.is_document())
assert(back.as_document().unwrap().get("age").unwrap().as_int32().unwrap() == 30)
```

### Safe 变体（不会抛错）

```moonbit
let bin  = to_bson_safe(user)      // 出错时返回空 Bytes
let back = from_bson_safe(bin)     // 出错时返回 BsonValue::Null
```

## 🔧 API 参考（完整曝光）

### 🏗 构造函数（Builders）

| 函数              | 签名                                 | 说明                         |
| --------------- | ---------------------------------- | -------------------------- |
| `bson_array`    | `bson_array() -> BsonValue`        | 创建一个空的 BSON 数组（Array）。     |
| `bson_bool`     | `bson_bool(Bool) -> BsonValue`     | 用布尔值创建 BSON Boolean 值。     |
| `bson_document` | `bson_document() -> BsonValue`     | 创建一个空的 BSON 文档（Document）。  |
| `bson_double`   | `bson_double(Double) -> BsonValue` | 用 64 位浮点数创建 BSON Double 值。 |
| `bson_int32`    | `bson_int32(Int) -> BsonValue`     | 用 32 位整型创建 BSON Int32 值。   |
| `bson_int64`    | `bson_int64(Int64) -> BsonValue`   | 用 64 位整型创建 BSON Int64 值。   |
| `bson_null`     | `bson_null() -> BsonValue`         | 创建 BSON Null 值。            |
| `bson_string`   | `bson_string(String) -> BsonValue` | 用给定字符串创建 BSON String 值。    |

### 📤 顶层编解码（Top-level Encode/Decode）

| 函数               | 签名                                      | 说明                                          |
| ---------------- | --------------------------------------- | ------------------------------------------- |
| `decode_bson`    | `decode_bson(Bytes) -> BsonValue raise BsonError` | 从 `Bytes` 解码出一个 `BsonValue`（顶层应为 Document）。 |
| `encode_bson`    | `encode_bson(BsonValue) -> Bytes raise BsonError` | 将一个 *Document* 作为顶层对象编码为 `Bytes`。           |
| `from_bson`      | `from_bson(Bytes) -> BsonValue raise BsonError`   | 便捷解码封装（内部调用 `decode_bson`）。                 |
| `from_bson_safe` | `from_bson_safe(Bytes) -> BsonValue`    | 安全解码封装：失败时返回 `BsonValue::Null`。             |
| `to_bson`        | `to_bson(BsonValue) -> Bytes raise BsonError`     | 便捷编码封装（内部调用 `encode_bson`）。                 |
| `to_bson_safe`   | `to_bson_safe(BsonValue) -> Bytes`      | 安全编码封装：失败时返回空 `Bytes`。                      |

### 🧱 `BsonValue` 方法

| 方法                       | 签名                                                   | 说明                                          |
| ------------------------ | ---------------------------------------------------- | ------------------------------------------- |
| `BsonValue::as_array`    | `BsonValue::as_array(Self) -> Array[Self]?`          | 如果是 Array，返回元素数组；否则返回 None。                 |
| `BsonValue::as_document` | `BsonValue::as_document(Self) -> Map[String, Self]?` | 如果是 Document，返回 Map；否则返回 None。              |
| `BsonValue::as_int32`    | `BsonValue::as_int32(Self) -> Int?`                  | 如果是 Int32，返回 Int；否则返回 None。                 |
| `BsonValue::as_int64`    | `BsonValue::as_int64(Self) -> Int64?`                | 如果是 Int64，返回 Int64；否则返回 None。               |
| `BsonValue::as_string`   | `BsonValue::as_string(Self) -> String?`              | 如果是 String，返回 String；否则返回 None。             |
| `BsonValue::is_array`    | `BsonValue::is_array(Self) -> Bool`                  | 是否为 Array。                                  |
| `BsonValue::is_document` | `BsonValue::is_document(Self) -> Bool`               | 是否为 Document。                               |
| `BsonValue::is_int`      | `BsonValue::is_int(Self) -> Bool`                    | 是否为整型（Int32/Int64）。                         |
| `BsonValue::is_string`   | `BsonValue::is_string(Self) -> Bool`                 | 是否为 String。                                 |
| `BsonValue::push`        | `BsonValue::push(Self, Self) -> Self`                | （仅 Array 有效）追加一个元素并返回修改后的 Array，支持链式调用。     |
| `BsonValue::set`         | `BsonValue::set(Self, String, Self) -> Self`         | （仅 Document 有效）设置字段并返回修改后的 Document，支持链式调用。 |

### ⚠️ 错误类型

`BsonError`（子错误枚举 `suberror`）可能在编/解码时被抛出：

| 成员                      | 负载       |
| ----------------------- | -------- |
| `InvalidString`         | `String` |
| `UnsupportedType`       | `Byte`   |
| `InvalidUtf8`           | `String` |
| `InvalidDocumentLength` | `String` |
| `InvalidStringLength`   | `String` |

### 🧭 常用操作示例

```moonbit
// 构造数组并读取
let arr = bson_array().push(bson_int32(1)).push(bson_int32(2))
assert(arr.is_array())
let xs = arr.as_array().unwrap()
assert(xs.length() == 2)

// 文档嵌套
let profile = bson_document()
  .set("name", bson_string("Grace"))
  .set("likes", arr)
```

## ❗ 已知限制

* 仅实现了上表列出的 BSON 类型，暂未覆盖 Binary、ObjectId 等扩展类型。

## 🧪 测试

见 `src/bson_test.mbt`，可根据 MoonBit 的测试命令运行。

## 📜 版权

本项目基于 Apache-2.0 许可证发布。详见 LICENSE。
