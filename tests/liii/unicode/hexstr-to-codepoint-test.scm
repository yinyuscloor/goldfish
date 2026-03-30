(import (liii check)
        (liii unicode)
        (liii base)
) ;import

(check-set-mode! 'report-failed)

;; hexstr->codepoint
;; 将十六进制字符串转换为 Unicode 码点。
;;
;; 语法
;; ----
;; (hexstr->codepoint hexstr)
;;
;; 参数
;; ----
;; hexstr : string
;; 十六进制字符串（纯十六进制，不含 "0x" 或 "U+" 前缀，如 "48"、"4E2D"、"1F44D"）。
;;
;; 返回值
;; ----
;; integer
;; Unicode 码点。
;;
;; 描述
;; ----
;; 解析纯十六进制字符串为 Unicode 码点值。
;; 输入应为纯十六进制数字，不包含任何前缀。
;;
;; 错误处理
;; ----
;; value-error 当字符串为空、格式无效或码点超出范围时。
;; type-error 当参数不是字符串时。

;; 基本 ASCII 字符
(check (hexstr->codepoint "48") => #x48)
(check (hexstr->codepoint "65") => #x65)
(check (hexstr->codepoint "6C") => #x6C)

;; 带前导零的十六进制字符串
(check (hexstr->codepoint "0048") => #x48)
(check (hexstr->codepoint "0041") => #x41)
(check (hexstr->codepoint "007A") => #x7A)

;; 中文字符
(check (hexstr->codepoint "4E2D") => #x4E2D)
(check (hexstr->codepoint "6587") => #x6587)

;; 表情符号（辅助平面字符）
(check (hexstr->codepoint "1F44D") => #x1F44D)
(check (hexstr->codepoint "1F680") => #x1F680)
(check (hexstr->codepoint "1F389") => #x1F389)

;; 边界值
(check (hexstr->codepoint "0") => #x0)
(check (hexstr->codepoint "10FFFF") => #x10FFFF)

;; 小写字母
(check (hexstr->codepoint "48") => #x48)
(check (hexstr->codepoint "4e2d") => #x4E2D)

;; 与 codepoint->hexstr 互逆操作
(check (hexstr->codepoint (codepoint->hexstr #x48)) => #x48)
(check (hexstr->codepoint (codepoint->hexstr #x4E2D)) => #x4E2D)
(check (hexstr->codepoint (codepoint->hexstr #x1F44D)) => #x1F44D)

;; 错误处理
(check-catch 'value-error (hexstr->codepoint ""))
(check-catch 'value-error (hexstr->codepoint "110000"))
(check-catch 'value-error (hexstr->codepoint "not-hex"))
(check-catch 'type-error (hexstr->codepoint 123))

(check-report)
