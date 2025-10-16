program lzw;

uses
 classes, SysUtils, crt;


type

  TDictionary = array of string;

  TCode = Word;
  TCodeArray = array of TCode;

  TCompresorLZW = class
    private

    public
      procedure Inicializar(var dict: TDictionary);
      function Buscar(const dict: TDictionary; const cadena: string): Integer;
      procedure Agregar(var dict: TDictionary; const cadena: string);

      function comprimir(const texto: string): TCodeArray;
      function descomprimir(const codigos: TCodeArray): string;


  end;

procedure TCompresorLZW.Inicializar(var dict: TDictionary);
var
  i: integer;

begin
  SetLength(dict, 256);

  for i := 0 to 255 do
    dict[i] := Chr(i);

end;



function TCompresorLZW.Buscar(const dict: TDictionary; const cadena: string): Integer;
var
  i: integer;

begin

  for i:= 0 to High(dict) do

    if dict[i] = cadena then
      Exit(i);


  Result := -1;

end;





procedure TCompresorLZW.Agregar(var dict: TDictionary; const cadena: string);
begin
  SetLength(dict, Length(dict) + 1);
  dict[high(dict)] := cadena;

end;



function TCompresorLZW.comprimir(const texto: string): TCodeArray;
var
  dict: TDictionary;
  entrada: string;
  caracter: Char;
  codigo: Integer;
  //El que usaremos por si viene una cadena nueva
  siguienteCodigo: Integer;
  i: Integer;
  //Codigos de la compresion
  resultado: array of tcode;

begin
  //1. Inicializar diccionario con caracteres ASCII
  Inicializar(dict);
  siguienteCodigo := 256;

  //Colocar size 0 a resulttado
  SetLength(resultado, 0);
  entrada := '';

  //Recorrer caracteres del texto
  for i := 1 to Length(texto) do
  begin
    caracter := texto[i];

    //Verificar si entrada + caracter esta en diccionario
    codigo := Buscar(dict, entrada + caracter);

    if codigo <> -1 then
    begin
      //Si existe, agregar otro caracter
      entrada := entrada + caracter;
    end
    else
    begin
      //Si existe, buscar el codigo para agregarlo a resultado
      codigo := Buscar(dict, entrada);
      if codigo <> -1 then
      begin
        //Agregar codigo al resultado
        SetLength(resultado, Length(resultado) + 1);
        resultado[High(resultado)] := codigo;

        // Agregar nueva entrada al diccionario
        if siguienteCodigo < 65536 then // Límite de 16 bits
        begin
          Agregar(dict, entrada + caracter);
          Inc(siguienteCodigo);
        end;


      end;

      // Reiniciar con el caracter actual
      entrada := caracter;

    end;
  end;

  // Agregar el último código
  if entrada <> '' then
  begin
    codigo := Buscar(dict, entrada);
    SetLength(resultado, Length(resultado) + 1);
    resultado[High(resultado)] := codigo;
  end;

  Result := resultado;

end;

function TCompresorLZW.descomprimir(const codigos: TCodeArray): string;
var
  dict: TDictionary;
  anterior, actual: string;
  codigoAnterior, codigoActual: TCode;
  i: Integer;
  siguienteCodigo: Integer;

begin

  Inicializar(dict);
  siguienteCodigo := 256;

  if Length(codigos) = 0 then
    Exit;


  //CodigoAnterior = 65
  codigoAnterior := codigos[0];
  //anterior = A
  anterior := dict[codigoAnterior];
  Result := anterior;


  for i := 0 to High(codigos) do
  begin
    //codigoActual = 67
    codigoActual := codigos[i];

    //Resultado = 65, 66, 67, 256, 68

    if codigoActual < Length(dict) then
      // Actual = B
      actual := dict[codigoActual]
    else if codigoActual = siguienteCodigo then
      actual := anterior + anterior[1]
    else
      raise Exception.Create('Error: Código inválido en compresión');
    //result = AB
    Result := Result + actual;

    if siguienteCodigo < 65536 then
    begin
      Agregar(dict, anterior + actual[1]);
      Inc(siguienteCodigo);
    end;

    //anterior = B
    anterior := actual;
    //Codigo actual = 66
    codigoAnterior := codigoActual;



  end;

end;


function CodigosAString(const codigos: TCodeArray): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to High(codigos) do
  begin
    if i > 0 then
      Result := Result + ',';
    Result := Result + IntToStr(codigos[i]);
  end;
end;


var
  compresor: TCompresorLZW;
  textoOriginal, textoDescomprimido: string;
  codigosComprimidos: TCodeArray;
  i: Integer;


begin

  // Ejemplo 1: Texto simple
  textoOriginal := 'ABCABCD';
  Writeln('=== EJEMPLO 1 ===');
  Writeln('Texto original: ', textoOriginal);

  codigosComprimidos := compresor.Comprimir(textoOriginal);

  Writeln('Códigos comprimidos: ', CodigosAString(codigosComprimidos));

  textoDescomprimido := compresor.Descomprimir(codigosComprimidos);
  Writeln('Texto descomprimido: ', textoDescomprimido);


  // Ejemplo 2: Texto con patrones repetitivos
  textoOriginal := 'TOBEORNOTTOBEORTOBEORNOT';
  Writeln('=== EJEMPLO 2 ===');
  Writeln('Texto original: ', textoOriginal);

  codigosComprimidos := compresor.Comprimir(textoOriginal);

  Writeln('Códigos comprimidos: ', CodigosAString(codigosComprimidos));

  textoDescomprimido := compresor.Descomprimir(codigosComprimidos);
  Writeln('Texto descomprimido: ', textoDescomprimido);


  // Ejemplo 3: Texto más largo
  textoOriginal := 'EL ALGORITMO LZW ES UN ALGORITMO DE COMPRESION MUY EFICIENTE';
  Writeln('=== EJEMPLO 3 ===');
  Writeln('Texto original: ', textoOriginal);

  codigosComprimidos := compresor.Comprimir(textoOriginal);

  Writeln('Primeros 10 códigos: ');
  for i := 0 to 30 do
    Write(codigosComprimidos[i], ' ');
  Writeln;

  textoDescomprimido := compresor.Descomprimir(codigosComprimidos);
  Writeln('Texto descomprimido: ', textoDescomprimido);

  // Ejemplo 4
  textoOriginal := 'UNUNUN';
  Writeln('=== EJEMPLO 4 ===');
  Writeln('Texto original: ', textoOriginal);

  codigosComprimidos := compresor.Comprimir(textoOriginal);
  Writeln('Códigos comprimidos: ', CodigosAString(codigosComprimidos));

  textoDescomprimido := compresor.Descomprimir(codigosComprimidos);
  Writeln('Texto descomprimido: ', textoDescomprimido);


  readkey;

  //UN


end.

