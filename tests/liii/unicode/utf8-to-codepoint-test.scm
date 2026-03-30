(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; utf8->codepoint
;; 将 UTF-8 编码的字节向量转换为 Unicode 码点。
;;
;; 语法
;; ----
;; (utf8->codepoint bytevector)
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-8 编码的字节向量。
;;
;; 返回值
;; ----
;; integer
;; Unicode 码点。
;;
;; 错误处理
;; ----
;; value-error 当字节向量为空或包含无效的 UTF-8 编码序列时。
;; type-error 当参数不是字节向量时。

;; 1 字节编码
(check (utf8->codepoint #u8(#x48)) => #x48)
(check (utf8->codepoint #u8(#x00)) => #x00)
(check (utf8->codepoint #u8(#x7F)) => #x7F)

;; 2 字节编码
(check (utf8->codepoint #u8(#xC2 #xA4)) => #xA4)
(check (utf8->codepoint #u8(#xC2 #x80)) => #x80)
(check (utf8->codepoint #u8(#xDF #xBF)) => #x7FF)

;; 3 字节编码
(check (utf8->codepoint #u8(#xE4 #xB8 #xAD)) => #x4E2D)
(check (utf8->codepoint #u8(#xE0 #xA0 #x80)) => #x800)
(check (utf8->codepoint #u8(#xEF #xBF #xBF)) => #xFFFF)

;; 4 字节编码
(check (utf8->codepoint #u8(#xF0 #x9F #x91 #x8D)) => #x1F44D)
(check (utf8->codepoint #u8(#xF0 #x90 #x80 #x80)) => #x10000)
(check (utf8->codepoint #u8(#xF4 #x8F #xBF #xBF)) => #x10FFFF)

;; 常见字符
(check (utf8->codepoint #u8(#xF0 #x9F #x9A #x80)) => #x1F680)
(check (utf8->codepoint #u8(#xF0 #x9F #x8E #x89)) => #x1F389)

;; 与 codepoint->utf8 互逆操作
(check (utf8->codepoint (codepoint->utf8 #x48)) => #x48)
(check (utf8->codepoint (codepoint->utf8 #x4E2D)) => #x4E2D)
(check (utf8->codepoint (codepoint->utf8 #x1F44D)) => #x1F44D)
(check (utf8->codepoint (codepoint->utf8 #x10FFFF)) => #x10FFFF)

;; 错误处理
(check-catch 'value-error (utf8->codepoint #u8()))
(check-catch 'value-error (utf8->codepoint #u8(#x80)))
(check-catch 'value-error (utf8->codepoint #u8(#xC0 #x80)))
(check-catch 'type-error (utf8->codepoint "not-a-bytevector"))
(check-catch 'type-error (utf8->codepoint 123))

(check-report)
