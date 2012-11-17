with RASCAL.ToolboxQuit;          use RASCAL.ToolboxQuit;
with RASCAL.Toolbox;              use RASCAL.Toolbox;
with RASCAL.OS;                   use RASCAL.OS;

package Controller_MainWindow is

   type TEL_OpenWindow_Type             is new Toolbox_UserEventListener(16#14#,-1,-1) with null record;
   type TEL_OKButtonPressed_Type        is new Toolbox_UserEventListener(16#30#,-1,-1) with null record;
   type TEL_EscapeButtonPressed_Type    is new Toolbox_UserEventListener(16#31#,-1,-1) with null record;
   type TEL_RenewSelected_Type          is new Toolbox_UserEventListener(16#33#,-1,-1) with null record;

   --
   --
   --
   procedure Handle (The : in TEL_OKButtonPressed_Type);

   --
   --
   --
   procedure Handle (The : in TEL_EscapeButtonPressed_Type);

   --
   --
   --
   procedure Handle (The : in TEL_RenewSelected_Type);

   --
   -- The user has clicked on the iconbar icon - open the amin window.
   --
   procedure Handle (The : in TEL_OpenWindow_Type);

    
end Controller_MainWindow;
