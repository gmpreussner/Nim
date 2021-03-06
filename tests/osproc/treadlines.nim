discard """
  output: '''Error: cannot open 'a.nim'\31
Error: cannot open 'b.nim'\31
'''
  targets: "c"
"""

import osproc

var ps: seq[Process] # compile & run 2 progs in parallel
for prog in ["a", "b"]:
  ps.add startProcess("nim", "",
                      ["r", "--hint[Conf]=off", "--hint[Processing]=off", prog],
                      options = {poUsePath, poDaemon, poStdErrToStdOut})

for p in ps:
  let (lines, exCode) = p.readLines
  if exCode != 0:
    for line in lines: echo line
  p.close
