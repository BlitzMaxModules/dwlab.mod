'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTPause Extends LTObject
	Field PreviousPause:LTPause
	Field Project:LTProject
	Field Key:Int
	
	
	
	Method Render()
	End Method
	
	
	
	Method Update()
	End Method
	
	
	
	Method CheckKey()
		If KeyHit( Key ) Then Remove()
	End Method
	
	
	
	Method Remove()
		Project.CurrentPause = PreviousPause
	End Method
End Type