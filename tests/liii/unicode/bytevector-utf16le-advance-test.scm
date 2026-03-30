(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; bytevector-utf16le-advance
;; 从指定字节位置前进到下一个 UTF-16LE 字符的起始位置。
;;
;; 语法
;; ----
;; (bytevector-utf16le-advance bytevector index [end])
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-16LE 编码的字节向量。
;;
;; index : integer
;; 当前字节位置（起始索引）。
;;
;; end : integer (可选，默认字节向量长度)
;; 字节向量的结束位置。
;;
;; 返回值
;; ----
;; integer
;; 下一个 UTF-16LE 字符的起始字节位置；如果遇到无效序列则返回当前位置。

;; ASCII 字符测试（2字节编码）
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00) 0) => 2)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00) 2) => 4)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00) 4) => 6)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00) 6) => 8)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F #x00) 8) => 10)

;; 基本多文种平面字符测试（2字节编码）
(check (bytevector-utf16le-advance #u8(#xE4 #x00 #x48 #x00) 0) => 2)
(check (bytevector-utf16le-advance #u8(#xE9 #x00 #x65 #x00) 0) => 2)
(check (bytevector-utf16le-advance #u8(#x2D #x4E #x48 #x00) 0) => 2)

;; 辅助平面字符测试（4字节编码，代理对）
(check (bytevector-utf16le-advance #u8(#x3D #xD8 #x4D #xDC #x48 #x00) 0) => 4)
(check (bytevector-utf16le-advance #u8(#x3D #xD8 #x80 #xDE #x65 #x00) 0) => 4)
(check (bytevector-utf16le-advance #u8(#x3C #xD8 #x89 #xDF #x6C #x00) 0) => 4)

;; 混合字符序列测试
(check (bytevector-utf16le-advance #u8(#x48 #x00 #xE4 #x00 #x2D #x4E #x3D #xD8 #x4D #xDC) 0) => 2)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #xE4 #x00 #x2D #x4E #x3D #xD8 #x4D #xDC) 2) => 4)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #xE4 #x00 #x2D #x4E #x3D #xD8 #x4D #xDC) 4) => 6)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #xE4 #x00 #x2D #x4E #x3D #xD8 #x4D #xDC) 6) => 10)

;; 边界条件测试
(check (bytevector-utf16le-advance #u8() 0) => 0)
(check (bytevector-utf16le-advance #u8(#x48 #x00) 0) => 2)
(check (bytevector-utf16le-advance #u8(#x48 #x00) 2) => 2)

;; 无效 UTF-16LE 序列测试
(check (bytevector-utf16le-advance #u8(#x48) 0) => 0)
(check (bytevector-utf16le-advance #u8(#x3D #xD8) 0) => 0)
(check (bytevector-utf16le-advance #u8(#x3D #xD8 #x4D) 0) => 0)
(check (bytevector-utf16le-advance #u8(#x00 #xDC #x00 #x00) 0) => 0)
(check (bytevector-utf16le-advance #u8(#x3D #xD8 #x00 #x00) 0) => 0)

;; 结束位置参数测试
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00) 0 2) => 2)
(check (bytevector-utf16le-advance #u8(#x48 #x00 #x65 #x00 #x6C #x00) 0 4) => 2)
(check (bytevector-utf16le-advance #u8(#xE4 #x00 #x48 #x00) 0 2) => 2)
(check (bytevector-utf16le-advance #u8(#xE4 #x00 #x48 #x00) 0 4) => 2)

(check-report)
