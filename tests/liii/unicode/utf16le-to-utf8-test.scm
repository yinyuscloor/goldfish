(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; utf16le->utf8
;; 将 UTF-16LE 编码的字节向量转换为 UTF-8 编码的字节向量。
;;
;; 语法
;; ----
;; (utf16le->utf8 bytevector)
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-16LE 编码的字节向量。
;;
;; 返回值
;; ----
;; bytevector
;; UTF-8 编码的字节向量。
;;
;; 错误处理
;; ----
;; value-error 当字节向量包含无效的 UTF-16LE 编码序列时。
;; type-error 当参数不是字节向量时。

;; ASCII 字符（2 字节 UTF-16LE -> 1 字节 UTF-8）
(check (utf16le->utf8 #u8(#x48 #x00)) => #u8(#x48))
(check (utf16le->utf8 #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00)) => #u8(#x48 #x65 #x6C #x6C #x6F))

;; BMP 字符（2 字节 UTF-16LE -> 2-3 字节 UTF-8）
(check (utf16le->utf8 #u8(#xE4 #x00)) => #u8(#xC3 #xA4))
(check (utf16le->utf8 #u8(#x2D #x4E)) => #u8(#xE4 #xB8 #xAD))

;; 代理对（4 字节 UTF-16LE -> 4 字节 UTF-8）
(check (utf16le->utf8 #u8(#x3D #xD8 #x4D #xDC)) => #u8(#xF0 #x9F #x91 #x8D))
(check (utf16le->utf8 #u8(#x3D #xD8 #x80 #xDE)) => #u8(#xF0 #x9F #x9A #x80))

;; 空字节向量
(check (utf16le->utf8 #u8()) => #u8())

;; 与 utf8->utf16le 互逆操作
(check (utf16le->utf8 (utf8->utf16le #u8(#x48))) => #u8(#x48))
(check (utf16le->utf8 (utf8->utf16le #u8(#xE4 #xB8 #xAD))) => #u8(#xE4 #xB8 #xAD))
(check (utf16le->utf8 (utf8->utf16le #u8(#xF0 #x9F #x91 #x8D))) => #u8(#xF0 #x9F #x91 #x8D))

;; 错误处理
(check-catch 'value-error (utf16le->utf8 #u8(#x00)))
(check-catch 'value-error (utf16le->utf8 #u8(#x00 #xD8)))
(check-catch 'type-error (utf16le->utf8 "not-a-bytevector"))

(check-report)
