program arbolb;

uses crt;

const
  Orden = 5;
  Max_claves = Orden - 1;
  Min_claves = (Orden div 2) -1;


type
  TElemento = record
    Id: Integer;
    Total: Double;

  end;

  PNodoArbolB = ^TNodoArbolB;
  TNodoArbolB = record
    Claves: array[1..Max_Claves] of TElemento;
    Hijos: array[0..Orden-1] of PNodoArbolB;
    EsHoja: Boolean;
    NumClaves: Integer;

  end;

  TArbolB = class
    private
    public
      Raiz: PNodoArbolB;

      function CrearNodo: PNodoArbolB;
      function EstaLleno(Nodo: PNodoArbolB): Boolean;

      procedure Insertar(Id: Integer; Total: Double);
      procedure DividirHijo(Padre: PNodoArbolB; IndiceHijo: Integer);
      procedure InsertarNoLleno(Nodo: PNodoArbolB; Elemento: TElemento);

      function Buscar(Id: Integer): TElemento;
      function BuscarRecursivo(Nodo: PNodoArbolB; Id: Integer): Telemento;


      procedure Mostrar;
      procedure MostrarRecursivo(Nodo: PNodoArbolB; Nivel: Integer);

      Constructor Create;

  end;


// -------------- CONSTRUCTOR -----------------
constructor TArbolB.Create;
begin
  Raiz := CrearNodo;

end;

function TArbolB.CrearNodo: PNodoArbolB;
var
  i: Integer;
begin
  New(Result);
  Result^.EsHoja := True;
  Result^.NumClaves := 0;
  for i := 0 to Orden-1 do
   Result^.Hijos[i] := nil;



end;


function TArbolB.EstaLleno(Nodo: PNodoArbolB): Boolean;
begin
  Result := Nodo^.NumClaves >= Max_Claves;

end;


// ---------------------- INSERTAR ------------------------
procedure TArbolB.Insertar(Id: Integer; Total: Double);
var
  NuevoElemento: TElemento;
  NuevaRaiz: PNodoArbolB;

begin
  NuevoElemento.ID := Id;
  NuevoElemento.Total := Total;

  if EstaLleno(Raiz) then
  begin
    NuevaRaiz := CrearNodo;
    NuevaRaiz^.EsHoja := False;
    NuevaRaiz^.Hijos[0] := Raiz;
    NuevaRaiz^.NumClaves := 0;
    DividirHijo(NuevaRaiz, 0);
    Raiz := NuevaRaiz;

  end;

  InsertarNoLleno(Raiz, NuevoElemento);



end;

// -------------------- DIVIDIR HIJO ---------------
procedure TArbolB.DividirHijo(Padre: PNodoArbolB; IndiceHijo: Integer);
var
  HijoCompleto, NuevoHijo: PNodoARbolB;
  ElementoMedio: TElemento;
  i, j: Integer;

begin
  HijoCompleto := Padre^.Hijos[IndiceHijo];

  NuevoHijo := CrearNodo;
  NuevoHijo^.EsHoja := HijoCompleto^.EsHoja;

  ElementoMedio := HijoCompleto^.Claves[Min_Claves + 1];

  NuevoHijo^.NumClaves := Max_Claves-(Min_Claves + 1);

  for i := 1 to NuevoHijo^.NumClaves do
  begin
    NuevoHijo^.Claves[i] := HijoCompleto^.Claves[i + Min_Claves + 1];

  end;

  if not HijoCompleto^.EsHoja then
  begin
    for i := 0 to NuevoHijo^.NumClaves do
    begin
      NuevoHijo^.Hijos[i] := HijoCompleto^.Hijos[i + Min_Claves + 1];
      HijoCompleto^.Hijos[i + Min_Claves + 1] := nil
    end;
  end;

  HijoCompleto^.NumClaves := Min_Claves;

  for i := Padre^.NumClaves + 1 downto IndiceHijo + 2 do
  begin
    Padre^.Hijos[i] := Padre^.Hijos[i-1];

  end;

  Padre^.Hijos[IndiceHijo + 1] := NuevoHijo;

  for i := Padre^.NumClaves downto IndiceHijo + 1 do
  begin
    Padre^.Claves[i+1] := Padre^.Claves[i];

  end;

  Padre^.Claves[IndiceHijo + 1] := ElementoMedio;
  Inc(Padre^.NumClaves);

end;


// ---------------------- INSERTAR NO LLENO --------------
procedure TArbolB.InsertarNoLleno(Nodo: PNodoArbolB; Elemento: TElemento);
var
  i: Integer;

begin
  i := Nodo^.NumClaves;

  if Nodo^.EsHoja then
  begin

    while(i >= 1) and (Elemento.Id < Nodo^.Claves[i].Id) do
    begin
      Nodo^.Claves[i + 1] := Nodo^.Claves[i];
      Dec(i);

    end;
  Nodo^.Claves[i+1] := Elemento;
  Inc(Nodo^.NumClaves);

  end
  else
  begin
    while(i >= 1) and (Elemento.Id < Nodo^.Claves[i].Id) do
    begin
      Dec(i);
    end;
    Inc(i);



    if EstaLleno(Nodo^.Hijos[i-1]) then
    begin
      DividirHijo(Nodo, i - 1);
      if Elemento.Id > Nodo^.Claves[i].Id then
      begin
        Inc(i);
      end;
    end;

    InsertarNoLleno(Nodo^.Hijos[i-1], Elemento);

  end;
end;

// -------------------- BUSCAR -------------------------

function TArbolB.Buscar(Id: Integer): TElemento;
begin
  Result := BuscarRecursivo(Raiz, Id);
end;


function TArbolB.BuscarRecursivo(Nodo: PNodoArbolB; Id: Integer): TElemento;
var
  i: Integer;
  ElementoNulo: TElemento;

begin

  i := 1;
  while (i <= Nodo^.NumClaves) and (Id > Nodo^.Claves[i].Id) do
  begin
    Inc(i)
  end;

  if (i <= Nodo^.NumClaves) and (Id = Nodo^.Claves[i].Id) then
  begin
    Result := Nodo^.Claves[i];
    Exit;
  end;

  if Nodo^.EsHoja then
  begin
    ElementoNulo.Id := -1;
    ElementoNulo.Total := 0.0;
    Result := ElementoNulo;
    Exit;
  end;

  Result := BuscarRecursivo(Nodo^.Hijos[i-1], Id);




end;


// -------------------- MOSTRAR ----------------------
procedure TArbolB.Mostrar;
begin
  Writeln('=== ÁRBOL B - ESTRUCTURA COMPLETA ===');
  MostrarRecursivo(Raiz, 0);
  Writeln('=====================================');
end;

procedure TArbolB.MostrarRecursivo(Nodo: PNodoArbolB; Nivel: Integer);
var
  i, j: Integer;
  Sangria: String;
begin
  if Nodo = nil then Exit;

  // Crear sangría para mostrar la estructura jerárquica
  Sangria := '';
  for i := 1 to Nivel * 3 do
    Sangria := Sangria + ' ';

  // Mostrar información del nodo
  Write(Sangria, 'Nivel ', Nivel, ': ');
  if Nodo^.EsHoja then
    Write('[HOJA] ')
  else
    Write('[INTERNO] ');

  // Mostrar las claves del nodo
  Write('Claves: [');
  for i := 1 to Nodo^.NumClaves do
  begin
    Write(Nodo^.Claves[i].Id);
    if i < Nodo^.NumClaves then
      Write(', ');
  end;
  Writeln(']');

  // Mostrar detalles de cada elemento
  if Nodo^.NumClaves > 0 then
  begin
    Write(Sangria, '        Detalles: [');
    for i := 1 to Nodo^.NumClaves do
    begin
      Write(Nodo^.Claves[i].Id, '=', Nodo^.Claves[i].Total:0:2);
      if i < Nodo^.NumClaves then
        Write(', ');
    end;
    Writeln(']');
  end;

  // Mostrar número de hijos si es nodo interno
  if not Nodo^.EsHoja then
  begin
    Writeln(Sangria, '        Hijos: ', Nodo^.NumClaves + 1);
  end;

  // Recorrer recursivamente los hijos
  if not Nodo^.EsHoja then
  begin
    for i := 0 to Nodo^.NumClaves do
    begin
      MostrarRecursivo(Nodo^.Hijos[i], Nivel + 1);
    end;
  end;
end;

var
  Arbol: TArbolB;
  Resultado: TElemento;


begin

  Arbol := TArbolB.Create;

  Arbol.Insertar(101, 150.75);
  Arbol.Insertar(205, 230.50);
  Arbol.Insertar(307, 175.25);
  Arbol.Insertar(409, 320.00);
  Arbol.Insertar(512, 195.80);

  Arbol.Insertar(102, 190.80);
  Arbol.Insertar(600, 185.80);
  Arbol.Insertar(700, 190.81);

  Resultado := Arbol.Buscar(99);

  if Resultado.Id <> -1 then
   writeln('Encontrado: ID=', Resultado.Id, ', Total=', Resultado.Total:0:2)
  else
    Writeln('No encontrado');



  Arbol.Mostrar;

  readkey;



end.

