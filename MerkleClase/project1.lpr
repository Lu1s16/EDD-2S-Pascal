program Merkle;

uses
  Classes, SysUtils, fpjson, jsonparser, sha1, crt;



type
  //Clase favoritos
  TFavorito = class
    public
      Remitente: String;
      Asunto: String;
      Fecha: String;
      Mensaje: String;

      constructor Create(ARemitente, AAsunto, AFecha, AMensaje: string);
      function GetHash: string;
  end;


  // Nodo del arbol
  TMerkleNode = class
    public
      Hash: string;
      Left, Right: TMerkleNode;
      Favorito: TFavorito;

      //Funciones
      Constructor CreateLeaf(AFavorito: TFavorito); overload;
      Constructor CreateInternal(ALeft, ARight: TMerkleNode); overload;
      function CalculateHash(const LeftHash, RightHash: string): string;

  end;


  // Arbol
  TMerkleTree = class
    public
      Root: TMerkleNode;
      Leaves: TList; // Lista para nodos hoja

      constructor Create;
      destructor Destroy; override;
      procedure BuildTree;
      procedure Insert(ARemitente, AAsunto, AFecha, AMensaje: string);

      procedure View;
      procedure ViewRecursive(Curr: TMerkleNode);


  end;


// ---------------- FAVORITOS -----------------
constructor TFavorito.Create(ARemitente, AAsunto, AFecha, AMensaje: string);
begin
  Remitente := ARemitente;
  Asunto := AAsunto;
  Fecha :=  AFecha;
  Mensaje := AMensaje;

end;

function TFavorito.GetHash: String;
var
  JSON: TJSONObject;
  Data: String;
  Digest: TSHA1Digest;
  i: integer;

begin
  JSON := TJSONObject.Create;

  try
    JSON.Add('Remitente', Remitente);
    JSON.Add('Asunto', Asunto);
    JSON.Add('Fecha', Fecha);
    JSON.Add('Mensaje', Mensaje);

    Data := JSON.AsJSON;


  finally
    JSON.Free;
  end;

  Digest := SHA1String(Data);
  //Digest = [169, 153, 62, 212...]

  Result := '';

  for i := 0 to High(Digest) do
      Result := Result + LowerCase(IntToHex(Digest[i], 2));
      // Result = a995dse8d5f4fgrh4hgs8
end;

// ---------- Nodo ----------
constructor TMerkleNode.CreateLeaf(AFavorito: TFavorito);
begin
  Favorito := AFavorito;
  Hash := Favorito.GetHash;
  Left := nil;
  Right := nil;


end;

constructor TMerkleNode.CreateInternal(ALeft, ARight: TMerkleNode);
begin
  Favorito := nil;
  Left := ALeft;
  Right := ARight;

  if Assigned(ARight) then
    Hash := CalculateHash(ALeft.Hash, ARight.Hash)
  else
    Hash := CalculateHash(ALeft.Hash, ALeft.Hash);

end;

function TMerkleNode.CalculateHash(const LeftHash, RightHash: string): string;
var
  Combined: String;
  Digest: TSHA1Digest;
  i: integer;

begin
  Combined := LeftHash + RightHash;
  Digest := SHa1String(Combined);

  Result := '';

  for i := 0 to High(Digest) do
      Result := Result + LowerCase(IntToHex(Digest[i], 2));


end;

// --------- Arbol Merkle -----------
constructor TMerkleTree.Create;
begin
  Leaves := TList.Create;
  Root := nil;
end;

destructor TMerkleTree.Destroy;
begin
  Leaves.Free;
  inherited Destroy;

end;


procedure TMerkleTree.Insert(ARemitente, AAsunto, AFecha, AMensaje: string);
var
  Leaf: TMerkleNode;
  Fav: TFavorito;

begin
  Fav := TFavorito.Create(ARemitente, AAsunto, AFecha, AMensaje);

  Leaf := TMerkleNode.CreateLeaf(Fav);

  Leaves.Add(Leaf);

  BuildTree;


end;

procedure TMerkleTree.BuildTree;
var
  CurrentLevel, NextLevel: TList;
  i: Integer;
  Left, Right, Parent: TMerkleNode;

begin
  if Leaves.Count = 0 then
    begin
      Root := nil;
      Exit;
    end;

  CurrentLevel := TList.Create;

  try
    CurrentLevel.Assign(Leaves);

    while CurrentLevel.Count > 1 do
    begin
      NextLevel := TList.Create;

      for i := 0 to CurrentLevel.Count - 1 do
      begin

        if i mod 2 = 0 then
        begin
          Left := TMerkleNode(CurrentLevel[i]);

          if i + 1 < CurrentLevel.Count then
            Right := TMerkleNode(CurrentLevel[i+1])
          else
            Right := nil;

          Parent := TMerkleNode.CreateInternal(Left, Right);
          NextLevel.Add(Parent);

        end;
      end;

      CurrentLevel.Free;
      CurrentLevel := NextLevel;


    end;

    Root := TMerkleNode(CurrentLevel[0]);

  finally
    CurrentLevel.Free;
  end;




end;

procedure TMerkleTree.View;
begin
  ViewRecursive(root);


end;


procedure TMerkleTree.ViewRecursive(curr: TMerkleNode);
begin

  if curr.Left <> nil then
  begin
    viewRecursive(curr.Left);
  end;

  if curr.Favorito <> nil then
    writeln(curr.Favorito.Remitente)
  else
    writeln(curr.Hash);

  if curr.Right <> nil then
  begin
    viewRecursive(curr.Right);
  end;


end;



var
  MiArbol: TMerkleTree;

begin

  MiArbol := TMerkleTree.Create;

  MiArbol.Insert('Luis', 'Clase', '08/10/2025', 'No hay clase');
  MiArbol.Insert('Alejandra', 'Proyecto', '09/12/2025', 'EntregaProyecto');
  MiArbol.Insert('Enrique', 'Salida', '10/11/2025', 'Salir al cine');
  MiArbol.Insert('Enrique', 'Salida', '10/11/2025', 'Salir al cine');
  MiArbol.Insert('Enrique', 'Salida', '10/11/2025', 'Salir al cine');

  MiArbol.View;

  readKey;




end.

