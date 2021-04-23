--Zuzanna Misztal
--Zadanie pierwsze
--To zadanie skończyłam w 1,5h od czasu przywrócenia prądu


with Ada.Text_IO, Ada.Numerics.Discrete_Random, Ada.Numerics.Generic_Elementary_Functions;
use Ada.Text_IO;

procedure Main is

   -- tworzenie odpowiednich pakietów, aby móc losować współrzędne punktu
   package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);
   use Los_Liczby;
   -- oraz wykonywać pierwiastkowanie
   package Value_Functions is new Ada.Numerics.Generic_Elementary_Functions(Float);
   use Value_Functions;

   -- utworzenie typu Punkt, zawierającego współrzędne X i Y będące Integerami
   type Punkt is record
      X, Y: Integer := 0;
   end record;

   -- zdefiniowanie typu zadaniowego, z wyróżnikiem stanowiącym ile punktów ma być generowanych
   task type Generating(N: Integer := 1) is
   end Generating;

   -- utworzenie zadania przesyłającego 5 punktów
   Z1: Generating(5);

   -- specyfikacja zadania
   -- zadanie Calculating ma dwe wejścia - jedno synchronizujące - jedno pobierające punkt
   task Calculating is
      entry We(P: Punkt);
      entry Koniec;
   end Calculating;

   -- treść zadania
   -- zadanie losuje współrzędne punktu, wypisuje i  spotyka się z zadaniem Calculating wysyłając mu punkt
   task body Generating is
      x, y: Integer;
      Point: Punkt;
      Gen: Generator;
   begin
      reset(Gen);
      for i in 1..N loop
         x := Random(Gen) mod 100;
         y := Random(Gen) mod 100;
         Point.X := x;
         Point.Y := y;
         Put_Line("Sending x=" & x'Img & ", y=" & y'Img);
         Calculating.We(Point);
      end loop;
      -- synchronizuje koniec generowania wartości z końcem zadania Calculating
      Calculating.Koniec;
   end Generating;

   task body Calculating is
      Point1: Punkt;
      Point2: Punkt := (0, 0);
      dist_a: Float;
      dist_b: Float;
   begin
      loop
         select
            -- po otrzymaniu punktu przy spotkaniu
            accept We(P: in Punkt) do
               Put_Line("Received x=" & P.X'Img & ", y=" & P.Y'Img);
               -- liczy odległość punktu od środka układu współrzędnych
               dist_a := Sqrt(Float(P.X**2 + P.Y**2));
               Point1 := Point2;
               Point2 := P;
               -- liczy odległość między pobranym punktem, a poprzednim
               -- punkt zerowy, z którym porównywany jest pierwszy nadesłany punkt jest w środku układu współrzędnych
               dist_b := Sqrt(Float((P.X - Point1.X)**2 + (P.Y - Point1.Y)**2));
               Put_Line("From origin = " & dist_a'Img);
               Put_Line("From last = " & dist_b'Img);
            end We;
         or
            accept Koniec;
            exit;
         end select;
      end loop;
   end Calculating;

begin
   null;
end Main;
