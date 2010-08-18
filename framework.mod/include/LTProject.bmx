' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Global L_CurrentProject:LTProject

Type LTProject Extends LTObject
  Field LogicFPS:Float = 75
  Field MinFPS:Float = 15
  Field Pass:Int
  Field DeltaTime:Float
  Field ProjectTime:Float
  
  
  
  Method Init()
  End Method
  
  
  
  Method Render()
  End Method
  
  
  
  Method Logic()
  End Method
  
  
  
  Method Execute()
    FlushKeys
    FlushMouse
    
    Pass = 1
    DeltaTime = 0
    
    Init()

    Local StartTime:Int = MilliSecs()
    Local FPSTime:Int = 0
    Local FPSCount:Int = 0
    
    Local RealTime:Float = 0
    Local LastRenderTime:Float = 0
    Local MaxRenderPeriod:Float = 1.0 / MinFPS
    
    DeltaTime = 1.0 / LogicFPS
    
    Repeat
      ProjectTime :+  DeltaTime
      
      Logic()
      For Local Actor:LTActor = Eachin L_Actors
        Actor.Logic()
      Next

      Repeat
        RealTime = 0.001 * ( Millisecs() - StartTime )
        If RealTime >= ProjectTime And ( RealTime - LastRenderTime ) < MaxRenderPeriod Then Exit
        
        Render()
        For Local Actor:LTActor = Eachin L_Actors
          Actor.Render()
        Next
      
        LastRenderTime = 0.001 * ( Millisecs() - StartTime )
        FPSCount :+ 1
      Forever
      
      If Millisecs() >= 1000 + FPSTime Then
        L_FPS = FPSCount
        FPSCount = 0
        FPSTime = Millisecs()
        L_MemoryUsed = Int( GCMemAlloced() / 1024 )
      End If
      
      PollSystem()
      Pass :+ 1
    Forever
  End Method
End Type