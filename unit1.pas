unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  firefly =class
  	period: double;
    lastperiod: double;
    lastfire: double;
    ontime: integer;
    syncwith: firefly;
    checkbox: TCheckbox;
    constructor create( period_, ontime_: integer; syncwith_: firefly; checkbox_: TCheckbox);
    procedure step();
  	end;

  TForm1 = class(TForm)
   Button1: TButton;
   Button2: TButton;
   Edit1: TEdit;
   Timer1: TTimer;
   procedure Button1Click(Sender: TObject);
   procedure Button2Click(Sender: TObject);
   procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1;
  checkboxes: array of TCheckbox;
  fireflies: array of firefly;

implementation

{ TForm1 }

constructor firefly.create( period_, ontime_: integer; syncwith_: firefly; checkbox_: TCheckbox);
	begin
    period:=period_;
    lastperiod:=period;
    lastfire:=0;
    ontime:=ontime_;
    syncwith:=syncwith_;
    checkbox:=checkbox_;
    end;

procedure firefly.step();
	begin
    lastfire:=lastfire+1;
    if (lastfire>=ontime) then
    	checkbox.checked:=false;
    if (lastfire>=period) then
    	begin
        checkbox.checked:=true;
        lastfire:=0;
        lastperiod:=period;
        end;



	if ((syncwith<>nil) and (syncwith.lastfire=0)) then
    	begin

		if ((lastfire/period)<=0.5) then
   			period:=period + (lastfire/2) +1
    	else
   			period:=period - ((period-lastfire)/2)+1;
        if (syncwith.period>2*period) then
        	period:=period*2;
        if (syncwith.period<period/2) then
        	period:=period / 2;

        end;

    end;


procedure createFirefly();
var i:integer; c: TCheckbox;
	begin
    i:=length(fireflies);
 	setlength(fireflies, i+1);

    c:= Tcheckbox.create(Form1);
 	c.parent:=form1;
    c.top:=i*15;

    if (i=0) then
    	fireflies[i]:=firefly.create(50+trunc(random()*20), 10, nil, c)
    else
		fireflies[i]:=firefly.create(50+trunc(random()*50), 10, fireflies[i-1], c);
    end;


procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
begin
randomize();
for i:= 0 to 20 do
	createfirefly();


end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 fireflies[0].period:=strtoint(edit1.text);
end;



procedure TForm1.Timer1Timer(Sender: TObject);
var i:integer;
	begin
    canvas.Rectangle(30,0,1000,1000);
    for i:=0 to length(fireflies)-1 do
    	begin
     	fireflies[i].step();
        canvas.textout(30, i*15, floattostr(fireflies[i].period));
        end;
	end;



initialization
  {$I unit1.lrs}

end.

