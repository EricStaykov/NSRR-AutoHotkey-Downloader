; Written by Eric Staykov (2024)
; Please do not distribute without the license
; Download NSRR files quickly and in parallel from a browser
; Tested using Chrome and AutoHotkey 2.0.11
; After starting this script with AutoHotkey, go into the browser window and press Ctrl + e to open pages and Ctrl + r to start downloads 
; Once started, it can be exited by pressing Ctrl + Esc

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir% 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET VALUES BELOW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET VALUES BELOW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET VALUES BELOW
totalFiles := 2056 ; SET THIS
basePath := "https://sleepdata.org/datasets/mesa/files/polysomnography/annotations-events-profusion" ; SET THIS
fileType := 1 ; SET THIS TO 0 IF FILE TYPE IS .EDF (TO SKIP OVER THE PREVIEW) AND 1 IF SOMETHING ELSE
delay = 100 ; operation-by-operation delay which is in milliseconds. Increase the value if downloading too few files or computer starts slowing down or unable to download files fast enough
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET VALUES ABOVE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET VALUES ABOVE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET VALUES ABOVE

elementsPerPage := 100 ; this should be 100
lastPageElements := Mod(totalFiles, elementsPerPage)
pages := totalFiles/elementsPerPage
if (lastPageElements > 0)
{
	pages++ ; to account for the last page with less elements
}

; Open pages
^e::
	count := 1
	Loop, %pages%
	{
		URL := Format("{1}?page={:d} ", basePath, count) ; need space at the end to defeat suggested previous pages
		OpenPage(delay, URL)
		count++
	}
Return

; Start downloading
^r::
	MsgBox % Format("About to download {:d} files ({:d} pages of {:d} elements with last page {:d} elements) from base path {5}", totalFiles, pages, elementsPerPage, lastPageElements, basePath)
	count := 1
	Loop, %pages%
	{
		MultiClick()
		if ((count == 1) && (lastPageElements > 0))
		{
			elements := lastPageElements
		} else {
			elements := elementsPerPage
		}
		Loop, %elements%
		{
			DownloadFile(delay, fileType)
		}
		PrevPage(delay)
		count++
	}
	MsgBox Finished!
Return

MultiClick() {
	Click, 100, 500 ; this will click in the white space and restart from the first download
	Click, 100, 500
	Click, 100, 500
	Click, 100, 500
	Click, 100, 500
	Click, 100, 500
	Click, 100, 500
	Click, 100, 500
	Click, 100, 500
	Return
}

; Open page
OpenPage(delay, URL) {
	Sleep, delay
	Send {Ctrl t}
	Send, {Ctrl Down}{t Down}{Ctrl Up}{t Up}
	Sleep, delay
	SendInput, %URL%
	Sleep, delay
	Send {Enter}
	Return
}

; Go to previous page/tab
PrevPage(delay) {
	MultiEscape(delay)
	Send {Ctrl Shift Tab}
	Send, {Ctrl Down}{Shift Down}{Tab Down}{Ctrl Up}{Shift Up}{Tab Up}
	Return
}

; Download a single file	
DownloadFile(delay, fileType) {
	MultiEscape(delay)
	Send {Tab}
	if (fileType == 0)
	{
		MultiEscape(delay)
		Send {Tab}
	}
	MultiEscape(delay)
	Send {Ctrl Enter}
	Send, {Ctrl Down}{Enter Down}{Ctrl Up}{Enter Up}
	Return
}

; Needed to hide completed downloads pop up
MultiEscape(delay){
	Sleep, delay
	Send {Esc}
	Send {Esc}
	Send {Esc}
	Send {Esc}
	Send {Esc}
	Send {Esc}
}

^Esc::ExitApp  ; Exit script with Ctrl + Escape
