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


procedure OrdenamientoBurbuja(var lista: TLista);
var
  n, i, j: integer;
  anterior, actual, siguiente, temp: PNodo;
  swapped: boolean;

begin

  n := lista.tamano;

  for i := 1 to n do
  begin
    actual := lista.cabeza;
    anterior := nil;
    siguiente := lista.cabeza^.siguiente;

    swapped := false;

    for j := 1 to n-1 do
    begin

      if siguiente <> nil then
      begin
        if actual^.dato > siguiente^.dato  then
        begin

             if anterior = nil then
             begin
             actual^.siguiente := siguiente^.siguiente;
             siguiente^.siguiente := actual;
             temp := actual;
             actual := siguiente;
             siguiente := temp;
             lista.cabeza := actual;




             end
        else
        begin
          anterior^.siguiente := siguiente;
          actual^.siguiente := siguiente^.siguiente;
          temp := actual;
          actual := siguiente;
          siguiente^.siguiente := temp;
          siguiente := temp;

          swapped := true;

        end;



      end;

        anterior := actual;
      actual := siguiente;
      siguiente := siguiente^.siguiente;



      end;







    end;
  end;



end;


var
  miLista: TLista;


begin

  Inicializar(miLista);



  InsertarFinal(miLista, 5);
  InsertarFinal(miLista, 6);
  InsertarFinal(miLIsta, 1);
  InsertarFinal(miLIsta, 3);

  Mostrar(miLista);

  OrdenamientoBurbuja(miLista);





  Mostrar(miLista);




  readkey;

end.

