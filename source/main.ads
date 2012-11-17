with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with AcronymList;               use AcronymList;

with RASCAL.WimpTask;           use RASCAL.WimpTask;
with RASCAL.Utility;            use RASCAL.Utility;
with RASCAL.Variable;           use RASCAL.Variable;
with RASCAL.OS;                 use RASCAL.OS;

package Main is   

   --

   Main_Task      : ToolBox_Task_Class;
   main_objectid  : Object_ID             := -1;
   main_winid     : Wimp_Handle_Type      := -1;
   
   Data_Menu_Entries : natural            := 0;
   x_pos             : Integer            := -1;
   y_pos             : Integer            := -1;

   -- Constants

   Not_Found_Message : UString;
   app_name          : constant String := "Meaning";
   Choices_Write     : constant String := "<Choices$Write>." & app_name;
   Choices_Read      : constant String := "Choices:" & app_name & ".Choices";
   scrapdir          : constant String := "<Wimp$ScrapDir>." & app_name;

   --

   Acronym_List : AcronymList.ListPointer := new AcronymList.List;
   Untitled_String : Unbounded_String;

   --

   procedure Main;

   procedure Discard_Acronyms;

   procedure Read_Acronyms;

   procedure Report_Error (Token : in String;
                           Info  : in String);
                           
   --

 end Main;
 