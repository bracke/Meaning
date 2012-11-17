with RASCAL.ToolboxQuit;          use RASCAL.ToolboxQuit;
with RASCAL.Toolbox;              use RASCAL.Toolbox;
with RASCAL.OS;                   use RASCAL.OS;

package Controller_DataMenu is

   type TEL_DataMenuOpen_Type           is new Toolbox_UserEventListener(16#34#,-1,-1) with null record;
   type TEL_DataEntrySelected_Type      is new Toolbox_UserEventListener(16#35#,-1,-1) with null record;
   type TEL_ViewDataDir_Type            is new Toolbox_UserEventListener(16#32#,-1,-1) with null record;

   procedure Handle (The : in TEL_ViewDataDir_Type);
   procedure Handle (The : in TEL_DataMenuOpen_Type);
   procedure Handle (The : in TEL_DataEntrySelected_Type);

end Controller_DataMenu;
