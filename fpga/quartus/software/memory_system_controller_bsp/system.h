/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios' in SOPC Builder design 'soc_system'
 * SOPC Builder design path: ../../soc_system.sopcinfo
 *
 * Generated: Tue Nov 28 17:44:40 EST 2017
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00040820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x13
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00020020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x13
#define ALT_CPU_NAME "nios"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00020000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00040820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x13
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00020020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x13
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00020000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_TIMER
#define __ALTERA_MSGDMA
#define __ALTERA_NIOS2_GEN2


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone V"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x41058
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x41058
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x41058
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "soc_system"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK NIOS_CLK_TIMER
#define ALT_TIMESTAMP_CLK NIOS_CLK_TIMER


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x41058
#define JTAG_UART_IRQ 2
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * msgdma_csr configuration
 *
 */

#define ALT_MODULE_CLASS_msgdma_csr altera_msgdma
#define MSGDMA_CSR_BASE 0x41020
#define MSGDMA_CSR_BURST_ENABLE 0
#define MSGDMA_CSR_BURST_WRAPPING_SUPPORT 0
#define MSGDMA_CSR_CHANNEL_ENABLE 0
#define MSGDMA_CSR_CHANNEL_ENABLE_DERIVED 0
#define MSGDMA_CSR_CHANNEL_WIDTH 8
#define MSGDMA_CSR_DATA_FIFO_DEPTH 32
#define MSGDMA_CSR_DATA_WIDTH 32
#define MSGDMA_CSR_DESCRIPTOR_FIFO_DEPTH 128
#define MSGDMA_CSR_DMA_MODE 2
#define MSGDMA_CSR_ENHANCED_FEATURES 0
#define MSGDMA_CSR_ERROR_ENABLE 0
#define MSGDMA_CSR_ERROR_ENABLE_DERIVED 0
#define MSGDMA_CSR_ERROR_WIDTH 8
#define MSGDMA_CSR_IRQ 0
#define MSGDMA_CSR_IRQ_INTERRUPT_CONTROLLER_ID 0
#define MSGDMA_CSR_MAX_BURST_COUNT 2
#define MSGDMA_CSR_MAX_BYTE 1024
#define MSGDMA_CSR_MAX_STRIDE 1
#define MSGDMA_CSR_NAME "/dev/msgdma_csr"
#define MSGDMA_CSR_PACKET_ENABLE 0
#define MSGDMA_CSR_PACKET_ENABLE_DERIVED 0
#define MSGDMA_CSR_PREFETCHER_ENABLE 0
#define MSGDMA_CSR_PROGRAMMABLE_BURST_ENABLE 0
#define MSGDMA_CSR_RESPONSE_PORT 2
#define MSGDMA_CSR_SPAN 32
#define MSGDMA_CSR_STRIDE_ENABLE 0
#define MSGDMA_CSR_STRIDE_ENABLE_DERIVED 0
#define MSGDMA_CSR_TRANSFER_TYPE "Aligned Accesses"
#define MSGDMA_CSR_TYPE "altera_msgdma"


/*
 * msgdma_descriptor_slave configuration
 *
 */

#define ALT_MODULE_CLASS_msgdma_descriptor_slave altera_msgdma
#define MSGDMA_DESCRIPTOR_SLAVE_BASE 0x41040
#define MSGDMA_DESCRIPTOR_SLAVE_BURST_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_BURST_WRAPPING_SUPPORT 0
#define MSGDMA_DESCRIPTOR_SLAVE_CHANNEL_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_CHANNEL_ENABLE_DERIVED 0
#define MSGDMA_DESCRIPTOR_SLAVE_CHANNEL_WIDTH 8
#define MSGDMA_DESCRIPTOR_SLAVE_DATA_FIFO_DEPTH 32
#define MSGDMA_DESCRIPTOR_SLAVE_DATA_WIDTH 32
#define MSGDMA_DESCRIPTOR_SLAVE_DESCRIPTOR_FIFO_DEPTH 128
#define MSGDMA_DESCRIPTOR_SLAVE_DMA_MODE 2
#define MSGDMA_DESCRIPTOR_SLAVE_ENHANCED_FEATURES 0
#define MSGDMA_DESCRIPTOR_SLAVE_ERROR_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_ERROR_ENABLE_DERIVED 0
#define MSGDMA_DESCRIPTOR_SLAVE_ERROR_WIDTH 8
#define MSGDMA_DESCRIPTOR_SLAVE_IRQ -1
#define MSGDMA_DESCRIPTOR_SLAVE_IRQ_INTERRUPT_CONTROLLER_ID -1
#define MSGDMA_DESCRIPTOR_SLAVE_MAX_BURST_COUNT 2
#define MSGDMA_DESCRIPTOR_SLAVE_MAX_BYTE 1024
#define MSGDMA_DESCRIPTOR_SLAVE_MAX_STRIDE 1
#define MSGDMA_DESCRIPTOR_SLAVE_NAME "/dev/msgdma_descriptor_slave"
#define MSGDMA_DESCRIPTOR_SLAVE_PACKET_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_PACKET_ENABLE_DERIVED 0
#define MSGDMA_DESCRIPTOR_SLAVE_PREFETCHER_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_PROGRAMMABLE_BURST_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_RESPONSE_PORT 2
#define MSGDMA_DESCRIPTOR_SLAVE_SPAN 16
#define MSGDMA_DESCRIPTOR_SLAVE_STRIDE_ENABLE 0
#define MSGDMA_DESCRIPTOR_SLAVE_STRIDE_ENABLE_DERIVED 0
#define MSGDMA_DESCRIPTOR_SLAVE_TRANSFER_TYPE "Aligned Accesses"
#define MSGDMA_DESCRIPTOR_SLAVE_TYPE "altera_msgdma"


/*
 * nios_clk_timer configuration
 *
 */

#define ALT_MODULE_CLASS_nios_clk_timer altera_avalon_timer
#define NIOS_CLK_TIMER_ALWAYS_RUN 0
#define NIOS_CLK_TIMER_BASE 0x41000
#define NIOS_CLK_TIMER_COUNTER_SIZE 32
#define NIOS_CLK_TIMER_FIXED_PERIOD 0
#define NIOS_CLK_TIMER_FREQ 50000000
#define NIOS_CLK_TIMER_IRQ 1
#define NIOS_CLK_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define NIOS_CLK_TIMER_LOAD_VALUE 49999
#define NIOS_CLK_TIMER_MULT 0.001
#define NIOS_CLK_TIMER_NAME "/dev/nios_clk_timer"
#define NIOS_CLK_TIMER_PERIOD 1
#define NIOS_CLK_TIMER_PERIOD_UNITS "ms"
#define NIOS_CLK_TIMER_RESET_OUTPUT 0
#define NIOS_CLK_TIMER_SNAPSHOT 1
#define NIOS_CLK_TIMER_SPAN 32
#define NIOS_CLK_TIMER_TICKS_PER_SEC 1000
#define NIOS_CLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define NIOS_CLK_TIMER_TYPE "altera_avalon_timer"


/*
 * nios_mem configuration
 *
 */

#define ALT_MODULE_CLASS_nios_mem altera_avalon_onchip_memory2
#define NIOS_MEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define NIOS_MEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define NIOS_MEM_BASE 0x20000
#define NIOS_MEM_CONTENTS_INFO ""
#define NIOS_MEM_DUAL_PORT 0
#define NIOS_MEM_GUI_RAM_BLOCK_TYPE "AUTO"
#define NIOS_MEM_INIT_CONTENTS_FILE "soc_system_nios_mem"
#define NIOS_MEM_INIT_MEM_CONTENT 1
#define NIOS_MEM_INSTANCE_ID "NONE"
#define NIOS_MEM_IRQ -1
#define NIOS_MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NIOS_MEM_NAME "/dev/nios_mem"
#define NIOS_MEM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define NIOS_MEM_RAM_BLOCK_TYPE "AUTO"
#define NIOS_MEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define NIOS_MEM_SINGLE_CLOCK_OP 0
#define NIOS_MEM_SIZE_MULTIPLE 1
#define NIOS_MEM_SIZE_VALUE 102400
#define NIOS_MEM_SPAN 102400
#define NIOS_MEM_TYPE "altera_avalon_onchip_memory2"
#define NIOS_MEM_WRITABLE 1

#endif /* __SYSTEM_H_ */
