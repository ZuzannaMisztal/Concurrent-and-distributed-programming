with Ada.Text_IO;
use Ada.Text_IO;
with GNAT.Sockets;
use GNAT.Sockets;
with Ada.Containers.Generic_Array_Sort;

procedure socketB is
   
   type My_Array is array (Natural range <>) of Float;
   
   -- procedura sortująca
   procedure sort is new Ada.Containers.Generic_Array_Sort
     (Index_Type     => Natural,
      Element_Type   => Float,
      Array_Type     => My_Array);
   
   task B;
   
   task body B is
      arr      : My_Array(1..20);
      -- last i start są zmiennymi pomocniczymi do oddzielenia w arr wartości przesłanych przez A od "pustych" pól
      last     : Integer;
      start    : Integer;
      data     : Float;
      Address  : Sock_Addr_Type;
      Socket   : Socket_Type;
      Channel  : Stream_Access;
   begin
      Address.Addr := Addresses(Get_Host_By_Name(Host_Name), 1);
      Address.Port := 5876;
      Create_Socket(Socket);
      Set_Socket_Option (Socket, Socket_Level, (Reuse_Address, True));
      Connect_Socket (Socket, Address);
      Channel := Stream(Socket);
      for I in 1..20 loop
         data := Float'Input(Channel);
         if data = 0.0 then
            last := I - 1; -- oznacza który indeks jest ostatnim z wartościami otrzymanymi przez A
            exit;
         end if;
         arr(I) := data;          
      end loop;
      sort(arr);
      -- wartości "puste" są w gruncie rzeczy równe 0, więc po posortowaniu znajdą się na początku tablicy
      -- start określa indeks, od którego zaczynają się wartości przesłane przez A
      start := 21 - last;
      for I in start..20 loop
         Put_Line(arr(I)'Img);
         Float'Output(Channel, arr(I));
      end loop;             
   end B;
   
begin
   null;
end socketB;
