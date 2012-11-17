with Controller_Quit;           use Controller_Quit;
with Controller_Internet;       use Controller_Internet;
with Controller_Bugz;           use Controller_Bugz;
with Controller_Choices;        use Controller_Choices;
with Controller_Help;           use Controller_Help;
with Controller_MainWindow;     use Controller_MainWindow;
with Controller_DataMenu;       use Controller_DataMenu;
with Controller_Error;          use Controller_Error;
with Controller_Dummy;          use Controller_Dummy;
with AcronymList;               use AcronymList;
with Ada.Exceptions;
with Reporter;
with Text_IO;

with RASCAL.MessageTrans;       use RASCAL.MessageTrans;
with RASCAL.Error;              use RASCAL.Error;
with RASCAL.FileInternal;       use RASCAL.FileInternal;
with RASCAL.Heap;               use RASCAL.Heap;
with RASCAL.FileExternal;       use RASCAL.FileExternal;
with RASCAL.Toolbox;            use RASCAL.Toolbox;
with RASCAL.ToolboxProgInfo;

package body Main is

   --

   package MessageTrans    renames RASCAL.MessageTrans;
   package Error           renames RASCAL.Error;          
   package FileInternal    renames RASCAL.FileInternal;   
   package Heap            renames RASCAL.Heap;           
   package FileExternal    renames RASCAL.FileExternal;   
   package Toolbox         renames RASCAL.Toolbox;        
   package ToolboxProgInfo renames RASCAL.ToolboxProgInfo;
   package WimpTask        renames RASCAL.WimpTask;
   package Utility         renames RASCAL.Utility; 
   package Variable        renames RASCAL.Variable;
   package OS              renames RASCAL.OS;      

   --

   procedure Report_Error (Token : in String;
                           Info  : in String) is

      E        : Error_Pointer          := Get_Error (Main_Task);
      M        : Error_Message_Pointer  := new Error_Message_Type;
      Result   : Error_Return_Type      := XButton1;
   begin
      if Get_Status (Main_task) then
         M.all.Token(1..Token'Length) := Token;
         M.all.Param1(1..Info'Length) := Info;
         M.all.Category := Warning;
         M.all.Flags    := Error_Flag_OK;
         Result         := Error.Show_Message (E,M);
      else
         Text_IO.Put_Line(MessageTrans.Lookup(Token,E.all.Msg_Handle,Info));
      end if;
   end Report_Error;
   
   --

   procedure Discard_Acronyms is

      Start   : AcronymList.Position;
      i       : AcronymList.Position;
      Meaning : Meaning_Pointer;
   begin
      if not IsEmpty(Acronym_List.all) then
         i := First (Acronym_List.all);
         loop
            -- For each file loop..
            Meaning := Retrieve (Acronym_List.all,i);
            Heap.Free(Meaning.all.Buffer.all);
            Delete (Acronym_List.all, i);
         
            i := First (Acronym_List.all);
            if IsEmpty(Acronym_List.all) then
               exit;
            end if;
         end loop;
      end if;
   exception
      when e: others => Report_Error("DISCARDING",Ada.Exceptions.Exception_Information (e));
   end Discard_Acronyms;

   --

   procedure Read_Acronyms is

      Path       : String         := "Choices:Meaning.Data";
      Dir_List   : Directory_Type := Get_Directory_List(Path);
   begin
      for i in Dir_List'Range loop
         declare
            FileName   : String  := S(Dir_List(i));
            FilePath   : String  := Path & "." & FileName;
            FileSize   : constant natural := Get_Size(FilePath);
            FileBuffer : Heap_Block_Pointer := new Heap.Heap_block_Type(FileSize);
            Offset     : natural := 0;
         begin
            Load_File(FilePath,Heap.Get_Address(FileBuffer.all));
            AddToRear(Acronym_List.all,new Meaning_Type'(U(FileName),FileBuffer,FileSize));
         end;
      end loop;
   exception
      when e: others => Report_Error("READING",Ada.Exceptions.Exception_Information (e));
   end Read_Acronyms;

   --

   procedure Main is

      ProgInfo_Window : Object_ID;
      Misc            : Messages_Handle_Type;
   begin
      -- Messages
      Add_Listener (Main_Task,new MEL_Message_Bugz_Query);
      Add_Listener (Main_Task,new MEL_Message_Quit);          -- React upon quit from taskmanager

      -- Toolbox Events
      Add_Listener (Main_Task,new TEL_Quit_Quit);
      Add_Listener (Main_Task,new TEL_ViewManual_Type);
      Add_Listener (Main_Task,new TEL_ViewSection_Type);
      Add_Listener (Main_Task,new TEL_ViewIHelp_Type);
      Add_Listener (Main_Task,new TEL_ViewHomePage_Type);
      Add_Listener (Main_Task,new TEL_SendEmail_Type);      
      Add_Listener (Main_Task,new TEL_CreateReport_Type);
      Add_Listener (Main_Task,new TEL_OKButtonPressed_Type);
      Add_Listener (Main_Task,new TEL_EscapeButtonPressed_Type);
      Add_Listener (Main_Task,new TEL_ViewDataDir_Type);
      Add_Listener (Main_Task,new TEL_RenewSelected_Type);
      Add_Listener (Main_Task,new TEL_DataMenuOpen_Type);
      Add_Listener (Main_Task,new TEL_DataEntrySelected_Type);
      Add_Listener (Main_Task,new TEL_Toolbox_Error);
      Add_Listener (Main_Task,new TEL_OpenWindow_Type);
      Add_Listener (Main_Task,new TEL_Dummy);

      -- Start task
      WimpTask.Set_Resources_Path(Main_Task,"<MeaningRes$Dir>");
      WimpTask.Initialise(Main_Task);

      if FileExternal.Exists("Choices:Meaning.Misc") then
         Misc := MessageTrans.Open_File("Choices:Meaning.Misc");
         begin
            Read_Integer ("XPOS",x_pos,Misc);
            Read_Integer ("YPOS",y_pos,Misc);
         exception
            when others => null;            
         end;
      end if;

      ProgInfo_Window := Toolbox.Create_Object("ProgInfo",From_Template);
      ToolboxProgInfo.Set_Version(ProgInfo_Window,MessageTrans.Lookup("VERS",Get_Message_Block(Main_Task)));

      Not_Found_Message := U(MessageTrans.Lookup("NOTFOUND",Get_Message_Block(Main_Task)));

      Untitled_String := U(MessageTrans.Lookup("UNTITLED",Get_Message_Block(Main_Task)));
      if Length(Untitled_String) = 0 then
         Untitled_String := U("Untitled");
      end if;

      -- Choices directory
      if FileExternal.Exists(Choices_Write) /=true then
         Create_Directory(Choices_Write);
      end if;
      if FileExternal.Exists(Choices_Write & ".Data") /=true then
         FileExternal.Copy("<Meaning$Dir>.Resources.Data",Choices_Write & ".Data");
      end if;

      Read_Acronyms;

      main_objectid  := Toolbox.Create_Object ("Main");
      -- Start polling
      WimpTask.Poll(Main_Task);

   exception
      when e: others => Text_IO.Put_Line (Ada.Exceptions.Exception_Information (e));
   end Main;

   --

     
end Main;

