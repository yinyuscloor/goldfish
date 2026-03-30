(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; codepoint->utf16be
;; 将 Unicode 码点转换为 UTF-16BE 编码的字节向量。
;;
;; 语法
;; ----
;; (codepoint->utf16be codepoint)
;;
;; 参数
;; ----
;; codepoint : integer
;; Unicode 码点（0 到 #x10FFFF）。
;;
;; 返回值
;; ----
;; bytevector
;; UTF-16BE 编码的字节向量。
;;
;; 描述
;; ----
;; 编码规则：
;; - U+0000 到 U+FFFF: 2 字节编码（大端序）
;; - U+10000 到 U+10FFFF: 4 字节编码（代理对，大端序）
;;
;; 错误处理
;; ----
;; value-error 当码点超出 Unicode 范围或处于代理区时。
;; type-error 当参数不是整数时。

;; 基本 BMP 字符（2 字节）
(check (codepoint->utf16be #x0048) => #u8(#x00 #x48))
(check (codepoint->utf16be #x0041) => #u8(#x00 #x41))
(check (codepoint->utf16be #x00A4) => #u8(#x00 #xA4))
(check (codepoint->utf16be #x4E2D) => #u8(#x4E #x2D))

;; 边界测试
(check (codepoint->utf16be #x0000) => #u8(#x00 #x00))
(check (codepoint->utf16be #xFFFF) => #u8(#xFF #xFF))

;; 代理区外字符（4 字节）
(check (codepoint->utf16be #x1F44D) => #u8(#xD8 #x3D #xDC #x4D))
(check (codepoint->utf16be #x1F680) => #u8(#xD8 #x3D #xDE #x80))
(check (codepoint->utf16be #x10000) => #u8(#xD8 #x00 #xDC #x00))
(check (codepoint->utf16be #x10FFFF) => #u8(#xDB #xFF #xDF #xFF))

;; 与 utf16be->codepoint 互逆操作
(check (utf16be->codepoint (codepoint->utf16be #x0048)) => #x0048)
(check (utf16be->codepoint (codepoint->utf16be #x4E2D)) => #x4E2D)
(check (utf16be->codepoint (codepoint->utf16be #x1F44D)) => #x1F44D)
(check (utf16be->codepoint (codepoint->utf16be #x10FFFF)) => #x10FFFF)

;; 错误处理
(check-catch 'value-error (codepoint->utf16be -1))
(check-catch 'value-error (codepoint->utf16be #x110000))
(check-catch 'value-error (codepoint->utf16be #xD800))
(check-catch 'value-error (codepoint->utf16be #xDFFF))
(check-catch 'type-error (codepoint->utf16be "not-an-integer"))

(check-report)
