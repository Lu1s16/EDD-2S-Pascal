program blockchain;

uses
  Classes, SysUtils, fpjson, jsonparser, sha1, crt, DCPsha256, DCPcrypt2;

type
  // Clase bloque que almacenara todos los datos.
  PBlock = ^TBlock;
  TBlock = record
    Index: integer;
    //Atributos del correo
    //ID, Remitente, Asunto, Mensaje
    ID: string;
    Nombre: string;
    Contrasenia: string;

    //Para reconocer el hash del bloque anterior
    PreviusHash: string;
    Hash: string;
    next: PBlock;
    prev: PBlock;
  end;

  //Clase blockchain
  TBlockchain = class
    private

    public
      head: PBlock;
      Tail: PBlock;
      Size: Integer;

      constructor Create;
      function Insertar(nombre, contrasenia: string): PBlock;
      procedure Imprimir;
      function GetSha256(str: string): string;

    end;


// Constructor para inicializar la estructura
constructor TBlockchain.Create;
begin
  head := nil;
  tail := nil;
  Size := 0;
end;


// Obtener el sha256 para almacenar en el hash del bloque
function TBlockchain.GetSHA256(str: string): string;
var
  Hash: TDCP_sha256;
  Digest: array[0..31] of Byte;
  i: Integer;
begin
  Hash := TDCP_sha256.Create(nil);
  try
    Hash.Init;
    Hash.UpdateStr(str);
    Hash.Final(Digest);

    Result := '';
    for i := 0 to 31 do
      Result := Result + LowerCase(IntToHex(Digest[i], 2));
  finally
    Hash.Free;
  end;
end;

//Insertar bloques en la estructura de blockchain
function TBlockchain.Insertar(nombre, contrasenia: sTring): PBlock;
var
  newBlock: PBlock;
  valor: string;
begin

  // Crear nuevo bloque
  New(newBlock);
  newBlock^.Index := Size;
  newBlock^.Nombre := nombre;
  newBlock^.Contrasenia := contrasenia;
  newBlock^.PreviusHash := '';
  newBlock^.Hash := '';
  newBlock^.next := nil;
  newBlock^.prev := nil;

  // Configurar PreviousHash
  if head = nil then
    newBlock^.PreviusHash := '0000'
  else
    newBlock^.PreviusHash := tail^.Hash;

  // Calcular Hash
  // Falta calcular timestamp
  valor := IntToStr(newBlock^.Index) + nombre + contrasenia + newBlock^.PreviusHash;
  newBlock^.Hash := GetSHA256(valor);

  // Insertar en la lista
  if head = nil then
  begin
    // newBlock (head, tail)
    head := newBlock;
    tail := newBlock;
  end
  else
  begin
    // (tail, head) <- newBlock
    newBlock^.prev := tail;
    // (tail, head) -> newBlock
    tail^.next := newBlock;
    // (head) <-> newBlock (tail)
    tail := newBlock;
  end;

  Inc(Size);
  Result := newBlock;
end;


procedure TBlockchain.Imprimir;
var
  temp: PBlock;
begin
  temp := head;

  while temp <> nil do
  begin
    Writeln('Index: ', temp^.Index);
    Writeln('Nombre: ', temp^.Nombre);
    Writeln('Contraseña: ', temp^.Contrasenia);
    Writeln('PreviusHash: ', temp^.PreviusHash);
    Writeln('Hash: ', temp^.Hash);
    Writeln('---------------------');

    temp := temp^.next;
  end;
end;



var
  blockch: TBlockchain;
begin

  blockch := TBlockchain.Create;
  try
    // Insertar bloques
    blockch.Insertar('Luis', '1234');
    blockch.Insertar('Ericka', 'micontraseña');
    blockch.Insertar('Jorge', 'clavesecreta');

    // Imprimir blockchain
    Writeln('=== BLOCKCHAIN COMPLETO ===');
    blockch.Imprimir;



  finally
    // Aquí deberías liberar la memoria de todos los bloques
    // Implementar un destructor para TBlockchain
    blockch.Free;
  end;

  Readln;
end.

