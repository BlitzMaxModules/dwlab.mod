'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Rem
bbdoc: Digital Wizard's Lab Framework GUI form constructor module.
End Rem
Module dwlab.forms

ModuleInfo "Version: 1.0.0.1"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

ModuleInfo "History: &nbsp; &nbsp; "
ModuleInfo "History: v1.0.0.1 (28.06.11)"
ModuleInfo "History: &nbsp; &nbsp; Removed variable parameters from Set() and Toggle() methods of LTMenuSwitch class."
ModuleInfo "History: v1.0 (28.06.11)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."

Import brl.eventqueue
?win32
Import maxgui.win32maxguiex
?linux
Import maxgui.fltkmaxgui
?macos
Import maxgui.cocoamaxgui
?

Import dwlab.frmwork

Include "LTForm.bmx"
Include "LTGadget.bmx"
Include "LTHorizontalList.bmx"
Include "LTMenuSwitch.bmx"