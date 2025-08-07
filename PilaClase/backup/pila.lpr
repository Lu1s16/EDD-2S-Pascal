program pila;

uses crt;

type
  // Nodo
  PNodo = ^PiNodo;
  PiNodo = record
    edad: integer;
    nombre: string;
    siguiente: PNodo;
  end;


  // Pila
  TPila = record
    top: PNodo;
    tamano: integer;
  end;


// Operaciones
procedure Inicializar(var pila: TPila);
begin
  pila.tamano := 0;
  pila.top := nil;


end;


// Push
procedure push(var pila: TPila; valorEdad: integer; valorName: string);
var
  nuevoNodo: PNodo;

begin
  new(nuevoNodo);
  nuevoNodo^.edad := valorEdad;
  nuevoNodo^.nombre := valorName;
  nuevoNodo^.siguiente := pila.top; // (nuevo) -> Top
  pila.top := nuevoNodo;           // (nuevo) top ->
  Inc(pila.tamano);

  // () top ->
  // (nuevo) -> () top
  // (nuevo) top -> ()

  // () top -> () -> ()


end;

// Pop
function pop(var pila: TPila): Boolean;
var
  temp: PNodo;

begin
  if(pila.top = nil) then
    Exit(False);

  temp := pila.top; // (temp) top -> () -> ()
  pila.top := pila.top^.siguiente; // (temp)  -> () top -> ()

  Dispose(temp);            // () top -> ()
  Dec(pila.tamano);

  Result := True;
end;

// Imprimir
function print(var pila: TPila): Boolean;
var
  actual: PNodo;

begin
  if(pila.top = nil) then
    Exit(False);

  actual := pila.top;
  write('Pila: (');
  while (actual <> nil) do
  // () top -> () -> () -> actual
  begin
    write(actual^.nombre, ' ', actual^.edad, '<-');
    actual := actual^.siguiente;
  end;

  writeln(')');
  writeln('Tamaño: ', pila.tamano);

  Result := True;

end;

var
  miPila: TPila;


begin
   inicializar(miPila);

   push(miPila, 21, 'Manuel');
   push(miPila, 31, 'Josue Sanchez');
   push(miPila, 25, 'Fernando');

   if not print(miPila) then
     writeln('Pila Vacia');

   readkey;


end.

