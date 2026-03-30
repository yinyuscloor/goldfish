(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; utf16be->codepoint
;; 将 UTF-16BE 编码的字节向量转换为 Unicode 码点。
;;
;; 语法
;; ----
;; (utf16be->codepoint bytevector)
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-16BE 编码的字节向量。
;;
;; 返回值
;; ----
;; integer
;; Unicode 码点。
;;
;; 描述
;; ----
;; 解码规则：
;; - 2 字节：直接解码为 BMP 字符
;; - 4 字节：解析代理对，解码为辅助平面字符
;;
;; 错误处理
;; ----
;; value-error 当字节向量无效时。
;; type-error 当参数不是字节向量时。

;; 基本 BMP 字符（2 字节）
(check (utf16be->codepoint #u8(#x00 #x48)) => #x0048)
(check (utf16be->codepoint #u8(#x00 #x41)) => #x0041)
(check (utf16be->codepoint #u8(#x00 #xA4)) => #x00A4)
(check (utf16be->codepoint #u8(#x4E #x2D)) => #x4E2D)

;; 边界测试
(check (utf16be->codepoint #u8(#x00 #x00)) => #x0000)
(check (utf16be->codepoint #u8(#xFF #xFF)) => #xFFFF)

;; 代理对（4 字节）
(check (utf16be->codepoint #u8(#xD8 #x3D #xDC #x4D)) => #x1F44D)
(check (utf16be->codepoint #u8(#xD8 #x3D #xDE #x80)) => #x1F680)
(check (utf16be->codepoint #u8(#xD8 #x00 #xDC #x00)) => #x10000)
(check (utf16be->codepoint #u8(#xDB #xFF #xDF #xFF)) => #x10FFFF)

;; 与 codepoint->utf16be 互逆操作
(check (utf16be->codepoint (codepoint->utf16be #x0048)) => #x0048)
(check (utf16be->codepoint (codepoint->utf16be #x4E2D)) => #x4E2D)
(check (utf16be->codepoint (codepoint->utf16be #x1F44D)) => #x1F44D)
(check (utf16be->codepoint (codepoint->utf16be #x10FFFF)) => #x10FFFF)

;; 错误处理
(check-catch 'value-error (utf16be->codepoint #u8()))
(check-catch 'value-error (utf16be->codepoint #u8(#x00)))
(check-catch 'value-error (utf16be->codepoint #u8(#xD8 #x00)))
(check-catch 'value-error (utf16be->codepoint #u8(#xDC #x00 #xDC #x00)))
(check-catch 'type-error (utf16be->codepoint "not-a-bytevector"))
(check-catch 'type-error (utf16be->codepoint 123))

(check-report)
