#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
  consoleinit();
  printfinit();
  printf("xv6 kernel is booting\n");  // Add this line

  kinit();         // physical page allocator
  kvminit();       // create kernel page table
  kvminithart();   // turn on paging
  procinit();      // process table
  trapinit();      // trap vectors
  trapinithart();  // install kernel trap vector
  plicinit();      // set up interrupt controller
  plicinithart();  // ask PLIC for device interrupts
  binit();         // buffer cache
  iinit();         // inode cache
  fileinit();      // file table
  virtio_disk_init(); // emulated hard disk
  printf("xv6 kernel initialization complete\n");  // Add this line

  userinit();      // first user process
  printf("userinit complete\n");  // Add this line

  scheduler();     // start running processes
}
