'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TStats Extends LTObject
	Field LevelName:String
	Field Completed:Int
	Field Score:Int
	Field Time:Int
	Field Turns:Int	
	
	Function AddStats()
		local Stat:TStats = New TStats
		Stat.LevelName = Menu.LevelName
		Stat.Completed = LTLevelWindow.LevelIsCompleted
		Stat.Score = Profile.LevelScore
		Stat.Time = Profile.LevelTime
		Stat.Turns = Profile.LevelTurns
		TStatList.Instance.Stats.AddLast( Stat )
		TStatList.Instance.SaveToFile( "stats.xml" )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "level", LevelName )
		XMLObject.ManageIntAttribute( "completed", Completed )
		XMLObject.ManageIntAttribute( "score", Score )
		XMLObject.ManageIntAttribute( "time", Time )
		XMLObject.ManageIntAttribute( "turns", Turns )
	End Method
End Type



Type TStatList Extends LTObject
	Global Instance:TStatList = New TStatList
	
	Field Stats:TList = New TList
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageChildList( Stats )
	End Method
End Type
