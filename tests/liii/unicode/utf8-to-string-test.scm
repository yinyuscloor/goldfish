(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; utf8->string
;; 将 UTF-8 编码的字节向量转换为字符串。
;;
;; 语法
;; ----
;; (utf8->string bytevector)
;;
;; 参数
;; ----
;; bytevector : bytevector
;; 包含 UTF-8 编码字节的字节向量。
;;
;; 返回值
;; ----
;; string
;; 转换后的字符串。
;;
;; 错误处理
;; ----
;; value-error 当字节向量包含无效的 UTF-8 编码序列时。
;; type-error 当参数不是字节向量时。

;; 基本 ASCII 测试
(check (utf8->string (bytevector #x48 #x65 #x6C #x6C #x6F)) => "Hello")
(check (utf8->string #u8(#x48)) => "H")
(check (utf8->string #u8(#x48 #x65)) => "He")

;; 空字节向量
(check (utf8->string #u8()) => "")

;; 2 字节 UTF-8 字符 (U+0080 到 U+07FF)
(check (utf8->string #u8(#xC3 #xA4)) => "ä")

;; 3 字节 UTF-8 字符 (U+0800 到 U+FFFF)
(check (utf8->string #u8(#xE4 #xB8 #xAD)) => "中")
(check (utf8->string #u8(#xE6 #xB1 #x89)) => "汉")
(check (utf8->string #u8(#xE5 #xAD #x97)) => "字")

;; 4 字节 UTF-8 字符 (U+10000 到 U+10FFFF)
(check (utf8->string #u8(#xF0 #x9F #x91 #x8D)) => "👍")
(check (utf8->string #u8(#xF0 #x9F #x9A #x80)) => "🚀")
(check (utf8->string #u8(#xF0 #x9F #x8E #x89)) => "🎉")
(check (utf8->string #u8(#xF0 #x9F #x8E #x8A)) => "🎊")

;; 混合字符测试
(check (utf8->string #u8(#xF0 #x9F #x91 #x8D #xF0 #x9F #x9A #x80)) => "👍🚀")
(check (utf8->string #u8(#x48 #x65 #x6C #x6C #x6F #x20 #xF0 #x9F #x9A #x80 #x20 #x57 #x6F #x72 #x6C #x64)) => "Hello 🚀 World")
(check (utf8->string #u8(#xE4 #xBD #xA0 #xE5 #xA5 #xBD #x20 #xF0 #x9F #x8E #x89 #x20 #xE6 #xB5 #x8B #xE8 #xAF #x95)) => "你好 🎉 测试")

;; 错误处理测试
(check-catch 'value-error (utf8->string (bytevector #xFF #x65 #x6C #x6C #x6F)))
(check-catch 'value-error (utf8->string (bytevector #x80)))
(check-catch 'value-error (utf8->string (bytevector #xF8 #x80 #x80 #x80 #x80)))
(check-catch 'value-error (utf8->string (bytevector #xFC #x80 #x80 #x80 #x80 #x80)))

;; 与 string->utf8 互逆操作验证
(check (utf8->string (string->utf8 "")) => "")
(check (utf8->string (string->utf8 "H")) => "H")
(check (utf8->string (string->utf8 "Hello")) => "Hello")
(check (utf8->string (string->utf8 "ä")) => "ä")
(check (utf8->string (string->utf8 "中")) => "中")
(check (utf8->string (string->utf8 "👍")) => "👍")
(check (utf8->string (string->utf8 "汉字书写")) => "汉字书写")
(check (utf8->string (string->utf8 "Hello 你好 👍")) => "Hello 你好 👍")

(check-report)
