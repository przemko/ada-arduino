with AVR.MCU;
with AVR.Wait;

procedure Handler;
pragma Machine_Attribute (Entity         => Handler,
			  Attribute_Name => "signal");
pragma Export (Convention    => C,
	       Entity        => Handler,
	       External_Name => "__vector_13");

