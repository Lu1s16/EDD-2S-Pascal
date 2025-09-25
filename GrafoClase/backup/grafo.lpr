program grafos;

uses crt;

type

  // Nodo del grafo
  PNodoGrafo = ^TNodoGrafo;

  TNodoGrafo = record
    valor: string;
    siguiente: PNodoGrafo;
  end;



  edge = record
    origen: PNodoGrafo;
    destino: PNodoGrafo;
  end;


  Grafo = class
    private

    public
      root: PNodoGrafo;
      conexionesID: integer;
      conexiones: array of edge;

      constructor Create;
      procedure crearNodo(valor: string);
      procedure crearConexion(origen: string; destino: string);
      function buscarNodo(valor: string): PNodoGrafo;
      procedure RecorrerGrafo;

  end;



constructor Grafo.Create;
begin
  root := nil;
  conexionesID := 0;
  SetLength(conexiones, 100);

end;

procedure Grafo.crearNodo(valor: string);
var
  nuevoNodo: PNodoGrafo;
  actual: PNodoGrafo;
begin
  new(NuevoNodo);
  nuevoNodo^.valor := valor;
  nuevoNodo^.siguiente := nil;

  // Metodo para verificar que no este repetido nodo (extra)


  if root = nil then
  begin
    root := nuevoNodo;
  end
  else
  begin
    actual := root;
    while actual^.siguiente <> nil do
    begin
      actual := actual^.siguiente; // 1 -> 2 -> 3 ->
      // actual = 3
    end;

    actual^.siguiente := nuevoNodo;
    // 3 -> 4
  end;




end;

procedure Grafo.crearConexion(origen: string; destino: string);
var
  nodoInicio, nodoDestino: PNodoGrafo;
  conexion: edge;
begin

  nodoInicio := buscarNodo(origen);
  nodoDestino := buscarNodo(destino);

  if(nodoInicio = nil) or (nodoDestino = nil) then
  begin
    Writeln('Nodo inico o destino no existe');
    Exit
  end;

  conexion.origen := nodoInicio;
  conexion.destino := nodoDestino;


  conexiones[conexionesID] := conexion;

  Inc(conexionesID);



end;

procedure Grafo.RecorrerGrafo;
var
  actual: PNodoGrafo;
  i: integer;
begin

  // Imprimir nodos

  actual := root;
  while actual <> nil do
  begin
    // A [label = "Valor A"]
    Writeln('Valor del nodo ', actual^.valor);
    actual := actual^.siguiente;
  end;


  // Imprimir conexiones
  for i := 0 to conexionesID-1 do
  begin
    Writeln('Conexion: nodo inicio ', conexiones[i].origen^.valor, ' nodo destino: ', conexiones[i].destino^.valor);
  end;



end;


function Grafo.buscarNodo(valor: string): PNodoGrafo;
var
  actual: PNodoGrafo;

begin
  actual := root;

  while actual <> nil do
  begin
    if actual^.valor = valor then
    begin
      Exit(actual);
    end;

    actual := actual^.siguiente;

  end;

  Exit(nil);


end;

var
  miGrafo: Grafo;

begin

  miGrafo := Grafo.Create;

  miGrafo.crearNodo('A');
  miGrafo.crearNodo('B');
  miGrafo.crearNodo('C');
  miGrafo.crearNodo('D');
  miGrafo.crearNodo('G');

  miGrafo.crearConexion('A', 'B');
  miGrafo.crearConexion('A', 'G');
  miGrafo.crearConexion('B', 'D');
  miGrafo.crearConexion('B', 'C');
  miGrafo.crearConexion('G', 'D');





  miGrafo.RecorrerGrafo;

  readkey;

end.

