(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; utf8->utf16le
;; 将 UTF-8 编码的字节向量转换为 UTF-16LE 编码的字节向量。
;;
;; 语法
;; ----
;; (utf8->utf16le bytevector)
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-8 编码的字节向量。
;;
;; 返回值
;; ----
;; bytevector
;; UTF-16LE 编码的字节向量。
;;
;; 错误处理
;; ----
;; value-error 当字节向量包含无效的 UTF-8 编码序列时。
;; type-error 当参数不是字节向量时。

;; ASCII 字符
(check (utf8->utf16le #u8(#x48)) => #u8(#x48 #x00))
(check (utf8->utf16le #u8(#x48 #x65 #x6C #x6C #x6F)) => #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00))

;; 2 字节 UTF-8 -> 2 字节 UTF-16LE
(check (utf8->utf16le #u8(#xC3 #xA4)) => #u8(#xE4 #x00))

;; 3 字节 UTF-8 -> 2 字节 UTF-16LE
(check (utf8->utf16le #u8(#xE4 #xB8 #xAD)) => #u8(#x2D #x4E))

;; 4 字节 UTF-8 -> 4 字节 UTF-16LE（代理对）
(check (utf8->utf16le #u8(#xF0 #x9F #x91 #x8D)) => #u8(#x3D #xD8 #x4D #xDC))
(check (utf8->utf16le #u8(#xF0 #x9F #x9A #x80)) => #u8(#x3D #xD8 #x80 #xDE))

;; 空字节向量
(check (utf8->utf16le #u8()) => #u8())

;; 与 utf16le->utf8 互逆操作
(check (utf8->utf16le (utf16le->utf8 #u8(#x48 #x00))) => #u8(#x48 #x00))
(check (utf8->utf16le (utf16le->utf8 #u8(#x2D #x4E))) => #u8(#x2D #x4E))
(check (utf8->utf16le (utf16le->utf8 #u8(#x3D #xD8 #x4D #xDC))) => #u8(#x3D #xD8 #x4D #xDC))

;; 错误处理
(check-catch 'value-error (utf8->utf16le #u8(#xFF)))
(check-catch 'type-error (utf8->utf16le "not-a-bytevector"))

(check-report)
