OUTPUT_ARCH("riscv")
ENTRY(_start)
SECTIONS
{
    . = 0;
    .text : {
        *(.entry)
        *(.text)
      }
}

