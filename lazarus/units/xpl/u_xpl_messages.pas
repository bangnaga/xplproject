﻿unit u_xpl_messages;

// These classes handle specific class of messages and their behaviour

{$i xpl.inc}

interface

uses Classes
     , SysUtils
     , u_xpl_message
     , u_xpl_common
     ;

type // THeartBeatMsg =========================================================

     { TOsdBasic }

     TOsdBasic = class(TxPLMessage)
     private
       function GetColumn: integer;
       function GetCommand: string;
       function GetDelay: integer;
       function GetRow: integer;
       function GetText: string;
       procedure SetColumn(const AValue: integer);
       procedure SetCommand(const AValue: string);
       procedure SetDelay(const AValue: integer);
       procedure SetRow(const AValue: integer);
       procedure SetText(const AValue: string);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Command : string read GetCommand write SetCommand;
        property Text  : string read GetText write SetText;
        property Row  : integer read GetRow write SetRow;
        property Column  : integer read GetColumn write SetColumn;
        property Delay : integer read GetDelay write SetDelay;
     end;

     { TLogBasic }

     { TDawnDuskBasic }
     TDawnDuskStatusType = (dawn,dusk,noon);
     TDayNightStatusType = (day,night);

     { TDawnDuskBasicTrig }

     TDawnDuskBasicTrig = class(TxPLMessage)
     private
       function GetStatus: TDawnDuskStatusType;
       procedure SetStatus(aValue: TDawnDuskStatusType);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Status  : TDawnDuskStatusType read GetStatus write SetStatus;
     end;

     { TDawnDuskBasicStat }

     TDawnDuskBasicStat = class(TxPLMessage)
     private
       function GetStatus: TDayNightStatusType;
       procedure SetStatus(aValue: TDayNightStatusType);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Status  : TDayNightStatusType read GetStatus write SetStatus;
     end;


     TLogBasic = class(TxPLMessage)
     private
       function GetCode: string;
       function GetText: string;
       function GetType: TEventType;
       procedure SetCode(const AValue: string);
       procedure SetText(const AValue: string);
       procedure SetType(const AValue: TEventType);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Type_ : TEventType read GetType write SetType;
        property Text  : string read GetText write SetText;
        property Code  : string read GetCode write SetCode;
     end;

     TSendmsgBasic = class(TxPLMessage)
     private
       function GetText: string;
       function GetTo: string;
       procedure SetText(const AValue: string);
       procedure SetTo(const AValue: string);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Text  : string read GetText write SetText;
        property To_  : string read GetTo write SetTo;
     end;

     { TReceiveMsgBasic }

     TReceiveMsgBasic = class(TSendmsgBasic)
     private
       function GetFrom: string;
       procedure SetFrom(AValue: string);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property From : string read GetFrom write SetFrom;
     end;

     { TTimerBasic }

     TTimerBasic = class(TxPLMessage)
     private
       function GetDevice : string;
       function GetCurrent : string;
       procedure SetCurrent(const AValue: string);
       procedure SetDevice(const aValue : string);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Device  : string read GetDevice write SetDevice;
        property Current : string read GetCurrent write SetCurrent;
     end;

     { TSensorBasic }
     // http://xplproject.org.uk/wiki/index.php?title=Schema_-_SENSOR.BASIC
     TSensorType = ( utUndefined, utBattery,  utCount, utCurrent, utDirection,
                              utDistance,  utEnergy,   utFan,   utGeneric, utHumidity,
                              utInput,     utOutput,   utPower, utPressure,utSetpoint,
                              utSpeed,     utTemp,     utUV,    utVoltage, utVolume,
                              utWeight, utPresence );
const     TSensorTypeLib : array[TSensorType] of string = ( 'undefined', 'battery',  'count', 'current', 'direction',
                            'distance',  'energy',   'fan',   'generic', 'humidity',
                            'input',     'output',   'power', 'pressure','setpoint',
                            'speed',     'temp',     'uv',    'voltage', 'volume',
                            'weight','presence' );

 TSensorUnits : Array[TSensorType] of String = ('','%','','A','Deg','m','kWh','rpm',
                                             '','%','','','kW','N/m2','DegC','mph',
                                             'DegC','','V','m3','kg','');
type TSensorBasic = class(TxPLMessage)
     private
       function GetDevice : string;
       function GetCurrent : string;
       function GetType : TSensorType;
       function GetUnits: string;
       procedure SetType(const AValue: TSensorType);
       procedure SetCurrent(const AValue: string);
       procedure SetDevice(const aValue : string);
       procedure SetUnits(const AValue: string);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
        function SensorName : string;
     published
        property Device  : string read GetDevice write SetDevice;
        property Current : string read GetCurrent write SetCurrent;
        property Type_  : TSensorType read GetType write SetType;
        property Units : string read GetUnits write SetUnits;
     end;



     { TConfigMessageFamily }

type     TConfigMessageFamily = class(TxPLMessage)
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     end;

     TConfigListCmnd = class(TConfigMessageFamily)
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     end;

     { TConfigListStat }

     TConfigListStat = class(TConfigListCmnd)
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     public
        function ItemMax(const i : integer) : integer;
        function ItemName(const i : integer) : string;
     end;

     { TConfigListMsg }

     TConfigCurrentCmnd = class(TConfigListCmnd)
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     end;

     { TConfigResponseCmnd }

     TConfigResponseCmnd = class(TConfigMessageFamily)
     private
        fMultiValued : TStringList;

        function GetFilters : TStringList;
        function GetGroups : TStringList;
        procedure Read_Multivalued(const aListIndex : integer);
        function  Getinterval: integer;
        function  Getnewconf: string;
        procedure Setinterval(const AValue: integer);
        procedure Setnewconf(const AValue: string);
        function  GetMultiValued(const aValue : string) : TStringList;
        procedure SlChanged(Sender : TObject);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
        destructor  Destroy; override;
        function  IsCoreValue(const aIndex : integer) : boolean;
     published
        property newconf : string read Getnewconf write Setnewconf stored false;
        property interval: integer read Getinterval write Setinterval stored false;
        property filters : TStringList read GetFilters stored false; //write SetFilters stored false;
        property groups  : TStringList read GetGroups stored false; // write SetGroups stored false;
     end;

     TConfigCurrentStat = class(TConfigResponseCmnd)
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;

        procedure   Assign(aMessage : TPersistent); override;
     published
        property Interval;
        property NewConf;
        property Filters;
        property Groups;
     end;

     THeartBeatReq = class(TxPLMessage)
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     end;

     { TDawnDuskReq }

     TDawnDuskReq = class(TxPLMessage)
     private
        function GetQuery: string;
        procedure SetQuery(aValue: string);
     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
     published
        property Query : string read GetQuery write SetQuery;
     end;

     THeartBeatMsg = class(TxPLMessage)
     private
        function  GetAppName: string;
        function  GetInterval: integer;
        function  Getport: integer;
        function  Getremote_ip: string;
        function  GetVersion: string;
        procedure SetAppName(const AValue: string);
        procedure SetInterval(const AValue: integer);
        procedure Setport(const AValue: integer);
        procedure Setremote_ip(const AValue: string);
        procedure SetVersion(const AValue: string);

     public
        constructor Create(const aOwner: TComponent; const aRawxPL : string = ''); reintroduce;
        procedure   Send;

     published
        property interval : integer read GetInterval  write SetInterval;
        property port     : integer read Getport      write Setport;
        property remote_ip: string  read Getremote_ip write Setremote_ip;
        property appname  : string  read GetAppName   write SetAppName;
        property version  : string  read GetVersion   write SetVersion;
     end;

     // TFragmentReq ==========================================================

     { TFragmentReqMsg }
     TFragmentMsg = class(TxPLMessage)

     end;

     TFragmentReqMsg = class(TFragmentMsg)
     private
        function GetMessage: integer;
        function GetParts: IntArray;
        procedure SetMessage(const AValue: integer);
        procedure SetParts(const AValue: IntArray);

     public
        constructor Create(const aOwner : TComponent); overload;

        procedure AddPart(const aPart : integer);
     published
        property Parts : IntArray read GetParts write SetParts;
        property Message : integer read GetMessage write SetMessage;
     end;

     { TFragmentBasicMsg }

     TFragBasicMsg = class(TFragmentMsg)
     private
        fPartNum, fPartMax, fUniqueId : integer;

        procedure SetPartMax(const AValue: integer);
        procedure SetPartNum(const AValue: integer);
        procedure SetUniqueId(const AValue: integer);

        procedure ReadPartIdElements;
        procedure WritePartIdElements;

     public
        constructor Create(const aOwner : TComponent; const aSourceMsg : TxPLMessage; const FirstOne : boolean = false); reintroduce; overload;
        function    Identifier : string;
        function    IsTheFirst : boolean;
        function    ToMessage  : TxPLMessage;
        function    IsValid    : boolean; reintroduce;

        property    PartNum  : integer read fPartNum  write SetPartNum;
        property    PartMax  : integer read fPartMax  write SetPartMax;
        property    UniqueId : integer read fUniqueId write SetUniqueId;
     end;

     function MessageBroker(const aRawxPL : string) : TxPLMessage;

// ============================================================================
implementation

uses StrUtils
     , TypInfo
     , u_xpl_schema
     , u_xpl_sender
     , u_xpl_custom_listener
     , uxplConst
     ;

const K_HBEAT_ME_INTERVAL = 'interval';
      K_HBEAT_ME_PORT     = 'port';
      K_HBEAT_ME_REMOTEIP = 'remote-ip';
      K_HBEAT_ME_VERSION  = 'version';
      K_HBEAT_ME_APPNAME  = 'appname';

      K_FRAGREQ_ME_MESSAGE = 'message';
      K_FRAGBAS_ME_PARTID  = 'partid';

      K_CONFIG_RESPONSE_KEYS : Array[0..3] of string = ('newconf','interval','filter','group');

// ===========================================================================
function MessageBroker(const aRawxPL: string): TxPLMessage;
var aMsg : TxPLMessage;
begin
   aMsg := TxPLMessage.Create(nil,aRawxPL);
   if
     aMsg.Schema.Equals(Schema_FragBasic) then result := TFragBasicMsg.Create(nil,aMsg)
   else if
     aMsg.Schema.Equals(Schema_FragReq)   then result := TFragmentReqMsg.Create(nil,aRawxPL)
   else if
     aMsg.Schema.Equals(Schema_HBeatApp)  then result := THeartBeatMsg.Create(nil,aRawxPL)
   else if
     aMsg.Schema.Equals(Schema_HBeatReq)  then result := THeartBeatReq.Create(nil,aRawxPL)
   else if
     (aMsg.Schema.Equals(Schema_ConfigList)) and (aMsg.MessageType = cmnd) then result := TConfigListCmnd.Create(nil,aRawxPL)
   else if
     (aMsg.Schema.Equals(Schema_ConfigCurr)) and (aMsg.MessageType = cmnd) then result := TConfigCurrentCmnd.Create(nil,aRawxPL)
   else if
     (aMsg.Schema.Equals(Schema_ConfigResp)) and (aMsg.MessageType = cmnd) then result := TConfigResponseCmnd.Create(nil,aRawxPL)
   else if
     (aMsg.Schema.Equals(Schema_ConfigCurr)) and (aMsg.MessageType = stat) then result := TConfigCurrentStat.Create(nil,aRawxPL)
   else if
     (aMsg.Schema.Equals(Schema_DDBasic)) and (aMsg.MessageType = trig) then result := TDawnDuskBasicTrig.Create(nil,aRawxPL)
   else if
     (aMsg.Schema.Equals(Schema_DDBasic)) and (aMsg.MessageType = stat) then result := TDawnDuskBasicStat.Create(nil,aRawxPL)
     else if
     (aMsg.Schema.Equals(Schema_DDRequest)) and (aMsg.MessageType = cmnd) then result := TDawnDuskReq.Create(nil,aRawxPL)
   else if
     aMsg.Schema.RawxPL = 'log.basic' then result := TLogBasic.Create(nil,aRawxPL)
   else if
     aMsg.Schema.RawxPL = 'osd.basic' then result := TOsdBasic.Create(nil,aRawxPL)
   else if
     aMsg.Schema.RawxPL = 'sendmsg.basic' then result := TSendmsgBasic.Create(nil,aRawxPL)
   else if
     aMsg.Schema.RawxPL = 'rcvmsg.basic' then result := TReceivemsgBasic.Create(nil,aRawxPL)
   else if
     aMsg.Schema.RawxPL = 'sensor.basic' then result := TSensorBasic.Create(nil,aRawxPL)
     else if
       aMsg.Schema.RawxPL = 'timer.basic' then result := TTimerBasic.Create(nil,aRawxPL)
   else result := aMsg;

   if result<>aMsg then aMsg.Free;
end;

{ TDawnDuskBasicStat }

function TDawnDuskBasicStat.GetStatus: TDayNightStatusType;
begin
   if Body.GetValueByKey('status')='day' then Result := day
   else if Body.GetValueByKey('status')='night' then Result := night;
end;

procedure TDawnDuskBasicStat.SetStatus(aValue: TDayNightStatusType);
begin
   case aValue of
        day : Body.SetValueByKey('status','day');
        night : Body.SetValueByKey('status','night');
   end;
end;

constructor TDawnDuskBasicStat.Create(const aOwner: TComponent;
   const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.Assign(Schema_DDBasic);
      Target.IsGeneric := True;
      MessageType      := stat;
      Body.AddKeyValuePairs( ['type','status'],['daynight','']);
   end;
end;

{ TDawnDuskReq }

function TDawnDuskReq.GetQuery: string;
begin
   Result := Body.GetValueByKey('query');
end;

procedure TDawnDuskReq.SetQuery(aValue: string);
begin
   Body.SetValueByKey('query',aValue);
end;

constructor TDawnDuskReq.Create(const aOwner: TComponent; const aRawxPL: string
   );
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.Assign(Schema_DDRequest);
      Target.IsGeneric := True;
      MessageType      := cmnd;
      Body.AddKeyValuePairs( ['command','query'],['status','daynight']);
   end;
end;

{ TDawnDuskBasicTrig }

function TDawnDuskBasicTrig.GetStatus: TDawnDuskStatusType;
var s : string;
begin
   s := Body.GetValueByKey('status');
   if s = 'dawn' then Result := dawn
   else if s ='dusk' then Result := dusk;
end;

procedure TDawnDuskBasicTrig.SetStatus(aValue: TDawnDuskStatusType);
begin
   Body.SetValueByKey('status',GetEnumName(TypeInfo(TDawnDuskStatusType),Ord(aValue)));
end;

constructor TDawnDuskBasicTrig.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.Assign(Schema_DDBasic);
      Target.IsGeneric := True;
      MessageType      := trig;
      Body.AddKeyValuePairs( ['type','status'],['dawndusk','']);
   end;
end;

{ TTimerBasic }
function TTimerBasic.GetDevice: string;
begin
   result := Body.GetValueByKey('device','');
end;

function TTimerBasic.GetCurrent: string;
begin
   result := Body.GetValueByKey('current','');
end;

procedure TTimerBasic.SetCurrent(const AValue: string);
begin
   Body.SetValueByKey('current',aValue);
end;

procedure TTimerBasic.SetDevice(const AValue: string);
begin
   Body.SetValueByKey('device',aValue);
end;

constructor TTimerBasic.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.RawxPL := 'timer.basic';
      Target.IsGeneric := True;
      MessageType      := stat;
      Body.AddKeyValuePairs( ['device','current'],['','']);
   end;
end;

// TConfigMessageFamily =======================================================
constructor TConfigMessageFamily.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL = '' then begin
      Schema.Classe := 'config';
   end;
end;

{ TConfigCurrentStat }
constructor TConfigCurrentStat.Create(const aOwner: TComponent;  const aRawxPL: string);
begin
   inherited Create(aOwner, aRawxPL);
   if aRawxPL = '' then begin
      Schema.Type_:= 'current';
      MessageType := stat;
      Target.IsGeneric:=true;
   end;
end;

procedure TConfigCurrentStat.Assign(aMessage: TPersistent);
begin
   Body.ResetValues;
   inherited Assign(aMessage);
   if aMessage is TConfigCurrentStat then begin
      fMultiValued.Assign(tConfigCurrentStat(aMessage).fMultiValued);
   end;
end;

{ TConfigListCmnd }
constructor TConfigListCmnd.Create(const aOwner: TComponent; const aRawxPL: string);      // formerly TConfigReqMsg
begin
   inherited Create(aOwner, aRawxPL);
   if aRawxPL = '' then begin
      Schema.Type_:= 'list';
      MessageType := cmnd;
      Body.AddKeyValuePairs( ['command'],['request']);
   end;
end;

constructor TConfigListStat.Create(const aOwner: TComponent;   const aRawxPL: string);
begin
   inherited Create(aOwner, aRawxPL);
   if aRawxPL = '' then begin
      MessageType := stat;
      Body.ResetValues;
      Body.AddKeyValuePairs( ['reconf','option','option','option'],['newconf','interval','filter[16]','group[16]']);
   end;
end;

function TConfigListStat.ItemMax(const i: integer): integer;
var sl : tstringlist;
    s  : string;
begin
   sl := TStringList.Create;
   s := AnsiReplaceStr(Body.Values[i],']','[');
   sl.Delimiter := '[';
   sl.DelimitedText := s;
   if sl.Count=1 then result := 1 else result := StrToInt(sl[1]);
   sl.free;
end;

function TConfigListStat.ItemName(const i: integer): string;
var sl : tstringlist;
    s  : string;
begin
   sl := TStringList.Create;
   s := AnsiReplaceStr(Body.Values[i],']','[');
   sl.Delimiter := '[';
   sl.DelimitedText := s;
   result := sl[0];
   sl.free;
end;

{ TConfigCurrentCmnd }
constructor TConfigCurrentCmnd.Create(const aOwner: TComponent; const aRawxPL: string);    // formerly TConfigCurrMsg
begin
   inherited Create(aOwner, aRawxPL);
   if aRawxPL = '' then begin
      Schema.Type_:= 'current';
   end;
end;

// TConfigRespMsg =============================================================
constructor TConfigResponseCmnd.Create(const aOwner: TComponent; const aRawxPL: string);        // formerly TConfigRespMsg
begin
   inherited Create(aOwner, aRawxPL);
   fMultiValued := TStringList.Create;

   if aRawxPL = '' then begin
      Schema.Type_:= 'response';
      MessageType := cmnd;
      Body.AddKeyValuePairs( K_CONFIG_RESPONSE_KEYS,['','','','']);
   end;
end;

destructor TConfigResponseCmnd.Destroy;
var i : integer;
begin
   for i:=0 to Pred(fMultivalued.Count) do
       if Assigned(fMultiValued.Objects[i]) then
            TStringList(fMultiValued.Objects[i]).Free;
   fMultiValued.Free;
   inherited Destroy;
end;

function TConfigResponseCmnd.GetFilters : TStringList;
begin
   result := GetMultiValued('filter');
end;

function TConfigResponseCmnd.GetGroups : TStringList;
begin
   result := GetMultiValued('group');
end;

procedure TConfigResponseCmnd.SlChanged(Sender: TObject);
var j,i : integer;
begin
   for j:=0 to Pred(fMultiValued.Count) do begin
       if (fMultiValued.Objects[j] = sender) then begin                        // Identify the sending stringlist
          for i:=Pred(Body.ItemCount) downto 0 do
              if Body.Keys[i] = fMultiValued[j] then Body.DeleteItem(i);
          if TStringList(Sender).Count = 0
             then Body.AddKeyValue(fMultiValued[j]+'=')
             else for i:=0 to Pred(TStringList(Sender).Count) do
                  Body.AddKeyValue(fMultiValued[j] + '=' + TStringList(Sender)[i]);
       end;
   end;
end;

function TConfigResponseCmnd.GetMultiValued(const aValue: string): TStringList;
         function NewList : TStringList;
         begin
            result := TStringList.Create;
            result.Sorted := true;
            result.Duplicates:=dupIgnore;
            result.OnChange  :=@slChanged;
         end;
var i : integer;
begin
   result := nil;

   for i:=0 to Pred(fMultiValued.count) do
       if fMultiValued[i] = aValue then
          result := TStringList(fMultiValued.Objects[i]);
   if (result = nil) then begin
      result := NewList;
      i := fMultiValued.AddObject(aValue,Result);
      Read_MultiValued(i);
   end;
end;

procedure TConfigResponseCmnd.Read_Multivalued(const aListIndex: integer);
var i : integer;
    aSl : TStringList;
begin
   aSL := TStringList(fMultiValued.Objects[aListIndex]);
   aSL.BeginUpdate;
   aSL.Clear;
   for i := 0 to Pred(Body.ItemCount) do
       if (Body.Keys[i] = fMultiValued[aListIndex]) and (Body.Values[i]<>'') then aSL.Add(Body.Values[i]);
   aSL.EndUpdate;
end;

function TConfigResponseCmnd.Getinterval: integer;
begin
   result := StrToIntDef(Body.GetValueByKey('interval',''),-1);
end;

function TConfigResponseCmnd.Getnewconf: string;
begin
   result := Body.GetValueByKey('newconf','');
end;

procedure TConfigResponseCmnd.Setinterval(const AValue: integer);
begin
   Body.SetValueByKey('interval',IntToStr(aValue));
end;

procedure TConfigResponseCmnd.Setnewconf(const AValue: string);
begin
   Body.SetValueByKey('newconf',aValue);
end;

function TConfigResponseCmnd.IsCoreValue(const aIndex: integer): boolean;
begin
   result := AnsiIndexStr(Body.Keys[aIndex],K_CONFIG_RESPONSE_KEYS) <>-1;
end;

// TSensorBasic ===============================================================
constructor TSensorBasic.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.RawxPL := 'sensor.basic';
      Target.IsGeneric := True;
      MessageType      := trig;
      Body.AddKeyValuePairs( ['device','type','current'],['','','']);
   end;
end;

function TSensorBasic.SensorName: string;
begin
//   result := Source.AsFilter + '.' + Device;
   result := Device;
end;

function TSensorBasic.GetDevice: string;
begin
   result := Body.GetValueByKey('device','');
end;

procedure TSensorBasic.SetDevice(const AValue: string);
begin
   Body.SetValueByKey('device',aValue);
end;

function TSensorBasic.GetType: TSensorType;
var s : string;
    i : integer;
begin
   s := Body.GetValueByKey('type','');
   i := AnsiIndexStr(AnsiLowerCase(s),TSensorTypeLib);
   if i=-1 then i := 0;
   Result := TSensorType(i);
end;

procedure TSensorBasic.SetType(const AValue: TSensorType);
var {%H-}foo : string;
begin
   Body.SetValueByKey('type',TSensorTypeLib[aValue]);
   foo := GetUnits;                                                           // Will set the default unit for current value
end;

function TSensorBasic.GetCurrent: string;
begin
   result := Body.GetValueByKey('current','');
end;

procedure TSensorBasic.SetCurrent(const AValue: string);
begin
   Body.SetValueByKey('current',aValue);
end;

procedure TSensorBasic.SetUnits(const AValue: string);
begin
   Body.SetValueByKey('units',aValue);
end;

function TSensorBasic.GetUnits: string;
begin
   result := Body.GetValueByKey('units','');
   if AnsiSameText(result,'') then begin                                       // Si aucune unité indiquée, on renvoie celle par
      result  := TSensorUnits[Type_];                                          // défaut pour le type courant
      if not AnsiSameText(result,'') then
         SetUnits(result);                                                    // on indique l'unité dans le body au passage
   end;
end;

// TSendmsgBasic ==============================================================
constructor TSendmsgBasic.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.RawxPL := 'sendmsg.basic';
      Target.IsGeneric := True;
      MessageType      := cmnd;
      Body.AddKeyValuePairs( ['body','to'],['','']);
   end;
end;

function TSendmsgBasic.GetTo: string;
begin
   result := Body.GetValueByKey('to','');
end;

function TSendmsgBasic.GetText: string;
begin
   result := Body.GetValueByKey('body');
end;

procedure TSendmsgBasic.SetText(const AValue: string);
begin
   Body.SetValueByKey('body',aValue);
end;

procedure TSendmsgBasic.SetTo(const AValue: string);
begin
   Body.SetValueByKey('to',aValue);
end;

{ TReceiveMsgBasic }

constructor TReceiveMsgBasic.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.RawxPL := 'rcvmsg.basic';
      MessageType      := trig;
      Body.AddKeyValuePairs( ['from'],['']);
   end;
end;

function TReceiveMsgBasic.GetFrom: string;
begin
   result := Body.GetValueByKey('from','');
end;

procedure TReceiveMsgBasic.SetFrom(AValue: string);
begin
   Body.SetValueByKey('from',aValue);
end;

{ TLogBasic }
constructor TLogBasic.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.RawxPL := 'log.basic';
      Target.IsGeneric := True;
      MessageType      := trig;
      Body.AddKeyValuePairs( ['type','text'],['','']);
   end;
end;

function TLogBasic.GetCode: string;
begin
   result := Body.GetValueByKey('code','');
end;

function TLogBasic.GetText: string;
begin
   result := Body.GetValueByKey('text');
end;

function TLogBasic.GetType: TEventType;
begin
   result := xPLLevelToEventType(Body.GetValueByKey('type'));
end;

procedure TLogBasic.SetCode(const AValue: string);
begin
   Body.SetValueByKey('code',aValue);
end;

procedure TLogBasic.SetText(const AValue: string);
begin
   Body.SetValueByKey('text',aValue);
end;

procedure TLogBasic.SetType(const AValue: TEventType);
begin
   Body.SetValueByKey('type',EventTypeToxPLLevel(aValue));
end;

{ TOsdBasic }

function TOsdBasic.GetColumn: integer;
begin
   result := StrToIntDef(Body.GetValueByKey('column'),0);
end;

function TOsdBasic.GetCommand: string;
begin
   result := Body.GetValueByKey('command','write');
end;

function TOsdBasic.GetDelay: integer;
begin
   result := StrToIntDef(Body.GetValueByKey('delay'),-1);
end;

function TOsdBasic.GetRow: integer;
begin
   result := StrToIntDef(Body.GetValueByKey('row'),0);
end;

function TOsdBasic.GetText: string;
begin
   result := Body.GetValueByKey('text');
end;

procedure TOsdBasic.SetColumn(const AValue: integer);
begin
   Body.SetValueByKey('column',IntToStr(aValue));
end;

procedure TOsdBasic.SetCommand(const AValue: string);
begin
   Body.SetValueByKey('command',aValue);
end;

procedure TOsdBasic.SetDelay(const AValue: integer);
begin
   if GetDelay=-1 then Body.AddKeyValue('delay=');
   Body.SetValueByKey('delay',IntToStr(aValue));
end;

procedure TOsdBasic.SetRow(const AValue: integer);
begin
   Body.SetValueByKey('row',IntToStr(aValue));
end;

procedure TOsdBasic.SetText(const AValue: string);
begin
   Body.SetValueByKey('text',aValue);
end;

constructor TOsdBasic.Create(const aOwner: TComponent; const aRawxPL: string);
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.RawxPL := 'osd.basic';
      Target.IsGeneric := True;
      MessageType      := cmnd;
      Body.AddKeyValuePairs( ['command','text'],['','']);
   end;
end;

// TFragmentBasicMsg =========================================================
constructor TFragBasicMsg.Create(const aOwner: TComponent; const aSourceMsg : TxPLMessage; const FirstOne : boolean = false);
begin
   fPartNum  := -1;
   fPartMax  := -1;
   fUniqueId := -1;

   inherited Create(aOwner);                                                   // This object can be created from two purposes :
   if aSourceMsg.schema.Equals(Schema_FragBasic) then begin                    //    1°/ Creating it from rawxpl received on the network
      Assign(aSourceMsg);
      ReadPartIdElements;
   end else begin                                                              //    2°/ Having a big message of class.type schema to explode it
      AssignHeader(aSourceMsg);
      Schema.Assign(Schema_FragBasic);
      Body.addkeyvaluepairs([K_FRAGBAS_ME_PARTID],['%d/%d:%d']);
      if FirstOne then begin
         Body.addkeyvaluepairs(['schema'],[aSourceMsg.Schema.RawxPL]);
         fPartNum := 1;
      end;
   end;
end;

procedure TFragBasicMsg.SetPartMax(const AValue: integer);
begin
   if aValue = fPartMax then exit;
   fPartMax := aValue;
   WritePartIdElements;
end;

procedure TFragBasicMsg.SetPartNum(const AValue: integer);
begin
   if aValue = fPartNum then exit;
   fPartNum := aValue;
   WritePartIdElements;
end;

procedure TFragBasicMsg.SetUniqueId(const AValue: integer);
begin
   if aValue = fUniqueId then exit;
   fUniqueId := aValue;
   WritePartIdElements;
end;

procedure TFragBasicMsg.ReadPartIdElements;
var List   : TStringList;
    partid : string;
begin
    partid := AnsiReplaceStr(Body.GetValueByKey('partid'),'/',':');
    List   := TStringList.Create;
    List.Delimiter := ':';
    List.DelimitedText := partid;

    if list.Count=3 then begin
       fPartNum  := StrToIntDef(list[0],-1);
       fPartMax  := StrToIntDef(list[1],-1);
       fUniqueId := StrToIntDef(list[2],-1);
    end;
    list.Free;
end;

procedure TFragBasicMsg.WritePartIdElements;
begin
   Body.SetValueByKey(K_FRAGBAS_ME_PARTID, Format('%d/%d:%d',[fPartNum, fPartMax, fUniqueID]));
end;

function TFragBasicMsg.ToMessage: TxPLMessage;
begin
   if IsTheFirst then begin
      Result := TxPLMessage.Create(owner);
      if IsValid then begin
         Result.Assign(self);
         Result.schema.RawxPL := Body.GetValueByKey('schema');
         Result.Body.DeleteItem(0);                                               // Delete the partid line
         if Result.Schema.IsValid then Result.Body.DeleteItem(0);                 // delete the schema line
      end;
   end else Result := nil;
end;

function TFragBasicMsg.IsValid: boolean;
begin
   Result := inherited IsValid and ( (fPartNum * fPartMax * fUniqueId) >= 0);
   if IsTheFirst then Result := Result and (Body.GetValueByKey('schema')<>'');
end;

function TFragBasicMsg.Identifier: string;
begin
   result := AnsiReplaceStr(Source.AsFilter,'.','') + IntToStr(fUniqueId);
end;

function TFragBasicMsg.IsTheFirst: boolean;
begin
   result := (fPartNum = 1);
end;

// TFragmentReq ==============================================================
constructor TFragmentReqMsg.Create(const aOwner: TComponent);
begin
   inherited Create(aOwner);
   Schema.Assign(Schema_FragReq);
   MessageType := cmnd;
   Body.AddKeyValuePairs( ['command',K_FRAGREQ_ME_MESSAGE], ['resend','']);
end;

function TFragmentReqMsg.GetMessage: integer;
begin
   result := StrToIntDef(Body.GetValueByKey(K_FRAGREQ_ME_MESSAGE),-1);
end;

function TFragmentReqMsg.GetParts: IntArray;
var i : integer;

begin
   SetLength(Result,0);
   for i:=0 to Pred(Body.ItemCount) do
       if Body.Keys[i]='part' then begin
          SetLength(Result,Length(result)+1);
          Result[length(result)-1] := StrToInt(Body.Values[i]);
       end;
end;

procedure TFragmentReqMsg.SetMessage(const AValue: integer);
begin
   Body.SetValueByKey(K_FRAGREQ_ME_MESSAGE,IntToStr(aValue));
end;

procedure TFragmentReqMsg.AddPart(const aPart: integer);
begin
   Body.AddKeyValue('part=' + IntToStr(aPart));
end;

procedure TFragmentReqMsg.SetParts(const AValue: IntArray);
var i : integer;
begin
   for i:=low(aValue) to high(aValue) do AddPart(aValue[i]);
end;

// THeartBeatReq ==============================================================
constructor THeartBeatReq.Create(const aOwner: TComponent; const aRawxPL : string = '');
begin
   inherited Create(aOwner,aRawxPL);
   if aRawxPL='' then begin
      Schema.Assign(Schema_HBeatReq);
      Target.IsGeneric := True;
      MessageType      := cmnd;
      Body.AddKeyValuePairs( ['command'],['request']);
   end;
end;

// THeartBeatMsg ==============================================================
constructor THeartBeatMsg.Create(const aOwner: TComponent; const aRawxPL : string = '');
begin
   inherited Create(aOwner, aRawxPL);
   if aRawxPL='' then begin
      Schema.Assign(Schema_HBeatApp);
      MessageType:= stat;
      Target.IsGeneric := True;
      Body.AddKeyValuePairs( [K_HBEAT_ME_INTERVAL,K_HBEAT_ME_PORT,K_HBEAT_ME_REMOTEIP,K_HBEAT_ME_APPNAME ,K_HBEAT_ME_VERSION],
                             ['','','','','']);
      if Owner is TxPLCustomListener then with TxPLCustomListener(Owner) do begin
         Self.Interval := Config.Interval;
         Self.AppName  := AppName;
         Self.Version  := Version;
         if not Config.IsValid then Schema.Classe := 'config';
         if csDestroying in ComponentState then Schema.Type_ := 'end';
      end;
   end;
end;

procedure THeartBeatMsg.Send;
begin
   if Owner is TxPLSender then
      TxPLSender(Owner).Send(self);
end;

function THeartBeatMsg.GetAppName: string;
begin
   result := Body.GetValueByKey('appname','');
end;

function THeartBeatMsg.GetInterval: integer;
begin
   result := StrToIntDef(Body.GetValueByKey(K_HBEAT_ME_INTERVAL),MIN_HBEAT);
end;

function THeartBeatMsg.Getport: integer;
begin
   Assert(Body.GetValueByKey(K_HBEAT_ME_PORT,'')<>'');
   result := StrToIntDef(Body.GetValueByKey(K_HBEAT_ME_PORT),-1);
end;

function THeartBeatMsg.Getremote_ip: string;
begin
   result := Body.GetValueByKey(K_HBEAT_ME_REMOTEIP);
end;

function THeartBeatMsg.GetVersion: string;
begin
   result := Body.GetValueByKey('version','');
end;

procedure THeartBeatMsg.SetAppName(const AValue: string);
begin
   Body.SetValueByKey('appname',aValue);
end;

procedure THeartBeatMsg.SetInterval(const AValue: integer);
begin
   Body.SetValueByKey(K_HBEAT_ME_INTERVAL,IntToStr(aValue));
end;

procedure THeartBeatMsg.Setport(const AValue: integer);
begin
   Body.SetValueByKey(K_HBEAT_ME_PORT,IntToStr(aValue));
end;

procedure THeartBeatMsg.Setremote_ip(const AValue: string);
begin
   Body.SetValueByKey(K_HBEAT_ME_REMOTEIP,aValue);
end;

procedure THeartBeatMsg.SetVersion(const AValue: string);
begin
   Body.SetValueByKey('version',aValue);
end;

end.
