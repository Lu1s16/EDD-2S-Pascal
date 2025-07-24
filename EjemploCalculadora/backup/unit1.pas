unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Operar: TButton;
    Num1: TEdit;
    Num2: TEdit;
    Result: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Resta: TRadioButton;
    Multiplicacion: TRadioButton;
    Division: TRadioButton;
    Suma: TRadioButton;
    procedure OperarButton(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  numero1, numero2, resultado: Double;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.OperarButton(Sender: TObject);
begin

  if (Num1.Text = '') or (Num2.Text = '') then
  begin
    ShowMessage('Por favor ingrese ambos números');
    Exit;
  end;

  try
    numero1:= StrToFloat(Num1.Text);
    numero2:= StrToFloat(Num2.Text);

    if (Suma.Checked) then
       resultado := numero1 + numero2
    else if (Resta.Checked) then
       resultado := numero1 - numero2
    else if (Multiplicacion.Checked) then
       resultado := numero1 * numero2
    else if (Division.Checked) then
    begin
      if numero2 = 0 then
       begin
         ShowMessage('No se puede divir entre 0');
         Exit;
       end;
       resultado := numero1 / numero2;
    end

    else
    begin
      ShowMessage('Seleccione una operación');
      Exit;
    end;



    Result.Caption := 'Resultado: ' + FormatFloat('0.####', resultado);



  except
    on E: EConvertError do
       ShowMessage('Error al convertir');

  end;

end;

end.

