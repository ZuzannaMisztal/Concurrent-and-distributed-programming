with Ada.Text_IO;
use Ada.Text_IO;
with GNAT.Sockets;
use GNAT.Sockets;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure Socket is

   task A;

   task body A is
      Address    : Sock_Addr_Type;
      Server     : Socket_Type;
      Socket     : Socket_Type;
      Channel    : Stream_Access;
      N          : Integer := 10;
      Data       : Float;
      G          : Generator;
   begin
      Reset(G);
      Address.Port := 5876;
      Create_Socket(Server);
      Set_Socket_Option (Server, Socket_Level, (Reuse_Address, True));
      Bind_Socket (Server, Address);
      Listen_Socket (Server);
      Accept_Socket (Server, Socket, Address);
      Channel := Stream(Socket);
      -- pętla generująca i wysyłająca dane typu float
      for I in 1..N loop
         Data := Random(G);
         Put_Line("Sending " & Data'Img);
         Float'Output(Channel, Data);
      end loop;
      Float'Output(Channel, 0.0); -- sygnalizuje koniec
      Put_Line("Received sorted");
      -- pętla odbierająca posortowane liczby
      for I in 1..N loop
         Data := Float'Input(Channel);
         Put_Line(Data'Img);
      end loop;
   end A;

begin
   null;
end Socket;
