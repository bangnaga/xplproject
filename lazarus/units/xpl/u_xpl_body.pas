unit u_xpl_body;
{==============================================================================
  UnitName      = uxplmsgbody
  UnitDesc      = xPL Message Body management object and function
  UnitCopyright = GPL by Clinique / xPL Project
 ==============================================================================
 Rawdata passed are not transformed to lower case, Body lowers body item keys
 but not body item values.

 0.98 : Added method to clean empty body elements ('value=')
 1.02 : Added auto cut / reassemble of long body variable into multiple lines
 1.03 : Added AddKeyValuePairs
 1.04 : Class renamed TxPLBody
 1.5  : Added fControlInput property to override read/write controls needed for OPC
}

{$i xpl.inc}

interface

uses Classes
     , u_xpl_common
     ;

type // TxPLBody ==============================================================
     TxPLBody = class(TComponent, IxPLCommon, IxPLRaw)
        private
           fControlInput : boolean;
           fKeys,
           fValues,
           fStrings : TStringList;

           procedure AddKeyValuePair(const aKey, aValue : string);              // This one moved to private because of creation of AddKeyValuePairs
           function  AppendItem(const aName : string) : integer;
           function  GetCount: integer; inline;
           function  IsValidKey(const aKey : string) : boolean;
           function  IsValidValue(const aValue : string) : boolean;

           function  Get_RawxPL : string;
           function  Get_Strings: TStrings;
           procedure Set_Keys(const AValue: TStringList);
           procedure Set_RawxPL(const AValue: string);
           procedure Set_Strings(const AValue: TStrings);
           procedure Set_Values(const AValue: TStringList);
        public
           constructor Create(aOwner : TComponent); override;
           destructor  Destroy; override;

           procedure Assign(Source : TPersistent); override;
           function  IsValid : boolean;

           procedure ResetValues;

           procedure CleanEmptyValues;

           procedure AddKeyValuePairs(const aKeys, aValues : TStringList); overload;
           procedure AddKeyValuePairs(const aKeys, aValues : Array of string); overload;
           procedure AddKeyValue(const aKeyValuePair : string);
           procedure Append(const aBody : TxPLBody);
           procedure InsertKeyValuePair(const aIndex : integer; const aKey, aValue : string);
           procedure DeleteItem(const aIndex : integer);
           function  GetValueByKey(const aKeyValue: string; const aDefVal : string = '') : string;
           procedure SetValueByKey(const aKeyValue, aDefVal : string);

           property ItemCount : integer     read GetCount;
           property ControlInput : boolean  read fControlInput write fControlInput;
        published
           property Keys      : TStringList read fKeys       write Set_Keys;
           property Values    : TStringList read fValues     write Set_Values;
           property RawxPL    : string      read Get_RawxPL  write Set_RawxPL  stored false;
           property Strings   : TStrings read Get_Strings write Set_Strings stored false;
        end;

implementation // =============================================================
uses sysutils
     , strutils
     ;

// ============================================================================
const K_MSG_BODY_FORMAT     = '{'#10'%s}'#10;
      K_BODY_ELMT_DELIMITER = '=';

// TxPLBody ===================================================================
constructor TxPLBody.Create(aOwner : TComponent);
begin
   inherited;
   include(fComponentStyle,csSubComponent);
   fControlInput := true;
   fKeys    := TStringList.Create;
   fValues  := TStringList.Create;
   fStrings := TStringList.Create;
end;

destructor TxPLBody.destroy;
begin
   fStrings.Free;
   fValues.Free;
   fKeys.Free;

   inherited;
end;

function TxPLBody.GetCount: integer;
begin
   result := fKeys.Count;
end;

function TxPLBody.IsValidKey(const aKey: string): boolean;
begin
   result := IsValidxPLIdent(aKey) and (length(aKey)<=MAX_KEY_LEN);
end;

function TxPLBody.IsValidValue(const aValue: string): boolean;
begin
   result := length(aValue) <= MAX_VALUE_LEN;
end;

procedure TxPLBody.ResetValues;
begin
   Keys.Clear;
   Values.Clear;
end;

procedure TxPLBody.DeleteItem(const aIndex: integer);
begin
   Keys.Delete(aIndex);
   Values.Delete(aIndex);
end;

function TxPLBody.AppendItem(const aName : string) : integer;
begin
   result := Keys.Add(aName);
   Values.Add('');
end;

procedure TxPLBody.Set_Values(const AValue: TStringList);
begin
   Values.Assign(aValue);
end;

procedure TxPLBody.Set_Keys(const AValue: TStringList);
begin
   Keys.Assign(aValue);
end;

procedure TxPLBody.Assign(Source : TPersistent);
begin
   if Source is TxPLBody then begin
      Set_Keys(TxPLBody(Source).Keys);
      Set_Values(TxPLBody(Source).Values);
      fControlInput := TxPLBody(Source).ControlInput;
   end else inherited;
end;

function TxPLBody.IsValid: boolean;
var s : string;
begin
   if not fControlInput then exit(true);
   result := true;
   for s in Keys do result := result and IsValidKey(s);
   for s in Values do result := result and IsValidValue(s);
end;

procedure TxPLBody.CleanEmptyValues;
var i : integer;
begin
   i := 0;
   while i<ItemCount do
         if Values[i]='' then DeleteItem(i) else inc(i);
end;

function TxPLBody.Get_RawxPL: string;
begin
   result := Format(K_MSG_BODY_FORMAT,[AnsiReplaceStr(Strings.Text,#13,'')]);
end;

function TxPLBody.Get_Strings: TStrings;
var i : integer;
begin
   fStrings.Assign(fKeys);
   if fControlInput then
      for i:= 0 to Pred(ItemCount) do
          fStrings[i] := fStrings[i] + '=' + Values[i];

   result := fStrings;
end;

procedure TxPLBody.Set_Strings(const AValue: TStrings);
begin
   RawxPL := AnsiReplaceStr(aValue.Text,#13,#10);
end;

function TxPLBody.GetValueByKey(const aKeyValue: string; const aDefVal : string = '') : string;
var i : integer;
begin
   i := Keys.IndexOf(aKeyValue);
   if i>=0 then result := Values[i]
           else result := aDefVal;
end;

procedure TxPLBody.SetValueByKey(const aKeyValue, aDefVal : string);
var i : integer;
begin
   i := Keys.IndexOf(aKeyValue);
   if i>=0 then Values[i] := aDefVal                                           // If the key is found, the value is set
           else AddKeyValuePair(aKeyValue,aDefVal);                            // else key added and value set
end;

procedure TxPLBody.AddKeyValuePairs(const aKeys, aValues : TStringList);
var i : integer;
begin
   for i := 0 to Pred(aKeys.Count) do AddKeyValuePair(aKeys[i],aValues[i]);
end;

procedure TxPLBody.AddKeyValuePairs(const aKeys, aValues: array of string);
var i : integer;
begin
   for i := Low(aKeys) to High(aKeys) do AddKeyValuePair(aKeys[i],aValues[i]);
end;

procedure TxPLBody.InsertKeyValuePair(const aIndex : integer; const aKey, aValue : string);
begin
   Keys.Insert(aIndex, aKey);
   Values.Insert(aIndex, aValue);
end;

procedure TxPLBody.AddKeyValuePair(const aKey, aValue: string);
begin
   Values[AppendItem(aKey)] := aValue;
end;

procedure TxPLBody.AddKeyValue(const aKeyValuePair: string);
var i : integer;
begin
   i := AnsiPos(K_BODY_ELMT_DELIMITER,aKeyValuePair);
   if i <> 0 then AddKeyValuePair( AnsiLowerCase(Copy(aKeyValuePair,0,i-1)) ,
                                   Copy(aKeyValuePair,i+1,length(aKeyValuePair)-i + 1));
end;

procedure TxPLBody.Append(const aBody: TxPLBody);
var i : integer;
begin
   for i:= 0 to pred(aBody.ItemCount) do AddKeyValuePair(aBody.Keys[i],aBody.Values[i]);
end;

procedure TxPLBody.Set_RawxPL(const AValue: string);
var sl : tstringlist;
    ch : string;
begin
   ResetValues;
   sl := TStringList.Create;
   sl.Delimiter:=#10;                                                          // use LF as delimiter
   sl.StrictDelimiter := true;
   sl.DelimitedText:=AnsiReplaceStr(aValue,#13,'');                            // get rid of CR
   for ch in sl do
      if length(ch)>0 then
         if fControlInput then AddKeyValue(ch)
                          else begin
                               Keys.Append(ch);
                               Values.Append('');
                          end;
   sl.free;
end;

// ============================================================================
initialization
   Classes.RegisterClass(TxPLBody);

end.
