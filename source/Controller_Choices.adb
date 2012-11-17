with RASCAL.Utility;             use RASCAL.Utility;
with RASCAL.UserMessages;

with Main;                       use Main;
with Interfaces.C;               use Interfaces.C;
with Ada.Strings.Fixed;          use Ada.Strings.Fixed;
with Ada.Characters.Handling;    use Ada.Characters.Handling;
with Ada.Exceptions;
with Reporter;

package body Controller_Choices is

   --

   package Utility      renames RASCAL.Utility;
   package UserMessages renames RASCAL.UserMessages; 
                                             
   --

   procedure Handle (The : in TEL_ViewChoices_Type) is
   begin
      Call_OS_CLI("Filer_Run <Meaning$Dir>.!Configure");
   exception
      when e: others => Report_Error("CHOICES",Ada.Exceptions.Exception_Information (e));
   end Handle;
   
   --

   procedure Handle (The : in MEL_Message_ConfiX) is

      Message : String := To_Ada(The.Event.all.Message);
   begin
      if Index(To_Lower(Message),"config") >= Message'First then
         null; -- read choices
      end if;
   exception
      when e: others => Report_Error("MCONFIX",Ada.Exceptions.Exception_Information (e));
   end Handle;

   --
   
end Controller_Choices;
