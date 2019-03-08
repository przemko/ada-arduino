package Keypad is
   
   type Button is (None,
		   Select_Button,
		   Left_Button,
		   Up_Button,
		   Down_Button,
		   Right_Button);
   
   function Key_Pressed return Boolean;
   function Read_Key return Button;
   
end Keypad;
