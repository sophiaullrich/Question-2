
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	ra,4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	ra,0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	ra,4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	ra,4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	ra,4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	0880                	addi	s0,sp,80
 11c:	89aa                	mv	s3,a0
 11e:	8b2e                	mv	s6,a1
  m = 0;
 120:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 122:	3ff00b93          	li	s7,1023
 126:	00001a97          	auipc	s5,0x1
 12a:	eeaa8a93          	addi	s5,s5,-278 # 1010 <buf>
 12e:	a835                	j	16a <grep+0x64>
      p = q+1;
 130:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 134:	45a9                	li	a1,10
 136:	854a                	mv	a0,s2
 138:	1bc000ef          	jal	ra,2f4 <strchr>
 13c:	84aa                	mv	s1,a0
 13e:	c505                	beqz	a0,166 <grep+0x60>
      *q = 0;
 140:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 144:	85ca                	mv	a1,s2
 146:	854e                	mv	a0,s3
 148:	f79ff0ef          	jal	ra,c0 <match>
 14c:	d175                	beqz	a0,130 <grep+0x2a>
        *q = '\n';
 14e:	47a9                	li	a5,10
 150:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 154:	00148613          	addi	a2,s1,1
 158:	4126063b          	subw	a2,a2,s2
 15c:	85ca                	mv	a1,s2
 15e:	4505                	li	a0,1
 160:	37a000ef          	jal	ra,4da <write>
 164:	b7f1                	j	130 <grep+0x2a>
    if(m > 0){
 166:	03404363          	bgtz	s4,18c <grep+0x86>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 16a:	414b863b          	subw	a2,s7,s4
 16e:	014a85b3          	add	a1,s5,s4
 172:	855a                	mv	a0,s6
 174:	35e000ef          	jal	ra,4d2 <read>
 178:	02a05463          	blez	a0,1a0 <grep+0x9a>
    m += n;
 17c:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 180:	014a87b3          	add	a5,s5,s4
 184:	00078023          	sb	zero,0(a5)
    p = buf;
 188:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 18a:	b76d                	j	134 <grep+0x2e>
      m -= p - buf;
 18c:	415907b3          	sub	a5,s2,s5
 190:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 194:	8652                	mv	a2,s4
 196:	85ca                	mv	a1,s2
 198:	8556                	mv	a0,s5
 19a:	272000ef          	jal	ra,40c <memmove>
 19e:	b7f1                	j	16a <grep+0x64>
}
 1a0:	60a6                	ld	ra,72(sp)
 1a2:	6406                	ld	s0,64(sp)
 1a4:	74e2                	ld	s1,56(sp)
 1a6:	7942                	ld	s2,48(sp)
 1a8:	79a2                	ld	s3,40(sp)
 1aa:	7a02                	ld	s4,32(sp)
 1ac:	6ae2                	ld	s5,24(sp)
 1ae:	6b42                	ld	s6,16(sp)
 1b0:	6ba2                	ld	s7,8(sp)
 1b2:	6161                	addi	sp,sp,80
 1b4:	8082                	ret

00000000000001b6 <main>:
{
 1b6:	7139                	addi	sp,sp,-64
 1b8:	fc06                	sd	ra,56(sp)
 1ba:	f822                	sd	s0,48(sp)
 1bc:	f426                	sd	s1,40(sp)
 1be:	f04a                	sd	s2,32(sp)
 1c0:	ec4e                	sd	s3,24(sp)
 1c2:	e852                	sd	s4,16(sp)
 1c4:	e456                	sd	s5,8(sp)
 1c6:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1c8:	4785                	li	a5,1
 1ca:	04a7d663          	bge	a5,a0,216 <main+0x60>
  pattern = argv[1];
 1ce:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1d2:	4789                	li	a5,2
 1d4:	04a7db63          	bge	a5,a0,22a <main+0x74>
 1d8:	01058913          	addi	s2,a1,16
 1dc:	ffd5099b          	addiw	s3,a0,-3
 1e0:	1982                	slli	s3,s3,0x20
 1e2:	0209d993          	srli	s3,s3,0x20
 1e6:	098e                	slli	s3,s3,0x3
 1e8:	05e1                	addi	a1,a1,24
 1ea:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1ec:	4581                	li	a1,0
 1ee:	00093503          	ld	a0,0(s2)
 1f2:	308000ef          	jal	ra,4fa <open>
 1f6:	84aa                	mv	s1,a0
 1f8:	04054063          	bltz	a0,238 <main+0x82>
    grep(pattern, fd);
 1fc:	85aa                	mv	a1,a0
 1fe:	8552                	mv	a0,s4
 200:	f07ff0ef          	jal	ra,106 <grep>
    close(fd);
 204:	8526                	mv	a0,s1
 206:	2dc000ef          	jal	ra,4e2 <close>
  for(i = 2; i < argc; i++){
 20a:	0921                	addi	s2,s2,8
 20c:	ff3910e3          	bne	s2,s3,1ec <main+0x36>
  exit(0);
 210:	4501                	li	a0,0
 212:	2a8000ef          	jal	ra,4ba <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 216:	00001597          	auipc	a1,0x1
 21a:	84a58593          	addi	a1,a1,-1974 # a60 <malloc+0xe2>
 21e:	4509                	li	a0,2
 220:	67a000ef          	jal	ra,89a <fprintf>
    exit(1);
 224:	4505                	li	a0,1
 226:	294000ef          	jal	ra,4ba <exit>
    grep(pattern, 0);
 22a:	4581                	li	a1,0
 22c:	8552                	mv	a0,s4
 22e:	ed9ff0ef          	jal	ra,106 <grep>
    exit(0);
 232:	4501                	li	a0,0
 234:	286000ef          	jal	ra,4ba <exit>
      printf("grep: cannot open %s\n", argv[i]);
 238:	00093583          	ld	a1,0(s2)
 23c:	00001517          	auipc	a0,0x1
 240:	84450513          	addi	a0,a0,-1980 # a80 <malloc+0x102>
 244:	680000ef          	jal	ra,8c4 <printf>
      exit(1);
 248:	4505                	li	a0,1
 24a:	270000ef          	jal	ra,4ba <exit>

000000000000024e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  extern int main();
  main();
 256:	f61ff0ef          	jal	ra,1b6 <main>
  exit(0);
 25a:	4501                	li	a0,0
 25c:	25e000ef          	jal	ra,4ba <exit>

0000000000000260 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 266:	87aa                	mv	a5,a0
 268:	0585                	addi	a1,a1,1
 26a:	0785                	addi	a5,a5,1
 26c:	fff5c703          	lbu	a4,-1(a1)
 270:	fee78fa3          	sb	a4,-1(a5)
 274:	fb75                	bnez	a4,268 <strcpy+0x8>
    ;
  return os;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret

000000000000027c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 282:	00054783          	lbu	a5,0(a0)
 286:	cb91                	beqz	a5,29a <strcmp+0x1e>
 288:	0005c703          	lbu	a4,0(a1)
 28c:	00f71763          	bne	a4,a5,29a <strcmp+0x1e>
    p++, q++;
 290:	0505                	addi	a0,a0,1
 292:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	fbe5                	bnez	a5,288 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 29a:	0005c503          	lbu	a0,0(a1)
}
 29e:	40a7853b          	subw	a0,a5,a0
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <strlen>:

uint
strlen(const char *s)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	cf91                	beqz	a5,2ce <strlen+0x26>
 2b4:	0505                	addi	a0,a0,1
 2b6:	87aa                	mv	a5,a0
 2b8:	4685                	li	a3,1
 2ba:	9e89                	subw	a3,a3,a0
 2bc:	00f6853b          	addw	a0,a3,a5
 2c0:	0785                	addi	a5,a5,1
 2c2:	fff7c703          	lbu	a4,-1(a5)
 2c6:	fb7d                	bnez	a4,2bc <strlen+0x14>
    ;
  return n;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  for(n = 0; s[n]; n++)
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <strlen+0x20>

00000000000002d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d8:	ca19                	beqz	a2,2ee <memset+0x1c>
 2da:	87aa                	mv	a5,a0
 2dc:	1602                	slli	a2,a2,0x20
 2de:	9201                	srli	a2,a2,0x20
 2e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e8:	0785                	addi	a5,a5,1
 2ea:	fee79de3          	bne	a5,a4,2e4 <memset+0x12>
  }
  return dst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strchr>:

char*
strchr(const char *s, char c)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb99                	beqz	a5,314 <strchr+0x20>
    if(*s == c)
 300:	00f58763          	beq	a1,a5,30e <strchr+0x1a>
  for(; *s; s++)
 304:	0505                	addi	a0,a0,1
 306:	00054783          	lbu	a5,0(a0)
 30a:	fbfd                	bnez	a5,300 <strchr+0xc>
      return (char*)s;
  return 0;
 30c:	4501                	li	a0,0
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strchr+0x1a>

0000000000000318 <gets>:

char*
gets(char *buf, int max)
{
 318:	711d                	addi	sp,sp,-96
 31a:	ec86                	sd	ra,88(sp)
 31c:	e8a2                	sd	s0,80(sp)
 31e:	e4a6                	sd	s1,72(sp)
 320:	e0ca                	sd	s2,64(sp)
 322:	fc4e                	sd	s3,56(sp)
 324:	f852                	sd	s4,48(sp)
 326:	f456                	sd	s5,40(sp)
 328:	f05a                	sd	s6,32(sp)
 32a:	ec5e                	sd	s7,24(sp)
 32c:	1080                	addi	s0,sp,96
 32e:	8baa                	mv	s7,a0
 330:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 332:	892a                	mv	s2,a0
 334:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 336:	4aa9                	li	s5,10
 338:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 33a:	89a6                	mv	s3,s1
 33c:	2485                	addiw	s1,s1,1
 33e:	0344d663          	bge	s1,s4,36a <gets+0x52>
    cc = read(0, &c, 1);
 342:	4605                	li	a2,1
 344:	faf40593          	addi	a1,s0,-81
 348:	4501                	li	a0,0
 34a:	188000ef          	jal	ra,4d2 <read>
    if(cc < 1)
 34e:	00a05e63          	blez	a0,36a <gets+0x52>
    buf[i++] = c;
 352:	faf44783          	lbu	a5,-81(s0)
 356:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 35a:	01578763          	beq	a5,s5,368 <gets+0x50>
 35e:	0905                	addi	s2,s2,1
 360:	fd679de3          	bne	a5,s6,33a <gets+0x22>
  for(i=0; i+1 < max; ){
 364:	89a6                	mv	s3,s1
 366:	a011                	j	36a <gets+0x52>
 368:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 36a:	99de                	add	s3,s3,s7
 36c:	00098023          	sb	zero,0(s3)
  return buf;
}
 370:	855e                	mv	a0,s7
 372:	60e6                	ld	ra,88(sp)
 374:	6446                	ld	s0,80(sp)
 376:	64a6                	ld	s1,72(sp)
 378:	6906                	ld	s2,64(sp)
 37a:	79e2                	ld	s3,56(sp)
 37c:	7a42                	ld	s4,48(sp)
 37e:	7aa2                	ld	s5,40(sp)
 380:	7b02                	ld	s6,32(sp)
 382:	6be2                	ld	s7,24(sp)
 384:	6125                	addi	sp,sp,96
 386:	8082                	ret

0000000000000388 <stat>:

int
stat(const char *n, struct stat *st)
{
 388:	1101                	addi	sp,sp,-32
 38a:	ec06                	sd	ra,24(sp)
 38c:	e822                	sd	s0,16(sp)
 38e:	e426                	sd	s1,8(sp)
 390:	e04a                	sd	s2,0(sp)
 392:	1000                	addi	s0,sp,32
 394:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 396:	4581                	li	a1,0
 398:	162000ef          	jal	ra,4fa <open>
  if(fd < 0)
 39c:	02054163          	bltz	a0,3be <stat+0x36>
 3a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a2:	85ca                	mv	a1,s2
 3a4:	16e000ef          	jal	ra,512 <fstat>
 3a8:	892a                	mv	s2,a0
  close(fd);
 3aa:	8526                	mv	a0,s1
 3ac:	136000ef          	jal	ra,4e2 <close>
  return r;
}
 3b0:	854a                	mv	a0,s2
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	64a2                	ld	s1,8(sp)
 3b8:	6902                	ld	s2,0(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret
    return -1;
 3be:	597d                	li	s2,-1
 3c0:	bfc5                	j	3b0 <stat+0x28>

00000000000003c2 <atoi>:

int
atoi(const char *s)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c8:	00054603          	lbu	a2,0(a0)
 3cc:	fd06079b          	addiw	a5,a2,-48
 3d0:	0ff7f793          	andi	a5,a5,255
 3d4:	4725                	li	a4,9
 3d6:	02f76963          	bltu	a4,a5,408 <atoi+0x46>
 3da:	86aa                	mv	a3,a0
  n = 0;
 3dc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3de:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3e0:	0685                	addi	a3,a3,1
 3e2:	0025179b          	slliw	a5,a0,0x2
 3e6:	9fa9                	addw	a5,a5,a0
 3e8:	0017979b          	slliw	a5,a5,0x1
 3ec:	9fb1                	addw	a5,a5,a2
 3ee:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f2:	0006c603          	lbu	a2,0(a3)
 3f6:	fd06071b          	addiw	a4,a2,-48
 3fa:	0ff77713          	andi	a4,a4,255
 3fe:	fee5f1e3          	bgeu	a1,a4,3e0 <atoi+0x1e>
  return n;
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
  n = 0;
 408:	4501                	li	a0,0
 40a:	bfe5                	j	402 <atoi+0x40>

000000000000040c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 412:	02b57463          	bgeu	a0,a1,43a <memmove+0x2e>
    while(n-- > 0)
 416:	00c05f63          	blez	a2,434 <memmove+0x28>
 41a:	1602                	slli	a2,a2,0x20
 41c:	9201                	srli	a2,a2,0x20
 41e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 422:	872a                	mv	a4,a0
      *dst++ = *src++;
 424:	0585                	addi	a1,a1,1
 426:	0705                	addi	a4,a4,1
 428:	fff5c683          	lbu	a3,-1(a1)
 42c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 430:	fee79ae3          	bne	a5,a4,424 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 434:	6422                	ld	s0,8(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret
    dst += n;
 43a:	00c50733          	add	a4,a0,a2
    src += n;
 43e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 440:	fec05ae3          	blez	a2,434 <memmove+0x28>
 444:	fff6079b          	addiw	a5,a2,-1
 448:	1782                	slli	a5,a5,0x20
 44a:	9381                	srli	a5,a5,0x20
 44c:	fff7c793          	not	a5,a5
 450:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 452:	15fd                	addi	a1,a1,-1
 454:	177d                	addi	a4,a4,-1
 456:	0005c683          	lbu	a3,0(a1)
 45a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 45e:	fee79ae3          	bne	a5,a4,452 <memmove+0x46>
 462:	bfc9                	j	434 <memmove+0x28>

0000000000000464 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 464:	1141                	addi	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 46a:	ca05                	beqz	a2,49a <memcmp+0x36>
 46c:	fff6069b          	addiw	a3,a2,-1
 470:	1682                	slli	a3,a3,0x20
 472:	9281                	srli	a3,a3,0x20
 474:	0685                	addi	a3,a3,1
 476:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 478:	00054783          	lbu	a5,0(a0)
 47c:	0005c703          	lbu	a4,0(a1)
 480:	00e79863          	bne	a5,a4,490 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 484:	0505                	addi	a0,a0,1
    p2++;
 486:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 488:	fed518e3          	bne	a0,a3,478 <memcmp+0x14>
  }
  return 0;
 48c:	4501                	li	a0,0
 48e:	a019                	j	494 <memcmp+0x30>
      return *p1 - *p2;
 490:	40e7853b          	subw	a0,a5,a4
}
 494:	6422                	ld	s0,8(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret
  return 0;
 49a:	4501                	li	a0,0
 49c:	bfe5                	j	494 <memcmp+0x30>

000000000000049e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49e:	1141                	addi	sp,sp,-16
 4a0:	e406                	sd	ra,8(sp)
 4a2:	e022                	sd	s0,0(sp)
 4a4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a6:	f67ff0ef          	jal	ra,40c <memmove>
}
 4aa:	60a2                	ld	ra,8(sp)
 4ac:	6402                	ld	s0,0(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b2:	4885                	li	a7,1
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ba:	4889                	li	a7,2
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c2:	488d                	li	a7,3
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ca:	4891                	li	a7,4
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <read>:
.global read
read:
 li a7, SYS_read
 4d2:	4895                	li	a7,5
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <write>:
.global write
write:
 li a7, SYS_write
 4da:	48c1                	li	a7,16
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <close>:
.global close
close:
 li a7, SYS_close
 4e2:	48d5                	li	a7,21
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ea:	4899                	li	a7,6
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f2:	489d                	li	a7,7
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <open>:
.global open
open:
 li a7, SYS_open
 4fa:	48bd                	li	a7,15
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 502:	48c5                	li	a7,17
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50a:	48c9                	li	a7,18
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 512:	48a1                	li	a7,8
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <link>:
.global link
link:
 li a7, SYS_link
 51a:	48cd                	li	a7,19
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 522:	48d1                	li	a7,20
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52a:	48a5                	li	a7,9
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <dup>:
.global dup
dup:
 li a7, SYS_dup
 532:	48a9                	li	a7,10
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53a:	48ad                	li	a7,11
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 542:	48b1                	li	a7,12
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54a:	48b5                	li	a7,13
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 552:	48b9                	li	a7,14
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55a:	1101                	addi	sp,sp,-32
 55c:	ec06                	sd	ra,24(sp)
 55e:	e822                	sd	s0,16(sp)
 560:	1000                	addi	s0,sp,32
 562:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 566:	4605                	li	a2,1
 568:	fef40593          	addi	a1,s0,-17
 56c:	f6fff0ef          	jal	ra,4da <write>
}
 570:	60e2                	ld	ra,24(sp)
 572:	6442                	ld	s0,16(sp)
 574:	6105                	addi	sp,sp,32
 576:	8082                	ret

0000000000000578 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	7139                	addi	sp,sp,-64
 57a:	fc06                	sd	ra,56(sp)
 57c:	f822                	sd	s0,48(sp)
 57e:	f426                	sd	s1,40(sp)
 580:	f04a                	sd	s2,32(sp)
 582:	ec4e                	sd	s3,24(sp)
 584:	0080                	addi	s0,sp,64
 586:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 588:	c299                	beqz	a3,58e <printint+0x16>
 58a:	0805c663          	bltz	a1,616 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 58e:	2581                	sext.w	a1,a1
  neg = 0;
 590:	4881                	li	a7,0
 592:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 596:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 598:	2601                	sext.w	a2,a2
 59a:	00000517          	auipc	a0,0x0
 59e:	50650513          	addi	a0,a0,1286 # aa0 <digits>
 5a2:	883a                	mv	a6,a4
 5a4:	2705                	addiw	a4,a4,1
 5a6:	02c5f7bb          	remuw	a5,a1,a2
 5aa:	1782                	slli	a5,a5,0x20
 5ac:	9381                	srli	a5,a5,0x20
 5ae:	97aa                	add	a5,a5,a0
 5b0:	0007c783          	lbu	a5,0(a5)
 5b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b8:	0005879b          	sext.w	a5,a1
 5bc:	02c5d5bb          	divuw	a1,a1,a2
 5c0:	0685                	addi	a3,a3,1
 5c2:	fec7f0e3          	bgeu	a5,a2,5a2 <printint+0x2a>
  if(neg)
 5c6:	00088b63          	beqz	a7,5dc <printint+0x64>
    buf[i++] = '-';
 5ca:	fd040793          	addi	a5,s0,-48
 5ce:	973e                	add	a4,a4,a5
 5d0:	02d00793          	li	a5,45
 5d4:	fef70823          	sb	a5,-16(a4)
 5d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5dc:	02e05663          	blez	a4,608 <printint+0x90>
 5e0:	fc040793          	addi	a5,s0,-64
 5e4:	00e78933          	add	s2,a5,a4
 5e8:	fff78993          	addi	s3,a5,-1
 5ec:	99ba                	add	s3,s3,a4
 5ee:	377d                	addiw	a4,a4,-1
 5f0:	1702                	slli	a4,a4,0x20
 5f2:	9301                	srli	a4,a4,0x20
 5f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f8:	fff94583          	lbu	a1,-1(s2)
 5fc:	8526                	mv	a0,s1
 5fe:	f5dff0ef          	jal	ra,55a <putc>
  while(--i >= 0)
 602:	197d                	addi	s2,s2,-1
 604:	ff391ae3          	bne	s2,s3,5f8 <printint+0x80>
}
 608:	70e2                	ld	ra,56(sp)
 60a:	7442                	ld	s0,48(sp)
 60c:	74a2                	ld	s1,40(sp)
 60e:	7902                	ld	s2,32(sp)
 610:	69e2                	ld	s3,24(sp)
 612:	6121                	addi	sp,sp,64
 614:	8082                	ret
    x = -xx;
 616:	40b005bb          	negw	a1,a1
    neg = 1;
 61a:	4885                	li	a7,1
    x = -xx;
 61c:	bf9d                	j	592 <printint+0x1a>

000000000000061e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 61e:	7119                	addi	sp,sp,-128
 620:	fc86                	sd	ra,120(sp)
 622:	f8a2                	sd	s0,112(sp)
 624:	f4a6                	sd	s1,104(sp)
 626:	f0ca                	sd	s2,96(sp)
 628:	ecce                	sd	s3,88(sp)
 62a:	e8d2                	sd	s4,80(sp)
 62c:	e4d6                	sd	s5,72(sp)
 62e:	e0da                	sd	s6,64(sp)
 630:	fc5e                	sd	s7,56(sp)
 632:	f862                	sd	s8,48(sp)
 634:	f466                	sd	s9,40(sp)
 636:	f06a                	sd	s10,32(sp)
 638:	ec6e                	sd	s11,24(sp)
 63a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63c:	0005c903          	lbu	s2,0(a1)
 640:	22090e63          	beqz	s2,87c <vprintf+0x25e>
 644:	8b2a                	mv	s6,a0
 646:	8a2e                	mv	s4,a1
 648:	8bb2                	mv	s7,a2
  state = 0;
 64a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 64c:	4481                	li	s1,0
 64e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 650:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 654:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 658:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 65c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	00000c97          	auipc	s9,0x0
 664:	440c8c93          	addi	s9,s9,1088 # aa0 <digits>
 668:	a005                	j	688 <vprintf+0x6a>
        putc(fd, c0);
 66a:	85ca                	mv	a1,s2
 66c:	855a                	mv	a0,s6
 66e:	eedff0ef          	jal	ra,55a <putc>
 672:	a019                	j	678 <vprintf+0x5a>
    } else if(state == '%'){
 674:	03598263          	beq	s3,s5,698 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 678:	2485                	addiw	s1,s1,1
 67a:	8726                	mv	a4,s1
 67c:	009a07b3          	add	a5,s4,s1
 680:	0007c903          	lbu	s2,0(a5)
 684:	1e090c63          	beqz	s2,87c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 688:	0009079b          	sext.w	a5,s2
    if(state == 0){
 68c:	fe0994e3          	bnez	s3,674 <vprintf+0x56>
      if(c0 == '%'){
 690:	fd579de3          	bne	a5,s5,66a <vprintf+0x4c>
        state = '%';
 694:	89be                	mv	s3,a5
 696:	b7cd                	j	678 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 698:	cfa5                	beqz	a5,710 <vprintf+0xf2>
 69a:	00ea06b3          	add	a3,s4,a4
 69e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6a4:	c681                	beqz	a3,6ac <vprintf+0x8e>
 6a6:	9752                	add	a4,a4,s4
 6a8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ac:	03878a63          	beq	a5,s8,6e0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6b0:	05a78463          	beq	a5,s10,6f8 <vprintf+0xda>
      } else if(c0 == 'u'){
 6b4:	0db78763          	beq	a5,s11,782 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6b8:	07800713          	li	a4,120
 6bc:	10e78963          	beq	a5,a4,7ce <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6c0:	07000713          	li	a4,112
 6c4:	12e78e63          	beq	a5,a4,800 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6c8:	07300713          	li	a4,115
 6cc:	16e78b63          	beq	a5,a4,842 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6d0:	05579063          	bne	a5,s5,710 <vprintf+0xf2>
        putc(fd, '%');
 6d4:	85d6                	mv	a1,s5
 6d6:	855a                	mv	a0,s6
 6d8:	e83ff0ef          	jal	ra,55a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bf69                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4685                	li	a3,1
 6e6:	4629                	li	a2,10
 6e8:	000ba583          	lw	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	e8bff0ef          	jal	ra,578 <printint>
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b749                	j	678 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 6f8:	03868663          	beq	a3,s8,724 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6fc:	05a68163          	beq	a3,s10,73e <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 700:	09b68d63          	beq	a3,s11,79a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 704:	03a68f63          	beq	a3,s10,742 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 708:	07800793          	li	a5,120
 70c:	0cf68d63          	beq	a3,a5,7e6 <vprintf+0x1c8>
        putc(fd, '%');
 710:	85d6                	mv	a1,s5
 712:	855a                	mv	a0,s6
 714:	e47ff0ef          	jal	ra,55a <putc>
        putc(fd, c0);
 718:	85ca                	mv	a1,s2
 71a:	855a                	mv	a0,s6
 71c:	e3fff0ef          	jal	ra,55a <putc>
      state = 0;
 720:	4981                	li	s3,0
 722:	bf99                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 724:	008b8913          	addi	s2,s7,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	e47ff0ef          	jal	ra,578 <printint>
        i += 1;
 736:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 1;
 73c:	bf35                	j	678 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 73e:	03860563          	beq	a2,s8,768 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 742:	07b60963          	beq	a2,s11,7b4 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 746:	07800793          	li	a5,120
 74a:	fcf613e3          	bne	a2,a5,710 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 74e:	008b8913          	addi	s2,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000ba583          	lw	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	e1dff0ef          	jal	ra,578 <printint>
        i += 2;
 760:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
        i += 2;
 766:	bf09                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 768:	008b8913          	addi	s2,s7,8
 76c:	4685                	li	a3,1
 76e:	4629                	li	a2,10
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	e03ff0ef          	jal	ra,578 <printint>
        i += 2;
 77a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
        i += 2;
 780:	bde5                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	de9ff0ef          	jal	ra,578 <printint>
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	b5c5                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	dd1ff0ef          	jal	ra,578 <printint>
        i += 1;
 7ac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
        i += 1;
 7b2:	b5d9                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	db7ff0ef          	jal	ra,578 <printint>
        i += 2;
 7c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
        i += 2;
 7cc:	b575                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4641                	li	a2,16
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	d9dff0ef          	jal	ra,578 <printint>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bd51                	j	678 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000ba583          	lw	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	d85ff0ef          	jal	ra,578 <printint>
        i += 1;
 7f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
        i += 1;
 7fe:	bdad                	j	678 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 800:	008b8793          	addi	a5,s7,8
 804:	f8f43423          	sd	a5,-120(s0)
 808:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 80c:	03000593          	li	a1,48
 810:	855a                	mv	a0,s6
 812:	d49ff0ef          	jal	ra,55a <putc>
  putc(fd, 'x');
 816:	07800593          	li	a1,120
 81a:	855a                	mv	a0,s6
 81c:	d3fff0ef          	jal	ra,55a <putc>
 820:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 822:	03c9d793          	srli	a5,s3,0x3c
 826:	97e6                	add	a5,a5,s9
 828:	0007c583          	lbu	a1,0(a5)
 82c:	855a                	mv	a0,s6
 82e:	d2dff0ef          	jal	ra,55a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 832:	0992                	slli	s3,s3,0x4
 834:	397d                	addiw	s2,s2,-1
 836:	fe0916e3          	bnez	s2,822 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 83a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 83e:	4981                	li	s3,0
 840:	bd25                	j	678 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 842:	008b8993          	addi	s3,s7,8
 846:	000bb903          	ld	s2,0(s7)
 84a:	00090f63          	beqz	s2,868 <vprintf+0x24a>
        for(; *s; s++)
 84e:	00094583          	lbu	a1,0(s2)
 852:	c195                	beqz	a1,876 <vprintf+0x258>
          putc(fd, *s);
 854:	855a                	mv	a0,s6
 856:	d05ff0ef          	jal	ra,55a <putc>
        for(; *s; s++)
 85a:	0905                	addi	s2,s2,1
 85c:	00094583          	lbu	a1,0(s2)
 860:	f9f5                	bnez	a1,854 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 862:	8bce                	mv	s7,s3
      state = 0;
 864:	4981                	li	s3,0
 866:	bd09                	j	678 <vprintf+0x5a>
          s = "(null)";
 868:	00000917          	auipc	s2,0x0
 86c:	23090913          	addi	s2,s2,560 # a98 <malloc+0x11a>
        for(; *s; s++)
 870:	02800593          	li	a1,40
 874:	b7c5                	j	854 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 876:	8bce                	mv	s7,s3
      state = 0;
 878:	4981                	li	s3,0
 87a:	bbfd                	j	678 <vprintf+0x5a>
    }
  }
}
 87c:	70e6                	ld	ra,120(sp)
 87e:	7446                	ld	s0,112(sp)
 880:	74a6                	ld	s1,104(sp)
 882:	7906                	ld	s2,96(sp)
 884:	69e6                	ld	s3,88(sp)
 886:	6a46                	ld	s4,80(sp)
 888:	6aa6                	ld	s5,72(sp)
 88a:	6b06                	ld	s6,64(sp)
 88c:	7be2                	ld	s7,56(sp)
 88e:	7c42                	ld	s8,48(sp)
 890:	7ca2                	ld	s9,40(sp)
 892:	7d02                	ld	s10,32(sp)
 894:	6de2                	ld	s11,24(sp)
 896:	6109                	addi	sp,sp,128
 898:	8082                	ret

000000000000089a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89a:	715d                	addi	sp,sp,-80
 89c:	ec06                	sd	ra,24(sp)
 89e:	e822                	sd	s0,16(sp)
 8a0:	1000                	addi	s0,sp,32
 8a2:	e010                	sd	a2,0(s0)
 8a4:	e414                	sd	a3,8(s0)
 8a6:	e818                	sd	a4,16(s0)
 8a8:	ec1c                	sd	a5,24(s0)
 8aa:	03043023          	sd	a6,32(s0)
 8ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b6:	8622                	mv	a2,s0
 8b8:	d67ff0ef          	jal	ra,61e <vprintf>
}
 8bc:	60e2                	ld	ra,24(sp)
 8be:	6442                	ld	s0,16(sp)
 8c0:	6161                	addi	sp,sp,80
 8c2:	8082                	ret

00000000000008c4 <printf>:

void
printf(const char *fmt, ...)
{
 8c4:	711d                	addi	sp,sp,-96
 8c6:	ec06                	sd	ra,24(sp)
 8c8:	e822                	sd	s0,16(sp)
 8ca:	1000                	addi	s0,sp,32
 8cc:	e40c                	sd	a1,8(s0)
 8ce:	e810                	sd	a2,16(s0)
 8d0:	ec14                	sd	a3,24(s0)
 8d2:	f018                	sd	a4,32(s0)
 8d4:	f41c                	sd	a5,40(s0)
 8d6:	03043823          	sd	a6,48(s0)
 8da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	00840613          	addi	a2,s0,8
 8e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e6:	85aa                	mv	a1,a0
 8e8:	4505                	li	a0,1
 8ea:	d35ff0ef          	jal	ra,61e <vprintf>
}
 8ee:	60e2                	ld	ra,24(sp)
 8f0:	6442                	ld	s0,16(sp)
 8f2:	6125                	addi	sp,sp,96
 8f4:	8082                	ret

00000000000008f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f6:	1141                	addi	sp,sp,-16
 8f8:	e422                	sd	s0,8(sp)
 8fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 900:	00000797          	auipc	a5,0x0
 904:	7007b783          	ld	a5,1792(a5) # 1000 <freep>
 908:	a805                	j	938 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90a:	4618                	lw	a4,8(a2)
 90c:	9db9                	addw	a1,a1,a4
 90e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	6318                	ld	a4,0(a4)
 916:	fee53823          	sd	a4,-16(a0)
 91a:	a091                	j	95e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91c:	ff852703          	lw	a4,-8(a0)
 920:	9e39                	addw	a2,a2,a4
 922:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 924:	ff053703          	ld	a4,-16(a0)
 928:	e398                	sd	a4,0(a5)
 92a:	a099                	j	970 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	6398                	ld	a4,0(a5)
 92e:	00e7e463          	bltu	a5,a4,936 <free+0x40>
 932:	00e6ea63          	bltu	a3,a4,946 <free+0x50>
{
 936:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	fed7fae3          	bgeu	a5,a3,92c <free+0x36>
 93c:	6398                	ld	a4,0(a5)
 93e:	00e6e463          	bltu	a3,a4,946 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	fee7eae3          	bltu	a5,a4,936 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 946:	ff852583          	lw	a1,-8(a0)
 94a:	6390                	ld	a2,0(a5)
 94c:	02059713          	slli	a4,a1,0x20
 950:	9301                	srli	a4,a4,0x20
 952:	0712                	slli	a4,a4,0x4
 954:	9736                	add	a4,a4,a3
 956:	fae60ae3          	beq	a2,a4,90a <free+0x14>
    bp->s.ptr = p->s.ptr;
 95a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95e:	4790                	lw	a2,8(a5)
 960:	02061713          	slli	a4,a2,0x20
 964:	9301                	srli	a4,a4,0x20
 966:	0712                	slli	a4,a4,0x4
 968:	973e                	add	a4,a4,a5
 96a:	fae689e3          	beq	a3,a4,91c <free+0x26>
  } else
    p->s.ptr = bp;
 96e:	e394                	sd	a3,0(a5)
  freep = p;
 970:	00000717          	auipc	a4,0x0
 974:	68f73823          	sd	a5,1680(a4) # 1000 <freep>
}
 978:	6422                	ld	s0,8(sp)
 97a:	0141                	addi	sp,sp,16
 97c:	8082                	ret

000000000000097e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97e:	7139                	addi	sp,sp,-64
 980:	fc06                	sd	ra,56(sp)
 982:	f822                	sd	s0,48(sp)
 984:	f426                	sd	s1,40(sp)
 986:	f04a                	sd	s2,32(sp)
 988:	ec4e                	sd	s3,24(sp)
 98a:	e852                	sd	s4,16(sp)
 98c:	e456                	sd	s5,8(sp)
 98e:	e05a                	sd	s6,0(sp)
 990:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	02051493          	slli	s1,a0,0x20
 996:	9081                	srli	s1,s1,0x20
 998:	04bd                	addi	s1,s1,15
 99a:	8091                	srli	s1,s1,0x4
 99c:	0014899b          	addiw	s3,s1,1
 9a0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a2:	00000517          	auipc	a0,0x0
 9a6:	65e53503          	ld	a0,1630(a0) # 1000 <freep>
 9aa:	c515                	beqz	a0,9d6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ae:	4798                	lw	a4,8(a5)
 9b0:	02977f63          	bgeu	a4,s1,9ee <malloc+0x70>
 9b4:	8a4e                	mv	s4,s3
 9b6:	0009871b          	sext.w	a4,s3
 9ba:	6685                	lui	a3,0x1
 9bc:	00d77363          	bgeu	a4,a3,9c2 <malloc+0x44>
 9c0:	6a05                	lui	s4,0x1
 9c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ca:	00000917          	auipc	s2,0x0
 9ce:	63690913          	addi	s2,s2,1590 # 1000 <freep>
  if(p == (char*)-1)
 9d2:	5afd                	li	s5,-1
 9d4:	a0bd                	j	a42 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 9d6:	00001797          	auipc	a5,0x1
 9da:	a3a78793          	addi	a5,a5,-1478 # 1410 <base>
 9de:	00000717          	auipc	a4,0x0
 9e2:	62f73123          	sd	a5,1570(a4) # 1000 <freep>
 9e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ec:	b7e1                	j	9b4 <malloc+0x36>
      if(p->s.size == nunits)
 9ee:	02e48b63          	beq	s1,a4,a24 <malloc+0xa6>
        p->s.size -= nunits;
 9f2:	4137073b          	subw	a4,a4,s3
 9f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f8:	1702                	slli	a4,a4,0x20
 9fa:	9301                	srli	a4,a4,0x20
 9fc:	0712                	slli	a4,a4,0x4
 9fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a00:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a04:	00000717          	auipc	a4,0x0
 a08:	5ea73e23          	sd	a0,1532(a4) # 1000 <freep>
      return (void*)(p + 1);
 a0c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a10:	70e2                	ld	ra,56(sp)
 a12:	7442                	ld	s0,48(sp)
 a14:	74a2                	ld	s1,40(sp)
 a16:	7902                	ld	s2,32(sp)
 a18:	69e2                	ld	s3,24(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
 a20:	6121                	addi	sp,sp,64
 a22:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a24:	6398                	ld	a4,0(a5)
 a26:	e118                	sd	a4,0(a0)
 a28:	bff1                	j	a04 <malloc+0x86>
  hp->s.size = nu;
 a2a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2e:	0541                	addi	a0,a0,16
 a30:	ec7ff0ef          	jal	ra,8f6 <free>
  return freep;
 a34:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a38:	dd61                	beqz	a0,a10 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3c:	4798                	lw	a4,8(a5)
 a3e:	fa9778e3          	bgeu	a4,s1,9ee <malloc+0x70>
    if(p == freep)
 a42:	00093703          	ld	a4,0(s2)
 a46:	853e                	mv	a0,a5
 a48:	fef719e3          	bne	a4,a5,a3a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 a4c:	8552                	mv	a0,s4
 a4e:	af5ff0ef          	jal	ra,542 <sbrk>
  if(p == (char*)-1)
 a52:	fd551ce3          	bne	a0,s5,a2a <malloc+0xac>
        return 0;
 a56:	4501                	li	a0,0
 a58:	bf65                	j	a10 <malloc+0x92>
