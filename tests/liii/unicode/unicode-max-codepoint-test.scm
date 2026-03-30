(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; unicode-max-codepoint
;; Unicode 最大有效码点常量。
;;
;; 语法
;; ----
;; unicode-max-codepoint
;;
;; 返回值
;; ----
;; integer
;; 返回 Unicode 的最大有效码点值 #x10FFFF（十进制 1114111）。
;;
;; 描述
;; ----
;; 根据 Unicode 标准，有效的码点范围是 0 到 #x10FFFF。
;; 这个常量定义了该范围的上限。

;; 基本值测试
(check unicode-max-codepoint => #x10FFFF)
(check unicode-max-codepoint => 1114111)

;; 与边界相关的测试
(check-true (<= #x10FFFF unicode-max-codepoint))
(check-true (< unicode-max-codepoint #x110000))

;; 验证码点范围
(check-true (integer? unicode-max-codepoint))
(check-true (positive? unicode-max-codepoint))

;; 与函数配合使用
(check (codepoint->utf8 unicode-max-codepoint) => #u8(#xF4 #x8F #xBF #xBF))
(check (codepoint->hexstr unicode-max-codepoint) => "10FFFF")

(check-report)
