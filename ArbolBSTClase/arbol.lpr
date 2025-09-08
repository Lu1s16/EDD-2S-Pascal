program arbol;

uses crt;

type

  // Nodo
  PTNode = ^TNode;
  TNode = record
    ID: integer;
    right: PTNode;
    left: PTNode;
  end;

  // Arbol
  Tree = class
    private

    public
      root: PTNode;

      // Creacion
      constructor Create;
      procedure Agregar(id: Integer);
      procedure recursive(curr: PTnode; newNode: PTnode);

      // Destructor
      destructor Destroy; override;
      procedure LiberarArbol(nodo: PTnode);

      // Recorridos y busqueda
      function Buscar(id: Integer): Boolean;
      procedure RecorridoInOrder;
      procedure RecorridoPreOrder;
      procedure RecorridoPostOrder;

      procedure inOrderRecursive(curr: PTNode);
      procedure preOrderRecursive(curr: PTNode);
      procedure postOrderRecursive(curr: PTNode);
  end;


// ---------------------- CREACION ------------------
constructor Tree.Create;
begin
  root := nil;

end;

procedure Tree.Agregar(id: Integer);
var
  node: PTNode;
begin
  new(node);
  node^.ID := id;
  node^.right := nil;
  node^.left := nil;

  if root = nil then
  begin
    root := node;
  end

  else
  begin
    recursive(root, node);
  end;

end;


procedure Tree.recursive(curr: PTNode; newNode: PTNode);
begin

  if newNode^.ID < curr^.ID then
  begin
    if curr^.left <> nil then
    begin
      recursive(curr^.left, newNode);
    end

    else
    begin
      curr^.left := newNode;
    end;
  end

  else if newNode^.ID > curr^.ID then
  begin
    if curr^.right <> nil then
    begin
      recursive(curr^.right, newNode);
    end

    else
    begin
      curr^.right := newNode;
    end;
  end
  // Por si ya existe el nodo
  else
  begin
    Writeln('El valor ya esta en el arbol');
    Dispose(newNode);

  end;


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

  // Curr: 70

  if curr^.left <> nil then
  begin

    inOrderRecursive(curr^.left);
  end;

  // Mostrando: 20, 30, 40, 50

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

  // Curr: 50, 40

  // Mostrando: 50, 30 , 20 , 40

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

  // Curr: 50, 70, 80



  if curr^.left <> nil then
  begin
    postOrderRecursive(curr^.left);
  end;


  if curr^.right<> nil then
  begin
    postOrderRecursive(curr^.right);
  end;

  // Mostrar: 20, 40, 30, 60, 80, 70, 50

  // Mostrar el nodo
  writeln('Nodo: ', curr^.ID);


end;

var
  miArbol: Tree;
begin

  miArbol := Tree.Create;

  // Agregar elementos
  miArbol.Agregar(50);
  miArbol.Agregar(30);
  miArbol.Agregar(70);
  miArbol.Agregar(20);
  miArbol.Agregar(40);
  miArbol.Agregar(60);
  miArbol.Agregar(80);

  // Insertar repetido
  miArbol.Agregar(70);

  writeln('Recorrido In Order');
  miArbol.RecorridoInOrder;
  writeln('------');

  writeln('Recorrido Pre Order');
  miArbol.RecorridoPreOrder;
  writeln('------');

  writeln('Recorrido Post Order');
  miArbol.RecorridoPostOrder;
  writeln('------');

  if miArbol.Buscar(40) then
  begin
    writeln('Si existe');
  end;
  readkey;




end.

