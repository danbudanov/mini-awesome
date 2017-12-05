	component soc_system is
		port (
			adc_external_interface_sclk           : out   std_logic;                                        -- sclk
			adc_external_interface_cs_n           : out   std_logic;                                        -- cs_n
			adc_external_interface_dout           : in    std_logic                     := 'X';             -- dout
			adc_external_interface_din            : out   std_logic;                                        -- din
			button_pio_external_connection_export : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			button_pio_s1_address                 : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			button_pio_s1_write_n                 : in    std_logic                     := 'X';             -- write_n
			button_pio_s1_writedata               : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			button_pio_s1_chipselect              : in    std_logic                     := 'X';             -- chipselect
			button_pio_s1_readdata                : out   std_logic_vector(31 downto 0);                    -- readdata
			clk_clk                               : in    std_logic                     := 'X';             -- clk
			dipsw_pio_external_connection_export  : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			gpio_sig_gpio_direction               : out   std_logic_vector(15 downto 0);                    -- gpio_direction
			gpio_sig_gpio_output_sig              : out   std_logic_vector(15 downto 0);                    -- gpio_output_sig
			gpio_sig_gpio_input_sig               : in    std_logic_vector(15 downto 0) := (others => 'X'); -- gpio_input_sig
			hps_0_f2h_cold_reset_req_reset_n      : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_debug_reset_req_reset_n     : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_stm_hw_events_stm_hwevents  : in    std_logic_vector(27 downto 0) := (others => 'X'); -- stm_hwevents
			hps_0_f2h_warm_reset_req_reset_n      : in    std_logic                     := 'X';             -- reset_n
			hps_0_h2f_reset_reset_n               : out   std_logic;                                        -- reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim1_inst_CLK    : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_0_hps_io_hps_io_spim1_inst_MOSI   : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_0_hps_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_0_hps_io_hps_io_spim1_inst_SS0    : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			i2c_external_sda_in                   : in    std_logic                     := 'X';             -- sda_in
			i2c_external_scl_in                   : in    std_logic                     := 'X';             -- scl_in
			i2c_external_sda_oe                   : out   std_logic;                                        -- sda_oe
			i2c_external_scl_oe                   : out   std_logic;                                        -- scl_oe
			ilc_irq_irq                           : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- irq
			led_pio_external_connection_export    : out   std_logic_vector(6 downto 0);                     -- export
			memory_mem_a                          : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                         : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                         : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                       : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                        : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                       : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                      : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                      : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                       : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                    : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                         : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                      : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                        : out   std_logic;                                        -- mem_odt
			memory_mem_dm                         : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                      : in    std_logic                     := 'X';             -- oct_rzqin
			pll_locked_export                     : out   std_logic;                                        -- export
			pwm_sig_writeresponsevalid_n          : out   std_logic_vector(7 downto 0);                     -- writeresponsevalid_n
			reset_reset_n                         : in    std_logic                     := 'X';             -- reset_n
			select_sig_i2c_select                 : out   std_logic;                                        -- i2c_select
			select_sig_pwm_select                 : out   std_logic_vector(7 downto 0);                     -- pwm_select
			select_sig_spi_select                 : out   std_logic;                                        -- spi_select
			select_sig_uart_select                : out   std_logic;                                        -- uart_select
			spi_external_MISO                     : in    std_logic                     := 'X';             -- MISO
			spi_external_MOSI                     : out   std_logic;                                        -- MOSI
			spi_external_SCLK                     : out   std_logic;                                        -- SCLK
			spi_external_SS_n                     : out   std_logic;                                        -- SS_n
			uart_external_rxd                     : in    std_logic                     := 'X';             -- rxd
			uart_external_txd                     : out   std_logic                                         -- txd
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			adc_external_interface_sclk           => CONNECTED_TO_adc_external_interface_sclk,           --         adc_external_interface.sclk
			adc_external_interface_cs_n           => CONNECTED_TO_adc_external_interface_cs_n,           --                               .cs_n
			adc_external_interface_dout           => CONNECTED_TO_adc_external_interface_dout,           --                               .dout
			adc_external_interface_din            => CONNECTED_TO_adc_external_interface_din,            --                               .din
			button_pio_external_connection_export => CONNECTED_TO_button_pio_external_connection_export, -- button_pio_external_connection.export
			button_pio_s1_address                 => CONNECTED_TO_button_pio_s1_address,                 --                  button_pio_s1.address
			button_pio_s1_write_n                 => CONNECTED_TO_button_pio_s1_write_n,                 --                               .write_n
			button_pio_s1_writedata               => CONNECTED_TO_button_pio_s1_writedata,               --                               .writedata
			button_pio_s1_chipselect              => CONNECTED_TO_button_pio_s1_chipselect,              --                               .chipselect
			button_pio_s1_readdata                => CONNECTED_TO_button_pio_s1_readdata,                --                               .readdata
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                            clk.clk
			dipsw_pio_external_connection_export  => CONNECTED_TO_dipsw_pio_external_connection_export,  --  dipsw_pio_external_connection.export
			gpio_sig_gpio_direction               => CONNECTED_TO_gpio_sig_gpio_direction,               --                       gpio_sig.gpio_direction
			gpio_sig_gpio_output_sig              => CONNECTED_TO_gpio_sig_gpio_output_sig,              --                               .gpio_output_sig
			gpio_sig_gpio_input_sig               => CONNECTED_TO_gpio_sig_gpio_input_sig,               --                               .gpio_input_sig
			hps_0_f2h_cold_reset_req_reset_n      => CONNECTED_TO_hps_0_f2h_cold_reset_req_reset_n,      --       hps_0_f2h_cold_reset_req.reset_n
			hps_0_f2h_debug_reset_req_reset_n     => CONNECTED_TO_hps_0_f2h_debug_reset_req_reset_n,     --      hps_0_f2h_debug_reset_req.reset_n
			hps_0_f2h_stm_hw_events_stm_hwevents  => CONNECTED_TO_hps_0_f2h_stm_hw_events_stm_hwevents,  --        hps_0_f2h_stm_hw_events.stm_hwevents
			hps_0_f2h_warm_reset_req_reset_n      => CONNECTED_TO_hps_0_f2h_warm_reset_req_reset_n,      --       hps_0_f2h_warm_reset_req.reset_n
			hps_0_h2f_reset_reset_n               => CONNECTED_TO_hps_0_h2f_reset_reset_n,               --                hps_0_h2f_reset.reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CLK, --                   hps_0_hps_io.hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD0,   --                               .hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD1,   --                               .hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD2,   --                               .hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD3,   --                               .hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD0,   --                               .hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDIO,   --                               .hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC    => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDC,    --                               .hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CTL, --                               .hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CTL, --                               .hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CLK, --                               .hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD1,   --                               .hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD2,   --                               .hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD3,   --                               .hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_sdio_inst_CMD     => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CMD,     --                               .hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D0,      --                               .hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D1,      --                               .hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK     => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CLK,     --                               .hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D2,      --                               .hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D3,      --                               .hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D0,      --                               .hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D1,      --                               .hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D2,      --                               .hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D3,      --                               .hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D4,      --                               .hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D5,      --                               .hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D6,      --                               .hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D7,      --                               .hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_CLK,     --                               .hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_STP,     --                               .hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_DIR,     --                               .hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_NXT,     --                               .hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim1_inst_CLK    => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_CLK,    --                               .hps_io_spim1_inst_CLK
			hps_0_hps_io_hps_io_spim1_inst_MOSI   => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MOSI,   --                               .hps_io_spim1_inst_MOSI
			hps_0_hps_io_hps_io_spim1_inst_MISO   => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_MISO,   --                               .hps_io_spim1_inst_MISO
			hps_0_hps_io_hps_io_spim1_inst_SS0    => CONNECTED_TO_hps_0_hps_io_hps_io_spim1_inst_SS0,    --                               .hps_io_spim1_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX     => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_RX,     --                               .hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX     => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_TX,     --                               .hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SDA,     --                               .hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SCL,     --                               .hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SDA,     --                               .hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SCL,     --                               .hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO09,  --                               .hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO35,  --                               .hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO40  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO40,  --                               .hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO53  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO53,  --                               .hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO54,  --                               .hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO61,  --                               .hps_io_gpio_inst_GPIO61
			i2c_external_sda_in                   => CONNECTED_TO_i2c_external_sda_in,                   --                   i2c_external.sda_in
			i2c_external_scl_in                   => CONNECTED_TO_i2c_external_scl_in,                   --                               .scl_in
			i2c_external_sda_oe                   => CONNECTED_TO_i2c_external_sda_oe,                   --                               .sda_oe
			i2c_external_scl_oe                   => CONNECTED_TO_i2c_external_scl_oe,                   --                               .scl_oe
			ilc_irq_irq                           => CONNECTED_TO_ilc_irq_irq,                           --                        ilc_irq.irq
			led_pio_external_connection_export    => CONNECTED_TO_led_pio_external_connection_export,    --    led_pio_external_connection.export
			memory_mem_a                          => CONNECTED_TO_memory_mem_a,                          --                         memory.mem_a
			memory_mem_ba                         => CONNECTED_TO_memory_mem_ba,                         --                               .mem_ba
			memory_mem_ck                         => CONNECTED_TO_memory_mem_ck,                         --                               .mem_ck
			memory_mem_ck_n                       => CONNECTED_TO_memory_mem_ck_n,                       --                               .mem_ck_n
			memory_mem_cke                        => CONNECTED_TO_memory_mem_cke,                        --                               .mem_cke
			memory_mem_cs_n                       => CONNECTED_TO_memory_mem_cs_n,                       --                               .mem_cs_n
			memory_mem_ras_n                      => CONNECTED_TO_memory_mem_ras_n,                      --                               .mem_ras_n
			memory_mem_cas_n                      => CONNECTED_TO_memory_mem_cas_n,                      --                               .mem_cas_n
			memory_mem_we_n                       => CONNECTED_TO_memory_mem_we_n,                       --                               .mem_we_n
			memory_mem_reset_n                    => CONNECTED_TO_memory_mem_reset_n,                    --                               .mem_reset_n
			memory_mem_dq                         => CONNECTED_TO_memory_mem_dq,                         --                               .mem_dq
			memory_mem_dqs                        => CONNECTED_TO_memory_mem_dqs,                        --                               .mem_dqs
			memory_mem_dqs_n                      => CONNECTED_TO_memory_mem_dqs_n,                      --                               .mem_dqs_n
			memory_mem_odt                        => CONNECTED_TO_memory_mem_odt,                        --                               .mem_odt
			memory_mem_dm                         => CONNECTED_TO_memory_mem_dm,                         --                               .mem_dm
			memory_oct_rzqin                      => CONNECTED_TO_memory_oct_rzqin,                      --                               .oct_rzqin
			pll_locked_export                     => CONNECTED_TO_pll_locked_export,                     --                     pll_locked.export
			pwm_sig_writeresponsevalid_n          => CONNECTED_TO_pwm_sig_writeresponsevalid_n,          --                        pwm_sig.writeresponsevalid_n
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --                          reset.reset_n
			select_sig_i2c_select                 => CONNECTED_TO_select_sig_i2c_select,                 --                     select_sig.i2c_select
			select_sig_pwm_select                 => CONNECTED_TO_select_sig_pwm_select,                 --                               .pwm_select
			select_sig_spi_select                 => CONNECTED_TO_select_sig_spi_select,                 --                               .spi_select
			select_sig_uart_select                => CONNECTED_TO_select_sig_uart_select,                --                               .uart_select
			spi_external_MISO                     => CONNECTED_TO_spi_external_MISO,                     --                   spi_external.MISO
			spi_external_MOSI                     => CONNECTED_TO_spi_external_MOSI,                     --                               .MOSI
			spi_external_SCLK                     => CONNECTED_TO_spi_external_SCLK,                     --                               .SCLK
			spi_external_SS_n                     => CONNECTED_TO_spi_external_SS_n,                     --                               .SS_n
			uart_external_rxd                     => CONNECTED_TO_uart_external_rxd,                     --                  uart_external.rxd
			uart_external_txd                     => CONNECTED_TO_uart_external_txd                      --                               .txd
		);

