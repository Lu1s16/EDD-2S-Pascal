unit Ejemplo1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    bucle1: TButton;
    Label1: TLabel;
    procedure bucle1buton(Sender: TObject);
    procedure MostrarButton(Sender: TObject);
  private

  public

  end;

const
  edad: integer = 60;


var
  Form1: TForm1;
  nombre: string;
  apellido: string = 'Garcia';
  numero, a, sum: integer;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MostrarButton(Sender: TObject);
begin

  Label1.Caption := apellido;
  ShowMessage(intToStr(edad));

  if (edad = 40) then

     ShowMessage('Edad igual a 40')


  else if (edad <> 40) then
    ShowMessage('Edad no igual a 40')

  else
      showMessage('Edad');






end;

procedure TForm1.bucle1buton(Sender: TObject);
begin

  numero := 0;

  while (numero < 6) do
  begin
    numero := numero + 2;
    ShowMessage(intTostr(numero));

  end;

  for a:=10 to 12 do
  begin
    ShowMessage('Valor de a: ' + inttoStr(a));
  end;

  numero := 6;



  repeat
    sum:= sum + numero;
    numero := numero - 2;

    ShowMessage('Valor en repeat: ' + inttoStr(sum));

  until numero = 0;



end;

end.

