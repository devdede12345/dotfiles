; extends

((line_comment) @comment.chinese
  (#match? @comment.chinese "[一-龥]")
  (#set! priority 110))

((block_comment) @comment.chinese
  (#match? @comment.chinese "[一-龥]")
  (#set! priority 110))
