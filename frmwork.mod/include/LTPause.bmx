'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Singleton class for Pause objects
End Rem
Type LTPause Extends LTObject
	Field PreviousPause:LTPause
	Field Project:LTProject
	Field Key:Int
	
	
	
	Rem
	bbdoc: Render method.
	about: Will be executed persistently by active project rendering mechanism when pause will be active for this project.
	Fill it with methods which will display pause information.
	End Rem
	Method Render()
	End Method
	
	
	
	Rem
	bbdoc: Pause updating method.
	about: Will be executed persistently by active project logic mechanism when pause will be active for this project.
	Fill it with methods which will control pause object state (animation for example).
	End Rem
	Method Update()
	End Method
	
	
	
	Rem
	bbdoc: Method for checking if pause key has been pressed and remove pause object if yes.
	End Rem
	Method CheckKey()
		If KeyHit( Key ) Then Remove()
	End Method
	
	
	
	Rem
	bbdoc: Pause object removing method.
	End Rem
	Method Remove()
		Project.CurrentPause = PreviousPause
	End Method
End Type