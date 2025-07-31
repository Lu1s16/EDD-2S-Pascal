program listasimple;
uses crt;

type

  TDato = Integer;

  // Nodo
  PNodo = ^TNodo;

  TNodo = record
    dato: TDato;
    //nombre: string;
    //edad: integer;
    siguiente: PNodo;
  end;


  // Lista
  TLista = record
    cabeza: PNodo;
    tamano: Integer;
  end;


// Inicializar la lista
procedure Inicializar(var lista: TLista);
begin
  lista.cabeza := nil;
  lista.tamano := 0;

end;

// Insertar los nodos
procedure InsertarInicio(var lista: TLista; valor: TDato);
var
  nuevoNodo: PNodo;

begin
  new(nuevoNodo);
  nuevoNodo^.dato := valor;
  nuevoNodo^.siguiente := lista.cabeza;
  lista.cabeza := nuevoNodo;
  Inc(lista.tamano);


end;

procedure InsertarFinal(var lista: TLista; valor: TDato);
var
  nuevoNodo, actual : PNodo;

begin
  new(nuevoNodo);
  nuevoNodo^.dato := valor;
  nuevoNodo^.siguiente := nil;


  if lista.cabeza = nil then
   lista.cabeza := nuevoNodo
  else
  begin

    actual := lista.cabeza;
    while actual^.siguiente <> nil do
      actual := actual^.siguiente;
    actual^.siguiente := nuevoNodo;

  end;

  Inc(lista.tamano);

end;


function Eliminar(var lista: TLista; valor: TDato): Boolean;
var
  actual, anterior : PNodo;

begin
  actual := lista.cabeza;
  anterior := nil;

  while(actual <> nil) and (actual^.dato <> valor) do
  begin
    anterior := actual;
    actual := actual^.siguiente;

  end;


  if actual = nil then
   Exit(False);   // No encontro el valor


  if anterior = nil then
   lista.cabeza := actual^.siguiente
   else
     anterior^.siguiente := actual^.siguiente;


  Dispose(actual);
  Dec(lista.tamano);
  Result := True;



end;



function Buscar(lista: TLista; valor: TDato): Boolean;
var
  actual: PNodo;

begin
  actual := lista.cabeza;
  while actual <> nil do
  begin
    if actual^.dato = valor then
     Exit(True);
    actual := actual^.siguiente;
  end;


  Result := False;
end;


procedure Mostrar(lista: TLista);
var
  actual: PNodo;

begin
  actual := lista.cabeza;
  Write('Lista simple(');

  while actual <> nil do
  begin
    write(actual^.dato);
    if actual^.siguiente <> nil then
     write(', ');

    actual := actual^.siguiente;
  end;

  write(')');
  Writeln('Tamano:', lista.tamano);

end;

procedure LiberarLista(var lista: TLista);
var
  actual, siguiente: PNodo;

begin
  actual := lista.cabeza;

  while actual <> nil do
  begin
    siguiente := actual^.siguiente;
    Dispose(actual);
    actual := siguiente;

  end;

  lista.cabeza := nil;
  lista.tamano := 0;


end;




var
  miLista: TLista;


begin

  Inicializar(miLista);


  InsertarInicio(miLista, 10);
  InsertarInicio(miLista, 23);
  InsertarInicio(miLista, 5);
  InsertarInicio(miLista, 60);

  Mostrar(miLista);

  InsertarFinal(miLista, 100);
  InsertarFinal(miLista, 44);
  InsertarFinal(miLIsta, 80);
  InsertarFinal(miLIsta, 20);

  Mostrar(miLista);

  if Buscar(miLista, 20) then
   Writeln('El 20 si esta en la lista')

  else
   writeln('El 20 no esta en la lista');


  if Eliminar(miLista, 11) then
   writeln('11 fue eliminado correctamente')
  else
   writeln('11 no fue eliminado porqu no existe');




  readkey;

end.

