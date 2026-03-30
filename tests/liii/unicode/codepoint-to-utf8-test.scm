(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; codepoint->utf8
;; 将 Unicode 码点转换为 UTF-8 编码的字节向量。
;;
;; 语法
;; ----
;; (codepoint->utf8 codepoint)
;;
;; 参数
;; ----
;; codepoint : integer
;; Unicode 码点（0 到 #x10FFFF）。
;;
;; 返回值
;; ----
;; bytevector
;; UTF-8 编码的字节向量。
;;
;; 描述
;; ----
;; 编码规则：
;; - U+0000 到 U+007F: 1 字节编码
;; - U+0080 到 U+07FF: 2 字节编码
;; - U+0800 到 U+FFFF: 3 字节编码
;; - U+10000 到 U+10FFFF: 4 字节编码
;;
;; 错误处理
;; ----
;; value-error 当码点超出 Unicode 范围时。
;; type-error 当参数不是整数时。

;; 1 字节编码 (U+0000 到 U+007F)
(check (codepoint->utf8 #x48) => #u8(#x48))
(check (codepoint->utf8 #x00) => #u8(#x00))
(check (codepoint->utf8 #x7F) => #u8(#x7F))
(check (codepoint->utf8 #x41) => #u8(#x41))

;; 2 字节编码 (U+0080 到 U+07FF)
(check (codepoint->utf8 #xA4) => #u8(#xC2 #xA4))
(check (codepoint->utf8 #x080) => #u8(#xC2 #x80))
(check (codepoint->utf8 #x7FF) => #u8(#xDF #xBF))

;; 3 字节编码 (U+0800 到 U+FFFF)
(check (codepoint->utf8 #x4E2D) => #u8(#xE4 #xB8 #xAD))
(check (codepoint->utf8 #x0800) => #u8(#xE0 #xA0 #x80))
(check (codepoint->utf8 #xFFFF) => #u8(#xEF #xBF #xBF))

;; 4 字节编码 (U+10000 到 U+10FFFF)
(check (codepoint->utf8 #x1F44D) => #u8(#xF0 #x9F #x91 #x8D))
(check (codepoint->utf8 #x10000) => #u8(#xF0 #x90 #x80 #x80))
(check (codepoint->utf8 #x10FFFF) => #u8(#xF4 #x8F #xBF #xBF))

;; 常见字符测试
(check (codepoint->utf8 #x1F680) => #u8(#xF0 #x9F #x9A #x80))
(check (codepoint->utf8 #x1F389) => #u8(#xF0 #x9F #x8E #x89))

;; 与 utf8->codepoint 互逆操作
(check (utf8->codepoint (codepoint->utf8 #x48)) => #x48)
(check (utf8->codepoint (codepoint->utf8 #x4E2D)) => #x4E2D)
(check (utf8->codepoint (codepoint->utf8 #x1F44D)) => #x1F44D)
(check (utf8->codepoint (codepoint->utf8 #x10FFFF)) => #x10FFFF)

;; 错误处理
(check-catch 'value-error (codepoint->utf8 -1))
(check-catch 'value-error (codepoint->utf8 #x110000))
(check-catch 'type-error (codepoint->utf8 "not-an-integer"))
(check-catch 'type-error (codepoint->utf8 #\A))

(check-report)
