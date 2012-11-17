with RASCAL.Utility;       use RASCAL.Utility;
with RASCAL.Heap;          use RASCAL.Heap;

package AcronymList is

------------------------------------------------------------------------
--  | Generic ADT for one-way linked lists
--  | Author: Michael B. Feldman, The George Washington University
--  | Last Modified: January 1996
------------------------------------------------------------------------

   --  exported types

   type Meaning_Type is
   record
   Category: UString;
   Buffer  : Heap_Block_Pointer;
   FileSize: natural;
   end record;

   type Meaning_Pointer is access Meaning_Type;


   type Position is private;
   type List is limited private;
   type ListPointer is access List;
   --  exported exceptions
   
   OutOfSpace : exception;  --   raised if no space left for a new node
   PastEnd   : exception;  --   raised if a Position is past the end
   PastBegin : exception;  --   raised if a Position is before the begin
   EmptyList : exception;
   
   --  basic constructors
   
   procedure AddToRear (L : in out List; X : Meaning_Pointer);
   --  Pre:  L and X are defined
   --  Post: a node containing X is inserted
   --    at the front or rear of L, respectively
   
   --  basic selectors
   
   function First (L : List) return Position;

   function Retrieve (L : in List; P : in Position)
                           return Meaning_Pointer;
   --  Pre:    L and P are defined; P designates a node in L
   --  Post:   returns the value of the element at position P
   --  Raises: EmptyList if L is empty
   --          PastBegin if P points before the beginning of L
   --          PastEnd   if P points beyond the end of L
   
   --  other constructors

   procedure Delete (L : in out List; P : Position);

   --  Pre:    L and P are defined; P designates a node in L
   --  Post:   the node at position P of L is deleted
   --  Raises: EmptyList if L is empty
   --          PastBegin if P is NULL
   
   --  iterator operations
   
   procedure GoAhead (L : List; P : in out Position);
   --  Pre:    L and P are defined; P designates a node in L
   --  Post:   P is advanced to designate the next node of L
   --  Raises: EmptyList if L is empty
   --          PastEnd   if P points beyond the end of L
   
   procedure GoBack    (L : List; P : in out Position);
   --  Pre:    L and P are defined; P designates a node in L
   --  Post:   P is moved to designate the previous node of L
   --  Raises: EmptyList if L is empty
   --          PastBegin if P points beyond the end of L
   
   --  inquiry operators
   
   function  IsEmpty   (L : List) return Boolean;
   function  IsFirst   (L : List; P : Position) return Boolean;
   function  IsLast    (L : List; P : Position) return Boolean;
   function  IsPastEnd (L : List; P : Position) return Boolean;
   function  IsPastBegin (L : List; P : Position) return Boolean;
   --  Pre:    L and P are defined
   --  Post:   return True if the condition is met; False otherwise   
  
private

   type Node;
   type Position is access Node;
   
   type Node is record
     Info : Meaning_Pointer;
     Link : Position;
   end record;
   
   type List is record     
     Head : Position;
     Tail : Position;
   end record;
  
end AcronymList;
