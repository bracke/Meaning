with RASCAL.Memory;              use RASCAL.Memory;
with RASCAL.OS;                  use RASCAL.OS;
with RASCAL.Utility;             use RASCAL.Utility;
with RASCAL.FileExternal;        use RASCAL.FileExternal;
with RASCAL.ToolboxMenu;         use RASCAL.ToolboxMenu;
with RASCAL.Toolbox;             use RASCAL.Toolbox;
with RASCAL.Bugz;                use RASCAL.Bugz;
with RASCAL.WimpTask;            use RASCAL.WimpTask;

with AcronymList;                use AcronymList;
with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;
with Interfaces.C;               use Interfaces.C;
with Main;                       use Main;
with Ada.Exceptions;             
with Ada.Characters.Handling;
with Reporter;

package body Controller_DataMenu is

   --

   package Memory        renames RASCAL.Memory;
   package OS            renames RASCAL.OS;          
   package Utility       renames RASCAL.Utility;     
   package FileExternal  renames RASCAL.FileExternal;
   package ToolboxMenu   renames RASCAL.ToolboxMenu; 
   package Toolbox       renames RASCAL.Toolbox;     
   package Bugz          renames RASCAL.Bugz;
   package WimpTask      renames RASCAL.WimpTask;

   --

   procedure Handle (The : in TEL_DataMenuOpen_Type) is

      Object     : Object_ID      := Get_Self_Id(Main_Task);
      Dir_List   : Directory_Type := Get_Directory_List(Choices_Write & ".Data");
   begin
      -- Delete old entries      
      if Data_Menu_Entries > 0 then
         ToolboxMenu.Remove_Entries(Object,Data_Menu_Entries,1);
      end if;

      -- Insert new entries
      for i in Dir_List'Range loop
         ToolboxMenu.Add_Last_Entry(Object,S(Dir_List(i)),Component_ID(i),Click_Event => 16#35#); 
      end loop;

      Data_Menu_Entries := Dir_List'Last;
   exception
      when e: others => Report_Error("OPENDATAMENU",Ada.Exceptions.Exception_Information (e));
   end Handle;

   --

   procedure Handle (The : in TEL_DataEntrySelected_Type) is

      Object     : Object_ID    := Get_Self_Id(Main_Task);
      Component  : Component_ID := Get_Self_Component(Main_Task);
      FileName   : String       := ToolboxMenu.Get_Entry_Text(Object,Component);
   begin
      Call_OS_CLI("Filer_Run " &  Choices_Write & ".Data." & FileName);
   exception
      when e: others => Report_Error("VIEWDATAENTRY",Ada.Exceptions.Exception_Information (e));
   end Handle;

   --

   procedure Handle (The : in TEL_ViewDataDir_Type) is
   begin
      Call_OS_CLI ("Filer_OpenDir " & Choices_Write & ".Data");
   exception
      when e: others => Report_Error("VIEWDATA",Ada.Exceptions.Exception_Information (e));
   end Handle;

   --

end Controller_DataMenu;
