with Ada;
use Ada;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with Ada.Text_IO.Text_Streams;
use Ada.Text_IO.Text_Streams;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure Strum is
   Plik     : File_Type;
   Nazwa    : String := "matrix.txt";
   Strumien : Stream_Access;

   G: Generator;

   -- zdefiniowanie typu tablicy dwuwymiarowej
   type Matrix is array(Integer range <>, Integer range <>) of Float;


   procedure Read (S: access Root_Stream_Type'Class; M: out Matrix);
   procedure Write (S: access Root_Stream_Type'Class; M: in Matrix);
   -- przypisanie odpowiednich procedur do atrybutów typu matrix
   for Matrix'Read use Read;
   for Matrix'Write use Write;

   procedure Read (S: access Root_Stream_Type'Class; M: out Matrix) is
   begin
      for Elem of M loop
         Float'Read(S, Elem);
      end loop;
   end Read;

   procedure Write(S: access Root_Stream_Type'Class; M: in Matrix) is
   begin
      for Elem of M loop
         Float'Write(S, Elem);
      end loop;
   end Write;

   function To_String(M: Matrix; Str: String:=""; I: Integer:=1; J: Integer:=1) return String is
     (if I>M'Last and Str'Length > 0 then
         Str
      else
        (if Str'Length=0 then
              To_String(M,Str&" ",M'First)
         else
         -- J jest indeksem kolumny
         -- jeśli nie jesteśmy w ostatniej kolumnie, to po dodaniu wartości do wynikowego stringa
         -- przesuwamy się z indeksem kolumny o jeden w prawo
            (if J < M'Last(2) then
                  To_String(M,Str&ASCII.LF&"["&I'Img&","&J'Img&"]=>"&M(I, J)'Img,I, J+1)
             -- jeśli jesteśmy w ostatniej kolumnie, to po dodaniu wartości do wynikowego stringa
             -- przesuwamy I czyli indeks wierszy o jeden "w dół", a indeks kolumny ustawiamy na 1
             else
                To_String(M,Str&ASCII.LF&"["&I'Img&","&J'Img&"]=>"&M(I, J)'Img,I+1, 1))));

   -- deklaracja macierzy 3 x 3
   -- liczba elementów może być dowolna, ale aby macierz była kompatybilna z funkcją To_string
   -- indeksacja obu wymiarów powinna się zaczynać od 1
   Macierz : Matrix(1..3, 1..3);-- := (others => (others => Random(G)));

begin
   Reset(G);
   Macierz := (others => (others => Random(G)));
   Create(Plik, Out_File, Nazwa);
   Strumien := Stream(Plik);
   Put_Line("Zapisuje macierz: " & To_String(Macierz));
   Matrix'Output(Strumien, Macierz);
   Close(Plik);

   -- zerowanie macierzy
   Macierz := (others => (others => 0.0));

   Open(Plik, In_File, Nazwa);
   Strumien := Stream(Plik);

   Macierz := Matrix'Input(Strumien);
   Put_Line("Odczytuje macierz: " & To_String(Macierz));
   Close(Plik);
end Strum;
