;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;------------------------------------------------------------------------------------------
#SingleInstance Force
StringCaseSense, On
DetectHiddenWindows, On
global MonitorCount
;------------------------------------------------------------------------------------------
; Admin Check:
;-------------
If IsProcessElevated(DllCall("GetCurrentProcessId")) 
	{
		; MsgBox, Congrats this script is running as admin.
	}
	Else 
		{
			MsgBox, , PrecisionPlanIT.com's Virtual Display Driver: Wizard requires Admin, Note: The wizard needs to be ran as Admin so that install/uninstall/reload of drivers is possible., 5
			; Permissions escalation:
			RequestAdminSelf()
		}

VideoControllers := GetVideoControllers()

Gui, New
GUISetColor("2f1c35", "00f19d")
Gui, Add, Text, xm c00f19d, Kai of Kb.PrecisionPlanIT.com presents: `nVirtual Display Driver: Wizard

Gui, Add, Text, xm c00f19d, Driver:%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
Gui, Add, Button, x+m gDriverInstall, Install
Gui, Add, Button, x+m gDriverUnInstall, Uninstall
Gui, Add, Button, x+m gDriverReload, Reload

Gui, Add, Text, xm c00f19d, Backup:%A_Space%%A_Space%
Gui, Add, ComboBox, x+m yp W153 vBackupFileSel HwndCBBackup, Default||
LoadBackupEntries()
Gui, Add, Button, xp y+m gBackupLoad, Load
Gui, Add, Button, x+m yp gBackupSave, Save

Gui, Add, Text, xm section c00f19d, GPU:%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
Gui, Add, ListBox, ys W153 vRenderingEngine gRenderSelected, %VideoControllers% ;|Nvidia GeForce 1080ti ; For TESTING, add another fake gpu entry

Gui, Add, Text, xs section c00f19d, Monitors:
Gui, Add, Edit, ys W153 vMonitorCount gMonitorCSelect, 
Gui, Add, UpDown, Range1-100,

Gui, Add, Text, xm c00f19d, Available Resolutions:
Gui, Add, Text, xm section c76b57e, Press F2 to set priority for the selection. Enter to submit.`nPressing DELETE will remove an entry.

Gui, Add, ListView, -ReadOnly NoSort R25 AltSubmit vListView_Resolutions gResolutionWasChanged, Priority|Width|Height|Refresh Rate

Gui, Add, Text, xm section c00f19d, Width:
Gui, Add, Edit, xm y+m W75 vResolutionWt, 
Gui, Add, Text, ys section c00f19d, Height:
Gui, Add, Edit, xs y+m W75 vResolutionHt, 
Gui, Add, Text, ys section c00f19d, Refresh/Hz:
Gui, Add, Edit, xs y+m W75 vResolutionHz, 
Gui, Add, Button, xm section c00f19d gAddResolution, Add Resolution

for n, param in A_Args  ; For each parameter:
{
    if n = 1
		Exec_Inte := param
		if n = 2 
			Exec_Args := param
	; Msgbox, % Exec_Inte . Exec_Args
}
if A_Args.Length() = 0
	{
		; MsgBox % "This executable has been launched without arguements."
		Exec_Inte := "GUIs_Adva"
	}
	else if (A_Args.Length() = 1) or (A_Args.Length() = 2)
		{
			; "Driv_Inst/Unin/Relo"
			; "Back_Load/Save/Remo" <filename>
			; "Moni_Sets" <integer>
			; "GPUs_Sets" <String> / or <integer>
			; "Resl_Adds/Remo" %SUNSHINE_CLIENT_WIDTH/HEIGHT/FPS% ; Add has to set to the highest priority.
			; MsgBox % "A command has been executed."
			Gui, Show, Hide, PrPlanIT.com - Virt. Display Drv.: Wiz
		}
		else 
			{
				ExitApp
			}


; MsgBox % LV_GetCount()
If FileExist("C:\IddSampleDriver\vdd_settings.xml")
	{
		ParseOptionsXML()
	}
	Else If FileExist("C:\IddSampleDriver\option.txt")
		{
			ParseOptionsTXT()
			ParseAdapterTXT()
		}
			Else 
				{
					FileCreateDir, C:\IddSampleDriver
					FileCopy, %A_WorkingDir%\vdd_settings.xml, C:\IddSampleDriver\vdd_settings.xml
					FileCopy, %A_WorkingDir%\option.txt, C:\IddSampleDriver\option.txt
					FileCopy, %A_WorkingDir%\adapter.txt, C:\IddSampleDriver\adapter.txt
					If FileExist("C:\IddSampleDriver\vdd_settings.xml")
						ParseOptionsXML()
						Else 
							{
								ParseOptionsTXT()
								ParseAdapterTXT()
							}
				}
SortOutResolutionPriority()
WriteConfig()
; MsgBox, % Exec_Inte
If Exec_Inte = GUIs_Adva
	{
		global InitialLoadIn := 1
		Gui, Show, , PrPlanIT.com - Virt. Display Drv.: Wiz
		Return
	}
	Else If Exec_Inte = Driv_Inst
		{
			; Msgbox, We Are gonna deploy the Driver now!
			DriverInstall()
		}
		Else If Exec_Inte = Driv_Unin
			{
				; Msgbox, We Are gonna uninstall the Driver now!
				DriverUnInstall()
			}
			Else If Exec_Inte = Driv_Relo
				{
					; Msgbox, We Are gonna reload the Driver now!
					DriverReload()
				}
				Else If Exec_Inte = Back_Load
					{
						;Msgbox, % "We Are gonna load a Backup titled " . Exec_Args . " now!"
						ControlGet, BackupFileLst, List,, ComboBox1, PrPlanIT.com - Virt. Display Drv.: Wiz
						BackupDetected := 0
						Loop, Parse, BackupFileLst, `n
						{
							If (A_LoopField = Exec_Args)
								BackupDetected := 1
						}
						If BackupDetected = 1
							{
								GuiControl, ChooseString, BackupFileSel, %Exec_Args%
								Gosub BackupLoad
								; MsgBox, % "The backup requested """ . Exec_Args . """ exists. We loaded the backup."
							}
							Else 
								{
									Msgbox % "Uh-oh, the backup requested """ . Exec_Args . """ does not exist."
								}
					}
					Else If Exec_Inte = Back_Save
						{
							; Msgbox, % "We Are gonna save a Backup titled " . Exec_Args . " now!"
							ControlGet, BackupFileLst, List,, ComboBox1, PrPlanIT.com - Virt. Display Drv.: Wiz
							BackupDetected := 0
							Loop, Parse, BackupFileLst, `n
							{
								If (A_LoopField = Exec_Args)
									BackupDetected := 1
							}
							If BackupDetected = 1
								{
									GuiControl, ChooseString, BackupFileSel, %Exec_Args%
									Gosub BackupSave
									; MsgBox, % "The backup requested """ . Exec_Args . """ exists. We changed the backup."
								}
								Else 
									{
										GuiControl,, BackupFileSel, %Exec_Args%||
										Gosub BackupSave
										; Msgbox % "Uh-oh, the backup requested """ . Exec_Args . """ does not exist."
									}
						}
						Else If Exec_Inte = Back_Remo
							{
								; Msgbox, % "We Are gonna remove the Backup titled " . Exec_Args . " now!"
								ControlGet, BackupFileLst, List,, ComboBox1, PrPlanIT.com - Virt. Display Drv.: Wiz
								BackupDetected := 0
								Loop, Parse, BackupFileLst, `n
								{
									If (A_LoopField = Exec_Args)
										BackupDetected := 1
								}
								If BackupDetected = 1
									{
										GuiControl, ChooseString, BackupFileSel, %Exec_Args%
										Gosub BackupDelete
										; MsgBox, % "The backup requested """ . Exec_Args . """ exists. We deleted the backup."
									}
									Else 
										{
											; Msgbox % "Uh-oh, the backup requested """ . Exec_Args . """ does not exist."
										}
							}
							Else If Exec_Inte = Moni_Sets
								{
									global InitialLoadIn := 1
									GuiControl,, MonitorCount, %Exec_Args%
									GuiControlGet, NewMonitorCount, , MonitorCount
									; Msgbox, %NewMonitorCount%
									Gosub, MonitorCSelect
								}
								Else If Exec_Inte = GPUs_Sets
									{	
										if Exec_Args is integer
											{
												GuiControl, Choose, RenderingEngine, %Exec_Args%
											}
											Else GuiControl, ChooseString, RenderingEngine, %Exec_Args%
										Gosub, RenderSelected
									}
									Else If Exec_Inte = Reso_Adds
										{
											Reso_Found := 0
											Loop, Parse, Exec_Args, `,
												{
													If A_Index = 1
														Reso_Wt := A_LoopField
													If A_Index = 2
														Reso_Ht := A_LoopField
													If A_Index = 3
														Reso_Hz := A_LoopField
												}
											Loop % LV_GetCount()
												{
													LV_GetText(ResolutionWt, A_Index, 2)
													LV_GetText(ResolutionHt, A_Index, 3)
													LV_GetText(ResolutionHz, A_Index, 4)
													IfInString, Exec_Args, % ResolutionWt . "," . ResolutionHt . "," . ResolutionHz
														{
															Reso_Found := 1
															Reso_ID := A_Index
														}
												}
												If (Reso_Found = 0)
														{
															Msgbox, % Reso_Wt . Reso_Ht . Reso_Hz
														}
														Else 
															{
																LV_Delete(Reso_ID)
															}
											LV_Insert(1, "", 1, Reso_Wt, Reso_Ht, Reso_Hz)
											SortOutResolutionPriority()
											WriteConfig()
										}
										Else If Exec_Inte = Reso_Remo
											{
												Loop % LV_GetCount()
													{
														LV_GetText(ResolutionWt, A_Index, 2)
														LV_GetText(ResolutionHt, A_Index, 3)
														LV_GetText(ResolutionHz, A_Index, 4)
														IfInString, Exec_Args, % ResolutionWt . "," . ResolutionHt . "," . ResolutionHz
															{
																Msgbox, Deletion request matched a resolution entry, attempt for deletion.
																LV_Delete(A_Index)
																SortOutResolutionPriority()
																WriteConfig()
															}
													}
												
											}
											Else ExitApp
ExitApp
; %User_Arguements%

RenderSelected:
GuiControlGet, RenderSel, , RenderingEngine
; MsgBox, % RenderSel
WriteConfig()
Return

MonitorCSelect:
GuiControlGet, NewMonitorCount, , MonitorCount
; Msgbox, % NewMonitorCount . MonitorCount
; Msgbox, % BoolProcessing
; Msgbox, % A_EventInfo . A_GUIEvent
If (InitialLoadIn = 1)
	{
		If (NewMonitorCount != MonitorCount)
			{
				; Msgbox, Need to write new monitor count.
				; Gui, Hide
				WriteConfig()
				; Gui, Show, , PrPlanIT.com - Virt. Display Drv.: Wiz
			}
			;Else Msgbox
	}
; MsgBox, InitialLoadIn: %InitialLoadIn%
Return

BackupSave:
GuiControlGet, BackupFileSel, , BackupFileSel
; MsgBox, % BackupFileSel
WriteConfig(BackupFileSel)
Return

BackupLoad:
GuiControlGet, BackupFileSel, , BackupFileSel
LV_Delete()
ConfigXML_Filename := A_WorkingDir . "\Backups\vdd_settings.xml." . BackupFileSel . ".backup"
ConfigAdapter_Filename := A_WorkingDir . "\Backups\adapter.txt." . BackupFileSel . ".backup"
ConfigOptions_Filename := A_WorkingDir . "\Backups\option.txt." . BackupFileSel . ".backup"

If (FileExist(ConfigXML_Filename) = 1)
	{
		; Msgbox, found xml
		ParseOptionsXML(BackupFileSel)
	}
	Else
		{	
			; MsgBox, % BackupFileSel . ConfigAdapter_Filename 
			If FileExist(ConfigAdapter_Filename)
				ParseAdapterTXT(BackupFileSel)
			If FileExist(ConfigOptions_Filename)
				ParseOptionsTXT(BackupFileSel)
		}
SortOutResolutionPriority()
WriteConfig()
Return

BackupDelete:
GuiControlGet, BackupFileSel, , BackupFileSel
ConfigXML_Filename := A_WorkingDir . "\Backups\vdd_settings.xml." . BackupFileSel . ".backup"
ConfigAdapter_Filename := A_WorkingDir . "\Backups\adapter.txt." . BackupFileSel . ".backup"
ConfigOptions_Filename := A_WorkingDir . "\Backups\option.txt." . BackupFileSel . ".backup"
; MsgBox, % BackupFileSel
FileDelete, %ConfigXML_Filename%
FileDelete, %ConfigAdapter_Filename%
FileDelete, %ConfigOptions_Filename%
Return

ResolutionWasChanged:
IfEqual, A_GuiEvent, e
	{
		ResolutionCount := LV_GetCount()
		; MsgBox % "A resolution priority was changed. The focused row number is " . LV_GetNext(0, "Focused")
		LV_GetText(NewResolutionID, LV_GetNext(, "F"), 1)
		LV_GetText(ResolutionWt, LV_GetNext(, "F"), 2)
		LV_GetText(ResolutionHt, LV_GetNext(, "F"), 3)
		LV_GetText(ResolutionHZ, LV_GetNext(, "F"), 4)
		if NewResolutionID between 1 and %ResolutionCount%
			{
				; Msgbox, The user edited a list view item. We will remove row %A_EventInfo%. The entry is for %ResolutionWt%x%ResolutionHt% %ResolutionHz%hz. We will next set the priority to %NewResolutionID% as requested.
				LV_Delete(LV_GetNext(, "F"))
				LV_Insert(NewResolutionID, "", NewResolutionID, ResolutionWt, ResolutionHt, ResolutionHZ)
			}
			Else 
				{
					
					Msgbox, The priority must be between 1 and %ResolutionCount%. Please be mindful. ??
					LV_Modify(LV_GetNext(0, "Focused"), "", LV_GetNext(0, "Focused"), ResolutionWt, ResolutionHt, ResolutionHZ)
				}
		SortOutResolutionPriority()
		WriteConfig()
	}
Else IfEqual, A_GuiEvent, K
	{
		If (A_EventInfo = 46) ; (46 is delete)
			{
				; Msgbox, % "The user pressed delete (Key #" . A_EventInfo . ") while selecting the list view. At Row Number " . LV_GetNext(, "F")
				LV_GetText(ResolutionWt, LV_GetNext(, "F"), 2)
				LV_GetText(ResolutionHt, LV_GetNext(, "F"), 3)
				LV_GetText(ResolutionHZ, LV_GetNext(, "F"), 4)
				MsgBox, 4, Confirm deletion?, % "Are you sure you want to delete " . ResolutionWt . "x" . ResolutionHt . " " . ResolutionHz . "hz?"
				IfMsgBox Yes
					{
						NewResolutionID := LV_GetNext(, "F")
						LV_Delete(NewResolutionID)
						SortOutResolutionPriority()
						WriteConfig()
					}
			}
	}
	
return

GuiClose:
ExitApp

AddResolution:
Gui, Submit, NoHide
LV_Insert(1, "", 1, ResolutionWt, ResolutionHt, ResolutionHz)
SortOutResolutionPriority()
WriteConfig()
Return

DriverInstall:
DriverInstall()
Return

DriverUnInstall:
DriverUnInstall()
Return

DriverReload:
DriverReload()
Return

LoadBackupEntries()
	{
		; MsgBox
		BackupEntries := "Default||"
		Loop, Files, %A_WorkingDir%\Backups\*, RF
			{
				; MsgBox, % A_LoopFileName ; return i.e. adapter.txt.Default.backup
				If InStr(A_LoopFileName, "adapter.txt")
					{
						RegExMatch(A_LoopFileName, "adapter`.txt`.(.+)`.backup", BackupName)
					}
					Else If InStr(A_LoopFileName, "option.txt")
						{
							RegExMatch(A_LoopFileName, "option.txt`.(.+)`.backup", BackupName)
						}
						Else If InStr(A_LoopFileName, "vdd_settings.xml")
							{
								RegExMatch(A_LoopFileName, "vdd_settings`.xml`.(.+)`.backup", BackupName)
							}
				If InStr(BackupEntries, BackupName1)
					continue
					Else 
						{
							BackupEntries := BackupEntries . "`," . BackupName1
							GuiControl, , BackupFileSel, %BackupName1%
						}
				; Msgbox, % BackupName1
			}
	}
	
DriverInstall()
{
	Run, devcon install "%A_WorkingDir%\IddSampleDriver.inf" root\iddsampledriver
}
DriverUnInstall()
{
	Run, devcon /r remove root\iddsampledriver
}
DriverReload()
{
	Run, devcon restart *iddsampledriver
}

CMDtoSTDOut(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99 ¬
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /c " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}

GetVideoControllers() {
	VideoControllerDump := CMDtoSTDOut("wmic path win32_VideoController get name")
	VideoControllers := ""
	Loop, parse, VideoControllerDump, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed. 
	{
        	If (A_LoopField = "")
        		continue
    		IfInString, A_LoopField, Name
        		continue
        	IfInString, A_LoopField, IddSampleDriver
        		continue
        	IfInString, A_LoopField, Microsoft Remote Display Adapter
        		continue
		If (VideoControllers = "")
			VideoControllers := RegExReplace(A_LoopField, "\s+$", "")
		Else 
			VideoControllers := VideoControllers . "|" . RegExReplace(A_LoopField, "\s+$", "")
	}
	return VideoControllers
}


IsProcessElevated(ProcessID)
{
    if !(hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID, "ptr"))
        throw Exception("OpenProcess failed", -1)
    if !(DllCall("advapi32\OpenProcessToken", "ptr", hProcess, "uint", 0x0008, "ptr*", hToken))
        throw Exception("OpenProcessToken failed", -1), DllCall("CloseHandle", "ptr", hProcess)
    if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 20, "uint*", IsElevated, "uint", 4, "uint*", size))
        throw Exception("GetTokenInformation failed", -1), DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
	Sleep, 100
    return IsElevated, DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
			
}
RequestAdminSelf()
{
	if A_IsCompiled
			Run *RunAs "%A_ScriptFullPath%" /restart
		else
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
	Return
}
ParseAdapterTXT(Filename := "")
	{
		If (Filename = "")
			Filename := "C:\IddSampleDriver\adapter.txt"
			Else Filename := A_WorkingDir . "\Backups\adapter.txt." . Filename . ".backup"
		Loop, Read, %Filename%
			{
				RenderEngine := A_LoopReadLine
				GuiControl, ChooseString, RenderingEngine, %RenderEngine%
				break
			}
	}
ParseOptionsTXT(Filename := "") {
	If (Filename = "")
		Filename := "C:\IddSampleDriver\option.txt"
		Else Filename := A_WorkingDir . "\Backups\option.txt." . Filename . ".backup"
	NewResolutionID := 1
	LV_Delete()
	Loop, Read, %Filename%
		If A_LoopReadLine is integer
			{
				MonitorCount := A_LoopReadLine
				GuiControl,, MonitorCount, %MonitorCount%
			}
			Else If (A_LoopReadLine = "")
				continue
				Else {
					Loop, Parse, A_LoopReadLine, `,, %A_Space%
						{
							If (A_Index = 1)
								ResolutionWt := A_LoopField
							If (A_Index = 2)
								ResolutionHt := A_LoopField
							If (A_Index = 3)
								{
									ResolutionHZ := A_LoopField
									LV_Add("", NewResolutionID, ResolutionWt, ResolutionHt, ResolutionHz)
									NewResolutionID := LV_GetCount() + 1
								}
						}
				}
	Return
	
}
ParseOptionsXML(Filename := "") {
	If (Filename = "")
		Filename := "C:\IddSampleDriver\vdd_settings.xml"
		Else Filename := A_WorkingDir . "\Backups\vdd_settings.xml." . Filename . ".backup"
	FileRead, OptionsXML, %Filename%
	; MsgBox % OptionsXML
	RegExMatch(OptionsXML, "<count>(.+)</count>", DisplaysCount)
	MonitorCount := DisplaysCount1
	RegExMatch(OptionsXML, "<friendlyname>(.+)</friendlyname>", RenderEngine)
	GuiControl,, MonitorCount, %MonitorCount%
	GuiControl, ChooseString, RenderingEngine, %RenderEngine1%
	Gui, Submit, NoHide
	; Msgbox % MonitorCount
	; MsgBox % RenderEngine1
	OptionsXML := StrReplace(OptionsXML, "</resolution>", "$")
	NewResolutionID := 1
	LV_Delete()
	Loop, Parse, OptionsXML, $
		{
			RegExMatch(A_LoopField, "<width>(.+)</width>", ResolutionWt)
			RegExMatch(A_LoopField, "<height>(.+)</height>", ResolutionHt)
			ResolutionHz := StrReplace(A_LoopField, "</refresh_rate>", "$")
			Loop, Parse, ResolutionHz, $
				{
						If (RegExMatch(A_LoopField, "<refresh_rate>([0-9]+)$", ResolutionHz))
							{
								; Msgbox, Adding an entry now for %ResolutionWt1%x%ResolutionHt1% %ResolutionHz1%hz
								LV_Add("", NewResolutionID, ResolutionWt1, ResolutionHt1, ResolutionHz1)
								;MsgBox % NewResolutionID . ResolutionWt1 . ResolutionHt1 . ResolutionHz1
								NewResolutionID := LV_GetCount() + 1
							}
				}
		}
	
	Return
	
}
SortOutResolutionPriority()
	{
		; Define resolutions list w x h
		; Determine order of priority for matching w x h resolutions based off first reference to that particular w x h
		Loop % LV_GetCount()
			{
				LV_GetText(ResolutionWt, A_Index, 2)
				LV_GetText(ResolutionHt, A_Index, 3)
				IfNotInString, ResolutionsList, % ResolutionWt . "x" . ResolutionHt
					{
						If (ResolutionsList != "")
							ResolutionsList := ResolutionsList . ","
						ResolutionsList .= ResolutionWt . "x" . ResolutionHt
					}
			}
		; MsgBox % ResolutionsList
		; Iterate the resolution list to set each HZ in the same order
		ParentResolutionWt := ""
		ResolvedPriorityCounter := 1
		Loop, Parse, ResolutionsList, `,
			{
				Loop, Parse, A_LoopField, x
					{
						If (A_Index = 1)
							ParentResolutionWt := A_LoopField
						If (A_Index = 2)
							ParentResolutionHt := A_LoopField
					}
				Loop % LV_GetCount()
					{	
								LV_GetText(ResolutionWt, A_Index, 2)
								LV_GetText(ResolutionHt, A_Index, 3)
								LV_GetText(ResolutionHZ, A_Index, 4)
								If InStr(ParentResolutionWt . "x" . ParentResolutionHt, ResolutionWt . "x" . ResolutionHt)
									{
										LV_Delete(A_Index)
										LV_Insert(ResolvedPriorityCounter, "", ResolvedPriorityCounter, ResolutionWt, ResolutionHt, ResolutionHZ) ; Cant insert the last one cause one before it does not exist :D
										ResolvedPriorityCounter := ResolvedPriorityCounter + 1
										continue
									}
					}
					
			}
			Loop % LV_GetCount() ; Fix screwed sorted stuff by setting the ids over what has been sorted!
				{
				}
		; Sort the listview accordingly to dynamically keep the resolutions linked on changes. A later step should be allowing user to automatically have the selected entry insert in text at the bottom so easily can add more hz. Also perhaps a keystroke for move up down and a remove entry near those controls next to the current highlighted res text
		Return
	}

WriteConfig(Filename := "") 
	{
		BoolProcessing := 1
		FileCreateDir, %A_WorkingDir%\Backups ; Create the backups folder if it doesnt exist as FileAppend can not do such.
		If (Filename = "")
			{
				ConfigAdapter_Filename := "C:\IddSampleDriver\adapter.txt"
				ConfigOptions_Filename := "C:\IddSampleDriver\option.txt"
				ConfigXML_Filename := "C:\IddSampleDriver\vdd_settings.xml"
			}
			Else 
				{
					ConfigAdapter_Filename := A_WorkingDir . "\Backups\adapter.txt." . Filename . ".backup"
					ConfigOptions_Filename := A_WorkingDir . "\Backups\option.txt." . Filename . ".backup"
					ConfigXML_Filename := A_WorkingDir . "\Backups\vdd_settings.xml." . Filename . ".backup"
				}
		GuiControlGet, MonitorCount, , MonitorCount
		GuiControlGet, RenderSel, , RenderingEngine
		WriteConfigXML_Header(MonitorCount, RenderSel)
		WriteConfigCSV_NonResData(MonitorCount, RenderSel)
		MatchedResolution := ""
		Loop % LV_GetCount()
		{
			LV_GetText(ResolutionWt, A_Index, 2)
			LV_GetText(ResolutionHt, A_Index, 3)
			LV_GetText(ResolutionHZ, A_Index, 4)
			WriteConfigCSV_Resolution(ResolutionWt, ResolutionHt, ResolutionHZ)
			If (MatchedResolution = "") ; if its fresh create res entry and move on.
				{
					MatchedResolution := ResolutionWt . "x" . ResolutionHt
					WriteConfigXML_Resolution(ResolutionWt, ResolutionHt)
				}
			If InStr(MatchedResolution, ResolutionWt . "x" . ResolutionHt) ; If matches write a hz entry only.
				{
					WriteConfigXML_Hz(ResolutionHZ)
				}
					Else ; otherwise if it doesnt match close the res off and reset match to create next on next iteration.
						{
							WriteConfigXML_ResEnd()
							WriteConfigXML_Resolution(ResolutionWt, ResolutionHt)
							WriteConfigXML_Hz(ResolutionHZ)
							MatchedResolution := ResolutionWt . "x" . ResolutionHt
						}

		}
		WriteConfigXML_ResEnd()	; The last resolution would not be closed at this time.
		WriteConfigXML_Footer()
		DefaultBackupDetected := 1
		IfNotExist, %A_WorkingDir%\Backups\adapter.txt.Default.backup
			{
				DefaultBackupDetected := 0
				FileCopy, %A_WorkingDir%\Backups\adapter.txt.temp, %A_WorkingDir%\Backups\adapter.txt.Default.backup
			}
		IfNotExist, %A_WorkingDir%\Backups\option.txt.Default.backup
			{
				DefaultBackupDetected := 0
				FileCopy, %A_WorkingDir%\Backups\option.txt.temp, %A_WorkingDir%\Backups\option.txt.Default.backup
			}
		IfNotExist, %A_WorkingDir%\Backups\vdd_settings.xml.Default.backup
			{
				DefaultBackupDetected := 0
				FileCopy, %A_WorkingDir%\Backups\vdd_settings.xml.temp, %A_WorkingDir%\Backups\vdd_settings.xml.Default.backup
			}
		If (DefaultBackupDetected = 0)
			MsgBox, Your Backups folder did not contain a default backup entry. We took the liberty of making you one. From now on make your own backups if you want them.
		; File copy to the ConfigAdapter_Filename ConfigOptions_Filename ConfigXML_Filename entries
		FileCopy, %A_WorkingDir%\Backups\adapter.txt.temp, %ConfigAdapter_Filename%, 1
		FileCopy, %A_WorkingDir%\Backups\option.txt.temp, %ConfigOptions_Filename%, 1
		FileCopy, %A_WorkingDir%\Backups\vdd_settings.xml.temp, %ConfigXML_Filename%, 1
		BoolProcessing := 0
		Return
	}
		
WriteConfigXML_Header(MonitorCount, RenderSel)
	{
		FileDelete, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, <?xml version='1.0' encoding='utf-8'?>`n<vdd_settings>`n%A_Tab%<monitors>`n%A_Tab%%A_Tab% <count>, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, %MonitorCount%, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, </count>`n%A_Tab%</monitors>`n%A_Tab%<gpu>`n%A_Tab%%A_Tab%<friendlyname>, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, %RenderSel%, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, </friendlyname>`n%A_Tab%</gpu>`n%A_Tab% <resolutions>`n, %A_WorkingDir%\Backups\vdd_settings.xml.temp
	}
WriteConfigXML_Resolution(ResolutionWt, ResolutionHt)
	{
		FileAppend, %A_Tab%%A_Tab%<resolution>`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%<width>, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, %ResolutionWt%, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, </width>`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%<height>, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, %ResolutionHt%, %A_WorkingDir%\Backups\vdd_settings.xml.temp
		FileAppend, </height>`n, %A_WorkingDir%\Backups\vdd_settings.xml.temp
	}
WriteConfigXML_Hz(ResolutionHZ)
	{
		FileAppend, %A_Tab%%A_Tab%%A_Tab%%A_Tab%<refresh_rate>%ResolutionHZ%</refresh_rate>`n, %A_WorkingDir%\Backups\vdd_settings.xml.temp
	}
WriteConfigXML_ResEnd()
	{
		FileAppend, %A_Tab%%A_Tab%</resolution>`n, %A_WorkingDir%\Backups\vdd_settings.xml.temp
	}
WriteConfigXML_Footer()
	{
		FileAppend, %A_Tab%</resolutions>`n</vdd_settings>, %A_WorkingDir%\Backups\vdd_settings.xml.temp
	}
WriteConfigCSV_Resolution(ResolutionWt, ResolutionHt, ResolutionHZ)
	{
		FileAppend, %ResolutionWt%`, %ResolutionHt%`, %ResolutionHZ%`n, %A_WorkingDir%\Backups\option.txt.temp
	}
WriteConfigCSV_NonResData(MonitorCount, RenderSel)
	{
		FileDelete, %A_WorkingDir%\Backups\option.txt.temp
		FileDelete, %A_WorkingDir%\Backups\adapter.txt.temp
		FileAppend, %MonitorCount%`n, %A_WorkingDir%\Backups\option.txt.temp
		FileAppend, %RenderSel%, %A_WorkingDir%\Backups\adapter.txt.temp
}
GUISetColor(Window, Control)
	{
		Gui, Color, %Window%, %Control%
	}