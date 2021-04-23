--Zuzanna Misztal
--Zadanie ostatnie
--Przesyłam co napisałam, mimo że nie działa. Poświęciłam na to dość dużo czasu, i niestety nie wiem w czym jest problem.
--Byłabym wdzięczna za podpowiedź. Bardzo nie chciałabym zostać z tyłu grupy akurat w momencie gdy pojawia się sedno przedmiotu,
--a co za tym idzie nowa wiedza do nabycia

--To u mnie była awaria prądu.
--jeśli uzna Pan, że ten program jest warty jakieś punkty, to sugeruję przy nich wagę 0.75,
--gdyż w takiej postaci był przeze mnie skończony koło północy wczoraj

with Ada.Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

procedure Main is

   -- typy z których wartości będzie losować zadanie C
   type Colors is (Red, Green, Blue);
   type Numbers is new Integer range 0..5;

   -- odpowiednie pakiety do losowania
   package Los_Colors is new Ada.Numerics.Discrete_Random(Colors);
   package Los_Numbers is new Ada.Numerics.Discrete_Random(Numbers);

   -- specyfikacja zadania C z dwoma wejściami synchronizującymi
   task C is
      entry Rand_Color;
      entry Rand_Number;
   end C;

   -- zadania D i E mają po jednym wejściu na przekazane przez zadanie C wartości, które te zadania mają wypisywać
   task D is
      entry Number_Value(N: Numbers);
   end D;

   task E is
      entry Color_Value(Col: Colors);
   end E;

   --treść zadania
   task body C is
      Color: Colors;
      Number: Numbers;
      Color_Gen: Los_Colors.Generator;
      Num_Gen: Los_Numbers.Generator;
   begin
      Los_Colors.Reset(Color_Gen);
      Los_Numbers.Reset(Num_Gen);
      loop
         -- instrukcja obsługująca komunikaty wysyłane przez zadania D i E
         select
            accept Rand_Number  do
               Put_Line("accepted rand_num");
               Number := Los_Numbers.Random(Num_Gen);
               Put_Line("Chosen number: " & Number'Img);
               -- to się wypisuje, ale w dalszej części program wydaje się zawieszać
               D.Number_Value(Number);
               Put_Line("Task D called");
            end Rand_Number;
         or
            accept Rand_Color  do
               Put_Line("accepted rand_color");
               Color := Los_Colors.Random(Color_Gen);
               Put_Line("Chosen color: " & Color'Img);
               E.Color_Value(Color);
            end Rand_Color;
         or
         -- jeśli nie przychodzą nowe komunikaty zakończ
            delay 1.0;
            exit;
         end select;
      end loop;
   end C;

   task body D is
   begin
      for i in 1..5 loop
         Put_Line("Jestem w D");
         C.Rand_Number;
         -- tutaj dodatkowa pętla, której nie ma w zadaniu E
         -- miała być próbą skomunikowania się z zadaniem C
         Put_Line("Before accept D");
         loop
            accept Number_Value(N: in Numbers) do
               Put_Line("Wylosowano numer " & N'Img);
            end Number_Value;
            Put_Line("After accept D");
         end loop;
      end loop;
   end D;

   task body E is
   begin
      for i in 1..5 loop
         C.Rand_Color;
         Put_Line("task E");
         accept Color_Value(Col: in Colors) do
            Put_Line("Wylosowano kolor " & Col'Img);
         end Color_Value;
      end loop;
   end E;

begin
   null;
end Main;
