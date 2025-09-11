program arbolavl;

uses crt;

type

  //Nodo
  PTNode = ^TNode;
  TNode = record
    ID: integer;
    nombre: string;
    edad: integer;

    left: PTNode;
    right: PTNode;

    Height: Integer;
  end;

  // Arbol
  Tree = class
    private

    public
      root: PTNode;

      // Creacion
      constructor Create;

      // Insertar
      procedure Agregar(id: Integer; nombreValor: string; edadValor: integer);
      function recursive(item: PTNode; node: PTnode): PTNode;
      function getHeight(node: PTNode): Integer;
      function getMaxHeight(leftNOde: Integer; rightNode: Integer): Integer;

      // Rotaciones
      function rotateleft(node1: PTnode): PTnode;
      function rotateright(node2: PTnode): PTnode;
      function doubleleft(node: PTnode): PTnode;
      function doubleright(node: PTnode): PTnode;

      // Destructor
      destructor Destroy; override;
      procedure LiberarArbol(nodo: PTnode);

      // Recorridos
      Procedure RecorridoInOrder;
      procedure RecorridoPreOrder;
      procedure RecorridoPostOrder;

      procedure inOrderRecursive(curr: PTNode);
      procedure preOrderRecursive(curr: Ptnode);
      procedure postOrderRecursive(curr: PTnode);

      function Buscar(id: Integer): Boolean;
  end;

constructor Tree.Create;
begin
  root := nil;
end;


procedure Tree.Agregar(id: Integer; nombreValor: string; edadValor: integer);
var
  node: PTnode;
begin
  new(node);
  node^.ID := id;
  node^.nombre := nombreValor;
  node^.edad := edadValor;
  node^.right := nil;
  node^.left := nil;
  node^.height := 0;

  root := Recursive(node, root);

end;

function Tree.getHeight(node: PTnode): Integer;
begin

  if node = nil then
  begin
    Exit(-1)
  end
  else
  begin
    Exit(node^.height)
  end;


end;

function Tree.getMaxHeight(leftNode: Integer; rightNode: Integer): Integer;
begin
  if leftNode > RightNode then
    Exit(leftNode)
  else
    Exit(rightNode);

end;

function Tree.recursive(item: PTnode; node: PTnode): PTnode;
begin

  if(node = nil) then
  begin
    node := item;
  end


  // Insertar lado izquierdo
  else if item^.ID < node^.ID then
  begin
    node^.left := recursive(item, node^.left);

    //Rotaciones
    if GetHeight(node^.right) - GetHeight(node^.left) = 2 then
    begin
      if item^.ID < node^.left^.ID then
       node := rotateRight(node)
      else
        node := doubleRight(node);
    end;

  end

  // Insertar a la derecha
  else if item^.ID > node^.ID then
  begin
    node^.right := recursive(item, node^.right);

    // Rotaciones
    if GetHeight(node^.right) - GetHeight(node^.left) = 2 then
    begin
      if item^.ID > node^.right^.ID then
       node := rotateleft(node)

      else
       node := doubleleft(node)
    end;
  end

  else
   Writeln('Elemento ya existe en el arbol');

  node^.height := getMaxHeight( GetHeight(node^.left), GetHeight(node^.right)) + 1;
  Exit(node);


end;


// Rotaciones
function Tree.rotateright(node2: PTnode): PTnode;
var
  node1: PTnode;
begin
  node1 := node2^.left;
  node2^.left := node1^.right;
  node1^.right := node2;

  node2^.height := getMaxHeight( GetHeight(node2^.left), GetHeight(node2^.right)) + 1;
  node1^.height := getMaxHeight( GetHeight(node1^.left), node2^.Height) + 1;

  Exit(node1);
end;

function Tree.rotateleft(node1: PTnode): PTnode;
var
  node2: PTnode;
begin
  node2 := node1^.right;
  node1^.right := node2^.left;
  node2^.left := node1;

  node1^.height := getMaxHeight( getHeight(node1^.left), getHeight(node1^.right) ) + 1;
  node2^.height := getMaxHeight( getHeight(node2^.right), node1^.height) + 1;

  Exit(node2);

end;

function Tree.doubleright(node: PTnode): PTnode;
begin
  node^.right := rotateLeft(node^.right);
  Exit(node);
end;

function Tree.doubleleft(node: PTnode): PTnode;
begin
  node^.left := rotateright(node^.left);
  Exit(node);
end;

// ------------------ Destructor ------------
destructor Tree.Destroy;
begin
  LiberarArbol(root);
  inherited Destroy;

end;

procedure Tree.LiberarArbol(nodo: PTNode);
begin
  if nodo <> nil then
  begin
    LiberarArbol(nodo^.left);
    LIberarArbol(nodo^.right);
    Dispose(nodo);
  end;

end;

// --------------------- Busqueda -------------
function Tree.Buscar(id: Integer): Boolean;
var
  actual: PTNode;
begin
  actual := root;

  while actual <> nil do
  begin
    if id = actual^.ID then
     Exit(True)
    else if id < actual^.ID then
     actual := actual^.left
    else
     actual := actual^.right;

  end;
  Result := False;

end;

// -------------------- Recorrido InOrden --------------
procedure Tree.RecorridoInOrder;
begin
  inOrderRecursive(root);

end;


procedure Tree.inOrderRecursive(curr: PTNode);
begin



  if curr^.left <> nil then
  begin

    inOrderRecursive(curr^.left);
  end;

  // Mostrar el nodo
  writeln('Nodo: ', curr^.ID);

  if curr^.right<> nil then
  begin
    inOrderRecursive(curr^.right);
  end;


end;

// ------------------ Recorrido PreOrder ----------------
procedure Tree.RecorridoPreOrder;
begin
  preOrderRecursive(root);

end;


procedure Tree.preOrderRecursive(curr: PTNode);
begin

  // Mostrar el nodo
  writeln('Nodo: ', curr^.ID);

  if curr^.left <> nil then
  begin
    preOrderRecursive(curr^.left);
  end;


  if curr^.right<> nil then
  begin
    preOrderRecursive(curr^.right);
  end;


end;


// ---------------- Recorrido PostOrder -----------
procedure Tree.RecorridoPostOrder;
begin
  postOrderRecursive(root);

end;


procedure Tree.postOrderRecursive(curr: PTNode);
begin

  if curr^.left <> nil then
  begin
    postOrderRecursive(curr^.left);
  end;


  if curr^.right<> nil then
  begin
    postOrderRecursive(curr^.right);
  end;


  // Mostrar el nodo
  writeln('Nodo: ', curr^.ID);


end;


var
  miArbol: Tree;


begin
  miArbol := Tree.Create;

  miArbol.Agregar(1, 'Luis', 22);
  miArbol.Agregar(2, 'Anderson', 23);
  miArbol.Agregar(3, 'Enrique', 25);
  miArbol.Agregar(4, 'Glendy', 26);
  miArbol.Agregar(5, 'Saul', 22);
  miArbol.Agregar(6, 'Mayelin', 21);
  miArbol.Agregar(7, 'Jorge', 20);

  miArbol.Agregar(4, 'Marcos', 22);

  writeln('Recorrido In Order');
  miArbol.RecorridoInOrder;
  writeln('------');

  writeln('Recorrido Pre Order');
  miArbol.RecorridoPreOrder;
  writeln('------');


  writeln('Recorrido Post Order');
  miArbol.RecorridoPostOrder;
  writeln('------');



  readkey;




end.

