with Ada.Text_IO;
use Ada.Text_IO;

procedure zad2 is

   task Semafor is
      --podstawowe operacje na semaforze
      entry Czekaj;
      entry Sygnalizuj;
   end Semafor;

   task body Semafor is
      --
      S: Integer range 0..5 := 5;
   begin
      loop
         select
            --jeśli są dostępne zasoby to oznacz jeden jako zajęty
            when S > 0 =>
            accept Czekaj do
               S := S - 1;
            end Czekaj;
         or
            -- zwalnianie zasobu
            accept Sygnalizuj do
               S := S + 1;
            end Sygnalizuj;
         or
            delay 5.0;
            exit;
         end select;
      end loop;
   end Semafor;

   --typ zadaniowy z wyroznikiem N
   task type Zadanie(N: Integer);

   task body Zadanie is
   begin
      --zajecie zasobu przez zadanie
      Semafor.Czekaj;
      Put_Line("Zadanie " & N'Img & " korzystam z zasobu");
      delay 1.0;
      -- po odczekaniu 1s zwalnia zasob
      Semafor.Sygnalizuj;
      Put_Line("Zadanie " & N'Img & " zwalniam zasob");
   end Zadanie;


  Z1: Zadanie(1);
  Z2: Zadanie(2);
  Z3: Zadanie(3);
  Z4: Zadanie(4);
  Z5: Zadanie(5);
  Z6: Zadanie(6);
  Z7: Zadanie(7);
  Z8: Zadanie(8);
  Z9: Zadanie(9);
  Z10: Zadanie(10);

begin
   null;
end zad2;
