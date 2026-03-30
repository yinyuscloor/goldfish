(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; string->utf8
;; 将字符串转换为 UTF-8 编码的字节向量。
;;
;; 语法
;; ----
;; (string->utf8 string [start [end]])
;;
;; 参数
;; ----
;; string : string
;; 要转换的字符串。
;;
;; start : integer (可选，默认 0)
;; 起始字符位置（基于字符计数）。
;;
;; end : integer (可选，默认字符串末尾)
;; 结束字符位置（基于字符计数）。
;;
;; 返回值
;; ----
;; bytevector
;; 包含 UTF-8 编码字节的字节向量。
;;
;; 错误处理
;; ----
;; out-of-range 当 start 或 end 超出字符串范围时。

;; 基本 ASCII 测试
(check (string->utf8 "Hello") => (bytevector #x48 #x65 #x6C #x6C #x6F))
(check (string->utf8 "") => #u8())

;; 多字节字符测试
(check (string->utf8 "ä") => #u8(#xC3 #xA4))
(check (string->utf8 "中") => #u8(#xE4 #xB8 #xAD))
(check (string->utf8 "👍") => #u8(#xF0 #x9F #x91 #x8D))
(check (string->utf8 "🚀") => #u8(#xF0 #x9F #x9A #x80))
(check (string->utf8 "🎉") => #u8(#xF0 #x9F #x8E #x89))

;; 混合字符测试
(check (string->utf8 "Hello 🚀 World") => #u8(#x48 #x65 #x6C #x6C #x6F #x20 #xF0 #x9F #x9A #x80 #x20 #x57 #x6F #x72 #x6C #x64))
(check (string->utf8 "你好 🎉 测试") => #u8(#xE4 #xBD #xA0 #xE5 #xA5 #xBD #x20 #xF0 #x9F #x8E #x89 #x20 #xE6 #xB5 #x8B #xE8 #xAF #x95))

;; 带 start 和 end 参数的测试
(check (string->utf8 "Hello" 0 0) => #u8())
(check (string->utf8 "Hello" 1 1) => #u8())
(check (string->utf8 "Hello" 2 3) => #u8(#x6C))
(check (string->utf8 "Hello" 3 5) => #u8(#x6C #x6F))
(check (string->utf8 "Hello" 2) => #u8(#x6C #x6C #x6F))
(check (string->utf8 "Hello" 0 3) => #u8(#x48 #x65 #x6C))

;; Unicode 字符范围测试
(check (string->utf8 "汉") => #u8(#xE6 #xB1 #x89))
(check (string->utf8 "字") => #u8(#xE5 #xAD #x97))

;; 错误处理测试
(check-catch 'out-of-range (string->utf8 "Hello" 2 6))
(check-catch 'out-of-range (string->utf8 "汉字书写" 4))

;; 与 utf8->string 互逆操作验证
(check (utf8->string (string->utf8 "Hello" 1 2)) => "e")
(check (utf8->string (string->utf8 "Hello" 0 2)) => "He")
(check (utf8->string (string->utf8 "Hello" 2)) => "llo")
(check (utf8->string (string->utf8 "Hello" 2 5)) => "llo")

(check-report)
