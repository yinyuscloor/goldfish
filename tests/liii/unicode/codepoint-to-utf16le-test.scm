(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; codepoint->utf16le
;; 将 Unicode 码点转换为 UTF-16LE 编码的字节向量。
;;
;; 语法
;; ----
;; (codepoint->utf16le codepoint)
;;
;; 参数
;; ----
;; codepoint : integer
;; Unicode 码点（0 到 #x10FFFF）。
;;
;; 返回值
;; ----
;; bytevector
;; UTF-16LE 编码的字节向量。
;;
;; 描述
;; ----
;; 编码规则：
;; - U+0000 到 U+FFFF: 2 字节编码（小端序）
;; - U+10000 到 U+10FFFF: 4 字节编码（代理对，小端序）
;;
;; 错误处理
;; ----
;; value-error 当码点超出 Unicode 范围或处于代理区时。
;; type-error 当参数不是整数时。

;; 基本 BMP 字符（2 字节）
(check (codepoint->utf16le #x0048) => #u8(#x48 #x00))
(check (codepoint->utf16le #x0041) => #u8(#x41 #x00))
(check (codepoint->utf16le #x00A4) => #u8(#xA4 #x00))
(check (codepoint->utf16le #x4E2D) => #u8(#x2D #x4E))

;; 边界测试
(check (codepoint->utf16le #x0000) => #u8(#x00 #x00))
(check (codepoint->utf16le #xFFFF) => #u8(#xFF #xFF))

;; 代理区外字符（4 字节）
(check (codepoint->utf16le #x1F44D) => #u8(#x3D #xD8 #x4D #xDC))
(check (codepoint->utf16le #x1F680) => #u8(#x3D #xD8 #x80 #xDE))
(check (codepoint->utf16le #x10000) => #u8(#x00 #xD8 #x00 #xDC))
(check (codepoint->utf16le #x10FFFF) => #u8(#xFF #xDB #xFF #xDF))

;; 与 utf16le->codepoint 互逆操作
(check (utf16le->codepoint (codepoint->utf16le #x0048)) => #x0048)
(check (utf16le->codepoint (codepoint->utf16le #x4E2D)) => #x4E2D)
(check (utf16le->codepoint (codepoint->utf16le #x1F44D)) => #x1F44D)
(check (utf16le->codepoint (codepoint->utf16le #x10FFFF)) => #x10FFFF)

;; 错误处理
(check-catch 'value-error (codepoint->utf16le -1))
(check-catch 'value-error (codepoint->utf16le #x110000))
(check-catch 'value-error (codepoint->utf16le #xD800))
(check-catch 'value-error (codepoint->utf16le #xDFFF))
(check-catch 'type-error (codepoint->utf16le "not-an-integer"))

(check-report)
