(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; bytevector-utf16be-advance
;; 从指定字节位置前进到下一个 UTF-16BE 字符的起始位置。
;;
;; 语法
;; ----
;; (bytevector-utf16be-advance bytevector index [end])
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-16BE 编码的字节向量。
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
;; 下一个 UTF-16BE 字符的起始字节位置；如果遇到无效序列则返回当前位置。

;; ASCII 字符测试（2字节编码）
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F) 0) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F) 2) => 4)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F) 4) => 6)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F) 6) => 8)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C #x00 #x6C #x00 #x6F) 8) => 10)

;; 基本多文种平面字符测试（2字节编码）
(check (bytevector-utf16be-advance #u8(#x00 #xE4 #x00 #x48) 0) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #xE9 #x00 #x65) 0) => 2)
(check (bytevector-utf16be-advance #u8(#x4E #x2D #x00 #x48) 0) => 2)

;; 辅助平面字符测试（4字节编码，代理对）
(check (bytevector-utf16be-advance #u8(#xD8 #x3D #xDC #x4D #x00 #x48) 0) => 4)
(check (bytevector-utf16be-advance #u8(#xD8 #x3D #xDE #x80 #x00 #x65) 0) => 4)
(check (bytevector-utf16be-advance #u8(#xD8 #x3C #xDF #x89 #x00 #x6C) 0) => 4)

;; 混合字符序列测试
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #xE4 #x4E #x2D #xD8 #x3D #xDC #x4D) 0) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #xE4 #x4E #x2D #xD8 #x3D #xDC #x4D) 2) => 4)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #xE4 #x4E #x2D #xD8 #x3D #xDC #x4D) 4) => 6)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #xE4 #x4E #x2D #xD8 #x3D #xDC #x4D) 6) => 10)

;; 边界条件测试
(check (bytevector-utf16be-advance #u8() 0) => 0)
(check (bytevector-utf16be-advance #u8(#x00 #x48) 0) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #x48) 2) => 2)

;; 无效 UTF-16BE 序列测试
(check (bytevector-utf16be-advance #u8(#x00) 0) => 0)
(check (bytevector-utf16be-advance #u8(#xD8 #x3D) 0) => 0)
(check (bytevector-utf16be-advance #u8(#xD8 #x3D #xDC) 0) => 0)
(check (bytevector-utf16be-advance #u8(#xDC #x00 #x00 #x00) 0) => 0)
(check (bytevector-utf16be-advance #u8(#xD8 #x3D #x00 #x00) 0) => 0)

;; 结束位置参数测试
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C) 0 2) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #x48 #x00 #x65 #x00 #x6C) 0 4) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #xE4 #x00 #x48) 0 2) => 2)
(check (bytevector-utf16be-advance #u8(#x00 #xE4 #x00 #x48) 0 4) => 2)

(check-report)
