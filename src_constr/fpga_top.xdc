set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports MAIN_CLK]
set_property -dict {PACKAGE_PIN W1 IOSTANDARD LVCMOS33} [get_ports LCD_BLK]
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS33} [get_ports LCD_RST]
set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports LCD_DC]
set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVCMOS33} [get_ports LCD_SDA]
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVCMOS33} [get_ports LCD_SCK]

create_clock -period 10.000 [get_ports MAIN_CLK]