unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type


  // Nodo para peliculas
  PNodoPelicula = ^TNodoPelicula;
  TNodoPelicula = record
    nombre: string;
    siguiente: PNodoPelicula;

  end;

  // Lista para peliculas
  TListaPeliculas = record
    cabeza: PNodoPelicula;
    tamano: integer;
  end;


  // Nodo para categorias
  PNodoCategoria = ^TNodoCategoria;
  TNodoCategoria = record
    nombre: string;
    peliculas: TListaPeliculas;
    siguiente: PNodoCategoria;

  end;

  // Lista para categorias
  TListaCategorias = record
    cabeza: PNodoCategoria;
    tamano: Integer;
  end;




  { TForm1 }

  TForm1 = class(TForm)
    ButtonAgregarCategoria: TButton;
    ButtonAgregarPelicula: TButton;
    ButtonMostrarTodo: TButton;
    ComboBoxCategorias: TComboBox;
    EditCategoria: TEdit;
    EditPelicula: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure ButtonAgregarCategoriaClick(Sender: TObject);
    procedure ButtonAgregarPeliculaClick(Sender: TObject);
    procedure ButtonMostrarTodoClick(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    listaCategorias: TListaCategorias;
    procedure ActualizarComboBox;
    procedure InicializarListaPeliculas(var lista: TlistaPeliculas);
    procedure InicializarListaCategorias(var lista: TListaCategorias);
    procedure InsertarCategoria(var lista: TlistaCategorias; nombre: string);
    procedure InsertarPeliculas(var lista: TListaPeliculas; nombre: string);
    function BuscarCategoria(lista: TlistaCategorias; nombre: string): PNodoCategoria;
    procedure MostrarCatalogoCompleto;
    procedure LiberarListaPeliculas(var lista: TListaPeliculas);
    procedure LiberarListaCategorias(var lista: TListaCategorias);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}




{ TForm1 }

procedure TForm1.ButtonAgregarCategoriaClick(Sender: TObject);
var
  nombreCategoria: string;
begin

  nombreCategoria := Trim(EditCategoria.Text);
  if nombreCategoria = '' then
  begin
    ShowMessage('Ingrese un nombre de categoria');
    Exit;
  end;

  if BuscarCategoria(listaCategorias, nombreCategoria) <> nil then
  begin
    ShowMessage('La categoria ya existe');
    Exit;
  end;

  InsertarCategoria(listaCategorias, nombreCategoria);
  ActualizarComboBox;
  EditCategoria.Clear;
  ShowMessage('Categoria agregada con exito');

end;

procedure TForm1.ButtonAgregarPeliculaClick(Sender: TObject);
var
  nombrePelicula, nombreCategoria: string;
  categoria: PNodoCategoria;

begin
  nombrePelicula := Trim(EditPelicula.Text);
  if nombrePelicula = '' then
  begin
    ShowMessage('Ingrese un nombre de pelicula');
    Exit;
  end;

  if ComboBoxCategorias.ItemIndex = -1 then
  begin
    ShowMessage('No hay categorias disponibles. Cree una categoria');
    Exit;

  end;

  nombreCategoria := ComboBoxCategorias.Items[ComboBoxCategorias.ItemIndex];
  categoria := BuscarCategoria(listaCategorias, nombreCategoria);


  InsertarPeliculas(categoria^.peliculas, nombrePelicula);
  EditPelicula.Clear;
  ShowMessage('Pelicula agregada a ''' + nombreCategoria + ''' con Exito');



end;

procedure TForm1.ButtonMostrarTodoClick(Sender: TObject);
begin
  MostrarCatalogoCompleto;

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  InicializarListaCategorias(listaCategorias);

end;

procedure TForm1.FormClose(Sender: TObject);
begin
  LiberarListaCategorias(listaCategorias);

end;


procedure TForm1.InicializarListaPeliculas(var lista: TListaPeliculas);
begin
  lista.cabeza := nil;
  lista.tamano := 0;

end;

procedure TForm1.InicializarListaCategorias(var lista: TListaCategorias);
begin
  lista.cabeza := nil;
  lista.tamano := 0;

end;


procedure TForm1.InsertarCategoria(var lista: TListaCategorias; nombre: string);
var
  nuevoNodo: PNodoCategoria;

begin
  new(nuevoNodo);
  nuevoNodo^.nombre := nombre;
  InicializarListaPeliculas(nuevoNodo^.peliculas);
  nuevoNodo^.siguiente := lista.cabeza; // (nuevoNodo) -> cabeza
  lista.cabeza := nuevoNodo;            // (nuevoNodo) cabeza ->
  Inc(lista.tamano);

end;

procedure TForm1.InsertarPeliculas(var lista: TListaPeliculas; nombre: string);
var
  nuevoNodo: PNodoPelicula;

begin
  new(nuevoNodo);
  nuevoNodo^.nombre := nombre;
  nuevoNodo^.siguiente := lista.cabeza;  // (nuevoNodo) -> cabeza
  lista.cabeza := nuevoNodo;             // (nuevoNodo) cabeza ->
  Inc(lista.tamano);


end;

function TForm1.BuscarCategoria(lista: TListaCategorias; nombre: string): PNodoCategoria;
var
  actual: PNodoCategoria;

begin
  actual := lista.cabeza;
  while actual <> nil do
  begin
    if actual^.nombre = nombre then
     Exit(actual);

    actual := actual^.siguiente;
  end;

  Result := nil;

end;

procedure TForm1.ActualizarComboBox;
var
  actual: PNodoCategoria;

begin
  ComboBoxCategorias.Clear;
  actual := listaCategorias.cabeza;
  while actual <> nil do
  begin
    ComboBoxCategorias.Items.Add(actual^.nombre);
    actual := actual^.siguiente;
  end;


  if ComboBoxCategorias.Items.Count > 0 then
    ComboBoxCategorias.ItemIndex := 0;



end;


procedure TForm1.MostrarCatalogoCompleto;
var
  actualCat: PNodoCategoria;
  actualPel: PnodoPelicula;

begin
  Memo1.Clear;
  if listaCategorias.tamano = 0 then
  begin
    Memo1.Lines.Add('No hay categorias registradas.');
    Exit;
  end;

  actualCat := listaCategorias.cabeza;
  while actualCat <> nil do
  begin
    Memo1.Lines.Add('===' + actualCat^.nombre + '===');

    if actualCat^.peliculas.tamano = 0 then
     Memo1.Lines.Add('No hay peliculas en esta categoria')
    else
    begin
      actualPel := actualCat^.peliculas.cabeza;
      while actualPel <> nil do
      begin
        Memo1.Lines.Add(' -' + actualPel^.nombre);
        actualPel := actualPel^.siguiente;
      end;


    end;

    Memo1.Lines.Add('');
    actualCat := actualCat^.siguiente;
  end;

end;


procedure TForm1.LiberarListaPeliculas(var lista: TListaPeliculas);
var
  actual, siguiente: PNodoPelicula;
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

procedure TForm1.LiberarListaCategorias(var lista: TListaCategorias);
var
  actual, siguiente: PNodoCategoria;

begin
  actual := lista.cabeza;
  while actual <> nil do
  begin
    siguiente := actual^.siguiente;
    LiberarListaPeliculas(actual^.peliculas);
    Dispose(actual);
    actual := siguiente;
  end;

  lista.cabeza := nil;
  lista.tamano := 0;




end;


end.

