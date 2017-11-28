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
