
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	27a000ef          	jal	ra,282 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	278000ef          	jal	ra,28a <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	302000ef          	jal	ra,31a <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	ra,0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	25e000ef          	jal	ra,28a <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	4685                	li	a3,1
  8a:	9e89                	subw	a3,a3,a0
  8c:	00f6853b          	addw	a0,a3,a5
  90:	0785                	addi	a5,a5,1
  92:	fff7c703          	lbu	a4,-1(a5)
  96:	fb7d                	bnez	a4,8c <strlen+0x14>
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	188000ef          	jal	ra,2a2 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e426                	sd	s1,8(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	addi	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	162000ef          	jal	ra,2ca <open>
  if(fd < 0)
 16c:	02054163          	bltz	a0,18e <stat+0x36>
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	16e000ef          	jal	ra,2e2 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	136000ef          	jal	ra,2b2 <close>
  return r;
}
 180:	854a                	mv	a0,s2
 182:	60e2                	ld	ra,24(sp)
 184:	6442                	ld	s0,16(sp)
 186:	64a2                	ld	s1,8(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfc5                	j	180 <stat+0x28>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054603          	lbu	a2,0(a0)
 19c:	fd06079b          	addiw	a5,a2,-48
 1a0:	0ff7f793          	andi	a5,a5,255
 1a4:	4725                	li	a4,9
 1a6:	02f76963          	bltu	a4,a5,1d8 <atoi+0x46>
 1aa:	86aa                	mv	a3,a0
  n = 0;
 1ac:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ae:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1b0:	0685                	addi	a3,a3,1
 1b2:	0025179b          	slliw	a5,a0,0x2
 1b6:	9fa9                	addw	a5,a5,a0
 1b8:	0017979b          	slliw	a5,a5,0x1
 1bc:	9fb1                	addw	a5,a5,a2
 1be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c2:	0006c603          	lbu	a2,0(a3)
 1c6:	fd06071b          	addiw	a4,a2,-48
 1ca:	0ff77713          	andi	a4,a4,255
 1ce:	fee5f1e3          	bgeu	a1,a4,1b0 <atoi+0x1e>
  return n;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  n = 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <atoi+0x40>

00000000000001dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e2:	02b57463          	bgeu	a0,a1,20a <memmove+0x2e>
    while(n-- > 0)
 1e6:	00c05f63          	blez	a2,204 <memmove+0x28>
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f4:	0585                	addi	a1,a1,1
 1f6:	0705                	addi	a4,a4,1
 1f8:	fff5c683          	lbu	a3,-1(a1)
 1fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 200:	fee79ae3          	bne	a5,a4,1f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
    dst += n;
 20a:	00c50733          	add	a4,a0,a2
    src += n;
 20e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 210:	fec05ae3          	blez	a2,204 <memmove+0x28>
 214:	fff6079b          	addiw	a5,a2,-1
 218:	1782                	slli	a5,a5,0x20
 21a:	9381                	srli	a5,a5,0x20
 21c:	fff7c793          	not	a5,a5
 220:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 222:	15fd                	addi	a1,a1,-1
 224:	177d                	addi	a4,a4,-1
 226:	0005c683          	lbu	a3,0(a1)
 22a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x46>
 232:	bfc9                	j	204 <memmove+0x28>

0000000000000234 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 23a:	ca05                	beqz	a2,26a <memcmp+0x36>
 23c:	fff6069b          	addiw	a3,a2,-1
 240:	1682                	slli	a3,a3,0x20
 242:	9281                	srli	a3,a3,0x20
 244:	0685                	addi	a3,a3,1
 246:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 248:	00054783          	lbu	a5,0(a0)
 24c:	0005c703          	lbu	a4,0(a1)
 250:	00e79863          	bne	a5,a4,260 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 254:	0505                	addi	a0,a0,1
    p2++;
 256:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 258:	fed518e3          	bne	a0,a3,248 <memcmp+0x14>
  }
  return 0;
 25c:	4501                	li	a0,0
 25e:	a019                	j	264 <memcmp+0x30>
      return *p1 - *p2;
 260:	40e7853b          	subw	a0,a5,a4
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  return 0;
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <memcmp+0x30>

000000000000026e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 276:	f67ff0ef          	jal	ra,1dc <memmove>
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret

0000000000000282 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 282:	4885                	li	a7,1
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <exit>:
.global exit
exit:
 li a7, SYS_exit
 28a:	4889                	li	a7,2
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <wait>:
.global wait
wait:
 li a7, SYS_wait
 292:	488d                	li	a7,3
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 29a:	4891                	li	a7,4
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <read>:
.global read
read:
 li a7, SYS_read
 2a2:	4895                	li	a7,5
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <write>:
.global write
write:
 li a7, SYS_write
 2aa:	48c1                	li	a7,16
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <close>:
.global close
close:
 li a7, SYS_close
 2b2:	48d5                	li	a7,21
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ba:	4899                	li	a7,6
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c2:	489d                	li	a7,7
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <open>:
.global open
open:
 li a7, SYS_open
 2ca:	48bd                	li	a7,15
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d2:	48c5                	li	a7,17
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2da:	48c9                	li	a7,18
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e2:	48a1                	li	a7,8
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <link>:
.global link
link:
 li a7, SYS_link
 2ea:	48cd                	li	a7,19
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f2:	48d1                	li	a7,20
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2fa:	48a5                	li	a7,9
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <dup>:
.global dup
dup:
 li a7, SYS_dup
 302:	48a9                	li	a7,10
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 30a:	48ad                	li	a7,11
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 312:	48b1                	li	a7,12
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31a:	48b5                	li	a7,13
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 322:	48b9                	li	a7,14
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 32a:	1101                	addi	sp,sp,-32
 32c:	ec06                	sd	ra,24(sp)
 32e:	e822                	sd	s0,16(sp)
 330:	1000                	addi	s0,sp,32
 332:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 336:	4605                	li	a2,1
 338:	fef40593          	addi	a1,s0,-17
 33c:	f6fff0ef          	jal	ra,2aa <write>
}
 340:	60e2                	ld	ra,24(sp)
 342:	6442                	ld	s0,16(sp)
 344:	6105                	addi	sp,sp,32
 346:	8082                	ret

0000000000000348 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 348:	7139                	addi	sp,sp,-64
 34a:	fc06                	sd	ra,56(sp)
 34c:	f822                	sd	s0,48(sp)
 34e:	f426                	sd	s1,40(sp)
 350:	f04a                	sd	s2,32(sp)
 352:	ec4e                	sd	s3,24(sp)
 354:	0080                	addi	s0,sp,64
 356:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 358:	c299                	beqz	a3,35e <printint+0x16>
 35a:	0805c663          	bltz	a1,3e6 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 35e:	2581                	sext.w	a1,a1
  neg = 0;
 360:	4881                	li	a7,0
 362:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 366:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 368:	2601                	sext.w	a2,a2
 36a:	00000517          	auipc	a0,0x0
 36e:	4ce50513          	addi	a0,a0,1230 # 838 <digits>
 372:	883a                	mv	a6,a4
 374:	2705                	addiw	a4,a4,1
 376:	02c5f7bb          	remuw	a5,a1,a2
 37a:	1782                	slli	a5,a5,0x20
 37c:	9381                	srli	a5,a5,0x20
 37e:	97aa                	add	a5,a5,a0
 380:	0007c783          	lbu	a5,0(a5)
 384:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 388:	0005879b          	sext.w	a5,a1
 38c:	02c5d5bb          	divuw	a1,a1,a2
 390:	0685                	addi	a3,a3,1
 392:	fec7f0e3          	bgeu	a5,a2,372 <printint+0x2a>
  if(neg)
 396:	00088b63          	beqz	a7,3ac <printint+0x64>
    buf[i++] = '-';
 39a:	fd040793          	addi	a5,s0,-48
 39e:	973e                	add	a4,a4,a5
 3a0:	02d00793          	li	a5,45
 3a4:	fef70823          	sb	a5,-16(a4)
 3a8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ac:	02e05663          	blez	a4,3d8 <printint+0x90>
 3b0:	fc040793          	addi	a5,s0,-64
 3b4:	00e78933          	add	s2,a5,a4
 3b8:	fff78993          	addi	s3,a5,-1
 3bc:	99ba                	add	s3,s3,a4
 3be:	377d                	addiw	a4,a4,-1
 3c0:	1702                	slli	a4,a4,0x20
 3c2:	9301                	srli	a4,a4,0x20
 3c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3c8:	fff94583          	lbu	a1,-1(s2)
 3cc:	8526                	mv	a0,s1
 3ce:	f5dff0ef          	jal	ra,32a <putc>
  while(--i >= 0)
 3d2:	197d                	addi	s2,s2,-1
 3d4:	ff391ae3          	bne	s2,s3,3c8 <printint+0x80>
}
 3d8:	70e2                	ld	ra,56(sp)
 3da:	7442                	ld	s0,48(sp)
 3dc:	74a2                	ld	s1,40(sp)
 3de:	7902                	ld	s2,32(sp)
 3e0:	69e2                	ld	s3,24(sp)
 3e2:	6121                	addi	sp,sp,64
 3e4:	8082                	ret
    x = -xx;
 3e6:	40b005bb          	negw	a1,a1
    neg = 1;
 3ea:	4885                	li	a7,1
    x = -xx;
 3ec:	bf9d                	j	362 <printint+0x1a>

00000000000003ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3ee:	7119                	addi	sp,sp,-128
 3f0:	fc86                	sd	ra,120(sp)
 3f2:	f8a2                	sd	s0,112(sp)
 3f4:	f4a6                	sd	s1,104(sp)
 3f6:	f0ca                	sd	s2,96(sp)
 3f8:	ecce                	sd	s3,88(sp)
 3fa:	e8d2                	sd	s4,80(sp)
 3fc:	e4d6                	sd	s5,72(sp)
 3fe:	e0da                	sd	s6,64(sp)
 400:	fc5e                	sd	s7,56(sp)
 402:	f862                	sd	s8,48(sp)
 404:	f466                	sd	s9,40(sp)
 406:	f06a                	sd	s10,32(sp)
 408:	ec6e                	sd	s11,24(sp)
 40a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 40c:	0005c903          	lbu	s2,0(a1)
 410:	22090e63          	beqz	s2,64c <vprintf+0x25e>
 414:	8b2a                	mv	s6,a0
 416:	8a2e                	mv	s4,a1
 418:	8bb2                	mv	s7,a2
  state = 0;
 41a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 41c:	4481                	li	s1,0
 41e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 420:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 424:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 428:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 42c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 430:	00000c97          	auipc	s9,0x0
 434:	408c8c93          	addi	s9,s9,1032 # 838 <digits>
 438:	a005                	j	458 <vprintf+0x6a>
        putc(fd, c0);
 43a:	85ca                	mv	a1,s2
 43c:	855a                	mv	a0,s6
 43e:	eedff0ef          	jal	ra,32a <putc>
 442:	a019                	j	448 <vprintf+0x5a>
    } else if(state == '%'){
 444:	03598263          	beq	s3,s5,468 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 448:	2485                	addiw	s1,s1,1
 44a:	8726                	mv	a4,s1
 44c:	009a07b3          	add	a5,s4,s1
 450:	0007c903          	lbu	s2,0(a5)
 454:	1e090c63          	beqz	s2,64c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 458:	0009079b          	sext.w	a5,s2
    if(state == 0){
 45c:	fe0994e3          	bnez	s3,444 <vprintf+0x56>
      if(c0 == '%'){
 460:	fd579de3          	bne	a5,s5,43a <vprintf+0x4c>
        state = '%';
 464:	89be                	mv	s3,a5
 466:	b7cd                	j	448 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 468:	cfa5                	beqz	a5,4e0 <vprintf+0xf2>
 46a:	00ea06b3          	add	a3,s4,a4
 46e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 472:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 474:	c681                	beqz	a3,47c <vprintf+0x8e>
 476:	9752                	add	a4,a4,s4
 478:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 47c:	03878a63          	beq	a5,s8,4b0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 480:	05a78463          	beq	a5,s10,4c8 <vprintf+0xda>
      } else if(c0 == 'u'){
 484:	0db78763          	beq	a5,s11,552 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 488:	07800713          	li	a4,120
 48c:	10e78963          	beq	a5,a4,59e <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 490:	07000713          	li	a4,112
 494:	12e78e63          	beq	a5,a4,5d0 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 498:	07300713          	li	a4,115
 49c:	16e78b63          	beq	a5,a4,612 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4a0:	05579063          	bne	a5,s5,4e0 <vprintf+0xf2>
        putc(fd, '%');
 4a4:	85d6                	mv	a1,s5
 4a6:	855a                	mv	a0,s6
 4a8:	e83ff0ef          	jal	ra,32a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ac:	4981                	li	s3,0
 4ae:	bf69                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4b0:	008b8913          	addi	s2,s7,8
 4b4:	4685                	li	a3,1
 4b6:	4629                	li	a2,10
 4b8:	000ba583          	lw	a1,0(s7)
 4bc:	855a                	mv	a0,s6
 4be:	e8bff0ef          	jal	ra,348 <printint>
 4c2:	8bca                	mv	s7,s2
      state = 0;
 4c4:	4981                	li	s3,0
 4c6:	b749                	j	448 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	03868663          	beq	a3,s8,4f4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4cc:	05a68163          	beq	a3,s10,50e <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 4d0:	09b68d63          	beq	a3,s11,56a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4d4:	03a68f63          	beq	a3,s10,512 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 4d8:	07800793          	li	a5,120
 4dc:	0cf68d63          	beq	a3,a5,5b6 <vprintf+0x1c8>
        putc(fd, '%');
 4e0:	85d6                	mv	a1,s5
 4e2:	855a                	mv	a0,s6
 4e4:	e47ff0ef          	jal	ra,32a <putc>
        putc(fd, c0);
 4e8:	85ca                	mv	a1,s2
 4ea:	855a                	mv	a0,s6
 4ec:	e3fff0ef          	jal	ra,32a <putc>
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	bf99                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f4:	008b8913          	addi	s2,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	e47ff0ef          	jal	ra,348 <printint>
        i += 1;
 506:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 508:	8bca                	mv	s7,s2
      state = 0;
 50a:	4981                	li	s3,0
        i += 1;
 50c:	bf35                	j	448 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50e:	03860563          	beq	a2,s8,538 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 512:	07b60963          	beq	a2,s11,584 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 516:	07800793          	li	a5,120
 51a:	fcf613e3          	bne	a2,a5,4e0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 51e:	008b8913          	addi	s2,s7,8
 522:	4681                	li	a3,0
 524:	4641                	li	a2,16
 526:	000ba583          	lw	a1,0(s7)
 52a:	855a                	mv	a0,s6
 52c:	e1dff0ef          	jal	ra,348 <printint>
        i += 2;
 530:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 532:	8bca                	mv	s7,s2
      state = 0;
 534:	4981                	li	s3,0
        i += 2;
 536:	bf09                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 538:	008b8913          	addi	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e03ff0ef          	jal	ra,348 <printint>
        i += 2;
 54a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
        i += 2;
 550:	bde5                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 552:	008b8913          	addi	s2,s7,8
 556:	4681                	li	a3,0
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	de9ff0ef          	jal	ra,348 <printint>
 564:	8bca                	mv	s7,s2
      state = 0;
 566:	4981                	li	s3,0
 568:	b5c5                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4681                	li	a3,0
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	dd1ff0ef          	jal	ra,348 <printint>
        i += 1;
 57c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
        i += 1;
 582:	b5d9                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 584:	008b8913          	addi	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	db7ff0ef          	jal	ra,348 <printint>
        i += 2;
 596:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	b575                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4641                	li	a2,16
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	d9dff0ef          	jal	ra,348 <printint>
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bd51                	j	448 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4641                	li	a2,16
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	d85ff0ef          	jal	ra,348 <printint>
        i += 1;
 5c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 1;
 5ce:	bdad                	j	448 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 5d0:	008b8793          	addi	a5,s7,8
 5d4:	f8f43423          	sd	a5,-120(s0)
 5d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5dc:	03000593          	li	a1,48
 5e0:	855a                	mv	a0,s6
 5e2:	d49ff0ef          	jal	ra,32a <putc>
  putc(fd, 'x');
 5e6:	07800593          	li	a1,120
 5ea:	855a                	mv	a0,s6
 5ec:	d3fff0ef          	jal	ra,32a <putc>
 5f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f2:	03c9d793          	srli	a5,s3,0x3c
 5f6:	97e6                	add	a5,a5,s9
 5f8:	0007c583          	lbu	a1,0(a5)
 5fc:	855a                	mv	a0,s6
 5fe:	d2dff0ef          	jal	ra,32a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 602:	0992                	slli	s3,s3,0x4
 604:	397d                	addiw	s2,s2,-1
 606:	fe0916e3          	bnez	s2,5f2 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 60a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 60e:	4981                	li	s3,0
 610:	bd25                	j	448 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 612:	008b8993          	addi	s3,s7,8
 616:	000bb903          	ld	s2,0(s7)
 61a:	00090f63          	beqz	s2,638 <vprintf+0x24a>
        for(; *s; s++)
 61e:	00094583          	lbu	a1,0(s2)
 622:	c195                	beqz	a1,646 <vprintf+0x258>
          putc(fd, *s);
 624:	855a                	mv	a0,s6
 626:	d05ff0ef          	jal	ra,32a <putc>
        for(; *s; s++)
 62a:	0905                	addi	s2,s2,1
 62c:	00094583          	lbu	a1,0(s2)
 630:	f9f5                	bnez	a1,624 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 632:	8bce                	mv	s7,s3
      state = 0;
 634:	4981                	li	s3,0
 636:	bd09                	j	448 <vprintf+0x5a>
          s = "(null)";
 638:	00000917          	auipc	s2,0x0
 63c:	1f890913          	addi	s2,s2,504 # 830 <malloc+0xe2>
        for(; *s; s++)
 640:	02800593          	li	a1,40
 644:	b7c5                	j	624 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 646:	8bce                	mv	s7,s3
      state = 0;
 648:	4981                	li	s3,0
 64a:	bbfd                	j	448 <vprintf+0x5a>
    }
  }
}
 64c:	70e6                	ld	ra,120(sp)
 64e:	7446                	ld	s0,112(sp)
 650:	74a6                	ld	s1,104(sp)
 652:	7906                	ld	s2,96(sp)
 654:	69e6                	ld	s3,88(sp)
 656:	6a46                	ld	s4,80(sp)
 658:	6aa6                	ld	s5,72(sp)
 65a:	6b06                	ld	s6,64(sp)
 65c:	7be2                	ld	s7,56(sp)
 65e:	7c42                	ld	s8,48(sp)
 660:	7ca2                	ld	s9,40(sp)
 662:	7d02                	ld	s10,32(sp)
 664:	6de2                	ld	s11,24(sp)
 666:	6109                	addi	sp,sp,128
 668:	8082                	ret

000000000000066a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66a:	715d                	addi	sp,sp,-80
 66c:	ec06                	sd	ra,24(sp)
 66e:	e822                	sd	s0,16(sp)
 670:	1000                	addi	s0,sp,32
 672:	e010                	sd	a2,0(s0)
 674:	e414                	sd	a3,8(s0)
 676:	e818                	sd	a4,16(s0)
 678:	ec1c                	sd	a5,24(s0)
 67a:	03043023          	sd	a6,32(s0)
 67e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 682:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 686:	8622                	mv	a2,s0
 688:	d67ff0ef          	jal	ra,3ee <vprintf>
}
 68c:	60e2                	ld	ra,24(sp)
 68e:	6442                	ld	s0,16(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret

0000000000000694 <printf>:

void
printf(const char *fmt, ...)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e40c                	sd	a1,8(s0)
 69e:	e810                	sd	a2,16(s0)
 6a0:	ec14                	sd	a3,24(s0)
 6a2:	f018                	sd	a4,32(s0)
 6a4:	f41c                	sd	a5,40(s0)
 6a6:	03043823          	sd	a6,48(s0)
 6aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	00840613          	addi	a2,s0,8
 6b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b6:	85aa                	mv	a1,a0
 6b8:	4505                	li	a0,1
 6ba:	d35ff0ef          	jal	ra,3ee <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret

00000000000006c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	1141                	addi	sp,sp,-16
 6c8:	e422                	sd	s0,8(sp)
 6ca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6cc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	00001797          	auipc	a5,0x1
 6d4:	9307b783          	ld	a5,-1744(a5) # 1000 <freep>
 6d8:	a805                	j	708 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6da:	4618                	lw	a4,8(a2)
 6dc:	9db9                	addw	a1,a1,a4
 6de:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e2:	6398                	ld	a4,0(a5)
 6e4:	6318                	ld	a4,0(a4)
 6e6:	fee53823          	sd	a4,-16(a0)
 6ea:	a091                	j	72e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ec:	ff852703          	lw	a4,-8(a0)
 6f0:	9e39                	addw	a2,a2,a4
 6f2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6f4:	ff053703          	ld	a4,-16(a0)
 6f8:	e398                	sd	a4,0(a5)
 6fa:	a099                	j	740 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fc:	6398                	ld	a4,0(a5)
 6fe:	00e7e463          	bltu	a5,a4,706 <free+0x40>
 702:	00e6ea63          	bltu	a3,a4,716 <free+0x50>
{
 706:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 708:	fed7fae3          	bgeu	a5,a3,6fc <free+0x36>
 70c:	6398                	ld	a4,0(a5)
 70e:	00e6e463          	bltu	a3,a4,716 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	fee7eae3          	bltu	a5,a4,706 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 716:	ff852583          	lw	a1,-8(a0)
 71a:	6390                	ld	a2,0(a5)
 71c:	02059713          	slli	a4,a1,0x20
 720:	9301                	srli	a4,a4,0x20
 722:	0712                	slli	a4,a4,0x4
 724:	9736                	add	a4,a4,a3
 726:	fae60ae3          	beq	a2,a4,6da <free+0x14>
    bp->s.ptr = p->s.ptr;
 72a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 72e:	4790                	lw	a2,8(a5)
 730:	02061713          	slli	a4,a2,0x20
 734:	9301                	srli	a4,a4,0x20
 736:	0712                	slli	a4,a4,0x4
 738:	973e                	add	a4,a4,a5
 73a:	fae689e3          	beq	a3,a4,6ec <free+0x26>
  } else
    p->s.ptr = bp;
 73e:	e394                	sd	a3,0(a5)
  freep = p;
 740:	00001717          	auipc	a4,0x1
 744:	8cf73023          	sd	a5,-1856(a4) # 1000 <freep>
}
 748:	6422                	ld	s0,8(sp)
 74a:	0141                	addi	sp,sp,16
 74c:	8082                	ret

000000000000074e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 74e:	7139                	addi	sp,sp,-64
 750:	fc06                	sd	ra,56(sp)
 752:	f822                	sd	s0,48(sp)
 754:	f426                	sd	s1,40(sp)
 756:	f04a                	sd	s2,32(sp)
 758:	ec4e                	sd	s3,24(sp)
 75a:	e852                	sd	s4,16(sp)
 75c:	e456                	sd	s5,8(sp)
 75e:	e05a                	sd	s6,0(sp)
 760:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	02051493          	slli	s1,a0,0x20
 766:	9081                	srli	s1,s1,0x20
 768:	04bd                	addi	s1,s1,15
 76a:	8091                	srli	s1,s1,0x4
 76c:	0014899b          	addiw	s3,s1,1
 770:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 772:	00001517          	auipc	a0,0x1
 776:	88e53503          	ld	a0,-1906(a0) # 1000 <freep>
 77a:	c515                	beqz	a0,7a6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77e:	4798                	lw	a4,8(a5)
 780:	02977f63          	bgeu	a4,s1,7be <malloc+0x70>
 784:	8a4e                	mv	s4,s3
 786:	0009871b          	sext.w	a4,s3
 78a:	6685                	lui	a3,0x1
 78c:	00d77363          	bgeu	a4,a3,792 <malloc+0x44>
 790:	6a05                	lui	s4,0x1
 792:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 796:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 79a:	00001917          	auipc	s2,0x1
 79e:	86690913          	addi	s2,s2,-1946 # 1000 <freep>
  if(p == (char*)-1)
 7a2:	5afd                	li	s5,-1
 7a4:	a0bd                	j	812 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7a6:	00001797          	auipc	a5,0x1
 7aa:	86a78793          	addi	a5,a5,-1942 # 1010 <base>
 7ae:	00001717          	auipc	a4,0x1
 7b2:	84f73923          	sd	a5,-1966(a4) # 1000 <freep>
 7b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7bc:	b7e1                	j	784 <malloc+0x36>
      if(p->s.size == nunits)
 7be:	02e48b63          	beq	s1,a4,7f4 <malloc+0xa6>
        p->s.size -= nunits;
 7c2:	4137073b          	subw	a4,a4,s3
 7c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c8:	1702                	slli	a4,a4,0x20
 7ca:	9301                	srli	a4,a4,0x20
 7cc:	0712                	slli	a4,a4,0x4
 7ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82a73623          	sd	a0,-2004(a4) # 1000 <freep>
      return (void*)(p + 1);
 7dc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e0:	70e2                	ld	ra,56(sp)
 7e2:	7442                	ld	s0,48(sp)
 7e4:	74a2                	ld	s1,40(sp)
 7e6:	7902                	ld	s2,32(sp)
 7e8:	69e2                	ld	s3,24(sp)
 7ea:	6a42                	ld	s4,16(sp)
 7ec:	6aa2                	ld	s5,8(sp)
 7ee:	6b02                	ld	s6,0(sp)
 7f0:	6121                	addi	sp,sp,64
 7f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	bff1                	j	7d4 <malloc+0x86>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	ec7ff0ef          	jal	ra,6c6 <free>
  return freep;
 804:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 808:	dd61                	beqz	a0,7e0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	fa9778e3          	bgeu	a4,s1,7be <malloc+0x70>
    if(p == freep)
 812:	00093703          	ld	a4,0(s2)
 816:	853e                	mv	a0,a5
 818:	fef719e3          	bne	a4,a5,80a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 81c:	8552                	mv	a0,s4
 81e:	af5ff0ef          	jal	ra,312 <sbrk>
  if(p == (char*)-1)
 822:	fd551ce3          	bne	a0,s5,7fa <malloc+0xac>
        return 0;
 826:	4501                	li	a0,0
 828:	bf65                	j	7e0 <malloc+0x92>
