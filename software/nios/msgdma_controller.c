#include <modular_sgdma_dispatcher.h>

#include <altera_msgdma_csr_regs.h>
#include <altera_msgdma_descriptor_regs.h>
#include <sys/alt_errno.h>
#include <sys/alt_irq.h>
#include <io.h>

/**
 * See: 
 *  https://www.altera.com/documentation/sfo1400787952932.html#lro1402196946061
 * 
 * alt_msgdma_dev* alt_msgdma_open (const char* name)
 *
 *  *name — Character pointer to name of msgdma peripheral as registered with 
 *  the HAL. For example, an mSGDMA in Platform Designer would be opened by 
 *  asking for "MSGDMA_0_DISPATCHER_INTERNAL"
 *
 *
 * void alt_msgdma_init (alt_msgdma_dev *dev, alt_u32 ic_id, alt_u32 irq)
 *
 *  *dev – a pointer to mSGDMA instance.
 *  ic_id – id of irq interrupt controller
 *  irq – irq number that belonged to mSGDMA instance
 *
 *
 * int alt_msgdma_write_standard_descriptor 
 *  (alt_u32 csr_base, alt_u32 descriptor_base, 
 *  alt_msgdma_standard_descriptor *descriptor) 
 *
 *  csr_base – base address of the dispatcher CSR slave port.
 *  descriptor_base – base address of the dispatcher descriptor slave port.
 *  *descriptor – a pointer to a standard descriptor structure.
 *
 *
 * int alt_msgdma_standard_descriptor_async_transfer
 *  (alt_msgdma_dev *dev, alt_msgdma_standard_descriptor *desc) 
 *
 *  *dev — a pointer to msgdma instance.
 *  *desc — a pointer to a standard descriptor structure
 *
 *
 * int alt_msgdma_construct_standard_st_to_mm_descriptor 
 *  (alt_msgdma_dev *dev, alt_msgdma_standard_descriptor *descriptor, 
 *  alt_u32 *write_address, alt_u32 length, alt_u32 control)
 *
 *  *dev-a pointer to msgdma instance.
 *  *descriptor – a pointer to a standard descriptor structure.
 *  *write_address – a pointer to the base address of the destination memory.
 *  length - is used to specify the number of bytes to transfer per descriptor. 
 The largest possible value can be filled in is “0Xffffffff”.
 *  control – control field.
 */

/** Reference from
 * https://alteraforum.com/forum/showthread.php?t=56725
 */
// Modular Scatter-Gather DMA ST-to-MM with callback function

#include <stdio.h>

// DMA transfer
#include <altera_msgdma_descriptor_regs.h>
#include <altera_msgdma_csr_regs.h>
#include <altera_msgdma.h>

// Parallel I/O
#include <altera_avalon_pio_regs.h>
#include <sys/alt_irq.h>

#define DMA_LEN_BYTES 1600000 // Size of each DMA transfer in bytes
#define BUFFER_A 0x40000000 // SDRAM Buffer A address

// Modular Scatter-Gather DMA Globals
alt_msgdma_dev *DATA_DMA_A;
alt_msgdma_standard_descriptor DATA_DMA_A_desc;

// DMA variables
alt_u32 *DMA_write_addr_ptr_A; // Pointer for DMA A transfer write address
alt_u32 DMA_write_addr_A; // DMA A transfer write address

// Declare callback function
void DATA_DMA_A_callback_function(void* context);

void DATA_DMA_A_callback_function(void* context) {
    alt_msgdma_standard_descriptor_async_transfer(DATA _DMA_A, &DATA_DMA_A_desc);

    // Toggle PIO
    IOWR_ALTERA_AVALON_PIO_DATA(NIOS_DATA1_READY_BASE, 1);
    IOWR_ALTERA_AVALON_PIO_DATA(NIOS_DATA1_READY_BASE, 0);
}

int main() {
    // Open the streaming modular scatter-gather DMA controllers
    DATA_DMA_A = alt_msgdma_open("/dev/data1_msgdma_csr");
    if(DATA_DMA_A == NULL)
        printf("Could not open the mSG-DMA1\n");

    // Configure DMA callback functions
    alt_msgdma_register_callback(DATA_DMA_A, DATA_DMA_A_callback_function, 0, NULL);

    // Configure the DMA write address
    DMA_write_addr_A = (alt_u32) BUFFER_A ;
    DMA_write_addr_ptr_A = (alt_u32*)(DMA_write_addr_A);

    dma_len_bytes = (alt_u32) DMA_LEN_BYTES;

    // Construct the DMA descriptors
    alt_msgdma_construct_standard_st_to_mm_descriptor ( DATA_DMA_A,
            &DATA_DMA_A_desc, DMA_write_addr_ptr_A, dma_len_bytes,
            ALTERA_MSGDMA_DESCRIPTOR_CONTROL_TRANSFER_COMPLETE _IRQ_MASK );

    // Start DMA transfers
    alt_msgdma_standard_descriptor_async_transfer(DATA _DMA_A, &DATA_DMA_A_desc);

    return 0;
}
