with RASCAL.Memory;                     use RASCAL.Memory;
with RASCAL.OS;                         use RASCAL.OS;
with RASCAL.Utility;                    use RASCAL.Utility;
with RASCAL.FileExternal;               use RASCAL.FileExternal;
with RASCAL.Heap;                       use RASCAL.Heap;
with RASCAL.WimpTask;                   use RASCAL.WimpTask;
with RASCAL.ToolboxMenu;                use RASCAL.ToolboxMenu;
with RASCAL.Toolbox;                    use RASCAL.Toolbox;
with RASCAL.ToolboxWritableField;       use RASCAL.ToolboxWritableField;
with RASCAL.ToolboxTextArea;            use RASCAL.ToolboxTextArea;
with RASCAL.Bugz;                       use RASCAL.Bugz;
with RASCAL.Mode;                       use RASCAL.Mode;

with Main;                              use Main;
with Ada.Exceptions;                    
with AcronymList;                       use AcronymList;
with Ada.Strings.Unbounded;             use Ada.Strings.Unbounded;
with Interfaces.C;                      use Interfaces.C;
with Ada.Characters.Handling;
with Reporter;

package body Controller_MainWindow is

   --

   package Memory               renames RASCAL.Memory;
   package OS                   renames RASCAL.OS;                  
   package Utility              renames RASCAL.Utility;             
   package FileExternal         renames RASCAL.FileExternal;        
   package Heap                 renames RASCAL.Heap;                
   package WimpTask             renames RASCAL.WimpTask;            
   package ToolboxMenu          renames RASCAL.ToolboxMenu;         
   package Toolbox              renames RASCAL.Toolbox;             
   package ToolboxWritableField renames RASCAL.ToolboxWritableField;
   package ToolboxTextArea      renames RASCAL.ToolboxTextArea;     
   package Bugz                 renames RASCAL.Bugz;
   package Mode                 renames RASCAL.Mode;

   --

   procedure Open_Window is
   begin
      if x_pos > Mode.Get_X_Resolution (OSUnits) or
         y_pos > Mode.Get_Y_Resolution (OSUnits) or
                                       x_pos < 0 or y_pos < 0 then

         Toolbox.Show_Object (main_objectid,0,0,Centre);
      else
         Toolbox.Show_Object_At (main_objectid,x_pos,y_pos,0,0);
      end if;      
   end Open_Window;

   --

   procedure Handle (The : in TEL_OKButtonPressed_Type) is

      Object  : Object_ID := Get_Self_Id(Main_Task);
      Acronym : String    := Ada.Characters.Handling.To_Lower(Get_Value(Object,1));

      Start   : AcronymList.Position;
      i       : AcronymList.Position;

      Meaning : Meaning_Pointer;
      Result  : UString;

   begin

      if not IsEmpty(Acronym_List.all) then
         
         Start := First (Acronym_List.all);
         i     := Start;
         loop
            -- For each file loop..

            Meaning := Retrieve (Acronym_List.all,i);

            declare
               Acronym_Str    : UString;
               Meaning_Str    : UString;

               Offset     : natural := 0;
               FileSize   : natural := Meaning.all.FileSize;
            begin

               -- for each line in filebuffer loop..
               while Offset < FileSize loop
                  Acronym_Str := U(MemoryToString(Heap.Get_Address(Meaning.all.Buffer.all),Offset,ASCII.LF));
                  Offset := Offset + Ada.Strings.Unbounded.Length(Acronym_Str) + 1;

                  if Acronym = Ada.Characters.Handling.To_Lower(S(Acronym_Str)) then
                     -- It is a match..
                     if Offset < FileSize and
                            Ada.Strings.Unbounded.Length(Acronym_Str) > 0 then
                                                                                                                               
                        Meaning_Str := U(MemoryToString(Get_Address(Meaning.all.Buffer.all),Offset,ASCII.LF));
                        Offset := Offset + Ada.Strings.Unbounded.Length(Meaning_Str) + 1;

                        Ada.Strings.Unbounded.Append(Result,Meaning.all.Category);
                        Ada.Strings.Unbounded.Append(Result,": ");
                        Ada.Strings.Unbounded.Append(Result,Meaning_Str);
                        Ada.Strings.Unbounded.Append(Result," " & ASCII.LF);
                     end if;

                  end if; 
               end loop;
               
            end;

            if IsLast (Acronym_List.all, i) then
               exit;
            end if;
            GoAhead (Acronym_List.all, i);

         end loop;

         if Ada.Strings.Unbounded.Length(Result) = 0 then
            Result := Not_Found_Message;
         end if;

         ToolboxTextArea.Set_Text(Object,0,S(Result));

      end if;
   exception
      when e: others => Report_Error("SEARCHING",Ada.Exceptions.Exception_Information (e));
   end Handle;

   --

   procedure Handle (The : in TEL_EscapeButtonPressed_Type) is

      Object  : Object_ID := Get_Self_Id(Main_Task);

   begin
      Hide_Object(Object);
   end Handle;

   --

   procedure Handle (The : in TEL_RenewSelected_Type) is
   begin
     Discard_Acronyms;
     Read_Acronyms;
   exception
      when e: others => Report_Error("RENEW",Ada.Exceptions.Exception_Information (e));     
   end Handle;

   --

   procedure Handle (The : in TEL_OpenWindow_Type) is
   begin
      Open_Window;
   exception
      when Exception_Data : others => Report_Error("OPENWINDOW",Ada.Exceptions.Exception_Information (Exception_Data));
   end Handle;
end Controller_MainWindow;
