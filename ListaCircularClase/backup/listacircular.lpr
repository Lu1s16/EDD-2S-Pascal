program listacircular;

uses crt;

type

  TDato = Integer;

  PNodo = ^TNodo;
  TNodo = record
    dato: TDato;
    siguiente: PNodo;
  end;

  TListaCircular = record
    ultimo: PNodo;
    tamano: Integer;
  end;


// Operaciones

procedure Inicializar(var lista: TListaCircular);
begin
  lista.ultimo := nil;
  lista.tamano := 0;

end;


function ListaVacia( var lista: TListaCircular): Boolean;
begin
  Result := (lista.ultimo = nil);


end;


// Insertar
procedure Insertar(var lista: TListaCircular; valor: TDato);
var
  nuevoNodo: PNodo;

begin
  new(nuevoNodo);
  nuevoNodo^.dato := valor;

  if listaVacia(lista) then
  begin
    nuevoNodo^.siguiente := nuevoNodo; //(nuevo) -> (nuevo)
    lista.ultimo := nuevoNodo;         // (nuevo) ultimo -> (nuevo) ultimo
  end
  else
  begin
    nuevoNodo^.siguiente := lista.ultimo^.siguiente;
    lista.ultimo^.siguiente := nuevoNodo;


  end;

  Inc(lista.tamano);


end;


// Eliminar un nodo
function Eliminar(var lista: TListaCircular; valor: TDato): Boolean;
var
  actual, anterior: PNodo;
  encontrado: Boolean;

begin

  if listaVAcia(lista) then
    Exit(False);


  actual := lista.ultimo^.siguiente;
  anterior := lista.ultimo;


  repeat
    if actual^.dato = valor then
    begin
      encontrado := True;
      Break;
    end;
    anterior := actual;
    actual := actual^.siguiente;


  until actual = lista.ultimo^.siguiente;


  if not encontrado then
   Exit(False);

  anterior^.siguiente := actual^.siguiente;

  if actual = actual^.siguiente then
    lista.ultimo := nil

  else if actual = lista.ultimo then
     lista.ultimo := anterior;


  Dispose(actual);
  Dec(lista.tamano);
  Result := True;


end;

// Buscar elemento
function Buscar(var lista: TListaCircular; valor: TDato): Boolean;
var
  actual: PNodo;

begin
  if ListaVacia(lista) then
    Exit(False);

  actual := lista.ultimo^.siguiente;


  repeat

    if actual^.dato = valor then
      Exit(True);

    actual := actual^.siguiente;

  until actual = lista.ultimo^.siguiente;

  Result := False;


end;


// Mostrar lista
procedure MostrarLista(var lista: TListaCircular);
var
  actual: PNodo;

begin
  if ListaVacia(lista) then
  begin
    Writeln('Lista Vacia');
    Exit;
  end;

  actual := lista.ultimo^.siguiente;
  Write('LIsta circular: (');

  repeat
    Write(actual^.dato);
    actual := actual^.siguiente;

    if actual <> lista.ultimo^.siguiente then
      Write(', ');


  until actual = lista.ultimo^.siguiente;


  writeln(')');
  writeln('Tamaño: ', lista.tamano);

end;


// Liberar memoria
procedure LiberarLista(var lista: TListaCircular);
var
  actual, siguiente, inicio: PNodo;
begin
  if ListaVacia(lista) then
    Exit;

  inicio := lista.ultimo^.siguiente;
  actual := inicio;

  repeat
    siguiente := actual^.siguiente;
    Dispose(actual);
    actual := siguiente;
  until actual = inicio;

  lista.ultimo := nil;
  lista.tamano := 0;
end;

var
  miLista: TListaCircular;
begin
  // Inicializar lista
  Inicializar(miLista);

  // Insertar elementos
  Insertar(miLista, 10);
  Insertar(miLista, 20);
  Insertar(miLista, 5);
  Insertar(miLista, 30);

  // Mostrar lista
  MostrarLista(miLista);
  // Salida esperada: Lista circular: [5, 10, 20, 30]
  //                  Tamaño: 4

  // Buscar elemento
  if Buscar(miLista, 20) then
    Writeln('20 está en la lista')
  else
    Writeln('20 NO está en la lista');

  // Eliminar elemento
  if EliminarNodo(miLista, 10) then
    Writeln('10 eliminado correctamente')
  else
    Writeln('10 no encontrado');

  // Mostrar lista después de eliminar
  MostrarLista(miLista);
  // Salida esperada: Lista circular: [5, 20, 30]
  //                  Tamaño: 3

  // Liberar memoria
  LiberarLista(miLista);
  readkey;
end.



begin

end.

