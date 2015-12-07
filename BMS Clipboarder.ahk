^d::
  CopyNotes()
  RunUtility("dist\build\Unmatch\Unmatch.exe")
  Return

^m::
  InputBox script, Move notes, Enter script (a)[z][s][x][d][c][f][v]
  CutNotes()
  RunUtility("dist\build\MoveNotes\MoveNotes.exe """ . script . """")
  Return

^b::
  CutNotes()
  RunUtility("dist\build\BGMize\BGMize.exe")
  Return
CopyNotes()
{
  _PrepareClipboard("Copy")
}

CutNotes()
{
  _PrepareClipboard("Cut")
}

RunUtility(utility)
{
  RunWait %comspec% /c %utility% < input.txt > output.txt, , Min
  FileRead output, *t output.txt
  lines := StrSplit(output, "`n")
  status := lines.RemoveAt(1)
  message := lines.RemoveAt(1)
  If (status = "ok")
  {
    outClipboard := ""
    Loop % lines.MaxIndex()
    {
      outClipboard .= lines[A_Index] . "`r`n"
    }
    Clipboard := outClipboard
    Send ^v
  }
  Else
  {
    MsgBox bms-clipboarder ERROR %status%: %message%
  }
}

_PrepareClipboard(mode)
{
  Clipboard := "!"
  Sleep 100
  If (mode = "Copy")
  {
    Send ^c
  }
  If (mode = "Cut")
  {
    Send ^x
  }
  While Clipboard == "!"
  {
  }
  FileDelete input.txt
  FileAppend %Clipboard%, input.txt, UTF-8-RAW
}
