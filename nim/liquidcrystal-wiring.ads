with AVR; use AVR;
with AVR.MCU;

private package LiquidCrystal.Wiring is
   
   pragma Preelaborate;
   
   --  pin   id   port  bit  
   --==================================================
   --    0  PD0  PORTD    0  RXD   PCINT16       RX
   --    1  PD1  PORTD    1  TXD   PCINT17       TX
   --    2  PD2  PORTD    2  INT0  PCINT18
   --    3  PD3  PORTD    3  INT1  PCINT19  PWM  OC2B
   --    4  PD4  PORTD    4  T0    PCINT20       XCK
   --    5  PD5  PORTD    5  T1    PCINT21  PWM
   --    6  PD6  PORTD    6  AIN0  PCINT22  PWM  OC0A
   --    7  PD7  PORTD    7  AIN1  PCINT23
   ----------------------------------------------------
   --    8  PB0  PORTB    0  CLK0  PCINT0        ICP1
   --    9  PB1  PORTB    1  OC1A  PCINT1   PWM
   --   10  PB2  PORTB    2  OC1B  PCINT2   PWM  SS
   --   11  PB3  PORTB    3  OC2A  PCINT3   PWM  MOSI
   --   12  PB4  PORTB    4        PCINT4        MISO
   --   13  PB5  PORTB    5        PCINT5        SCK
   ----------------------------------------------------
   
   -- Interface pins: 8, 9, 4, 5, 6, 7 :)
 
   Data0             : Boolean renames MCU.PORTD_Bits (4); 
   Data1             : Boolean renames MCU.PORTD_Bits (5);
   Data2             : Boolean renames MCU.PORTD_Bits (6);
   Data3             : Boolean renames MCU.PORTD_Bits (7);
   Data0_DD          : Boolean renames  MCU.DDRD_Bits (4);
   Data1_DD          : Boolean renames  MCU.DDRD_Bits (5);
   Data2_DD          : Boolean renames  MCU.DDRD_Bits (6);
   Data3_DD          : Boolean renames  MCU.DDRD_Bits (7);
   
   
   RegisterSelect    : Boolean renames MCU.PORTB_Bits (0);
   RegisterSelect_DD : Boolean renames MCU.DDRB_Bits (0);
   
   ReadWrite         : Boolean renames MCU.PORTD_Bits (3);
   ReadWrite_DD      : Boolean renames MCU.DDRD_Bits (3);
   
   Enable            : Boolean renames MCU.PORTB_Bits (1);
   Enable_DD         : Boolean renames MCU.DDRB_Bits (1);
   
   Processor_Speed   : constant := 16_000_000;
   
end LiquidCrystal.Wiring;
