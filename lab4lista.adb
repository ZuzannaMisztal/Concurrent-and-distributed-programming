with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Lab4Lista is

   package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);
  use Los_Liczby;

type Element is
  record
    Data : Integer := 0;
    Next : access Element := Null;
  end record;

type Elem_Ptr is access all Element;

procedure Print(List : access Element) is
  L : access Element := List;
begin
  if List = Null then
    Put_Line("List EMPTY!");
  else
    Put_Line("List:");
  end if;
  while L /= Null loop
    Put(L.Data, 4); -- z pakietu Ada.Integer_Text_IO
    New_Line;
    L := L.Next;
  end loop;
end Print;

procedure Insert(List : in out Elem_Ptr; D : in Integer) is
  E : Elem_Ptr := new Element;
begin
  E.Data := D;
  E.Next := List;
  -- lub E.all := (D, List);
  List := E;
end Insert;

-- wstawianie jako funkcja - wersja krótka
function Insert(List : access Element; D : in Integer) return access Element is
  ( new Element'(D,List) );

-- do napisania !!
procedure Insert_Sort(List : in out Elem_Ptr; D : in Integer) is
      L : Elem_Ptr := List;
      E : Elem_Ptr := new Element;
   begin
      if L.Data > D then

         E.all := (D, List);
         List := E;

         return;
      end if;
      Find_elem:

         loop
            exit Find_elem when L.Next = null;
            exit Find_elem when L.Next.Data > D;
            L := L.Next;
         end loop Find_elem;
      E.Data := D;
      E.Next := L.Next;
      L.Next := E;
end Insert_Sort;

   function Random_List(n: Integer) return Elem_Ptr is
      L : Elem_Ptr := null;
      Wart : Integer := 0;
      Gen: Generator;
   begin
      for I in 1..n loop
         Wart := Random(Gen) mod 100 + 1;
         Insert(L, Wart);
      end loop;
      return L;
   end Random_List;


   function Find_Elem(List : in out Elem_Ptr; D : in Integer) return Elem_Ptr is
      L: Elem_Ptr := List;
   begin
      while L /= null loop
         if L.Data = D then
            return L;
         end if;
         L := L.Next;
      end loop;
      return null;
   end Find_Elem;

   procedure Delete_Elem(List : in out Elem_Ptr; D : in Integer) is
      L: Elem_Ptr := List;
   begin
      if L.Data = D then
         List := L.Next;
         return;
      end if;
      while L.Next /= null loop
         if L.Next.Data = D then
            L.Next := L.Next.Next;
            return;
         end if;
         L := L.Next;
      end loop;
   end Delete_Elem;

   procedure Delete_All_Elems(List: in out Elem_Ptr; D: in Integer) is
      L: Elem_Ptr := List;
   begin
      while L.Next /= null loop
         if L.Next.Data = D then
            L.Next := L.Next.Next;
         end if;
         L := L.Next;
      end loop;
   end Delete_All_Elems;


   procedure Delete_Duplicates(List: in out Elem_Ptr) is
      L: Elem_Ptr := List;
   begin
      while L /= null loop
         Delete_All_Elems(L, L.Data);
         L := L.Next;
      end loop;
   end Delete_Duplicates;


   Lista : Elem_Ptr := Null;
   Lista2 : Elem_Ptr := null;
   rand_list : Elem_Ptr := null;
   found : Elem_Ptr := null;

begin
  Lista := Insert(Lista, 21);
  Insert(Lista, 20);
  for I in reverse 1..12 loop
  Insert(Lista, I);
   end loop;
   Lista2 := Insert(Lista2, 8);
   Insert(Lista2, 7);
   Insert(Lista2, 2);
   Insert(Lista2, 7);
   Insert(Lista2, 3);
   Insert(Lista2, 2);
   Insert(Lista2, 2);
   Insert(Lista2, 7);
   Insert(Lista2, 9);
   Insert(Lista2, 9);
   --print(Lista);
   --rand_list := Random_List(6);
   --Print(rand_list);
   --found := Find_Elem(Lista, 11);
   --Print(found);
   --found := Find_Elem(Lista, 13);
   --Print(found);
   --print(Lista);
   --Delete_Elem(Lista, 1);
   --Print(Lista);
   Delete_Duplicates(Lista2);
   Print(Lista2);
end Lab4Lista;
