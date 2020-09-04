def `\cnode{child1}`child_ai`\cnode{child2}`() do
  IO.`\cnode{annoy1}`puts`\cnode{annoy2}`("Are were there yet?")

  `\cnode{receive1}`receive`\cnode{receive2}` do
    `\cnode{msg1}`:arrived`\cnode{msg2}` -> IO.`\cnode{finally1}`puts`\cnode{finally2}`("Finally!")
  after
    `\cnode{timeout1}`1`\cnode{timeout2}` -> `\cnode{rec1}`child_ai`\cnode{rec2}`()
  end
end

child = `\cnode{spawn1}`spawn`\cnode{spawn2}`(&child_ai/0)
`\cnode{drive1}`drive`\cnode{drive2}`()
`\cnode{send1}`send`\cnode{send2}`(child, :arrived)
