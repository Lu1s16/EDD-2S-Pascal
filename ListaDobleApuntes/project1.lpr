program ListaDoble;

uses crt;

// 1. Definir los tipos que vamos a utilizar

type
  TDato = Integer;  // -> Dar un nombre al tipo de dato

  // Crear el nodo
  PNodo = ^TNodo;    // -> Esto es un apuntador que solo puede referenciar a datos tipo TNodo
  TNodo = record
    dato: TDato;     // -> Dato del nodo
    nombre: string;  // -> Dato del nodo
    anterior: PNodo;
    siguiente: PNodo;
  end;


  // Crear la lista
  TListaDoble = record
    cabeza: PNodo;
    Cola: PNodo;
    tamano: Integer;
  end;


// 2. Inicializar la lista
procedure InicializarLista(var lista: TListaDoble);

begin
  // Inicializamos las variables.
  lista.cabeza := nil;
  lista.cola := nil;
  lista.tamano := 0;
end;


// 3. Insertar al inicio
procedure InsertarAlInicio(var lista: TListaDoble; valor: TDato; name: string);
var
 nuevoNodo: PNodo; //Variable que usaremos en este procedure
begin
  new(nuevoNodo); // REservamos memoria para el nodo a crear
  nuevoNodo^.dato := valor; // -> a lo que estaba apuntando neuvoNodo.dato ahora apunta a valor
  nuevoNodo^.nombre := name; // -> lo mismo que lo anterior
  nuevoNodo^.anterior := nil;
  nuevoNodo^.siguiente := lista.cabeza;

  if lista.cabeza <> nil then // Si cabeza no es nil
   lista.cabeza^.anterior := nuevoNodo
  else
    lista.cola := nuevoNodo; // LIsta vacia


  lista.cabeza := nuevoNodo;
  Inc(lista.tamano);
end;


// 4. Insertar al final
procedure InsertarAlFinal(var lista: TListaDoble; valor: TDato; name: string);
var
 nuevoNodo: PNodo;
begin
  new(nuevoNodo);
  nuevoNodo^.dato := valor;
  nuevoNodo^.nombre := name;
  nuevoNodo^.siguiente := nil;
  nuevoNodo^.anterior := lista.cola;

  if lista.cola <> nil then
   lista.cola^.siguiente := nuevoNodo
  else
    lista.cabeza := nuevoNodo; // Lista vacia

  lista.cola := nuevoNodo;
  Inc(lista.tamano);
end;

// 5. Eliminar por valor
function EliminarNodo(var lista: TListaDoble; valor: TDato): Boolean; // -> retornada boolean
var
 actual: PNodo;

begin
 actual := lista.cabeza; // -> Empezamos por nodo cabeza


 // Recorrer los nodos
 while (actual <> nil) and (actual^.dato <> valor) do
  actual := actual^.siguiente; // Pasamos al siguiente nodo


 if actual = nil then
  Exit(False); // No se encontro

 // Reajustar los punteros
 if actual^.anterior <> nil then
  actual^.anterior^.siguiente := actual^.siguiente
 else
   lista.cabeza := actual^.siguiente; // Nodo a eliminar es cabeza

 if actual^.siguiente <> nil then // Para cola
  actual^.siguiente^.anterior := actual^.anterior
 else
   lista.cola := actual^.anterior;

 // Liberar memoria
 Dispose(actual);
 Dec(lista.tamano);
 Result := True;

end;



// 6. Buscar nodo
function Buscar(lista: TListaDoble; valor: TDato): Boolean;
var
  actual: PNodo;
begin
  // Búsqueda optimizada (puede comenzar por cabeza o cola según convenga)
  actual := lista.cabeza;    // Empezamos a recorrer por cabeza
  while actual <> nil do
  begin
    if actual^.dato = valor then // Si se cumple encontro el nodo
      Exit(True);
    actual := actual^.siguiente;  // Si no pasa al siguiente
  end;
  Result := False;    // No se encontro
end;


// 7. Mostrar de inicio a fin
procedure MostrarListaAdelante(lista: TListaDoble);
var
  actual: PNodo;
begin
  actual := lista.cabeza; // Empezamos en cabeza
  Write('Lista (adelante): [');
  while actual <> nil do
  begin
    Write(actual^.dato);
    Write(' ' + actual^.nombre);
    if actual^.siguiente <> nil then  // Significa que hay otro nodo adelante
      Write(', ');
    actual := actual^.siguiente;  // Pasa al siguiente
  end;
  Writeln(']');
  Writeln('Tamaño: ', lista.tamano);
end;


// Mostrar de fin a inicio
procedure MostrarListaAtras(lista: TListaDoble);
var
  actual: PNodo;
begin
  actual := lista.cola;
  Write('Lista (atrás): [');
  while actual <> nil do
  begin
    Write(actual^.dato);
    if actual^.anterior <> nil then
      Write(', ');
    actual := actual^.anterior;
  end;
  Writeln(']');
end;


// LIberar memoria para cuando cerremos el programa
procedure LiberarLista(var lista: TListaDoble);
var
  actual, siguiente: PNodo;
begin
  actual := lista.cabeza;   // Empezamos en cabeza
  while actual <> nil do
  begin
    siguiente := actual^.siguiente;
    Dispose(actual);          // Eliminamos actual
    actual := siguiente;      // Actual sera el siguiente
    // Para validar si actual es nil o es otro nodo
  end;
  lista.cabeza := nil;
  lista.cola := nil;
  lista.tamano := 0;
end;



var
  miLista: TListaDoble;
begin
  // Inicializar lista
  InicializarLista(miLista);

  // Insertar elementos
  InsertarAlFinal(miLista, 10, 'Luis');
  InsertarAlFinal(miLista, 20, 'Jorge');
  InsertarAlInicio(miLista, 5, 'Pedro');
  InsertarAlFinal(miLista, 30, 'Paola');

  // Mostrar lista en ambos sentidos
  MostrarListaAdelante(miLista);
  MostrarListaAtras(miLista);

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
  MostrarListaAdelante(miLista);
  MostrarListaAtras(miLista);

  // Liberar memoria
  LiberarLista(miLista);

  readkey;

end.



