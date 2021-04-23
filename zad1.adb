with Ada.Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

procedure zad1 is

   type My_Character is new Character range 'A'..'Z';

   package Random_Character is new Ada.Numerics.Discrete_Random(My_Character);
   use Random_Character;

   -- zdefiniowanie typu tablicowego
   type bufor_array is array(Integer range <>) of My_Character;

   -- zmienna określająca wielkość bufora
   num: Integer := 5;

   --specyfikacja typu bufora wieloelementowego na obiekcie chronionym
   protected type Buf(N: Integer) is
      entry Wstaw(C: My_Character);
      entry Pobierz(C: out My_Character);
   private
      bufor: bufor_array(1..N);
      licznik: Integer := 0;
   end Buf;


   protected body Buf is
      entry Wstaw(C: My_Character) when licznik < N is
      begin
         --oznacz, że wdo bufora zostala dodana wartosc
         licznik := licznik + 1;
         --wstaw otrzymana wartosc do bufora
         bufor(licznik) := C;
         Put_Line("Licznik wzrosl do: " & licznik'Img);
      end Wstaw;

      entry Pobierz(C: out My_Character) when licznik > 0 is
      begin
         -- pobiera wartosc z ostatniego elementu w buforze
         C := bufor(licznik);
         licznik := licznik - 1;
         Put_Line("Licznik spadl do: " & licznik'Img);
      end Pobierz;
   end Buf;

   bufor: Buf(num);

   task Producent;

   task body Producent is
      value: My_Character;
      gen: Generator;
   begin
      Reset(gen);
      for I in 1..2*num loop
         --losowanie wartosci produkowanej
         value := Random(gen);
         Put_Line("wyprodukowalem: " & value'Img);
         --przekazanie wyprodukowanej wartosci do bufora
         bufor.Wstaw(value);
      end loop;
   end Producent;

   task Konsument;

   task body Konsument is
      value: My_Character;
   begin
      for I IN 1..10 loop
         bufor.Pobierz(value);
         Put_Line("skonsumowalem: " & value'Img);
      end loop;
   end Konsument;

begin
   null;
end zad1;
