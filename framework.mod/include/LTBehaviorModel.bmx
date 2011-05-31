'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBehaviorModel Extends LTObject
	Field Active:Int = True
	Field Link:TLink
	
	
	
	Method Init( Sprite:LTSprite )
	End Method

	
	
	Method Activate( Sprite:LTSprite )
	End Method
	
	
	
	Method Deactivate( Sprite:LTSprite )
	End Method
	
	
	
	Method ApplyTo( Sprite:LTSprite )
	End Method
	
	
	
	Method Remove()
		Link.Remove()
	End Method
End Type