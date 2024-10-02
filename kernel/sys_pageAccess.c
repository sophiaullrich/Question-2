// You should copy this kernel function to sysproc.c
// and set up a system call for pageAccess() in xv6

int
sys_pageAccess(void)
{
	//sophia ullrich 22165598
	//completed function
	
    // Get the three function arguments from the pageAccess() system call
	uint64 usrpage_ptr;  // First argument - pointer to user space address
	int npages;          // Second argument - the number of pages to examine
	uint64 usraddr;      // Third argument - pointer to the bitmap
	argaddr(0, &usrpage_ptr);
	argint(1, &npages);
	argaddr(2, &usraddr);

	struct proc* p = myproc();
	if (npages > 64)
		return -1;

	pte_t *pte;
	uint64 va;
	uint64 bitmap = 0;

	for (int i = 0; i < npages; i++) {
		va = usrpage_ptr + i * PGSIZE;
		pte = walk(p->pagetable, va, 0);
		if (pte == 0)
			return -1;
		if (*pte & PTE_A)
			bitmap |= (1ULL << i);
	}

	// Return the bitmap pointer to the user program
	if (copyout(p->pagetable, usraddr, (char*)&bitmap, sizeof(bitmap)) < 0)
		return -1;

	return 0;
}

		va = usrpage_ptr + i * PGSIZE;
		pte = walk(p->pagetable, va, 0);
		if (pte == 0)
			return -1;
		if (*pte & PTE_A)
			bitmap |= (1ULL << i);
	}

	// Return the bitmap pointer to the user program
	if (copyout(p->pagetable, usraddr, (char*)&bitmap, sizeof(bitmap)) < 0)
		return -1;

	return 0;
}
