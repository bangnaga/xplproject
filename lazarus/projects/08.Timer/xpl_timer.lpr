program xpl_timer;

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
     Interfaces, // this includes the LCL widgetset
     Forms, pl_rx, fpTimer,
     frm_timer,
     u_xpl_timer,
     u_xpl_application,
     u_xpl_listener,
     timer_listener,
     u_xpl_gui_resource,
     u_xpl_common;

{$IFDEF WINDOWS}{$R xpl_timer.rc}{$ENDIF}


begin
  Application.Initialize;

  xPLApplication := TxPLTimerListener.Create(nil);
  xPLGUIResource := TxPLGUIResource.Create;

  Application.CreateForm(TFrmTimer,  frmTimer);
  Application.Icon := FrmTimer.Icon;
  Application.Run;

  xPLGUIResource.Free;
  xPLApplication.Free;
end.



