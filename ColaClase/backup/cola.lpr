program cola;

uses crt;

type

  // Nodo
  PNodo = ^CNodo;
  CNodo = record
    dato: Integer;
    noombre: string;
    siguiente: PNodo;
  end;

  // Cola
  TCola = record
    primero: PNodo;
    ultimo: PNodo;
    tamano: Integer;
  end;


// Operaciones
procedure Inicializar(var cola: TCola);
begin
  cola.primero := nil;
  cola.ultimo := nil;
  cola.tamano := 0;

end;


procedure encolar(var cola: TCola; valor: integer; valorName: string);
var
  nuevoNodo: PNodo;
begin
  new(nuevoNodo);
  nuevoNodo^.dato := valor;
  nuevoNodo^.nombre := valorName;
  nuevoNodo^.siguiente := nil;

  if cola.ultimo = nil then
  begin
    cola.primero := nuevoNodo; //(nuevo) primero / ultimo
    cola.ultimo := nuevoNodo;

  end

  else
  begin
    cola.ultimo^.siguiente := nuevoNodo; //() primero / ultimo -> (nuevo)
    cola.ultimo := nuevoNodo     //() primero  -> (nuevo)  ultimo
  end;

  Inc(cola.tamano);

end;

function desencolar(var cola: TCola): Boolean;
var
  actual: PNodo; // Puntero Nodo

begin
  if (cola.primero = nil) then
   Exit(False); // Cola vacia

  actual := cola.primero;   // (actual) primero -> () -> () ultimo

  cola.primero := cola.primero^.siguiente; // (actual) primero -> () -> () ultimo
                                           // (actual) -> () primero -> () ultimo

  if (cola.primero = nil) then  // (actual)   -> nil primero / ultimo
   cola.ultimo := nil;

  Dispose(actual);
  Dec(cola.tamano);

  Result := True;


end;

procedure print(var cola: TCola);
var
  actual: PNodo;
begin
  actual := cola.primero;
  write('Cola (');
  while actual <> nil do
  begin
     write(actual^.dato);
     write(' ', actual^.nombre, ' <- ');
     actual := actual^.siguiente;

  end;
  writeln(')');
  writeln('Tamaño: ', cola.tamano);

end;




var
  miCola: TCola;


begin
  // Inicializar cola
  Inicializar(miCola);

  // Encolar
  Encolar(miCola, 5, 'Luis');
  Encolar(miCola, 10, 'Katy');
  Encolar(miCola, 15, 'Erick');

  // Imprimir
  print(miCola);


  // Desencolar
  if desencolar(miCola) <> True then
   writeln('Cola vacia');

  readkey;

   // Imprimir
  print(miCola);
  readkey;




end.

