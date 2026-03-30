(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; bytevector-advance-utf8
;; 从指定字节位置前进到下一个 UTF-8 字符的起始位置。
;;
;; 语法
;; ----
;; (bytevector-advance-utf8 bytevector index [end])
;;
;; 参数
;; ----
;; bytevector : bytevector
;; UTF-8 编码的字节向量。
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
;; 下一个 UTF-8 字符的起始字节位置；如果遇到无效序列则返回当前位置。

;; ASCII 字符测试（1字节编码）
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 0) => 1)
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 1) => 2)
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 2) => 3)
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 3) => 4)
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 4) => 5)

;; 基本多文种平面字符测试（2字节编码）
(check (bytevector-advance-utf8 #u8(#xC3 #xA4 #x48) 0) => 2)
(check (bytevector-advance-utf8 #u8(#xC3 #xA9 #x65) 0) => 2)
(check (bytevector-advance-utf8 #u8(#xC3 #xB6 #x6C) 0) => 2)

;; BMP 字符测试（3字节编码，中文）
(check (bytevector-advance-utf8 #u8(#xE4 #xB8 #xAD #x48) 0) => 3)
(check (bytevector-advance-utf8 #u8(#xE6 #xB1 #x89 #x65) 0) => 3)
(check (bytevector-advance-utf8 #u8(#xE5 #xAD #x97 #x6C) 0) => 3)

;; 辅助平面字符测试（4字节编码，表情符号）
(check (bytevector-advance-utf8 #u8(#xF0 #x9F #x91 #x8D #x48) 0) => 4)
(check (bytevector-advance-utf8 #u8(#xF0 #x9F #x9A #x80 #x65) 0) => 4)
(check (bytevector-advance-utf8 #u8(#xF0 #x9F #x8E #x89 #x6C) 0) => 4)

;; 混合字符序列测试
(check (bytevector-advance-utf8 #u8(#x48 #xC3 #xA4 #xE4 #xB8 #xAD #xF0 #x9F #x91 #x8D) 0) => 1)
(check (bytevector-advance-utf8 #u8(#x48 #xC3 #xA4 #xE4 #xB8 #xAD #xF0 #x9F #x91 #x8D) 1) => 3)
(check (bytevector-advance-utf8 #u8(#x48 #xC3 #xA4 #xE4 #xB8 #xAD #xF0 #x9F #x91 #x8D) 3) => 6)
(check (bytevector-advance-utf8 #u8(#x48 #xC3 #xA4 #xE4 #xB8 #xAD #xF0 #x9F #x91 #x8D) 6) => 10)

;; 边界条件测试
(check (bytevector-advance-utf8 #u8() 0) => 0)
(check (bytevector-advance-utf8 #u8(#x48) 0) => 1)
(check (bytevector-advance-utf8 #u8(#x48) 1) => 1)

;; 无效 UTF-8 序列测试
(check (bytevector-advance-utf8 #u8(#x80) 0) => 0)
(check (bytevector-advance-utf8 #u8(#xC2) 0) => 0)
(check (bytevector-advance-utf8 #u8(#xE4 #xB8) 0) => 0)
(check (bytevector-advance-utf8 #u8(#xF0 #x9F #x91) 0) => 0)
(check (bytevector-advance-utf8 #u8(#xFF) 0) => 0)

;; 无效延续字节测试
(check (bytevector-advance-utf8 #u8(#xC2 #x00) 0) => 0)
(check (bytevector-advance-utf8 #u8(#xE4 #x00 #xAD) 0) => 0)
(check (bytevector-advance-utf8 #u8(#xF0 #x9F #x00 #x8D) 0) => 0)

;; 结束位置参数测试
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 0 1) => 1)
(check (bytevector-advance-utf8 #u8(#x48 #x65 #x6C #x6C #x6F) 0 2) => 1)
(check (bytevector-advance-utf8 #u8(#xC3 #xA4 #x48) 0 2) => 2)
(check (bytevector-advance-utf8 #u8(#xC3 #xA4 #x48) 0 3) => 2)

(check-report)
