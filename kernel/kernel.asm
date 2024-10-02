
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	95010113          	addi	sp,sp,-1712 # 80007950 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	ra,80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	0x14d,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddb7f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d9078793          	addi	a5,a5,-624 # 80000e10 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05263          	blez	a2,80000126 <consolewrite+0x56>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	05e020ef          	jal	ra,80002158 <either_copyin>
    800000fe:	01550a63          	beq	a0,s5,80000112 <consolewrite+0x42>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7da000ef          	jal	ra,800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
  }

  return i;
}
    80000112:	854a                	mv	a0,s2
    80000114:	60a6                	ld	ra,72(sp)
    80000116:	6406                	ld	s0,64(sp)
    80000118:	74e2                	ld	s1,56(sp)
    8000011a:	7942                	ld	s2,48(sp)
    8000011c:	79a2                	ld	s3,40(sp)
    8000011e:	7a02                	ld	s4,32(sp)
    80000120:	6ae2                	ld	s5,24(sp)
    80000122:	6161                	addi	sp,sp,80
    80000124:	8082                	ret
  for(i = 0; i < n; i++){
    80000126:	4901                	li	s2,0
    80000128:	b7ed                	j	80000112 <consolewrite+0x42>

000000008000012a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012a:	7159                	addi	sp,sp,-112
    8000012c:	f486                	sd	ra,104(sp)
    8000012e:	f0a2                	sd	s0,96(sp)
    80000130:	eca6                	sd	s1,88(sp)
    80000132:	e8ca                	sd	s2,80(sp)
    80000134:	e4ce                	sd	s3,72(sp)
    80000136:	e0d2                	sd	s4,64(sp)
    80000138:	fc56                	sd	s5,56(sp)
    8000013a:	f85a                	sd	s6,48(sp)
    8000013c:	f45e                	sd	s7,40(sp)
    8000013e:	f062                	sd	s8,32(sp)
    80000140:	ec66                	sd	s9,24(sp)
    80000142:	e86a                	sd	s10,16(sp)
    80000144:	1880                	addi	s0,sp,112
    80000146:	8aaa                	mv	s5,a0
    80000148:	8a2e                	mv	s4,a1
    8000014a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000014c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000150:	00010517          	auipc	a0,0x10
    80000154:	80050513          	addi	a0,a0,-2048 # 8000f950 <cons>
    80000158:	243000ef          	jal	ra,80000b9a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000015c:	0000f497          	auipc	s1,0xf
    80000160:	7f448493          	addi	s1,s1,2036 # 8000f950 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000164:	00010917          	auipc	s2,0x10
    80000168:	88490913          	addi	s2,s2,-1916 # 8000f9e8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000016c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000016e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000170:	4ca9                	li	s9,10
  while(n > 0){
    80000172:	07305363          	blez	s3,800001d8 <consoleread+0xae>
    while(cons.r == cons.w){
    80000176:	0984a783          	lw	a5,152(s1)
    8000017a:	09c4a703          	lw	a4,156(s1)
    8000017e:	02f71163          	bne	a4,a5,800001a0 <consoleread+0x76>
      if(killed(myproc())){
    80000182:	664010ef          	jal	ra,800017e6 <myproc>
    80000186:	665010ef          	jal	ra,80001fea <killed>
    8000018a:	e125                	bnez	a0,800001ea <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    8000018c:	85a6                	mv	a1,s1
    8000018e:	854a                	mv	a0,s2
    80000190:	423010ef          	jal	ra,80001db2 <sleep>
    while(cons.r == cons.w){
    80000194:	0984a783          	lw	a5,152(s1)
    80000198:	09c4a703          	lw	a4,156(s1)
    8000019c:	fef703e3          	beq	a4,a5,80000182 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0017871b          	addiw	a4,a5,1
    800001a4:	08e4ac23          	sw	a4,152(s1)
    800001a8:	07f7f713          	andi	a4,a5,127
    800001ac:	9726                	add	a4,a4,s1
    800001ae:	01874703          	lbu	a4,24(a4)
    800001b2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001b6:	057d0f63          	beq	s10,s7,80000214 <consoleread+0xea>
    cbuf = c;
    800001ba:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001be:	4685                	li	a3,1
    800001c0:	f9f40613          	addi	a2,s0,-97
    800001c4:	85d2                	mv	a1,s4
    800001c6:	8556                	mv	a0,s5
    800001c8:	747010ef          	jal	ra,8000210e <either_copyout>
    800001cc:	01850663          	beq	a0,s8,800001d8 <consoleread+0xae>
    dst++;
    800001d0:	0a05                	addi	s4,s4,1
    --n;
    800001d2:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800001d4:	f99d1fe3          	bne	s10,s9,80000172 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001d8:	0000f517          	auipc	a0,0xf
    800001dc:	77850513          	addi	a0,a0,1912 # 8000f950 <cons>
    800001e0:	253000ef          	jal	ra,80000c32 <release>

  return target - n;
    800001e4:	413b053b          	subw	a0,s6,s3
    800001e8:	a801                	j	800001f8 <consoleread+0xce>
        release(&cons.lock);
    800001ea:	0000f517          	auipc	a0,0xf
    800001ee:	76650513          	addi	a0,a0,1894 # 8000f950 <cons>
    800001f2:	241000ef          	jal	ra,80000c32 <release>
        return -1;
    800001f6:	557d                	li	a0,-1
}
    800001f8:	70a6                	ld	ra,104(sp)
    800001fa:	7406                	ld	s0,96(sp)
    800001fc:	64e6                	ld	s1,88(sp)
    800001fe:	6946                	ld	s2,80(sp)
    80000200:	69a6                	ld	s3,72(sp)
    80000202:	6a06                	ld	s4,64(sp)
    80000204:	7ae2                	ld	s5,56(sp)
    80000206:	7b42                	ld	s6,48(sp)
    80000208:	7ba2                	ld	s7,40(sp)
    8000020a:	7c02                	ld	s8,32(sp)
    8000020c:	6ce2                	ld	s9,24(sp)
    8000020e:	6d42                	ld	s10,16(sp)
    80000210:	6165                	addi	sp,sp,112
    80000212:	8082                	ret
      if(n < target){
    80000214:	0009871b          	sext.w	a4,s3
    80000218:	fd6770e3          	bgeu	a4,s6,800001d8 <consoleread+0xae>
        cons.r--;
    8000021c:	0000f717          	auipc	a4,0xf
    80000220:	7cf72623          	sw	a5,1996(a4) # 8000f9e8 <cons+0x98>
    80000224:	bf55                	j	800001d8 <consoleread+0xae>

0000000080000226 <consputc>:
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000022e:	10000793          	li	a5,256
    80000232:	00f50863          	beq	a0,a5,80000242 <consputc+0x1c>
    uartputc_sync(c);
    80000236:	5d4000ef          	jal	ra,8000080a <uartputc_sync>
}
    8000023a:	60a2                	ld	ra,8(sp)
    8000023c:	6402                	ld	s0,0(sp)
    8000023e:	0141                	addi	sp,sp,16
    80000240:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000242:	4521                	li	a0,8
    80000244:	5c6000ef          	jal	ra,8000080a <uartputc_sync>
    80000248:	02000513          	li	a0,32
    8000024c:	5be000ef          	jal	ra,8000080a <uartputc_sync>
    80000250:	4521                	li	a0,8
    80000252:	5b8000ef          	jal	ra,8000080a <uartputc_sync>
    80000256:	b7d5                	j	8000023a <consputc+0x14>

0000000080000258 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000258:	1101                	addi	sp,sp,-32
    8000025a:	ec06                	sd	ra,24(sp)
    8000025c:	e822                	sd	s0,16(sp)
    8000025e:	e426                	sd	s1,8(sp)
    80000260:	e04a                	sd	s2,0(sp)
    80000262:	1000                	addi	s0,sp,32
    80000264:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000266:	0000f517          	auipc	a0,0xf
    8000026a:	6ea50513          	addi	a0,a0,1770 # 8000f950 <cons>
    8000026e:	12d000ef          	jal	ra,80000b9a <acquire>

  switch(c){
    80000272:	47d5                	li	a5,21
    80000274:	0af48063          	beq	s1,a5,80000314 <consoleintr+0xbc>
    80000278:	0297c663          	blt	a5,s1,800002a4 <consoleintr+0x4c>
    8000027c:	47a1                	li	a5,8
    8000027e:	0cf48f63          	beq	s1,a5,8000035c <consoleintr+0x104>
    80000282:	47c1                	li	a5,16
    80000284:	10f49063          	bne	s1,a5,80000384 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80000288:	71b010ef          	jal	ra,800021a2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028c:	0000f517          	auipc	a0,0xf
    80000290:	6c450513          	addi	a0,a0,1732 # 8000f950 <cons>
    80000294:	19f000ef          	jal	ra,80000c32 <release>
}
    80000298:	60e2                	ld	ra,24(sp)
    8000029a:	6442                	ld	s0,16(sp)
    8000029c:	64a2                	ld	s1,8(sp)
    8000029e:	6902                	ld	s2,0(sp)
    800002a0:	6105                	addi	sp,sp,32
    800002a2:	8082                	ret
  switch(c){
    800002a4:	07f00793          	li	a5,127
    800002a8:	0af48a63          	beq	s1,a5,8000035c <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002ac:	0000f717          	auipc	a4,0xf
    800002b0:	6a470713          	addi	a4,a4,1700 # 8000f950 <cons>
    800002b4:	0a072783          	lw	a5,160(a4)
    800002b8:	09872703          	lw	a4,152(a4)
    800002bc:	9f99                	subw	a5,a5,a4
    800002be:	07f00713          	li	a4,127
    800002c2:	fcf765e3          	bltu	a4,a5,8000028c <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002c6:	47b5                	li	a5,13
    800002c8:	0cf48163          	beq	s1,a5,8000038a <consoleintr+0x132>
      consputc(c);
    800002cc:	8526                	mv	a0,s1
    800002ce:	f59ff0ef          	jal	ra,80000226 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d2:	0000f797          	auipc	a5,0xf
    800002d6:	67e78793          	addi	a5,a5,1662 # 8000f950 <cons>
    800002da:	0a07a683          	lw	a3,160(a5)
    800002de:	0016871b          	addiw	a4,a3,1
    800002e2:	0007061b          	sext.w	a2,a4
    800002e6:	0ae7a023          	sw	a4,160(a5)
    800002ea:	07f6f693          	andi	a3,a3,127
    800002ee:	97b6                	add	a5,a5,a3
    800002f0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002f4:	47a9                	li	a5,10
    800002f6:	0af48f63          	beq	s1,a5,800003b4 <consoleintr+0x15c>
    800002fa:	4791                	li	a5,4
    800002fc:	0af48c63          	beq	s1,a5,800003b4 <consoleintr+0x15c>
    80000300:	0000f797          	auipc	a5,0xf
    80000304:	6e87a783          	lw	a5,1768(a5) # 8000f9e8 <cons+0x98>
    80000308:	9f1d                	subw	a4,a4,a5
    8000030a:	08000793          	li	a5,128
    8000030e:	f6f71fe3          	bne	a4,a5,8000028c <consoleintr+0x34>
    80000312:	a04d                	j	800003b4 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000314:	0000f717          	auipc	a4,0xf
    80000318:	63c70713          	addi	a4,a4,1596 # 8000f950 <cons>
    8000031c:	0a072783          	lw	a5,160(a4)
    80000320:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000324:	0000f497          	auipc	s1,0xf
    80000328:	62c48493          	addi	s1,s1,1580 # 8000f950 <cons>
    while(cons.e != cons.w &&
    8000032c:	4929                	li	s2,10
    8000032e:	f4f70fe3          	beq	a4,a5,8000028c <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000332:	37fd                	addiw	a5,a5,-1
    80000334:	07f7f713          	andi	a4,a5,127
    80000338:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000033a:	01874703          	lbu	a4,24(a4)
    8000033e:	f52707e3          	beq	a4,s2,8000028c <consoleintr+0x34>
      cons.e--;
    80000342:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000346:	10000513          	li	a0,256
    8000034a:	eddff0ef          	jal	ra,80000226 <consputc>
    while(cons.e != cons.w &&
    8000034e:	0a04a783          	lw	a5,160(s1)
    80000352:	09c4a703          	lw	a4,156(s1)
    80000356:	fcf71ee3          	bne	a4,a5,80000332 <consoleintr+0xda>
    8000035a:	bf0d                	j	8000028c <consoleintr+0x34>
    if(cons.e != cons.w){
    8000035c:	0000f717          	auipc	a4,0xf
    80000360:	5f470713          	addi	a4,a4,1524 # 8000f950 <cons>
    80000364:	0a072783          	lw	a5,160(a4)
    80000368:	09c72703          	lw	a4,156(a4)
    8000036c:	f2f700e3          	beq	a4,a5,8000028c <consoleintr+0x34>
      cons.e--;
    80000370:	37fd                	addiw	a5,a5,-1
    80000372:	0000f717          	auipc	a4,0xf
    80000376:	66f72f23          	sw	a5,1662(a4) # 8000f9f0 <cons+0xa0>
      consputc(BACKSPACE);
    8000037a:	10000513          	li	a0,256
    8000037e:	ea9ff0ef          	jal	ra,80000226 <consputc>
    80000382:	b729                	j	8000028c <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000384:	f00484e3          	beqz	s1,8000028c <consoleintr+0x34>
    80000388:	b715                	j	800002ac <consoleintr+0x54>
      consputc(c);
    8000038a:	4529                	li	a0,10
    8000038c:	e9bff0ef          	jal	ra,80000226 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000390:	0000f797          	auipc	a5,0xf
    80000394:	5c078793          	addi	a5,a5,1472 # 8000f950 <cons>
    80000398:	0a07a703          	lw	a4,160(a5)
    8000039c:	0017069b          	addiw	a3,a4,1
    800003a0:	0006861b          	sext.w	a2,a3
    800003a4:	0ad7a023          	sw	a3,160(a5)
    800003a8:	07f77713          	andi	a4,a4,127
    800003ac:	97ba                	add	a5,a5,a4
    800003ae:	4729                	li	a4,10
    800003b0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003b4:	0000f797          	auipc	a5,0xf
    800003b8:	62c7ac23          	sw	a2,1592(a5) # 8000f9ec <cons+0x9c>
        wakeup(&cons.r);
    800003bc:	0000f517          	auipc	a0,0xf
    800003c0:	62c50513          	addi	a0,a0,1580 # 8000f9e8 <cons+0x98>
    800003c4:	23b010ef          	jal	ra,80001dfe <wakeup>
    800003c8:	b5d1                	j	8000028c <consoleintr+0x34>

00000000800003ca <consoleinit>:

void
consoleinit(void)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e406                	sd	ra,8(sp)
    800003ce:	e022                	sd	s0,0(sp)
    800003d0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d2:	00007597          	auipc	a1,0x7
    800003d6:	c3e58593          	addi	a1,a1,-962 # 80007010 <etext+0x10>
    800003da:	0000f517          	auipc	a0,0xf
    800003de:	57650513          	addi	a0,a0,1398 # 8000f950 <cons>
    800003e2:	738000ef          	jal	ra,80000b1a <initlock>

  uartinit();
    800003e6:	3d8000ef          	jal	ra,800007be <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003ea:	0001f797          	auipc	a5,0x1f
    800003ee:	6fe78793          	addi	a5,a5,1790 # 8001fae8 <devsw>
    800003f2:	00000717          	auipc	a4,0x0
    800003f6:	d3870713          	addi	a4,a4,-712 # 8000012a <consoleread>
    800003fa:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003fc:	00000717          	auipc	a4,0x0
    80000400:	cd470713          	addi	a4,a4,-812 # 800000d0 <consolewrite>
    80000404:	ef98                	sd	a4,24(a5)
}
    80000406:	60a2                	ld	ra,8(sp)
    80000408:	6402                	ld	s0,0(sp)
    8000040a:	0141                	addi	sp,sp,16
    8000040c:	8082                	ret

000000008000040e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000040e:	7179                	addi	sp,sp,-48
    80000410:	f406                	sd	ra,40(sp)
    80000412:	f022                	sd	s0,32(sp)
    80000414:	ec26                	sd	s1,24(sp)
    80000416:	e84a                	sd	s2,16(sp)
    80000418:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000041a:	c219                	beqz	a2,80000420 <printint+0x12>
    8000041c:	06054f63          	bltz	a0,8000049a <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80000420:	4881                	li	a7,0
    80000422:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000426:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000428:	00007617          	auipc	a2,0x7
    8000042c:	c1060613          	addi	a2,a2,-1008 # 80007038 <digits>
    80000430:	883e                	mv	a6,a5
    80000432:	2785                	addiw	a5,a5,1
    80000434:	02b57733          	remu	a4,a0,a1
    80000438:	9732                	add	a4,a4,a2
    8000043a:	00074703          	lbu	a4,0(a4)
    8000043e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000442:	872a                	mv	a4,a0
    80000444:	02b55533          	divu	a0,a0,a1
    80000448:	0685                	addi	a3,a3,1
    8000044a:	feb773e3          	bgeu	a4,a1,80000430 <printint+0x22>

  if(sign)
    8000044e:	00088b63          	beqz	a7,80000464 <printint+0x56>
    buf[i++] = '-';
    80000452:	fe040713          	addi	a4,s0,-32
    80000456:	97ba                	add	a5,a5,a4
    80000458:	02d00713          	li	a4,45
    8000045c:	fee78823          	sb	a4,-16(a5)
    80000460:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000464:	02f05563          	blez	a5,8000048e <printint+0x80>
    80000468:	fd040713          	addi	a4,s0,-48
    8000046c:	00f704b3          	add	s1,a4,a5
    80000470:	fff70913          	addi	s2,a4,-1
    80000474:	993e                	add	s2,s2,a5
    80000476:	37fd                	addiw	a5,a5,-1
    80000478:	1782                	slli	a5,a5,0x20
    8000047a:	9381                	srli	a5,a5,0x20
    8000047c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000480:	fff4c503          	lbu	a0,-1(s1)
    80000484:	da3ff0ef          	jal	ra,80000226 <consputc>
  while(--i >= 0)
    80000488:	14fd                	addi	s1,s1,-1
    8000048a:	ff249be3          	bne	s1,s2,80000480 <printint+0x72>
}
    8000048e:	70a2                	ld	ra,40(sp)
    80000490:	7402                	ld	s0,32(sp)
    80000492:	64e2                	ld	s1,24(sp)
    80000494:	6942                	ld	s2,16(sp)
    80000496:	6145                	addi	sp,sp,48
    80000498:	8082                	ret
    x = -xx;
    8000049a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000049e:	4885                	li	a7,1
    x = -xx;
    800004a0:	b749                	j	80000422 <printint+0x14>

00000000800004a2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004a2:	7155                	addi	sp,sp,-208
    800004a4:	e506                	sd	ra,136(sp)
    800004a6:	e122                	sd	s0,128(sp)
    800004a8:	fca6                	sd	s1,120(sp)
    800004aa:	f8ca                	sd	s2,112(sp)
    800004ac:	f4ce                	sd	s3,104(sp)
    800004ae:	f0d2                	sd	s4,96(sp)
    800004b0:	ecd6                	sd	s5,88(sp)
    800004b2:	e8da                	sd	s6,80(sp)
    800004b4:	e4de                	sd	s7,72(sp)
    800004b6:	e0e2                	sd	s8,64(sp)
    800004b8:	fc66                	sd	s9,56(sp)
    800004ba:	f86a                	sd	s10,48(sp)
    800004bc:	f46e                	sd	s11,40(sp)
    800004be:	0900                	addi	s0,sp,144
    800004c0:	8a2a                	mv	s4,a0
    800004c2:	e40c                	sd	a1,8(s0)
    800004c4:	e810                	sd	a2,16(s0)
    800004c6:	ec14                	sd	a3,24(s0)
    800004c8:	f018                	sd	a4,32(s0)
    800004ca:	f41c                	sd	a5,40(s0)
    800004cc:	03043823          	sd	a6,48(s0)
    800004d0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004d4:	0000f797          	auipc	a5,0xf
    800004d8:	53c7a783          	lw	a5,1340(a5) # 8000fa10 <pr+0x18>
    800004dc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004e0:	eb9d                	bnez	a5,80000516 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004e2:	00840793          	addi	a5,s0,8
    800004e6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004ea:	00054503          	lbu	a0,0(a0)
    800004ee:	24050463          	beqz	a0,80000736 <printf+0x294>
    800004f2:	4981                	li	s3,0
    if(cx != '%'){
    800004f4:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004f8:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004fc:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000500:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000504:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000508:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000050c:	00007b97          	auipc	s7,0x7
    80000510:	b2cb8b93          	addi	s7,s7,-1236 # 80007038 <digits>
    80000514:	a081                	j	80000554 <printf+0xb2>
    acquire(&pr.lock);
    80000516:	0000f517          	auipc	a0,0xf
    8000051a:	4e250513          	addi	a0,a0,1250 # 8000f9f8 <pr>
    8000051e:	67c000ef          	jal	ra,80000b9a <acquire>
  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	f171                	bnez	a0,800004f2 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000530:	0000f517          	auipc	a0,0xf
    80000534:	4c850513          	addi	a0,a0,1224 # 8000f9f8 <pr>
    80000538:	6fa000ef          	jal	ra,80000c32 <release>
    8000053c:	aaed                	j	80000736 <printf+0x294>
      consputc(cx);
    8000053e:	ce9ff0ef          	jal	ra,80000226 <consputc>
      continue;
    80000542:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000544:	0014899b          	addiw	s3,s1,1
    80000548:	013a07b3          	add	a5,s4,s3
    8000054c:	0007c503          	lbu	a0,0(a5)
    80000550:	1c050f63          	beqz	a0,8000072e <printf+0x28c>
    if(cx != '%'){
    80000554:	ff5515e3          	bne	a0,s5,8000053e <printf+0x9c>
    i++;
    80000558:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000055c:	009a07b3          	add	a5,s4,s1
    80000560:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000564:	1c090563          	beqz	s2,8000072e <printf+0x28c>
    80000568:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000056c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000056e:	c789                	beqz	a5,80000578 <printf+0xd6>
    80000570:	009a0733          	add	a4,s4,s1
    80000574:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000578:	03690463          	beq	s2,s6,800005a0 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    8000057c:	03890e63          	beq	s2,s8,800005b8 <printf+0x116>
    } else if(c0 == 'u'){
    80000580:	0b990d63          	beq	s2,s9,8000063a <printf+0x198>
    } else if(c0 == 'x'){
    80000584:	11a90363          	beq	s2,s10,8000068a <printf+0x1e8>
    } else if(c0 == 'p'){
    80000588:	13b90b63          	beq	s2,s11,800006be <printf+0x21c>
    } else if(c0 == 's'){
    8000058c:	07300793          	li	a5,115
    80000590:	16f90363          	beq	s2,a5,800006f6 <printf+0x254>
    } else if(c0 == '%'){
    80000594:	03591c63          	bne	s2,s5,800005cc <printf+0x12a>
      consputc('%');
    80000598:	8556                	mv	a0,s5
    8000059a:	c8dff0ef          	jal	ra,80000226 <consputc>
    8000059e:	b75d                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    800005a0:	f8843783          	ld	a5,-120(s0)
    800005a4:	00878713          	addi	a4,a5,8
    800005a8:	f8e43423          	sd	a4,-120(s0)
    800005ac:	4605                	li	a2,1
    800005ae:	45a9                	li	a1,10
    800005b0:	4388                	lw	a0,0(a5)
    800005b2:	e5dff0ef          	jal	ra,8000040e <printint>
    800005b6:	b779                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b8:	03678163          	beq	a5,s6,800005da <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005bc:	03878d63          	beq	a5,s8,800005f6 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800005c0:	09978963          	beq	a5,s9,80000652 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005c4:	03878b63          	beq	a5,s8,800005fa <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800005c8:	0da78d63          	beq	a5,s10,800006a2 <printf+0x200>
      consputc('%');
    800005cc:	8556                	mv	a0,s5
    800005ce:	c59ff0ef          	jal	ra,80000226 <consputc>
      consputc(c0);
    800005d2:	854a                	mv	a0,s2
    800005d4:	c53ff0ef          	jal	ra,80000226 <consputc>
    800005d8:	b7b5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	6388                	ld	a0,0(a5)
    800005ec:	e23ff0ef          	jal	ra,8000040e <printint>
      i += 1;
    800005f0:	0029849b          	addiw	s1,s3,2
    800005f4:	bf81                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03668463          	beq	a3,s6,8000061e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005fa:	07968a63          	beq	a3,s9,8000066e <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800005fe:	fda697e3          	bne	a3,s10,800005cc <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4601                	li	a2,0
    80000610:	45c1                	li	a1,16
    80000612:	6388                	ld	a0,0(a5)
    80000614:	dfbff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000618:	0039849b          	addiw	s1,s3,3
    8000061c:	b725                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000061e:	f8843783          	ld	a5,-120(s0)
    80000622:	00878713          	addi	a4,a5,8
    80000626:	f8e43423          	sd	a4,-120(s0)
    8000062a:	4605                	li	a2,1
    8000062c:	45a9                	li	a1,10
    8000062e:	6388                	ld	a0,0(a5)
    80000630:	ddfff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000634:	0039849b          	addiw	s1,s3,3
    80000638:	b731                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    8000063a:	f8843783          	ld	a5,-120(s0)
    8000063e:	00878713          	addi	a4,a5,8
    80000642:	f8e43423          	sd	a4,-120(s0)
    80000646:	4601                	li	a2,0
    80000648:	45a9                	li	a1,10
    8000064a:	4388                	lw	a0,0(a5)
    8000064c:	dc3ff0ef          	jal	ra,8000040e <printint>
    80000650:	bdd5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	dabff0ef          	jal	ra,8000040e <printint>
      i += 1;
    80000668:	0029849b          	addiw	s1,s3,2
    8000066c:	bde1                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	6388                	ld	a0,0(a5)
    80000680:	d8fff0ef          	jal	ra,8000040e <printint>
      i += 2;
    80000684:	0039849b          	addiw	s1,s3,3
    80000688:	bd75                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	4601                	li	a2,0
    80000698:	45c1                	li	a1,16
    8000069a:	4388                	lw	a0,0(a5)
    8000069c:	d73ff0ef          	jal	ra,8000040e <printint>
    800006a0:	b555                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d5bff0ef          	jal	ra,8000040e <printint>
      i += 1;
    800006b8:	0029849b          	addiw	s1,s3,2
    800006bc:	b561                	j	80000544 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ce:	03000513          	li	a0,48
    800006d2:	b55ff0ef          	jal	ra,80000226 <consputc>
  consputc('x');
    800006d6:	856a                	mv	a0,s10
    800006d8:	b4fff0ef          	jal	ra,80000226 <consputc>
    800006dc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006de:	03c9d793          	srli	a5,s3,0x3c
    800006e2:	97de                	add	a5,a5,s7
    800006e4:	0007c503          	lbu	a0,0(a5)
    800006e8:	b3fff0ef          	jal	ra,80000226 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ec:	0992                	slli	s3,s3,0x4
    800006ee:	397d                	addiw	s2,s2,-1
    800006f0:	fe0917e3          	bnez	s2,800006de <printf+0x23c>
    800006f4:	bd81                	j	80000544 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	0007b903          	ld	s2,0(a5)
    80000706:	00090d63          	beqz	s2,80000720 <printf+0x27e>
      for(; *s; s++)
    8000070a:	00094503          	lbu	a0,0(s2)
    8000070e:	e2050be3          	beqz	a0,80000544 <printf+0xa2>
        consputc(*s);
    80000712:	b15ff0ef          	jal	ra,80000226 <consputc>
      for(; *s; s++)
    80000716:	0905                	addi	s2,s2,1
    80000718:	00094503          	lbu	a0,0(s2)
    8000071c:	f97d                	bnez	a0,80000712 <printf+0x270>
    8000071e:	b51d                	j	80000544 <printf+0xa2>
        s = "(null)";
    80000720:	00007917          	auipc	s2,0x7
    80000724:	8f890913          	addi	s2,s2,-1800 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000728:	02800513          	li	a0,40
    8000072c:	b7dd                	j	80000712 <printf+0x270>
  if(locking)
    8000072e:	f7843783          	ld	a5,-136(s0)
    80000732:	de079fe3          	bnez	a5,80000530 <printf+0x8e>

  return 0;
}
    80000736:	4501                	li	a0,0
    80000738:	60aa                	ld	ra,136(sp)
    8000073a:	640a                	ld	s0,128(sp)
    8000073c:	74e6                	ld	s1,120(sp)
    8000073e:	7946                	ld	s2,112(sp)
    80000740:	79a6                	ld	s3,104(sp)
    80000742:	7a06                	ld	s4,96(sp)
    80000744:	6ae6                	ld	s5,88(sp)
    80000746:	6b46                	ld	s6,80(sp)
    80000748:	6ba6                	ld	s7,72(sp)
    8000074a:	6c06                	ld	s8,64(sp)
    8000074c:	7ce2                	ld	s9,56(sp)
    8000074e:	7d42                	ld	s10,48(sp)
    80000750:	7da2                	ld	s11,40(sp)
    80000752:	6169                	addi	sp,sp,208
    80000754:	8082                	ret

0000000080000756 <panic>:

void
panic(char *s)
{
    80000756:	1101                	addi	sp,sp,-32
    80000758:	ec06                	sd	ra,24(sp)
    8000075a:	e822                	sd	s0,16(sp)
    8000075c:	e426                	sd	s1,8(sp)
    8000075e:	1000                	addi	s0,sp,32
    80000760:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000762:	0000f797          	auipc	a5,0xf
    80000766:	2a07a723          	sw	zero,686(a5) # 8000fa10 <pr+0x18>
  printf("panic: ");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	8b650513          	addi	a0,a0,-1866 # 80007020 <etext+0x20>
    80000772:	d31ff0ef          	jal	ra,800004a2 <printf>
  printf("%s\n", s);
    80000776:	85a6                	mv	a1,s1
    80000778:	00007517          	auipc	a0,0x7
    8000077c:	8b050513          	addi	a0,a0,-1872 # 80007028 <etext+0x28>
    80000780:	d23ff0ef          	jal	ra,800004a2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000784:	4785                	li	a5,1
    80000786:	00007717          	auipc	a4,0x7
    8000078a:	18f72523          	sw	a5,394(a4) # 80007910 <panicked>
  for(;;)
    8000078e:	a001                	j	8000078e <panic+0x38>

0000000080000790 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000790:	1101                	addi	sp,sp,-32
    80000792:	ec06                	sd	ra,24(sp)
    80000794:	e822                	sd	s0,16(sp)
    80000796:	e426                	sd	s1,8(sp)
    80000798:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000079a:	0000f497          	auipc	s1,0xf
    8000079e:	25e48493          	addi	s1,s1,606 # 8000f9f8 <pr>
    800007a2:	00007597          	auipc	a1,0x7
    800007a6:	88e58593          	addi	a1,a1,-1906 # 80007030 <etext+0x30>
    800007aa:	8526                	mv	a0,s1
    800007ac:	36e000ef          	jal	ra,80000b1a <initlock>
  pr.locking = 1;
    800007b0:	4785                	li	a5,1
    800007b2:	cc9c                	sw	a5,24(s1)
}
    800007b4:	60e2                	ld	ra,24(sp)
    800007b6:	6442                	ld	s0,16(sp)
    800007b8:	64a2                	ld	s1,8(sp)
    800007ba:	6105                	addi	sp,sp,32
    800007bc:	8082                	ret

00000000800007be <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007be:	1141                	addi	sp,sp,-16
    800007c0:	e406                	sd	ra,8(sp)
    800007c2:	e022                	sd	s0,0(sp)
    800007c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007c6:	100007b7          	lui	a5,0x10000
    800007ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ce:	f8000713          	li	a4,-128
    800007d2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007d6:	470d                	li	a4,3
    800007d8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007e4:	469d                	li	a3,7
    800007e6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ea:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ee:	00007597          	auipc	a1,0x7
    800007f2:	86258593          	addi	a1,a1,-1950 # 80007050 <digits+0x18>
    800007f6:	0000f517          	auipc	a0,0xf
    800007fa:	22250513          	addi	a0,a0,546 # 8000fa18 <uart_tx_lock>
    800007fe:	31c000ef          	jal	ra,80000b1a <initlock>
}
    80000802:	60a2                	ld	ra,8(sp)
    80000804:	6402                	ld	s0,0(sp)
    80000806:	0141                	addi	sp,sp,16
    80000808:	8082                	ret

000000008000080a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000080a:	1101                	addi	sp,sp,-32
    8000080c:	ec06                	sd	ra,24(sp)
    8000080e:	e822                	sd	s0,16(sp)
    80000810:	e426                	sd	s1,8(sp)
    80000812:	1000                	addi	s0,sp,32
    80000814:	84aa                	mv	s1,a0
  push_off();
    80000816:	344000ef          	jal	ra,80000b5a <push_off>

  if(panicked){
    8000081a:	00007797          	auipc	a5,0x7
    8000081e:	0f67a783          	lw	a5,246(a5) # 80007910 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000822:	10000737          	lui	a4,0x10000
  if(panicked){
    80000826:	c391                	beqz	a5,8000082a <uartputc_sync+0x20>
    for(;;)
    80000828:	a001                	j	80000828 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000082e:	0207f793          	andi	a5,a5,32
    80000832:	dfe5                	beqz	a5,8000082a <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000834:	0ff4f513          	andi	a0,s1,255
    80000838:	100007b7          	lui	a5,0x10000
    8000083c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000840:	39e000ef          	jal	ra,80000bde <pop_off>
}
    80000844:	60e2                	ld	ra,24(sp)
    80000846:	6442                	ld	s0,16(sp)
    80000848:	64a2                	ld	s1,8(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084e:	00007797          	auipc	a5,0x7
    80000852:	0ca7b783          	ld	a5,202(a5) # 80007918 <uart_tx_r>
    80000856:	00007717          	auipc	a4,0x7
    8000085a:	0ca73703          	ld	a4,202(a4) # 80007920 <uart_tx_w>
    8000085e:	06f70c63          	beq	a4,a5,800008d6 <uartstart+0x88>
{
    80000862:	7139                	addi	sp,sp,-64
    80000864:	fc06                	sd	ra,56(sp)
    80000866:	f822                	sd	s0,48(sp)
    80000868:	f426                	sd	s1,40(sp)
    8000086a:	f04a                	sd	s2,32(sp)
    8000086c:	ec4e                	sd	s3,24(sp)
    8000086e:	e852                	sd	s4,16(sp)
    80000870:	e456                	sd	s5,8(sp)
    80000872:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000878:	0000fa17          	auipc	s4,0xf
    8000087c:	1a0a0a13          	addi	s4,s4,416 # 8000fa18 <uart_tx_lock>
    uart_tx_r += 1;
    80000880:	00007497          	auipc	s1,0x7
    80000884:	09848493          	addi	s1,s1,152 # 80007918 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000888:	00007997          	auipc	s3,0x7
    8000088c:	09898993          	addi	s3,s3,152 # 80007920 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000890:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000894:	02077713          	andi	a4,a4,32
    80000898:	c715                	beqz	a4,800008c4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000089a:	01f7f713          	andi	a4,a5,31
    8000089e:	9752                	add	a4,a4,s4
    800008a0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008a4:	0785                	addi	a5,a5,1
    800008a6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a8:	8526                	mv	a0,s1
    800008aa:	554010ef          	jal	ra,80001dfe <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	609c                	ld	a5,0(s1)
    800008b4:	0009b703          	ld	a4,0(s3)
    800008b8:	fcf71ce3          	bne	a4,a5,80000890 <uartstart+0x42>
      ReadReg(ISR);
    800008bc:	100007b7          	lui	a5,0x10000
    800008c0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008c4:	70e2                	ld	ra,56(sp)
    800008c6:	7442                	ld	s0,48(sp)
    800008c8:	74a2                	ld	s1,40(sp)
    800008ca:	7902                	ld	s2,32(sp)
    800008cc:	69e2                	ld	s3,24(sp)
    800008ce:	6a42                	ld	s4,16(sp)
    800008d0:	6aa2                	ld	s5,8(sp)
    800008d2:	6121                	addi	sp,sp,64
    800008d4:	8082                	ret
      ReadReg(ISR);
    800008d6:	100007b7          	lui	a5,0x10000
    800008da:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008f2:	0000f517          	auipc	a0,0xf
    800008f6:	12650513          	addi	a0,a0,294 # 8000fa18 <uart_tx_lock>
    800008fa:	2a0000ef          	jal	ra,80000b9a <acquire>
  if(panicked){
    800008fe:	00007797          	auipc	a5,0x7
    80000902:	0127a783          	lw	a5,18(a5) # 80007910 <panicked>
    80000906:	efbd                	bnez	a5,80000984 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000908:	00007717          	auipc	a4,0x7
    8000090c:	01873703          	ld	a4,24(a4) # 80007920 <uart_tx_w>
    80000910:	00007797          	auipc	a5,0x7
    80000914:	0087b783          	ld	a5,8(a5) # 80007918 <uart_tx_r>
    80000918:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091c:	0000f997          	auipc	s3,0xf
    80000920:	0fc98993          	addi	s3,s3,252 # 8000fa18 <uart_tx_lock>
    80000924:	00007497          	auipc	s1,0x7
    80000928:	ff448493          	addi	s1,s1,-12 # 80007918 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000092c:	00007917          	auipc	s2,0x7
    80000930:	ff490913          	addi	s2,s2,-12 # 80007920 <uart_tx_w>
    80000934:	00e79d63          	bne	a5,a4,8000094e <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000938:	85ce                	mv	a1,s3
    8000093a:	8526                	mv	a0,s1
    8000093c:	476010ef          	jal	ra,80001db2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000940:	00093703          	ld	a4,0(s2)
    80000944:	609c                	ld	a5,0(s1)
    80000946:	02078793          	addi	a5,a5,32
    8000094a:	fee787e3          	beq	a5,a4,80000938 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000094e:	0000f497          	auipc	s1,0xf
    80000952:	0ca48493          	addi	s1,s1,202 # 8000fa18 <uart_tx_lock>
    80000956:	01f77793          	andi	a5,a4,31
    8000095a:	97a6                	add	a5,a5,s1
    8000095c:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000960:	0705                	addi	a4,a4,1
    80000962:	00007797          	auipc	a5,0x7
    80000966:	fae7bf23          	sd	a4,-66(a5) # 80007920 <uart_tx_w>
  uartstart();
    8000096a:	ee5ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    8000096e:	8526                	mv	a0,s1
    80000970:	2c2000ef          	jal	ra,80000c32 <release>
}
    80000974:	70a2                	ld	ra,40(sp)
    80000976:	7402                	ld	s0,32(sp)
    80000978:	64e2                	ld	s1,24(sp)
    8000097a:	6942                	ld	s2,16(sp)
    8000097c:	69a2                	ld	s3,8(sp)
    8000097e:	6a02                	ld	s4,0(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    for(;;)
    80000984:	a001                	j	80000984 <uartputc+0xa4>

0000000080000986 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e422                	sd	s0,8(sp)
    8000098a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000098c:	100007b7          	lui	a5,0x10000
    80000990:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000994:	8b85                	andi	a5,a5,1
    80000996:	cb91                	beqz	a5,800009aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009a0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009a4:	6422                	ld	s0,8(sp)
    800009a6:	0141                	addi	sp,sp,16
    800009a8:	8082                	ret
    return -1;
    800009aa:	557d                	li	a0,-1
    800009ac:	bfe5                	j	800009a4 <uartgetc+0x1e>

00000000800009ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b8:	54fd                	li	s1,-1
    800009ba:	a019                	j	800009c0 <uartintr+0x12>
      break;
    consoleintr(c);
    800009bc:	89dff0ef          	jal	ra,80000258 <consoleintr>
    int c = uartgetc();
    800009c0:	fc7ff0ef          	jal	ra,80000986 <uartgetc>
    if(c == -1)
    800009c4:	fe951ce3          	bne	a0,s1,800009bc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009c8:	0000f497          	auipc	s1,0xf
    800009cc:	05048493          	addi	s1,s1,80 # 8000fa18 <uart_tx_lock>
    800009d0:	8526                	mv	a0,s1
    800009d2:	1c8000ef          	jal	ra,80000b9a <acquire>
  uartstart();
    800009d6:	e79ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    800009da:	8526                	mv	a0,s1
    800009dc:	256000ef          	jal	ra,80000c32 <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	e04a                	sd	s2,0(sp)
    800009f4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f6:	03451793          	slli	a5,a0,0x34
    800009fa:	e7a9                	bnez	a5,80000a44 <kfree+0x5a>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	00020797          	auipc	a5,0x20
    80000a02:	28278793          	addi	a5,a5,642 # 80020c80 <end>
    80000a06:	02f56f63          	bltu	a0,a5,80000a44 <kfree+0x5a>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	02f57b63          	bgeu	a0,a5,80000a44 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	258000ef          	jal	ra,80000c6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1a:	0000f917          	auipc	s2,0xf
    80000a1e:	03690913          	addi	s2,s2,54 # 8000fa50 <kmem>
    80000a22:	854a                	mv	a0,s2
    80000a24:	176000ef          	jal	ra,80000b9a <acquire>
  r->next = kmem.freelist;
    80000a28:	01893783          	ld	a5,24(s2)
    80000a2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a32:	854a                	mv	a0,s2
    80000a34:	1fe000ef          	jal	ra,80000c32 <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6902                	ld	s2,0(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret
    panic("kfree");
    80000a44:	00006517          	auipc	a0,0x6
    80000a48:	61450513          	addi	a0,a0,1556 # 80007058 <digits+0x20>
    80000a4c:	d0bff0ef          	jal	ra,80000756 <panic>

0000000080000a50 <freerange>:
{
    80000a50:	7179                	addi	sp,sp,-48
    80000a52:	f406                	sd	ra,40(sp)
    80000a54:	f022                	sd	s0,32(sp)
    80000a56:	ec26                	sd	s1,24(sp)
    80000a58:	e84a                	sd	s2,16(sp)
    80000a5a:	e44e                	sd	s3,8(sp)
    80000a5c:	e052                	sd	s4,0(sp)
    80000a5e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a60:	6785                	lui	a5,0x1
    80000a62:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a66:	94aa                	add	s1,s1,a0
    80000a68:	757d                	lui	a0,0xfffff
    80000a6a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a6c:	94be                	add	s1,s1,a5
    80000a6e:	0095ec63          	bltu	a1,s1,80000a86 <freerange+0x36>
    80000a72:	892e                	mv	s2,a1
    kfree(p);
    80000a74:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a76:	6985                	lui	s3,0x1
    kfree(p);
    80000a78:	01448533          	add	a0,s1,s4
    80000a7c:	f6fff0ef          	jal	ra,800009ea <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe997be3          	bgeu	s2,s1,80000a78 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00006597          	auipc	a1,0x6
    80000aa2:	5c258593          	addi	a1,a1,1474 # 80007060 <digits+0x28>
    80000aa6:	0000f517          	auipc	a0,0xf
    80000aaa:	faa50513          	addi	a0,a0,-86 # 8000fa50 <kmem>
    80000aae:	06c000ef          	jal	ra,80000b1a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab2:	45c5                	li	a1,17
    80000ab4:	05ee                	slli	a1,a1,0x1b
    80000ab6:	00020517          	auipc	a0,0x20
    80000aba:	1ca50513          	addi	a0,a0,458 # 80020c80 <end>
    80000abe:	f93ff0ef          	jal	ra,80000a50 <freerange>
}
    80000ac2:	60a2                	ld	ra,8(sp)
    80000ac4:	6402                	ld	s0,0(sp)
    80000ac6:	0141                	addi	sp,sp,16
    80000ac8:	8082                	ret

0000000080000aca <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000aca:	1101                	addi	sp,sp,-32
    80000acc:	ec06                	sd	ra,24(sp)
    80000ace:	e822                	sd	s0,16(sp)
    80000ad0:	e426                	sd	s1,8(sp)
    80000ad2:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ad4:	0000f497          	auipc	s1,0xf
    80000ad8:	f7c48493          	addi	s1,s1,-132 # 8000fa50 <kmem>
    80000adc:	8526                	mv	a0,s1
    80000ade:	0bc000ef          	jal	ra,80000b9a <acquire>
  r = kmem.freelist;
    80000ae2:	6c84                	ld	s1,24(s1)
  if(r)
    80000ae4:	c485                	beqz	s1,80000b0c <kalloc+0x42>
    kmem.freelist = r->next;
    80000ae6:	609c                	ld	a5,0(s1)
    80000ae8:	0000f517          	auipc	a0,0xf
    80000aec:	f6850513          	addi	a0,a0,-152 # 8000fa50 <kmem>
    80000af0:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000af2:	140000ef          	jal	ra,80000c32 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000af6:	6605                	lui	a2,0x1
    80000af8:	4595                	li	a1,5
    80000afa:	8526                	mv	a0,s1
    80000afc:	172000ef          	jal	ra,80000c6e <memset>
  return (void*)r;
}
    80000b00:	8526                	mv	a0,s1
    80000b02:	60e2                	ld	ra,24(sp)
    80000b04:	6442                	ld	s0,16(sp)
    80000b06:	64a2                	ld	s1,8(sp)
    80000b08:	6105                	addi	sp,sp,32
    80000b0a:	8082                	ret
  release(&kmem.lock);
    80000b0c:	0000f517          	auipc	a0,0xf
    80000b10:	f4450513          	addi	a0,a0,-188 # 8000fa50 <kmem>
    80000b14:	11e000ef          	jal	ra,80000c32 <release>
  if(r)
    80000b18:	b7e5                	j	80000b00 <kalloc+0x36>

0000000080000b1a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e422                	sd	s0,8(sp)
    80000b1e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b20:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b22:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b26:	00053823          	sd	zero,16(a0)
}
    80000b2a:	6422                	ld	s0,8(sp)
    80000b2c:	0141                	addi	sp,sp,16
    80000b2e:	8082                	ret

0000000080000b30 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b30:	411c                	lw	a5,0(a0)
    80000b32:	e399                	bnez	a5,80000b38 <holding+0x8>
    80000b34:	4501                	li	a0,0
  return r;
}
    80000b36:	8082                	ret
{
    80000b38:	1101                	addi	sp,sp,-32
    80000b3a:	ec06                	sd	ra,24(sp)
    80000b3c:	e822                	sd	s0,16(sp)
    80000b3e:	e426                	sd	s1,8(sp)
    80000b40:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b42:	6904                	ld	s1,16(a0)
    80000b44:	487000ef          	jal	ra,800017ca <mycpu>
    80000b48:	40a48533          	sub	a0,s1,a0
    80000b4c:	00153513          	seqz	a0,a0
}
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret

0000000080000b5a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b5a:	1101                	addi	sp,sp,-32
    80000b5c:	ec06                	sd	ra,24(sp)
    80000b5e:	e822                	sd	s0,16(sp)
    80000b60:	e426                	sd	s1,8(sp)
    80000b62:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b64:	100024f3          	csrr	s1,sstatus
    80000b68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b6e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b72:	459000ef          	jal	ra,800017ca <mycpu>
    80000b76:	5d3c                	lw	a5,120(a0)
    80000b78:	cb99                	beqz	a5,80000b8e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b7a:	451000ef          	jal	ra,800017ca <mycpu>
    80000b7e:	5d3c                	lw	a5,120(a0)
    80000b80:	2785                	addiw	a5,a5,1
    80000b82:	dd3c                	sw	a5,120(a0)
}
    80000b84:	60e2                	ld	ra,24(sp)
    80000b86:	6442                	ld	s0,16(sp)
    80000b88:	64a2                	ld	s1,8(sp)
    80000b8a:	6105                	addi	sp,sp,32
    80000b8c:	8082                	ret
    mycpu()->intena = old;
    80000b8e:	43d000ef          	jal	ra,800017ca <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b92:	8085                	srli	s1,s1,0x1
    80000b94:	8885                	andi	s1,s1,1
    80000b96:	dd64                	sw	s1,124(a0)
    80000b98:	b7cd                	j	80000b7a <push_off+0x20>

0000000080000b9a <acquire>:
{
    80000b9a:	1101                	addi	sp,sp,-32
    80000b9c:	ec06                	sd	ra,24(sp)
    80000b9e:	e822                	sd	s0,16(sp)
    80000ba0:	e426                	sd	s1,8(sp)
    80000ba2:	1000                	addi	s0,sp,32
    80000ba4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ba6:	fb5ff0ef          	jal	ra,80000b5a <push_off>
  if(holding(lk))
    80000baa:	8526                	mv	a0,s1
    80000bac:	f85ff0ef          	jal	ra,80000b30 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb0:	4705                	li	a4,1
  if(holding(lk))
    80000bb2:	e105                	bnez	a0,80000bd2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb4:	87ba                	mv	a5,a4
    80000bb6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bba:	2781                	sext.w	a5,a5
    80000bbc:	ffe5                	bnez	a5,80000bb4 <acquire+0x1a>
  __sync_synchronize();
    80000bbe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bc2:	409000ef          	jal	ra,800017ca <mycpu>
    80000bc6:	e888                	sd	a0,16(s1)
}
    80000bc8:	60e2                	ld	ra,24(sp)
    80000bca:	6442                	ld	s0,16(sp)
    80000bcc:	64a2                	ld	s1,8(sp)
    80000bce:	6105                	addi	sp,sp,32
    80000bd0:	8082                	ret
    panic("acquire");
    80000bd2:	00006517          	auipc	a0,0x6
    80000bd6:	49650513          	addi	a0,a0,1174 # 80007068 <digits+0x30>
    80000bda:	b7dff0ef          	jal	ra,80000756 <panic>

0000000080000bde <pop_off>:

void
pop_off(void)
{
    80000bde:	1141                	addi	sp,sp,-16
    80000be0:	e406                	sd	ra,8(sp)
    80000be2:	e022                	sd	s0,0(sp)
    80000be4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000be6:	3e5000ef          	jal	ra,800017ca <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bee:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bf0:	e78d                	bnez	a5,80000c1a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bf2:	5d3c                	lw	a5,120(a0)
    80000bf4:	02f05963          	blez	a5,80000c26 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bf8:	37fd                	addiw	a5,a5,-1
    80000bfa:	0007871b          	sext.w	a4,a5
    80000bfe:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c00:	eb09                	bnez	a4,80000c12 <pop_off+0x34>
    80000c02:	5d7c                	lw	a5,124(a0)
    80000c04:	c799                	beqz	a5,80000c12 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c0a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c0e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c12:	60a2                	ld	ra,8(sp)
    80000c14:	6402                	ld	s0,0(sp)
    80000c16:	0141                	addi	sp,sp,16
    80000c18:	8082                	ret
    panic("pop_off - interruptible");
    80000c1a:	00006517          	auipc	a0,0x6
    80000c1e:	45650513          	addi	a0,a0,1110 # 80007070 <digits+0x38>
    80000c22:	b35ff0ef          	jal	ra,80000756 <panic>
    panic("pop_off");
    80000c26:	00006517          	auipc	a0,0x6
    80000c2a:	46250513          	addi	a0,a0,1122 # 80007088 <digits+0x50>
    80000c2e:	b29ff0ef          	jal	ra,80000756 <panic>

0000000080000c32 <release>:
{
    80000c32:	1101                	addi	sp,sp,-32
    80000c34:	ec06                	sd	ra,24(sp)
    80000c36:	e822                	sd	s0,16(sp)
    80000c38:	e426                	sd	s1,8(sp)
    80000c3a:	1000                	addi	s0,sp,32
    80000c3c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c3e:	ef3ff0ef          	jal	ra,80000b30 <holding>
    80000c42:	c105                	beqz	a0,80000c62 <release+0x30>
  lk->cpu = 0;
    80000c44:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c48:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c4c:	0f50000f          	fence	iorw,ow
    80000c50:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c54:	f8bff0ef          	jal	ra,80000bde <pop_off>
}
    80000c58:	60e2                	ld	ra,24(sp)
    80000c5a:	6442                	ld	s0,16(sp)
    80000c5c:	64a2                	ld	s1,8(sp)
    80000c5e:	6105                	addi	sp,sp,32
    80000c60:	8082                	ret
    panic("release");
    80000c62:	00006517          	auipc	a0,0x6
    80000c66:	42e50513          	addi	a0,a0,1070 # 80007090 <digits+0x58>
    80000c6a:	aedff0ef          	jal	ra,80000756 <panic>

0000000080000c6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c6e:	1141                	addi	sp,sp,-16
    80000c70:	e422                	sd	s0,8(sp)
    80000c72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c74:	ca19                	beqz	a2,80000c8a <memset+0x1c>
    80000c76:	87aa                	mv	a5,a0
    80000c78:	1602                	slli	a2,a2,0x20
    80000c7a:	9201                	srli	a2,a2,0x20
    80000c7c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c80:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c84:	0785                	addi	a5,a5,1
    80000c86:	fee79de3          	bne	a5,a4,80000c80 <memset+0x12>
  }
  return dst;
}
    80000c8a:	6422                	ld	s0,8(sp)
    80000c8c:	0141                	addi	sp,sp,16
    80000c8e:	8082                	ret

0000000080000c90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c90:	1141                	addi	sp,sp,-16
    80000c92:	e422                	sd	s0,8(sp)
    80000c94:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c96:	ca05                	beqz	a2,80000cc6 <memcmp+0x36>
    80000c98:	fff6069b          	addiw	a3,a2,-1
    80000c9c:	1682                	slli	a3,a3,0x20
    80000c9e:	9281                	srli	a3,a3,0x20
    80000ca0:	0685                	addi	a3,a3,1
    80000ca2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ca4:	00054783          	lbu	a5,0(a0)
    80000ca8:	0005c703          	lbu	a4,0(a1)
    80000cac:	00e79863          	bne	a5,a4,80000cbc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cb0:	0505                	addi	a0,a0,1
    80000cb2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000cb4:	fed518e3          	bne	a0,a3,80000ca4 <memcmp+0x14>
  }

  return 0;
    80000cb8:	4501                	li	a0,0
    80000cba:	a019                	j	80000cc0 <memcmp+0x30>
      return *s1 - *s2;
    80000cbc:	40e7853b          	subw	a0,a5,a4
}
    80000cc0:	6422                	ld	s0,8(sp)
    80000cc2:	0141                	addi	sp,sp,16
    80000cc4:	8082                	ret
  return 0;
    80000cc6:	4501                	li	a0,0
    80000cc8:	bfe5                	j	80000cc0 <memcmp+0x30>

0000000080000cca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cca:	1141                	addi	sp,sp,-16
    80000ccc:	e422                	sd	s0,8(sp)
    80000cce:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cd0:	c205                	beqz	a2,80000cf0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cd2:	02a5e263          	bltu	a1,a0,80000cf6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00c587b3          	add	a5,a1,a2
{
    80000cde:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ce0:	0585                	addi	a1,a1,1
    80000ce2:	0705                	addi	a4,a4,1
    80000ce4:	fff5c683          	lbu	a3,-1(a1)
    80000ce8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cec:	fef59ae3          	bne	a1,a5,80000ce0 <memmove+0x16>

  return dst;
}
    80000cf0:	6422                	ld	s0,8(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret
  if(s < d && s + n > d){
    80000cf6:	02061693          	slli	a3,a2,0x20
    80000cfa:	9281                	srli	a3,a3,0x20
    80000cfc:	00d58733          	add	a4,a1,a3
    80000d00:	fce57be3          	bgeu	a0,a4,80000cd6 <memmove+0xc>
    d += n;
    80000d04:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d06:	fff6079b          	addiw	a5,a2,-1
    80000d0a:	1782                	slli	a5,a5,0x20
    80000d0c:	9381                	srli	a5,a5,0x20
    80000d0e:	fff7c793          	not	a5,a5
    80000d12:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d14:	177d                	addi	a4,a4,-1
    80000d16:	16fd                	addi	a3,a3,-1
    80000d18:	00074603          	lbu	a2,0(a4)
    80000d1c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d20:	fee79ae3          	bne	a5,a4,80000d14 <memmove+0x4a>
    80000d24:	b7f1                	j	80000cf0 <memmove+0x26>

0000000080000d26 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e406                	sd	ra,8(sp)
    80000d2a:	e022                	sd	s0,0(sp)
    80000d2c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d2e:	f9dff0ef          	jal	ra,80000cca <memmove>
}
    80000d32:	60a2                	ld	ra,8(sp)
    80000d34:	6402                	ld	s0,0(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d40:	ce11                	beqz	a2,80000d5c <strncmp+0x22>
    80000d42:	00054783          	lbu	a5,0(a0)
    80000d46:	cf89                	beqz	a5,80000d60 <strncmp+0x26>
    80000d48:	0005c703          	lbu	a4,0(a1)
    80000d4c:	00f71a63          	bne	a4,a5,80000d60 <strncmp+0x26>
    n--, p++, q++;
    80000d50:	367d                	addiw	a2,a2,-1
    80000d52:	0505                	addi	a0,a0,1
    80000d54:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d56:	f675                	bnez	a2,80000d42 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d58:	4501                	li	a0,0
    80000d5a:	a809                	j	80000d6c <strncmp+0x32>
    80000d5c:	4501                	li	a0,0
    80000d5e:	a039                	j	80000d6c <strncmp+0x32>
  if(n == 0)
    80000d60:	ca09                	beqz	a2,80000d72 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d62:	00054503          	lbu	a0,0(a0)
    80000d66:	0005c783          	lbu	a5,0(a1)
    80000d6a:	9d1d                	subw	a0,a0,a5
}
    80000d6c:	6422                	ld	s0,8(sp)
    80000d6e:	0141                	addi	sp,sp,16
    80000d70:	8082                	ret
    return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	bfe5                	j	80000d6c <strncmp+0x32>

0000000080000d76 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d76:	1141                	addi	sp,sp,-16
    80000d78:	e422                	sd	s0,8(sp)
    80000d7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d7c:	872a                	mv	a4,a0
    80000d7e:	8832                	mv	a6,a2
    80000d80:	367d                	addiw	a2,a2,-1
    80000d82:	01005963          	blez	a6,80000d94 <strncpy+0x1e>
    80000d86:	0705                	addi	a4,a4,1
    80000d88:	0005c783          	lbu	a5,0(a1)
    80000d8c:	fef70fa3          	sb	a5,-1(a4)
    80000d90:	0585                	addi	a1,a1,1
    80000d92:	f7f5                	bnez	a5,80000d7e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d94:	86ba                	mv	a3,a4
    80000d96:	00c05c63          	blez	a2,80000dae <strncpy+0x38>
    *s++ = 0;
    80000d9a:	0685                	addi	a3,a3,1
    80000d9c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000da0:	fff6c793          	not	a5,a3
    80000da4:	9fb9                	addw	a5,a5,a4
    80000da6:	010787bb          	addw	a5,a5,a6
    80000daa:	fef048e3          	bgtz	a5,80000d9a <strncpy+0x24>
  return os;
}
    80000dae:	6422                	ld	s0,8(sp)
    80000db0:	0141                	addi	sp,sp,16
    80000db2:	8082                	ret

0000000080000db4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000db4:	1141                	addi	sp,sp,-16
    80000db6:	e422                	sd	s0,8(sp)
    80000db8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dba:	02c05363          	blez	a2,80000de0 <safestrcpy+0x2c>
    80000dbe:	fff6069b          	addiw	a3,a2,-1
    80000dc2:	1682                	slli	a3,a3,0x20
    80000dc4:	9281                	srli	a3,a3,0x20
    80000dc6:	96ae                	add	a3,a3,a1
    80000dc8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dca:	00d58963          	beq	a1,a3,80000ddc <safestrcpy+0x28>
    80000dce:	0585                	addi	a1,a1,1
    80000dd0:	0785                	addi	a5,a5,1
    80000dd2:	fff5c703          	lbu	a4,-1(a1)
    80000dd6:	fee78fa3          	sb	a4,-1(a5)
    80000dda:	fb65                	bnez	a4,80000dca <safestrcpy+0x16>
    ;
  *s = 0;
    80000ddc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000de0:	6422                	ld	s0,8(sp)
    80000de2:	0141                	addi	sp,sp,16
    80000de4:	8082                	ret

0000000080000de6 <strlen>:

int
strlen(const char *s)
{
    80000de6:	1141                	addi	sp,sp,-16
    80000de8:	e422                	sd	s0,8(sp)
    80000dea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000dec:	00054783          	lbu	a5,0(a0)
    80000df0:	cf91                	beqz	a5,80000e0c <strlen+0x26>
    80000df2:	0505                	addi	a0,a0,1
    80000df4:	87aa                	mv	a5,a0
    80000df6:	4685                	li	a3,1
    80000df8:	9e89                	subw	a3,a3,a0
    80000dfa:	00f6853b          	addw	a0,a3,a5
    80000dfe:	0785                	addi	a5,a5,1
    80000e00:	fff7c703          	lbu	a4,-1(a5)
    80000e04:	fb7d                	bnez	a4,80000dfa <strlen+0x14>
    ;
  return n;
}
    80000e06:	6422                	ld	s0,8(sp)
    80000e08:	0141                	addi	sp,sp,16
    80000e0a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e0c:	4501                	li	a0,0
    80000e0e:	bfe5                	j	80000e06 <strlen+0x20>

0000000080000e10 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e406                	sd	ra,8(sp)
    80000e14:	e022                	sd	s0,0(sp)
    80000e16:	0800                	addi	s0,sp,16
  consoleinit();
    80000e18:	db2ff0ef          	jal	ra,800003ca <consoleinit>
  printfinit();
    80000e1c:	975ff0ef          	jal	ra,80000790 <printfinit>
  printf("xv6 kernel is booting\n");  // Add this line
    80000e20:	00006517          	auipc	a0,0x6
    80000e24:	27850513          	addi	a0,a0,632 # 80007098 <digits+0x60>
    80000e28:	e7aff0ef          	jal	ra,800004a2 <printf>

  kinit();         // physical page allocator
    80000e2c:	c6bff0ef          	jal	ra,80000a96 <kinit>
  kvminit();       // create kernel page table
    80000e30:	2d6000ef          	jal	ra,80001106 <kvminit>
  kvminithart();   // turn on paging
    80000e34:	048000ef          	jal	ra,80000e7c <kvminithart>
  procinit();      // process table
    80000e38:	0db000ef          	jal	ra,80001712 <procinit>
  trapinit();      // trap vectors
    80000e3c:	472010ef          	jal	ra,800022ae <trapinit>
  trapinithart();  // install kernel trap vector
    80000e40:	492010ef          	jal	ra,800022d2 <trapinithart>
  plicinit();      // set up interrupt controller
    80000e44:	2da040ef          	jal	ra,8000511e <plicinit>
  plicinithart();  // ask PLIC for device interrupts
    80000e48:	2ec040ef          	jal	ra,80005134 <plicinithart>
  binit();         // buffer cache
    80000e4c:	36f010ef          	jal	ra,800029ba <binit>
  iinit();         // inode cache
    80000e50:	14e020ef          	jal	ra,80002f9e <iinit>
  fileinit();      // file table
    80000e54:	6e9020ef          	jal	ra,80003d3c <fileinit>
  virtio_disk_init(); // emulated hard disk
    80000e58:	3cc040ef          	jal	ra,80005224 <virtio_disk_init>
  printf("xv6 kernel initialization complete\n");  // Add this line
    80000e5c:	00006517          	auipc	a0,0x6
    80000e60:	25450513          	addi	a0,a0,596 # 800070b0 <digits+0x78>
    80000e64:	e3eff0ef          	jal	ra,800004a2 <printf>

  userinit();      // first user process
    80000e68:	3e7000ef          	jal	ra,80001a4e <userinit>
  printf("userinit complete\n");  // Add this line
    80000e6c:	00006517          	auipc	a0,0x6
    80000e70:	26c50513          	addi	a0,a0,620 # 800070d8 <digits+0xa0>
    80000e74:	e2eff0ef          	jal	ra,800004a2 <printf>

  scheduler();     // start running processes
    80000e78:	5a1000ef          	jal	ra,80001c18 <scheduler>

0000000080000e7c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e422                	sd	s0,8(sp)
    80000e80:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000e82:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000e86:	00007797          	auipc	a5,0x7
    80000e8a:	aaa7b783          	ld	a5,-1366(a5) # 80007930 <kernel_pagetable>
    80000e8e:	83b1                	srli	a5,a5,0xc
    80000e90:	577d                	li	a4,-1
    80000e92:	177e                	slli	a4,a4,0x3f
    80000e94:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000e96:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000e9a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000e9e:	6422                	ld	s0,8(sp)
    80000ea0:	0141                	addi	sp,sp,16
    80000ea2:	8082                	ret

0000000080000ea4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ea4:	7139                	addi	sp,sp,-64
    80000ea6:	fc06                	sd	ra,56(sp)
    80000ea8:	f822                	sd	s0,48(sp)
    80000eaa:	f426                	sd	s1,40(sp)
    80000eac:	f04a                	sd	s2,32(sp)
    80000eae:	ec4e                	sd	s3,24(sp)
    80000eb0:	e852                	sd	s4,16(sp)
    80000eb2:	e456                	sd	s5,8(sp)
    80000eb4:	e05a                	sd	s6,0(sp)
    80000eb6:	0080                	addi	s0,sp,64
    80000eb8:	84aa                	mv	s1,a0
    80000eba:	89ae                	mv	s3,a1
    80000ebc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000ebe:	57fd                	li	a5,-1
    80000ec0:	83e9                	srli	a5,a5,0x1a
    80000ec2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ec4:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ec6:	02b7fc63          	bgeu	a5,a1,80000efe <walk+0x5a>
    panic("walk");
    80000eca:	00006517          	auipc	a0,0x6
    80000ece:	22650513          	addi	a0,a0,550 # 800070f0 <digits+0xb8>
    80000ed2:	885ff0ef          	jal	ra,80000756 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ed6:	060a8263          	beqz	s5,80000f3a <walk+0x96>
    80000eda:	bf1ff0ef          	jal	ra,80000aca <kalloc>
    80000ede:	84aa                	mv	s1,a0
    80000ee0:	c139                	beqz	a0,80000f26 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ee2:	6605                	lui	a2,0x1
    80000ee4:	4581                	li	a1,0
    80000ee6:	d89ff0ef          	jal	ra,80000c6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000eea:	00c4d793          	srli	a5,s1,0xc
    80000eee:	07aa                	slli	a5,a5,0xa
    80000ef0:	0017e793          	ori	a5,a5,1
    80000ef4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000ef8:	3a5d                	addiw	s4,s4,-9
    80000efa:	036a0063          	beq	s4,s6,80000f1a <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000efe:	0149d933          	srl	s2,s3,s4
    80000f02:	1ff97913          	andi	s2,s2,511
    80000f06:	090e                	slli	s2,s2,0x3
    80000f08:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f0a:	00093483          	ld	s1,0(s2)
    80000f0e:	0014f793          	andi	a5,s1,1
    80000f12:	d3f1                	beqz	a5,80000ed6 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f14:	80a9                	srli	s1,s1,0xa
    80000f16:	04b2                	slli	s1,s1,0xc
    80000f18:	b7c5                	j	80000ef8 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f1a:	00c9d513          	srli	a0,s3,0xc
    80000f1e:	1ff57513          	andi	a0,a0,511
    80000f22:	050e                	slli	a0,a0,0x3
    80000f24:	9526                	add	a0,a0,s1
}
    80000f26:	70e2                	ld	ra,56(sp)
    80000f28:	7442                	ld	s0,48(sp)
    80000f2a:	74a2                	ld	s1,40(sp)
    80000f2c:	7902                	ld	s2,32(sp)
    80000f2e:	69e2                	ld	s3,24(sp)
    80000f30:	6a42                	ld	s4,16(sp)
    80000f32:	6aa2                	ld	s5,8(sp)
    80000f34:	6b02                	ld	s6,0(sp)
    80000f36:	6121                	addi	sp,sp,64
    80000f38:	8082                	ret
        return 0;
    80000f3a:	4501                	li	a0,0
    80000f3c:	b7ed                	j	80000f26 <walk+0x82>

0000000080000f3e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f3e:	57fd                	li	a5,-1
    80000f40:	83e9                	srli	a5,a5,0x1a
    80000f42:	00b7f463          	bgeu	a5,a1,80000f4a <walkaddr+0xc>
    return 0;
    80000f46:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f48:	8082                	ret
{
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e406                	sd	ra,8(sp)
    80000f4e:	e022                	sd	s0,0(sp)
    80000f50:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f52:	4601                	li	a2,0
    80000f54:	f51ff0ef          	jal	ra,80000ea4 <walk>
  if(pte == 0)
    80000f58:	c105                	beqz	a0,80000f78 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000f5a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f5c:	0117f693          	andi	a3,a5,17
    80000f60:	4745                	li	a4,17
    return 0;
    80000f62:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f64:	00e68663          	beq	a3,a4,80000f70 <walkaddr+0x32>
}
    80000f68:	60a2                	ld	ra,8(sp)
    80000f6a:	6402                	ld	s0,0(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret
  pa = PTE2PA(*pte);
    80000f70:	00a7d513          	srli	a0,a5,0xa
    80000f74:	0532                	slli	a0,a0,0xc
  return pa;
    80000f76:	bfcd                	j	80000f68 <walkaddr+0x2a>
    return 0;
    80000f78:	4501                	li	a0,0
    80000f7a:	b7fd                	j	80000f68 <walkaddr+0x2a>

0000000080000f7c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000f7c:	715d                	addi	sp,sp,-80
    80000f7e:	e486                	sd	ra,72(sp)
    80000f80:	e0a2                	sd	s0,64(sp)
    80000f82:	fc26                	sd	s1,56(sp)
    80000f84:	f84a                	sd	s2,48(sp)
    80000f86:	f44e                	sd	s3,40(sp)
    80000f88:	f052                	sd	s4,32(sp)
    80000f8a:	ec56                	sd	s5,24(sp)
    80000f8c:	e85a                	sd	s6,16(sp)
    80000f8e:	e45e                	sd	s7,8(sp)
    80000f90:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000f92:	03459793          	slli	a5,a1,0x34
    80000f96:	e7a9                	bnez	a5,80000fe0 <mappages+0x64>
    80000f98:	8aaa                	mv	s5,a0
    80000f9a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000f9c:	03461793          	slli	a5,a2,0x34
    80000fa0:	e7b1                	bnez	a5,80000fec <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fa2:	ca39                	beqz	a2,80000ff8 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fa4:	79fd                	lui	s3,0xfffff
    80000fa6:	964e                	add	a2,a2,s3
    80000fa8:	00b609b3          	add	s3,a2,a1
  a = va;
    80000fac:	892e                	mv	s2,a1
    80000fae:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000fb2:	6b85                	lui	s7,0x1
    80000fb4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000fb8:	4605                	li	a2,1
    80000fba:	85ca                	mv	a1,s2
    80000fbc:	8556                	mv	a0,s5
    80000fbe:	ee7ff0ef          	jal	ra,80000ea4 <walk>
    80000fc2:	c539                	beqz	a0,80001010 <mappages+0x94>
    if(*pte & PTE_V)
    80000fc4:	611c                	ld	a5,0(a0)
    80000fc6:	8b85                	andi	a5,a5,1
    80000fc8:	ef95                	bnez	a5,80001004 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000fca:	80b1                	srli	s1,s1,0xc
    80000fcc:	04aa                	slli	s1,s1,0xa
    80000fce:	0164e4b3          	or	s1,s1,s6
    80000fd2:	0014e493          	ori	s1,s1,1
    80000fd6:	e104                	sd	s1,0(a0)
    if(a == last)
    80000fd8:	05390863          	beq	s2,s3,80001028 <mappages+0xac>
    a += PGSIZE;
    80000fdc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000fde:	bfd9                	j	80000fb4 <mappages+0x38>
    panic("mappages: va not aligned");
    80000fe0:	00006517          	auipc	a0,0x6
    80000fe4:	11850513          	addi	a0,a0,280 # 800070f8 <digits+0xc0>
    80000fe8:	f6eff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size not aligned");
    80000fec:	00006517          	auipc	a0,0x6
    80000ff0:	12c50513          	addi	a0,a0,300 # 80007118 <digits+0xe0>
    80000ff4:	f62ff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size");
    80000ff8:	00006517          	auipc	a0,0x6
    80000ffc:	14050513          	addi	a0,a0,320 # 80007138 <digits+0x100>
    80001000:	f56ff0ef          	jal	ra,80000756 <panic>
      panic("mappages: remap");
    80001004:	00006517          	auipc	a0,0x6
    80001008:	14450513          	addi	a0,a0,324 # 80007148 <digits+0x110>
    8000100c:	f4aff0ef          	jal	ra,80000756 <panic>
      return -1;
    80001010:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001012:	60a6                	ld	ra,72(sp)
    80001014:	6406                	ld	s0,64(sp)
    80001016:	74e2                	ld	s1,56(sp)
    80001018:	7942                	ld	s2,48(sp)
    8000101a:	79a2                	ld	s3,40(sp)
    8000101c:	7a02                	ld	s4,32(sp)
    8000101e:	6ae2                	ld	s5,24(sp)
    80001020:	6b42                	ld	s6,16(sp)
    80001022:	6ba2                	ld	s7,8(sp)
    80001024:	6161                	addi	sp,sp,80
    80001026:	8082                	ret
  return 0;
    80001028:	4501                	li	a0,0
    8000102a:	b7e5                	j	80001012 <mappages+0x96>

000000008000102c <kvmmap>:
{
    8000102c:	1141                	addi	sp,sp,-16
    8000102e:	e406                	sd	ra,8(sp)
    80001030:	e022                	sd	s0,0(sp)
    80001032:	0800                	addi	s0,sp,16
    80001034:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001036:	86b2                	mv	a3,a2
    80001038:	863e                	mv	a2,a5
    8000103a:	f43ff0ef          	jal	ra,80000f7c <mappages>
    8000103e:	e509                	bnez	a0,80001048 <kvmmap+0x1c>
}
    80001040:	60a2                	ld	ra,8(sp)
    80001042:	6402                	ld	s0,0(sp)
    80001044:	0141                	addi	sp,sp,16
    80001046:	8082                	ret
    panic("kvmmap");
    80001048:	00006517          	auipc	a0,0x6
    8000104c:	11050513          	addi	a0,a0,272 # 80007158 <digits+0x120>
    80001050:	f06ff0ef          	jal	ra,80000756 <panic>

0000000080001054 <kvmmake>:
{
    80001054:	1101                	addi	sp,sp,-32
    80001056:	ec06                	sd	ra,24(sp)
    80001058:	e822                	sd	s0,16(sp)
    8000105a:	e426                	sd	s1,8(sp)
    8000105c:	e04a                	sd	s2,0(sp)
    8000105e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001060:	a6bff0ef          	jal	ra,80000aca <kalloc>
    80001064:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001066:	6605                	lui	a2,0x1
    80001068:	4581                	li	a1,0
    8000106a:	c05ff0ef          	jal	ra,80000c6e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000106e:	4719                	li	a4,6
    80001070:	6685                	lui	a3,0x1
    80001072:	10000637          	lui	a2,0x10000
    80001076:	100005b7          	lui	a1,0x10000
    8000107a:	8526                	mv	a0,s1
    8000107c:	fb1ff0ef          	jal	ra,8000102c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001080:	4719                	li	a4,6
    80001082:	6685                	lui	a3,0x1
    80001084:	10001637          	lui	a2,0x10001
    80001088:	100015b7          	lui	a1,0x10001
    8000108c:	8526                	mv	a0,s1
    8000108e:	f9fff0ef          	jal	ra,8000102c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001092:	4719                	li	a4,6
    80001094:	040006b7          	lui	a3,0x4000
    80001098:	0c000637          	lui	a2,0xc000
    8000109c:	0c0005b7          	lui	a1,0xc000
    800010a0:	8526                	mv	a0,s1
    800010a2:	f8bff0ef          	jal	ra,8000102c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010a6:	00006917          	auipc	s2,0x6
    800010aa:	f5a90913          	addi	s2,s2,-166 # 80007000 <etext>
    800010ae:	4729                	li	a4,10
    800010b0:	80006697          	auipc	a3,0x80006
    800010b4:	f5068693          	addi	a3,a3,-176 # 7000 <_entry-0x7fff9000>
    800010b8:	4605                	li	a2,1
    800010ba:	067e                	slli	a2,a2,0x1f
    800010bc:	85b2                	mv	a1,a2
    800010be:	8526                	mv	a0,s1
    800010c0:	f6dff0ef          	jal	ra,8000102c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800010c4:	4719                	li	a4,6
    800010c6:	46c5                	li	a3,17
    800010c8:	06ee                	slli	a3,a3,0x1b
    800010ca:	412686b3          	sub	a3,a3,s2
    800010ce:	864a                	mv	a2,s2
    800010d0:	85ca                	mv	a1,s2
    800010d2:	8526                	mv	a0,s1
    800010d4:	f59ff0ef          	jal	ra,8000102c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800010d8:	4729                	li	a4,10
    800010da:	6685                	lui	a3,0x1
    800010dc:	00005617          	auipc	a2,0x5
    800010e0:	f2460613          	addi	a2,a2,-220 # 80006000 <_trampoline>
    800010e4:	040005b7          	lui	a1,0x4000
    800010e8:	15fd                	addi	a1,a1,-1
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	8526                	mv	a0,s1
    800010ee:	f3fff0ef          	jal	ra,8000102c <kvmmap>
  proc_mapstacks(kpgtbl);
    800010f2:	8526                	mv	a0,s1
    800010f4:	594000ef          	jal	ra,80001688 <proc_mapstacks>
}
    800010f8:	8526                	mv	a0,s1
    800010fa:	60e2                	ld	ra,24(sp)
    800010fc:	6442                	ld	s0,16(sp)
    800010fe:	64a2                	ld	s1,8(sp)
    80001100:	6902                	ld	s2,0(sp)
    80001102:	6105                	addi	sp,sp,32
    80001104:	8082                	ret

0000000080001106 <kvminit>:
{
    80001106:	1141                	addi	sp,sp,-16
    80001108:	e406                	sd	ra,8(sp)
    8000110a:	e022                	sd	s0,0(sp)
    8000110c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000110e:	f47ff0ef          	jal	ra,80001054 <kvmmake>
    80001112:	00007797          	auipc	a5,0x7
    80001116:	80a7bf23          	sd	a0,-2018(a5) # 80007930 <kernel_pagetable>
}
    8000111a:	60a2                	ld	ra,8(sp)
    8000111c:	6402                	ld	s0,0(sp)
    8000111e:	0141                	addi	sp,sp,16
    80001120:	8082                	ret

0000000080001122 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001122:	715d                	addi	sp,sp,-80
    80001124:	e486                	sd	ra,72(sp)
    80001126:	e0a2                	sd	s0,64(sp)
    80001128:	fc26                	sd	s1,56(sp)
    8000112a:	f84a                	sd	s2,48(sp)
    8000112c:	f44e                	sd	s3,40(sp)
    8000112e:	f052                	sd	s4,32(sp)
    80001130:	ec56                	sd	s5,24(sp)
    80001132:	e85a                	sd	s6,16(sp)
    80001134:	e45e                	sd	s7,8(sp)
    80001136:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001138:	03459793          	slli	a5,a1,0x34
    8000113c:	e795                	bnez	a5,80001168 <uvmunmap+0x46>
    8000113e:	8a2a                	mv	s4,a0
    80001140:	892e                	mv	s2,a1
    80001142:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001144:	0632                	slli	a2,a2,0xc
    80001146:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000114a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000114c:	6b05                	lui	s6,0x1
    8000114e:	0535ea63          	bltu	a1,s3,800011a2 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001152:	60a6                	ld	ra,72(sp)
    80001154:	6406                	ld	s0,64(sp)
    80001156:	74e2                	ld	s1,56(sp)
    80001158:	7942                	ld	s2,48(sp)
    8000115a:	79a2                	ld	s3,40(sp)
    8000115c:	7a02                	ld	s4,32(sp)
    8000115e:	6ae2                	ld	s5,24(sp)
    80001160:	6b42                	ld	s6,16(sp)
    80001162:	6ba2                	ld	s7,8(sp)
    80001164:	6161                	addi	sp,sp,80
    80001166:	8082                	ret
    panic("uvmunmap: not aligned");
    80001168:	00006517          	auipc	a0,0x6
    8000116c:	ff850513          	addi	a0,a0,-8 # 80007160 <digits+0x128>
    80001170:	de6ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: walk");
    80001174:	00006517          	auipc	a0,0x6
    80001178:	00450513          	addi	a0,a0,4 # 80007178 <digits+0x140>
    8000117c:	ddaff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not mapped");
    80001180:	00006517          	auipc	a0,0x6
    80001184:	00850513          	addi	a0,a0,8 # 80007188 <digits+0x150>
    80001188:	dceff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not a leaf");
    8000118c:	00006517          	auipc	a0,0x6
    80001190:	01450513          	addi	a0,a0,20 # 800071a0 <digits+0x168>
    80001194:	dc2ff0ef          	jal	ra,80000756 <panic>
    *pte = 0;
    80001198:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000119c:	995a                	add	s2,s2,s6
    8000119e:	fb397ae3          	bgeu	s2,s3,80001152 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800011a2:	4601                	li	a2,0
    800011a4:	85ca                	mv	a1,s2
    800011a6:	8552                	mv	a0,s4
    800011a8:	cfdff0ef          	jal	ra,80000ea4 <walk>
    800011ac:	84aa                	mv	s1,a0
    800011ae:	d179                	beqz	a0,80001174 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800011b0:	6108                	ld	a0,0(a0)
    800011b2:	00157793          	andi	a5,a0,1
    800011b6:	d7e9                	beqz	a5,80001180 <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    800011b8:	3ff57793          	andi	a5,a0,1023
    800011bc:	fd7788e3          	beq	a5,s7,8000118c <uvmunmap+0x6a>
    if(do_free){
    800011c0:	fc0a8ce3          	beqz	s5,80001198 <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800011c4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800011c6:	0532                	slli	a0,a0,0xc
    800011c8:	823ff0ef          	jal	ra,800009ea <kfree>
    800011cc:	b7f1                	j	80001198 <uvmunmap+0x76>

00000000800011ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011ce:	1101                	addi	sp,sp,-32
    800011d0:	ec06                	sd	ra,24(sp)
    800011d2:	e822                	sd	s0,16(sp)
    800011d4:	e426                	sd	s1,8(sp)
    800011d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800011d8:	8f3ff0ef          	jal	ra,80000aca <kalloc>
    800011dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011de:	c509                	beqz	a0,800011e8 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011e0:	6605                	lui	a2,0x1
    800011e2:	4581                	li	a1,0
    800011e4:	a8bff0ef          	jal	ra,80000c6e <memset>
  return pagetable;
}
    800011e8:	8526                	mv	a0,s1
    800011ea:	60e2                	ld	ra,24(sp)
    800011ec:	6442                	ld	s0,16(sp)
    800011ee:	64a2                	ld	s1,8(sp)
    800011f0:	6105                	addi	sp,sp,32
    800011f2:	8082                	ret

00000000800011f4 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800011f4:	7179                	addi	sp,sp,-48
    800011f6:	f406                	sd	ra,40(sp)
    800011f8:	f022                	sd	s0,32(sp)
    800011fa:	ec26                	sd	s1,24(sp)
    800011fc:	e84a                	sd	s2,16(sp)
    800011fe:	e44e                	sd	s3,8(sp)
    80001200:	e052                	sd	s4,0(sp)
    80001202:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001204:	6785                	lui	a5,0x1
    80001206:	04f67063          	bgeu	a2,a5,80001246 <uvmfirst+0x52>
    8000120a:	8a2a                	mv	s4,a0
    8000120c:	89ae                	mv	s3,a1
    8000120e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001210:	8bbff0ef          	jal	ra,80000aca <kalloc>
    80001214:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001216:	6605                	lui	a2,0x1
    80001218:	4581                	li	a1,0
    8000121a:	a55ff0ef          	jal	ra,80000c6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000121e:	4779                	li	a4,30
    80001220:	86ca                	mv	a3,s2
    80001222:	6605                	lui	a2,0x1
    80001224:	4581                	li	a1,0
    80001226:	8552                	mv	a0,s4
    80001228:	d55ff0ef          	jal	ra,80000f7c <mappages>
  memmove(mem, src, sz);
    8000122c:	8626                	mv	a2,s1
    8000122e:	85ce                	mv	a1,s3
    80001230:	854a                	mv	a0,s2
    80001232:	a99ff0ef          	jal	ra,80000cca <memmove>
}
    80001236:	70a2                	ld	ra,40(sp)
    80001238:	7402                	ld	s0,32(sp)
    8000123a:	64e2                	ld	s1,24(sp)
    8000123c:	6942                	ld	s2,16(sp)
    8000123e:	69a2                	ld	s3,8(sp)
    80001240:	6a02                	ld	s4,0(sp)
    80001242:	6145                	addi	sp,sp,48
    80001244:	8082                	ret
    panic("uvmfirst: more than a page");
    80001246:	00006517          	auipc	a0,0x6
    8000124a:	f7250513          	addi	a0,a0,-142 # 800071b8 <digits+0x180>
    8000124e:	d08ff0ef          	jal	ra,80000756 <panic>

0000000080001252 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001252:	1101                	addi	sp,sp,-32
    80001254:	ec06                	sd	ra,24(sp)
    80001256:	e822                	sd	s0,16(sp)
    80001258:	e426                	sd	s1,8(sp)
    8000125a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000125c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000125e:	00b67d63          	bgeu	a2,a1,80001278 <uvmdealloc+0x26>
    80001262:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001264:	6785                	lui	a5,0x1
    80001266:	17fd                	addi	a5,a5,-1
    80001268:	00f60733          	add	a4,a2,a5
    8000126c:	767d                	lui	a2,0xfffff
    8000126e:	8f71                	and	a4,a4,a2
    80001270:	97ae                	add	a5,a5,a1
    80001272:	8ff1                	and	a5,a5,a2
    80001274:	00f76863          	bltu	a4,a5,80001284 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001278:	8526                	mv	a0,s1
    8000127a:	60e2                	ld	ra,24(sp)
    8000127c:	6442                	ld	s0,16(sp)
    8000127e:	64a2                	ld	s1,8(sp)
    80001280:	6105                	addi	sp,sp,32
    80001282:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001284:	8f99                	sub	a5,a5,a4
    80001286:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001288:	4685                	li	a3,1
    8000128a:	0007861b          	sext.w	a2,a5
    8000128e:	85ba                	mv	a1,a4
    80001290:	e93ff0ef          	jal	ra,80001122 <uvmunmap>
    80001294:	b7d5                	j	80001278 <uvmdealloc+0x26>

0000000080001296 <uvmalloc>:
  if(newsz < oldsz)
    80001296:	08b66963          	bltu	a2,a1,80001328 <uvmalloc+0x92>
{
    8000129a:	7139                	addi	sp,sp,-64
    8000129c:	fc06                	sd	ra,56(sp)
    8000129e:	f822                	sd	s0,48(sp)
    800012a0:	f426                	sd	s1,40(sp)
    800012a2:	f04a                	sd	s2,32(sp)
    800012a4:	ec4e                	sd	s3,24(sp)
    800012a6:	e852                	sd	s4,16(sp)
    800012a8:	e456                	sd	s5,8(sp)
    800012aa:	e05a                	sd	s6,0(sp)
    800012ac:	0080                	addi	s0,sp,64
    800012ae:	8aaa                	mv	s5,a0
    800012b0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012b2:	6985                	lui	s3,0x1
    800012b4:	19fd                	addi	s3,s3,-1
    800012b6:	95ce                	add	a1,a1,s3
    800012b8:	79fd                	lui	s3,0xfffff
    800012ba:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012be:	06c9f763          	bgeu	s3,a2,8000132c <uvmalloc+0x96>
    800012c2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012c4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012c8:	803ff0ef          	jal	ra,80000aca <kalloc>
    800012cc:	84aa                	mv	s1,a0
    if(mem == 0){
    800012ce:	c11d                	beqz	a0,800012f4 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    800012d0:	6605                	lui	a2,0x1
    800012d2:	4581                	li	a1,0
    800012d4:	99bff0ef          	jal	ra,80000c6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012d8:	875a                	mv	a4,s6
    800012da:	86a6                	mv	a3,s1
    800012dc:	6605                	lui	a2,0x1
    800012de:	85ca                	mv	a1,s2
    800012e0:	8556                	mv	a0,s5
    800012e2:	c9bff0ef          	jal	ra,80000f7c <mappages>
    800012e6:	e51d                	bnez	a0,80001314 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012e8:	6785                	lui	a5,0x1
    800012ea:	993e                	add	s2,s2,a5
    800012ec:	fd496ee3          	bltu	s2,s4,800012c8 <uvmalloc+0x32>
  return newsz;
    800012f0:	8552                	mv	a0,s4
    800012f2:	a039                	j	80001300 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    800012f4:	864e                	mv	a2,s3
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8556                	mv	a0,s5
    800012fa:	f59ff0ef          	jal	ra,80001252 <uvmdealloc>
      return 0;
    800012fe:	4501                	li	a0,0
}
    80001300:	70e2                	ld	ra,56(sp)
    80001302:	7442                	ld	s0,48(sp)
    80001304:	74a2                	ld	s1,40(sp)
    80001306:	7902                	ld	s2,32(sp)
    80001308:	69e2                	ld	s3,24(sp)
    8000130a:	6a42                	ld	s4,16(sp)
    8000130c:	6aa2                	ld	s5,8(sp)
    8000130e:	6b02                	ld	s6,0(sp)
    80001310:	6121                	addi	sp,sp,64
    80001312:	8082                	ret
      kfree(mem);
    80001314:	8526                	mv	a0,s1
    80001316:	ed4ff0ef          	jal	ra,800009ea <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000131a:	864e                	mv	a2,s3
    8000131c:	85ca                	mv	a1,s2
    8000131e:	8556                	mv	a0,s5
    80001320:	f33ff0ef          	jal	ra,80001252 <uvmdealloc>
      return 0;
    80001324:	4501                	li	a0,0
    80001326:	bfe9                	j	80001300 <uvmalloc+0x6a>
    return oldsz;
    80001328:	852e                	mv	a0,a1
}
    8000132a:	8082                	ret
  return newsz;
    8000132c:	8532                	mv	a0,a2
    8000132e:	bfc9                	j	80001300 <uvmalloc+0x6a>

0000000080001330 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001330:	7179                	addi	sp,sp,-48
    80001332:	f406                	sd	ra,40(sp)
    80001334:	f022                	sd	s0,32(sp)
    80001336:	ec26                	sd	s1,24(sp)
    80001338:	e84a                	sd	s2,16(sp)
    8000133a:	e44e                	sd	s3,8(sp)
    8000133c:	e052                	sd	s4,0(sp)
    8000133e:	1800                	addi	s0,sp,48
    80001340:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001342:	84aa                	mv	s1,a0
    80001344:	6905                	lui	s2,0x1
    80001346:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001348:	4985                	li	s3,1
    8000134a:	a811                	j	8000135e <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000134c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000134e:	0532                	slli	a0,a0,0xc
    80001350:	fe1ff0ef          	jal	ra,80001330 <freewalk>
      pagetable[i] = 0;
    80001354:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001358:	04a1                	addi	s1,s1,8
    8000135a:	01248f63          	beq	s1,s2,80001378 <freewalk+0x48>
    pte_t pte = pagetable[i];
    8000135e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001360:	00f57793          	andi	a5,a0,15
    80001364:	ff3784e3          	beq	a5,s3,8000134c <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001368:	8905                	andi	a0,a0,1
    8000136a:	d57d                	beqz	a0,80001358 <freewalk+0x28>
      panic("freewalk: leaf");
    8000136c:	00006517          	auipc	a0,0x6
    80001370:	e6c50513          	addi	a0,a0,-404 # 800071d8 <digits+0x1a0>
    80001374:	be2ff0ef          	jal	ra,80000756 <panic>
    }
  }
  kfree((void*)pagetable);
    80001378:	8552                	mv	a0,s4
    8000137a:	e70ff0ef          	jal	ra,800009ea <kfree>
}
    8000137e:	70a2                	ld	ra,40(sp)
    80001380:	7402                	ld	s0,32(sp)
    80001382:	64e2                	ld	s1,24(sp)
    80001384:	6942                	ld	s2,16(sp)
    80001386:	69a2                	ld	s3,8(sp)
    80001388:	6a02                	ld	s4,0(sp)
    8000138a:	6145                	addi	sp,sp,48
    8000138c:	8082                	ret

000000008000138e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	1000                	addi	s0,sp,32
    80001398:	84aa                	mv	s1,a0
  if(sz > 0)
    8000139a:	e989                	bnez	a1,800013ac <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000139c:	8526                	mv	a0,s1
    8000139e:	f93ff0ef          	jal	ra,80001330 <freewalk>
}
    800013a2:	60e2                	ld	ra,24(sp)
    800013a4:	6442                	ld	s0,16(sp)
    800013a6:	64a2                	ld	s1,8(sp)
    800013a8:	6105                	addi	sp,sp,32
    800013aa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013ac:	6605                	lui	a2,0x1
    800013ae:	167d                	addi	a2,a2,-1
    800013b0:	962e                	add	a2,a2,a1
    800013b2:	4685                	li	a3,1
    800013b4:	8231                	srli	a2,a2,0xc
    800013b6:	4581                	li	a1,0
    800013b8:	d6bff0ef          	jal	ra,80001122 <uvmunmap>
    800013bc:	b7c5                	j	8000139c <uvmfree+0xe>

00000000800013be <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800013be:	c65d                	beqz	a2,8000146c <uvmcopy+0xae>
{
    800013c0:	715d                	addi	sp,sp,-80
    800013c2:	e486                	sd	ra,72(sp)
    800013c4:	e0a2                	sd	s0,64(sp)
    800013c6:	fc26                	sd	s1,56(sp)
    800013c8:	f84a                	sd	s2,48(sp)
    800013ca:	f44e                	sd	s3,40(sp)
    800013cc:	f052                	sd	s4,32(sp)
    800013ce:	ec56                	sd	s5,24(sp)
    800013d0:	e85a                	sd	s6,16(sp)
    800013d2:	e45e                	sd	s7,8(sp)
    800013d4:	0880                	addi	s0,sp,80
    800013d6:	8b2a                	mv	s6,a0
    800013d8:	8aae                	mv	s5,a1
    800013da:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800013dc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800013de:	4601                	li	a2,0
    800013e0:	85ce                	mv	a1,s3
    800013e2:	855a                	mv	a0,s6
    800013e4:	ac1ff0ef          	jal	ra,80000ea4 <walk>
    800013e8:	c121                	beqz	a0,80001428 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800013ea:	6118                	ld	a4,0(a0)
    800013ec:	00177793          	andi	a5,a4,1
    800013f0:	c3b1                	beqz	a5,80001434 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800013f2:	00a75593          	srli	a1,a4,0xa
    800013f6:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800013fa:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800013fe:	eccff0ef          	jal	ra,80000aca <kalloc>
    80001402:	892a                	mv	s2,a0
    80001404:	c129                	beqz	a0,80001446 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001406:	6605                	lui	a2,0x1
    80001408:	85de                	mv	a1,s7
    8000140a:	8c1ff0ef          	jal	ra,80000cca <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000140e:	8726                	mv	a4,s1
    80001410:	86ca                	mv	a3,s2
    80001412:	6605                	lui	a2,0x1
    80001414:	85ce                	mv	a1,s3
    80001416:	8556                	mv	a0,s5
    80001418:	b65ff0ef          	jal	ra,80000f7c <mappages>
    8000141c:	e115                	bnez	a0,80001440 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000141e:	6785                	lui	a5,0x1
    80001420:	99be                	add	s3,s3,a5
    80001422:	fb49eee3          	bltu	s3,s4,800013de <uvmcopy+0x20>
    80001426:	a805                	j	80001456 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001428:	00006517          	auipc	a0,0x6
    8000142c:	dc050513          	addi	a0,a0,-576 # 800071e8 <digits+0x1b0>
    80001430:	b26ff0ef          	jal	ra,80000756 <panic>
      panic("uvmcopy: page not present");
    80001434:	00006517          	auipc	a0,0x6
    80001438:	dd450513          	addi	a0,a0,-556 # 80007208 <digits+0x1d0>
    8000143c:	b1aff0ef          	jal	ra,80000756 <panic>
      kfree(mem);
    80001440:	854a                	mv	a0,s2
    80001442:	da8ff0ef          	jal	ra,800009ea <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001446:	4685                	li	a3,1
    80001448:	00c9d613          	srli	a2,s3,0xc
    8000144c:	4581                	li	a1,0
    8000144e:	8556                	mv	a0,s5
    80001450:	cd3ff0ef          	jal	ra,80001122 <uvmunmap>
  return -1;
    80001454:	557d                	li	a0,-1
}
    80001456:	60a6                	ld	ra,72(sp)
    80001458:	6406                	ld	s0,64(sp)
    8000145a:	74e2                	ld	s1,56(sp)
    8000145c:	7942                	ld	s2,48(sp)
    8000145e:	79a2                	ld	s3,40(sp)
    80001460:	7a02                	ld	s4,32(sp)
    80001462:	6ae2                	ld	s5,24(sp)
    80001464:	6b42                	ld	s6,16(sp)
    80001466:	6ba2                	ld	s7,8(sp)
    80001468:	6161                	addi	sp,sp,80
    8000146a:	8082                	ret
  return 0;
    8000146c:	4501                	li	a0,0
}
    8000146e:	8082                	ret

0000000080001470 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001470:	1141                	addi	sp,sp,-16
    80001472:	e406                	sd	ra,8(sp)
    80001474:	e022                	sd	s0,0(sp)
    80001476:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001478:	4601                	li	a2,0
    8000147a:	a2bff0ef          	jal	ra,80000ea4 <walk>
  if(pte == 0)
    8000147e:	c901                	beqz	a0,8000148e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001480:	611c                	ld	a5,0(a0)
    80001482:	9bbd                	andi	a5,a5,-17
    80001484:	e11c                	sd	a5,0(a0)
}
    80001486:	60a2                	ld	ra,8(sp)
    80001488:	6402                	ld	s0,0(sp)
    8000148a:	0141                	addi	sp,sp,16
    8000148c:	8082                	ret
    panic("uvmclear");
    8000148e:	00006517          	auipc	a0,0x6
    80001492:	d9a50513          	addi	a0,a0,-614 # 80007228 <digits+0x1f0>
    80001496:	ac0ff0ef          	jal	ra,80000756 <panic>

000000008000149a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    8000149a:	c6c9                	beqz	a3,80001524 <copyout+0x8a>
{
    8000149c:	711d                	addi	sp,sp,-96
    8000149e:	ec86                	sd	ra,88(sp)
    800014a0:	e8a2                	sd	s0,80(sp)
    800014a2:	e4a6                	sd	s1,72(sp)
    800014a4:	e0ca                	sd	s2,64(sp)
    800014a6:	fc4e                	sd	s3,56(sp)
    800014a8:	f852                	sd	s4,48(sp)
    800014aa:	f456                	sd	s5,40(sp)
    800014ac:	f05a                	sd	s6,32(sp)
    800014ae:	ec5e                	sd	s7,24(sp)
    800014b0:	e862                	sd	s8,16(sp)
    800014b2:	e466                	sd	s9,8(sp)
    800014b4:	e06a                	sd	s10,0(sp)
    800014b6:	1080                	addi	s0,sp,96
    800014b8:	8baa                	mv	s7,a0
    800014ba:	8aae                	mv	s5,a1
    800014bc:	8b32                	mv	s6,a2
    800014be:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800014c0:	74fd                	lui	s1,0xfffff
    800014c2:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800014c4:	57fd                	li	a5,-1
    800014c6:	83e9                	srli	a5,a5,0x1a
    800014c8:	0697e063          	bltu	a5,s1,80001528 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800014cc:	4cd5                	li	s9,21
    800014ce:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800014d0:	8c3e                	mv	s8,a5
    800014d2:	a025                	j	800014fa <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800014d4:	83a9                	srli	a5,a5,0xa
    800014d6:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800014d8:	409a8533          	sub	a0,s5,s1
    800014dc:	0009061b          	sext.w	a2,s2
    800014e0:	85da                	mv	a1,s6
    800014e2:	953e                	add	a0,a0,a5
    800014e4:	fe6ff0ef          	jal	ra,80000cca <memmove>

    len -= n;
    800014e8:	412989b3          	sub	s3,s3,s2
    src += n;
    800014ec:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800014ee:	02098963          	beqz	s3,80001520 <copyout+0x86>
    if(va0 >= MAXVA)
    800014f2:	034c6d63          	bltu	s8,s4,8000152c <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    800014f6:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    800014f8:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800014fa:	4601                	li	a2,0
    800014fc:	85a6                	mv	a1,s1
    800014fe:	855e                	mv	a0,s7
    80001500:	9a5ff0ef          	jal	ra,80000ea4 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001504:	c515                	beqz	a0,80001530 <copyout+0x96>
    80001506:	611c                	ld	a5,0(a0)
    80001508:	0157f713          	andi	a4,a5,21
    8000150c:	05971163          	bne	a4,s9,8000154e <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001510:	01a48a33          	add	s4,s1,s10
    80001514:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001518:	fb29fee3          	bgeu	s3,s2,800014d4 <copyout+0x3a>
    8000151c:	894e                	mv	s2,s3
    8000151e:	bf5d                	j	800014d4 <copyout+0x3a>
  }
  return 0;
    80001520:	4501                	li	a0,0
    80001522:	a801                	j	80001532 <copyout+0x98>
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret
      return -1;
    80001528:	557d                	li	a0,-1
    8000152a:	a021                	j	80001532 <copyout+0x98>
    8000152c:	557d                	li	a0,-1
    8000152e:	a011                	j	80001532 <copyout+0x98>
      return -1;
    80001530:	557d                	li	a0,-1
}
    80001532:	60e6                	ld	ra,88(sp)
    80001534:	6446                	ld	s0,80(sp)
    80001536:	64a6                	ld	s1,72(sp)
    80001538:	6906                	ld	s2,64(sp)
    8000153a:	79e2                	ld	s3,56(sp)
    8000153c:	7a42                	ld	s4,48(sp)
    8000153e:	7aa2                	ld	s5,40(sp)
    80001540:	7b02                	ld	s6,32(sp)
    80001542:	6be2                	ld	s7,24(sp)
    80001544:	6c42                	ld	s8,16(sp)
    80001546:	6ca2                	ld	s9,8(sp)
    80001548:	6d02                	ld	s10,0(sp)
    8000154a:	6125                	addi	sp,sp,96
    8000154c:	8082                	ret
      return -1;
    8000154e:	557d                	li	a0,-1
    80001550:	b7cd                	j	80001532 <copyout+0x98>

0000000080001552 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001552:	c6a5                	beqz	a3,800015ba <copyin+0x68>
{
    80001554:	715d                	addi	sp,sp,-80
    80001556:	e486                	sd	ra,72(sp)
    80001558:	e0a2                	sd	s0,64(sp)
    8000155a:	fc26                	sd	s1,56(sp)
    8000155c:	f84a                	sd	s2,48(sp)
    8000155e:	f44e                	sd	s3,40(sp)
    80001560:	f052                	sd	s4,32(sp)
    80001562:	ec56                	sd	s5,24(sp)
    80001564:	e85a                	sd	s6,16(sp)
    80001566:	e45e                	sd	s7,8(sp)
    80001568:	e062                	sd	s8,0(sp)
    8000156a:	0880                	addi	s0,sp,80
    8000156c:	8b2a                	mv	s6,a0
    8000156e:	8a2e                	mv	s4,a1
    80001570:	8c32                	mv	s8,a2
    80001572:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001574:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001576:	6a85                	lui	s5,0x1
    80001578:	a00d                	j	8000159a <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000157a:	018505b3          	add	a1,a0,s8
    8000157e:	0004861b          	sext.w	a2,s1
    80001582:	412585b3          	sub	a1,a1,s2
    80001586:	8552                	mv	a0,s4
    80001588:	f42ff0ef          	jal	ra,80000cca <memmove>

    len -= n;
    8000158c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001590:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001592:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001596:	02098063          	beqz	s3,800015b6 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000159a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000159e:	85ca                	mv	a1,s2
    800015a0:	855a                	mv	a0,s6
    800015a2:	99dff0ef          	jal	ra,80000f3e <walkaddr>
    if(pa0 == 0)
    800015a6:	cd01                	beqz	a0,800015be <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800015a8:	418904b3          	sub	s1,s2,s8
    800015ac:	94d6                	add	s1,s1,s5
    if(n > len)
    800015ae:	fc99f6e3          	bgeu	s3,s1,8000157a <copyin+0x28>
    800015b2:	84ce                	mv	s1,s3
    800015b4:	b7d9                	j	8000157a <copyin+0x28>
  }
  return 0;
    800015b6:	4501                	li	a0,0
    800015b8:	a021                	j	800015c0 <copyin+0x6e>
    800015ba:	4501                	li	a0,0
}
    800015bc:	8082                	ret
      return -1;
    800015be:	557d                	li	a0,-1
}
    800015c0:	60a6                	ld	ra,72(sp)
    800015c2:	6406                	ld	s0,64(sp)
    800015c4:	74e2                	ld	s1,56(sp)
    800015c6:	7942                	ld	s2,48(sp)
    800015c8:	79a2                	ld	s3,40(sp)
    800015ca:	7a02                	ld	s4,32(sp)
    800015cc:	6ae2                	ld	s5,24(sp)
    800015ce:	6b42                	ld	s6,16(sp)
    800015d0:	6ba2                	ld	s7,8(sp)
    800015d2:	6c02                	ld	s8,0(sp)
    800015d4:	6161                	addi	sp,sp,80
    800015d6:	8082                	ret

00000000800015d8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800015d8:	c2d5                	beqz	a3,8000167c <copyinstr+0xa4>
{
    800015da:	715d                	addi	sp,sp,-80
    800015dc:	e486                	sd	ra,72(sp)
    800015de:	e0a2                	sd	s0,64(sp)
    800015e0:	fc26                	sd	s1,56(sp)
    800015e2:	f84a                	sd	s2,48(sp)
    800015e4:	f44e                	sd	s3,40(sp)
    800015e6:	f052                	sd	s4,32(sp)
    800015e8:	ec56                	sd	s5,24(sp)
    800015ea:	e85a                	sd	s6,16(sp)
    800015ec:	e45e                	sd	s7,8(sp)
    800015ee:	0880                	addi	s0,sp,80
    800015f0:	8a2a                	mv	s4,a0
    800015f2:	8b2e                	mv	s6,a1
    800015f4:	8bb2                	mv	s7,a2
    800015f6:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800015f8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015fa:	6985                	lui	s3,0x1
    800015fc:	a035                	j	80001628 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800015fe:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001602:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001604:	0017b793          	seqz	a5,a5
    80001608:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000160c:	60a6                	ld	ra,72(sp)
    8000160e:	6406                	ld	s0,64(sp)
    80001610:	74e2                	ld	s1,56(sp)
    80001612:	7942                	ld	s2,48(sp)
    80001614:	79a2                	ld	s3,40(sp)
    80001616:	7a02                	ld	s4,32(sp)
    80001618:	6ae2                	ld	s5,24(sp)
    8000161a:	6b42                	ld	s6,16(sp)
    8000161c:	6ba2                	ld	s7,8(sp)
    8000161e:	6161                	addi	sp,sp,80
    80001620:	8082                	ret
    srcva = va0 + PGSIZE;
    80001622:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001626:	c4b9                	beqz	s1,80001674 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001628:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000162c:	85ca                	mv	a1,s2
    8000162e:	8552                	mv	a0,s4
    80001630:	90fff0ef          	jal	ra,80000f3e <walkaddr>
    if(pa0 == 0)
    80001634:	c131                	beqz	a0,80001678 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001636:	41790833          	sub	a6,s2,s7
    8000163a:	984e                	add	a6,a6,s3
    if(n > max)
    8000163c:	0104f363          	bgeu	s1,a6,80001642 <copyinstr+0x6a>
    80001640:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001642:	955e                	add	a0,a0,s7
    80001644:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001648:	fc080de3          	beqz	a6,80001622 <copyinstr+0x4a>
    8000164c:	985a                	add	a6,a6,s6
    8000164e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001650:	41650633          	sub	a2,a0,s6
    80001654:	14fd                	addi	s1,s1,-1
    80001656:	9b26                	add	s6,s6,s1
    80001658:	00f60733          	add	a4,a2,a5
    8000165c:	00074703          	lbu	a4,0(a4)
    80001660:	df59                	beqz	a4,800015fe <copyinstr+0x26>
        *dst = *p;
    80001662:	00e78023          	sb	a4,0(a5)
      --max;
    80001666:	40fb04b3          	sub	s1,s6,a5
      dst++;
    8000166a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000166c:	ff0796e3          	bne	a5,a6,80001658 <copyinstr+0x80>
      dst++;
    80001670:	8b42                	mv	s6,a6
    80001672:	bf45                	j	80001622 <copyinstr+0x4a>
    80001674:	4781                	li	a5,0
    80001676:	b779                	j	80001604 <copyinstr+0x2c>
      return -1;
    80001678:	557d                	li	a0,-1
    8000167a:	bf49                	j	8000160c <copyinstr+0x34>
  int got_null = 0;
    8000167c:	4781                	li	a5,0
  if(got_null){
    8000167e:	0017b793          	seqz	a5,a5
    80001682:	40f00533          	neg	a0,a5
}
    80001686:	8082                	ret

0000000080001688 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001688:	7139                	addi	sp,sp,-64
    8000168a:	fc06                	sd	ra,56(sp)
    8000168c:	f822                	sd	s0,48(sp)
    8000168e:	f426                	sd	s1,40(sp)
    80001690:	f04a                	sd	s2,32(sp)
    80001692:	ec4e                	sd	s3,24(sp)
    80001694:	e852                	sd	s4,16(sp)
    80001696:	e456                	sd	s5,8(sp)
    80001698:	e05a                	sd	s6,0(sp)
    8000169a:	0080                	addi	s0,sp,64
    8000169c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000169e:	0000f497          	auipc	s1,0xf
    800016a2:	80248493          	addi	s1,s1,-2046 # 8000fea0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016a6:	8b26                	mv	s6,s1
    800016a8:	00006a97          	auipc	s5,0x6
    800016ac:	958a8a93          	addi	s5,s5,-1704 # 80007000 <etext>
    800016b0:	04000937          	lui	s2,0x4000
    800016b4:	197d                	addi	s2,s2,-1
    800016b6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b8:	00014a17          	auipc	s4,0x14
    800016bc:	1e8a0a13          	addi	s4,s4,488 # 800158a0 <tickslock>
    char *pa = kalloc();
    800016c0:	c0aff0ef          	jal	ra,80000aca <kalloc>
    800016c4:	862a                	mv	a2,a0
    if(pa == 0)
    800016c6:	c121                	beqz	a0,80001706 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    800016c8:	416485b3          	sub	a1,s1,s6
    800016cc:	858d                	srai	a1,a1,0x3
    800016ce:	000ab783          	ld	a5,0(s5)
    800016d2:	02f585b3          	mul	a1,a1,a5
    800016d6:	2585                	addiw	a1,a1,1
    800016d8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800016dc:	4719                	li	a4,6
    800016de:	6685                	lui	a3,0x1
    800016e0:	40b905b3          	sub	a1,s2,a1
    800016e4:	854e                	mv	a0,s3
    800016e6:	947ff0ef          	jal	ra,8000102c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ea:	16848493          	addi	s1,s1,360
    800016ee:	fd4499e3          	bne	s1,s4,800016c0 <proc_mapstacks+0x38>
  }
}
    800016f2:	70e2                	ld	ra,56(sp)
    800016f4:	7442                	ld	s0,48(sp)
    800016f6:	74a2                	ld	s1,40(sp)
    800016f8:	7902                	ld	s2,32(sp)
    800016fa:	69e2                	ld	s3,24(sp)
    800016fc:	6a42                	ld	s4,16(sp)
    800016fe:	6aa2                	ld	s5,8(sp)
    80001700:	6b02                	ld	s6,0(sp)
    80001702:	6121                	addi	sp,sp,64
    80001704:	8082                	ret
      panic("kalloc");
    80001706:	00006517          	auipc	a0,0x6
    8000170a:	b3250513          	addi	a0,a0,-1230 # 80007238 <digits+0x200>
    8000170e:	848ff0ef          	jal	ra,80000756 <panic>

0000000080001712 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001712:	7139                	addi	sp,sp,-64
    80001714:	fc06                	sd	ra,56(sp)
    80001716:	f822                	sd	s0,48(sp)
    80001718:	f426                	sd	s1,40(sp)
    8000171a:	f04a                	sd	s2,32(sp)
    8000171c:	ec4e                	sd	s3,24(sp)
    8000171e:	e852                	sd	s4,16(sp)
    80001720:	e456                	sd	s5,8(sp)
    80001722:	e05a                	sd	s6,0(sp)
    80001724:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001726:	00006597          	auipc	a1,0x6
    8000172a:	b1a58593          	addi	a1,a1,-1254 # 80007240 <digits+0x208>
    8000172e:	0000e517          	auipc	a0,0xe
    80001732:	34250513          	addi	a0,a0,834 # 8000fa70 <pid_lock>
    80001736:	be4ff0ef          	jal	ra,80000b1a <initlock>
  initlock(&wait_lock, "wait_lock");
    8000173a:	00006597          	auipc	a1,0x6
    8000173e:	b0e58593          	addi	a1,a1,-1266 # 80007248 <digits+0x210>
    80001742:	0000e517          	auipc	a0,0xe
    80001746:	34650513          	addi	a0,a0,838 # 8000fa88 <wait_lock>
    8000174a:	bd0ff0ef          	jal	ra,80000b1a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000174e:	0000e497          	auipc	s1,0xe
    80001752:	75248493          	addi	s1,s1,1874 # 8000fea0 <proc>
      initlock(&p->lock, "proc");
    80001756:	00006b17          	auipc	s6,0x6
    8000175a:	b02b0b13          	addi	s6,s6,-1278 # 80007258 <digits+0x220>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000175e:	8aa6                	mv	s5,s1
    80001760:	00006a17          	auipc	s4,0x6
    80001764:	8a0a0a13          	addi	s4,s4,-1888 # 80007000 <etext>
    80001768:	04000937          	lui	s2,0x4000
    8000176c:	197d                	addi	s2,s2,-1
    8000176e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001770:	00014997          	auipc	s3,0x14
    80001774:	13098993          	addi	s3,s3,304 # 800158a0 <tickslock>
      initlock(&p->lock, "proc");
    80001778:	85da                	mv	a1,s6
    8000177a:	8526                	mv	a0,s1
    8000177c:	b9eff0ef          	jal	ra,80000b1a <initlock>
      p->state = UNUSED;
    80001780:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001784:	415487b3          	sub	a5,s1,s5
    80001788:	878d                	srai	a5,a5,0x3
    8000178a:	000a3703          	ld	a4,0(s4)
    8000178e:	02e787b3          	mul	a5,a5,a4
    80001792:	2785                	addiw	a5,a5,1
    80001794:	00d7979b          	slliw	a5,a5,0xd
    80001798:	40f907b3          	sub	a5,s2,a5
    8000179c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	16848493          	addi	s1,s1,360
    800017a2:	fd349be3          	bne	s1,s3,80001778 <procinit+0x66>
  }
}
    800017a6:	70e2                	ld	ra,56(sp)
    800017a8:	7442                	ld	s0,48(sp)
    800017aa:	74a2                	ld	s1,40(sp)
    800017ac:	7902                	ld	s2,32(sp)
    800017ae:	69e2                	ld	s3,24(sp)
    800017b0:	6a42                	ld	s4,16(sp)
    800017b2:	6aa2                	ld	s5,8(sp)
    800017b4:	6b02                	ld	s6,0(sp)
    800017b6:	6121                	addi	sp,sp,64
    800017b8:	8082                	ret

00000000800017ba <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800017ba:	1141                	addi	sp,sp,-16
    800017bc:	e422                	sd	s0,8(sp)
    800017be:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800017c0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800017c2:	2501                	sext.w	a0,a0
    800017c4:	6422                	ld	s0,8(sp)
    800017c6:	0141                	addi	sp,sp,16
    800017c8:	8082                	ret

00000000800017ca <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800017ca:	1141                	addi	sp,sp,-16
    800017cc:	e422                	sd	s0,8(sp)
    800017ce:	0800                	addi	s0,sp,16
    800017d0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800017d2:	2781                	sext.w	a5,a5
    800017d4:	079e                	slli	a5,a5,0x7
  return c;
}
    800017d6:	0000e517          	auipc	a0,0xe
    800017da:	2ca50513          	addi	a0,a0,714 # 8000faa0 <cpus>
    800017de:	953e                	add	a0,a0,a5
    800017e0:	6422                	ld	s0,8(sp)
    800017e2:	0141                	addi	sp,sp,16
    800017e4:	8082                	ret

00000000800017e6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800017e6:	1101                	addi	sp,sp,-32
    800017e8:	ec06                	sd	ra,24(sp)
    800017ea:	e822                	sd	s0,16(sp)
    800017ec:	e426                	sd	s1,8(sp)
    800017ee:	1000                	addi	s0,sp,32
  push_off();
    800017f0:	b6aff0ef          	jal	ra,80000b5a <push_off>
    800017f4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800017f6:	2781                	sext.w	a5,a5
    800017f8:	079e                	slli	a5,a5,0x7
    800017fa:	0000e717          	auipc	a4,0xe
    800017fe:	27670713          	addi	a4,a4,630 # 8000fa70 <pid_lock>
    80001802:	97ba                	add	a5,a5,a4
    80001804:	7b84                	ld	s1,48(a5)
  pop_off();
    80001806:	bd8ff0ef          	jal	ra,80000bde <pop_off>
  return p;
}
    8000180a:	8526                	mv	a0,s1
    8000180c:	60e2                	ld	ra,24(sp)
    8000180e:	6442                	ld	s0,16(sp)
    80001810:	64a2                	ld	s1,8(sp)
    80001812:	6105                	addi	sp,sp,32
    80001814:	8082                	ret

0000000080001816 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001816:	1141                	addi	sp,sp,-16
    80001818:	e406                	sd	ra,8(sp)
    8000181a:	e022                	sd	s0,0(sp)
    8000181c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000181e:	fc9ff0ef          	jal	ra,800017e6 <myproc>
    80001822:	c10ff0ef          	jal	ra,80000c32 <release>

  if (first) {
    80001826:	00006797          	auipc	a5,0x6
    8000182a:	09a7a783          	lw	a5,154(a5) # 800078c0 <first.1>
    8000182e:	e799                	bnez	a5,8000183c <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001830:	2bb000ef          	jal	ra,800022ea <usertrapret>
}
    80001834:	60a2                	ld	ra,8(sp)
    80001836:	6402                	ld	s0,0(sp)
    80001838:	0141                	addi	sp,sp,16
    8000183a:	8082                	ret
    fsinit(ROOTDEV);
    8000183c:	4505                	li	a0,1
    8000183e:	6f4010ef          	jal	ra,80002f32 <fsinit>
    first = 0;
    80001842:	00006797          	auipc	a5,0x6
    80001846:	0607af23          	sw	zero,126(a5) # 800078c0 <first.1>
    __sync_synchronize();
    8000184a:	0ff0000f          	fence
    8000184e:	b7cd                	j	80001830 <forkret+0x1a>

0000000080001850 <allocpid>:
{
    80001850:	1101                	addi	sp,sp,-32
    80001852:	ec06                	sd	ra,24(sp)
    80001854:	e822                	sd	s0,16(sp)
    80001856:	e426                	sd	s1,8(sp)
    80001858:	e04a                	sd	s2,0(sp)
    8000185a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000185c:	0000e917          	auipc	s2,0xe
    80001860:	21490913          	addi	s2,s2,532 # 8000fa70 <pid_lock>
    80001864:	854a                	mv	a0,s2
    80001866:	b34ff0ef          	jal	ra,80000b9a <acquire>
  pid = nextpid;
    8000186a:	00006797          	auipc	a5,0x6
    8000186e:	05a78793          	addi	a5,a5,90 # 800078c4 <nextpid>
    80001872:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001874:	0014871b          	addiw	a4,s1,1
    80001878:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000187a:	854a                	mv	a0,s2
    8000187c:	bb6ff0ef          	jal	ra,80000c32 <release>
}
    80001880:	8526                	mv	a0,s1
    80001882:	60e2                	ld	ra,24(sp)
    80001884:	6442                	ld	s0,16(sp)
    80001886:	64a2                	ld	s1,8(sp)
    80001888:	6902                	ld	s2,0(sp)
    8000188a:	6105                	addi	sp,sp,32
    8000188c:	8082                	ret

000000008000188e <proc_pagetable>:
{
    8000188e:	1101                	addi	sp,sp,-32
    80001890:	ec06                	sd	ra,24(sp)
    80001892:	e822                	sd	s0,16(sp)
    80001894:	e426                	sd	s1,8(sp)
    80001896:	e04a                	sd	s2,0(sp)
    80001898:	1000                	addi	s0,sp,32
    8000189a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000189c:	933ff0ef          	jal	ra,800011ce <uvmcreate>
    800018a0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018a2:	cd05                	beqz	a0,800018da <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018a4:	4729                	li	a4,10
    800018a6:	00004697          	auipc	a3,0x4
    800018aa:	75a68693          	addi	a3,a3,1882 # 80006000 <_trampoline>
    800018ae:	6605                	lui	a2,0x1
    800018b0:	040005b7          	lui	a1,0x4000
    800018b4:	15fd                	addi	a1,a1,-1
    800018b6:	05b2                	slli	a1,a1,0xc
    800018b8:	ec4ff0ef          	jal	ra,80000f7c <mappages>
    800018bc:	02054663          	bltz	a0,800018e8 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800018c0:	4719                	li	a4,6
    800018c2:	05893683          	ld	a3,88(s2)
    800018c6:	6605                	lui	a2,0x1
    800018c8:	020005b7          	lui	a1,0x2000
    800018cc:	15fd                	addi	a1,a1,-1
    800018ce:	05b6                	slli	a1,a1,0xd
    800018d0:	8526                	mv	a0,s1
    800018d2:	eaaff0ef          	jal	ra,80000f7c <mappages>
    800018d6:	00054f63          	bltz	a0,800018f4 <proc_pagetable+0x66>
}
    800018da:	8526                	mv	a0,s1
    800018dc:	60e2                	ld	ra,24(sp)
    800018de:	6442                	ld	s0,16(sp)
    800018e0:	64a2                	ld	s1,8(sp)
    800018e2:	6902                	ld	s2,0(sp)
    800018e4:	6105                	addi	sp,sp,32
    800018e6:	8082                	ret
    uvmfree(pagetable, 0);
    800018e8:	4581                	li	a1,0
    800018ea:	8526                	mv	a0,s1
    800018ec:	aa3ff0ef          	jal	ra,8000138e <uvmfree>
    return 0;
    800018f0:	4481                	li	s1,0
    800018f2:	b7e5                	j	800018da <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800018f4:	4681                	li	a3,0
    800018f6:	4605                	li	a2,1
    800018f8:	040005b7          	lui	a1,0x4000
    800018fc:	15fd                	addi	a1,a1,-1
    800018fe:	05b2                	slli	a1,a1,0xc
    80001900:	8526                	mv	a0,s1
    80001902:	821ff0ef          	jal	ra,80001122 <uvmunmap>
    uvmfree(pagetable, 0);
    80001906:	4581                	li	a1,0
    80001908:	8526                	mv	a0,s1
    8000190a:	a85ff0ef          	jal	ra,8000138e <uvmfree>
    return 0;
    8000190e:	4481                	li	s1,0
    80001910:	b7e9                	j	800018da <proc_pagetable+0x4c>

0000000080001912 <proc_freepagetable>:
{
    80001912:	1101                	addi	sp,sp,-32
    80001914:	ec06                	sd	ra,24(sp)
    80001916:	e822                	sd	s0,16(sp)
    80001918:	e426                	sd	s1,8(sp)
    8000191a:	e04a                	sd	s2,0(sp)
    8000191c:	1000                	addi	s0,sp,32
    8000191e:	84aa                	mv	s1,a0
    80001920:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001922:	4681                	li	a3,0
    80001924:	4605                	li	a2,1
    80001926:	040005b7          	lui	a1,0x4000
    8000192a:	15fd                	addi	a1,a1,-1
    8000192c:	05b2                	slli	a1,a1,0xc
    8000192e:	ff4ff0ef          	jal	ra,80001122 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001932:	4681                	li	a3,0
    80001934:	4605                	li	a2,1
    80001936:	020005b7          	lui	a1,0x2000
    8000193a:	15fd                	addi	a1,a1,-1
    8000193c:	05b6                	slli	a1,a1,0xd
    8000193e:	8526                	mv	a0,s1
    80001940:	fe2ff0ef          	jal	ra,80001122 <uvmunmap>
  uvmfree(pagetable, sz);
    80001944:	85ca                	mv	a1,s2
    80001946:	8526                	mv	a0,s1
    80001948:	a47ff0ef          	jal	ra,8000138e <uvmfree>
}
    8000194c:	60e2                	ld	ra,24(sp)
    8000194e:	6442                	ld	s0,16(sp)
    80001950:	64a2                	ld	s1,8(sp)
    80001952:	6902                	ld	s2,0(sp)
    80001954:	6105                	addi	sp,sp,32
    80001956:	8082                	ret

0000000080001958 <freeproc>:
{
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	e426                	sd	s1,8(sp)
    80001960:	1000                	addi	s0,sp,32
    80001962:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001964:	6d28                	ld	a0,88(a0)
    80001966:	c119                	beqz	a0,8000196c <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001968:	882ff0ef          	jal	ra,800009ea <kfree>
  p->trapframe = 0;
    8000196c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001970:	68a8                	ld	a0,80(s1)
    80001972:	c501                	beqz	a0,8000197a <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001974:	64ac                	ld	a1,72(s1)
    80001976:	f9dff0ef          	jal	ra,80001912 <proc_freepagetable>
  p->pagetable = 0;
    8000197a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000197e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001982:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001986:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000198a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000198e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001992:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001996:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000199a:	0004ac23          	sw	zero,24(s1)
}
    8000199e:	60e2                	ld	ra,24(sp)
    800019a0:	6442                	ld	s0,16(sp)
    800019a2:	64a2                	ld	s1,8(sp)
    800019a4:	6105                	addi	sp,sp,32
    800019a6:	8082                	ret

00000000800019a8 <allocproc>:
{
    800019a8:	1101                	addi	sp,sp,-32
    800019aa:	ec06                	sd	ra,24(sp)
    800019ac:	e822                	sd	s0,16(sp)
    800019ae:	e426                	sd	s1,8(sp)
    800019b0:	e04a                	sd	s2,0(sp)
    800019b2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800019b4:	0000e497          	auipc	s1,0xe
    800019b8:	4ec48493          	addi	s1,s1,1260 # 8000fea0 <proc>
    800019bc:	00014917          	auipc	s2,0x14
    800019c0:	ee490913          	addi	s2,s2,-284 # 800158a0 <tickslock>
    acquire(&p->lock);
    800019c4:	8526                	mv	a0,s1
    800019c6:	9d4ff0ef          	jal	ra,80000b9a <acquire>
    if(p->state == UNUSED) {
    800019ca:	4c9c                	lw	a5,24(s1)
    800019cc:	cb91                	beqz	a5,800019e0 <allocproc+0x38>
      release(&p->lock);
    800019ce:	8526                	mv	a0,s1
    800019d0:	a62ff0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019d4:	16848493          	addi	s1,s1,360
    800019d8:	ff2496e3          	bne	s1,s2,800019c4 <allocproc+0x1c>
  return 0;
    800019dc:	4481                	li	s1,0
    800019de:	a089                	j	80001a20 <allocproc+0x78>
  p->pid = allocpid();
    800019e0:	e71ff0ef          	jal	ra,80001850 <allocpid>
    800019e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800019e6:	4785                	li	a5,1
    800019e8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800019ea:	8e0ff0ef          	jal	ra,80000aca <kalloc>
    800019ee:	892a                	mv	s2,a0
    800019f0:	eca8                	sd	a0,88(s1)
    800019f2:	cd15                	beqz	a0,80001a2e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    800019f4:	8526                	mv	a0,s1
    800019f6:	e99ff0ef          	jal	ra,8000188e <proc_pagetable>
    800019fa:	892a                	mv	s2,a0
    800019fc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800019fe:	c121                	beqz	a0,80001a3e <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001a00:	07000613          	li	a2,112
    80001a04:	4581                	li	a1,0
    80001a06:	06048513          	addi	a0,s1,96
    80001a0a:	a64ff0ef          	jal	ra,80000c6e <memset>
  p->context.ra = (uint64)forkret;
    80001a0e:	00000797          	auipc	a5,0x0
    80001a12:	e0878793          	addi	a5,a5,-504 # 80001816 <forkret>
    80001a16:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a18:	60bc                	ld	a5,64(s1)
    80001a1a:	6705                	lui	a4,0x1
    80001a1c:	97ba                	add	a5,a5,a4
    80001a1e:	f4bc                	sd	a5,104(s1)
}
    80001a20:	8526                	mv	a0,s1
    80001a22:	60e2                	ld	ra,24(sp)
    80001a24:	6442                	ld	s0,16(sp)
    80001a26:	64a2                	ld	s1,8(sp)
    80001a28:	6902                	ld	s2,0(sp)
    80001a2a:	6105                	addi	sp,sp,32
    80001a2c:	8082                	ret
    freeproc(p);
    80001a2e:	8526                	mv	a0,s1
    80001a30:	f29ff0ef          	jal	ra,80001958 <freeproc>
    release(&p->lock);
    80001a34:	8526                	mv	a0,s1
    80001a36:	9fcff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001a3a:	84ca                	mv	s1,s2
    80001a3c:	b7d5                	j	80001a20 <allocproc+0x78>
    freeproc(p);
    80001a3e:	8526                	mv	a0,s1
    80001a40:	f19ff0ef          	jal	ra,80001958 <freeproc>
    release(&p->lock);
    80001a44:	8526                	mv	a0,s1
    80001a46:	9ecff0ef          	jal	ra,80000c32 <release>
    return 0;
    80001a4a:	84ca                	mv	s1,s2
    80001a4c:	bfd1                	j	80001a20 <allocproc+0x78>

0000000080001a4e <userinit>:
{
    80001a4e:	1101                	addi	sp,sp,-32
    80001a50:	ec06                	sd	ra,24(sp)
    80001a52:	e822                	sd	s0,16(sp)
    80001a54:	e426                	sd	s1,8(sp)
    80001a56:	1000                	addi	s0,sp,32
  p = allocproc();
    80001a58:	f51ff0ef          	jal	ra,800019a8 <allocproc>
    80001a5c:	84aa                	mv	s1,a0
  initproc = p;
    80001a5e:	00006797          	auipc	a5,0x6
    80001a62:	eca7bd23          	sd	a0,-294(a5) # 80007938 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001a66:	03400613          	li	a2,52
    80001a6a:	00006597          	auipc	a1,0x6
    80001a6e:	e6658593          	addi	a1,a1,-410 # 800078d0 <initcode>
    80001a72:	6928                	ld	a0,80(a0)
    80001a74:	f80ff0ef          	jal	ra,800011f4 <uvmfirst>
  p->sz = PGSIZE;
    80001a78:	6785                	lui	a5,0x1
    80001a7a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001a7c:	6cb8                	ld	a4,88(s1)
    80001a7e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001a82:	6cb8                	ld	a4,88(s1)
    80001a84:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001a86:	4641                	li	a2,16
    80001a88:	00005597          	auipc	a1,0x5
    80001a8c:	7d858593          	addi	a1,a1,2008 # 80007260 <digits+0x228>
    80001a90:	15848513          	addi	a0,s1,344
    80001a94:	b20ff0ef          	jal	ra,80000db4 <safestrcpy>
  p->cwd = namei("/");
    80001a98:	00005517          	auipc	a0,0x5
    80001a9c:	7d850513          	addi	a0,a0,2008 # 80007270 <digits+0x238>
    80001aa0:	571010ef          	jal	ra,80003810 <namei>
    80001aa4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001aa8:	478d                	li	a5,3
    80001aaa:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001aac:	8526                	mv	a0,s1
    80001aae:	984ff0ef          	jal	ra,80000c32 <release>
}
    80001ab2:	60e2                	ld	ra,24(sp)
    80001ab4:	6442                	ld	s0,16(sp)
    80001ab6:	64a2                	ld	s1,8(sp)
    80001ab8:	6105                	addi	sp,sp,32
    80001aba:	8082                	ret

0000000080001abc <growproc>:
{
    80001abc:	1101                	addi	sp,sp,-32
    80001abe:	ec06                	sd	ra,24(sp)
    80001ac0:	e822                	sd	s0,16(sp)
    80001ac2:	e426                	sd	s1,8(sp)
    80001ac4:	e04a                	sd	s2,0(sp)
    80001ac6:	1000                	addi	s0,sp,32
    80001ac8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001aca:	d1dff0ef          	jal	ra,800017e6 <myproc>
    80001ace:	84aa                	mv	s1,a0
  sz = p->sz;
    80001ad0:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001ad2:	01204c63          	bgtz	s2,80001aea <growproc+0x2e>
  } else if(n < 0){
    80001ad6:	02094463          	bltz	s2,80001afe <growproc+0x42>
  p->sz = sz;
    80001ada:	e4ac                	sd	a1,72(s1)
  return 0;
    80001adc:	4501                	li	a0,0
}
    80001ade:	60e2                	ld	ra,24(sp)
    80001ae0:	6442                	ld	s0,16(sp)
    80001ae2:	64a2                	ld	s1,8(sp)
    80001ae4:	6902                	ld	s2,0(sp)
    80001ae6:	6105                	addi	sp,sp,32
    80001ae8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001aea:	4691                	li	a3,4
    80001aec:	00b90633          	add	a2,s2,a1
    80001af0:	6928                	ld	a0,80(a0)
    80001af2:	fa4ff0ef          	jal	ra,80001296 <uvmalloc>
    80001af6:	85aa                	mv	a1,a0
    80001af8:	f16d                	bnez	a0,80001ada <growproc+0x1e>
      return -1;
    80001afa:	557d                	li	a0,-1
    80001afc:	b7cd                	j	80001ade <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001afe:	00b90633          	add	a2,s2,a1
    80001b02:	6928                	ld	a0,80(a0)
    80001b04:	f4eff0ef          	jal	ra,80001252 <uvmdealloc>
    80001b08:	85aa                	mv	a1,a0
    80001b0a:	bfc1                	j	80001ada <growproc+0x1e>

0000000080001b0c <fork>:
{
    80001b0c:	7139                	addi	sp,sp,-64
    80001b0e:	fc06                	sd	ra,56(sp)
    80001b10:	f822                	sd	s0,48(sp)
    80001b12:	f426                	sd	s1,40(sp)
    80001b14:	f04a                	sd	s2,32(sp)
    80001b16:	ec4e                	sd	s3,24(sp)
    80001b18:	e852                	sd	s4,16(sp)
    80001b1a:	e456                	sd	s5,8(sp)
    80001b1c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001b1e:	cc9ff0ef          	jal	ra,800017e6 <myproc>
    80001b22:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b24:	e85ff0ef          	jal	ra,800019a8 <allocproc>
    80001b28:	0e050663          	beqz	a0,80001c14 <fork+0x108>
    80001b2c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b2e:	048ab603          	ld	a2,72(s5)
    80001b32:	692c                	ld	a1,80(a0)
    80001b34:	050ab503          	ld	a0,80(s5)
    80001b38:	887ff0ef          	jal	ra,800013be <uvmcopy>
    80001b3c:	04054863          	bltz	a0,80001b8c <fork+0x80>
  np->sz = p->sz;
    80001b40:	048ab783          	ld	a5,72(s5)
    80001b44:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001b48:	058ab683          	ld	a3,88(s5)
    80001b4c:	87b6                	mv	a5,a3
    80001b4e:	058a3703          	ld	a4,88(s4)
    80001b52:	12068693          	addi	a3,a3,288
    80001b56:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001b5a:	6788                	ld	a0,8(a5)
    80001b5c:	6b8c                	ld	a1,16(a5)
    80001b5e:	6f90                	ld	a2,24(a5)
    80001b60:	01073023          	sd	a6,0(a4)
    80001b64:	e708                	sd	a0,8(a4)
    80001b66:	eb0c                	sd	a1,16(a4)
    80001b68:	ef10                	sd	a2,24(a4)
    80001b6a:	02078793          	addi	a5,a5,32
    80001b6e:	02070713          	addi	a4,a4,32
    80001b72:	fed792e3          	bne	a5,a3,80001b56 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001b76:	058a3783          	ld	a5,88(s4)
    80001b7a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001b7e:	0d0a8493          	addi	s1,s5,208
    80001b82:	0d0a0913          	addi	s2,s4,208
    80001b86:	150a8993          	addi	s3,s5,336
    80001b8a:	a829                	j	80001ba4 <fork+0x98>
    freeproc(np);
    80001b8c:	8552                	mv	a0,s4
    80001b8e:	dcbff0ef          	jal	ra,80001958 <freeproc>
    release(&np->lock);
    80001b92:	8552                	mv	a0,s4
    80001b94:	89eff0ef          	jal	ra,80000c32 <release>
    return -1;
    80001b98:	597d                	li	s2,-1
    80001b9a:	a09d                	j	80001c00 <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001b9c:	04a1                	addi	s1,s1,8
    80001b9e:	0921                	addi	s2,s2,8
    80001ba0:	01348963          	beq	s1,s3,80001bb2 <fork+0xa6>
    if(p->ofile[i])
    80001ba4:	6088                	ld	a0,0(s1)
    80001ba6:	d97d                	beqz	a0,80001b9c <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ba8:	216020ef          	jal	ra,80003dbe <filedup>
    80001bac:	00a93023          	sd	a0,0(s2)
    80001bb0:	b7f5                	j	80001b9c <fork+0x90>
  np->cwd = idup(p->cwd);
    80001bb2:	150ab503          	ld	a0,336(s5)
    80001bb6:	572010ef          	jal	ra,80003128 <idup>
    80001bba:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001bbe:	4641                	li	a2,16
    80001bc0:	158a8593          	addi	a1,s5,344
    80001bc4:	158a0513          	addi	a0,s4,344
    80001bc8:	9ecff0ef          	jal	ra,80000db4 <safestrcpy>
  pid = np->pid;
    80001bcc:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001bd0:	8552                	mv	a0,s4
    80001bd2:	860ff0ef          	jal	ra,80000c32 <release>
  acquire(&wait_lock);
    80001bd6:	0000e497          	auipc	s1,0xe
    80001bda:	eb248493          	addi	s1,s1,-334 # 8000fa88 <wait_lock>
    80001bde:	8526                	mv	a0,s1
    80001be0:	fbbfe0ef          	jal	ra,80000b9a <acquire>
  np->parent = p;
    80001be4:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001be8:	8526                	mv	a0,s1
    80001bea:	848ff0ef          	jal	ra,80000c32 <release>
  acquire(&np->lock);
    80001bee:	8552                	mv	a0,s4
    80001bf0:	fabfe0ef          	jal	ra,80000b9a <acquire>
  np->state = RUNNABLE;
    80001bf4:	478d                	li	a5,3
    80001bf6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001bfa:	8552                	mv	a0,s4
    80001bfc:	836ff0ef          	jal	ra,80000c32 <release>
}
    80001c00:	854a                	mv	a0,s2
    80001c02:	70e2                	ld	ra,56(sp)
    80001c04:	7442                	ld	s0,48(sp)
    80001c06:	74a2                	ld	s1,40(sp)
    80001c08:	7902                	ld	s2,32(sp)
    80001c0a:	69e2                	ld	s3,24(sp)
    80001c0c:	6a42                	ld	s4,16(sp)
    80001c0e:	6aa2                	ld	s5,8(sp)
    80001c10:	6121                	addi	sp,sp,64
    80001c12:	8082                	ret
    return -1;
    80001c14:	597d                	li	s2,-1
    80001c16:	b7ed                	j	80001c00 <fork+0xf4>

0000000080001c18 <scheduler>:
{
    80001c18:	715d                	addi	sp,sp,-80
    80001c1a:	e486                	sd	ra,72(sp)
    80001c1c:	e0a2                	sd	s0,64(sp)
    80001c1e:	fc26                	sd	s1,56(sp)
    80001c20:	f84a                	sd	s2,48(sp)
    80001c22:	f44e                	sd	s3,40(sp)
    80001c24:	f052                	sd	s4,32(sp)
    80001c26:	ec56                	sd	s5,24(sp)
    80001c28:	e85a                	sd	s6,16(sp)
    80001c2a:	e45e                	sd	s7,8(sp)
    80001c2c:	e062                	sd	s8,0(sp)
    80001c2e:	0880                	addi	s0,sp,80
    80001c30:	8792                	mv	a5,tp
  int id = r_tp();
    80001c32:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c34:	00779b13          	slli	s6,a5,0x7
    80001c38:	0000e717          	auipc	a4,0xe
    80001c3c:	e3870713          	addi	a4,a4,-456 # 8000fa70 <pid_lock>
    80001c40:	975a                	add	a4,a4,s6
    80001c42:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c46:	0000e717          	auipc	a4,0xe
    80001c4a:	e6270713          	addi	a4,a4,-414 # 8000faa8 <cpus+0x8>
    80001c4e:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001c50:	4c11                	li	s8,4
        c->proc = p;
    80001c52:	079e                	slli	a5,a5,0x7
    80001c54:	0000ea17          	auipc	s4,0xe
    80001c58:	e1ca0a13          	addi	s4,s4,-484 # 8000fa70 <pid_lock>
    80001c5c:	9a3e                	add	s4,s4,a5
        found = 1;
    80001c5e:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001c60:	00014997          	auipc	s3,0x14
    80001c64:	c4098993          	addi	s3,s3,-960 # 800158a0 <tickslock>
    80001c68:	a0a9                	j	80001cb2 <scheduler+0x9a>
      release(&p->lock);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	fc7fe0ef          	jal	ra,80000c32 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001c70:	16848493          	addi	s1,s1,360
    80001c74:	03348563          	beq	s1,s3,80001c9e <scheduler+0x86>
      acquire(&p->lock);
    80001c78:	8526                	mv	a0,s1
    80001c7a:	f21fe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == RUNNABLE) {
    80001c7e:	4c9c                	lw	a5,24(s1)
    80001c80:	ff2795e3          	bne	a5,s2,80001c6a <scheduler+0x52>
        p->state = RUNNING;
    80001c84:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001c88:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001c8c:	06048593          	addi	a1,s1,96
    80001c90:	855a                	mv	a0,s6
    80001c92:	5b2000ef          	jal	ra,80002244 <swtch>
        c->proc = 0;
    80001c96:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001c9a:	8ade                	mv	s5,s7
    80001c9c:	b7f9                	j	80001c6a <scheduler+0x52>
    if(found == 0) {
    80001c9e:	000a9a63          	bnez	s5,80001cb2 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ca6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001caa:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001cae:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cb6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cba:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001cbe:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cc0:	0000e497          	auipc	s1,0xe
    80001cc4:	1e048493          	addi	s1,s1,480 # 8000fea0 <proc>
      if(p->state == RUNNABLE) {
    80001cc8:	490d                	li	s2,3
    80001cca:	b77d                	j	80001c78 <scheduler+0x60>

0000000080001ccc <sched>:
{
    80001ccc:	7179                	addi	sp,sp,-48
    80001cce:	f406                	sd	ra,40(sp)
    80001cd0:	f022                	sd	s0,32(sp)
    80001cd2:	ec26                	sd	s1,24(sp)
    80001cd4:	e84a                	sd	s2,16(sp)
    80001cd6:	e44e                	sd	s3,8(sp)
    80001cd8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001cda:	b0dff0ef          	jal	ra,800017e6 <myproc>
    80001cde:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ce0:	e51fe0ef          	jal	ra,80000b30 <holding>
    80001ce4:	c92d                	beqz	a0,80001d56 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ce6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ce8:	2781                	sext.w	a5,a5
    80001cea:	079e                	slli	a5,a5,0x7
    80001cec:	0000e717          	auipc	a4,0xe
    80001cf0:	d8470713          	addi	a4,a4,-636 # 8000fa70 <pid_lock>
    80001cf4:	97ba                	add	a5,a5,a4
    80001cf6:	0a87a703          	lw	a4,168(a5)
    80001cfa:	4785                	li	a5,1
    80001cfc:	06f71363          	bne	a4,a5,80001d62 <sched+0x96>
  if(p->state == RUNNING)
    80001d00:	4c98                	lw	a4,24(s1)
    80001d02:	4791                	li	a5,4
    80001d04:	06f70563          	beq	a4,a5,80001d6e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d0c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001d0e:	e7b5                	bnez	a5,80001d7a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d10:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d12:	0000e917          	auipc	s2,0xe
    80001d16:	d5e90913          	addi	s2,s2,-674 # 8000fa70 <pid_lock>
    80001d1a:	2781                	sext.w	a5,a5
    80001d1c:	079e                	slli	a5,a5,0x7
    80001d1e:	97ca                	add	a5,a5,s2
    80001d20:	0ac7a983          	lw	s3,172(a5)
    80001d24:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d26:	2781                	sext.w	a5,a5
    80001d28:	079e                	slli	a5,a5,0x7
    80001d2a:	0000e597          	auipc	a1,0xe
    80001d2e:	d7e58593          	addi	a1,a1,-642 # 8000faa8 <cpus+0x8>
    80001d32:	95be                	add	a1,a1,a5
    80001d34:	06048513          	addi	a0,s1,96
    80001d38:	50c000ef          	jal	ra,80002244 <swtch>
    80001d3c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001d3e:	2781                	sext.w	a5,a5
    80001d40:	079e                	slli	a5,a5,0x7
    80001d42:	97ca                	add	a5,a5,s2
    80001d44:	0b37a623          	sw	s3,172(a5)
}
    80001d48:	70a2                	ld	ra,40(sp)
    80001d4a:	7402                	ld	s0,32(sp)
    80001d4c:	64e2                	ld	s1,24(sp)
    80001d4e:	6942                	ld	s2,16(sp)
    80001d50:	69a2                	ld	s3,8(sp)
    80001d52:	6145                	addi	sp,sp,48
    80001d54:	8082                	ret
    panic("sched p->lock");
    80001d56:	00005517          	auipc	a0,0x5
    80001d5a:	52250513          	addi	a0,a0,1314 # 80007278 <digits+0x240>
    80001d5e:	9f9fe0ef          	jal	ra,80000756 <panic>
    panic("sched locks");
    80001d62:	00005517          	auipc	a0,0x5
    80001d66:	52650513          	addi	a0,a0,1318 # 80007288 <digits+0x250>
    80001d6a:	9edfe0ef          	jal	ra,80000756 <panic>
    panic("sched running");
    80001d6e:	00005517          	auipc	a0,0x5
    80001d72:	52a50513          	addi	a0,a0,1322 # 80007298 <digits+0x260>
    80001d76:	9e1fe0ef          	jal	ra,80000756 <panic>
    panic("sched interruptible");
    80001d7a:	00005517          	auipc	a0,0x5
    80001d7e:	52e50513          	addi	a0,a0,1326 # 800072a8 <digits+0x270>
    80001d82:	9d5fe0ef          	jal	ra,80000756 <panic>

0000000080001d86 <yield>:
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	e426                	sd	s1,8(sp)
    80001d8e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001d90:	a57ff0ef          	jal	ra,800017e6 <myproc>
    80001d94:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001d96:	e05fe0ef          	jal	ra,80000b9a <acquire>
  p->state = RUNNABLE;
    80001d9a:	478d                	li	a5,3
    80001d9c:	cc9c                	sw	a5,24(s1)
  sched();
    80001d9e:	f2fff0ef          	jal	ra,80001ccc <sched>
  release(&p->lock);
    80001da2:	8526                	mv	a0,s1
    80001da4:	e8ffe0ef          	jal	ra,80000c32 <release>
}
    80001da8:	60e2                	ld	ra,24(sp)
    80001daa:	6442                	ld	s0,16(sp)
    80001dac:	64a2                	ld	s1,8(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001db2:	7179                	addi	sp,sp,-48
    80001db4:	f406                	sd	ra,40(sp)
    80001db6:	f022                	sd	s0,32(sp)
    80001db8:	ec26                	sd	s1,24(sp)
    80001dba:	e84a                	sd	s2,16(sp)
    80001dbc:	e44e                	sd	s3,8(sp)
    80001dbe:	1800                	addi	s0,sp,48
    80001dc0:	89aa                	mv	s3,a0
    80001dc2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001dc4:	a23ff0ef          	jal	ra,800017e6 <myproc>
    80001dc8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001dca:	dd1fe0ef          	jal	ra,80000b9a <acquire>
  release(lk);
    80001dce:	854a                	mv	a0,s2
    80001dd0:	e63fe0ef          	jal	ra,80000c32 <release>

  // Go to sleep.
  p->chan = chan;
    80001dd4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001dd8:	4789                	li	a5,2
    80001dda:	cc9c                	sw	a5,24(s1)

  sched();
    80001ddc:	ef1ff0ef          	jal	ra,80001ccc <sched>

  // Tidy up.
  p->chan = 0;
    80001de0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001de4:	8526                	mv	a0,s1
    80001de6:	e4dfe0ef          	jal	ra,80000c32 <release>
  acquire(lk);
    80001dea:	854a                	mv	a0,s2
    80001dec:	daffe0ef          	jal	ra,80000b9a <acquire>
}
    80001df0:	70a2                	ld	ra,40(sp)
    80001df2:	7402                	ld	s0,32(sp)
    80001df4:	64e2                	ld	s1,24(sp)
    80001df6:	6942                	ld	s2,16(sp)
    80001df8:	69a2                	ld	s3,8(sp)
    80001dfa:	6145                	addi	sp,sp,48
    80001dfc:	8082                	ret

0000000080001dfe <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001dfe:	7139                	addi	sp,sp,-64
    80001e00:	fc06                	sd	ra,56(sp)
    80001e02:	f822                	sd	s0,48(sp)
    80001e04:	f426                	sd	s1,40(sp)
    80001e06:	f04a                	sd	s2,32(sp)
    80001e08:	ec4e                	sd	s3,24(sp)
    80001e0a:	e852                	sd	s4,16(sp)
    80001e0c:	e456                	sd	s5,8(sp)
    80001e0e:	0080                	addi	s0,sp,64
    80001e10:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e12:	0000e497          	auipc	s1,0xe
    80001e16:	08e48493          	addi	s1,s1,142 # 8000fea0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e1a:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e1c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e1e:	00014917          	auipc	s2,0x14
    80001e22:	a8290913          	addi	s2,s2,-1406 # 800158a0 <tickslock>
    80001e26:	a801                	j	80001e36 <wakeup+0x38>
      }
      release(&p->lock);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	e09fe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e2e:	16848493          	addi	s1,s1,360
    80001e32:	03248263          	beq	s1,s2,80001e56 <wakeup+0x58>
    if(p != myproc()){
    80001e36:	9b1ff0ef          	jal	ra,800017e6 <myproc>
    80001e3a:	fea48ae3          	beq	s1,a0,80001e2e <wakeup+0x30>
      acquire(&p->lock);
    80001e3e:	8526                	mv	a0,s1
    80001e40:	d5bfe0ef          	jal	ra,80000b9a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001e44:	4c9c                	lw	a5,24(s1)
    80001e46:	ff3791e3          	bne	a5,s3,80001e28 <wakeup+0x2a>
    80001e4a:	709c                	ld	a5,32(s1)
    80001e4c:	fd479ee3          	bne	a5,s4,80001e28 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001e50:	0154ac23          	sw	s5,24(s1)
    80001e54:	bfd1                	j	80001e28 <wakeup+0x2a>
    }
  }
}
    80001e56:	70e2                	ld	ra,56(sp)
    80001e58:	7442                	ld	s0,48(sp)
    80001e5a:	74a2                	ld	s1,40(sp)
    80001e5c:	7902                	ld	s2,32(sp)
    80001e5e:	69e2                	ld	s3,24(sp)
    80001e60:	6a42                	ld	s4,16(sp)
    80001e62:	6aa2                	ld	s5,8(sp)
    80001e64:	6121                	addi	sp,sp,64
    80001e66:	8082                	ret

0000000080001e68 <reparent>:
{
    80001e68:	7179                	addi	sp,sp,-48
    80001e6a:	f406                	sd	ra,40(sp)
    80001e6c:	f022                	sd	s0,32(sp)
    80001e6e:	ec26                	sd	s1,24(sp)
    80001e70:	e84a                	sd	s2,16(sp)
    80001e72:	e44e                	sd	s3,8(sp)
    80001e74:	e052                	sd	s4,0(sp)
    80001e76:	1800                	addi	s0,sp,48
    80001e78:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e7a:	0000e497          	auipc	s1,0xe
    80001e7e:	02648493          	addi	s1,s1,38 # 8000fea0 <proc>
      pp->parent = initproc;
    80001e82:	00006a17          	auipc	s4,0x6
    80001e86:	ab6a0a13          	addi	s4,s4,-1354 # 80007938 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e8a:	00014997          	auipc	s3,0x14
    80001e8e:	a1698993          	addi	s3,s3,-1514 # 800158a0 <tickslock>
    80001e92:	a029                	j	80001e9c <reparent+0x34>
    80001e94:	16848493          	addi	s1,s1,360
    80001e98:	01348b63          	beq	s1,s3,80001eae <reparent+0x46>
    if(pp->parent == p){
    80001e9c:	7c9c                	ld	a5,56(s1)
    80001e9e:	ff279be3          	bne	a5,s2,80001e94 <reparent+0x2c>
      pp->parent = initproc;
    80001ea2:	000a3503          	ld	a0,0(s4)
    80001ea6:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001ea8:	f57ff0ef          	jal	ra,80001dfe <wakeup>
    80001eac:	b7e5                	j	80001e94 <reparent+0x2c>
}
    80001eae:	70a2                	ld	ra,40(sp)
    80001eb0:	7402                	ld	s0,32(sp)
    80001eb2:	64e2                	ld	s1,24(sp)
    80001eb4:	6942                	ld	s2,16(sp)
    80001eb6:	69a2                	ld	s3,8(sp)
    80001eb8:	6a02                	ld	s4,0(sp)
    80001eba:	6145                	addi	sp,sp,48
    80001ebc:	8082                	ret

0000000080001ebe <exit>:
{
    80001ebe:	7179                	addi	sp,sp,-48
    80001ec0:	f406                	sd	ra,40(sp)
    80001ec2:	f022                	sd	s0,32(sp)
    80001ec4:	ec26                	sd	s1,24(sp)
    80001ec6:	e84a                	sd	s2,16(sp)
    80001ec8:	e44e                	sd	s3,8(sp)
    80001eca:	e052                	sd	s4,0(sp)
    80001ecc:	1800                	addi	s0,sp,48
    80001ece:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ed0:	917ff0ef          	jal	ra,800017e6 <myproc>
    80001ed4:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ed6:	00006797          	auipc	a5,0x6
    80001eda:	a627b783          	ld	a5,-1438(a5) # 80007938 <initproc>
    80001ede:	0d050493          	addi	s1,a0,208
    80001ee2:	15050913          	addi	s2,a0,336
    80001ee6:	00a79f63          	bne	a5,a0,80001f04 <exit+0x46>
    panic("init exiting");
    80001eea:	00005517          	auipc	a0,0x5
    80001eee:	3d650513          	addi	a0,a0,982 # 800072c0 <digits+0x288>
    80001ef2:	865fe0ef          	jal	ra,80000756 <panic>
      fileclose(f);
    80001ef6:	70f010ef          	jal	ra,80003e04 <fileclose>
      p->ofile[fd] = 0;
    80001efa:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001efe:	04a1                	addi	s1,s1,8
    80001f00:	01248563          	beq	s1,s2,80001f0a <exit+0x4c>
    if(p->ofile[fd]){
    80001f04:	6088                	ld	a0,0(s1)
    80001f06:	f965                	bnez	a0,80001ef6 <exit+0x38>
    80001f08:	bfdd                	j	80001efe <exit+0x40>
  begin_op();
    80001f0a:	2df010ef          	jal	ra,800039e8 <begin_op>
  iput(p->cwd);
    80001f0e:	1509b503          	ld	a0,336(s3)
    80001f12:	3ca010ef          	jal	ra,800032dc <iput>
  end_op();
    80001f16:	343010ef          	jal	ra,80003a58 <end_op>
  p->cwd = 0;
    80001f1a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001f1e:	0000e497          	auipc	s1,0xe
    80001f22:	b6a48493          	addi	s1,s1,-1174 # 8000fa88 <wait_lock>
    80001f26:	8526                	mv	a0,s1
    80001f28:	c73fe0ef          	jal	ra,80000b9a <acquire>
  reparent(p);
    80001f2c:	854e                	mv	a0,s3
    80001f2e:	f3bff0ef          	jal	ra,80001e68 <reparent>
  wakeup(p->parent);
    80001f32:	0389b503          	ld	a0,56(s3)
    80001f36:	ec9ff0ef          	jal	ra,80001dfe <wakeup>
  acquire(&p->lock);
    80001f3a:	854e                	mv	a0,s3
    80001f3c:	c5ffe0ef          	jal	ra,80000b9a <acquire>
  p->xstate = status;
    80001f40:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001f44:	4795                	li	a5,5
    80001f46:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	ce7fe0ef          	jal	ra,80000c32 <release>
  sched();
    80001f50:	d7dff0ef          	jal	ra,80001ccc <sched>
  panic("zombie exit");
    80001f54:	00005517          	auipc	a0,0x5
    80001f58:	37c50513          	addi	a0,a0,892 # 800072d0 <digits+0x298>
    80001f5c:	ffafe0ef          	jal	ra,80000756 <panic>

0000000080001f60 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001f60:	7179                	addi	sp,sp,-48
    80001f62:	f406                	sd	ra,40(sp)
    80001f64:	f022                	sd	s0,32(sp)
    80001f66:	ec26                	sd	s1,24(sp)
    80001f68:	e84a                	sd	s2,16(sp)
    80001f6a:	e44e                	sd	s3,8(sp)
    80001f6c:	1800                	addi	s0,sp,48
    80001f6e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001f70:	0000e497          	auipc	s1,0xe
    80001f74:	f3048493          	addi	s1,s1,-208 # 8000fea0 <proc>
    80001f78:	00014997          	auipc	s3,0x14
    80001f7c:	92898993          	addi	s3,s3,-1752 # 800158a0 <tickslock>
    acquire(&p->lock);
    80001f80:	8526                	mv	a0,s1
    80001f82:	c19fe0ef          	jal	ra,80000b9a <acquire>
    if(p->pid == pid){
    80001f86:	589c                	lw	a5,48(s1)
    80001f88:	01278b63          	beq	a5,s2,80001f9e <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	ca5fe0ef          	jal	ra,80000c32 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001f92:	16848493          	addi	s1,s1,360
    80001f96:	ff3495e3          	bne	s1,s3,80001f80 <kill+0x20>
  }
  return -1;
    80001f9a:	557d                	li	a0,-1
    80001f9c:	a819                	j	80001fb2 <kill+0x52>
      p->killed = 1;
    80001f9e:	4785                	li	a5,1
    80001fa0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001fa2:	4c98                	lw	a4,24(s1)
    80001fa4:	4789                	li	a5,2
    80001fa6:	00f70d63          	beq	a4,a5,80001fc0 <kill+0x60>
      release(&p->lock);
    80001faa:	8526                	mv	a0,s1
    80001fac:	c87fe0ef          	jal	ra,80000c32 <release>
      return 0;
    80001fb0:	4501                	li	a0,0
}
    80001fb2:	70a2                	ld	ra,40(sp)
    80001fb4:	7402                	ld	s0,32(sp)
    80001fb6:	64e2                	ld	s1,24(sp)
    80001fb8:	6942                	ld	s2,16(sp)
    80001fba:	69a2                	ld	s3,8(sp)
    80001fbc:	6145                	addi	sp,sp,48
    80001fbe:	8082                	ret
        p->state = RUNNABLE;
    80001fc0:	478d                	li	a5,3
    80001fc2:	cc9c                	sw	a5,24(s1)
    80001fc4:	b7dd                	j	80001faa <kill+0x4a>

0000000080001fc6 <setkilled>:

void
setkilled(struct proc *p)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
    80001fd0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fd2:	bc9fe0ef          	jal	ra,80000b9a <acquire>
  p->killed = 1;
    80001fd6:	4785                	li	a5,1
    80001fd8:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001fda:	8526                	mv	a0,s1
    80001fdc:	c57fe0ef          	jal	ra,80000c32 <release>
}
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret

0000000080001fea <killed>:

int
killed(struct proc *p)
{
    80001fea:	1101                	addi	sp,sp,-32
    80001fec:	ec06                	sd	ra,24(sp)
    80001fee:	e822                	sd	s0,16(sp)
    80001ff0:	e426                	sd	s1,8(sp)
    80001ff2:	e04a                	sd	s2,0(sp)
    80001ff4:	1000                	addi	s0,sp,32
    80001ff6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001ff8:	ba3fe0ef          	jal	ra,80000b9a <acquire>
  k = p->killed;
    80001ffc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002000:	8526                	mv	a0,s1
    80002002:	c31fe0ef          	jal	ra,80000c32 <release>
  return k;
}
    80002006:	854a                	mv	a0,s2
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6902                	ld	s2,0(sp)
    80002010:	6105                	addi	sp,sp,32
    80002012:	8082                	ret

0000000080002014 <wait>:
{
    80002014:	715d                	addi	sp,sp,-80
    80002016:	e486                	sd	ra,72(sp)
    80002018:	e0a2                	sd	s0,64(sp)
    8000201a:	fc26                	sd	s1,56(sp)
    8000201c:	f84a                	sd	s2,48(sp)
    8000201e:	f44e                	sd	s3,40(sp)
    80002020:	f052                	sd	s4,32(sp)
    80002022:	ec56                	sd	s5,24(sp)
    80002024:	e85a                	sd	s6,16(sp)
    80002026:	e45e                	sd	s7,8(sp)
    80002028:	e062                	sd	s8,0(sp)
    8000202a:	0880                	addi	s0,sp,80
    8000202c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000202e:	fb8ff0ef          	jal	ra,800017e6 <myproc>
    80002032:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002034:	0000e517          	auipc	a0,0xe
    80002038:	a5450513          	addi	a0,a0,-1452 # 8000fa88 <wait_lock>
    8000203c:	b5ffe0ef          	jal	ra,80000b9a <acquire>
    havekids = 0;
    80002040:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002042:	4a15                	li	s4,5
        havekids = 1;
    80002044:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002046:	00014997          	auipc	s3,0x14
    8000204a:	85a98993          	addi	s3,s3,-1958 # 800158a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000204e:	0000ec17          	auipc	s8,0xe
    80002052:	a3ac0c13          	addi	s8,s8,-1478 # 8000fa88 <wait_lock>
    havekids = 0;
    80002056:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002058:	0000e497          	auipc	s1,0xe
    8000205c:	e4848493          	addi	s1,s1,-440 # 8000fea0 <proc>
    80002060:	a899                	j	800020b6 <wait+0xa2>
          pid = pp->pid;
    80002062:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002066:	000b0c63          	beqz	s6,8000207e <wait+0x6a>
    8000206a:	4691                	li	a3,4
    8000206c:	02c48613          	addi	a2,s1,44
    80002070:	85da                	mv	a1,s6
    80002072:	05093503          	ld	a0,80(s2)
    80002076:	c24ff0ef          	jal	ra,8000149a <copyout>
    8000207a:	00054f63          	bltz	a0,80002098 <wait+0x84>
          freeproc(pp);
    8000207e:	8526                	mv	a0,s1
    80002080:	8d9ff0ef          	jal	ra,80001958 <freeproc>
          release(&pp->lock);
    80002084:	8526                	mv	a0,s1
    80002086:	badfe0ef          	jal	ra,80000c32 <release>
          release(&wait_lock);
    8000208a:	0000e517          	auipc	a0,0xe
    8000208e:	9fe50513          	addi	a0,a0,-1538 # 8000fa88 <wait_lock>
    80002092:	ba1fe0ef          	jal	ra,80000c32 <release>
          return pid;
    80002096:	a891                	j	800020ea <wait+0xd6>
            release(&pp->lock);
    80002098:	8526                	mv	a0,s1
    8000209a:	b99fe0ef          	jal	ra,80000c32 <release>
            release(&wait_lock);
    8000209e:	0000e517          	auipc	a0,0xe
    800020a2:	9ea50513          	addi	a0,a0,-1558 # 8000fa88 <wait_lock>
    800020a6:	b8dfe0ef          	jal	ra,80000c32 <release>
            return -1;
    800020aa:	59fd                	li	s3,-1
    800020ac:	a83d                	j	800020ea <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020ae:	16848493          	addi	s1,s1,360
    800020b2:	03348063          	beq	s1,s3,800020d2 <wait+0xbe>
      if(pp->parent == p){
    800020b6:	7c9c                	ld	a5,56(s1)
    800020b8:	ff279be3          	bne	a5,s2,800020ae <wait+0x9a>
        acquire(&pp->lock);
    800020bc:	8526                	mv	a0,s1
    800020be:	addfe0ef          	jal	ra,80000b9a <acquire>
        if(pp->state == ZOMBIE){
    800020c2:	4c9c                	lw	a5,24(s1)
    800020c4:	f9478fe3          	beq	a5,s4,80002062 <wait+0x4e>
        release(&pp->lock);
    800020c8:	8526                	mv	a0,s1
    800020ca:	b69fe0ef          	jal	ra,80000c32 <release>
        havekids = 1;
    800020ce:	8756                	mv	a4,s5
    800020d0:	bff9                	j	800020ae <wait+0x9a>
    if(!havekids || killed(p)){
    800020d2:	c709                	beqz	a4,800020dc <wait+0xc8>
    800020d4:	854a                	mv	a0,s2
    800020d6:	f15ff0ef          	jal	ra,80001fea <killed>
    800020da:	c50d                	beqz	a0,80002104 <wait+0xf0>
      release(&wait_lock);
    800020dc:	0000e517          	auipc	a0,0xe
    800020e0:	9ac50513          	addi	a0,a0,-1620 # 8000fa88 <wait_lock>
    800020e4:	b4ffe0ef          	jal	ra,80000c32 <release>
      return -1;
    800020e8:	59fd                	li	s3,-1
}
    800020ea:	854e                	mv	a0,s3
    800020ec:	60a6                	ld	ra,72(sp)
    800020ee:	6406                	ld	s0,64(sp)
    800020f0:	74e2                	ld	s1,56(sp)
    800020f2:	7942                	ld	s2,48(sp)
    800020f4:	79a2                	ld	s3,40(sp)
    800020f6:	7a02                	ld	s4,32(sp)
    800020f8:	6ae2                	ld	s5,24(sp)
    800020fa:	6b42                	ld	s6,16(sp)
    800020fc:	6ba2                	ld	s7,8(sp)
    800020fe:	6c02                	ld	s8,0(sp)
    80002100:	6161                	addi	sp,sp,80
    80002102:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002104:	85e2                	mv	a1,s8
    80002106:	854a                	mv	a0,s2
    80002108:	cabff0ef          	jal	ra,80001db2 <sleep>
    havekids = 0;
    8000210c:	b7a9                	j	80002056 <wait+0x42>

000000008000210e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000210e:	7179                	addi	sp,sp,-48
    80002110:	f406                	sd	ra,40(sp)
    80002112:	f022                	sd	s0,32(sp)
    80002114:	ec26                	sd	s1,24(sp)
    80002116:	e84a                	sd	s2,16(sp)
    80002118:	e44e                	sd	s3,8(sp)
    8000211a:	e052                	sd	s4,0(sp)
    8000211c:	1800                	addi	s0,sp,48
    8000211e:	84aa                	mv	s1,a0
    80002120:	892e                	mv	s2,a1
    80002122:	89b2                	mv	s3,a2
    80002124:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002126:	ec0ff0ef          	jal	ra,800017e6 <myproc>
  if(user_dst){
    8000212a:	cc99                	beqz	s1,80002148 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000212c:	86d2                	mv	a3,s4
    8000212e:	864e                	mv	a2,s3
    80002130:	85ca                	mv	a1,s2
    80002132:	6928                	ld	a0,80(a0)
    80002134:	b66ff0ef          	jal	ra,8000149a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002138:	70a2                	ld	ra,40(sp)
    8000213a:	7402                	ld	s0,32(sp)
    8000213c:	64e2                	ld	s1,24(sp)
    8000213e:	6942                	ld	s2,16(sp)
    80002140:	69a2                	ld	s3,8(sp)
    80002142:	6a02                	ld	s4,0(sp)
    80002144:	6145                	addi	sp,sp,48
    80002146:	8082                	ret
    memmove((char *)dst, src, len);
    80002148:	000a061b          	sext.w	a2,s4
    8000214c:	85ce                	mv	a1,s3
    8000214e:	854a                	mv	a0,s2
    80002150:	b7bfe0ef          	jal	ra,80000cca <memmove>
    return 0;
    80002154:	8526                	mv	a0,s1
    80002156:	b7cd                	j	80002138 <either_copyout+0x2a>

0000000080002158 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002158:	7179                	addi	sp,sp,-48
    8000215a:	f406                	sd	ra,40(sp)
    8000215c:	f022                	sd	s0,32(sp)
    8000215e:	ec26                	sd	s1,24(sp)
    80002160:	e84a                	sd	s2,16(sp)
    80002162:	e44e                	sd	s3,8(sp)
    80002164:	e052                	sd	s4,0(sp)
    80002166:	1800                	addi	s0,sp,48
    80002168:	892a                	mv	s2,a0
    8000216a:	84ae                	mv	s1,a1
    8000216c:	89b2                	mv	s3,a2
    8000216e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002170:	e76ff0ef          	jal	ra,800017e6 <myproc>
  if(user_src){
    80002174:	cc99                	beqz	s1,80002192 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002176:	86d2                	mv	a3,s4
    80002178:	864e                	mv	a2,s3
    8000217a:	85ca                	mv	a1,s2
    8000217c:	6928                	ld	a0,80(a0)
    8000217e:	bd4ff0ef          	jal	ra,80001552 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6942                	ld	s2,16(sp)
    8000218a:	69a2                	ld	s3,8(sp)
    8000218c:	6a02                	ld	s4,0(sp)
    8000218e:	6145                	addi	sp,sp,48
    80002190:	8082                	ret
    memmove(dst, (char*)src, len);
    80002192:	000a061b          	sext.w	a2,s4
    80002196:	85ce                	mv	a1,s3
    80002198:	854a                	mv	a0,s2
    8000219a:	b31fe0ef          	jal	ra,80000cca <memmove>
    return 0;
    8000219e:	8526                	mv	a0,s1
    800021a0:	b7cd                	j	80002182 <either_copyin+0x2a>

00000000800021a2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800021a2:	715d                	addi	sp,sp,-80
    800021a4:	e486                	sd	ra,72(sp)
    800021a6:	e0a2                	sd	s0,64(sp)
    800021a8:	fc26                	sd	s1,56(sp)
    800021aa:	f84a                	sd	s2,48(sp)
    800021ac:	f44e                	sd	s3,40(sp)
    800021ae:	f052                	sd	s4,32(sp)
    800021b0:	ec56                	sd	s5,24(sp)
    800021b2:	e85a                	sd	s6,16(sp)
    800021b4:	e45e                	sd	s7,8(sp)
    800021b6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800021b8:	00005517          	auipc	a0,0x5
    800021bc:	13050513          	addi	a0,a0,304 # 800072e8 <digits+0x2b0>
    800021c0:	ae2fe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800021c4:	0000e497          	auipc	s1,0xe
    800021c8:	e3448493          	addi	s1,s1,-460 # 8000fff8 <proc+0x158>
    800021cc:	00014917          	auipc	s2,0x14
    800021d0:	82c90913          	addi	s2,s2,-2004 # 800159f8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800021d4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800021d6:	00005997          	auipc	s3,0x5
    800021da:	10a98993          	addi	s3,s3,266 # 800072e0 <digits+0x2a8>
    printf("%d %s %s", p->pid, state, p->name);
    800021de:	00005a97          	auipc	s5,0x5
    800021e2:	112a8a93          	addi	s5,s5,274 # 800072f0 <digits+0x2b8>
    printf("\n");
    800021e6:	00005a17          	auipc	s4,0x5
    800021ea:	102a0a13          	addi	s4,s4,258 # 800072e8 <digits+0x2b0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800021ee:	00005b97          	auipc	s7,0x5
    800021f2:	142b8b93          	addi	s7,s7,322 # 80007330 <states.0>
    800021f6:	a829                	j	80002210 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800021f8:	ed86a583          	lw	a1,-296(a3)
    800021fc:	8556                	mv	a0,s5
    800021fe:	aa4fe0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80002202:	8552                	mv	a0,s4
    80002204:	a9efe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002208:	16848493          	addi	s1,s1,360
    8000220c:	03248163          	beq	s1,s2,8000222e <procdump+0x8c>
    if(p->state == UNUSED)
    80002210:	86a6                	mv	a3,s1
    80002212:	ec04a783          	lw	a5,-320(s1)
    80002216:	dbed                	beqz	a5,80002208 <procdump+0x66>
      state = "???";
    80002218:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000221a:	fcfb6fe3          	bltu	s6,a5,800021f8 <procdump+0x56>
    8000221e:	1782                	slli	a5,a5,0x20
    80002220:	9381                	srli	a5,a5,0x20
    80002222:	078e                	slli	a5,a5,0x3
    80002224:	97de                	add	a5,a5,s7
    80002226:	6390                	ld	a2,0(a5)
    80002228:	fa61                	bnez	a2,800021f8 <procdump+0x56>
      state = "???";
    8000222a:	864e                	mv	a2,s3
    8000222c:	b7f1                	j	800021f8 <procdump+0x56>
  }
}
    8000222e:	60a6                	ld	ra,72(sp)
    80002230:	6406                	ld	s0,64(sp)
    80002232:	74e2                	ld	s1,56(sp)
    80002234:	7942                	ld	s2,48(sp)
    80002236:	79a2                	ld	s3,40(sp)
    80002238:	7a02                	ld	s4,32(sp)
    8000223a:	6ae2                	ld	s5,24(sp)
    8000223c:	6b42                	ld	s6,16(sp)
    8000223e:	6ba2                	ld	s7,8(sp)
    80002240:	6161                	addi	sp,sp,80
    80002242:	8082                	ret

0000000080002244 <swtch>:
    80002244:	00153023          	sd	ra,0(a0)
    80002248:	00253423          	sd	sp,8(a0)
    8000224c:	e900                	sd	s0,16(a0)
    8000224e:	ed04                	sd	s1,24(a0)
    80002250:	03253023          	sd	s2,32(a0)
    80002254:	03353423          	sd	s3,40(a0)
    80002258:	03453823          	sd	s4,48(a0)
    8000225c:	03553c23          	sd	s5,56(a0)
    80002260:	05653023          	sd	s6,64(a0)
    80002264:	05753423          	sd	s7,72(a0)
    80002268:	05853823          	sd	s8,80(a0)
    8000226c:	05953c23          	sd	s9,88(a0)
    80002270:	07a53023          	sd	s10,96(a0)
    80002274:	07b53423          	sd	s11,104(a0)
    80002278:	0005b083          	ld	ra,0(a1)
    8000227c:	0085b103          	ld	sp,8(a1)
    80002280:	6980                	ld	s0,16(a1)
    80002282:	6d84                	ld	s1,24(a1)
    80002284:	0205b903          	ld	s2,32(a1)
    80002288:	0285b983          	ld	s3,40(a1)
    8000228c:	0305ba03          	ld	s4,48(a1)
    80002290:	0385ba83          	ld	s5,56(a1)
    80002294:	0405bb03          	ld	s6,64(a1)
    80002298:	0485bb83          	ld	s7,72(a1)
    8000229c:	0505bc03          	ld	s8,80(a1)
    800022a0:	0585bc83          	ld	s9,88(a1)
    800022a4:	0605bd03          	ld	s10,96(a1)
    800022a8:	0685bd83          	ld	s11,104(a1)
    800022ac:	8082                	ret

00000000800022ae <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800022ae:	1141                	addi	sp,sp,-16
    800022b0:	e406                	sd	ra,8(sp)
    800022b2:	e022                	sd	s0,0(sp)
    800022b4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800022b6:	00005597          	auipc	a1,0x5
    800022ba:	0aa58593          	addi	a1,a1,170 # 80007360 <states.0+0x30>
    800022be:	00013517          	auipc	a0,0x13
    800022c2:	5e250513          	addi	a0,a0,1506 # 800158a0 <tickslock>
    800022c6:	855fe0ef          	jal	ra,80000b1a <initlock>
}
    800022ca:	60a2                	ld	ra,8(sp)
    800022cc:	6402                	ld	s0,0(sp)
    800022ce:	0141                	addi	sp,sp,16
    800022d0:	8082                	ret

00000000800022d2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800022d2:	1141                	addi	sp,sp,-16
    800022d4:	e422                	sd	s0,8(sp)
    800022d6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800022d8:	00003797          	auipc	a5,0x3
    800022dc:	de878793          	addi	a5,a5,-536 # 800050c0 <kernelvec>
    800022e0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800022e4:	6422                	ld	s0,8(sp)
    800022e6:	0141                	addi	sp,sp,16
    800022e8:	8082                	ret

00000000800022ea <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800022ea:	1141                	addi	sp,sp,-16
    800022ec:	e406                	sd	ra,8(sp)
    800022ee:	e022                	sd	s0,0(sp)
    800022f0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800022f2:	cf4ff0ef          	jal	ra,800017e6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800022fa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800022fc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002300:	00004617          	auipc	a2,0x4
    80002304:	d0060613          	addi	a2,a2,-768 # 80006000 <_trampoline>
    80002308:	00004697          	auipc	a3,0x4
    8000230c:	cf868693          	addi	a3,a3,-776 # 80006000 <_trampoline>
    80002310:	8e91                	sub	a3,a3,a2
    80002312:	040007b7          	lui	a5,0x4000
    80002316:	17fd                	addi	a5,a5,-1
    80002318:	07b2                	slli	a5,a5,0xc
    8000231a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000231c:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002320:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002322:	180026f3          	csrr	a3,satp
    80002326:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002328:	6d38                	ld	a4,88(a0)
    8000232a:	6134                	ld	a3,64(a0)
    8000232c:	6585                	lui	a1,0x1
    8000232e:	96ae                	add	a3,a3,a1
    80002330:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002332:	6d38                	ld	a4,88(a0)
    80002334:	00000697          	auipc	a3,0x0
    80002338:	10c68693          	addi	a3,a3,268 # 80002440 <usertrap>
    8000233c:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000233e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002340:	8692                	mv	a3,tp
    80002342:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002344:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002348:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000234c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002350:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002354:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002356:	6f18                	ld	a4,24(a4)
    80002358:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000235c:	6928                	ld	a0,80(a0)
    8000235e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002360:	00004717          	auipc	a4,0x4
    80002364:	d3c70713          	addi	a4,a4,-708 # 8000609c <userret>
    80002368:	8f11                	sub	a4,a4,a2
    8000236a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000236c:	577d                	li	a4,-1
    8000236e:	177e                	slli	a4,a4,0x3f
    80002370:	8d59                	or	a0,a0,a4
    80002372:	9782                	jalr	a5
}
    80002374:	60a2                	ld	ra,8(sp)
    80002376:	6402                	ld	s0,0(sp)
    80002378:	0141                	addi	sp,sp,16
    8000237a:	8082                	ret

000000008000237c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000237c:	1101                	addi	sp,sp,-32
    8000237e:	ec06                	sd	ra,24(sp)
    80002380:	e822                	sd	s0,16(sp)
    80002382:	e426                	sd	s1,8(sp)
    80002384:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002386:	c34ff0ef          	jal	ra,800017ba <cpuid>
    8000238a:	cd19                	beqz	a0,800023a8 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000238c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002390:	000f4737          	lui	a4,0xf4
    80002394:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002398:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000239a:	14d79073          	csrw	0x14d,a5
}
    8000239e:	60e2                	ld	ra,24(sp)
    800023a0:	6442                	ld	s0,16(sp)
    800023a2:	64a2                	ld	s1,8(sp)
    800023a4:	6105                	addi	sp,sp,32
    800023a6:	8082                	ret
    acquire(&tickslock);
    800023a8:	00013497          	auipc	s1,0x13
    800023ac:	4f848493          	addi	s1,s1,1272 # 800158a0 <tickslock>
    800023b0:	8526                	mv	a0,s1
    800023b2:	fe8fe0ef          	jal	ra,80000b9a <acquire>
    ticks++;
    800023b6:	00005517          	auipc	a0,0x5
    800023ba:	58a50513          	addi	a0,a0,1418 # 80007940 <ticks>
    800023be:	411c                	lw	a5,0(a0)
    800023c0:	2785                	addiw	a5,a5,1
    800023c2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800023c4:	a3bff0ef          	jal	ra,80001dfe <wakeup>
    release(&tickslock);
    800023c8:	8526                	mv	a0,s1
    800023ca:	869fe0ef          	jal	ra,80000c32 <release>
    800023ce:	bf7d                	j	8000238c <clockintr+0x10>

00000000800023d0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800023d0:	1101                	addi	sp,sp,-32
    800023d2:	ec06                	sd	ra,24(sp)
    800023d4:	e822                	sd	s0,16(sp)
    800023d6:	e426                	sd	s1,8(sp)
    800023d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800023da:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800023de:	57fd                	li	a5,-1
    800023e0:	17fe                	slli	a5,a5,0x3f
    800023e2:	07a5                	addi	a5,a5,9
    800023e4:	00f70d63          	beq	a4,a5,800023fe <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800023e8:	57fd                	li	a5,-1
    800023ea:	17fe                	slli	a5,a5,0x3f
    800023ec:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800023ee:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800023f0:	04f70463          	beq	a4,a5,80002438 <devintr+0x68>
  }
}
    800023f4:	60e2                	ld	ra,24(sp)
    800023f6:	6442                	ld	s0,16(sp)
    800023f8:	64a2                	ld	s1,8(sp)
    800023fa:	6105                	addi	sp,sp,32
    800023fc:	8082                	ret
    int irq = plic_claim();
    800023fe:	56b020ef          	jal	ra,80005168 <plic_claim>
    80002402:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002404:	47a9                	li	a5,10
    80002406:	02f50363          	beq	a0,a5,8000242c <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000240a:	4785                	li	a5,1
    8000240c:	02f50363          	beq	a0,a5,80002432 <devintr+0x62>
    return 1;
    80002410:	4505                	li	a0,1
    } else if(irq){
    80002412:	d0ed                	beqz	s1,800023f4 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002414:	85a6                	mv	a1,s1
    80002416:	00005517          	auipc	a0,0x5
    8000241a:	f5250513          	addi	a0,a0,-174 # 80007368 <states.0+0x38>
    8000241e:	884fe0ef          	jal	ra,800004a2 <printf>
      plic_complete(irq);
    80002422:	8526                	mv	a0,s1
    80002424:	565020ef          	jal	ra,80005188 <plic_complete>
    return 1;
    80002428:	4505                	li	a0,1
    8000242a:	b7e9                	j	800023f4 <devintr+0x24>
      uartintr();
    8000242c:	d82fe0ef          	jal	ra,800009ae <uartintr>
    80002430:	bfcd                	j	80002422 <devintr+0x52>
      virtio_disk_intr();
    80002432:	1c6030ef          	jal	ra,800055f8 <virtio_disk_intr>
    80002436:	b7f5                	j	80002422 <devintr+0x52>
    clockintr();
    80002438:	f45ff0ef          	jal	ra,8000237c <clockintr>
    return 2;
    8000243c:	4509                	li	a0,2
    8000243e:	bf5d                	j	800023f4 <devintr+0x24>

0000000080002440 <usertrap>:
{
    80002440:	1101                	addi	sp,sp,-32
    80002442:	ec06                	sd	ra,24(sp)
    80002444:	e822                	sd	s0,16(sp)
    80002446:	e426                	sd	s1,8(sp)
    80002448:	e04a                	sd	s2,0(sp)
    8000244a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000244c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002450:	1007f793          	andi	a5,a5,256
    80002454:	ef85                	bnez	a5,8000248c <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002456:	00003797          	auipc	a5,0x3
    8000245a:	c6a78793          	addi	a5,a5,-918 # 800050c0 <kernelvec>
    8000245e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002462:	b84ff0ef          	jal	ra,800017e6 <myproc>
    80002466:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002468:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000246a:	14102773          	csrr	a4,sepc
    8000246e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002470:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002474:	47a1                	li	a5,8
    80002476:	02f70163          	beq	a4,a5,80002498 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000247a:	f57ff0ef          	jal	ra,800023d0 <devintr>
    8000247e:	892a                	mv	s2,a0
    80002480:	c135                	beqz	a0,800024e4 <usertrap+0xa4>
  if(killed(p))
    80002482:	8526                	mv	a0,s1
    80002484:	b67ff0ef          	jal	ra,80001fea <killed>
    80002488:	cd1d                	beqz	a0,800024c6 <usertrap+0x86>
    8000248a:	a81d                	j	800024c0 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000248c:	00005517          	auipc	a0,0x5
    80002490:	efc50513          	addi	a0,a0,-260 # 80007388 <states.0+0x58>
    80002494:	ac2fe0ef          	jal	ra,80000756 <panic>
    if(killed(p))
    80002498:	b53ff0ef          	jal	ra,80001fea <killed>
    8000249c:	e121                	bnez	a0,800024dc <usertrap+0x9c>
    p->trapframe->epc += 4;
    8000249e:	6cb8                	ld	a4,88(s1)
    800024a0:	6f1c                	ld	a5,24(a4)
    800024a2:	0791                	addi	a5,a5,4
    800024a4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800024aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024ae:	10079073          	csrw	sstatus,a5
    syscall();
    800024b2:	248000ef          	jal	ra,800026fa <syscall>
  if(killed(p))
    800024b6:	8526                	mv	a0,s1
    800024b8:	b33ff0ef          	jal	ra,80001fea <killed>
    800024bc:	c901                	beqz	a0,800024cc <usertrap+0x8c>
    800024be:	4901                	li	s2,0
    exit(-1);
    800024c0:	557d                	li	a0,-1
    800024c2:	9fdff0ef          	jal	ra,80001ebe <exit>
  if(which_dev == 2)
    800024c6:	4789                	li	a5,2
    800024c8:	04f90563          	beq	s2,a5,80002512 <usertrap+0xd2>
  usertrapret();
    800024cc:	e1fff0ef          	jal	ra,800022ea <usertrapret>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	64a2                	ld	s1,8(sp)
    800024d6:	6902                	ld	s2,0(sp)
    800024d8:	6105                	addi	sp,sp,32
    800024da:	8082                	ret
      exit(-1);
    800024dc:	557d                	li	a0,-1
    800024de:	9e1ff0ef          	jal	ra,80001ebe <exit>
    800024e2:	bf75                	j	8000249e <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024e4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800024e8:	5890                	lw	a2,48(s1)
    800024ea:	00005517          	auipc	a0,0x5
    800024ee:	ebe50513          	addi	a0,a0,-322 # 800073a8 <states.0+0x78>
    800024f2:	fb1fd0ef          	jal	ra,800004a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800024f6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800024fa:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800024fe:	00005517          	auipc	a0,0x5
    80002502:	eda50513          	addi	a0,a0,-294 # 800073d8 <states.0+0xa8>
    80002506:	f9dfd0ef          	jal	ra,800004a2 <printf>
    setkilled(p);
    8000250a:	8526                	mv	a0,s1
    8000250c:	abbff0ef          	jal	ra,80001fc6 <setkilled>
    80002510:	b75d                	j	800024b6 <usertrap+0x76>
    yield();
    80002512:	875ff0ef          	jal	ra,80001d86 <yield>
    80002516:	bf5d                	j	800024cc <usertrap+0x8c>

0000000080002518 <kerneltrap>:
{
    80002518:	7179                	addi	sp,sp,-48
    8000251a:	f406                	sd	ra,40(sp)
    8000251c:	f022                	sd	s0,32(sp)
    8000251e:	ec26                	sd	s1,24(sp)
    80002520:	e84a                	sd	s2,16(sp)
    80002522:	e44e                	sd	s3,8(sp)
    80002524:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002526:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000252a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000252e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002532:	1004f793          	andi	a5,s1,256
    80002536:	c795                	beqz	a5,80002562 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002538:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000253c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000253e:	eb85                	bnez	a5,8000256e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002540:	e91ff0ef          	jal	ra,800023d0 <devintr>
    80002544:	c91d                	beqz	a0,8000257a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002546:	4789                	li	a5,2
    80002548:	04f50a63          	beq	a0,a5,8000259c <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000254c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002550:	10049073          	csrw	sstatus,s1
}
    80002554:	70a2                	ld	ra,40(sp)
    80002556:	7402                	ld	s0,32(sp)
    80002558:	64e2                	ld	s1,24(sp)
    8000255a:	6942                	ld	s2,16(sp)
    8000255c:	69a2                	ld	s3,8(sp)
    8000255e:	6145                	addi	sp,sp,48
    80002560:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002562:	00005517          	auipc	a0,0x5
    80002566:	e9e50513          	addi	a0,a0,-354 # 80007400 <states.0+0xd0>
    8000256a:	9ecfe0ef          	jal	ra,80000756 <panic>
    panic("kerneltrap: interrupts enabled");
    8000256e:	00005517          	auipc	a0,0x5
    80002572:	eba50513          	addi	a0,a0,-326 # 80007428 <states.0+0xf8>
    80002576:	9e0fe0ef          	jal	ra,80000756 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000257a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000257e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002582:	85ce                	mv	a1,s3
    80002584:	00005517          	auipc	a0,0x5
    80002588:	ec450513          	addi	a0,a0,-316 # 80007448 <states.0+0x118>
    8000258c:	f17fd0ef          	jal	ra,800004a2 <printf>
    panic("kerneltrap");
    80002590:	00005517          	auipc	a0,0x5
    80002594:	ee050513          	addi	a0,a0,-288 # 80007470 <states.0+0x140>
    80002598:	9befe0ef          	jal	ra,80000756 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000259c:	a4aff0ef          	jal	ra,800017e6 <myproc>
    800025a0:	d555                	beqz	a0,8000254c <kerneltrap+0x34>
    yield();
    800025a2:	fe4ff0ef          	jal	ra,80001d86 <yield>
    800025a6:	b75d                	j	8000254c <kerneltrap+0x34>

00000000800025a8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	1000                	addi	s0,sp,32
    800025b2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800025b4:	a32ff0ef          	jal	ra,800017e6 <myproc>
  switch (n) {
    800025b8:	4795                	li	a5,5
    800025ba:	0497e163          	bltu	a5,s1,800025fc <argraw+0x54>
    800025be:	048a                	slli	s1,s1,0x2
    800025c0:	00005717          	auipc	a4,0x5
    800025c4:	ee870713          	addi	a4,a4,-280 # 800074a8 <states.0+0x178>
    800025c8:	94ba                	add	s1,s1,a4
    800025ca:	409c                	lw	a5,0(s1)
    800025cc:	97ba                	add	a5,a5,a4
    800025ce:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800025d0:	6d3c                	ld	a5,88(a0)
    800025d2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800025d4:	60e2                	ld	ra,24(sp)
    800025d6:	6442                	ld	s0,16(sp)
    800025d8:	64a2                	ld	s1,8(sp)
    800025da:	6105                	addi	sp,sp,32
    800025dc:	8082                	ret
    return p->trapframe->a1;
    800025de:	6d3c                	ld	a5,88(a0)
    800025e0:	7fa8                	ld	a0,120(a5)
    800025e2:	bfcd                	j	800025d4 <argraw+0x2c>
    return p->trapframe->a2;
    800025e4:	6d3c                	ld	a5,88(a0)
    800025e6:	63c8                	ld	a0,128(a5)
    800025e8:	b7f5                	j	800025d4 <argraw+0x2c>
    return p->trapframe->a3;
    800025ea:	6d3c                	ld	a5,88(a0)
    800025ec:	67c8                	ld	a0,136(a5)
    800025ee:	b7dd                	j	800025d4 <argraw+0x2c>
    return p->trapframe->a4;
    800025f0:	6d3c                	ld	a5,88(a0)
    800025f2:	6bc8                	ld	a0,144(a5)
    800025f4:	b7c5                	j	800025d4 <argraw+0x2c>
    return p->trapframe->a5;
    800025f6:	6d3c                	ld	a5,88(a0)
    800025f8:	6fc8                	ld	a0,152(a5)
    800025fa:	bfe9                	j	800025d4 <argraw+0x2c>
  panic("argraw");
    800025fc:	00005517          	auipc	a0,0x5
    80002600:	e8450513          	addi	a0,a0,-380 # 80007480 <states.0+0x150>
    80002604:	952fe0ef          	jal	ra,80000756 <panic>

0000000080002608 <fetchaddr>:
{
    80002608:	1101                	addi	sp,sp,-32
    8000260a:	ec06                	sd	ra,24(sp)
    8000260c:	e822                	sd	s0,16(sp)
    8000260e:	e426                	sd	s1,8(sp)
    80002610:	e04a                	sd	s2,0(sp)
    80002612:	1000                	addi	s0,sp,32
    80002614:	84aa                	mv	s1,a0
    80002616:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002618:	9ceff0ef          	jal	ra,800017e6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000261c:	653c                	ld	a5,72(a0)
    8000261e:	02f4f663          	bgeu	s1,a5,8000264a <fetchaddr+0x42>
    80002622:	00848713          	addi	a4,s1,8
    80002626:	02e7e463          	bltu	a5,a4,8000264e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000262a:	46a1                	li	a3,8
    8000262c:	8626                	mv	a2,s1
    8000262e:	85ca                	mv	a1,s2
    80002630:	6928                	ld	a0,80(a0)
    80002632:	f21fe0ef          	jal	ra,80001552 <copyin>
    80002636:	00a03533          	snez	a0,a0
    8000263a:	40a00533          	neg	a0,a0
}
    8000263e:	60e2                	ld	ra,24(sp)
    80002640:	6442                	ld	s0,16(sp)
    80002642:	64a2                	ld	s1,8(sp)
    80002644:	6902                	ld	s2,0(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret
    return -1;
    8000264a:	557d                	li	a0,-1
    8000264c:	bfcd                	j	8000263e <fetchaddr+0x36>
    8000264e:	557d                	li	a0,-1
    80002650:	b7fd                	j	8000263e <fetchaddr+0x36>

0000000080002652 <fetchstr>:
{
    80002652:	7179                	addi	sp,sp,-48
    80002654:	f406                	sd	ra,40(sp)
    80002656:	f022                	sd	s0,32(sp)
    80002658:	ec26                	sd	s1,24(sp)
    8000265a:	e84a                	sd	s2,16(sp)
    8000265c:	e44e                	sd	s3,8(sp)
    8000265e:	1800                	addi	s0,sp,48
    80002660:	892a                	mv	s2,a0
    80002662:	84ae                	mv	s1,a1
    80002664:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002666:	980ff0ef          	jal	ra,800017e6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000266a:	86ce                	mv	a3,s3
    8000266c:	864a                	mv	a2,s2
    8000266e:	85a6                	mv	a1,s1
    80002670:	6928                	ld	a0,80(a0)
    80002672:	f67fe0ef          	jal	ra,800015d8 <copyinstr>
    80002676:	00054c63          	bltz	a0,8000268e <fetchstr+0x3c>
  return strlen(buf);
    8000267a:	8526                	mv	a0,s1
    8000267c:	f6afe0ef          	jal	ra,80000de6 <strlen>
}
    80002680:	70a2                	ld	ra,40(sp)
    80002682:	7402                	ld	s0,32(sp)
    80002684:	64e2                	ld	s1,24(sp)
    80002686:	6942                	ld	s2,16(sp)
    80002688:	69a2                	ld	s3,8(sp)
    8000268a:	6145                	addi	sp,sp,48
    8000268c:	8082                	ret
    return -1;
    8000268e:	557d                	li	a0,-1
    80002690:	bfc5                	j	80002680 <fetchstr+0x2e>

0000000080002692 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002692:	1101                	addi	sp,sp,-32
    80002694:	ec06                	sd	ra,24(sp)
    80002696:	e822                	sd	s0,16(sp)
    80002698:	e426                	sd	s1,8(sp)
    8000269a:	1000                	addi	s0,sp,32
    8000269c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000269e:	f0bff0ef          	jal	ra,800025a8 <argraw>
    800026a2:	c088                	sw	a0,0(s1)
}
    800026a4:	60e2                	ld	ra,24(sp)
    800026a6:	6442                	ld	s0,16(sp)
    800026a8:	64a2                	ld	s1,8(sp)
    800026aa:	6105                	addi	sp,sp,32
    800026ac:	8082                	ret

00000000800026ae <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800026ae:	1101                	addi	sp,sp,-32
    800026b0:	ec06                	sd	ra,24(sp)
    800026b2:	e822                	sd	s0,16(sp)
    800026b4:	e426                	sd	s1,8(sp)
    800026b6:	1000                	addi	s0,sp,32
    800026b8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800026ba:	eefff0ef          	jal	ra,800025a8 <argraw>
    800026be:	e088                	sd	a0,0(s1)
}
    800026c0:	60e2                	ld	ra,24(sp)
    800026c2:	6442                	ld	s0,16(sp)
    800026c4:	64a2                	ld	s1,8(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret

00000000800026ca <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800026ca:	7179                	addi	sp,sp,-48
    800026cc:	f406                	sd	ra,40(sp)
    800026ce:	f022                	sd	s0,32(sp)
    800026d0:	ec26                	sd	s1,24(sp)
    800026d2:	e84a                	sd	s2,16(sp)
    800026d4:	1800                	addi	s0,sp,48
    800026d6:	84ae                	mv	s1,a1
    800026d8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800026da:	fd840593          	addi	a1,s0,-40
    800026de:	fd1ff0ef          	jal	ra,800026ae <argaddr>
  return fetchstr(addr, buf, max);
    800026e2:	864a                	mv	a2,s2
    800026e4:	85a6                	mv	a1,s1
    800026e6:	fd843503          	ld	a0,-40(s0)
    800026ea:	f69ff0ef          	jal	ra,80002652 <fetchstr>
}
    800026ee:	70a2                	ld	ra,40(sp)
    800026f0:	7402                	ld	s0,32(sp)
    800026f2:	64e2                	ld	s1,24(sp)
    800026f4:	6942                	ld	s2,16(sp)
    800026f6:	6145                	addi	sp,sp,48
    800026f8:	8082                	ret

00000000800026fa <syscall>:
[SYS_pageAccess] sys_pageAccess,
};

void
syscall(void)
{
    800026fa:	1101                	addi	sp,sp,-32
    800026fc:	ec06                	sd	ra,24(sp)
    800026fe:	e822                	sd	s0,16(sp)
    80002700:	e426                	sd	s1,8(sp)
    80002702:	e04a                	sd	s2,0(sp)
    80002704:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002706:	8e0ff0ef          	jal	ra,800017e6 <myproc>
    8000270a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000270c:	05853903          	ld	s2,88(a0)
    80002710:	0a893783          	ld	a5,168(s2)
    80002714:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002718:	37fd                	addiw	a5,a5,-1
    8000271a:	4755                	li	a4,21
    8000271c:	00f76f63          	bltu	a4,a5,8000273a <syscall+0x40>
    80002720:	00369713          	slli	a4,a3,0x3
    80002724:	00005797          	auipc	a5,0x5
    80002728:	d9c78793          	addi	a5,a5,-612 # 800074c0 <syscalls>
    8000272c:	97ba                	add	a5,a5,a4
    8000272e:	639c                	ld	a5,0(a5)
    80002730:	c789                	beqz	a5,8000273a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002732:	9782                	jalr	a5
    80002734:	06a93823          	sd	a0,112(s2)
    80002738:	a829                	j	80002752 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000273a:	15848613          	addi	a2,s1,344
    8000273e:	588c                	lw	a1,48(s1)
    80002740:	00005517          	auipc	a0,0x5
    80002744:	d4850513          	addi	a0,a0,-696 # 80007488 <states.0+0x158>
    80002748:	d5bfd0ef          	jal	ra,800004a2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000274c:	6cbc                	ld	a5,88(s1)
    8000274e:	577d                	li	a4,-1
    80002750:	fbb8                	sd	a4,112(a5)
  }
}
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6902                	ld	s2,0(sp)
    8000275a:	6105                	addi	sp,sp,32
    8000275c:	8082                	ret

000000008000275e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000275e:	1101                	addi	sp,sp,-32
    80002760:	ec06                	sd	ra,24(sp)
    80002762:	e822                	sd	s0,16(sp)
    80002764:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002766:	fec40593          	addi	a1,s0,-20
    8000276a:	4501                	li	a0,0
    8000276c:	f27ff0ef          	jal	ra,80002692 <argint>
  exit(n);
    80002770:	fec42503          	lw	a0,-20(s0)
    80002774:	f4aff0ef          	jal	ra,80001ebe <exit>
  return 0;  // not reached
}
    80002778:	4501                	li	a0,0
    8000277a:	60e2                	ld	ra,24(sp)
    8000277c:	6442                	ld	s0,16(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002782:	1141                	addi	sp,sp,-16
    80002784:	e406                	sd	ra,8(sp)
    80002786:	e022                	sd	s0,0(sp)
    80002788:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000278a:	85cff0ef          	jal	ra,800017e6 <myproc>
}
    8000278e:	5908                	lw	a0,48(a0)
    80002790:	60a2                	ld	ra,8(sp)
    80002792:	6402                	ld	s0,0(sp)
    80002794:	0141                	addi	sp,sp,16
    80002796:	8082                	ret

0000000080002798 <sys_fork>:

uint64
sys_fork(void)
{
    80002798:	1141                	addi	sp,sp,-16
    8000279a:	e406                	sd	ra,8(sp)
    8000279c:	e022                	sd	s0,0(sp)
    8000279e:	0800                	addi	s0,sp,16
  return fork();
    800027a0:	b6cff0ef          	jal	ra,80001b0c <fork>
}
    800027a4:	60a2                	ld	ra,8(sp)
    800027a6:	6402                	ld	s0,0(sp)
    800027a8:	0141                	addi	sp,sp,16
    800027aa:	8082                	ret

00000000800027ac <sys_wait>:

uint64
sys_wait(void)
{
    800027ac:	1101                	addi	sp,sp,-32
    800027ae:	ec06                	sd	ra,24(sp)
    800027b0:	e822                	sd	s0,16(sp)
    800027b2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800027b4:	fe840593          	addi	a1,s0,-24
    800027b8:	4501                	li	a0,0
    800027ba:	ef5ff0ef          	jal	ra,800026ae <argaddr>
  return wait(p);
    800027be:	fe843503          	ld	a0,-24(s0)
    800027c2:	853ff0ef          	jal	ra,80002014 <wait>
}
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	6105                	addi	sp,sp,32
    800027cc:	8082                	ret

00000000800027ce <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800027ce:	7179                	addi	sp,sp,-48
    800027d0:	f406                	sd	ra,40(sp)
    800027d2:	f022                	sd	s0,32(sp)
    800027d4:	ec26                	sd	s1,24(sp)
    800027d6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800027d8:	fdc40593          	addi	a1,s0,-36
    800027dc:	4501                	li	a0,0
    800027de:	eb5ff0ef          	jal	ra,80002692 <argint>
  addr = myproc()->sz;
    800027e2:	804ff0ef          	jal	ra,800017e6 <myproc>
    800027e6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800027e8:	fdc42503          	lw	a0,-36(s0)
    800027ec:	ad0ff0ef          	jal	ra,80001abc <growproc>
    800027f0:	00054863          	bltz	a0,80002800 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800027f4:	8526                	mv	a0,s1
    800027f6:	70a2                	ld	ra,40(sp)
    800027f8:	7402                	ld	s0,32(sp)
    800027fa:	64e2                	ld	s1,24(sp)
    800027fc:	6145                	addi	sp,sp,48
    800027fe:	8082                	ret
    return -1;
    80002800:	54fd                	li	s1,-1
    80002802:	bfcd                	j	800027f4 <sys_sbrk+0x26>

0000000080002804 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002804:	7139                	addi	sp,sp,-64
    80002806:	fc06                	sd	ra,56(sp)
    80002808:	f822                	sd	s0,48(sp)
    8000280a:	f426                	sd	s1,40(sp)
    8000280c:	f04a                	sd	s2,32(sp)
    8000280e:	ec4e                	sd	s3,24(sp)
    80002810:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002812:	fcc40593          	addi	a1,s0,-52
    80002816:	4501                	li	a0,0
    80002818:	e7bff0ef          	jal	ra,80002692 <argint>
  if(n < 0)
    8000281c:	fcc42783          	lw	a5,-52(s0)
    80002820:	0607c563          	bltz	a5,8000288a <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002824:	00013517          	auipc	a0,0x13
    80002828:	07c50513          	addi	a0,a0,124 # 800158a0 <tickslock>
    8000282c:	b6efe0ef          	jal	ra,80000b9a <acquire>
  ticks0 = ticks;
    80002830:	00005917          	auipc	s2,0x5
    80002834:	11092903          	lw	s2,272(s2) # 80007940 <ticks>
  while(ticks - ticks0 < n){
    80002838:	fcc42783          	lw	a5,-52(s0)
    8000283c:	cb8d                	beqz	a5,8000286e <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000283e:	00013997          	auipc	s3,0x13
    80002842:	06298993          	addi	s3,s3,98 # 800158a0 <tickslock>
    80002846:	00005497          	auipc	s1,0x5
    8000284a:	0fa48493          	addi	s1,s1,250 # 80007940 <ticks>
    if(killed(myproc())){
    8000284e:	f99fe0ef          	jal	ra,800017e6 <myproc>
    80002852:	f98ff0ef          	jal	ra,80001fea <killed>
    80002856:	ed0d                	bnez	a0,80002890 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002858:	85ce                	mv	a1,s3
    8000285a:	8526                	mv	a0,s1
    8000285c:	d56ff0ef          	jal	ra,80001db2 <sleep>
  while(ticks - ticks0 < n){
    80002860:	409c                	lw	a5,0(s1)
    80002862:	412787bb          	subw	a5,a5,s2
    80002866:	fcc42703          	lw	a4,-52(s0)
    8000286a:	fee7e2e3          	bltu	a5,a4,8000284e <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000286e:	00013517          	auipc	a0,0x13
    80002872:	03250513          	addi	a0,a0,50 # 800158a0 <tickslock>
    80002876:	bbcfe0ef          	jal	ra,80000c32 <release>
  return 0;
    8000287a:	4501                	li	a0,0
}
    8000287c:	70e2                	ld	ra,56(sp)
    8000287e:	7442                	ld	s0,48(sp)
    80002880:	74a2                	ld	s1,40(sp)
    80002882:	7902                	ld	s2,32(sp)
    80002884:	69e2                	ld	s3,24(sp)
    80002886:	6121                	addi	sp,sp,64
    80002888:	8082                	ret
    n = 0;
    8000288a:	fc042623          	sw	zero,-52(s0)
    8000288e:	bf59                	j	80002824 <sys_sleep+0x20>
      release(&tickslock);
    80002890:	00013517          	auipc	a0,0x13
    80002894:	01050513          	addi	a0,a0,16 # 800158a0 <tickslock>
    80002898:	b9afe0ef          	jal	ra,80000c32 <release>
      return -1;
    8000289c:	557d                	li	a0,-1
    8000289e:	bff9                	j	8000287c <sys_sleep+0x78>

00000000800028a0 <sys_kill>:

uint64
sys_kill(void)
{
    800028a0:	1101                	addi	sp,sp,-32
    800028a2:	ec06                	sd	ra,24(sp)
    800028a4:	e822                	sd	s0,16(sp)
    800028a6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800028a8:	fec40593          	addi	a1,s0,-20
    800028ac:	4501                	li	a0,0
    800028ae:	de5ff0ef          	jal	ra,80002692 <argint>
  return kill(pid);
    800028b2:	fec42503          	lw	a0,-20(s0)
    800028b6:	eaaff0ef          	jal	ra,80001f60 <kill>
}
    800028ba:	60e2                	ld	ra,24(sp)
    800028bc:	6442                	ld	s0,16(sp)
    800028be:	6105                	addi	sp,sp,32
    800028c0:	8082                	ret

00000000800028c2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800028c2:	1101                	addi	sp,sp,-32
    800028c4:	ec06                	sd	ra,24(sp)
    800028c6:	e822                	sd	s0,16(sp)
    800028c8:	e426                	sd	s1,8(sp)
    800028ca:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800028cc:	00013517          	auipc	a0,0x13
    800028d0:	fd450513          	addi	a0,a0,-44 # 800158a0 <tickslock>
    800028d4:	ac6fe0ef          	jal	ra,80000b9a <acquire>
  xticks = ticks;
    800028d8:	00005497          	auipc	s1,0x5
    800028dc:	0684a483          	lw	s1,104(s1) # 80007940 <ticks>
  release(&tickslock);
    800028e0:	00013517          	auipc	a0,0x13
    800028e4:	fc050513          	addi	a0,a0,-64 # 800158a0 <tickslock>
    800028e8:	b4afe0ef          	jal	ra,80000c32 <release>
  return xticks;
}
    800028ec:	02049513          	slli	a0,s1,0x20
    800028f0:	9101                	srli	a0,a0,0x20
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	64a2                	ld	s1,8(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret

00000000800028fc <sys_pageAccess>:

int
sys_pageAccess(void)
{
    800028fc:	715d                	addi	sp,sp,-80
    800028fe:	e486                	sd	ra,72(sp)
    80002900:	e0a2                	sd	s0,64(sp)
    80002902:	fc26                	sd	s1,56(sp)
    80002904:	f84a                	sd	s2,48(sp)
    80002906:	f44e                	sd	s3,40(sp)
    80002908:	f052                	sd	s4,32(sp)
    8000290a:	0880                	addi	s0,sp,80
    // Get the three function arguments from the pageAccess() system call
    uint64 usrpage_ptr;  // First argument - pointer to user space address
    int npages;          // Second argument - the number of pages to examine
    uint64 usraddr;      // Third argument - pointer to the bitmap
    argaddr(0, &usrpage_ptr);
    8000290c:	fc840593          	addi	a1,s0,-56
    80002910:	4501                	li	a0,0
    80002912:	d9dff0ef          	jal	ra,800026ae <argaddr>
    argint(1, &npages);
    80002916:	fc440593          	addi	a1,s0,-60
    8000291a:	4505                	li	a0,1
    8000291c:	d77ff0ef          	jal	ra,80002692 <argint>
    argaddr(2, &usraddr);
    80002920:	fb840593          	addi	a1,s0,-72
    80002924:	4509                	li	a0,2
    80002926:	d89ff0ef          	jal	ra,800026ae <argaddr>

    struct proc* p = myproc();
    8000292a:	ebdfe0ef          	jal	ra,800017e6 <myproc>
    if (npages > 64)
    8000292e:	fc442783          	lw	a5,-60(s0)
    80002932:	04000713          	li	a4,64
    80002936:	06f74e63          	blt	a4,a5,800029b2 <sys_pageAccess+0xb6>
    8000293a:	89aa                	mv	s3,a0
        return -1;

    pte_t *pte;
    uint64 va;
    uint64 bitmap = 0;
    8000293c:	fa043823          	sd	zero,-80(s0)

    for (int i = 0; i < npages; i++) {
    80002940:	04f05663          	blez	a5,8000298c <sys_pageAccess+0x90>
    80002944:	4481                	li	s1,0
        va = usrpage_ptr + i * PGSIZE;
        pte = walk(p->pagetable, va, 0);
        if (pte == 0)
            return -1;
        if (*pte & PTE_A)
            bitmap |= (1ULL << i);
    80002946:	4a05                	li	s4,1
    80002948:	a801                	j	80002958 <sys_pageAccess+0x5c>
    for (int i = 0; i < npages; i++) {
    8000294a:	0485                	addi	s1,s1,1
    8000294c:	fc442703          	lw	a4,-60(s0)
    80002950:	0004879b          	sext.w	a5,s1
    80002954:	02e7dc63          	bge	a5,a4,8000298c <sys_pageAccess+0x90>
    80002958:	0004891b          	sext.w	s2,s1
        va = usrpage_ptr + i * PGSIZE;
    8000295c:	00c49793          	slli	a5,s1,0xc
        pte = walk(p->pagetable, va, 0);
    80002960:	4601                	li	a2,0
    80002962:	fc843583          	ld	a1,-56(s0)
    80002966:	95be                	add	a1,a1,a5
    80002968:	0509b503          	ld	a0,80(s3)
    8000296c:	d38fe0ef          	jal	ra,80000ea4 <walk>
        if (pte == 0)
    80002970:	c139                	beqz	a0,800029b6 <sys_pageAccess+0xba>
        if (*pte & PTE_A)
    80002972:	611c                	ld	a5,0(a0)
    80002974:	0407f793          	andi	a5,a5,64
    80002978:	dbe9                	beqz	a5,8000294a <sys_pageAccess+0x4e>
            bitmap |= (1ULL << i);
    8000297a:	012a1933          	sll	s2,s4,s2
    8000297e:	fb043783          	ld	a5,-80(s0)
    80002982:	0127e933          	or	s2,a5,s2
    80002986:	fb243823          	sd	s2,-80(s0)
    8000298a:	b7c1                	j	8000294a <sys_pageAccess+0x4e>
    }

    // Return the bitmap pointer to the user program
    if (copyout(p->pagetable, usraddr, (char*)&bitmap, sizeof(bitmap)) < 0)
    8000298c:	46a1                	li	a3,8
    8000298e:	fb040613          	addi	a2,s0,-80
    80002992:	fb843583          	ld	a1,-72(s0)
    80002996:	0509b503          	ld	a0,80(s3)
    8000299a:	b01fe0ef          	jal	ra,8000149a <copyout>
    8000299e:	41f5551b          	sraiw	a0,a0,0x1f
        return -1;

    return 0;
}
    800029a2:	60a6                	ld	ra,72(sp)
    800029a4:	6406                	ld	s0,64(sp)
    800029a6:	74e2                	ld	s1,56(sp)
    800029a8:	7942                	ld	s2,48(sp)
    800029aa:	79a2                	ld	s3,40(sp)
    800029ac:	7a02                	ld	s4,32(sp)
    800029ae:	6161                	addi	sp,sp,80
    800029b0:	8082                	ret
        return -1;
    800029b2:	557d                	li	a0,-1
    800029b4:	b7fd                	j	800029a2 <sys_pageAccess+0xa6>
            return -1;
    800029b6:	557d                	li	a0,-1
    800029b8:	b7ed                	j	800029a2 <sys_pageAccess+0xa6>

00000000800029ba <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800029ba:	7179                	addi	sp,sp,-48
    800029bc:	f406                	sd	ra,40(sp)
    800029be:	f022                	sd	s0,32(sp)
    800029c0:	ec26                	sd	s1,24(sp)
    800029c2:	e84a                	sd	s2,16(sp)
    800029c4:	e44e                	sd	s3,8(sp)
    800029c6:	e052                	sd	s4,0(sp)
    800029c8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800029ca:	00005597          	auipc	a1,0x5
    800029ce:	bae58593          	addi	a1,a1,-1106 # 80007578 <syscalls+0xb8>
    800029d2:	00013517          	auipc	a0,0x13
    800029d6:	ee650513          	addi	a0,a0,-282 # 800158b8 <bcache>
    800029da:	940fe0ef          	jal	ra,80000b1a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800029de:	0001b797          	auipc	a5,0x1b
    800029e2:	eda78793          	addi	a5,a5,-294 # 8001d8b8 <bcache+0x8000>
    800029e6:	0001b717          	auipc	a4,0x1b
    800029ea:	13a70713          	addi	a4,a4,314 # 8001db20 <bcache+0x8268>
    800029ee:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800029f2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029f6:	00013497          	auipc	s1,0x13
    800029fa:	eda48493          	addi	s1,s1,-294 # 800158d0 <bcache+0x18>
    b->next = bcache.head.next;
    800029fe:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002a00:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002a02:	00005a17          	auipc	s4,0x5
    80002a06:	b7ea0a13          	addi	s4,s4,-1154 # 80007580 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002a0a:	2b893783          	ld	a5,696(s2)
    80002a0e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002a10:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002a14:	85d2                	mv	a1,s4
    80002a16:	01048513          	addi	a0,s1,16
    80002a1a:	224010ef          	jal	ra,80003c3e <initsleeplock>
    bcache.head.next->prev = b;
    80002a1e:	2b893783          	ld	a5,696(s2)
    80002a22:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002a24:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a28:	45848493          	addi	s1,s1,1112
    80002a2c:	fd349fe3          	bne	s1,s3,80002a0a <binit+0x50>
  }
}
    80002a30:	70a2                	ld	ra,40(sp)
    80002a32:	7402                	ld	s0,32(sp)
    80002a34:	64e2                	ld	s1,24(sp)
    80002a36:	6942                	ld	s2,16(sp)
    80002a38:	69a2                	ld	s3,8(sp)
    80002a3a:	6a02                	ld	s4,0(sp)
    80002a3c:	6145                	addi	sp,sp,48
    80002a3e:	8082                	ret

0000000080002a40 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002a40:	7179                	addi	sp,sp,-48
    80002a42:	f406                	sd	ra,40(sp)
    80002a44:	f022                	sd	s0,32(sp)
    80002a46:	ec26                	sd	s1,24(sp)
    80002a48:	e84a                	sd	s2,16(sp)
    80002a4a:	e44e                	sd	s3,8(sp)
    80002a4c:	1800                	addi	s0,sp,48
    80002a4e:	892a                	mv	s2,a0
    80002a50:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002a52:	00013517          	auipc	a0,0x13
    80002a56:	e6650513          	addi	a0,a0,-410 # 800158b8 <bcache>
    80002a5a:	940fe0ef          	jal	ra,80000b9a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002a5e:	0001b497          	auipc	s1,0x1b
    80002a62:	1124b483          	ld	s1,274(s1) # 8001db70 <bcache+0x82b8>
    80002a66:	0001b797          	auipc	a5,0x1b
    80002a6a:	0ba78793          	addi	a5,a5,186 # 8001db20 <bcache+0x8268>
    80002a6e:	02f48b63          	beq	s1,a5,80002aa4 <bread+0x64>
    80002a72:	873e                	mv	a4,a5
    80002a74:	a021                	j	80002a7c <bread+0x3c>
    80002a76:	68a4                	ld	s1,80(s1)
    80002a78:	02e48663          	beq	s1,a4,80002aa4 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a7c:	449c                	lw	a5,8(s1)
    80002a7e:	ff279ce3          	bne	a5,s2,80002a76 <bread+0x36>
    80002a82:	44dc                	lw	a5,12(s1)
    80002a84:	ff3799e3          	bne	a5,s3,80002a76 <bread+0x36>
      b->refcnt++;
    80002a88:	40bc                	lw	a5,64(s1)
    80002a8a:	2785                	addiw	a5,a5,1
    80002a8c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a8e:	00013517          	auipc	a0,0x13
    80002a92:	e2a50513          	addi	a0,a0,-470 # 800158b8 <bcache>
    80002a96:	99cfe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002a9a:	01048513          	addi	a0,s1,16
    80002a9e:	1d6010ef          	jal	ra,80003c74 <acquiresleep>
      return b;
    80002aa2:	a889                	j	80002af4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002aa4:	0001b497          	auipc	s1,0x1b
    80002aa8:	0c44b483          	ld	s1,196(s1) # 8001db68 <bcache+0x82b0>
    80002aac:	0001b797          	auipc	a5,0x1b
    80002ab0:	07478793          	addi	a5,a5,116 # 8001db20 <bcache+0x8268>
    80002ab4:	00f48863          	beq	s1,a5,80002ac4 <bread+0x84>
    80002ab8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002aba:	40bc                	lw	a5,64(s1)
    80002abc:	cb91                	beqz	a5,80002ad0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002abe:	64a4                	ld	s1,72(s1)
    80002ac0:	fee49de3          	bne	s1,a4,80002aba <bread+0x7a>
  panic("bget: no buffers");
    80002ac4:	00005517          	auipc	a0,0x5
    80002ac8:	ac450513          	addi	a0,a0,-1340 # 80007588 <syscalls+0xc8>
    80002acc:	c8bfd0ef          	jal	ra,80000756 <panic>
      b->dev = dev;
    80002ad0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002ad4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002ad8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002adc:	4785                	li	a5,1
    80002ade:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ae0:	00013517          	auipc	a0,0x13
    80002ae4:	dd850513          	addi	a0,a0,-552 # 800158b8 <bcache>
    80002ae8:	94afe0ef          	jal	ra,80000c32 <release>
      acquiresleep(&b->lock);
    80002aec:	01048513          	addi	a0,s1,16
    80002af0:	184010ef          	jal	ra,80003c74 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002af4:	409c                	lw	a5,0(s1)
    80002af6:	cb89                	beqz	a5,80002b08 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002af8:	8526                	mv	a0,s1
    80002afa:	70a2                	ld	ra,40(sp)
    80002afc:	7402                	ld	s0,32(sp)
    80002afe:	64e2                	ld	s1,24(sp)
    80002b00:	6942                	ld	s2,16(sp)
    80002b02:	69a2                	ld	s3,8(sp)
    80002b04:	6145                	addi	sp,sp,48
    80002b06:	8082                	ret
    virtio_disk_rw(b, 0);
    80002b08:	4581                	li	a1,0
    80002b0a:	8526                	mv	a0,s1
    80002b0c:	0d1020ef          	jal	ra,800053dc <virtio_disk_rw>
    b->valid = 1;
    80002b10:	4785                	li	a5,1
    80002b12:	c09c                	sw	a5,0(s1)
  return b;
    80002b14:	b7d5                	j	80002af8 <bread+0xb8>

0000000080002b16 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002b16:	1101                	addi	sp,sp,-32
    80002b18:	ec06                	sd	ra,24(sp)
    80002b1a:	e822                	sd	s0,16(sp)
    80002b1c:	e426                	sd	s1,8(sp)
    80002b1e:	1000                	addi	s0,sp,32
    80002b20:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b22:	0541                	addi	a0,a0,16
    80002b24:	1ce010ef          	jal	ra,80003cf2 <holdingsleep>
    80002b28:	c911                	beqz	a0,80002b3c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002b2a:	4585                	li	a1,1
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	0af020ef          	jal	ra,800053dc <virtio_disk_rw>
}
    80002b32:	60e2                	ld	ra,24(sp)
    80002b34:	6442                	ld	s0,16(sp)
    80002b36:	64a2                	ld	s1,8(sp)
    80002b38:	6105                	addi	sp,sp,32
    80002b3a:	8082                	ret
    panic("bwrite");
    80002b3c:	00005517          	auipc	a0,0x5
    80002b40:	a6450513          	addi	a0,a0,-1436 # 800075a0 <syscalls+0xe0>
    80002b44:	c13fd0ef          	jal	ra,80000756 <panic>

0000000080002b48 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002b48:	1101                	addi	sp,sp,-32
    80002b4a:	ec06                	sd	ra,24(sp)
    80002b4c:	e822                	sd	s0,16(sp)
    80002b4e:	e426                	sd	s1,8(sp)
    80002b50:	e04a                	sd	s2,0(sp)
    80002b52:	1000                	addi	s0,sp,32
    80002b54:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b56:	01050913          	addi	s2,a0,16
    80002b5a:	854a                	mv	a0,s2
    80002b5c:	196010ef          	jal	ra,80003cf2 <holdingsleep>
    80002b60:	c13d                	beqz	a0,80002bc6 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002b62:	854a                	mv	a0,s2
    80002b64:	156010ef          	jal	ra,80003cba <releasesleep>

  acquire(&bcache.lock);
    80002b68:	00013517          	auipc	a0,0x13
    80002b6c:	d5050513          	addi	a0,a0,-688 # 800158b8 <bcache>
    80002b70:	82afe0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002b74:	40bc                	lw	a5,64(s1)
    80002b76:	37fd                	addiw	a5,a5,-1
    80002b78:	0007871b          	sext.w	a4,a5
    80002b7c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b7e:	eb05                	bnez	a4,80002bae <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002b80:	68bc                	ld	a5,80(s1)
    80002b82:	64b8                	ld	a4,72(s1)
    80002b84:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002b86:	64bc                	ld	a5,72(s1)
    80002b88:	68b8                	ld	a4,80(s1)
    80002b8a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b8c:	0001b797          	auipc	a5,0x1b
    80002b90:	d2c78793          	addi	a5,a5,-724 # 8001d8b8 <bcache+0x8000>
    80002b94:	2b87b703          	ld	a4,696(a5)
    80002b98:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b9a:	0001b717          	auipc	a4,0x1b
    80002b9e:	f8670713          	addi	a4,a4,-122 # 8001db20 <bcache+0x8268>
    80002ba2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002ba4:	2b87b703          	ld	a4,696(a5)
    80002ba8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002baa:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002bae:	00013517          	auipc	a0,0x13
    80002bb2:	d0a50513          	addi	a0,a0,-758 # 800158b8 <bcache>
    80002bb6:	87cfe0ef          	jal	ra,80000c32 <release>
}
    80002bba:	60e2                	ld	ra,24(sp)
    80002bbc:	6442                	ld	s0,16(sp)
    80002bbe:	64a2                	ld	s1,8(sp)
    80002bc0:	6902                	ld	s2,0(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret
    panic("brelse");
    80002bc6:	00005517          	auipc	a0,0x5
    80002bca:	9e250513          	addi	a0,a0,-1566 # 800075a8 <syscalls+0xe8>
    80002bce:	b89fd0ef          	jal	ra,80000756 <panic>

0000000080002bd2 <bpin>:

void
bpin(struct buf *b) {
    80002bd2:	1101                	addi	sp,sp,-32
    80002bd4:	ec06                	sd	ra,24(sp)
    80002bd6:	e822                	sd	s0,16(sp)
    80002bd8:	e426                	sd	s1,8(sp)
    80002bda:	1000                	addi	s0,sp,32
    80002bdc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002bde:	00013517          	auipc	a0,0x13
    80002be2:	cda50513          	addi	a0,a0,-806 # 800158b8 <bcache>
    80002be6:	fb5fd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt++;
    80002bea:	40bc                	lw	a5,64(s1)
    80002bec:	2785                	addiw	a5,a5,1
    80002bee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bf0:	00013517          	auipc	a0,0x13
    80002bf4:	cc850513          	addi	a0,a0,-824 # 800158b8 <bcache>
    80002bf8:	83afe0ef          	jal	ra,80000c32 <release>
}
    80002bfc:	60e2                	ld	ra,24(sp)
    80002bfe:	6442                	ld	s0,16(sp)
    80002c00:	64a2                	ld	s1,8(sp)
    80002c02:	6105                	addi	sp,sp,32
    80002c04:	8082                	ret

0000000080002c06 <bunpin>:

void
bunpin(struct buf *b) {
    80002c06:	1101                	addi	sp,sp,-32
    80002c08:	ec06                	sd	ra,24(sp)
    80002c0a:	e822                	sd	s0,16(sp)
    80002c0c:	e426                	sd	s1,8(sp)
    80002c0e:	1000                	addi	s0,sp,32
    80002c10:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c12:	00013517          	auipc	a0,0x13
    80002c16:	ca650513          	addi	a0,a0,-858 # 800158b8 <bcache>
    80002c1a:	f81fd0ef          	jal	ra,80000b9a <acquire>
  b->refcnt--;
    80002c1e:	40bc                	lw	a5,64(s1)
    80002c20:	37fd                	addiw	a5,a5,-1
    80002c22:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c24:	00013517          	auipc	a0,0x13
    80002c28:	c9450513          	addi	a0,a0,-876 # 800158b8 <bcache>
    80002c2c:	806fe0ef          	jal	ra,80000c32 <release>
}
    80002c30:	60e2                	ld	ra,24(sp)
    80002c32:	6442                	ld	s0,16(sp)
    80002c34:	64a2                	ld	s1,8(sp)
    80002c36:	6105                	addi	sp,sp,32
    80002c38:	8082                	ret

0000000080002c3a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002c3a:	1101                	addi	sp,sp,-32
    80002c3c:	ec06                	sd	ra,24(sp)
    80002c3e:	e822                	sd	s0,16(sp)
    80002c40:	e426                	sd	s1,8(sp)
    80002c42:	e04a                	sd	s2,0(sp)
    80002c44:	1000                	addi	s0,sp,32
    80002c46:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002c48:	00d5d59b          	srliw	a1,a1,0xd
    80002c4c:	0001b797          	auipc	a5,0x1b
    80002c50:	3487a783          	lw	a5,840(a5) # 8001df94 <sb+0x1c>
    80002c54:	9dbd                	addw	a1,a1,a5
    80002c56:	debff0ef          	jal	ra,80002a40 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002c5a:	0074f713          	andi	a4,s1,7
    80002c5e:	4785                	li	a5,1
    80002c60:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002c64:	14ce                	slli	s1,s1,0x33
    80002c66:	90d9                	srli	s1,s1,0x36
    80002c68:	00950733          	add	a4,a0,s1
    80002c6c:	05874703          	lbu	a4,88(a4)
    80002c70:	00e7f6b3          	and	a3,a5,a4
    80002c74:	c29d                	beqz	a3,80002c9a <bfree+0x60>
    80002c76:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c78:	94aa                	add	s1,s1,a0
    80002c7a:	fff7c793          	not	a5,a5
    80002c7e:	8ff9                	and	a5,a5,a4
    80002c80:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002c84:	6e9000ef          	jal	ra,80003b6c <log_write>
  brelse(bp);
    80002c88:	854a                	mv	a0,s2
    80002c8a:	ebfff0ef          	jal	ra,80002b48 <brelse>
}
    80002c8e:	60e2                	ld	ra,24(sp)
    80002c90:	6442                	ld	s0,16(sp)
    80002c92:	64a2                	ld	s1,8(sp)
    80002c94:	6902                	ld	s2,0(sp)
    80002c96:	6105                	addi	sp,sp,32
    80002c98:	8082                	ret
    panic("freeing free block");
    80002c9a:	00005517          	auipc	a0,0x5
    80002c9e:	91650513          	addi	a0,a0,-1770 # 800075b0 <syscalls+0xf0>
    80002ca2:	ab5fd0ef          	jal	ra,80000756 <panic>

0000000080002ca6 <balloc>:
{
    80002ca6:	711d                	addi	sp,sp,-96
    80002ca8:	ec86                	sd	ra,88(sp)
    80002caa:	e8a2                	sd	s0,80(sp)
    80002cac:	e4a6                	sd	s1,72(sp)
    80002cae:	e0ca                	sd	s2,64(sp)
    80002cb0:	fc4e                	sd	s3,56(sp)
    80002cb2:	f852                	sd	s4,48(sp)
    80002cb4:	f456                	sd	s5,40(sp)
    80002cb6:	f05a                	sd	s6,32(sp)
    80002cb8:	ec5e                	sd	s7,24(sp)
    80002cba:	e862                	sd	s8,16(sp)
    80002cbc:	e466                	sd	s9,8(sp)
    80002cbe:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002cc0:	0001b797          	auipc	a5,0x1b
    80002cc4:	2bc7a783          	lw	a5,700(a5) # 8001df7c <sb+0x4>
    80002cc8:	0e078163          	beqz	a5,80002daa <balloc+0x104>
    80002ccc:	8baa                	mv	s7,a0
    80002cce:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002cd0:	0001bb17          	auipc	s6,0x1b
    80002cd4:	2a8b0b13          	addi	s6,s6,680 # 8001df78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002cd8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002cda:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002cdc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002cde:	6c89                	lui	s9,0x2
    80002ce0:	a0b5                	j	80002d4c <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002ce2:	974a                	add	a4,a4,s2
    80002ce4:	8fd5                	or	a5,a5,a3
    80002ce6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002cea:	854a                	mv	a0,s2
    80002cec:	681000ef          	jal	ra,80003b6c <log_write>
        brelse(bp);
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	e57ff0ef          	jal	ra,80002b48 <brelse>
  bp = bread(dev, bno);
    80002cf6:	85a6                	mv	a1,s1
    80002cf8:	855e                	mv	a0,s7
    80002cfa:	d47ff0ef          	jal	ra,80002a40 <bread>
    80002cfe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002d00:	40000613          	li	a2,1024
    80002d04:	4581                	li	a1,0
    80002d06:	05850513          	addi	a0,a0,88
    80002d0a:	f65fd0ef          	jal	ra,80000c6e <memset>
  log_write(bp);
    80002d0e:	854a                	mv	a0,s2
    80002d10:	65d000ef          	jal	ra,80003b6c <log_write>
  brelse(bp);
    80002d14:	854a                	mv	a0,s2
    80002d16:	e33ff0ef          	jal	ra,80002b48 <brelse>
}
    80002d1a:	8526                	mv	a0,s1
    80002d1c:	60e6                	ld	ra,88(sp)
    80002d1e:	6446                	ld	s0,80(sp)
    80002d20:	64a6                	ld	s1,72(sp)
    80002d22:	6906                	ld	s2,64(sp)
    80002d24:	79e2                	ld	s3,56(sp)
    80002d26:	7a42                	ld	s4,48(sp)
    80002d28:	7aa2                	ld	s5,40(sp)
    80002d2a:	7b02                	ld	s6,32(sp)
    80002d2c:	6be2                	ld	s7,24(sp)
    80002d2e:	6c42                	ld	s8,16(sp)
    80002d30:	6ca2                	ld	s9,8(sp)
    80002d32:	6125                	addi	sp,sp,96
    80002d34:	8082                	ret
    brelse(bp);
    80002d36:	854a                	mv	a0,s2
    80002d38:	e11ff0ef          	jal	ra,80002b48 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002d3c:	015c87bb          	addw	a5,s9,s5
    80002d40:	00078a9b          	sext.w	s5,a5
    80002d44:	004b2703          	lw	a4,4(s6)
    80002d48:	06eaf163          	bgeu	s5,a4,80002daa <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002d4c:	41fad79b          	sraiw	a5,s5,0x1f
    80002d50:	0137d79b          	srliw	a5,a5,0x13
    80002d54:	015787bb          	addw	a5,a5,s5
    80002d58:	40d7d79b          	sraiw	a5,a5,0xd
    80002d5c:	01cb2583          	lw	a1,28(s6)
    80002d60:	9dbd                	addw	a1,a1,a5
    80002d62:	855e                	mv	a0,s7
    80002d64:	cddff0ef          	jal	ra,80002a40 <bread>
    80002d68:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d6a:	004b2503          	lw	a0,4(s6)
    80002d6e:	000a849b          	sext.w	s1,s5
    80002d72:	8662                	mv	a2,s8
    80002d74:	fca4f1e3          	bgeu	s1,a0,80002d36 <balloc+0x90>
      m = 1 << (bi % 8);
    80002d78:	41f6579b          	sraiw	a5,a2,0x1f
    80002d7c:	01d7d69b          	srliw	a3,a5,0x1d
    80002d80:	00c6873b          	addw	a4,a3,a2
    80002d84:	00777793          	andi	a5,a4,7
    80002d88:	9f95                	subw	a5,a5,a3
    80002d8a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002d8e:	4037571b          	sraiw	a4,a4,0x3
    80002d92:	00e906b3          	add	a3,s2,a4
    80002d96:	0586c683          	lbu	a3,88(a3)
    80002d9a:	00d7f5b3          	and	a1,a5,a3
    80002d9e:	d1b1                	beqz	a1,80002ce2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002da0:	2605                	addiw	a2,a2,1
    80002da2:	2485                	addiw	s1,s1,1
    80002da4:	fd4618e3          	bne	a2,s4,80002d74 <balloc+0xce>
    80002da8:	b779                	j	80002d36 <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	81e50513          	addi	a0,a0,-2018 # 800075c8 <syscalls+0x108>
    80002db2:	ef0fd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80002db6:	4481                	li	s1,0
    80002db8:	b78d                	j	80002d1a <balloc+0x74>

0000000080002dba <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002dba:	7179                	addi	sp,sp,-48
    80002dbc:	f406                	sd	ra,40(sp)
    80002dbe:	f022                	sd	s0,32(sp)
    80002dc0:	ec26                	sd	s1,24(sp)
    80002dc2:	e84a                	sd	s2,16(sp)
    80002dc4:	e44e                	sd	s3,8(sp)
    80002dc6:	e052                	sd	s4,0(sp)
    80002dc8:	1800                	addi	s0,sp,48
    80002dca:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002dcc:	47ad                	li	a5,11
    80002dce:	02b7e563          	bltu	a5,a1,80002df8 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002dd2:	02059493          	slli	s1,a1,0x20
    80002dd6:	9081                	srli	s1,s1,0x20
    80002dd8:	048a                	slli	s1,s1,0x2
    80002dda:	94aa                	add	s1,s1,a0
    80002ddc:	0504a903          	lw	s2,80(s1)
    80002de0:	06091663          	bnez	s2,80002e4c <bmap+0x92>
      addr = balloc(ip->dev);
    80002de4:	4108                	lw	a0,0(a0)
    80002de6:	ec1ff0ef          	jal	ra,80002ca6 <balloc>
    80002dea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002dee:	04090f63          	beqz	s2,80002e4c <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    80002df2:	0524a823          	sw	s2,80(s1)
    80002df6:	a899                	j	80002e4c <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002df8:	ff45849b          	addiw	s1,a1,-12
    80002dfc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002e00:	0ff00793          	li	a5,255
    80002e04:	06e7eb63          	bltu	a5,a4,80002e7a <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002e08:	08052903          	lw	s2,128(a0)
    80002e0c:	00091b63          	bnez	s2,80002e22 <bmap+0x68>
      addr = balloc(ip->dev);
    80002e10:	4108                	lw	a0,0(a0)
    80002e12:	e95ff0ef          	jal	ra,80002ca6 <balloc>
    80002e16:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e1a:	02090963          	beqz	s2,80002e4c <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002e1e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002e22:	85ca                	mv	a1,s2
    80002e24:	0009a503          	lw	a0,0(s3)
    80002e28:	c19ff0ef          	jal	ra,80002a40 <bread>
    80002e2c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002e2e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002e32:	02049593          	slli	a1,s1,0x20
    80002e36:	9181                	srli	a1,a1,0x20
    80002e38:	058a                	slli	a1,a1,0x2
    80002e3a:	00b784b3          	add	s1,a5,a1
    80002e3e:	0004a903          	lw	s2,0(s1)
    80002e42:	00090e63          	beqz	s2,80002e5e <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002e46:	8552                	mv	a0,s4
    80002e48:	d01ff0ef          	jal	ra,80002b48 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002e4c:	854a                	mv	a0,s2
    80002e4e:	70a2                	ld	ra,40(sp)
    80002e50:	7402                	ld	s0,32(sp)
    80002e52:	64e2                	ld	s1,24(sp)
    80002e54:	6942                	ld	s2,16(sp)
    80002e56:	69a2                	ld	s3,8(sp)
    80002e58:	6a02                	ld	s4,0(sp)
    80002e5a:	6145                	addi	sp,sp,48
    80002e5c:	8082                	ret
      addr = balloc(ip->dev);
    80002e5e:	0009a503          	lw	a0,0(s3)
    80002e62:	e45ff0ef          	jal	ra,80002ca6 <balloc>
    80002e66:	0005091b          	sext.w	s2,a0
      if(addr){
    80002e6a:	fc090ee3          	beqz	s2,80002e46 <bmap+0x8c>
        a[bn] = addr;
    80002e6e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002e72:	8552                	mv	a0,s4
    80002e74:	4f9000ef          	jal	ra,80003b6c <log_write>
    80002e78:	b7f9                	j	80002e46 <bmap+0x8c>
  panic("bmap: out of range");
    80002e7a:	00004517          	auipc	a0,0x4
    80002e7e:	76650513          	addi	a0,a0,1894 # 800075e0 <syscalls+0x120>
    80002e82:	8d5fd0ef          	jal	ra,80000756 <panic>

0000000080002e86 <iget>:
{
    80002e86:	7179                	addi	sp,sp,-48
    80002e88:	f406                	sd	ra,40(sp)
    80002e8a:	f022                	sd	s0,32(sp)
    80002e8c:	ec26                	sd	s1,24(sp)
    80002e8e:	e84a                	sd	s2,16(sp)
    80002e90:	e44e                	sd	s3,8(sp)
    80002e92:	e052                	sd	s4,0(sp)
    80002e94:	1800                	addi	s0,sp,48
    80002e96:	89aa                	mv	s3,a0
    80002e98:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e9a:	0001b517          	auipc	a0,0x1b
    80002e9e:	0fe50513          	addi	a0,a0,254 # 8001df98 <itable>
    80002ea2:	cf9fd0ef          	jal	ra,80000b9a <acquire>
  empty = 0;
    80002ea6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ea8:	0001b497          	auipc	s1,0x1b
    80002eac:	10848493          	addi	s1,s1,264 # 8001dfb0 <itable+0x18>
    80002eb0:	0001d697          	auipc	a3,0x1d
    80002eb4:	b9068693          	addi	a3,a3,-1136 # 8001fa40 <log>
    80002eb8:	a039                	j	80002ec6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002eba:	02090963          	beqz	s2,80002eec <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ebe:	08848493          	addi	s1,s1,136
    80002ec2:	02d48863          	beq	s1,a3,80002ef2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ec6:	449c                	lw	a5,8(s1)
    80002ec8:	fef059e3          	blez	a5,80002eba <iget+0x34>
    80002ecc:	4098                	lw	a4,0(s1)
    80002ece:	ff3716e3          	bne	a4,s3,80002eba <iget+0x34>
    80002ed2:	40d8                	lw	a4,4(s1)
    80002ed4:	ff4713e3          	bne	a4,s4,80002eba <iget+0x34>
      ip->ref++;
    80002ed8:	2785                	addiw	a5,a5,1
    80002eda:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002edc:	0001b517          	auipc	a0,0x1b
    80002ee0:	0bc50513          	addi	a0,a0,188 # 8001df98 <itable>
    80002ee4:	d4ffd0ef          	jal	ra,80000c32 <release>
      return ip;
    80002ee8:	8926                	mv	s2,s1
    80002eea:	a02d                	j	80002f14 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002eec:	fbe9                	bnez	a5,80002ebe <iget+0x38>
    80002eee:	8926                	mv	s2,s1
    80002ef0:	b7f9                	j	80002ebe <iget+0x38>
  if(empty == 0)
    80002ef2:	02090a63          	beqz	s2,80002f26 <iget+0xa0>
  ip->dev = dev;
    80002ef6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002efa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002efe:	4785                	li	a5,1
    80002f00:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002f04:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002f08:	0001b517          	auipc	a0,0x1b
    80002f0c:	09050513          	addi	a0,a0,144 # 8001df98 <itable>
    80002f10:	d23fd0ef          	jal	ra,80000c32 <release>
}
    80002f14:	854a                	mv	a0,s2
    80002f16:	70a2                	ld	ra,40(sp)
    80002f18:	7402                	ld	s0,32(sp)
    80002f1a:	64e2                	ld	s1,24(sp)
    80002f1c:	6942                	ld	s2,16(sp)
    80002f1e:	69a2                	ld	s3,8(sp)
    80002f20:	6a02                	ld	s4,0(sp)
    80002f22:	6145                	addi	sp,sp,48
    80002f24:	8082                	ret
    panic("iget: no inodes");
    80002f26:	00004517          	auipc	a0,0x4
    80002f2a:	6d250513          	addi	a0,a0,1746 # 800075f8 <syscalls+0x138>
    80002f2e:	829fd0ef          	jal	ra,80000756 <panic>

0000000080002f32 <fsinit>:
fsinit(int dev) {
    80002f32:	7179                	addi	sp,sp,-48
    80002f34:	f406                	sd	ra,40(sp)
    80002f36:	f022                	sd	s0,32(sp)
    80002f38:	ec26                	sd	s1,24(sp)
    80002f3a:	e84a                	sd	s2,16(sp)
    80002f3c:	e44e                	sd	s3,8(sp)
    80002f3e:	1800                	addi	s0,sp,48
    80002f40:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002f42:	4585                	li	a1,1
    80002f44:	afdff0ef          	jal	ra,80002a40 <bread>
    80002f48:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002f4a:	0001b997          	auipc	s3,0x1b
    80002f4e:	02e98993          	addi	s3,s3,46 # 8001df78 <sb>
    80002f52:	02000613          	li	a2,32
    80002f56:	05850593          	addi	a1,a0,88
    80002f5a:	854e                	mv	a0,s3
    80002f5c:	d6ffd0ef          	jal	ra,80000cca <memmove>
  brelse(bp);
    80002f60:	8526                	mv	a0,s1
    80002f62:	be7ff0ef          	jal	ra,80002b48 <brelse>
  if(sb.magic != FSMAGIC)
    80002f66:	0009a703          	lw	a4,0(s3)
    80002f6a:	102037b7          	lui	a5,0x10203
    80002f6e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f72:	02f71063          	bne	a4,a5,80002f92 <fsinit+0x60>
  initlog(dev, &sb);
    80002f76:	0001b597          	auipc	a1,0x1b
    80002f7a:	00258593          	addi	a1,a1,2 # 8001df78 <sb>
    80002f7e:	854a                	mv	a0,s2
    80002f80:	1d9000ef          	jal	ra,80003958 <initlog>
}
    80002f84:	70a2                	ld	ra,40(sp)
    80002f86:	7402                	ld	s0,32(sp)
    80002f88:	64e2                	ld	s1,24(sp)
    80002f8a:	6942                	ld	s2,16(sp)
    80002f8c:	69a2                	ld	s3,8(sp)
    80002f8e:	6145                	addi	sp,sp,48
    80002f90:	8082                	ret
    panic("invalid file system");
    80002f92:	00004517          	auipc	a0,0x4
    80002f96:	67650513          	addi	a0,a0,1654 # 80007608 <syscalls+0x148>
    80002f9a:	fbcfd0ef          	jal	ra,80000756 <panic>

0000000080002f9e <iinit>:
{
    80002f9e:	7179                	addi	sp,sp,-48
    80002fa0:	f406                	sd	ra,40(sp)
    80002fa2:	f022                	sd	s0,32(sp)
    80002fa4:	ec26                	sd	s1,24(sp)
    80002fa6:	e84a                	sd	s2,16(sp)
    80002fa8:	e44e                	sd	s3,8(sp)
    80002faa:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002fac:	00004597          	auipc	a1,0x4
    80002fb0:	67458593          	addi	a1,a1,1652 # 80007620 <syscalls+0x160>
    80002fb4:	0001b517          	auipc	a0,0x1b
    80002fb8:	fe450513          	addi	a0,a0,-28 # 8001df98 <itable>
    80002fbc:	b5ffd0ef          	jal	ra,80000b1a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002fc0:	0001b497          	auipc	s1,0x1b
    80002fc4:	00048493          	mv	s1,s1
    80002fc8:	0001d997          	auipc	s3,0x1d
    80002fcc:	a8898993          	addi	s3,s3,-1400 # 8001fa50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002fd0:	00004917          	auipc	s2,0x4
    80002fd4:	65890913          	addi	s2,s2,1624 # 80007628 <syscalls+0x168>
    80002fd8:	85ca                	mv	a1,s2
    80002fda:	8526                	mv	a0,s1
    80002fdc:	463000ef          	jal	ra,80003c3e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002fe0:	08848493          	addi	s1,s1,136 # 8001e048 <itable+0xb0>
    80002fe4:	ff349ae3          	bne	s1,s3,80002fd8 <iinit+0x3a>
}
    80002fe8:	70a2                	ld	ra,40(sp)
    80002fea:	7402                	ld	s0,32(sp)
    80002fec:	64e2                	ld	s1,24(sp)
    80002fee:	6942                	ld	s2,16(sp)
    80002ff0:	69a2                	ld	s3,8(sp)
    80002ff2:	6145                	addi	sp,sp,48
    80002ff4:	8082                	ret

0000000080002ff6 <ialloc>:
{
    80002ff6:	715d                	addi	sp,sp,-80
    80002ff8:	e486                	sd	ra,72(sp)
    80002ffa:	e0a2                	sd	s0,64(sp)
    80002ffc:	fc26                	sd	s1,56(sp)
    80002ffe:	f84a                	sd	s2,48(sp)
    80003000:	f44e                	sd	s3,40(sp)
    80003002:	f052                	sd	s4,32(sp)
    80003004:	ec56                	sd	s5,24(sp)
    80003006:	e85a                	sd	s6,16(sp)
    80003008:	e45e                	sd	s7,8(sp)
    8000300a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000300c:	0001b717          	auipc	a4,0x1b
    80003010:	f7872703          	lw	a4,-136(a4) # 8001df84 <sb+0xc>
    80003014:	4785                	li	a5,1
    80003016:	04e7f663          	bgeu	a5,a4,80003062 <ialloc+0x6c>
    8000301a:	8aaa                	mv	s5,a0
    8000301c:	8bae                	mv	s7,a1
    8000301e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003020:	0001ba17          	auipc	s4,0x1b
    80003024:	f58a0a13          	addi	s4,s4,-168 # 8001df78 <sb>
    80003028:	00048b1b          	sext.w	s6,s1
    8000302c:	0044d793          	srli	a5,s1,0x4
    80003030:	018a2583          	lw	a1,24(s4)
    80003034:	9dbd                	addw	a1,a1,a5
    80003036:	8556                	mv	a0,s5
    80003038:	a09ff0ef          	jal	ra,80002a40 <bread>
    8000303c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000303e:	05850993          	addi	s3,a0,88
    80003042:	00f4f793          	andi	a5,s1,15
    80003046:	079a                	slli	a5,a5,0x6
    80003048:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000304a:	00099783          	lh	a5,0(s3)
    8000304e:	cf85                	beqz	a5,80003086 <ialloc+0x90>
    brelse(bp);
    80003050:	af9ff0ef          	jal	ra,80002b48 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003054:	0485                	addi	s1,s1,1
    80003056:	00ca2703          	lw	a4,12(s4)
    8000305a:	0004879b          	sext.w	a5,s1
    8000305e:	fce7e5e3          	bltu	a5,a4,80003028 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003062:	00004517          	auipc	a0,0x4
    80003066:	5ce50513          	addi	a0,a0,1486 # 80007630 <syscalls+0x170>
    8000306a:	c38fd0ef          	jal	ra,800004a2 <printf>
  return 0;
    8000306e:	4501                	li	a0,0
}
    80003070:	60a6                	ld	ra,72(sp)
    80003072:	6406                	ld	s0,64(sp)
    80003074:	74e2                	ld	s1,56(sp)
    80003076:	7942                	ld	s2,48(sp)
    80003078:	79a2                	ld	s3,40(sp)
    8000307a:	7a02                	ld	s4,32(sp)
    8000307c:	6ae2                	ld	s5,24(sp)
    8000307e:	6b42                	ld	s6,16(sp)
    80003080:	6ba2                	ld	s7,8(sp)
    80003082:	6161                	addi	sp,sp,80
    80003084:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003086:	04000613          	li	a2,64
    8000308a:	4581                	li	a1,0
    8000308c:	854e                	mv	a0,s3
    8000308e:	be1fd0ef          	jal	ra,80000c6e <memset>
      dip->type = type;
    80003092:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003096:	854a                	mv	a0,s2
    80003098:	2d5000ef          	jal	ra,80003b6c <log_write>
      brelse(bp);
    8000309c:	854a                	mv	a0,s2
    8000309e:	aabff0ef          	jal	ra,80002b48 <brelse>
      return iget(dev, inum);
    800030a2:	85da                	mv	a1,s6
    800030a4:	8556                	mv	a0,s5
    800030a6:	de1ff0ef          	jal	ra,80002e86 <iget>
    800030aa:	b7d9                	j	80003070 <ialloc+0x7a>

00000000800030ac <iupdate>:
{
    800030ac:	1101                	addi	sp,sp,-32
    800030ae:	ec06                	sd	ra,24(sp)
    800030b0:	e822                	sd	s0,16(sp)
    800030b2:	e426                	sd	s1,8(sp)
    800030b4:	e04a                	sd	s2,0(sp)
    800030b6:	1000                	addi	s0,sp,32
    800030b8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800030ba:	415c                	lw	a5,4(a0)
    800030bc:	0047d79b          	srliw	a5,a5,0x4
    800030c0:	0001b597          	auipc	a1,0x1b
    800030c4:	ed05a583          	lw	a1,-304(a1) # 8001df90 <sb+0x18>
    800030c8:	9dbd                	addw	a1,a1,a5
    800030ca:	4108                	lw	a0,0(a0)
    800030cc:	975ff0ef          	jal	ra,80002a40 <bread>
    800030d0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800030d2:	05850793          	addi	a5,a0,88
    800030d6:	40c8                	lw	a0,4(s1)
    800030d8:	893d                	andi	a0,a0,15
    800030da:	051a                	slli	a0,a0,0x6
    800030dc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800030de:	04449703          	lh	a4,68(s1)
    800030e2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800030e6:	04649703          	lh	a4,70(s1)
    800030ea:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800030ee:	04849703          	lh	a4,72(s1)
    800030f2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800030f6:	04a49703          	lh	a4,74(s1)
    800030fa:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800030fe:	44f8                	lw	a4,76(s1)
    80003100:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003102:	03400613          	li	a2,52
    80003106:	05048593          	addi	a1,s1,80
    8000310a:	0531                	addi	a0,a0,12
    8000310c:	bbffd0ef          	jal	ra,80000cca <memmove>
  log_write(bp);
    80003110:	854a                	mv	a0,s2
    80003112:	25b000ef          	jal	ra,80003b6c <log_write>
  brelse(bp);
    80003116:	854a                	mv	a0,s2
    80003118:	a31ff0ef          	jal	ra,80002b48 <brelse>
}
    8000311c:	60e2                	ld	ra,24(sp)
    8000311e:	6442                	ld	s0,16(sp)
    80003120:	64a2                	ld	s1,8(sp)
    80003122:	6902                	ld	s2,0(sp)
    80003124:	6105                	addi	sp,sp,32
    80003126:	8082                	ret

0000000080003128 <idup>:
{
    80003128:	1101                	addi	sp,sp,-32
    8000312a:	ec06                	sd	ra,24(sp)
    8000312c:	e822                	sd	s0,16(sp)
    8000312e:	e426                	sd	s1,8(sp)
    80003130:	1000                	addi	s0,sp,32
    80003132:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003134:	0001b517          	auipc	a0,0x1b
    80003138:	e6450513          	addi	a0,a0,-412 # 8001df98 <itable>
    8000313c:	a5ffd0ef          	jal	ra,80000b9a <acquire>
  ip->ref++;
    80003140:	449c                	lw	a5,8(s1)
    80003142:	2785                	addiw	a5,a5,1
    80003144:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003146:	0001b517          	auipc	a0,0x1b
    8000314a:	e5250513          	addi	a0,a0,-430 # 8001df98 <itable>
    8000314e:	ae5fd0ef          	jal	ra,80000c32 <release>
}
    80003152:	8526                	mv	a0,s1
    80003154:	60e2                	ld	ra,24(sp)
    80003156:	6442                	ld	s0,16(sp)
    80003158:	64a2                	ld	s1,8(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret

000000008000315e <ilock>:
{
    8000315e:	1101                	addi	sp,sp,-32
    80003160:	ec06                	sd	ra,24(sp)
    80003162:	e822                	sd	s0,16(sp)
    80003164:	e426                	sd	s1,8(sp)
    80003166:	e04a                	sd	s2,0(sp)
    80003168:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000316a:	c105                	beqz	a0,8000318a <ilock+0x2c>
    8000316c:	84aa                	mv	s1,a0
    8000316e:	451c                	lw	a5,8(a0)
    80003170:	00f05d63          	blez	a5,8000318a <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003174:	0541                	addi	a0,a0,16
    80003176:	2ff000ef          	jal	ra,80003c74 <acquiresleep>
  if(ip->valid == 0){
    8000317a:	40bc                	lw	a5,64(s1)
    8000317c:	cf89                	beqz	a5,80003196 <ilock+0x38>
}
    8000317e:	60e2                	ld	ra,24(sp)
    80003180:	6442                	ld	s0,16(sp)
    80003182:	64a2                	ld	s1,8(sp)
    80003184:	6902                	ld	s2,0(sp)
    80003186:	6105                	addi	sp,sp,32
    80003188:	8082                	ret
    panic("ilock");
    8000318a:	00004517          	auipc	a0,0x4
    8000318e:	4be50513          	addi	a0,a0,1214 # 80007648 <syscalls+0x188>
    80003192:	dc4fd0ef          	jal	ra,80000756 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003196:	40dc                	lw	a5,4(s1)
    80003198:	0047d79b          	srliw	a5,a5,0x4
    8000319c:	0001b597          	auipc	a1,0x1b
    800031a0:	df45a583          	lw	a1,-524(a1) # 8001df90 <sb+0x18>
    800031a4:	9dbd                	addw	a1,a1,a5
    800031a6:	4088                	lw	a0,0(s1)
    800031a8:	899ff0ef          	jal	ra,80002a40 <bread>
    800031ac:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031ae:	05850593          	addi	a1,a0,88
    800031b2:	40dc                	lw	a5,4(s1)
    800031b4:	8bbd                	andi	a5,a5,15
    800031b6:	079a                	slli	a5,a5,0x6
    800031b8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800031ba:	00059783          	lh	a5,0(a1)
    800031be:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800031c2:	00259783          	lh	a5,2(a1)
    800031c6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800031ca:	00459783          	lh	a5,4(a1)
    800031ce:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800031d2:	00659783          	lh	a5,6(a1)
    800031d6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800031da:	459c                	lw	a5,8(a1)
    800031dc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800031de:	03400613          	li	a2,52
    800031e2:	05b1                	addi	a1,a1,12
    800031e4:	05048513          	addi	a0,s1,80
    800031e8:	ae3fd0ef          	jal	ra,80000cca <memmove>
    brelse(bp);
    800031ec:	854a                	mv	a0,s2
    800031ee:	95bff0ef          	jal	ra,80002b48 <brelse>
    ip->valid = 1;
    800031f2:	4785                	li	a5,1
    800031f4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800031f6:	04449783          	lh	a5,68(s1)
    800031fa:	f3d1                	bnez	a5,8000317e <ilock+0x20>
      panic("ilock: no type");
    800031fc:	00004517          	auipc	a0,0x4
    80003200:	45450513          	addi	a0,a0,1108 # 80007650 <syscalls+0x190>
    80003204:	d52fd0ef          	jal	ra,80000756 <panic>

0000000080003208 <iunlock>:
{
    80003208:	1101                	addi	sp,sp,-32
    8000320a:	ec06                	sd	ra,24(sp)
    8000320c:	e822                	sd	s0,16(sp)
    8000320e:	e426                	sd	s1,8(sp)
    80003210:	e04a                	sd	s2,0(sp)
    80003212:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003214:	c505                	beqz	a0,8000323c <iunlock+0x34>
    80003216:	84aa                	mv	s1,a0
    80003218:	01050913          	addi	s2,a0,16
    8000321c:	854a                	mv	a0,s2
    8000321e:	2d5000ef          	jal	ra,80003cf2 <holdingsleep>
    80003222:	cd09                	beqz	a0,8000323c <iunlock+0x34>
    80003224:	449c                	lw	a5,8(s1)
    80003226:	00f05b63          	blez	a5,8000323c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000322a:	854a                	mv	a0,s2
    8000322c:	28f000ef          	jal	ra,80003cba <releasesleep>
}
    80003230:	60e2                	ld	ra,24(sp)
    80003232:	6442                	ld	s0,16(sp)
    80003234:	64a2                	ld	s1,8(sp)
    80003236:	6902                	ld	s2,0(sp)
    80003238:	6105                	addi	sp,sp,32
    8000323a:	8082                	ret
    panic("iunlock");
    8000323c:	00004517          	auipc	a0,0x4
    80003240:	42450513          	addi	a0,a0,1060 # 80007660 <syscalls+0x1a0>
    80003244:	d12fd0ef          	jal	ra,80000756 <panic>

0000000080003248 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003248:	7179                	addi	sp,sp,-48
    8000324a:	f406                	sd	ra,40(sp)
    8000324c:	f022                	sd	s0,32(sp)
    8000324e:	ec26                	sd	s1,24(sp)
    80003250:	e84a                	sd	s2,16(sp)
    80003252:	e44e                	sd	s3,8(sp)
    80003254:	e052                	sd	s4,0(sp)
    80003256:	1800                	addi	s0,sp,48
    80003258:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000325a:	05050493          	addi	s1,a0,80
    8000325e:	08050913          	addi	s2,a0,128
    80003262:	a021                	j	8000326a <itrunc+0x22>
    80003264:	0491                	addi	s1,s1,4
    80003266:	01248b63          	beq	s1,s2,8000327c <itrunc+0x34>
    if(ip->addrs[i]){
    8000326a:	408c                	lw	a1,0(s1)
    8000326c:	dde5                	beqz	a1,80003264 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000326e:	0009a503          	lw	a0,0(s3)
    80003272:	9c9ff0ef          	jal	ra,80002c3a <bfree>
      ip->addrs[i] = 0;
    80003276:	0004a023          	sw	zero,0(s1)
    8000327a:	b7ed                	j	80003264 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000327c:	0809a583          	lw	a1,128(s3)
    80003280:	ed91                	bnez	a1,8000329c <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003282:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003286:	854e                	mv	a0,s3
    80003288:	e25ff0ef          	jal	ra,800030ac <iupdate>
}
    8000328c:	70a2                	ld	ra,40(sp)
    8000328e:	7402                	ld	s0,32(sp)
    80003290:	64e2                	ld	s1,24(sp)
    80003292:	6942                	ld	s2,16(sp)
    80003294:	69a2                	ld	s3,8(sp)
    80003296:	6a02                	ld	s4,0(sp)
    80003298:	6145                	addi	sp,sp,48
    8000329a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000329c:	0009a503          	lw	a0,0(s3)
    800032a0:	fa0ff0ef          	jal	ra,80002a40 <bread>
    800032a4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800032a6:	05850493          	addi	s1,a0,88
    800032aa:	45850913          	addi	s2,a0,1112
    800032ae:	a021                	j	800032b6 <itrunc+0x6e>
    800032b0:	0491                	addi	s1,s1,4
    800032b2:	01248963          	beq	s1,s2,800032c4 <itrunc+0x7c>
      if(a[j])
    800032b6:	408c                	lw	a1,0(s1)
    800032b8:	dde5                	beqz	a1,800032b0 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800032ba:	0009a503          	lw	a0,0(s3)
    800032be:	97dff0ef          	jal	ra,80002c3a <bfree>
    800032c2:	b7fd                	j	800032b0 <itrunc+0x68>
    brelse(bp);
    800032c4:	8552                	mv	a0,s4
    800032c6:	883ff0ef          	jal	ra,80002b48 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800032ca:	0809a583          	lw	a1,128(s3)
    800032ce:	0009a503          	lw	a0,0(s3)
    800032d2:	969ff0ef          	jal	ra,80002c3a <bfree>
    ip->addrs[NDIRECT] = 0;
    800032d6:	0809a023          	sw	zero,128(s3)
    800032da:	b765                	j	80003282 <itrunc+0x3a>

00000000800032dc <iput>:
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
    800032e8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032ea:	0001b517          	auipc	a0,0x1b
    800032ee:	cae50513          	addi	a0,a0,-850 # 8001df98 <itable>
    800032f2:	8a9fd0ef          	jal	ra,80000b9a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032f6:	4498                	lw	a4,8(s1)
    800032f8:	4785                	li	a5,1
    800032fa:	02f70163          	beq	a4,a5,8000331c <iput+0x40>
  ip->ref--;
    800032fe:	449c                	lw	a5,8(s1)
    80003300:	37fd                	addiw	a5,a5,-1
    80003302:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003304:	0001b517          	auipc	a0,0x1b
    80003308:	c9450513          	addi	a0,a0,-876 # 8001df98 <itable>
    8000330c:	927fd0ef          	jal	ra,80000c32 <release>
}
    80003310:	60e2                	ld	ra,24(sp)
    80003312:	6442                	ld	s0,16(sp)
    80003314:	64a2                	ld	s1,8(sp)
    80003316:	6902                	ld	s2,0(sp)
    80003318:	6105                	addi	sp,sp,32
    8000331a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000331c:	40bc                	lw	a5,64(s1)
    8000331e:	d3e5                	beqz	a5,800032fe <iput+0x22>
    80003320:	04a49783          	lh	a5,74(s1)
    80003324:	ffe9                	bnez	a5,800032fe <iput+0x22>
    acquiresleep(&ip->lock);
    80003326:	01048913          	addi	s2,s1,16
    8000332a:	854a                	mv	a0,s2
    8000332c:	149000ef          	jal	ra,80003c74 <acquiresleep>
    release(&itable.lock);
    80003330:	0001b517          	auipc	a0,0x1b
    80003334:	c6850513          	addi	a0,a0,-920 # 8001df98 <itable>
    80003338:	8fbfd0ef          	jal	ra,80000c32 <release>
    itrunc(ip);
    8000333c:	8526                	mv	a0,s1
    8000333e:	f0bff0ef          	jal	ra,80003248 <itrunc>
    ip->type = 0;
    80003342:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003346:	8526                	mv	a0,s1
    80003348:	d65ff0ef          	jal	ra,800030ac <iupdate>
    ip->valid = 0;
    8000334c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003350:	854a                	mv	a0,s2
    80003352:	169000ef          	jal	ra,80003cba <releasesleep>
    acquire(&itable.lock);
    80003356:	0001b517          	auipc	a0,0x1b
    8000335a:	c4250513          	addi	a0,a0,-958 # 8001df98 <itable>
    8000335e:	83dfd0ef          	jal	ra,80000b9a <acquire>
    80003362:	bf71                	j	800032fe <iput+0x22>

0000000080003364 <iunlockput>:
{
    80003364:	1101                	addi	sp,sp,-32
    80003366:	ec06                	sd	ra,24(sp)
    80003368:	e822                	sd	s0,16(sp)
    8000336a:	e426                	sd	s1,8(sp)
    8000336c:	1000                	addi	s0,sp,32
    8000336e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003370:	e99ff0ef          	jal	ra,80003208 <iunlock>
  iput(ip);
    80003374:	8526                	mv	a0,s1
    80003376:	f67ff0ef          	jal	ra,800032dc <iput>
}
    8000337a:	60e2                	ld	ra,24(sp)
    8000337c:	6442                	ld	s0,16(sp)
    8000337e:	64a2                	ld	s1,8(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003384:	1141                	addi	sp,sp,-16
    80003386:	e422                	sd	s0,8(sp)
    80003388:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000338a:	411c                	lw	a5,0(a0)
    8000338c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000338e:	415c                	lw	a5,4(a0)
    80003390:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003392:	04451783          	lh	a5,68(a0)
    80003396:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000339a:	04a51783          	lh	a5,74(a0)
    8000339e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800033a2:	04c56783          	lwu	a5,76(a0)
    800033a6:	e99c                	sd	a5,16(a1)
}
    800033a8:	6422                	ld	s0,8(sp)
    800033aa:	0141                	addi	sp,sp,16
    800033ac:	8082                	ret

00000000800033ae <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800033ae:	457c                	lw	a5,76(a0)
    800033b0:	0cd7ef63          	bltu	a5,a3,8000348e <readi+0xe0>
{
    800033b4:	7159                	addi	sp,sp,-112
    800033b6:	f486                	sd	ra,104(sp)
    800033b8:	f0a2                	sd	s0,96(sp)
    800033ba:	eca6                	sd	s1,88(sp)
    800033bc:	e8ca                	sd	s2,80(sp)
    800033be:	e4ce                	sd	s3,72(sp)
    800033c0:	e0d2                	sd	s4,64(sp)
    800033c2:	fc56                	sd	s5,56(sp)
    800033c4:	f85a                	sd	s6,48(sp)
    800033c6:	f45e                	sd	s7,40(sp)
    800033c8:	f062                	sd	s8,32(sp)
    800033ca:	ec66                	sd	s9,24(sp)
    800033cc:	e86a                	sd	s10,16(sp)
    800033ce:	e46e                	sd	s11,8(sp)
    800033d0:	1880                	addi	s0,sp,112
    800033d2:	8b2a                	mv	s6,a0
    800033d4:	8bae                	mv	s7,a1
    800033d6:	8a32                	mv	s4,a2
    800033d8:	84b6                	mv	s1,a3
    800033da:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800033dc:	9f35                	addw	a4,a4,a3
    return 0;
    800033de:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800033e0:	08d76663          	bltu	a4,a3,8000346c <readi+0xbe>
  if(off + n > ip->size)
    800033e4:	00e7f463          	bgeu	a5,a4,800033ec <readi+0x3e>
    n = ip->size - off;
    800033e8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033ec:	080a8f63          	beqz	s5,8000348a <readi+0xdc>
    800033f0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800033f2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800033f6:	5c7d                	li	s8,-1
    800033f8:	a80d                	j	8000342a <readi+0x7c>
    800033fa:	020d1d93          	slli	s11,s10,0x20
    800033fe:	020ddd93          	srli	s11,s11,0x20
    80003402:	05890793          	addi	a5,s2,88
    80003406:	86ee                	mv	a3,s11
    80003408:	963e                	add	a2,a2,a5
    8000340a:	85d2                	mv	a1,s4
    8000340c:	855e                	mv	a0,s7
    8000340e:	d01fe0ef          	jal	ra,8000210e <either_copyout>
    80003412:	05850763          	beq	a0,s8,80003460 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003416:	854a                	mv	a0,s2
    80003418:	f30ff0ef          	jal	ra,80002b48 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000341c:	013d09bb          	addw	s3,s10,s3
    80003420:	009d04bb          	addw	s1,s10,s1
    80003424:	9a6e                	add	s4,s4,s11
    80003426:	0559f163          	bgeu	s3,s5,80003468 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    8000342a:	00a4d59b          	srliw	a1,s1,0xa
    8000342e:	855a                	mv	a0,s6
    80003430:	98bff0ef          	jal	ra,80002dba <bmap>
    80003434:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003438:	c985                	beqz	a1,80003468 <readi+0xba>
    bp = bread(ip->dev, addr);
    8000343a:	000b2503          	lw	a0,0(s6)
    8000343e:	e02ff0ef          	jal	ra,80002a40 <bread>
    80003442:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003444:	3ff4f613          	andi	a2,s1,1023
    80003448:	40cc87bb          	subw	a5,s9,a2
    8000344c:	413a873b          	subw	a4,s5,s3
    80003450:	8d3e                	mv	s10,a5
    80003452:	2781                	sext.w	a5,a5
    80003454:	0007069b          	sext.w	a3,a4
    80003458:	faf6f1e3          	bgeu	a3,a5,800033fa <readi+0x4c>
    8000345c:	8d3a                	mv	s10,a4
    8000345e:	bf71                	j	800033fa <readi+0x4c>
      brelse(bp);
    80003460:	854a                	mv	a0,s2
    80003462:	ee6ff0ef          	jal	ra,80002b48 <brelse>
      tot = -1;
    80003466:	59fd                	li	s3,-1
  }
  return tot;
    80003468:	0009851b          	sext.w	a0,s3
}
    8000346c:	70a6                	ld	ra,104(sp)
    8000346e:	7406                	ld	s0,96(sp)
    80003470:	64e6                	ld	s1,88(sp)
    80003472:	6946                	ld	s2,80(sp)
    80003474:	69a6                	ld	s3,72(sp)
    80003476:	6a06                	ld	s4,64(sp)
    80003478:	7ae2                	ld	s5,56(sp)
    8000347a:	7b42                	ld	s6,48(sp)
    8000347c:	7ba2                	ld	s7,40(sp)
    8000347e:	7c02                	ld	s8,32(sp)
    80003480:	6ce2                	ld	s9,24(sp)
    80003482:	6d42                	ld	s10,16(sp)
    80003484:	6da2                	ld	s11,8(sp)
    80003486:	6165                	addi	sp,sp,112
    80003488:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000348a:	89d6                	mv	s3,s5
    8000348c:	bff1                	j	80003468 <readi+0xba>
    return 0;
    8000348e:	4501                	li	a0,0
}
    80003490:	8082                	ret

0000000080003492 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003492:	457c                	lw	a5,76(a0)
    80003494:	0ed7ea63          	bltu	a5,a3,80003588 <writei+0xf6>
{
    80003498:	7159                	addi	sp,sp,-112
    8000349a:	f486                	sd	ra,104(sp)
    8000349c:	f0a2                	sd	s0,96(sp)
    8000349e:	eca6                	sd	s1,88(sp)
    800034a0:	e8ca                	sd	s2,80(sp)
    800034a2:	e4ce                	sd	s3,72(sp)
    800034a4:	e0d2                	sd	s4,64(sp)
    800034a6:	fc56                	sd	s5,56(sp)
    800034a8:	f85a                	sd	s6,48(sp)
    800034aa:	f45e                	sd	s7,40(sp)
    800034ac:	f062                	sd	s8,32(sp)
    800034ae:	ec66                	sd	s9,24(sp)
    800034b0:	e86a                	sd	s10,16(sp)
    800034b2:	e46e                	sd	s11,8(sp)
    800034b4:	1880                	addi	s0,sp,112
    800034b6:	8aaa                	mv	s5,a0
    800034b8:	8bae                	mv	s7,a1
    800034ba:	8a32                	mv	s4,a2
    800034bc:	8936                	mv	s2,a3
    800034be:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800034c0:	00e687bb          	addw	a5,a3,a4
    800034c4:	0cd7e463          	bltu	a5,a3,8000358c <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800034c8:	00043737          	lui	a4,0x43
    800034cc:	0cf76263          	bltu	a4,a5,80003590 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800034d0:	0a0b0a63          	beqz	s6,80003584 <writei+0xf2>
    800034d4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034d6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800034da:	5c7d                	li	s8,-1
    800034dc:	a825                	j	80003514 <writei+0x82>
    800034de:	020d1d93          	slli	s11,s10,0x20
    800034e2:	020ddd93          	srli	s11,s11,0x20
    800034e6:	05848793          	addi	a5,s1,88
    800034ea:	86ee                	mv	a3,s11
    800034ec:	8652                	mv	a2,s4
    800034ee:	85de                	mv	a1,s7
    800034f0:	953e                	add	a0,a0,a5
    800034f2:	c67fe0ef          	jal	ra,80002158 <either_copyin>
    800034f6:	05850a63          	beq	a0,s8,8000354a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800034fa:	8526                	mv	a0,s1
    800034fc:	670000ef          	jal	ra,80003b6c <log_write>
    brelse(bp);
    80003500:	8526                	mv	a0,s1
    80003502:	e46ff0ef          	jal	ra,80002b48 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003506:	013d09bb          	addw	s3,s10,s3
    8000350a:	012d093b          	addw	s2,s10,s2
    8000350e:	9a6e                	add	s4,s4,s11
    80003510:	0569f063          	bgeu	s3,s6,80003550 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003514:	00a9559b          	srliw	a1,s2,0xa
    80003518:	8556                	mv	a0,s5
    8000351a:	8a1ff0ef          	jal	ra,80002dba <bmap>
    8000351e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003522:	c59d                	beqz	a1,80003550 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003524:	000aa503          	lw	a0,0(s5)
    80003528:	d18ff0ef          	jal	ra,80002a40 <bread>
    8000352c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000352e:	3ff97513          	andi	a0,s2,1023
    80003532:	40ac87bb          	subw	a5,s9,a0
    80003536:	413b073b          	subw	a4,s6,s3
    8000353a:	8d3e                	mv	s10,a5
    8000353c:	2781                	sext.w	a5,a5
    8000353e:	0007069b          	sext.w	a3,a4
    80003542:	f8f6fee3          	bgeu	a3,a5,800034de <writei+0x4c>
    80003546:	8d3a                	mv	s10,a4
    80003548:	bf59                	j	800034de <writei+0x4c>
      brelse(bp);
    8000354a:	8526                	mv	a0,s1
    8000354c:	dfcff0ef          	jal	ra,80002b48 <brelse>
  }

  if(off > ip->size)
    80003550:	04caa783          	lw	a5,76(s5)
    80003554:	0127f463          	bgeu	a5,s2,8000355c <writei+0xca>
    ip->size = off;
    80003558:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000355c:	8556                	mv	a0,s5
    8000355e:	b4fff0ef          	jal	ra,800030ac <iupdate>

  return tot;
    80003562:	0009851b          	sext.w	a0,s3
}
    80003566:	70a6                	ld	ra,104(sp)
    80003568:	7406                	ld	s0,96(sp)
    8000356a:	64e6                	ld	s1,88(sp)
    8000356c:	6946                	ld	s2,80(sp)
    8000356e:	69a6                	ld	s3,72(sp)
    80003570:	6a06                	ld	s4,64(sp)
    80003572:	7ae2                	ld	s5,56(sp)
    80003574:	7b42                	ld	s6,48(sp)
    80003576:	7ba2                	ld	s7,40(sp)
    80003578:	7c02                	ld	s8,32(sp)
    8000357a:	6ce2                	ld	s9,24(sp)
    8000357c:	6d42                	ld	s10,16(sp)
    8000357e:	6da2                	ld	s11,8(sp)
    80003580:	6165                	addi	sp,sp,112
    80003582:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003584:	89da                	mv	s3,s6
    80003586:	bfd9                	j	8000355c <writei+0xca>
    return -1;
    80003588:	557d                	li	a0,-1
}
    8000358a:	8082                	ret
    return -1;
    8000358c:	557d                	li	a0,-1
    8000358e:	bfe1                	j	80003566 <writei+0xd4>
    return -1;
    80003590:	557d                	li	a0,-1
    80003592:	bfd1                	j	80003566 <writei+0xd4>

0000000080003594 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003594:	1141                	addi	sp,sp,-16
    80003596:	e406                	sd	ra,8(sp)
    80003598:	e022                	sd	s0,0(sp)
    8000359a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000359c:	4639                	li	a2,14
    8000359e:	f9cfd0ef          	jal	ra,80000d3a <strncmp>
}
    800035a2:	60a2                	ld	ra,8(sp)
    800035a4:	6402                	ld	s0,0(sp)
    800035a6:	0141                	addi	sp,sp,16
    800035a8:	8082                	ret

00000000800035aa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800035aa:	7139                	addi	sp,sp,-64
    800035ac:	fc06                	sd	ra,56(sp)
    800035ae:	f822                	sd	s0,48(sp)
    800035b0:	f426                	sd	s1,40(sp)
    800035b2:	f04a                	sd	s2,32(sp)
    800035b4:	ec4e                	sd	s3,24(sp)
    800035b6:	e852                	sd	s4,16(sp)
    800035b8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800035ba:	04451703          	lh	a4,68(a0)
    800035be:	4785                	li	a5,1
    800035c0:	00f71a63          	bne	a4,a5,800035d4 <dirlookup+0x2a>
    800035c4:	892a                	mv	s2,a0
    800035c6:	89ae                	mv	s3,a1
    800035c8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800035ca:	457c                	lw	a5,76(a0)
    800035cc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800035ce:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035d0:	e39d                	bnez	a5,800035f6 <dirlookup+0x4c>
    800035d2:	a095                	j	80003636 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800035d4:	00004517          	auipc	a0,0x4
    800035d8:	09450513          	addi	a0,a0,148 # 80007668 <syscalls+0x1a8>
    800035dc:	97afd0ef          	jal	ra,80000756 <panic>
      panic("dirlookup read");
    800035e0:	00004517          	auipc	a0,0x4
    800035e4:	0a050513          	addi	a0,a0,160 # 80007680 <syscalls+0x1c0>
    800035e8:	96efd0ef          	jal	ra,80000756 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035ec:	24c1                	addiw	s1,s1,16
    800035ee:	04c92783          	lw	a5,76(s2)
    800035f2:	04f4f163          	bgeu	s1,a5,80003634 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035f6:	4741                	li	a4,16
    800035f8:	86a6                	mv	a3,s1
    800035fa:	fc040613          	addi	a2,s0,-64
    800035fe:	4581                	li	a1,0
    80003600:	854a                	mv	a0,s2
    80003602:	dadff0ef          	jal	ra,800033ae <readi>
    80003606:	47c1                	li	a5,16
    80003608:	fcf51ce3          	bne	a0,a5,800035e0 <dirlookup+0x36>
    if(de.inum == 0)
    8000360c:	fc045783          	lhu	a5,-64(s0)
    80003610:	dff1                	beqz	a5,800035ec <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003612:	fc240593          	addi	a1,s0,-62
    80003616:	854e                	mv	a0,s3
    80003618:	f7dff0ef          	jal	ra,80003594 <namecmp>
    8000361c:	f961                	bnez	a0,800035ec <dirlookup+0x42>
      if(poff)
    8000361e:	000a0463          	beqz	s4,80003626 <dirlookup+0x7c>
        *poff = off;
    80003622:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003626:	fc045583          	lhu	a1,-64(s0)
    8000362a:	00092503          	lw	a0,0(s2)
    8000362e:	859ff0ef          	jal	ra,80002e86 <iget>
    80003632:	a011                	j	80003636 <dirlookup+0x8c>
  return 0;
    80003634:	4501                	li	a0,0
}
    80003636:	70e2                	ld	ra,56(sp)
    80003638:	7442                	ld	s0,48(sp)
    8000363a:	74a2                	ld	s1,40(sp)
    8000363c:	7902                	ld	s2,32(sp)
    8000363e:	69e2                	ld	s3,24(sp)
    80003640:	6a42                	ld	s4,16(sp)
    80003642:	6121                	addi	sp,sp,64
    80003644:	8082                	ret

0000000080003646 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003646:	711d                	addi	sp,sp,-96
    80003648:	ec86                	sd	ra,88(sp)
    8000364a:	e8a2                	sd	s0,80(sp)
    8000364c:	e4a6                	sd	s1,72(sp)
    8000364e:	e0ca                	sd	s2,64(sp)
    80003650:	fc4e                	sd	s3,56(sp)
    80003652:	f852                	sd	s4,48(sp)
    80003654:	f456                	sd	s5,40(sp)
    80003656:	f05a                	sd	s6,32(sp)
    80003658:	ec5e                	sd	s7,24(sp)
    8000365a:	e862                	sd	s8,16(sp)
    8000365c:	e466                	sd	s9,8(sp)
    8000365e:	1080                	addi	s0,sp,96
    80003660:	84aa                	mv	s1,a0
    80003662:	8aae                	mv	s5,a1
    80003664:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003666:	00054703          	lbu	a4,0(a0)
    8000366a:	02f00793          	li	a5,47
    8000366e:	00f70f63          	beq	a4,a5,8000368c <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003672:	974fe0ef          	jal	ra,800017e6 <myproc>
    80003676:	15053503          	ld	a0,336(a0)
    8000367a:	aafff0ef          	jal	ra,80003128 <idup>
    8000367e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003680:	02f00913          	li	s2,47
  len = path - s;
    80003684:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003686:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003688:	4b85                	li	s7,1
    8000368a:	a861                	j	80003722 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    8000368c:	4585                	li	a1,1
    8000368e:	4505                	li	a0,1
    80003690:	ff6ff0ef          	jal	ra,80002e86 <iget>
    80003694:	89aa                	mv	s3,a0
    80003696:	b7ed                	j	80003680 <namex+0x3a>
      iunlockput(ip);
    80003698:	854e                	mv	a0,s3
    8000369a:	ccbff0ef          	jal	ra,80003364 <iunlockput>
      return 0;
    8000369e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800036a0:	854e                	mv	a0,s3
    800036a2:	60e6                	ld	ra,88(sp)
    800036a4:	6446                	ld	s0,80(sp)
    800036a6:	64a6                	ld	s1,72(sp)
    800036a8:	6906                	ld	s2,64(sp)
    800036aa:	79e2                	ld	s3,56(sp)
    800036ac:	7a42                	ld	s4,48(sp)
    800036ae:	7aa2                	ld	s5,40(sp)
    800036b0:	7b02                	ld	s6,32(sp)
    800036b2:	6be2                	ld	s7,24(sp)
    800036b4:	6c42                	ld	s8,16(sp)
    800036b6:	6ca2                	ld	s9,8(sp)
    800036b8:	6125                	addi	sp,sp,96
    800036ba:	8082                	ret
      iunlock(ip);
    800036bc:	854e                	mv	a0,s3
    800036be:	b4bff0ef          	jal	ra,80003208 <iunlock>
      return ip;
    800036c2:	bff9                	j	800036a0 <namex+0x5a>
      iunlockput(ip);
    800036c4:	854e                	mv	a0,s3
    800036c6:	c9fff0ef          	jal	ra,80003364 <iunlockput>
      return 0;
    800036ca:	89e6                	mv	s3,s9
    800036cc:	bfd1                	j	800036a0 <namex+0x5a>
  len = path - s;
    800036ce:	40b48633          	sub	a2,s1,a1
    800036d2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800036d6:	079c5c63          	bge	s8,s9,8000374e <namex+0x108>
    memmove(name, s, DIRSIZ);
    800036da:	4639                	li	a2,14
    800036dc:	8552                	mv	a0,s4
    800036de:	decfd0ef          	jal	ra,80000cca <memmove>
  while(*path == '/')
    800036e2:	0004c783          	lbu	a5,0(s1)
    800036e6:	01279763          	bne	a5,s2,800036f4 <namex+0xae>
    path++;
    800036ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800036ec:	0004c783          	lbu	a5,0(s1)
    800036f0:	ff278de3          	beq	a5,s2,800036ea <namex+0xa4>
    ilock(ip);
    800036f4:	854e                	mv	a0,s3
    800036f6:	a69ff0ef          	jal	ra,8000315e <ilock>
    if(ip->type != T_DIR){
    800036fa:	04499783          	lh	a5,68(s3)
    800036fe:	f9779de3          	bne	a5,s7,80003698 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80003702:	000a8563          	beqz	s5,8000370c <namex+0xc6>
    80003706:	0004c783          	lbu	a5,0(s1)
    8000370a:	dbcd                	beqz	a5,800036bc <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000370c:	865a                	mv	a2,s6
    8000370e:	85d2                	mv	a1,s4
    80003710:	854e                	mv	a0,s3
    80003712:	e99ff0ef          	jal	ra,800035aa <dirlookup>
    80003716:	8caa                	mv	s9,a0
    80003718:	d555                	beqz	a0,800036c4 <namex+0x7e>
    iunlockput(ip);
    8000371a:	854e                	mv	a0,s3
    8000371c:	c49ff0ef          	jal	ra,80003364 <iunlockput>
    ip = next;
    80003720:	89e6                	mv	s3,s9
  while(*path == '/')
    80003722:	0004c783          	lbu	a5,0(s1)
    80003726:	05279363          	bne	a5,s2,8000376c <namex+0x126>
    path++;
    8000372a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000372c:	0004c783          	lbu	a5,0(s1)
    80003730:	ff278de3          	beq	a5,s2,8000372a <namex+0xe4>
  if(*path == 0)
    80003734:	c78d                	beqz	a5,8000375e <namex+0x118>
    path++;
    80003736:	85a6                	mv	a1,s1
  len = path - s;
    80003738:	8cda                	mv	s9,s6
    8000373a:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000373c:	01278963          	beq	a5,s2,8000374e <namex+0x108>
    80003740:	d7d9                	beqz	a5,800036ce <namex+0x88>
    path++;
    80003742:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003744:	0004c783          	lbu	a5,0(s1)
    80003748:	ff279ce3          	bne	a5,s2,80003740 <namex+0xfa>
    8000374c:	b749                	j	800036ce <namex+0x88>
    memmove(name, s, len);
    8000374e:	2601                	sext.w	a2,a2
    80003750:	8552                	mv	a0,s4
    80003752:	d78fd0ef          	jal	ra,80000cca <memmove>
    name[len] = 0;
    80003756:	9cd2                	add	s9,s9,s4
    80003758:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000375c:	b759                	j	800036e2 <namex+0x9c>
  if(nameiparent){
    8000375e:	f40a81e3          	beqz	s5,800036a0 <namex+0x5a>
    iput(ip);
    80003762:	854e                	mv	a0,s3
    80003764:	b79ff0ef          	jal	ra,800032dc <iput>
    return 0;
    80003768:	4981                	li	s3,0
    8000376a:	bf1d                	j	800036a0 <namex+0x5a>
  if(*path == 0)
    8000376c:	dbed                	beqz	a5,8000375e <namex+0x118>
  while(*path != '/' && *path != 0)
    8000376e:	0004c783          	lbu	a5,0(s1)
    80003772:	85a6                	mv	a1,s1
    80003774:	b7f1                	j	80003740 <namex+0xfa>

0000000080003776 <dirlink>:
{
    80003776:	7139                	addi	sp,sp,-64
    80003778:	fc06                	sd	ra,56(sp)
    8000377a:	f822                	sd	s0,48(sp)
    8000377c:	f426                	sd	s1,40(sp)
    8000377e:	f04a                	sd	s2,32(sp)
    80003780:	ec4e                	sd	s3,24(sp)
    80003782:	e852                	sd	s4,16(sp)
    80003784:	0080                	addi	s0,sp,64
    80003786:	892a                	mv	s2,a0
    80003788:	8a2e                	mv	s4,a1
    8000378a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000378c:	4601                	li	a2,0
    8000378e:	e1dff0ef          	jal	ra,800035aa <dirlookup>
    80003792:	e52d                	bnez	a0,800037fc <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003794:	04c92483          	lw	s1,76(s2)
    80003798:	c48d                	beqz	s1,800037c2 <dirlink+0x4c>
    8000379a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000379c:	4741                	li	a4,16
    8000379e:	86a6                	mv	a3,s1
    800037a0:	fc040613          	addi	a2,s0,-64
    800037a4:	4581                	li	a1,0
    800037a6:	854a                	mv	a0,s2
    800037a8:	c07ff0ef          	jal	ra,800033ae <readi>
    800037ac:	47c1                	li	a5,16
    800037ae:	04f51b63          	bne	a0,a5,80003804 <dirlink+0x8e>
    if(de.inum == 0)
    800037b2:	fc045783          	lhu	a5,-64(s0)
    800037b6:	c791                	beqz	a5,800037c2 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037b8:	24c1                	addiw	s1,s1,16
    800037ba:	04c92783          	lw	a5,76(s2)
    800037be:	fcf4efe3          	bltu	s1,a5,8000379c <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800037c2:	4639                	li	a2,14
    800037c4:	85d2                	mv	a1,s4
    800037c6:	fc240513          	addi	a0,s0,-62
    800037ca:	dacfd0ef          	jal	ra,80000d76 <strncpy>
  de.inum = inum;
    800037ce:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037d2:	4741                	li	a4,16
    800037d4:	86a6                	mv	a3,s1
    800037d6:	fc040613          	addi	a2,s0,-64
    800037da:	4581                	li	a1,0
    800037dc:	854a                	mv	a0,s2
    800037de:	cb5ff0ef          	jal	ra,80003492 <writei>
    800037e2:	1541                	addi	a0,a0,-16
    800037e4:	00a03533          	snez	a0,a0
    800037e8:	40a00533          	neg	a0,a0
}
    800037ec:	70e2                	ld	ra,56(sp)
    800037ee:	7442                	ld	s0,48(sp)
    800037f0:	74a2                	ld	s1,40(sp)
    800037f2:	7902                	ld	s2,32(sp)
    800037f4:	69e2                	ld	s3,24(sp)
    800037f6:	6a42                	ld	s4,16(sp)
    800037f8:	6121                	addi	sp,sp,64
    800037fa:	8082                	ret
    iput(ip);
    800037fc:	ae1ff0ef          	jal	ra,800032dc <iput>
    return -1;
    80003800:	557d                	li	a0,-1
    80003802:	b7ed                	j	800037ec <dirlink+0x76>
      panic("dirlink read");
    80003804:	00004517          	auipc	a0,0x4
    80003808:	e8c50513          	addi	a0,a0,-372 # 80007690 <syscalls+0x1d0>
    8000380c:	f4bfc0ef          	jal	ra,80000756 <panic>

0000000080003810 <namei>:

struct inode*
namei(char *path)
{
    80003810:	1101                	addi	sp,sp,-32
    80003812:	ec06                	sd	ra,24(sp)
    80003814:	e822                	sd	s0,16(sp)
    80003816:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003818:	fe040613          	addi	a2,s0,-32
    8000381c:	4581                	li	a1,0
    8000381e:	e29ff0ef          	jal	ra,80003646 <namex>
}
    80003822:	60e2                	ld	ra,24(sp)
    80003824:	6442                	ld	s0,16(sp)
    80003826:	6105                	addi	sp,sp,32
    80003828:	8082                	ret

000000008000382a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000382a:	1141                	addi	sp,sp,-16
    8000382c:	e406                	sd	ra,8(sp)
    8000382e:	e022                	sd	s0,0(sp)
    80003830:	0800                	addi	s0,sp,16
    80003832:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003834:	4585                	li	a1,1
    80003836:	e11ff0ef          	jal	ra,80003646 <namex>
}
    8000383a:	60a2                	ld	ra,8(sp)
    8000383c:	6402                	ld	s0,0(sp)
    8000383e:	0141                	addi	sp,sp,16
    80003840:	8082                	ret

0000000080003842 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003842:	1101                	addi	sp,sp,-32
    80003844:	ec06                	sd	ra,24(sp)
    80003846:	e822                	sd	s0,16(sp)
    80003848:	e426                	sd	s1,8(sp)
    8000384a:	e04a                	sd	s2,0(sp)
    8000384c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000384e:	0001c917          	auipc	s2,0x1c
    80003852:	1f290913          	addi	s2,s2,498 # 8001fa40 <log>
    80003856:	01892583          	lw	a1,24(s2)
    8000385a:	02892503          	lw	a0,40(s2)
    8000385e:	9e2ff0ef          	jal	ra,80002a40 <bread>
    80003862:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003864:	02c92683          	lw	a3,44(s2)
    80003868:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000386a:	02d05763          	blez	a3,80003898 <write_head+0x56>
    8000386e:	0001c797          	auipc	a5,0x1c
    80003872:	20278793          	addi	a5,a5,514 # 8001fa70 <log+0x30>
    80003876:	05c50713          	addi	a4,a0,92
    8000387a:	36fd                	addiw	a3,a3,-1
    8000387c:	1682                	slli	a3,a3,0x20
    8000387e:	9281                	srli	a3,a3,0x20
    80003880:	068a                	slli	a3,a3,0x2
    80003882:	0001c617          	auipc	a2,0x1c
    80003886:	1f260613          	addi	a2,a2,498 # 8001fa74 <log+0x34>
    8000388a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000388c:	4390                	lw	a2,0(a5)
    8000388e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003890:	0791                	addi	a5,a5,4
    80003892:	0711                	addi	a4,a4,4
    80003894:	fed79ce3          	bne	a5,a3,8000388c <write_head+0x4a>
  }
  bwrite(buf);
    80003898:	8526                	mv	a0,s1
    8000389a:	a7cff0ef          	jal	ra,80002b16 <bwrite>
  brelse(buf);
    8000389e:	8526                	mv	a0,s1
    800038a0:	aa8ff0ef          	jal	ra,80002b48 <brelse>
}
    800038a4:	60e2                	ld	ra,24(sp)
    800038a6:	6442                	ld	s0,16(sp)
    800038a8:	64a2                	ld	s1,8(sp)
    800038aa:	6902                	ld	s2,0(sp)
    800038ac:	6105                	addi	sp,sp,32
    800038ae:	8082                	ret

00000000800038b0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800038b0:	0001c797          	auipc	a5,0x1c
    800038b4:	1bc7a783          	lw	a5,444(a5) # 8001fa6c <log+0x2c>
    800038b8:	08f05f63          	blez	a5,80003956 <install_trans+0xa6>
{
    800038bc:	7139                	addi	sp,sp,-64
    800038be:	fc06                	sd	ra,56(sp)
    800038c0:	f822                	sd	s0,48(sp)
    800038c2:	f426                	sd	s1,40(sp)
    800038c4:	f04a                	sd	s2,32(sp)
    800038c6:	ec4e                	sd	s3,24(sp)
    800038c8:	e852                	sd	s4,16(sp)
    800038ca:	e456                	sd	s5,8(sp)
    800038cc:	e05a                	sd	s6,0(sp)
    800038ce:	0080                	addi	s0,sp,64
    800038d0:	8b2a                	mv	s6,a0
    800038d2:	0001ca97          	auipc	s5,0x1c
    800038d6:	19ea8a93          	addi	s5,s5,414 # 8001fa70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038da:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800038dc:	0001c997          	auipc	s3,0x1c
    800038e0:	16498993          	addi	s3,s3,356 # 8001fa40 <log>
    800038e4:	a829                	j	800038fe <install_trans+0x4e>
    brelse(lbuf);
    800038e6:	854a                	mv	a0,s2
    800038e8:	a60ff0ef          	jal	ra,80002b48 <brelse>
    brelse(dbuf);
    800038ec:	8526                	mv	a0,s1
    800038ee:	a5aff0ef          	jal	ra,80002b48 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f2:	2a05                	addiw	s4,s4,1
    800038f4:	0a91                	addi	s5,s5,4
    800038f6:	02c9a783          	lw	a5,44(s3)
    800038fa:	04fa5463          	bge	s4,a5,80003942 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800038fe:	0189a583          	lw	a1,24(s3)
    80003902:	014585bb          	addw	a1,a1,s4
    80003906:	2585                	addiw	a1,a1,1
    80003908:	0289a503          	lw	a0,40(s3)
    8000390c:	934ff0ef          	jal	ra,80002a40 <bread>
    80003910:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003912:	000aa583          	lw	a1,0(s5)
    80003916:	0289a503          	lw	a0,40(s3)
    8000391a:	926ff0ef          	jal	ra,80002a40 <bread>
    8000391e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003920:	40000613          	li	a2,1024
    80003924:	05890593          	addi	a1,s2,88
    80003928:	05850513          	addi	a0,a0,88
    8000392c:	b9efd0ef          	jal	ra,80000cca <memmove>
    bwrite(dbuf);  // write dst to disk
    80003930:	8526                	mv	a0,s1
    80003932:	9e4ff0ef          	jal	ra,80002b16 <bwrite>
    if(recovering == 0)
    80003936:	fa0b18e3          	bnez	s6,800038e6 <install_trans+0x36>
      bunpin(dbuf);
    8000393a:	8526                	mv	a0,s1
    8000393c:	acaff0ef          	jal	ra,80002c06 <bunpin>
    80003940:	b75d                	j	800038e6 <install_trans+0x36>
}
    80003942:	70e2                	ld	ra,56(sp)
    80003944:	7442                	ld	s0,48(sp)
    80003946:	74a2                	ld	s1,40(sp)
    80003948:	7902                	ld	s2,32(sp)
    8000394a:	69e2                	ld	s3,24(sp)
    8000394c:	6a42                	ld	s4,16(sp)
    8000394e:	6aa2                	ld	s5,8(sp)
    80003950:	6b02                	ld	s6,0(sp)
    80003952:	6121                	addi	sp,sp,64
    80003954:	8082                	ret
    80003956:	8082                	ret

0000000080003958 <initlog>:
{
    80003958:	7179                	addi	sp,sp,-48
    8000395a:	f406                	sd	ra,40(sp)
    8000395c:	f022                	sd	s0,32(sp)
    8000395e:	ec26                	sd	s1,24(sp)
    80003960:	e84a                	sd	s2,16(sp)
    80003962:	e44e                	sd	s3,8(sp)
    80003964:	1800                	addi	s0,sp,48
    80003966:	892a                	mv	s2,a0
    80003968:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000396a:	0001c497          	auipc	s1,0x1c
    8000396e:	0d648493          	addi	s1,s1,214 # 8001fa40 <log>
    80003972:	00004597          	auipc	a1,0x4
    80003976:	d2e58593          	addi	a1,a1,-722 # 800076a0 <syscalls+0x1e0>
    8000397a:	8526                	mv	a0,s1
    8000397c:	99efd0ef          	jal	ra,80000b1a <initlock>
  log.start = sb->logstart;
    80003980:	0149a583          	lw	a1,20(s3)
    80003984:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003986:	0109a783          	lw	a5,16(s3)
    8000398a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000398c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003990:	854a                	mv	a0,s2
    80003992:	8aeff0ef          	jal	ra,80002a40 <bread>
  log.lh.n = lh->n;
    80003996:	4d34                	lw	a3,88(a0)
    80003998:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000399a:	02d05563          	blez	a3,800039c4 <initlog+0x6c>
    8000399e:	05c50793          	addi	a5,a0,92
    800039a2:	0001c717          	auipc	a4,0x1c
    800039a6:	0ce70713          	addi	a4,a4,206 # 8001fa70 <log+0x30>
    800039aa:	36fd                	addiw	a3,a3,-1
    800039ac:	1682                	slli	a3,a3,0x20
    800039ae:	9281                	srli	a3,a3,0x20
    800039b0:	068a                	slli	a3,a3,0x2
    800039b2:	06050613          	addi	a2,a0,96
    800039b6:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800039b8:	4390                	lw	a2,0(a5)
    800039ba:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800039bc:	0791                	addi	a5,a5,4
    800039be:	0711                	addi	a4,a4,4
    800039c0:	fed79ce3          	bne	a5,a3,800039b8 <initlog+0x60>
  brelse(buf);
    800039c4:	984ff0ef          	jal	ra,80002b48 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800039c8:	4505                	li	a0,1
    800039ca:	ee7ff0ef          	jal	ra,800038b0 <install_trans>
  log.lh.n = 0;
    800039ce:	0001c797          	auipc	a5,0x1c
    800039d2:	0807af23          	sw	zero,158(a5) # 8001fa6c <log+0x2c>
  write_head(); // clear the log
    800039d6:	e6dff0ef          	jal	ra,80003842 <write_head>
}
    800039da:	70a2                	ld	ra,40(sp)
    800039dc:	7402                	ld	s0,32(sp)
    800039de:	64e2                	ld	s1,24(sp)
    800039e0:	6942                	ld	s2,16(sp)
    800039e2:	69a2                	ld	s3,8(sp)
    800039e4:	6145                	addi	sp,sp,48
    800039e6:	8082                	ret

00000000800039e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800039e8:	1101                	addi	sp,sp,-32
    800039ea:	ec06                	sd	ra,24(sp)
    800039ec:	e822                	sd	s0,16(sp)
    800039ee:	e426                	sd	s1,8(sp)
    800039f0:	e04a                	sd	s2,0(sp)
    800039f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800039f4:	0001c517          	auipc	a0,0x1c
    800039f8:	04c50513          	addi	a0,a0,76 # 8001fa40 <log>
    800039fc:	99efd0ef          	jal	ra,80000b9a <acquire>
  while(1){
    if(log.committing){
    80003a00:	0001c497          	auipc	s1,0x1c
    80003a04:	04048493          	addi	s1,s1,64 # 8001fa40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a08:	4979                	li	s2,30
    80003a0a:	a029                	j	80003a14 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003a0c:	85a6                	mv	a1,s1
    80003a0e:	8526                	mv	a0,s1
    80003a10:	ba2fe0ef          	jal	ra,80001db2 <sleep>
    if(log.committing){
    80003a14:	50dc                	lw	a5,36(s1)
    80003a16:	fbfd                	bnez	a5,80003a0c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a18:	509c                	lw	a5,32(s1)
    80003a1a:	0017871b          	addiw	a4,a5,1
    80003a1e:	0007069b          	sext.w	a3,a4
    80003a22:	0027179b          	slliw	a5,a4,0x2
    80003a26:	9fb9                	addw	a5,a5,a4
    80003a28:	0017979b          	slliw	a5,a5,0x1
    80003a2c:	54d8                	lw	a4,44(s1)
    80003a2e:	9fb9                	addw	a5,a5,a4
    80003a30:	00f95763          	bge	s2,a5,80003a3e <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003a34:	85a6                	mv	a1,s1
    80003a36:	8526                	mv	a0,s1
    80003a38:	b7afe0ef          	jal	ra,80001db2 <sleep>
    80003a3c:	bfe1                	j	80003a14 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003a3e:	0001c517          	auipc	a0,0x1c
    80003a42:	00250513          	addi	a0,a0,2 # 8001fa40 <log>
    80003a46:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003a48:	9eafd0ef          	jal	ra,80000c32 <release>
      break;
    }
  }
}
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6902                	ld	s2,0(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003a58:	7139                	addi	sp,sp,-64
    80003a5a:	fc06                	sd	ra,56(sp)
    80003a5c:	f822                	sd	s0,48(sp)
    80003a5e:	f426                	sd	s1,40(sp)
    80003a60:	f04a                	sd	s2,32(sp)
    80003a62:	ec4e                	sd	s3,24(sp)
    80003a64:	e852                	sd	s4,16(sp)
    80003a66:	e456                	sd	s5,8(sp)
    80003a68:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003a6a:	0001c497          	auipc	s1,0x1c
    80003a6e:	fd648493          	addi	s1,s1,-42 # 8001fa40 <log>
    80003a72:	8526                	mv	a0,s1
    80003a74:	926fd0ef          	jal	ra,80000b9a <acquire>
  log.outstanding -= 1;
    80003a78:	509c                	lw	a5,32(s1)
    80003a7a:	37fd                	addiw	a5,a5,-1
    80003a7c:	0007891b          	sext.w	s2,a5
    80003a80:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003a82:	50dc                	lw	a5,36(s1)
    80003a84:	ef9d                	bnez	a5,80003ac2 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003a86:	04091463          	bnez	s2,80003ace <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003a8a:	0001c497          	auipc	s1,0x1c
    80003a8e:	fb648493          	addi	s1,s1,-74 # 8001fa40 <log>
    80003a92:	4785                	li	a5,1
    80003a94:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003a96:	8526                	mv	a0,s1
    80003a98:	99afd0ef          	jal	ra,80000c32 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a9c:	54dc                	lw	a5,44(s1)
    80003a9e:	04f04b63          	bgtz	a5,80003af4 <end_op+0x9c>
    acquire(&log.lock);
    80003aa2:	0001c497          	auipc	s1,0x1c
    80003aa6:	f9e48493          	addi	s1,s1,-98 # 8001fa40 <log>
    80003aaa:	8526                	mv	a0,s1
    80003aac:	8eefd0ef          	jal	ra,80000b9a <acquire>
    log.committing = 0;
    80003ab0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	b48fe0ef          	jal	ra,80001dfe <wakeup>
    release(&log.lock);
    80003aba:	8526                	mv	a0,s1
    80003abc:	976fd0ef          	jal	ra,80000c32 <release>
}
    80003ac0:	a00d                	j	80003ae2 <end_op+0x8a>
    panic("log.committing");
    80003ac2:	00004517          	auipc	a0,0x4
    80003ac6:	be650513          	addi	a0,a0,-1050 # 800076a8 <syscalls+0x1e8>
    80003aca:	c8dfc0ef          	jal	ra,80000756 <panic>
    wakeup(&log);
    80003ace:	0001c497          	auipc	s1,0x1c
    80003ad2:	f7248493          	addi	s1,s1,-142 # 8001fa40 <log>
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	b26fe0ef          	jal	ra,80001dfe <wakeup>
  release(&log.lock);
    80003adc:	8526                	mv	a0,s1
    80003ade:	954fd0ef          	jal	ra,80000c32 <release>
}
    80003ae2:	70e2                	ld	ra,56(sp)
    80003ae4:	7442                	ld	s0,48(sp)
    80003ae6:	74a2                	ld	s1,40(sp)
    80003ae8:	7902                	ld	s2,32(sp)
    80003aea:	69e2                	ld	s3,24(sp)
    80003aec:	6a42                	ld	s4,16(sp)
    80003aee:	6aa2                	ld	s5,8(sp)
    80003af0:	6121                	addi	sp,sp,64
    80003af2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003af4:	0001ca97          	auipc	s5,0x1c
    80003af8:	f7ca8a93          	addi	s5,s5,-132 # 8001fa70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003afc:	0001ca17          	auipc	s4,0x1c
    80003b00:	f44a0a13          	addi	s4,s4,-188 # 8001fa40 <log>
    80003b04:	018a2583          	lw	a1,24(s4)
    80003b08:	012585bb          	addw	a1,a1,s2
    80003b0c:	2585                	addiw	a1,a1,1
    80003b0e:	028a2503          	lw	a0,40(s4)
    80003b12:	f2ffe0ef          	jal	ra,80002a40 <bread>
    80003b16:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003b18:	000aa583          	lw	a1,0(s5)
    80003b1c:	028a2503          	lw	a0,40(s4)
    80003b20:	f21fe0ef          	jal	ra,80002a40 <bread>
    80003b24:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003b26:	40000613          	li	a2,1024
    80003b2a:	05850593          	addi	a1,a0,88
    80003b2e:	05848513          	addi	a0,s1,88
    80003b32:	998fd0ef          	jal	ra,80000cca <memmove>
    bwrite(to);  // write the log
    80003b36:	8526                	mv	a0,s1
    80003b38:	fdffe0ef          	jal	ra,80002b16 <bwrite>
    brelse(from);
    80003b3c:	854e                	mv	a0,s3
    80003b3e:	80aff0ef          	jal	ra,80002b48 <brelse>
    brelse(to);
    80003b42:	8526                	mv	a0,s1
    80003b44:	804ff0ef          	jal	ra,80002b48 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b48:	2905                	addiw	s2,s2,1
    80003b4a:	0a91                	addi	s5,s5,4
    80003b4c:	02ca2783          	lw	a5,44(s4)
    80003b50:	faf94ae3          	blt	s2,a5,80003b04 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003b54:	cefff0ef          	jal	ra,80003842 <write_head>
    install_trans(0); // Now install writes to home locations
    80003b58:	4501                	li	a0,0
    80003b5a:	d57ff0ef          	jal	ra,800038b0 <install_trans>
    log.lh.n = 0;
    80003b5e:	0001c797          	auipc	a5,0x1c
    80003b62:	f007a723          	sw	zero,-242(a5) # 8001fa6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003b66:	cddff0ef          	jal	ra,80003842 <write_head>
    80003b6a:	bf25                	j	80003aa2 <end_op+0x4a>

0000000080003b6c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003b6c:	1101                	addi	sp,sp,-32
    80003b6e:	ec06                	sd	ra,24(sp)
    80003b70:	e822                	sd	s0,16(sp)
    80003b72:	e426                	sd	s1,8(sp)
    80003b74:	e04a                	sd	s2,0(sp)
    80003b76:	1000                	addi	s0,sp,32
    80003b78:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b7a:	0001c917          	auipc	s2,0x1c
    80003b7e:	ec690913          	addi	s2,s2,-314 # 8001fa40 <log>
    80003b82:	854a                	mv	a0,s2
    80003b84:	816fd0ef          	jal	ra,80000b9a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b88:	02c92603          	lw	a2,44(s2)
    80003b8c:	47f5                	li	a5,29
    80003b8e:	06c7c363          	blt	a5,a2,80003bf4 <log_write+0x88>
    80003b92:	0001c797          	auipc	a5,0x1c
    80003b96:	eca7a783          	lw	a5,-310(a5) # 8001fa5c <log+0x1c>
    80003b9a:	37fd                	addiw	a5,a5,-1
    80003b9c:	04f65c63          	bge	a2,a5,80003bf4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ba0:	0001c797          	auipc	a5,0x1c
    80003ba4:	ec07a783          	lw	a5,-320(a5) # 8001fa60 <log+0x20>
    80003ba8:	04f05c63          	blez	a5,80003c00 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003bac:	4781                	li	a5,0
    80003bae:	04c05f63          	blez	a2,80003c0c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003bb2:	44cc                	lw	a1,12(s1)
    80003bb4:	0001c717          	auipc	a4,0x1c
    80003bb8:	ebc70713          	addi	a4,a4,-324 # 8001fa70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003bbc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003bbe:	4314                	lw	a3,0(a4)
    80003bc0:	04b68663          	beq	a3,a1,80003c0c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003bc4:	2785                	addiw	a5,a5,1
    80003bc6:	0711                	addi	a4,a4,4
    80003bc8:	fef61be3          	bne	a2,a5,80003bbe <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003bcc:	0621                	addi	a2,a2,8
    80003bce:	060a                	slli	a2,a2,0x2
    80003bd0:	0001c797          	auipc	a5,0x1c
    80003bd4:	e7078793          	addi	a5,a5,-400 # 8001fa40 <log>
    80003bd8:	963e                	add	a2,a2,a5
    80003bda:	44dc                	lw	a5,12(s1)
    80003bdc:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003bde:	8526                	mv	a0,s1
    80003be0:	ff3fe0ef          	jal	ra,80002bd2 <bpin>
    log.lh.n++;
    80003be4:	0001c717          	auipc	a4,0x1c
    80003be8:	e5c70713          	addi	a4,a4,-420 # 8001fa40 <log>
    80003bec:	575c                	lw	a5,44(a4)
    80003bee:	2785                	addiw	a5,a5,1
    80003bf0:	d75c                	sw	a5,44(a4)
    80003bf2:	a815                	j	80003c26 <log_write+0xba>
    panic("too big a transaction");
    80003bf4:	00004517          	auipc	a0,0x4
    80003bf8:	ac450513          	addi	a0,a0,-1340 # 800076b8 <syscalls+0x1f8>
    80003bfc:	b5bfc0ef          	jal	ra,80000756 <panic>
    panic("log_write outside of trans");
    80003c00:	00004517          	auipc	a0,0x4
    80003c04:	ad050513          	addi	a0,a0,-1328 # 800076d0 <syscalls+0x210>
    80003c08:	b4ffc0ef          	jal	ra,80000756 <panic>
  log.lh.block[i] = b->blockno;
    80003c0c:	00878713          	addi	a4,a5,8
    80003c10:	00271693          	slli	a3,a4,0x2
    80003c14:	0001c717          	auipc	a4,0x1c
    80003c18:	e2c70713          	addi	a4,a4,-468 # 8001fa40 <log>
    80003c1c:	9736                	add	a4,a4,a3
    80003c1e:	44d4                	lw	a3,12(s1)
    80003c20:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003c22:	faf60ee3          	beq	a2,a5,80003bde <log_write+0x72>
  }
  release(&log.lock);
    80003c26:	0001c517          	auipc	a0,0x1c
    80003c2a:	e1a50513          	addi	a0,a0,-486 # 8001fa40 <log>
    80003c2e:	804fd0ef          	jal	ra,80000c32 <release>
}
    80003c32:	60e2                	ld	ra,24(sp)
    80003c34:	6442                	ld	s0,16(sp)
    80003c36:	64a2                	ld	s1,8(sp)
    80003c38:	6902                	ld	s2,0(sp)
    80003c3a:	6105                	addi	sp,sp,32
    80003c3c:	8082                	ret

0000000080003c3e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003c3e:	1101                	addi	sp,sp,-32
    80003c40:	ec06                	sd	ra,24(sp)
    80003c42:	e822                	sd	s0,16(sp)
    80003c44:	e426                	sd	s1,8(sp)
    80003c46:	e04a                	sd	s2,0(sp)
    80003c48:	1000                	addi	s0,sp,32
    80003c4a:	84aa                	mv	s1,a0
    80003c4c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003c4e:	00004597          	auipc	a1,0x4
    80003c52:	aa258593          	addi	a1,a1,-1374 # 800076f0 <syscalls+0x230>
    80003c56:	0521                	addi	a0,a0,8
    80003c58:	ec3fc0ef          	jal	ra,80000b1a <initlock>
  lk->name = name;
    80003c5c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003c60:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c64:	0204a423          	sw	zero,40(s1)
}
    80003c68:	60e2                	ld	ra,24(sp)
    80003c6a:	6442                	ld	s0,16(sp)
    80003c6c:	64a2                	ld	s1,8(sp)
    80003c6e:	6902                	ld	s2,0(sp)
    80003c70:	6105                	addi	sp,sp,32
    80003c72:	8082                	ret

0000000080003c74 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c74:	1101                	addi	sp,sp,-32
    80003c76:	ec06                	sd	ra,24(sp)
    80003c78:	e822                	sd	s0,16(sp)
    80003c7a:	e426                	sd	s1,8(sp)
    80003c7c:	e04a                	sd	s2,0(sp)
    80003c7e:	1000                	addi	s0,sp,32
    80003c80:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c82:	00850913          	addi	s2,a0,8
    80003c86:	854a                	mv	a0,s2
    80003c88:	f13fc0ef          	jal	ra,80000b9a <acquire>
  while (lk->locked) {
    80003c8c:	409c                	lw	a5,0(s1)
    80003c8e:	c799                	beqz	a5,80003c9c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003c90:	85ca                	mv	a1,s2
    80003c92:	8526                	mv	a0,s1
    80003c94:	91efe0ef          	jal	ra,80001db2 <sleep>
  while (lk->locked) {
    80003c98:	409c                	lw	a5,0(s1)
    80003c9a:	fbfd                	bnez	a5,80003c90 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003c9c:	4785                	li	a5,1
    80003c9e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ca0:	b47fd0ef          	jal	ra,800017e6 <myproc>
    80003ca4:	591c                	lw	a5,48(a0)
    80003ca6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ca8:	854a                	mv	a0,s2
    80003caa:	f89fc0ef          	jal	ra,80000c32 <release>
}
    80003cae:	60e2                	ld	ra,24(sp)
    80003cb0:	6442                	ld	s0,16(sp)
    80003cb2:	64a2                	ld	s1,8(sp)
    80003cb4:	6902                	ld	s2,0(sp)
    80003cb6:	6105                	addi	sp,sp,32
    80003cb8:	8082                	ret

0000000080003cba <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003cba:	1101                	addi	sp,sp,-32
    80003cbc:	ec06                	sd	ra,24(sp)
    80003cbe:	e822                	sd	s0,16(sp)
    80003cc0:	e426                	sd	s1,8(sp)
    80003cc2:	e04a                	sd	s2,0(sp)
    80003cc4:	1000                	addi	s0,sp,32
    80003cc6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003cc8:	00850913          	addi	s2,a0,8
    80003ccc:	854a                	mv	a0,s2
    80003cce:	ecdfc0ef          	jal	ra,80000b9a <acquire>
  lk->locked = 0;
    80003cd2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cd6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003cda:	8526                	mv	a0,s1
    80003cdc:	922fe0ef          	jal	ra,80001dfe <wakeup>
  release(&lk->lk);
    80003ce0:	854a                	mv	a0,s2
    80003ce2:	f51fc0ef          	jal	ra,80000c32 <release>
}
    80003ce6:	60e2                	ld	ra,24(sp)
    80003ce8:	6442                	ld	s0,16(sp)
    80003cea:	64a2                	ld	s1,8(sp)
    80003cec:	6902                	ld	s2,0(sp)
    80003cee:	6105                	addi	sp,sp,32
    80003cf0:	8082                	ret

0000000080003cf2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003cf2:	7179                	addi	sp,sp,-48
    80003cf4:	f406                	sd	ra,40(sp)
    80003cf6:	f022                	sd	s0,32(sp)
    80003cf8:	ec26                	sd	s1,24(sp)
    80003cfa:	e84a                	sd	s2,16(sp)
    80003cfc:	e44e                	sd	s3,8(sp)
    80003cfe:	1800                	addi	s0,sp,48
    80003d00:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003d02:	00850913          	addi	s2,a0,8
    80003d06:	854a                	mv	a0,s2
    80003d08:	e93fc0ef          	jal	ra,80000b9a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d0c:	409c                	lw	a5,0(s1)
    80003d0e:	ef89                	bnez	a5,80003d28 <holdingsleep+0x36>
    80003d10:	4481                	li	s1,0
  release(&lk->lk);
    80003d12:	854a                	mv	a0,s2
    80003d14:	f1ffc0ef          	jal	ra,80000c32 <release>
  return r;
}
    80003d18:	8526                	mv	a0,s1
    80003d1a:	70a2                	ld	ra,40(sp)
    80003d1c:	7402                	ld	s0,32(sp)
    80003d1e:	64e2                	ld	s1,24(sp)
    80003d20:	6942                	ld	s2,16(sp)
    80003d22:	69a2                	ld	s3,8(sp)
    80003d24:	6145                	addi	sp,sp,48
    80003d26:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d28:	0284a983          	lw	s3,40(s1)
    80003d2c:	abbfd0ef          	jal	ra,800017e6 <myproc>
    80003d30:	5904                	lw	s1,48(a0)
    80003d32:	413484b3          	sub	s1,s1,s3
    80003d36:	0014b493          	seqz	s1,s1
    80003d3a:	bfe1                	j	80003d12 <holdingsleep+0x20>

0000000080003d3c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003d3c:	1141                	addi	sp,sp,-16
    80003d3e:	e406                	sd	ra,8(sp)
    80003d40:	e022                	sd	s0,0(sp)
    80003d42:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003d44:	00004597          	auipc	a1,0x4
    80003d48:	9bc58593          	addi	a1,a1,-1604 # 80007700 <syscalls+0x240>
    80003d4c:	0001c517          	auipc	a0,0x1c
    80003d50:	e3c50513          	addi	a0,a0,-452 # 8001fb88 <ftable>
    80003d54:	dc7fc0ef          	jal	ra,80000b1a <initlock>
}
    80003d58:	60a2                	ld	ra,8(sp)
    80003d5a:	6402                	ld	s0,0(sp)
    80003d5c:	0141                	addi	sp,sp,16
    80003d5e:	8082                	ret

0000000080003d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003d60:	1101                	addi	sp,sp,-32
    80003d62:	ec06                	sd	ra,24(sp)
    80003d64:	e822                	sd	s0,16(sp)
    80003d66:	e426                	sd	s1,8(sp)
    80003d68:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003d6a:	0001c517          	auipc	a0,0x1c
    80003d6e:	e1e50513          	addi	a0,a0,-482 # 8001fb88 <ftable>
    80003d72:	e29fc0ef          	jal	ra,80000b9a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d76:	0001c497          	auipc	s1,0x1c
    80003d7a:	e2a48493          	addi	s1,s1,-470 # 8001fba0 <ftable+0x18>
    80003d7e:	0001d717          	auipc	a4,0x1d
    80003d82:	dc270713          	addi	a4,a4,-574 # 80020b40 <disk>
    if(f->ref == 0){
    80003d86:	40dc                	lw	a5,4(s1)
    80003d88:	cf89                	beqz	a5,80003da2 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d8a:	02848493          	addi	s1,s1,40
    80003d8e:	fee49ce3          	bne	s1,a4,80003d86 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d92:	0001c517          	auipc	a0,0x1c
    80003d96:	df650513          	addi	a0,a0,-522 # 8001fb88 <ftable>
    80003d9a:	e99fc0ef          	jal	ra,80000c32 <release>
  return 0;
    80003d9e:	4481                	li	s1,0
    80003da0:	a809                	j	80003db2 <filealloc+0x52>
      f->ref = 1;
    80003da2:	4785                	li	a5,1
    80003da4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003da6:	0001c517          	auipc	a0,0x1c
    80003daa:	de250513          	addi	a0,a0,-542 # 8001fb88 <ftable>
    80003dae:	e85fc0ef          	jal	ra,80000c32 <release>
}
    80003db2:	8526                	mv	a0,s1
    80003db4:	60e2                	ld	ra,24(sp)
    80003db6:	6442                	ld	s0,16(sp)
    80003db8:	64a2                	ld	s1,8(sp)
    80003dba:	6105                	addi	sp,sp,32
    80003dbc:	8082                	ret

0000000080003dbe <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003dbe:	1101                	addi	sp,sp,-32
    80003dc0:	ec06                	sd	ra,24(sp)
    80003dc2:	e822                	sd	s0,16(sp)
    80003dc4:	e426                	sd	s1,8(sp)
    80003dc6:	1000                	addi	s0,sp,32
    80003dc8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003dca:	0001c517          	auipc	a0,0x1c
    80003dce:	dbe50513          	addi	a0,a0,-578 # 8001fb88 <ftable>
    80003dd2:	dc9fc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003dd6:	40dc                	lw	a5,4(s1)
    80003dd8:	02f05063          	blez	a5,80003df8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003ddc:	2785                	addiw	a5,a5,1
    80003dde:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003de0:	0001c517          	auipc	a0,0x1c
    80003de4:	da850513          	addi	a0,a0,-600 # 8001fb88 <ftable>
    80003de8:	e4bfc0ef          	jal	ra,80000c32 <release>
  return f;
}
    80003dec:	8526                	mv	a0,s1
    80003dee:	60e2                	ld	ra,24(sp)
    80003df0:	6442                	ld	s0,16(sp)
    80003df2:	64a2                	ld	s1,8(sp)
    80003df4:	6105                	addi	sp,sp,32
    80003df6:	8082                	ret
    panic("filedup");
    80003df8:	00004517          	auipc	a0,0x4
    80003dfc:	91050513          	addi	a0,a0,-1776 # 80007708 <syscalls+0x248>
    80003e00:	957fc0ef          	jal	ra,80000756 <panic>

0000000080003e04 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e04:	7139                	addi	sp,sp,-64
    80003e06:	fc06                	sd	ra,56(sp)
    80003e08:	f822                	sd	s0,48(sp)
    80003e0a:	f426                	sd	s1,40(sp)
    80003e0c:	f04a                	sd	s2,32(sp)
    80003e0e:	ec4e                	sd	s3,24(sp)
    80003e10:	e852                	sd	s4,16(sp)
    80003e12:	e456                	sd	s5,8(sp)
    80003e14:	0080                	addi	s0,sp,64
    80003e16:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e18:	0001c517          	auipc	a0,0x1c
    80003e1c:	d7050513          	addi	a0,a0,-656 # 8001fb88 <ftable>
    80003e20:	d7bfc0ef          	jal	ra,80000b9a <acquire>
  if(f->ref < 1)
    80003e24:	40dc                	lw	a5,4(s1)
    80003e26:	04f05963          	blez	a5,80003e78 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003e2a:	37fd                	addiw	a5,a5,-1
    80003e2c:	0007871b          	sext.w	a4,a5
    80003e30:	c0dc                	sw	a5,4(s1)
    80003e32:	04e04963          	bgtz	a4,80003e84 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003e36:	0004a903          	lw	s2,0(s1)
    80003e3a:	0094ca83          	lbu	s5,9(s1)
    80003e3e:	0104ba03          	ld	s4,16(s1)
    80003e42:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003e46:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003e4a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003e4e:	0001c517          	auipc	a0,0x1c
    80003e52:	d3a50513          	addi	a0,a0,-710 # 8001fb88 <ftable>
    80003e56:	dddfc0ef          	jal	ra,80000c32 <release>

  if(ff.type == FD_PIPE){
    80003e5a:	4785                	li	a5,1
    80003e5c:	04f90363          	beq	s2,a5,80003ea2 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003e60:	3979                	addiw	s2,s2,-2
    80003e62:	4785                	li	a5,1
    80003e64:	0327e663          	bltu	a5,s2,80003e90 <fileclose+0x8c>
    begin_op();
    80003e68:	b81ff0ef          	jal	ra,800039e8 <begin_op>
    iput(ff.ip);
    80003e6c:	854e                	mv	a0,s3
    80003e6e:	c6eff0ef          	jal	ra,800032dc <iput>
    end_op();
    80003e72:	be7ff0ef          	jal	ra,80003a58 <end_op>
    80003e76:	a829                	j	80003e90 <fileclose+0x8c>
    panic("fileclose");
    80003e78:	00004517          	auipc	a0,0x4
    80003e7c:	89850513          	addi	a0,a0,-1896 # 80007710 <syscalls+0x250>
    80003e80:	8d7fc0ef          	jal	ra,80000756 <panic>
    release(&ftable.lock);
    80003e84:	0001c517          	auipc	a0,0x1c
    80003e88:	d0450513          	addi	a0,a0,-764 # 8001fb88 <ftable>
    80003e8c:	da7fc0ef          	jal	ra,80000c32 <release>
  }
}
    80003e90:	70e2                	ld	ra,56(sp)
    80003e92:	7442                	ld	s0,48(sp)
    80003e94:	74a2                	ld	s1,40(sp)
    80003e96:	7902                	ld	s2,32(sp)
    80003e98:	69e2                	ld	s3,24(sp)
    80003e9a:	6a42                	ld	s4,16(sp)
    80003e9c:	6aa2                	ld	s5,8(sp)
    80003e9e:	6121                	addi	sp,sp,64
    80003ea0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ea2:	85d6                	mv	a1,s5
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	2ec000ef          	jal	ra,80004192 <pipeclose>
    80003eaa:	b7dd                	j	80003e90 <fileclose+0x8c>

0000000080003eac <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003eac:	715d                	addi	sp,sp,-80
    80003eae:	e486                	sd	ra,72(sp)
    80003eb0:	e0a2                	sd	s0,64(sp)
    80003eb2:	fc26                	sd	s1,56(sp)
    80003eb4:	f84a                	sd	s2,48(sp)
    80003eb6:	f44e                	sd	s3,40(sp)
    80003eb8:	0880                	addi	s0,sp,80
    80003eba:	84aa                	mv	s1,a0
    80003ebc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ebe:	929fd0ef          	jal	ra,800017e6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ec2:	409c                	lw	a5,0(s1)
    80003ec4:	37f9                	addiw	a5,a5,-2
    80003ec6:	4705                	li	a4,1
    80003ec8:	02f76f63          	bltu	a4,a5,80003f06 <filestat+0x5a>
    80003ecc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ece:	6c88                	ld	a0,24(s1)
    80003ed0:	a8eff0ef          	jal	ra,8000315e <ilock>
    stati(f->ip, &st);
    80003ed4:	fb840593          	addi	a1,s0,-72
    80003ed8:	6c88                	ld	a0,24(s1)
    80003eda:	caaff0ef          	jal	ra,80003384 <stati>
    iunlock(f->ip);
    80003ede:	6c88                	ld	a0,24(s1)
    80003ee0:	b28ff0ef          	jal	ra,80003208 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ee4:	46e1                	li	a3,24
    80003ee6:	fb840613          	addi	a2,s0,-72
    80003eea:	85ce                	mv	a1,s3
    80003eec:	05093503          	ld	a0,80(s2)
    80003ef0:	daafd0ef          	jal	ra,8000149a <copyout>
    80003ef4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ef8:	60a6                	ld	ra,72(sp)
    80003efa:	6406                	ld	s0,64(sp)
    80003efc:	74e2                	ld	s1,56(sp)
    80003efe:	7942                	ld	s2,48(sp)
    80003f00:	79a2                	ld	s3,40(sp)
    80003f02:	6161                	addi	sp,sp,80
    80003f04:	8082                	ret
  return -1;
    80003f06:	557d                	li	a0,-1
    80003f08:	bfc5                	j	80003ef8 <filestat+0x4c>

0000000080003f0a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f0a:	7179                	addi	sp,sp,-48
    80003f0c:	f406                	sd	ra,40(sp)
    80003f0e:	f022                	sd	s0,32(sp)
    80003f10:	ec26                	sd	s1,24(sp)
    80003f12:	e84a                	sd	s2,16(sp)
    80003f14:	e44e                	sd	s3,8(sp)
    80003f16:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003f18:	00854783          	lbu	a5,8(a0)
    80003f1c:	cbc1                	beqz	a5,80003fac <fileread+0xa2>
    80003f1e:	84aa                	mv	s1,a0
    80003f20:	89ae                	mv	s3,a1
    80003f22:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f24:	411c                	lw	a5,0(a0)
    80003f26:	4705                	li	a4,1
    80003f28:	04e78363          	beq	a5,a4,80003f6e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f2c:	470d                	li	a4,3
    80003f2e:	04e78563          	beq	a5,a4,80003f78 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f32:	4709                	li	a4,2
    80003f34:	06e79663          	bne	a5,a4,80003fa0 <fileread+0x96>
    ilock(f->ip);
    80003f38:	6d08                	ld	a0,24(a0)
    80003f3a:	a24ff0ef          	jal	ra,8000315e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003f3e:	874a                	mv	a4,s2
    80003f40:	5094                	lw	a3,32(s1)
    80003f42:	864e                	mv	a2,s3
    80003f44:	4585                	li	a1,1
    80003f46:	6c88                	ld	a0,24(s1)
    80003f48:	c66ff0ef          	jal	ra,800033ae <readi>
    80003f4c:	892a                	mv	s2,a0
    80003f4e:	00a05563          	blez	a0,80003f58 <fileread+0x4e>
      f->off += r;
    80003f52:	509c                	lw	a5,32(s1)
    80003f54:	9fa9                	addw	a5,a5,a0
    80003f56:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003f58:	6c88                	ld	a0,24(s1)
    80003f5a:	aaeff0ef          	jal	ra,80003208 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003f5e:	854a                	mv	a0,s2
    80003f60:	70a2                	ld	ra,40(sp)
    80003f62:	7402                	ld	s0,32(sp)
    80003f64:	64e2                	ld	s1,24(sp)
    80003f66:	6942                	ld	s2,16(sp)
    80003f68:	69a2                	ld	s3,8(sp)
    80003f6a:	6145                	addi	sp,sp,48
    80003f6c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f6e:	6908                	ld	a0,16(a0)
    80003f70:	34e000ef          	jal	ra,800042be <piperead>
    80003f74:	892a                	mv	s2,a0
    80003f76:	b7e5                	j	80003f5e <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f78:	02451783          	lh	a5,36(a0)
    80003f7c:	03079693          	slli	a3,a5,0x30
    80003f80:	92c1                	srli	a3,a3,0x30
    80003f82:	4725                	li	a4,9
    80003f84:	02d76663          	bltu	a4,a3,80003fb0 <fileread+0xa6>
    80003f88:	0792                	slli	a5,a5,0x4
    80003f8a:	0001c717          	auipc	a4,0x1c
    80003f8e:	b5e70713          	addi	a4,a4,-1186 # 8001fae8 <devsw>
    80003f92:	97ba                	add	a5,a5,a4
    80003f94:	639c                	ld	a5,0(a5)
    80003f96:	cf99                	beqz	a5,80003fb4 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003f98:	4505                	li	a0,1
    80003f9a:	9782                	jalr	a5
    80003f9c:	892a                	mv	s2,a0
    80003f9e:	b7c1                	j	80003f5e <fileread+0x54>
    panic("fileread");
    80003fa0:	00003517          	auipc	a0,0x3
    80003fa4:	78050513          	addi	a0,a0,1920 # 80007720 <syscalls+0x260>
    80003fa8:	faefc0ef          	jal	ra,80000756 <panic>
    return -1;
    80003fac:	597d                	li	s2,-1
    80003fae:	bf45                	j	80003f5e <fileread+0x54>
      return -1;
    80003fb0:	597d                	li	s2,-1
    80003fb2:	b775                	j	80003f5e <fileread+0x54>
    80003fb4:	597d                	li	s2,-1
    80003fb6:	b765                	j	80003f5e <fileread+0x54>

0000000080003fb8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003fb8:	715d                	addi	sp,sp,-80
    80003fba:	e486                	sd	ra,72(sp)
    80003fbc:	e0a2                	sd	s0,64(sp)
    80003fbe:	fc26                	sd	s1,56(sp)
    80003fc0:	f84a                	sd	s2,48(sp)
    80003fc2:	f44e                	sd	s3,40(sp)
    80003fc4:	f052                	sd	s4,32(sp)
    80003fc6:	ec56                	sd	s5,24(sp)
    80003fc8:	e85a                	sd	s6,16(sp)
    80003fca:	e45e                	sd	s7,8(sp)
    80003fcc:	e062                	sd	s8,0(sp)
    80003fce:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003fd0:	00954783          	lbu	a5,9(a0)
    80003fd4:	0e078863          	beqz	a5,800040c4 <filewrite+0x10c>
    80003fd8:	892a                	mv	s2,a0
    80003fda:	8aae                	mv	s5,a1
    80003fdc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fde:	411c                	lw	a5,0(a0)
    80003fe0:	4705                	li	a4,1
    80003fe2:	02e78263          	beq	a5,a4,80004006 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fe6:	470d                	li	a4,3
    80003fe8:	02e78463          	beq	a5,a4,80004010 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fec:	4709                	li	a4,2
    80003fee:	0ce79563          	bne	a5,a4,800040b8 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ff2:	0ac05163          	blez	a2,80004094 <filewrite+0xdc>
    int i = 0;
    80003ff6:	4981                	li	s3,0
    80003ff8:	6b05                	lui	s6,0x1
    80003ffa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ffe:	6b85                	lui	s7,0x1
    80004000:	c00b8b9b          	addiw	s7,s7,-1024
    80004004:	a041                	j	80004084 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004006:	6908                	ld	a0,16(a0)
    80004008:	1e2000ef          	jal	ra,800041ea <pipewrite>
    8000400c:	8a2a                	mv	s4,a0
    8000400e:	a071                	j	8000409a <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004010:	02451783          	lh	a5,36(a0)
    80004014:	03079693          	slli	a3,a5,0x30
    80004018:	92c1                	srli	a3,a3,0x30
    8000401a:	4725                	li	a4,9
    8000401c:	0ad76663          	bltu	a4,a3,800040c8 <filewrite+0x110>
    80004020:	0792                	slli	a5,a5,0x4
    80004022:	0001c717          	auipc	a4,0x1c
    80004026:	ac670713          	addi	a4,a4,-1338 # 8001fae8 <devsw>
    8000402a:	97ba                	add	a5,a5,a4
    8000402c:	679c                	ld	a5,8(a5)
    8000402e:	cfd9                	beqz	a5,800040cc <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80004030:	4505                	li	a0,1
    80004032:	9782                	jalr	a5
    80004034:	8a2a                	mv	s4,a0
    80004036:	a095                	j	8000409a <filewrite+0xe2>
    80004038:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000403c:	9adff0ef          	jal	ra,800039e8 <begin_op>
      ilock(f->ip);
    80004040:	01893503          	ld	a0,24(s2)
    80004044:	91aff0ef          	jal	ra,8000315e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004048:	8762                	mv	a4,s8
    8000404a:	02092683          	lw	a3,32(s2)
    8000404e:	01598633          	add	a2,s3,s5
    80004052:	4585                	li	a1,1
    80004054:	01893503          	ld	a0,24(s2)
    80004058:	c3aff0ef          	jal	ra,80003492 <writei>
    8000405c:	84aa                	mv	s1,a0
    8000405e:	00a05763          	blez	a0,8000406c <filewrite+0xb4>
        f->off += r;
    80004062:	02092783          	lw	a5,32(s2)
    80004066:	9fa9                	addw	a5,a5,a0
    80004068:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000406c:	01893503          	ld	a0,24(s2)
    80004070:	998ff0ef          	jal	ra,80003208 <iunlock>
      end_op();
    80004074:	9e5ff0ef          	jal	ra,80003a58 <end_op>

      if(r != n1){
    80004078:	009c1f63          	bne	s8,s1,80004096 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    8000407c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004080:	0149db63          	bge	s3,s4,80004096 <filewrite+0xde>
      int n1 = n - i;
    80004084:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004088:	84be                	mv	s1,a5
    8000408a:	2781                	sext.w	a5,a5
    8000408c:	fafb56e3          	bge	s6,a5,80004038 <filewrite+0x80>
    80004090:	84de                	mv	s1,s7
    80004092:	b75d                	j	80004038 <filewrite+0x80>
    int i = 0;
    80004094:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004096:	013a1f63          	bne	s4,s3,800040b4 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000409a:	8552                	mv	a0,s4
    8000409c:	60a6                	ld	ra,72(sp)
    8000409e:	6406                	ld	s0,64(sp)
    800040a0:	74e2                	ld	s1,56(sp)
    800040a2:	7942                	ld	s2,48(sp)
    800040a4:	79a2                	ld	s3,40(sp)
    800040a6:	7a02                	ld	s4,32(sp)
    800040a8:	6ae2                	ld	s5,24(sp)
    800040aa:	6b42                	ld	s6,16(sp)
    800040ac:	6ba2                	ld	s7,8(sp)
    800040ae:	6c02                	ld	s8,0(sp)
    800040b0:	6161                	addi	sp,sp,80
    800040b2:	8082                	ret
    ret = (i == n ? n : -1);
    800040b4:	5a7d                	li	s4,-1
    800040b6:	b7d5                	j	8000409a <filewrite+0xe2>
    panic("filewrite");
    800040b8:	00003517          	auipc	a0,0x3
    800040bc:	67850513          	addi	a0,a0,1656 # 80007730 <syscalls+0x270>
    800040c0:	e96fc0ef          	jal	ra,80000756 <panic>
    return -1;
    800040c4:	5a7d                	li	s4,-1
    800040c6:	bfd1                	j	8000409a <filewrite+0xe2>
      return -1;
    800040c8:	5a7d                	li	s4,-1
    800040ca:	bfc1                	j	8000409a <filewrite+0xe2>
    800040cc:	5a7d                	li	s4,-1
    800040ce:	b7f1                	j	8000409a <filewrite+0xe2>

00000000800040d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800040d0:	7179                	addi	sp,sp,-48
    800040d2:	f406                	sd	ra,40(sp)
    800040d4:	f022                	sd	s0,32(sp)
    800040d6:	ec26                	sd	s1,24(sp)
    800040d8:	e84a                	sd	s2,16(sp)
    800040da:	e44e                	sd	s3,8(sp)
    800040dc:	e052                	sd	s4,0(sp)
    800040de:	1800                	addi	s0,sp,48
    800040e0:	84aa                	mv	s1,a0
    800040e2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800040e4:	0005b023          	sd	zero,0(a1)
    800040e8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800040ec:	c75ff0ef          	jal	ra,80003d60 <filealloc>
    800040f0:	e088                	sd	a0,0(s1)
    800040f2:	cd35                	beqz	a0,8000416e <pipealloc+0x9e>
    800040f4:	c6dff0ef          	jal	ra,80003d60 <filealloc>
    800040f8:	00aa3023          	sd	a0,0(s4)
    800040fc:	c52d                	beqz	a0,80004166 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800040fe:	9cdfc0ef          	jal	ra,80000aca <kalloc>
    80004102:	892a                	mv	s2,a0
    80004104:	cd31                	beqz	a0,80004160 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004106:	4985                	li	s3,1
    80004108:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000410c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004110:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004114:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004118:	00003597          	auipc	a1,0x3
    8000411c:	62858593          	addi	a1,a1,1576 # 80007740 <syscalls+0x280>
    80004120:	9fbfc0ef          	jal	ra,80000b1a <initlock>
  (*f0)->type = FD_PIPE;
    80004124:	609c                	ld	a5,0(s1)
    80004126:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000412a:	609c                	ld	a5,0(s1)
    8000412c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004130:	609c                	ld	a5,0(s1)
    80004132:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004136:	609c                	ld	a5,0(s1)
    80004138:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000413c:	000a3783          	ld	a5,0(s4)
    80004140:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004144:	000a3783          	ld	a5,0(s4)
    80004148:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000414c:	000a3783          	ld	a5,0(s4)
    80004150:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004154:	000a3783          	ld	a5,0(s4)
    80004158:	0127b823          	sd	s2,16(a5)
  return 0;
    8000415c:	4501                	li	a0,0
    8000415e:	a005                	j	8000417e <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004160:	6088                	ld	a0,0(s1)
    80004162:	e501                	bnez	a0,8000416a <pipealloc+0x9a>
    80004164:	a029                	j	8000416e <pipealloc+0x9e>
    80004166:	6088                	ld	a0,0(s1)
    80004168:	c11d                	beqz	a0,8000418e <pipealloc+0xbe>
    fileclose(*f0);
    8000416a:	c9bff0ef          	jal	ra,80003e04 <fileclose>
  if(*f1)
    8000416e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004172:	557d                	li	a0,-1
  if(*f1)
    80004174:	c789                	beqz	a5,8000417e <pipealloc+0xae>
    fileclose(*f1);
    80004176:	853e                	mv	a0,a5
    80004178:	c8dff0ef          	jal	ra,80003e04 <fileclose>
  return -1;
    8000417c:	557d                	li	a0,-1
}
    8000417e:	70a2                	ld	ra,40(sp)
    80004180:	7402                	ld	s0,32(sp)
    80004182:	64e2                	ld	s1,24(sp)
    80004184:	6942                	ld	s2,16(sp)
    80004186:	69a2                	ld	s3,8(sp)
    80004188:	6a02                	ld	s4,0(sp)
    8000418a:	6145                	addi	sp,sp,48
    8000418c:	8082                	ret
  return -1;
    8000418e:	557d                	li	a0,-1
    80004190:	b7fd                	j	8000417e <pipealloc+0xae>

0000000080004192 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004192:	1101                	addi	sp,sp,-32
    80004194:	ec06                	sd	ra,24(sp)
    80004196:	e822                	sd	s0,16(sp)
    80004198:	e426                	sd	s1,8(sp)
    8000419a:	e04a                	sd	s2,0(sp)
    8000419c:	1000                	addi	s0,sp,32
    8000419e:	84aa                	mv	s1,a0
    800041a0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800041a2:	9f9fc0ef          	jal	ra,80000b9a <acquire>
  if(writable){
    800041a6:	02090763          	beqz	s2,800041d4 <pipeclose+0x42>
    pi->writeopen = 0;
    800041aa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800041ae:	21848513          	addi	a0,s1,536
    800041b2:	c4dfd0ef          	jal	ra,80001dfe <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800041b6:	2204b783          	ld	a5,544(s1)
    800041ba:	e785                	bnez	a5,800041e2 <pipeclose+0x50>
    release(&pi->lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	a75fc0ef          	jal	ra,80000c32 <release>
    kfree((char*)pi);
    800041c2:	8526                	mv	a0,s1
    800041c4:	827fc0ef          	jal	ra,800009ea <kfree>
  } else
    release(&pi->lock);
}
    800041c8:	60e2                	ld	ra,24(sp)
    800041ca:	6442                	ld	s0,16(sp)
    800041cc:	64a2                	ld	s1,8(sp)
    800041ce:	6902                	ld	s2,0(sp)
    800041d0:	6105                	addi	sp,sp,32
    800041d2:	8082                	ret
    pi->readopen = 0;
    800041d4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800041d8:	21c48513          	addi	a0,s1,540
    800041dc:	c23fd0ef          	jal	ra,80001dfe <wakeup>
    800041e0:	bfd9                	j	800041b6 <pipeclose+0x24>
    release(&pi->lock);
    800041e2:	8526                	mv	a0,s1
    800041e4:	a4ffc0ef          	jal	ra,80000c32 <release>
}
    800041e8:	b7c5                	j	800041c8 <pipeclose+0x36>

00000000800041ea <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041ea:	711d                	addi	sp,sp,-96
    800041ec:	ec86                	sd	ra,88(sp)
    800041ee:	e8a2                	sd	s0,80(sp)
    800041f0:	e4a6                	sd	s1,72(sp)
    800041f2:	e0ca                	sd	s2,64(sp)
    800041f4:	fc4e                	sd	s3,56(sp)
    800041f6:	f852                	sd	s4,48(sp)
    800041f8:	f456                	sd	s5,40(sp)
    800041fa:	f05a                	sd	s6,32(sp)
    800041fc:	ec5e                	sd	s7,24(sp)
    800041fe:	e862                	sd	s8,16(sp)
    80004200:	1080                	addi	s0,sp,96
    80004202:	84aa                	mv	s1,a0
    80004204:	8aae                	mv	s5,a1
    80004206:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004208:	ddefd0ef          	jal	ra,800017e6 <myproc>
    8000420c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000420e:	8526                	mv	a0,s1
    80004210:	98bfc0ef          	jal	ra,80000b9a <acquire>
  while(i < n){
    80004214:	09405c63          	blez	s4,800042ac <pipewrite+0xc2>
  int i = 0;
    80004218:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000421a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000421c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004220:	21c48b93          	addi	s7,s1,540
    80004224:	a81d                	j	8000425a <pipewrite+0x70>
      release(&pi->lock);
    80004226:	8526                	mv	a0,s1
    80004228:	a0bfc0ef          	jal	ra,80000c32 <release>
      return -1;
    8000422c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000422e:	854a                	mv	a0,s2
    80004230:	60e6                	ld	ra,88(sp)
    80004232:	6446                	ld	s0,80(sp)
    80004234:	64a6                	ld	s1,72(sp)
    80004236:	6906                	ld	s2,64(sp)
    80004238:	79e2                	ld	s3,56(sp)
    8000423a:	7a42                	ld	s4,48(sp)
    8000423c:	7aa2                	ld	s5,40(sp)
    8000423e:	7b02                	ld	s6,32(sp)
    80004240:	6be2                	ld	s7,24(sp)
    80004242:	6c42                	ld	s8,16(sp)
    80004244:	6125                	addi	sp,sp,96
    80004246:	8082                	ret
      wakeup(&pi->nread);
    80004248:	8562                	mv	a0,s8
    8000424a:	bb5fd0ef          	jal	ra,80001dfe <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000424e:	85a6                	mv	a1,s1
    80004250:	855e                	mv	a0,s7
    80004252:	b61fd0ef          	jal	ra,80001db2 <sleep>
  while(i < n){
    80004256:	05495c63          	bge	s2,s4,800042ae <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    8000425a:	2204a783          	lw	a5,544(s1)
    8000425e:	d7e1                	beqz	a5,80004226 <pipewrite+0x3c>
    80004260:	854e                	mv	a0,s3
    80004262:	d89fd0ef          	jal	ra,80001fea <killed>
    80004266:	f161                	bnez	a0,80004226 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004268:	2184a783          	lw	a5,536(s1)
    8000426c:	21c4a703          	lw	a4,540(s1)
    80004270:	2007879b          	addiw	a5,a5,512
    80004274:	fcf70ae3          	beq	a4,a5,80004248 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004278:	4685                	li	a3,1
    8000427a:	01590633          	add	a2,s2,s5
    8000427e:	faf40593          	addi	a1,s0,-81
    80004282:	0509b503          	ld	a0,80(s3)
    80004286:	accfd0ef          	jal	ra,80001552 <copyin>
    8000428a:	03650263          	beq	a0,s6,800042ae <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000428e:	21c4a783          	lw	a5,540(s1)
    80004292:	0017871b          	addiw	a4,a5,1
    80004296:	20e4ae23          	sw	a4,540(s1)
    8000429a:	1ff7f793          	andi	a5,a5,511
    8000429e:	97a6                	add	a5,a5,s1
    800042a0:	faf44703          	lbu	a4,-81(s0)
    800042a4:	00e78c23          	sb	a4,24(a5)
      i++;
    800042a8:	2905                	addiw	s2,s2,1
    800042aa:	b775                	j	80004256 <pipewrite+0x6c>
  int i = 0;
    800042ac:	4901                	li	s2,0
  wakeup(&pi->nread);
    800042ae:	21848513          	addi	a0,s1,536
    800042b2:	b4dfd0ef          	jal	ra,80001dfe <wakeup>
  release(&pi->lock);
    800042b6:	8526                	mv	a0,s1
    800042b8:	97bfc0ef          	jal	ra,80000c32 <release>
  return i;
    800042bc:	bf8d                	j	8000422e <pipewrite+0x44>

00000000800042be <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042be:	715d                	addi	sp,sp,-80
    800042c0:	e486                	sd	ra,72(sp)
    800042c2:	e0a2                	sd	s0,64(sp)
    800042c4:	fc26                	sd	s1,56(sp)
    800042c6:	f84a                	sd	s2,48(sp)
    800042c8:	f44e                	sd	s3,40(sp)
    800042ca:	f052                	sd	s4,32(sp)
    800042cc:	ec56                	sd	s5,24(sp)
    800042ce:	e85a                	sd	s6,16(sp)
    800042d0:	0880                	addi	s0,sp,80
    800042d2:	84aa                	mv	s1,a0
    800042d4:	892e                	mv	s2,a1
    800042d6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042d8:	d0efd0ef          	jal	ra,800017e6 <myproc>
    800042dc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042de:	8526                	mv	a0,s1
    800042e0:	8bbfc0ef          	jal	ra,80000b9a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042e4:	2184a703          	lw	a4,536(s1)
    800042e8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042ec:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042f0:	02f71363          	bne	a4,a5,80004316 <piperead+0x58>
    800042f4:	2244a783          	lw	a5,548(s1)
    800042f8:	cf99                	beqz	a5,80004316 <piperead+0x58>
    if(killed(pr)){
    800042fa:	8552                	mv	a0,s4
    800042fc:	ceffd0ef          	jal	ra,80001fea <killed>
    80004300:	e141                	bnez	a0,80004380 <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004302:	85a6                	mv	a1,s1
    80004304:	854e                	mv	a0,s3
    80004306:	aadfd0ef          	jal	ra,80001db2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000430a:	2184a703          	lw	a4,536(s1)
    8000430e:	21c4a783          	lw	a5,540(s1)
    80004312:	fef701e3          	beq	a4,a5,800042f4 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004316:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004318:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000431a:	05505163          	blez	s5,8000435c <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    8000431e:	2184a783          	lw	a5,536(s1)
    80004322:	21c4a703          	lw	a4,540(s1)
    80004326:	02f70b63          	beq	a4,a5,8000435c <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000432a:	0017871b          	addiw	a4,a5,1
    8000432e:	20e4ac23          	sw	a4,536(s1)
    80004332:	1ff7f793          	andi	a5,a5,511
    80004336:	97a6                	add	a5,a5,s1
    80004338:	0187c783          	lbu	a5,24(a5)
    8000433c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004340:	4685                	li	a3,1
    80004342:	fbf40613          	addi	a2,s0,-65
    80004346:	85ca                	mv	a1,s2
    80004348:	050a3503          	ld	a0,80(s4)
    8000434c:	94efd0ef          	jal	ra,8000149a <copyout>
    80004350:	01650663          	beq	a0,s6,8000435c <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004354:	2985                	addiw	s3,s3,1
    80004356:	0905                	addi	s2,s2,1
    80004358:	fd3a93e3          	bne	s5,s3,8000431e <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000435c:	21c48513          	addi	a0,s1,540
    80004360:	a9ffd0ef          	jal	ra,80001dfe <wakeup>
  release(&pi->lock);
    80004364:	8526                	mv	a0,s1
    80004366:	8cdfc0ef          	jal	ra,80000c32 <release>
  return i;
}
    8000436a:	854e                	mv	a0,s3
    8000436c:	60a6                	ld	ra,72(sp)
    8000436e:	6406                	ld	s0,64(sp)
    80004370:	74e2                	ld	s1,56(sp)
    80004372:	7942                	ld	s2,48(sp)
    80004374:	79a2                	ld	s3,40(sp)
    80004376:	7a02                	ld	s4,32(sp)
    80004378:	6ae2                	ld	s5,24(sp)
    8000437a:	6b42                	ld	s6,16(sp)
    8000437c:	6161                	addi	sp,sp,80
    8000437e:	8082                	ret
      release(&pi->lock);
    80004380:	8526                	mv	a0,s1
    80004382:	8b1fc0ef          	jal	ra,80000c32 <release>
      return -1;
    80004386:	59fd                	li	s3,-1
    80004388:	b7cd                	j	8000436a <piperead+0xac>

000000008000438a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000438a:	1141                	addi	sp,sp,-16
    8000438c:	e422                	sd	s0,8(sp)
    8000438e:	0800                	addi	s0,sp,16
    80004390:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004392:	8905                	andi	a0,a0,1
    80004394:	c111                	beqz	a0,80004398 <flags2perm+0xe>
      perm = PTE_X;
    80004396:	4521                	li	a0,8
    if(flags & 0x2)
    80004398:	8b89                	andi	a5,a5,2
    8000439a:	c399                	beqz	a5,800043a0 <flags2perm+0x16>
      perm |= PTE_W;
    8000439c:	00456513          	ori	a0,a0,4
    return perm;
}
    800043a0:	6422                	ld	s0,8(sp)
    800043a2:	0141                	addi	sp,sp,16
    800043a4:	8082                	ret

00000000800043a6 <exec>:

int
exec(char *path, char **argv)
{
    800043a6:	de010113          	addi	sp,sp,-544
    800043aa:	20113c23          	sd	ra,536(sp)
    800043ae:	20813823          	sd	s0,528(sp)
    800043b2:	20913423          	sd	s1,520(sp)
    800043b6:	21213023          	sd	s2,512(sp)
    800043ba:	ffce                	sd	s3,504(sp)
    800043bc:	fbd2                	sd	s4,496(sp)
    800043be:	f7d6                	sd	s5,488(sp)
    800043c0:	f3da                	sd	s6,480(sp)
    800043c2:	efde                	sd	s7,472(sp)
    800043c4:	ebe2                	sd	s8,464(sp)
    800043c6:	e7e6                	sd	s9,456(sp)
    800043c8:	e3ea                	sd	s10,448(sp)
    800043ca:	ff6e                	sd	s11,440(sp)
    800043cc:	1400                	addi	s0,sp,544
    800043ce:	892a                	mv	s2,a0
    800043d0:	dea43423          	sd	a0,-536(s0)
    800043d4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043d8:	c0efd0ef          	jal	ra,800017e6 <myproc>
    800043dc:	84aa                	mv	s1,a0

  begin_op();
    800043de:	e0aff0ef          	jal	ra,800039e8 <begin_op>

  if((ip = namei(path)) == 0){
    800043e2:	854a                	mv	a0,s2
    800043e4:	c2cff0ef          	jal	ra,80003810 <namei>
    800043e8:	c13d                	beqz	a0,8000444e <exec+0xa8>
    800043ea:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043ec:	d73fe0ef          	jal	ra,8000315e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043f0:	04000713          	li	a4,64
    800043f4:	4681                	li	a3,0
    800043f6:	e5040613          	addi	a2,s0,-432
    800043fa:	4581                	li	a1,0
    800043fc:	8556                	mv	a0,s5
    800043fe:	fb1fe0ef          	jal	ra,800033ae <readi>
    80004402:	04000793          	li	a5,64
    80004406:	00f51a63          	bne	a0,a5,8000441a <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000440a:	e5042703          	lw	a4,-432(s0)
    8000440e:	464c47b7          	lui	a5,0x464c4
    80004412:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004416:	04f70063          	beq	a4,a5,80004456 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000441a:	8556                	mv	a0,s5
    8000441c:	f49fe0ef          	jal	ra,80003364 <iunlockput>
    end_op();
    80004420:	e38ff0ef          	jal	ra,80003a58 <end_op>
  }
  return -1;
    80004424:	557d                	li	a0,-1
}
    80004426:	21813083          	ld	ra,536(sp)
    8000442a:	21013403          	ld	s0,528(sp)
    8000442e:	20813483          	ld	s1,520(sp)
    80004432:	20013903          	ld	s2,512(sp)
    80004436:	79fe                	ld	s3,504(sp)
    80004438:	7a5e                	ld	s4,496(sp)
    8000443a:	7abe                	ld	s5,488(sp)
    8000443c:	7b1e                	ld	s6,480(sp)
    8000443e:	6bfe                	ld	s7,472(sp)
    80004440:	6c5e                	ld	s8,464(sp)
    80004442:	6cbe                	ld	s9,456(sp)
    80004444:	6d1e                	ld	s10,448(sp)
    80004446:	7dfa                	ld	s11,440(sp)
    80004448:	22010113          	addi	sp,sp,544
    8000444c:	8082                	ret
    end_op();
    8000444e:	e0aff0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004452:	557d                	li	a0,-1
    80004454:	bfc9                	j	80004426 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    80004456:	8526                	mv	a0,s1
    80004458:	c36fd0ef          	jal	ra,8000188e <proc_pagetable>
    8000445c:	8b2a                	mv	s6,a0
    8000445e:	dd55                	beqz	a0,8000441a <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004460:	e7042783          	lw	a5,-400(s0)
    80004464:	e8845703          	lhu	a4,-376(s0)
    80004468:	c325                	beqz	a4,800044c8 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000446a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000446c:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004470:	6a05                	lui	s4,0x1
    80004472:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004476:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000447a:	6d85                	lui	s11,0x1
    8000447c:	7d7d                	lui	s10,0xfffff
    8000447e:	a411                	j	80004682 <exec+0x2dc>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004480:	00003517          	auipc	a0,0x3
    80004484:	2c850513          	addi	a0,a0,712 # 80007748 <syscalls+0x288>
    80004488:	acefc0ef          	jal	ra,80000756 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000448c:	874a                	mv	a4,s2
    8000448e:	009c86bb          	addw	a3,s9,s1
    80004492:	4581                	li	a1,0
    80004494:	8556                	mv	a0,s5
    80004496:	f19fe0ef          	jal	ra,800033ae <readi>
    8000449a:	2501                	sext.w	a0,a0
    8000449c:	18a91263          	bne	s2,a0,80004620 <exec+0x27a>
  for(i = 0; i < sz; i += PGSIZE){
    800044a0:	009d84bb          	addw	s1,s11,s1
    800044a4:	013d09bb          	addw	s3,s10,s3
    800044a8:	1b74fd63          	bgeu	s1,s7,80004662 <exec+0x2bc>
    pa = walkaddr(pagetable, va + i);
    800044ac:	02049593          	slli	a1,s1,0x20
    800044b0:	9181                	srli	a1,a1,0x20
    800044b2:	95e2                	add	a1,a1,s8
    800044b4:	855a                	mv	a0,s6
    800044b6:	a89fc0ef          	jal	ra,80000f3e <walkaddr>
    800044ba:	862a                	mv	a2,a0
    if(pa == 0)
    800044bc:	d171                	beqz	a0,80004480 <exec+0xda>
      n = PGSIZE;
    800044be:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800044c0:	fd49f6e3          	bgeu	s3,s4,8000448c <exec+0xe6>
      n = sz - i;
    800044c4:	894e                	mv	s2,s3
    800044c6:	b7d9                	j	8000448c <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044c8:	4901                	li	s2,0
  iunlockput(ip);
    800044ca:	8556                	mv	a0,s5
    800044cc:	e99fe0ef          	jal	ra,80003364 <iunlockput>
  end_op();
    800044d0:	d88ff0ef          	jal	ra,80003a58 <end_op>
  p = myproc();
    800044d4:	b12fd0ef          	jal	ra,800017e6 <myproc>
    800044d8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800044da:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800044de:	6785                	lui	a5,0x1
    800044e0:	17fd                	addi	a5,a5,-1
    800044e2:	993e                	add	s2,s2,a5
    800044e4:	77fd                	lui	a5,0xfffff
    800044e6:	00f977b3          	and	a5,s2,a5
    800044ea:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800044ee:	4691                	li	a3,4
    800044f0:	6609                	lui	a2,0x2
    800044f2:	963e                	add	a2,a2,a5
    800044f4:	85be                	mv	a1,a5
    800044f6:	855a                	mv	a0,s6
    800044f8:	d9ffc0ef          	jal	ra,80001296 <uvmalloc>
    800044fc:	8c2a                	mv	s8,a0
  ip = 0;
    800044fe:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004500:	12050063          	beqz	a0,80004620 <exec+0x27a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004504:	75f9                	lui	a1,0xffffe
    80004506:	95aa                	add	a1,a1,a0
    80004508:	855a                	mv	a0,s6
    8000450a:	f67fc0ef          	jal	ra,80001470 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000450e:	7afd                	lui	s5,0xfffff
    80004510:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004512:	df043783          	ld	a5,-528(s0)
    80004516:	6388                	ld	a0,0(a5)
    80004518:	c135                	beqz	a0,8000457c <exec+0x1d6>
    8000451a:	e9040993          	addi	s3,s0,-368
    8000451e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004522:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004524:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004526:	8c1fc0ef          	jal	ra,80000de6 <strlen>
    8000452a:	0015079b          	addiw	a5,a0,1
    8000452e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004532:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004536:	11596a63          	bltu	s2,s5,8000464a <exec+0x2a4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000453a:	df043d83          	ld	s11,-528(s0)
    8000453e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004542:	8552                	mv	a0,s4
    80004544:	8a3fc0ef          	jal	ra,80000de6 <strlen>
    80004548:	0015069b          	addiw	a3,a0,1
    8000454c:	8652                	mv	a2,s4
    8000454e:	85ca                	mv	a1,s2
    80004550:	855a                	mv	a0,s6
    80004552:	f49fc0ef          	jal	ra,8000149a <copyout>
    80004556:	0e054e63          	bltz	a0,80004652 <exec+0x2ac>
    ustack[argc] = sp;
    8000455a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000455e:	0485                	addi	s1,s1,1
    80004560:	008d8793          	addi	a5,s11,8
    80004564:	def43823          	sd	a5,-528(s0)
    80004568:	008db503          	ld	a0,8(s11)
    8000456c:	c911                	beqz	a0,80004580 <exec+0x1da>
    if(argc >= MAXARG)
    8000456e:	09a1                	addi	s3,s3,8
    80004570:	fb3c9be3          	bne	s9,s3,80004526 <exec+0x180>
  sz = sz1;
    80004574:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004578:	4a81                	li	s5,0
    8000457a:	a05d                	j	80004620 <exec+0x27a>
  sp = sz;
    8000457c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000457e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004580:	00349793          	slli	a5,s1,0x3
    80004584:	f9040713          	addi	a4,s0,-112
    80004588:	97ba                	add	a5,a5,a4
    8000458a:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffde280>
  sp -= (argc+1) * sizeof(uint64);
    8000458e:	00148693          	addi	a3,s1,1
    80004592:	068e                	slli	a3,a3,0x3
    80004594:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004598:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000459c:	01597663          	bgeu	s2,s5,800045a8 <exec+0x202>
  sz = sz1;
    800045a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045a4:	4a81                	li	s5,0
    800045a6:	a8ad                	j	80004620 <exec+0x27a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045a8:	e9040613          	addi	a2,s0,-368
    800045ac:	85ca                	mv	a1,s2
    800045ae:	855a                	mv	a0,s6
    800045b0:	eebfc0ef          	jal	ra,8000149a <copyout>
    800045b4:	0a054363          	bltz	a0,8000465a <exec+0x2b4>
  p->trapframe->a1 = sp;
    800045b8:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800045bc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045c0:	de843783          	ld	a5,-536(s0)
    800045c4:	0007c703          	lbu	a4,0(a5)
    800045c8:	cf11                	beqz	a4,800045e4 <exec+0x23e>
    800045ca:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045cc:	02f00693          	li	a3,47
    800045d0:	a039                	j	800045de <exec+0x238>
      last = s+1;
    800045d2:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800045d6:	0785                	addi	a5,a5,1
    800045d8:	fff7c703          	lbu	a4,-1(a5)
    800045dc:	c701                	beqz	a4,800045e4 <exec+0x23e>
    if(*s == '/')
    800045de:	fed71ce3          	bne	a4,a3,800045d6 <exec+0x230>
    800045e2:	bfc5                	j	800045d2 <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    800045e4:	4641                	li	a2,16
    800045e6:	de843583          	ld	a1,-536(s0)
    800045ea:	158b8513          	addi	a0,s7,344
    800045ee:	fc6fc0ef          	jal	ra,80000db4 <safestrcpy>
  oldpagetable = p->pagetable;
    800045f2:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800045f6:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800045fa:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045fe:	058bb783          	ld	a5,88(s7)
    80004602:	e6843703          	ld	a4,-408(s0)
    80004606:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004608:	058bb783          	ld	a5,88(s7)
    8000460c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004610:	85ea                	mv	a1,s10
    80004612:	b00fd0ef          	jal	ra,80001912 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004616:	0004851b          	sext.w	a0,s1
    8000461a:	b531                	j	80004426 <exec+0x80>
    8000461c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004620:	df843583          	ld	a1,-520(s0)
    80004624:	855a                	mv	a0,s6
    80004626:	aecfd0ef          	jal	ra,80001912 <proc_freepagetable>
  if(ip){
    8000462a:	de0a98e3          	bnez	s5,8000441a <exec+0x74>
  return -1;
    8000462e:	557d                	li	a0,-1
    80004630:	bbdd                	j	80004426 <exec+0x80>
    80004632:	df243c23          	sd	s2,-520(s0)
    80004636:	b7ed                	j	80004620 <exec+0x27a>
    80004638:	df243c23          	sd	s2,-520(s0)
    8000463c:	b7d5                	j	80004620 <exec+0x27a>
    8000463e:	df243c23          	sd	s2,-520(s0)
    80004642:	bff9                	j	80004620 <exec+0x27a>
    80004644:	df243c23          	sd	s2,-520(s0)
    80004648:	bfe1                	j	80004620 <exec+0x27a>
  sz = sz1;
    8000464a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000464e:	4a81                	li	s5,0
    80004650:	bfc1                	j	80004620 <exec+0x27a>
  sz = sz1;
    80004652:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004656:	4a81                	li	s5,0
    80004658:	b7e1                	j	80004620 <exec+0x27a>
  sz = sz1;
    8000465a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000465e:	4a81                	li	s5,0
    80004660:	b7c1                	j	80004620 <exec+0x27a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004662:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004666:	e0843783          	ld	a5,-504(s0)
    8000466a:	0017869b          	addiw	a3,a5,1
    8000466e:	e0d43423          	sd	a3,-504(s0)
    80004672:	e0043783          	ld	a5,-512(s0)
    80004676:	0387879b          	addiw	a5,a5,56
    8000467a:	e8845703          	lhu	a4,-376(s0)
    8000467e:	e4e6d6e3          	bge	a3,a4,800044ca <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004682:	2781                	sext.w	a5,a5
    80004684:	e0f43023          	sd	a5,-512(s0)
    80004688:	03800713          	li	a4,56
    8000468c:	86be                	mv	a3,a5
    8000468e:	e1840613          	addi	a2,s0,-488
    80004692:	4581                	li	a1,0
    80004694:	8556                	mv	a0,s5
    80004696:	d19fe0ef          	jal	ra,800033ae <readi>
    8000469a:	03800793          	li	a5,56
    8000469e:	f6f51fe3          	bne	a0,a5,8000461c <exec+0x276>
    if(ph.type != ELF_PROG_LOAD)
    800046a2:	e1842783          	lw	a5,-488(s0)
    800046a6:	4705                	li	a4,1
    800046a8:	fae79fe3          	bne	a5,a4,80004666 <exec+0x2c0>
    if(ph.memsz < ph.filesz)
    800046ac:	e4043483          	ld	s1,-448(s0)
    800046b0:	e3843783          	ld	a5,-456(s0)
    800046b4:	f6f4efe3          	bltu	s1,a5,80004632 <exec+0x28c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800046b8:	e2843783          	ld	a5,-472(s0)
    800046bc:	94be                	add	s1,s1,a5
    800046be:	f6f4ede3          	bltu	s1,a5,80004638 <exec+0x292>
    if(ph.vaddr % PGSIZE != 0)
    800046c2:	de043703          	ld	a4,-544(s0)
    800046c6:	8ff9                	and	a5,a5,a4
    800046c8:	fbbd                	bnez	a5,8000463e <exec+0x298>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046ca:	e1c42503          	lw	a0,-484(s0)
    800046ce:	cbdff0ef          	jal	ra,8000438a <flags2perm>
    800046d2:	86aa                	mv	a3,a0
    800046d4:	8626                	mv	a2,s1
    800046d6:	85ca                	mv	a1,s2
    800046d8:	855a                	mv	a0,s6
    800046da:	bbdfc0ef          	jal	ra,80001296 <uvmalloc>
    800046de:	dea43c23          	sd	a0,-520(s0)
    800046e2:	d12d                	beqz	a0,80004644 <exec+0x29e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046e4:	e2843c03          	ld	s8,-472(s0)
    800046e8:	e2042c83          	lw	s9,-480(s0)
    800046ec:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046f0:	f60b89e3          	beqz	s7,80004662 <exec+0x2bc>
    800046f4:	89de                	mv	s3,s7
    800046f6:	4481                	li	s1,0
    800046f8:	bb55                	j	800044ac <exec+0x106>

00000000800046fa <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046fa:	7179                	addi	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	ec26                	sd	s1,24(sp)
    80004702:	e84a                	sd	s2,16(sp)
    80004704:	1800                	addi	s0,sp,48
    80004706:	892e                	mv	s2,a1
    80004708:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000470a:	fdc40593          	addi	a1,s0,-36
    8000470e:	f85fd0ef          	jal	ra,80002692 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004712:	fdc42703          	lw	a4,-36(s0)
    80004716:	47bd                	li	a5,15
    80004718:	02e7e963          	bltu	a5,a4,8000474a <argfd+0x50>
    8000471c:	8cafd0ef          	jal	ra,800017e6 <myproc>
    80004720:	fdc42703          	lw	a4,-36(s0)
    80004724:	01a70793          	addi	a5,a4,26
    80004728:	078e                	slli	a5,a5,0x3
    8000472a:	953e                	add	a0,a0,a5
    8000472c:	611c                	ld	a5,0(a0)
    8000472e:	c385                	beqz	a5,8000474e <argfd+0x54>
    return -1;
  if(pfd)
    80004730:	00090463          	beqz	s2,80004738 <argfd+0x3e>
    *pfd = fd;
    80004734:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004738:	4501                	li	a0,0
  if(pf)
    8000473a:	c091                	beqz	s1,8000473e <argfd+0x44>
    *pf = f;
    8000473c:	e09c                	sd	a5,0(s1)
}
    8000473e:	70a2                	ld	ra,40(sp)
    80004740:	7402                	ld	s0,32(sp)
    80004742:	64e2                	ld	s1,24(sp)
    80004744:	6942                	ld	s2,16(sp)
    80004746:	6145                	addi	sp,sp,48
    80004748:	8082                	ret
    return -1;
    8000474a:	557d                	li	a0,-1
    8000474c:	bfcd                	j	8000473e <argfd+0x44>
    8000474e:	557d                	li	a0,-1
    80004750:	b7fd                	j	8000473e <argfd+0x44>

0000000080004752 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004752:	1101                	addi	sp,sp,-32
    80004754:	ec06                	sd	ra,24(sp)
    80004756:	e822                	sd	s0,16(sp)
    80004758:	e426                	sd	s1,8(sp)
    8000475a:	1000                	addi	s0,sp,32
    8000475c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000475e:	888fd0ef          	jal	ra,800017e6 <myproc>
    80004762:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004764:	0d050793          	addi	a5,a0,208
    80004768:	4501                	li	a0,0
    8000476a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000476c:	6398                	ld	a4,0(a5)
    8000476e:	cb19                	beqz	a4,80004784 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004770:	2505                	addiw	a0,a0,1
    80004772:	07a1                	addi	a5,a5,8
    80004774:	fed51ce3          	bne	a0,a3,8000476c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004778:	557d                	li	a0,-1
}
    8000477a:	60e2                	ld	ra,24(sp)
    8000477c:	6442                	ld	s0,16(sp)
    8000477e:	64a2                	ld	s1,8(sp)
    80004780:	6105                	addi	sp,sp,32
    80004782:	8082                	ret
      p->ofile[fd] = f;
    80004784:	01a50793          	addi	a5,a0,26
    80004788:	078e                	slli	a5,a5,0x3
    8000478a:	963e                	add	a2,a2,a5
    8000478c:	e204                	sd	s1,0(a2)
      return fd;
    8000478e:	b7f5                	j	8000477a <fdalloc+0x28>

0000000080004790 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004790:	715d                	addi	sp,sp,-80
    80004792:	e486                	sd	ra,72(sp)
    80004794:	e0a2                	sd	s0,64(sp)
    80004796:	fc26                	sd	s1,56(sp)
    80004798:	f84a                	sd	s2,48(sp)
    8000479a:	f44e                	sd	s3,40(sp)
    8000479c:	f052                	sd	s4,32(sp)
    8000479e:	ec56                	sd	s5,24(sp)
    800047a0:	e85a                	sd	s6,16(sp)
    800047a2:	0880                	addi	s0,sp,80
    800047a4:	8b2e                	mv	s6,a1
    800047a6:	89b2                	mv	s3,a2
    800047a8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800047aa:	fb040593          	addi	a1,s0,-80
    800047ae:	87cff0ef          	jal	ra,8000382a <nameiparent>
    800047b2:	84aa                	mv	s1,a0
    800047b4:	10050b63          	beqz	a0,800048ca <create+0x13a>
    return 0;

  ilock(dp);
    800047b8:	9a7fe0ef          	jal	ra,8000315e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047bc:	4601                	li	a2,0
    800047be:	fb040593          	addi	a1,s0,-80
    800047c2:	8526                	mv	a0,s1
    800047c4:	de7fe0ef          	jal	ra,800035aa <dirlookup>
    800047c8:	8aaa                	mv	s5,a0
    800047ca:	c521                	beqz	a0,80004812 <create+0x82>
    iunlockput(dp);
    800047cc:	8526                	mv	a0,s1
    800047ce:	b97fe0ef          	jal	ra,80003364 <iunlockput>
    ilock(ip);
    800047d2:	8556                	mv	a0,s5
    800047d4:	98bfe0ef          	jal	ra,8000315e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047d8:	000b059b          	sext.w	a1,s6
    800047dc:	4789                	li	a5,2
    800047de:	02f59563          	bne	a1,a5,80004808 <create+0x78>
    800047e2:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffde3c4>
    800047e6:	37f9                	addiw	a5,a5,-2
    800047e8:	17c2                	slli	a5,a5,0x30
    800047ea:	93c1                	srli	a5,a5,0x30
    800047ec:	4705                	li	a4,1
    800047ee:	00f76d63          	bltu	a4,a5,80004808 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800047f2:	8556                	mv	a0,s5
    800047f4:	60a6                	ld	ra,72(sp)
    800047f6:	6406                	ld	s0,64(sp)
    800047f8:	74e2                	ld	s1,56(sp)
    800047fa:	7942                	ld	s2,48(sp)
    800047fc:	79a2                	ld	s3,40(sp)
    800047fe:	7a02                	ld	s4,32(sp)
    80004800:	6ae2                	ld	s5,24(sp)
    80004802:	6b42                	ld	s6,16(sp)
    80004804:	6161                	addi	sp,sp,80
    80004806:	8082                	ret
    iunlockput(ip);
    80004808:	8556                	mv	a0,s5
    8000480a:	b5bfe0ef          	jal	ra,80003364 <iunlockput>
    return 0;
    8000480e:	4a81                	li	s5,0
    80004810:	b7cd                	j	800047f2 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004812:	85da                	mv	a1,s6
    80004814:	4088                	lw	a0,0(s1)
    80004816:	fe0fe0ef          	jal	ra,80002ff6 <ialloc>
    8000481a:	8a2a                	mv	s4,a0
    8000481c:	cd1d                	beqz	a0,8000485a <create+0xca>
  ilock(ip);
    8000481e:	941fe0ef          	jal	ra,8000315e <ilock>
  ip->major = major;
    80004822:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004826:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000482a:	4905                	li	s2,1
    8000482c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004830:	8552                	mv	a0,s4
    80004832:	87bfe0ef          	jal	ra,800030ac <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004836:	000b059b          	sext.w	a1,s6
    8000483a:	03258563          	beq	a1,s2,80004864 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    8000483e:	004a2603          	lw	a2,4(s4)
    80004842:	fb040593          	addi	a1,s0,-80
    80004846:	8526                	mv	a0,s1
    80004848:	f2ffe0ef          	jal	ra,80003776 <dirlink>
    8000484c:	06054363          	bltz	a0,800048b2 <create+0x122>
  iunlockput(dp);
    80004850:	8526                	mv	a0,s1
    80004852:	b13fe0ef          	jal	ra,80003364 <iunlockput>
  return ip;
    80004856:	8ad2                	mv	s5,s4
    80004858:	bf69                	j	800047f2 <create+0x62>
    iunlockput(dp);
    8000485a:	8526                	mv	a0,s1
    8000485c:	b09fe0ef          	jal	ra,80003364 <iunlockput>
    return 0;
    80004860:	8ad2                	mv	s5,s4
    80004862:	bf41                	j	800047f2 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004864:	004a2603          	lw	a2,4(s4)
    80004868:	00003597          	auipc	a1,0x3
    8000486c:	f0058593          	addi	a1,a1,-256 # 80007768 <syscalls+0x2a8>
    80004870:	8552                	mv	a0,s4
    80004872:	f05fe0ef          	jal	ra,80003776 <dirlink>
    80004876:	02054e63          	bltz	a0,800048b2 <create+0x122>
    8000487a:	40d0                	lw	a2,4(s1)
    8000487c:	00003597          	auipc	a1,0x3
    80004880:	ef458593          	addi	a1,a1,-268 # 80007770 <syscalls+0x2b0>
    80004884:	8552                	mv	a0,s4
    80004886:	ef1fe0ef          	jal	ra,80003776 <dirlink>
    8000488a:	02054463          	bltz	a0,800048b2 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    8000488e:	004a2603          	lw	a2,4(s4)
    80004892:	fb040593          	addi	a1,s0,-80
    80004896:	8526                	mv	a0,s1
    80004898:	edffe0ef          	jal	ra,80003776 <dirlink>
    8000489c:	00054b63          	bltz	a0,800048b2 <create+0x122>
    dp->nlink++;  // for ".."
    800048a0:	04a4d783          	lhu	a5,74(s1)
    800048a4:	2785                	addiw	a5,a5,1
    800048a6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800048aa:	8526                	mv	a0,s1
    800048ac:	801fe0ef          	jal	ra,800030ac <iupdate>
    800048b0:	b745                	j	80004850 <create+0xc0>
  ip->nlink = 0;
    800048b2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800048b6:	8552                	mv	a0,s4
    800048b8:	ff4fe0ef          	jal	ra,800030ac <iupdate>
  iunlockput(ip);
    800048bc:	8552                	mv	a0,s4
    800048be:	aa7fe0ef          	jal	ra,80003364 <iunlockput>
  iunlockput(dp);
    800048c2:	8526                	mv	a0,s1
    800048c4:	aa1fe0ef          	jal	ra,80003364 <iunlockput>
  return 0;
    800048c8:	b72d                	j	800047f2 <create+0x62>
    return 0;
    800048ca:	8aaa                	mv	s5,a0
    800048cc:	b71d                	j	800047f2 <create+0x62>

00000000800048ce <sys_dup>:
{
    800048ce:	7179                	addi	sp,sp,-48
    800048d0:	f406                	sd	ra,40(sp)
    800048d2:	f022                	sd	s0,32(sp)
    800048d4:	ec26                	sd	s1,24(sp)
    800048d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048d8:	fd840613          	addi	a2,s0,-40
    800048dc:	4581                	li	a1,0
    800048de:	4501                	li	a0,0
    800048e0:	e1bff0ef          	jal	ra,800046fa <argfd>
    return -1;
    800048e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048e6:	00054f63          	bltz	a0,80004904 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    800048ea:	fd843503          	ld	a0,-40(s0)
    800048ee:	e65ff0ef          	jal	ra,80004752 <fdalloc>
    800048f2:	84aa                	mv	s1,a0
    return -1;
    800048f4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048f6:	00054763          	bltz	a0,80004904 <sys_dup+0x36>
  filedup(f);
    800048fa:	fd843503          	ld	a0,-40(s0)
    800048fe:	cc0ff0ef          	jal	ra,80003dbe <filedup>
  return fd;
    80004902:	87a6                	mv	a5,s1
}
    80004904:	853e                	mv	a0,a5
    80004906:	70a2                	ld	ra,40(sp)
    80004908:	7402                	ld	s0,32(sp)
    8000490a:	64e2                	ld	s1,24(sp)
    8000490c:	6145                	addi	sp,sp,48
    8000490e:	8082                	ret

0000000080004910 <sys_read>:
{
    80004910:	7179                	addi	sp,sp,-48
    80004912:	f406                	sd	ra,40(sp)
    80004914:	f022                	sd	s0,32(sp)
    80004916:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004918:	fd840593          	addi	a1,s0,-40
    8000491c:	4505                	li	a0,1
    8000491e:	d91fd0ef          	jal	ra,800026ae <argaddr>
  argint(2, &n);
    80004922:	fe440593          	addi	a1,s0,-28
    80004926:	4509                	li	a0,2
    80004928:	d6bfd0ef          	jal	ra,80002692 <argint>
  if(argfd(0, 0, &f) < 0)
    8000492c:	fe840613          	addi	a2,s0,-24
    80004930:	4581                	li	a1,0
    80004932:	4501                	li	a0,0
    80004934:	dc7ff0ef          	jal	ra,800046fa <argfd>
    80004938:	87aa                	mv	a5,a0
    return -1;
    8000493a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000493c:	0007ca63          	bltz	a5,80004950 <sys_read+0x40>
  return fileread(f, p, n);
    80004940:	fe442603          	lw	a2,-28(s0)
    80004944:	fd843583          	ld	a1,-40(s0)
    80004948:	fe843503          	ld	a0,-24(s0)
    8000494c:	dbeff0ef          	jal	ra,80003f0a <fileread>
}
    80004950:	70a2                	ld	ra,40(sp)
    80004952:	7402                	ld	s0,32(sp)
    80004954:	6145                	addi	sp,sp,48
    80004956:	8082                	ret

0000000080004958 <sys_write>:
{
    80004958:	7179                	addi	sp,sp,-48
    8000495a:	f406                	sd	ra,40(sp)
    8000495c:	f022                	sd	s0,32(sp)
    8000495e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004960:	fd840593          	addi	a1,s0,-40
    80004964:	4505                	li	a0,1
    80004966:	d49fd0ef          	jal	ra,800026ae <argaddr>
  argint(2, &n);
    8000496a:	fe440593          	addi	a1,s0,-28
    8000496e:	4509                	li	a0,2
    80004970:	d23fd0ef          	jal	ra,80002692 <argint>
  if(argfd(0, 0, &f) < 0)
    80004974:	fe840613          	addi	a2,s0,-24
    80004978:	4581                	li	a1,0
    8000497a:	4501                	li	a0,0
    8000497c:	d7fff0ef          	jal	ra,800046fa <argfd>
    80004980:	87aa                	mv	a5,a0
    return -1;
    80004982:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004984:	0007ca63          	bltz	a5,80004998 <sys_write+0x40>
  return filewrite(f, p, n);
    80004988:	fe442603          	lw	a2,-28(s0)
    8000498c:	fd843583          	ld	a1,-40(s0)
    80004990:	fe843503          	ld	a0,-24(s0)
    80004994:	e24ff0ef          	jal	ra,80003fb8 <filewrite>
}
    80004998:	70a2                	ld	ra,40(sp)
    8000499a:	7402                	ld	s0,32(sp)
    8000499c:	6145                	addi	sp,sp,48
    8000499e:	8082                	ret

00000000800049a0 <sys_close>:
{
    800049a0:	1101                	addi	sp,sp,-32
    800049a2:	ec06                	sd	ra,24(sp)
    800049a4:	e822                	sd	s0,16(sp)
    800049a6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a8:	fe040613          	addi	a2,s0,-32
    800049ac:	fec40593          	addi	a1,s0,-20
    800049b0:	4501                	li	a0,0
    800049b2:	d49ff0ef          	jal	ra,800046fa <argfd>
    return -1;
    800049b6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049b8:	02054063          	bltz	a0,800049d8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800049bc:	e2bfc0ef          	jal	ra,800017e6 <myproc>
    800049c0:	fec42783          	lw	a5,-20(s0)
    800049c4:	07e9                	addi	a5,a5,26
    800049c6:	078e                	slli	a5,a5,0x3
    800049c8:	97aa                	add	a5,a5,a0
    800049ca:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049ce:	fe043503          	ld	a0,-32(s0)
    800049d2:	c32ff0ef          	jal	ra,80003e04 <fileclose>
  return 0;
    800049d6:	4781                	li	a5,0
}
    800049d8:	853e                	mv	a0,a5
    800049da:	60e2                	ld	ra,24(sp)
    800049dc:	6442                	ld	s0,16(sp)
    800049de:	6105                	addi	sp,sp,32
    800049e0:	8082                	ret

00000000800049e2 <sys_fstat>:
{
    800049e2:	1101                	addi	sp,sp,-32
    800049e4:	ec06                	sd	ra,24(sp)
    800049e6:	e822                	sd	s0,16(sp)
    800049e8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049ea:	fe040593          	addi	a1,s0,-32
    800049ee:	4505                	li	a0,1
    800049f0:	cbffd0ef          	jal	ra,800026ae <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049f4:	fe840613          	addi	a2,s0,-24
    800049f8:	4581                	li	a1,0
    800049fa:	4501                	li	a0,0
    800049fc:	cffff0ef          	jal	ra,800046fa <argfd>
    80004a00:	87aa                	mv	a5,a0
    return -1;
    80004a02:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a04:	0007c863          	bltz	a5,80004a14 <sys_fstat+0x32>
  return filestat(f, st);
    80004a08:	fe043583          	ld	a1,-32(s0)
    80004a0c:	fe843503          	ld	a0,-24(s0)
    80004a10:	c9cff0ef          	jal	ra,80003eac <filestat>
}
    80004a14:	60e2                	ld	ra,24(sp)
    80004a16:	6442                	ld	s0,16(sp)
    80004a18:	6105                	addi	sp,sp,32
    80004a1a:	8082                	ret

0000000080004a1c <sys_link>:
{
    80004a1c:	7169                	addi	sp,sp,-304
    80004a1e:	f606                	sd	ra,296(sp)
    80004a20:	f222                	sd	s0,288(sp)
    80004a22:	ee26                	sd	s1,280(sp)
    80004a24:	ea4a                	sd	s2,272(sp)
    80004a26:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a28:	08000613          	li	a2,128
    80004a2c:	ed040593          	addi	a1,s0,-304
    80004a30:	4501                	li	a0,0
    80004a32:	c99fd0ef          	jal	ra,800026ca <argstr>
    return -1;
    80004a36:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a38:	0c054663          	bltz	a0,80004b04 <sys_link+0xe8>
    80004a3c:	08000613          	li	a2,128
    80004a40:	f5040593          	addi	a1,s0,-176
    80004a44:	4505                	li	a0,1
    80004a46:	c85fd0ef          	jal	ra,800026ca <argstr>
    return -1;
    80004a4a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a4c:	0a054c63          	bltz	a0,80004b04 <sys_link+0xe8>
  begin_op();
    80004a50:	f99fe0ef          	jal	ra,800039e8 <begin_op>
  if((ip = namei(old)) == 0){
    80004a54:	ed040513          	addi	a0,s0,-304
    80004a58:	db9fe0ef          	jal	ra,80003810 <namei>
    80004a5c:	84aa                	mv	s1,a0
    80004a5e:	c525                	beqz	a0,80004ac6 <sys_link+0xaa>
  ilock(ip);
    80004a60:	efefe0ef          	jal	ra,8000315e <ilock>
  if(ip->type == T_DIR){
    80004a64:	04449703          	lh	a4,68(s1)
    80004a68:	4785                	li	a5,1
    80004a6a:	06f70263          	beq	a4,a5,80004ace <sys_link+0xb2>
  ip->nlink++;
    80004a6e:	04a4d783          	lhu	a5,74(s1)
    80004a72:	2785                	addiw	a5,a5,1
    80004a74:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a78:	8526                	mv	a0,s1
    80004a7a:	e32fe0ef          	jal	ra,800030ac <iupdate>
  iunlock(ip);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	f88fe0ef          	jal	ra,80003208 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a84:	fd040593          	addi	a1,s0,-48
    80004a88:	f5040513          	addi	a0,s0,-176
    80004a8c:	d9ffe0ef          	jal	ra,8000382a <nameiparent>
    80004a90:	892a                	mv	s2,a0
    80004a92:	c921                	beqz	a0,80004ae2 <sys_link+0xc6>
  ilock(dp);
    80004a94:	ecafe0ef          	jal	ra,8000315e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a98:	00092703          	lw	a4,0(s2)
    80004a9c:	409c                	lw	a5,0(s1)
    80004a9e:	02f71f63          	bne	a4,a5,80004adc <sys_link+0xc0>
    80004aa2:	40d0                	lw	a2,4(s1)
    80004aa4:	fd040593          	addi	a1,s0,-48
    80004aa8:	854a                	mv	a0,s2
    80004aaa:	ccdfe0ef          	jal	ra,80003776 <dirlink>
    80004aae:	02054763          	bltz	a0,80004adc <sys_link+0xc0>
  iunlockput(dp);
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	8b1fe0ef          	jal	ra,80003364 <iunlockput>
  iput(ip);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	823fe0ef          	jal	ra,800032dc <iput>
  end_op();
    80004abe:	f9bfe0ef          	jal	ra,80003a58 <end_op>
  return 0;
    80004ac2:	4781                	li	a5,0
    80004ac4:	a081                	j	80004b04 <sys_link+0xe8>
    end_op();
    80004ac6:	f93fe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004aca:	57fd                	li	a5,-1
    80004acc:	a825                	j	80004b04 <sys_link+0xe8>
    iunlockput(ip);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	895fe0ef          	jal	ra,80003364 <iunlockput>
    end_op();
    80004ad4:	f85fe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004ad8:	57fd                	li	a5,-1
    80004ada:	a02d                	j	80004b04 <sys_link+0xe8>
    iunlockput(dp);
    80004adc:	854a                	mv	a0,s2
    80004ade:	887fe0ef          	jal	ra,80003364 <iunlockput>
  ilock(ip);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	e7afe0ef          	jal	ra,8000315e <ilock>
  ip->nlink--;
    80004ae8:	04a4d783          	lhu	a5,74(s1)
    80004aec:	37fd                	addiw	a5,a5,-1
    80004aee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004af2:	8526                	mv	a0,s1
    80004af4:	db8fe0ef          	jal	ra,800030ac <iupdate>
  iunlockput(ip);
    80004af8:	8526                	mv	a0,s1
    80004afa:	86bfe0ef          	jal	ra,80003364 <iunlockput>
  end_op();
    80004afe:	f5bfe0ef          	jal	ra,80003a58 <end_op>
  return -1;
    80004b02:	57fd                	li	a5,-1
}
    80004b04:	853e                	mv	a0,a5
    80004b06:	70b2                	ld	ra,296(sp)
    80004b08:	7412                	ld	s0,288(sp)
    80004b0a:	64f2                	ld	s1,280(sp)
    80004b0c:	6952                	ld	s2,272(sp)
    80004b0e:	6155                	addi	sp,sp,304
    80004b10:	8082                	ret

0000000080004b12 <sys_unlink>:
{
    80004b12:	7151                	addi	sp,sp,-240
    80004b14:	f586                	sd	ra,232(sp)
    80004b16:	f1a2                	sd	s0,224(sp)
    80004b18:	eda6                	sd	s1,216(sp)
    80004b1a:	e9ca                	sd	s2,208(sp)
    80004b1c:	e5ce                	sd	s3,200(sp)
    80004b1e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b20:	08000613          	li	a2,128
    80004b24:	f3040593          	addi	a1,s0,-208
    80004b28:	4501                	li	a0,0
    80004b2a:	ba1fd0ef          	jal	ra,800026ca <argstr>
    80004b2e:	12054b63          	bltz	a0,80004c64 <sys_unlink+0x152>
  begin_op();
    80004b32:	eb7fe0ef          	jal	ra,800039e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b36:	fb040593          	addi	a1,s0,-80
    80004b3a:	f3040513          	addi	a0,s0,-208
    80004b3e:	cedfe0ef          	jal	ra,8000382a <nameiparent>
    80004b42:	84aa                	mv	s1,a0
    80004b44:	c54d                	beqz	a0,80004bee <sys_unlink+0xdc>
  ilock(dp);
    80004b46:	e18fe0ef          	jal	ra,8000315e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b4a:	00003597          	auipc	a1,0x3
    80004b4e:	c1e58593          	addi	a1,a1,-994 # 80007768 <syscalls+0x2a8>
    80004b52:	fb040513          	addi	a0,s0,-80
    80004b56:	a3ffe0ef          	jal	ra,80003594 <namecmp>
    80004b5a:	10050a63          	beqz	a0,80004c6e <sys_unlink+0x15c>
    80004b5e:	00003597          	auipc	a1,0x3
    80004b62:	c1258593          	addi	a1,a1,-1006 # 80007770 <syscalls+0x2b0>
    80004b66:	fb040513          	addi	a0,s0,-80
    80004b6a:	a2bfe0ef          	jal	ra,80003594 <namecmp>
    80004b6e:	10050063          	beqz	a0,80004c6e <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b72:	f2c40613          	addi	a2,s0,-212
    80004b76:	fb040593          	addi	a1,s0,-80
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	a2ffe0ef          	jal	ra,800035aa <dirlookup>
    80004b80:	892a                	mv	s2,a0
    80004b82:	0e050663          	beqz	a0,80004c6e <sys_unlink+0x15c>
  ilock(ip);
    80004b86:	dd8fe0ef          	jal	ra,8000315e <ilock>
  if(ip->nlink < 1)
    80004b8a:	04a91783          	lh	a5,74(s2)
    80004b8e:	06f05463          	blez	a5,80004bf6 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b92:	04491703          	lh	a4,68(s2)
    80004b96:	4785                	li	a5,1
    80004b98:	06f70563          	beq	a4,a5,80004c02 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004b9c:	4641                	li	a2,16
    80004b9e:	4581                	li	a1,0
    80004ba0:	fc040513          	addi	a0,s0,-64
    80004ba4:	8cafc0ef          	jal	ra,80000c6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba8:	4741                	li	a4,16
    80004baa:	f2c42683          	lw	a3,-212(s0)
    80004bae:	fc040613          	addi	a2,s0,-64
    80004bb2:	4581                	li	a1,0
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	8ddfe0ef          	jal	ra,80003492 <writei>
    80004bba:	47c1                	li	a5,16
    80004bbc:	08f51563          	bne	a0,a5,80004c46 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004bc0:	04491703          	lh	a4,68(s2)
    80004bc4:	4785                	li	a5,1
    80004bc6:	08f70663          	beq	a4,a5,80004c52 <sys_unlink+0x140>
  iunlockput(dp);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	f98fe0ef          	jal	ra,80003364 <iunlockput>
  ip->nlink--;
    80004bd0:	04a95783          	lhu	a5,74(s2)
    80004bd4:	37fd                	addiw	a5,a5,-1
    80004bd6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bda:	854a                	mv	a0,s2
    80004bdc:	cd0fe0ef          	jal	ra,800030ac <iupdate>
  iunlockput(ip);
    80004be0:	854a                	mv	a0,s2
    80004be2:	f82fe0ef          	jal	ra,80003364 <iunlockput>
  end_op();
    80004be6:	e73fe0ef          	jal	ra,80003a58 <end_op>
  return 0;
    80004bea:	4501                	li	a0,0
    80004bec:	a079                	j	80004c7a <sys_unlink+0x168>
    end_op();
    80004bee:	e6bfe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004bf2:	557d                	li	a0,-1
    80004bf4:	a059                	j	80004c7a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004bf6:	00003517          	auipc	a0,0x3
    80004bfa:	b8250513          	addi	a0,a0,-1150 # 80007778 <syscalls+0x2b8>
    80004bfe:	b59fb0ef          	jal	ra,80000756 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c02:	04c92703          	lw	a4,76(s2)
    80004c06:	02000793          	li	a5,32
    80004c0a:	f8e7f9e3          	bgeu	a5,a4,80004b9c <sys_unlink+0x8a>
    80004c0e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c12:	4741                	li	a4,16
    80004c14:	86ce                	mv	a3,s3
    80004c16:	f1840613          	addi	a2,s0,-232
    80004c1a:	4581                	li	a1,0
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	f90fe0ef          	jal	ra,800033ae <readi>
    80004c22:	47c1                	li	a5,16
    80004c24:	00f51b63          	bne	a0,a5,80004c3a <sys_unlink+0x128>
    if(de.inum != 0)
    80004c28:	f1845783          	lhu	a5,-232(s0)
    80004c2c:	ef95                	bnez	a5,80004c68 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c2e:	29c1                	addiw	s3,s3,16
    80004c30:	04c92783          	lw	a5,76(s2)
    80004c34:	fcf9efe3          	bltu	s3,a5,80004c12 <sys_unlink+0x100>
    80004c38:	b795                	j	80004b9c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004c3a:	00003517          	auipc	a0,0x3
    80004c3e:	b5650513          	addi	a0,a0,-1194 # 80007790 <syscalls+0x2d0>
    80004c42:	b15fb0ef          	jal	ra,80000756 <panic>
    panic("unlink: writei");
    80004c46:	00003517          	auipc	a0,0x3
    80004c4a:	b6250513          	addi	a0,a0,-1182 # 800077a8 <syscalls+0x2e8>
    80004c4e:	b09fb0ef          	jal	ra,80000756 <panic>
    dp->nlink--;
    80004c52:	04a4d783          	lhu	a5,74(s1)
    80004c56:	37fd                	addiw	a5,a5,-1
    80004c58:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	c4efe0ef          	jal	ra,800030ac <iupdate>
    80004c62:	b7a5                	j	80004bca <sys_unlink+0xb8>
    return -1;
    80004c64:	557d                	li	a0,-1
    80004c66:	a811                	j	80004c7a <sys_unlink+0x168>
    iunlockput(ip);
    80004c68:	854a                	mv	a0,s2
    80004c6a:	efafe0ef          	jal	ra,80003364 <iunlockput>
  iunlockput(dp);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ef4fe0ef          	jal	ra,80003364 <iunlockput>
  end_op();
    80004c74:	de5fe0ef          	jal	ra,80003a58 <end_op>
  return -1;
    80004c78:	557d                	li	a0,-1
}
    80004c7a:	70ae                	ld	ra,232(sp)
    80004c7c:	740e                	ld	s0,224(sp)
    80004c7e:	64ee                	ld	s1,216(sp)
    80004c80:	694e                	ld	s2,208(sp)
    80004c82:	69ae                	ld	s3,200(sp)
    80004c84:	616d                	addi	sp,sp,240
    80004c86:	8082                	ret

0000000080004c88 <sys_open>:

uint64
sys_open(void)
{
    80004c88:	7131                	addi	sp,sp,-192
    80004c8a:	fd06                	sd	ra,184(sp)
    80004c8c:	f922                	sd	s0,176(sp)
    80004c8e:	f526                	sd	s1,168(sp)
    80004c90:	f14a                	sd	s2,160(sp)
    80004c92:	ed4e                	sd	s3,152(sp)
    80004c94:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c96:	f4c40593          	addi	a1,s0,-180
    80004c9a:	4505                	li	a0,1
    80004c9c:	9f7fd0ef          	jal	ra,80002692 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ca0:	08000613          	li	a2,128
    80004ca4:	f5040593          	addi	a1,s0,-176
    80004ca8:	4501                	li	a0,0
    80004caa:	a21fd0ef          	jal	ra,800026ca <argstr>
    80004cae:	87aa                	mv	a5,a0
    return -1;
    80004cb0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cb2:	0807cd63          	bltz	a5,80004d4c <sys_open+0xc4>

  begin_op();
    80004cb6:	d33fe0ef          	jal	ra,800039e8 <begin_op>

  if(omode & O_CREATE){
    80004cba:	f4c42783          	lw	a5,-180(s0)
    80004cbe:	2007f793          	andi	a5,a5,512
    80004cc2:	c3c5                	beqz	a5,80004d62 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004cc4:	4681                	li	a3,0
    80004cc6:	4601                	li	a2,0
    80004cc8:	4589                	li	a1,2
    80004cca:	f5040513          	addi	a0,s0,-176
    80004cce:	ac3ff0ef          	jal	ra,80004790 <create>
    80004cd2:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cd4:	c159                	beqz	a0,80004d5a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cd6:	04449703          	lh	a4,68(s1)
    80004cda:	478d                	li	a5,3
    80004cdc:	00f71763          	bne	a4,a5,80004cea <sys_open+0x62>
    80004ce0:	0464d703          	lhu	a4,70(s1)
    80004ce4:	47a5                	li	a5,9
    80004ce6:	0ae7e963          	bltu	a5,a4,80004d98 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cea:	876ff0ef          	jal	ra,80003d60 <filealloc>
    80004cee:	89aa                	mv	s3,a0
    80004cf0:	0c050963          	beqz	a0,80004dc2 <sys_open+0x13a>
    80004cf4:	a5fff0ef          	jal	ra,80004752 <fdalloc>
    80004cf8:	892a                	mv	s2,a0
    80004cfa:	0c054163          	bltz	a0,80004dbc <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cfe:	04449703          	lh	a4,68(s1)
    80004d02:	478d                	li	a5,3
    80004d04:	0af70163          	beq	a4,a5,80004da6 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d08:	4789                	li	a5,2
    80004d0a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d0e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d12:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d16:	f4c42783          	lw	a5,-180(s0)
    80004d1a:	0017c713          	xori	a4,a5,1
    80004d1e:	8b05                	andi	a4,a4,1
    80004d20:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d24:	0037f713          	andi	a4,a5,3
    80004d28:	00e03733          	snez	a4,a4
    80004d2c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d30:	4007f793          	andi	a5,a5,1024
    80004d34:	c791                	beqz	a5,80004d40 <sys_open+0xb8>
    80004d36:	04449703          	lh	a4,68(s1)
    80004d3a:	4789                	li	a5,2
    80004d3c:	06f70c63          	beq	a4,a5,80004db4 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d40:	8526                	mv	a0,s1
    80004d42:	cc6fe0ef          	jal	ra,80003208 <iunlock>
  end_op();
    80004d46:	d13fe0ef          	jal	ra,80003a58 <end_op>

  return fd;
    80004d4a:	854a                	mv	a0,s2
}
    80004d4c:	70ea                	ld	ra,184(sp)
    80004d4e:	744a                	ld	s0,176(sp)
    80004d50:	74aa                	ld	s1,168(sp)
    80004d52:	790a                	ld	s2,160(sp)
    80004d54:	69ea                	ld	s3,152(sp)
    80004d56:	6129                	addi	sp,sp,192
    80004d58:	8082                	ret
      end_op();
    80004d5a:	cfffe0ef          	jal	ra,80003a58 <end_op>
      return -1;
    80004d5e:	557d                	li	a0,-1
    80004d60:	b7f5                	j	80004d4c <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004d62:	f5040513          	addi	a0,s0,-176
    80004d66:	aabfe0ef          	jal	ra,80003810 <namei>
    80004d6a:	84aa                	mv	s1,a0
    80004d6c:	c115                	beqz	a0,80004d90 <sys_open+0x108>
    ilock(ip);
    80004d6e:	bf0fe0ef          	jal	ra,8000315e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d72:	04449703          	lh	a4,68(s1)
    80004d76:	4785                	li	a5,1
    80004d78:	f4f71fe3          	bne	a4,a5,80004cd6 <sys_open+0x4e>
    80004d7c:	f4c42783          	lw	a5,-180(s0)
    80004d80:	d7ad                	beqz	a5,80004cea <sys_open+0x62>
      iunlockput(ip);
    80004d82:	8526                	mv	a0,s1
    80004d84:	de0fe0ef          	jal	ra,80003364 <iunlockput>
      end_op();
    80004d88:	cd1fe0ef          	jal	ra,80003a58 <end_op>
      return -1;
    80004d8c:	557d                	li	a0,-1
    80004d8e:	bf7d                	j	80004d4c <sys_open+0xc4>
      end_op();
    80004d90:	cc9fe0ef          	jal	ra,80003a58 <end_op>
      return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	bf5d                	j	80004d4c <sys_open+0xc4>
    iunlockput(ip);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	dcafe0ef          	jal	ra,80003364 <iunlockput>
    end_op();
    80004d9e:	cbbfe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	b765                	j	80004d4c <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004da6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004daa:	04649783          	lh	a5,70(s1)
    80004dae:	02f99223          	sh	a5,36(s3)
    80004db2:	b785                	j	80004d12 <sys_open+0x8a>
    itrunc(ip);
    80004db4:	8526                	mv	a0,s1
    80004db6:	c92fe0ef          	jal	ra,80003248 <itrunc>
    80004dba:	b759                	j	80004d40 <sys_open+0xb8>
      fileclose(f);
    80004dbc:	854e                	mv	a0,s3
    80004dbe:	846ff0ef          	jal	ra,80003e04 <fileclose>
    iunlockput(ip);
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	da0fe0ef          	jal	ra,80003364 <iunlockput>
    end_op();
    80004dc8:	c91fe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004dcc:	557d                	li	a0,-1
    80004dce:	bfbd                	j	80004d4c <sys_open+0xc4>

0000000080004dd0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dd0:	7175                	addi	sp,sp,-144
    80004dd2:	e506                	sd	ra,136(sp)
    80004dd4:	e122                	sd	s0,128(sp)
    80004dd6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dd8:	c11fe0ef          	jal	ra,800039e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ddc:	08000613          	li	a2,128
    80004de0:	f7040593          	addi	a1,s0,-144
    80004de4:	4501                	li	a0,0
    80004de6:	8e5fd0ef          	jal	ra,800026ca <argstr>
    80004dea:	02054363          	bltz	a0,80004e10 <sys_mkdir+0x40>
    80004dee:	4681                	li	a3,0
    80004df0:	4601                	li	a2,0
    80004df2:	4585                	li	a1,1
    80004df4:	f7040513          	addi	a0,s0,-144
    80004df8:	999ff0ef          	jal	ra,80004790 <create>
    80004dfc:	c911                	beqz	a0,80004e10 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfe:	d66fe0ef          	jal	ra,80003364 <iunlockput>
  end_op();
    80004e02:	c57fe0ef          	jal	ra,80003a58 <end_op>
  return 0;
    80004e06:	4501                	li	a0,0
}
    80004e08:	60aa                	ld	ra,136(sp)
    80004e0a:	640a                	ld	s0,128(sp)
    80004e0c:	6149                	addi	sp,sp,144
    80004e0e:	8082                	ret
    end_op();
    80004e10:	c49fe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004e14:	557d                	li	a0,-1
    80004e16:	bfcd                	j	80004e08 <sys_mkdir+0x38>

0000000080004e18 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e18:	7135                	addi	sp,sp,-160
    80004e1a:	ed06                	sd	ra,152(sp)
    80004e1c:	e922                	sd	s0,144(sp)
    80004e1e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e20:	bc9fe0ef          	jal	ra,800039e8 <begin_op>
  argint(1, &major);
    80004e24:	f6c40593          	addi	a1,s0,-148
    80004e28:	4505                	li	a0,1
    80004e2a:	869fd0ef          	jal	ra,80002692 <argint>
  argint(2, &minor);
    80004e2e:	f6840593          	addi	a1,s0,-152
    80004e32:	4509                	li	a0,2
    80004e34:	85ffd0ef          	jal	ra,80002692 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e38:	08000613          	li	a2,128
    80004e3c:	f7040593          	addi	a1,s0,-144
    80004e40:	4501                	li	a0,0
    80004e42:	889fd0ef          	jal	ra,800026ca <argstr>
    80004e46:	02054563          	bltz	a0,80004e70 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e4a:	f6841683          	lh	a3,-152(s0)
    80004e4e:	f6c41603          	lh	a2,-148(s0)
    80004e52:	458d                	li	a1,3
    80004e54:	f7040513          	addi	a0,s0,-144
    80004e58:	939ff0ef          	jal	ra,80004790 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e5c:	c911                	beqz	a0,80004e70 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e5e:	d06fe0ef          	jal	ra,80003364 <iunlockput>
  end_op();
    80004e62:	bf7fe0ef          	jal	ra,80003a58 <end_op>
  return 0;
    80004e66:	4501                	li	a0,0
}
    80004e68:	60ea                	ld	ra,152(sp)
    80004e6a:	644a                	ld	s0,144(sp)
    80004e6c:	610d                	addi	sp,sp,160
    80004e6e:	8082                	ret
    end_op();
    80004e70:	be9fe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004e74:	557d                	li	a0,-1
    80004e76:	bfcd                	j	80004e68 <sys_mknod+0x50>

0000000080004e78 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e78:	7135                	addi	sp,sp,-160
    80004e7a:	ed06                	sd	ra,152(sp)
    80004e7c:	e922                	sd	s0,144(sp)
    80004e7e:	e526                	sd	s1,136(sp)
    80004e80:	e14a                	sd	s2,128(sp)
    80004e82:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e84:	963fc0ef          	jal	ra,800017e6 <myproc>
    80004e88:	892a                	mv	s2,a0
  
  begin_op();
    80004e8a:	b5ffe0ef          	jal	ra,800039e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e8e:	08000613          	li	a2,128
    80004e92:	f6040593          	addi	a1,s0,-160
    80004e96:	4501                	li	a0,0
    80004e98:	833fd0ef          	jal	ra,800026ca <argstr>
    80004e9c:	04054163          	bltz	a0,80004ede <sys_chdir+0x66>
    80004ea0:	f6040513          	addi	a0,s0,-160
    80004ea4:	96dfe0ef          	jal	ra,80003810 <namei>
    80004ea8:	84aa                	mv	s1,a0
    80004eaa:	c915                	beqz	a0,80004ede <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004eac:	ab2fe0ef          	jal	ra,8000315e <ilock>
  if(ip->type != T_DIR){
    80004eb0:	04449703          	lh	a4,68(s1)
    80004eb4:	4785                	li	a5,1
    80004eb6:	02f71863          	bne	a4,a5,80004ee6 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eba:	8526                	mv	a0,s1
    80004ebc:	b4cfe0ef          	jal	ra,80003208 <iunlock>
  iput(p->cwd);
    80004ec0:	15093503          	ld	a0,336(s2)
    80004ec4:	c18fe0ef          	jal	ra,800032dc <iput>
  end_op();
    80004ec8:	b91fe0ef          	jal	ra,80003a58 <end_op>
  p->cwd = ip;
    80004ecc:	14993823          	sd	s1,336(s2)
  return 0;
    80004ed0:	4501                	li	a0,0
}
    80004ed2:	60ea                	ld	ra,152(sp)
    80004ed4:	644a                	ld	s0,144(sp)
    80004ed6:	64aa                	ld	s1,136(sp)
    80004ed8:	690a                	ld	s2,128(sp)
    80004eda:	610d                	addi	sp,sp,160
    80004edc:	8082                	ret
    end_op();
    80004ede:	b7bfe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	b7fd                	j	80004ed2 <sys_chdir+0x5a>
    iunlockput(ip);
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	c7cfe0ef          	jal	ra,80003364 <iunlockput>
    end_op();
    80004eec:	b6dfe0ef          	jal	ra,80003a58 <end_op>
    return -1;
    80004ef0:	557d                	li	a0,-1
    80004ef2:	b7c5                	j	80004ed2 <sys_chdir+0x5a>

0000000080004ef4 <sys_exec>:

uint64
sys_exec(void)
{
    80004ef4:	7145                	addi	sp,sp,-464
    80004ef6:	e786                	sd	ra,456(sp)
    80004ef8:	e3a2                	sd	s0,448(sp)
    80004efa:	ff26                	sd	s1,440(sp)
    80004efc:	fb4a                	sd	s2,432(sp)
    80004efe:	f74e                	sd	s3,424(sp)
    80004f00:	f352                	sd	s4,416(sp)
    80004f02:	ef56                	sd	s5,408(sp)
    80004f04:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f06:	e3840593          	addi	a1,s0,-456
    80004f0a:	4505                	li	a0,1
    80004f0c:	fa2fd0ef          	jal	ra,800026ae <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f10:	08000613          	li	a2,128
    80004f14:	f4040593          	addi	a1,s0,-192
    80004f18:	4501                	li	a0,0
    80004f1a:	fb0fd0ef          	jal	ra,800026ca <argstr>
    80004f1e:	87aa                	mv	a5,a0
    return -1;
    80004f20:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f22:	0a07c463          	bltz	a5,80004fca <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80004f26:	10000613          	li	a2,256
    80004f2a:	4581                	li	a1,0
    80004f2c:	e4040513          	addi	a0,s0,-448
    80004f30:	d3ffb0ef          	jal	ra,80000c6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f34:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f38:	89a6                	mv	s3,s1
    80004f3a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f3c:	02000a13          	li	s4,32
    80004f40:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f44:	00391793          	slli	a5,s2,0x3
    80004f48:	e3040593          	addi	a1,s0,-464
    80004f4c:	e3843503          	ld	a0,-456(s0)
    80004f50:	953e                	add	a0,a0,a5
    80004f52:	eb6fd0ef          	jal	ra,80002608 <fetchaddr>
    80004f56:	02054663          	bltz	a0,80004f82 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80004f5a:	e3043783          	ld	a5,-464(s0)
    80004f5e:	cf8d                	beqz	a5,80004f98 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f60:	b6bfb0ef          	jal	ra,80000aca <kalloc>
    80004f64:	85aa                	mv	a1,a0
    80004f66:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f6a:	cd01                	beqz	a0,80004f82 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f6c:	6605                	lui	a2,0x1
    80004f6e:	e3043503          	ld	a0,-464(s0)
    80004f72:	ee0fd0ef          	jal	ra,80002652 <fetchstr>
    80004f76:	00054663          	bltz	a0,80004f82 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80004f7a:	0905                	addi	s2,s2,1
    80004f7c:	09a1                	addi	s3,s3,8
    80004f7e:	fd4911e3          	bne	s2,s4,80004f40 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f82:	10048913          	addi	s2,s1,256
    80004f86:	6088                	ld	a0,0(s1)
    80004f88:	c121                	beqz	a0,80004fc8 <sys_exec+0xd4>
    kfree(argv[i]);
    80004f8a:	a61fb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f8e:	04a1                	addi	s1,s1,8
    80004f90:	ff249be3          	bne	s1,s2,80004f86 <sys_exec+0x92>
  return -1;
    80004f94:	557d                	li	a0,-1
    80004f96:	a815                	j	80004fca <sys_exec+0xd6>
      argv[i] = 0;
    80004f98:	0a8e                	slli	s5,s5,0x3
    80004f9a:	fc040793          	addi	a5,s0,-64
    80004f9e:	9abe                	add	s5,s5,a5
    80004fa0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fa4:	e4040593          	addi	a1,s0,-448
    80004fa8:	f4040513          	addi	a0,s0,-192
    80004fac:	bfaff0ef          	jal	ra,800043a6 <exec>
    80004fb0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb2:	10048993          	addi	s3,s1,256
    80004fb6:	6088                	ld	a0,0(s1)
    80004fb8:	c511                	beqz	a0,80004fc4 <sys_exec+0xd0>
    kfree(argv[i]);
    80004fba:	a31fb0ef          	jal	ra,800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fbe:	04a1                	addi	s1,s1,8
    80004fc0:	ff349be3          	bne	s1,s3,80004fb6 <sys_exec+0xc2>
  return ret;
    80004fc4:	854a                	mv	a0,s2
    80004fc6:	a011                	j	80004fca <sys_exec+0xd6>
  return -1;
    80004fc8:	557d                	li	a0,-1
}
    80004fca:	60be                	ld	ra,456(sp)
    80004fcc:	641e                	ld	s0,448(sp)
    80004fce:	74fa                	ld	s1,440(sp)
    80004fd0:	795a                	ld	s2,432(sp)
    80004fd2:	79ba                	ld	s3,424(sp)
    80004fd4:	7a1a                	ld	s4,416(sp)
    80004fd6:	6afa                	ld	s5,408(sp)
    80004fd8:	6179                	addi	sp,sp,464
    80004fda:	8082                	ret

0000000080004fdc <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fdc:	7139                	addi	sp,sp,-64
    80004fde:	fc06                	sd	ra,56(sp)
    80004fe0:	f822                	sd	s0,48(sp)
    80004fe2:	f426                	sd	s1,40(sp)
    80004fe4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fe6:	801fc0ef          	jal	ra,800017e6 <myproc>
    80004fea:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fec:	fd840593          	addi	a1,s0,-40
    80004ff0:	4501                	li	a0,0
    80004ff2:	ebcfd0ef          	jal	ra,800026ae <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ff6:	fc840593          	addi	a1,s0,-56
    80004ffa:	fd040513          	addi	a0,s0,-48
    80004ffe:	8d2ff0ef          	jal	ra,800040d0 <pipealloc>
    return -1;
    80005002:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005004:	0a054463          	bltz	a0,800050ac <sys_pipe+0xd0>
  fd0 = -1;
    80005008:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000500c:	fd043503          	ld	a0,-48(s0)
    80005010:	f42ff0ef          	jal	ra,80004752 <fdalloc>
    80005014:	fca42223          	sw	a0,-60(s0)
    80005018:	08054163          	bltz	a0,8000509a <sys_pipe+0xbe>
    8000501c:	fc843503          	ld	a0,-56(s0)
    80005020:	f32ff0ef          	jal	ra,80004752 <fdalloc>
    80005024:	fca42023          	sw	a0,-64(s0)
    80005028:	06054063          	bltz	a0,80005088 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000502c:	4691                	li	a3,4
    8000502e:	fc440613          	addi	a2,s0,-60
    80005032:	fd843583          	ld	a1,-40(s0)
    80005036:	68a8                	ld	a0,80(s1)
    80005038:	c62fc0ef          	jal	ra,8000149a <copyout>
    8000503c:	00054e63          	bltz	a0,80005058 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005040:	4691                	li	a3,4
    80005042:	fc040613          	addi	a2,s0,-64
    80005046:	fd843583          	ld	a1,-40(s0)
    8000504a:	0591                	addi	a1,a1,4
    8000504c:	68a8                	ld	a0,80(s1)
    8000504e:	c4cfc0ef          	jal	ra,8000149a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005052:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005054:	04055c63          	bgez	a0,800050ac <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005058:	fc442783          	lw	a5,-60(s0)
    8000505c:	07e9                	addi	a5,a5,26
    8000505e:	078e                	slli	a5,a5,0x3
    80005060:	97a6                	add	a5,a5,s1
    80005062:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005066:	fc042503          	lw	a0,-64(s0)
    8000506a:	0569                	addi	a0,a0,26
    8000506c:	050e                	slli	a0,a0,0x3
    8000506e:	94aa                	add	s1,s1,a0
    80005070:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005074:	fd043503          	ld	a0,-48(s0)
    80005078:	d8dfe0ef          	jal	ra,80003e04 <fileclose>
    fileclose(wf);
    8000507c:	fc843503          	ld	a0,-56(s0)
    80005080:	d85fe0ef          	jal	ra,80003e04 <fileclose>
    return -1;
    80005084:	57fd                	li	a5,-1
    80005086:	a01d                	j	800050ac <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005088:	fc442783          	lw	a5,-60(s0)
    8000508c:	0007c763          	bltz	a5,8000509a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005090:	07e9                	addi	a5,a5,26
    80005092:	078e                	slli	a5,a5,0x3
    80005094:	94be                	add	s1,s1,a5
    80005096:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000509a:	fd043503          	ld	a0,-48(s0)
    8000509e:	d67fe0ef          	jal	ra,80003e04 <fileclose>
    fileclose(wf);
    800050a2:	fc843503          	ld	a0,-56(s0)
    800050a6:	d5ffe0ef          	jal	ra,80003e04 <fileclose>
    return -1;
    800050aa:	57fd                	li	a5,-1
}
    800050ac:	853e                	mv	a0,a5
    800050ae:	70e2                	ld	ra,56(sp)
    800050b0:	7442                	ld	s0,48(sp)
    800050b2:	74a2                	ld	s1,40(sp)
    800050b4:	6121                	addi	sp,sp,64
    800050b6:	8082                	ret
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	e4aa                	sd	a0,72(sp)
    800050d2:	e8ae                	sd	a1,80(sp)
    800050d4:	ecb2                	sd	a2,88(sp)
    800050d6:	f0b6                	sd	a3,96(sp)
    800050d8:	f4ba                	sd	a4,104(sp)
    800050da:	f8be                	sd	a5,112(sp)
    800050dc:	fcc2                	sd	a6,120(sp)
    800050de:	e146                	sd	a7,128(sp)
    800050e0:	edf2                	sd	t3,216(sp)
    800050e2:	f1f6                	sd	t4,224(sp)
    800050e4:	f5fa                	sd	t5,232(sp)
    800050e6:	f9fe                	sd	t6,240(sp)
    800050e8:	c30fd0ef          	jal	ra,80002518 <kerneltrap>
    800050ec:	6082                	ld	ra,0(sp)
    800050ee:	6122                	ld	sp,8(sp)
    800050f0:	61c2                	ld	gp,16(sp)
    800050f2:	7282                	ld	t0,32(sp)
    800050f4:	7322                	ld	t1,40(sp)
    800050f6:	73c2                	ld	t2,48(sp)
    800050f8:	6526                	ld	a0,72(sp)
    800050fa:	65c6                	ld	a1,80(sp)
    800050fc:	6666                	ld	a2,88(sp)
    800050fe:	7686                	ld	a3,96(sp)
    80005100:	7726                	ld	a4,104(sp)
    80005102:	77c6                	ld	a5,112(sp)
    80005104:	7866                	ld	a6,120(sp)
    80005106:	688a                	ld	a7,128(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
	...

000000008000511e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511e:	1141                	addi	sp,sp,-16
    80005120:	e422                	sd	s0,8(sp)
    80005122:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005124:	0c0007b7          	lui	a5,0xc000
    80005128:	4705                	li	a4,1
    8000512a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000512c:	c3d8                	sw	a4,4(a5)
}
    8000512e:	6422                	ld	s0,8(sp)
    80005130:	0141                	addi	sp,sp,16
    80005132:	8082                	ret

0000000080005134 <plicinithart>:

void
plicinithart(void)
{
    80005134:	1141                	addi	sp,sp,-16
    80005136:	e406                	sd	ra,8(sp)
    80005138:	e022                	sd	s0,0(sp)
    8000513a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000513c:	e7efc0ef          	jal	ra,800017ba <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	953e                	add	a0,a0,a5
    8000515c:	00052023          	sw	zero,0(a0)
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	e4afc0ef          	jal	ra,800017ba <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005174:	00d5179b          	slliw	a5,a0,0xd
    80005178:	0c201537          	lui	a0,0xc201
    8000517c:	953e                	add	a0,a0,a5
  return irq;
}
    8000517e:	4148                	lw	a0,4(a0)
    80005180:	60a2                	ld	ra,8(sp)
    80005182:	6402                	ld	s0,0(sp)
    80005184:	0141                	addi	sp,sp,16
    80005186:	8082                	ret

0000000080005188 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005188:	1101                	addi	sp,sp,-32
    8000518a:	ec06                	sd	ra,24(sp)
    8000518c:	e822                	sd	s0,16(sp)
    8000518e:	e426                	sd	s1,8(sp)
    80005190:	1000                	addi	s0,sp,32
    80005192:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005194:	e26fc0ef          	jal	ra,800017ba <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005198:	00d5151b          	slliw	a0,a0,0xd
    8000519c:	0c2017b7          	lui	a5,0xc201
    800051a0:	97aa                	add	a5,a5,a0
    800051a2:	c3c4                	sw	s1,4(a5)
}
    800051a4:	60e2                	ld	ra,24(sp)
    800051a6:	6442                	ld	s0,16(sp)
    800051a8:	64a2                	ld	s1,8(sp)
    800051aa:	6105                	addi	sp,sp,32
    800051ac:	8082                	ret

00000000800051ae <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051ae:	1141                	addi	sp,sp,-16
    800051b0:	e406                	sd	ra,8(sp)
    800051b2:	e022                	sd	s0,0(sp)
    800051b4:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051b6:	479d                	li	a5,7
    800051b8:	04a7ca63          	blt	a5,a0,8000520c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800051bc:	0001c797          	auipc	a5,0x1c
    800051c0:	98478793          	addi	a5,a5,-1660 # 80020b40 <disk>
    800051c4:	97aa                	add	a5,a5,a0
    800051c6:	0187c783          	lbu	a5,24(a5)
    800051ca:	e7b9                	bnez	a5,80005218 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051cc:	00451613          	slli	a2,a0,0x4
    800051d0:	0001c797          	auipc	a5,0x1c
    800051d4:	97078793          	addi	a5,a5,-1680 # 80020b40 <disk>
    800051d8:	6394                	ld	a3,0(a5)
    800051da:	96b2                	add	a3,a3,a2
    800051dc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051e0:	6398                	ld	a4,0(a5)
    800051e2:	9732                	add	a4,a4,a2
    800051e4:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051e8:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051ec:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051f0:	953e                	add	a0,a0,a5
    800051f2:	4785                	li	a5,1
    800051f4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800051f8:	0001c517          	auipc	a0,0x1c
    800051fc:	96050513          	addi	a0,a0,-1696 # 80020b58 <disk+0x18>
    80005200:	bfffc0ef          	jal	ra,80001dfe <wakeup>
}
    80005204:	60a2                	ld	ra,8(sp)
    80005206:	6402                	ld	s0,0(sp)
    80005208:	0141                	addi	sp,sp,16
    8000520a:	8082                	ret
    panic("free_desc 1");
    8000520c:	00002517          	auipc	a0,0x2
    80005210:	5ac50513          	addi	a0,a0,1452 # 800077b8 <syscalls+0x2f8>
    80005214:	d42fb0ef          	jal	ra,80000756 <panic>
    panic("free_desc 2");
    80005218:	00002517          	auipc	a0,0x2
    8000521c:	5b050513          	addi	a0,a0,1456 # 800077c8 <syscalls+0x308>
    80005220:	d36fb0ef          	jal	ra,80000756 <panic>

0000000080005224 <virtio_disk_init>:
{
    80005224:	1101                	addi	sp,sp,-32
    80005226:	ec06                	sd	ra,24(sp)
    80005228:	e822                	sd	s0,16(sp)
    8000522a:	e426                	sd	s1,8(sp)
    8000522c:	e04a                	sd	s2,0(sp)
    8000522e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005230:	00002597          	auipc	a1,0x2
    80005234:	5a858593          	addi	a1,a1,1448 # 800077d8 <syscalls+0x318>
    80005238:	0001c517          	auipc	a0,0x1c
    8000523c:	a3050513          	addi	a0,a0,-1488 # 80020c68 <disk+0x128>
    80005240:	8dbfb0ef          	jal	ra,80000b1a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005244:	100017b7          	lui	a5,0x10001
    80005248:	4398                	lw	a4,0(a5)
    8000524a:	2701                	sext.w	a4,a4
    8000524c:	747277b7          	lui	a5,0x74727
    80005250:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005254:	14f71063          	bne	a4,a5,80005394 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005258:	100017b7          	lui	a5,0x10001
    8000525c:	43dc                	lw	a5,4(a5)
    8000525e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005260:	4709                	li	a4,2
    80005262:	12e79963          	bne	a5,a4,80005394 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005266:	100017b7          	lui	a5,0x10001
    8000526a:	479c                	lw	a5,8(a5)
    8000526c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000526e:	12e79363          	bne	a5,a4,80005394 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005272:	100017b7          	lui	a5,0x10001
    80005276:	47d8                	lw	a4,12(a5)
    80005278:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000527a:	554d47b7          	lui	a5,0x554d4
    8000527e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005282:	10f71963          	bne	a4,a5,80005394 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005286:	100017b7          	lui	a5,0x10001
    8000528a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528e:	4705                	li	a4,1
    80005290:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005292:	470d                	li	a4,3
    80005294:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005296:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005298:	c7ffe737          	lui	a4,0xc7ffe
    8000529c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddadf>
    800052a0:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052a2:	2701                	sext.w	a4,a4
    800052a4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052a6:	472d                	li	a4,11
    800052a8:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052aa:	5bbc                	lw	a5,112(a5)
    800052ac:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052b0:	8ba1                	andi	a5,a5,8
    800052b2:	0e078763          	beqz	a5,800053a0 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052be:	43fc                	lw	a5,68(a5)
    800052c0:	2781                	sext.w	a5,a5
    800052c2:	0e079563          	bnez	a5,800053ac <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	5bdc                	lw	a5,52(a5)
    800052cc:	2781                	sext.w	a5,a5
  if(max == 0)
    800052ce:	0e078563          	beqz	a5,800053b8 <virtio_disk_init+0x194>
  if(max < NUM)
    800052d2:	471d                	li	a4,7
    800052d4:	0ef77863          	bgeu	a4,a5,800053c4 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    800052d8:	ff2fb0ef          	jal	ra,80000aca <kalloc>
    800052dc:	0001c497          	auipc	s1,0x1c
    800052e0:	86448493          	addi	s1,s1,-1948 # 80020b40 <disk>
    800052e4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052e6:	fe4fb0ef          	jal	ra,80000aca <kalloc>
    800052ea:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052ec:	fdefb0ef          	jal	ra,80000aca <kalloc>
    800052f0:	87aa                	mv	a5,a0
    800052f2:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052f4:	6088                	ld	a0,0(s1)
    800052f6:	cd69                	beqz	a0,800053d0 <virtio_disk_init+0x1ac>
    800052f8:	0001c717          	auipc	a4,0x1c
    800052fc:	85073703          	ld	a4,-1968(a4) # 80020b48 <disk+0x8>
    80005300:	cb61                	beqz	a4,800053d0 <virtio_disk_init+0x1ac>
    80005302:	c7f9                	beqz	a5,800053d0 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    80005304:	6605                	lui	a2,0x1
    80005306:	4581                	li	a1,0
    80005308:	967fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.avail, 0, PGSIZE);
    8000530c:	0001c497          	auipc	s1,0x1c
    80005310:	83448493          	addi	s1,s1,-1996 # 80020b40 <disk>
    80005314:	6605                	lui	a2,0x1
    80005316:	4581                	li	a1,0
    80005318:	6488                	ld	a0,8(s1)
    8000531a:	955fb0ef          	jal	ra,80000c6e <memset>
  memset(disk.used, 0, PGSIZE);
    8000531e:	6605                	lui	a2,0x1
    80005320:	4581                	li	a1,0
    80005322:	6888                	ld	a0,16(s1)
    80005324:	94bfb0ef          	jal	ra,80000c6e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005328:	100017b7          	lui	a5,0x10001
    8000532c:	4721                	li	a4,8
    8000532e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005330:	4098                	lw	a4,0(s1)
    80005332:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005336:	40d8                	lw	a4,4(s1)
    80005338:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000533c:	6498                	ld	a4,8(s1)
    8000533e:	0007069b          	sext.w	a3,a4
    80005342:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005346:	9701                	srai	a4,a4,0x20
    80005348:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000534c:	6898                	ld	a4,16(s1)
    8000534e:	0007069b          	sext.w	a3,a4
    80005352:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005356:	9701                	srai	a4,a4,0x20
    80005358:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000535c:	4705                	li	a4,1
    8000535e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005360:	00e48c23          	sb	a4,24(s1)
    80005364:	00e48ca3          	sb	a4,25(s1)
    80005368:	00e48d23          	sb	a4,26(s1)
    8000536c:	00e48da3          	sb	a4,27(s1)
    80005370:	00e48e23          	sb	a4,28(s1)
    80005374:	00e48ea3          	sb	a4,29(s1)
    80005378:	00e48f23          	sb	a4,30(s1)
    8000537c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005380:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005384:	0727a823          	sw	s2,112(a5)
}
    80005388:	60e2                	ld	ra,24(sp)
    8000538a:	6442                	ld	s0,16(sp)
    8000538c:	64a2                	ld	s1,8(sp)
    8000538e:	6902                	ld	s2,0(sp)
    80005390:	6105                	addi	sp,sp,32
    80005392:	8082                	ret
    panic("could not find virtio disk");
    80005394:	00002517          	auipc	a0,0x2
    80005398:	45450513          	addi	a0,a0,1108 # 800077e8 <syscalls+0x328>
    8000539c:	bbafb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053a0:	00002517          	auipc	a0,0x2
    800053a4:	46850513          	addi	a0,a0,1128 # 80007808 <syscalls+0x348>
    800053a8:	baefb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk should not be ready");
    800053ac:	00002517          	auipc	a0,0x2
    800053b0:	47c50513          	addi	a0,a0,1148 # 80007828 <syscalls+0x368>
    800053b4:	ba2fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk has no queue 0");
    800053b8:	00002517          	auipc	a0,0x2
    800053bc:	49050513          	addi	a0,a0,1168 # 80007848 <syscalls+0x388>
    800053c0:	b96fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk max queue too short");
    800053c4:	00002517          	auipc	a0,0x2
    800053c8:	4a450513          	addi	a0,a0,1188 # 80007868 <syscalls+0x3a8>
    800053cc:	b8afb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk kalloc");
    800053d0:	00002517          	auipc	a0,0x2
    800053d4:	4b850513          	addi	a0,a0,1208 # 80007888 <syscalls+0x3c8>
    800053d8:	b7efb0ef          	jal	ra,80000756 <panic>

00000000800053dc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053dc:	7119                	addi	sp,sp,-128
    800053de:	fc86                	sd	ra,120(sp)
    800053e0:	f8a2                	sd	s0,112(sp)
    800053e2:	f4a6                	sd	s1,104(sp)
    800053e4:	f0ca                	sd	s2,96(sp)
    800053e6:	ecce                	sd	s3,88(sp)
    800053e8:	e8d2                	sd	s4,80(sp)
    800053ea:	e4d6                	sd	s5,72(sp)
    800053ec:	e0da                	sd	s6,64(sp)
    800053ee:	fc5e                	sd	s7,56(sp)
    800053f0:	f862                	sd	s8,48(sp)
    800053f2:	f466                	sd	s9,40(sp)
    800053f4:	f06a                	sd	s10,32(sp)
    800053f6:	ec6e                	sd	s11,24(sp)
    800053f8:	0100                	addi	s0,sp,128
    800053fa:	8aaa                	mv	s5,a0
    800053fc:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053fe:	00c52d03          	lw	s10,12(a0)
    80005402:	001d1d1b          	slliw	s10,s10,0x1
    80005406:	1d02                	slli	s10,s10,0x20
    80005408:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    8000540c:	0001c517          	auipc	a0,0x1c
    80005410:	85c50513          	addi	a0,a0,-1956 # 80020c68 <disk+0x128>
    80005414:	f86fb0ef          	jal	ra,80000b9a <acquire>
  for(int i = 0; i < 3; i++){
    80005418:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000541a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000541c:	0001bb97          	auipc	s7,0x1b
    80005420:	724b8b93          	addi	s7,s7,1828 # 80020b40 <disk>
  for(int i = 0; i < 3; i++){
    80005424:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005426:	0001cc97          	auipc	s9,0x1c
    8000542a:	842c8c93          	addi	s9,s9,-1982 # 80020c68 <disk+0x128>
    8000542e:	a8a9                	j	80005488 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005430:	00fb8733          	add	a4,s7,a5
    80005434:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005438:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000543a:	0207c563          	bltz	a5,80005464 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000543e:	2905                	addiw	s2,s2,1
    80005440:	0611                	addi	a2,a2,4
    80005442:	05690863          	beq	s2,s6,80005492 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80005446:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005448:	0001b717          	auipc	a4,0x1b
    8000544c:	6f870713          	addi	a4,a4,1784 # 80020b40 <disk>
    80005450:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005452:	01874683          	lbu	a3,24(a4)
    80005456:	fee9                	bnez	a3,80005430 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005458:	2785                	addiw	a5,a5,1
    8000545a:	0705                	addi	a4,a4,1
    8000545c:	fe979be3          	bne	a5,s1,80005452 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005460:	57fd                	li	a5,-1
    80005462:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005464:	01205b63          	blez	s2,8000547a <virtio_disk_rw+0x9e>
    80005468:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000546a:	000a2503          	lw	a0,0(s4)
    8000546e:	d41ff0ef          	jal	ra,800051ae <free_desc>
      for(int j = 0; j < i; j++)
    80005472:	2d85                	addiw	s11,s11,1
    80005474:	0a11                	addi	s4,s4,4
    80005476:	ffb91ae3          	bne	s2,s11,8000546a <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000547a:	85e6                	mv	a1,s9
    8000547c:	0001b517          	auipc	a0,0x1b
    80005480:	6dc50513          	addi	a0,a0,1756 # 80020b58 <disk+0x18>
    80005484:	92ffc0ef          	jal	ra,80001db2 <sleep>
  for(int i = 0; i < 3; i++){
    80005488:	f8040a13          	addi	s4,s0,-128
{
    8000548c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000548e:	894e                	mv	s2,s3
    80005490:	bf5d                	j	80005446 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005492:	f8042583          	lw	a1,-128(s0)
    80005496:	00a58793          	addi	a5,a1,10
    8000549a:	0792                	slli	a5,a5,0x4

  if(write)
    8000549c:	0001b617          	auipc	a2,0x1b
    800054a0:	6a460613          	addi	a2,a2,1700 # 80020b40 <disk>
    800054a4:	00f60733          	add	a4,a2,a5
    800054a8:	018036b3          	snez	a3,s8
    800054ac:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054ae:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800054b2:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054b6:	f6078693          	addi	a3,a5,-160
    800054ba:	6218                	ld	a4,0(a2)
    800054bc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054be:	00878513          	addi	a0,a5,8
    800054c2:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054c4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054c6:	6208                	ld	a0,0(a2)
    800054c8:	96aa                	add	a3,a3,a0
    800054ca:	4741                	li	a4,16
    800054cc:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ce:	4705                	li	a4,1
    800054d0:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800054d4:	f8442703          	lw	a4,-124(s0)
    800054d8:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054dc:	0712                	slli	a4,a4,0x4
    800054de:	953a                	add	a0,a0,a4
    800054e0:	058a8693          	addi	a3,s5,88
    800054e4:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800054e6:	6208                	ld	a0,0(a2)
    800054e8:	972a                	add	a4,a4,a0
    800054ea:	40000693          	li	a3,1024
    800054ee:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054f0:	001c3c13          	seqz	s8,s8
    800054f4:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054f6:	001c6c13          	ori	s8,s8,1
    800054fa:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800054fe:	f8842603          	lw	a2,-120(s0)
    80005502:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005506:	0001b697          	auipc	a3,0x1b
    8000550a:	63a68693          	addi	a3,a3,1594 # 80020b40 <disk>
    8000550e:	00258713          	addi	a4,a1,2
    80005512:	0712                	slli	a4,a4,0x4
    80005514:	9736                	add	a4,a4,a3
    80005516:	587d                	li	a6,-1
    80005518:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000551c:	0612                	slli	a2,a2,0x4
    8000551e:	9532                	add	a0,a0,a2
    80005520:	f9078793          	addi	a5,a5,-112
    80005524:	97b6                	add	a5,a5,a3
    80005526:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80005528:	629c                	ld	a5,0(a3)
    8000552a:	97b2                	add	a5,a5,a2
    8000552c:	4605                	li	a2,1
    8000552e:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005530:	4509                	li	a0,2
    80005532:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80005536:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000553a:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000553e:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005542:	6698                	ld	a4,8(a3)
    80005544:	00275783          	lhu	a5,2(a4)
    80005548:	8b9d                	andi	a5,a5,7
    8000554a:	0786                	slli	a5,a5,0x1
    8000554c:	97ba                	add	a5,a5,a4
    8000554e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005552:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005556:	6698                	ld	a4,8(a3)
    80005558:	00275783          	lhu	a5,2(a4)
    8000555c:	2785                	addiw	a5,a5,1
    8000555e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005562:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005566:	100017b7          	lui	a5,0x10001
    8000556a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000556e:	004aa783          	lw	a5,4(s5)
    80005572:	00c79f63          	bne	a5,a2,80005590 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80005576:	0001b917          	auipc	s2,0x1b
    8000557a:	6f290913          	addi	s2,s2,1778 # 80020c68 <disk+0x128>
  while(b->disk == 1) {
    8000557e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005580:	85ca                	mv	a1,s2
    80005582:	8556                	mv	a0,s5
    80005584:	82ffc0ef          	jal	ra,80001db2 <sleep>
  while(b->disk == 1) {
    80005588:	004aa783          	lw	a5,4(s5)
    8000558c:	fe978ae3          	beq	a5,s1,80005580 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80005590:	f8042903          	lw	s2,-128(s0)
    80005594:	00290793          	addi	a5,s2,2
    80005598:	00479713          	slli	a4,a5,0x4
    8000559c:	0001b797          	auipc	a5,0x1b
    800055a0:	5a478793          	addi	a5,a5,1444 # 80020b40 <disk>
    800055a4:	97ba                	add	a5,a5,a4
    800055a6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055aa:	0001b997          	auipc	s3,0x1b
    800055ae:	59698993          	addi	s3,s3,1430 # 80020b40 <disk>
    800055b2:	00491713          	slli	a4,s2,0x4
    800055b6:	0009b783          	ld	a5,0(s3)
    800055ba:	97ba                	add	a5,a5,a4
    800055bc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055c0:	854a                	mv	a0,s2
    800055c2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055c6:	be9ff0ef          	jal	ra,800051ae <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055ca:	8885                	andi	s1,s1,1
    800055cc:	f0fd                	bnez	s1,800055b2 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ce:	0001b517          	auipc	a0,0x1b
    800055d2:	69a50513          	addi	a0,a0,1690 # 80020c68 <disk+0x128>
    800055d6:	e5cfb0ef          	jal	ra,80000c32 <release>
}
    800055da:	70e6                	ld	ra,120(sp)
    800055dc:	7446                	ld	s0,112(sp)
    800055de:	74a6                	ld	s1,104(sp)
    800055e0:	7906                	ld	s2,96(sp)
    800055e2:	69e6                	ld	s3,88(sp)
    800055e4:	6a46                	ld	s4,80(sp)
    800055e6:	6aa6                	ld	s5,72(sp)
    800055e8:	6b06                	ld	s6,64(sp)
    800055ea:	7be2                	ld	s7,56(sp)
    800055ec:	7c42                	ld	s8,48(sp)
    800055ee:	7ca2                	ld	s9,40(sp)
    800055f0:	7d02                	ld	s10,32(sp)
    800055f2:	6de2                	ld	s11,24(sp)
    800055f4:	6109                	addi	sp,sp,128
    800055f6:	8082                	ret

00000000800055f8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055f8:	1101                	addi	sp,sp,-32
    800055fa:	ec06                	sd	ra,24(sp)
    800055fc:	e822                	sd	s0,16(sp)
    800055fe:	e426                	sd	s1,8(sp)
    80005600:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005602:	0001b497          	auipc	s1,0x1b
    80005606:	53e48493          	addi	s1,s1,1342 # 80020b40 <disk>
    8000560a:	0001b517          	auipc	a0,0x1b
    8000560e:	65e50513          	addi	a0,a0,1630 # 80020c68 <disk+0x128>
    80005612:	d88fb0ef          	jal	ra,80000b9a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005616:	10001737          	lui	a4,0x10001
    8000561a:	533c                	lw	a5,96(a4)
    8000561c:	8b8d                	andi	a5,a5,3
    8000561e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005620:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005624:	689c                	ld	a5,16(s1)
    80005626:	0204d703          	lhu	a4,32(s1)
    8000562a:	0027d783          	lhu	a5,2(a5)
    8000562e:	04f70663          	beq	a4,a5,8000567a <virtio_disk_intr+0x82>
    __sync_synchronize();
    80005632:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005636:	6898                	ld	a4,16(s1)
    80005638:	0204d783          	lhu	a5,32(s1)
    8000563c:	8b9d                	andi	a5,a5,7
    8000563e:	078e                	slli	a5,a5,0x3
    80005640:	97ba                	add	a5,a5,a4
    80005642:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005644:	00278713          	addi	a4,a5,2
    80005648:	0712                	slli	a4,a4,0x4
    8000564a:	9726                	add	a4,a4,s1
    8000564c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005650:	e321                	bnez	a4,80005690 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005652:	0789                	addi	a5,a5,2
    80005654:	0792                	slli	a5,a5,0x4
    80005656:	97a6                	add	a5,a5,s1
    80005658:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000565a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000565e:	fa0fc0ef          	jal	ra,80001dfe <wakeup>

    disk.used_idx += 1;
    80005662:	0204d783          	lhu	a5,32(s1)
    80005666:	2785                	addiw	a5,a5,1
    80005668:	17c2                	slli	a5,a5,0x30
    8000566a:	93c1                	srli	a5,a5,0x30
    8000566c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005670:	6898                	ld	a4,16(s1)
    80005672:	00275703          	lhu	a4,2(a4)
    80005676:	faf71ee3          	bne	a4,a5,80005632 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    8000567a:	0001b517          	auipc	a0,0x1b
    8000567e:	5ee50513          	addi	a0,a0,1518 # 80020c68 <disk+0x128>
    80005682:	db0fb0ef          	jal	ra,80000c32 <release>
}
    80005686:	60e2                	ld	ra,24(sp)
    80005688:	6442                	ld	s0,16(sp)
    8000568a:	64a2                	ld	s1,8(sp)
    8000568c:	6105                	addi	sp,sp,32
    8000568e:	8082                	ret
      panic("virtio_disk_intr status");
    80005690:	00002517          	auipc	a0,0x2
    80005694:	21050513          	addi	a0,a0,528 # 800078a0 <syscalls+0x3e0>
    80005698:	8befb0ef          	jal	ra,80000756 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
