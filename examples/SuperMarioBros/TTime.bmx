'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TTime Extends LTBehaviorModel
  Const Time:Int = 200
  Const Threshold:Int = 50
  Const WarningPeriod:Double = 2.77
  
  Field StartingTime:Double
  Field WarningStartingTime:Double
  


  Method Init( Shape:LTShape )
    StartingTime = Game.Time
    WarningStartingTime = 0.0
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    Game.TimeLeft = Ceil( 2.0 * ( StartingTime + Time - Game.Time ) )
    If Game.TimeLeft <= 0 Then
      Remove( Shape )
      Game.Mario.AttachModel( TDying.Create( False ) )
    End If
    If Game.TimeLeft <= Threshold And Not WarningStartingTime Then
      Game.MusicChannel.Stop()
      Game.MusicChannel = Game.Warning.Play()
      WarningStartingTime = Game.Time
    End If
    If WarningStartingTime And Game.Time > WarningStartingTime + WarningPeriod Then Game.MusicChannel.SetRate( 1.3 )
  End Method
End Type