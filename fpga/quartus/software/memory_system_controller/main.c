/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
//#include <modular_sgdma_dispatcher.h>

#include <altera_msgdma.h>
#include <altera_msgdma_csr_regs.h>
#include <altera_msgdma_descriptor_regs.h>
#include <sys/alt_errno.h>
#include <sys/alt_irq.h>
#include <io.h>

#define BUFFER_ADDR SAMPLE_BUFFER_BASE

int main()
{
  printf("NIOS II DMA Controller\n");

  int ret;

  alt_msgdma_dev* msgdma = alt_msgdma_open(MSGDMA_CSR_NAME);
  ret = alt_msgdma_init(msgdma, 0, 0);

  alt_msgdma_standard_descriptor* descriptor =
		  (alt_msgdma_standard_descriptor*) malloc(sizeof(
				  alt_msgdma_standard_descriptor));
  alt_u32* write_address = 0;
  alt_u32 length = NIOS_MEM_SIZE_VALUE / 2;
  alt_u32 control = 0;

  ret = alt_msgdma_construct_standard_st_to_mm_descriptor(msgdma, descriptor,
		  length, control);

  alt_u32 dma_write_addr = (alt_u32) BUDDER_ADDR;
  alt_u32* dma_write_addr_ptr = (alt_u32*) dma_write_addr;




  return 0;
}
