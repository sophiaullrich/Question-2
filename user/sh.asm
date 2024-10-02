
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	17e58593          	addi	a1,a1,382 # 1190 <malloc+0xe2>
      1a:	4509                	li	a0,2
      1c:	3ef000ef          	jal	ra,c0a <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1dd000ef          	jal	ra,a02 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	21b000ef          	jal	ra,a48 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	14458593          	addi	a1,a1,324 # 1198 <malloc+0xea>
      5c:	4509                	li	a0,2
      5e:	76d000ef          	jal	ra,fca <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	387000ef          	jal	ra,bea <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	373000ef          	jal	ra,be2 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	11e50513          	addi	a0,a0,286 # 11a0 <malloc+0xf2>
      8a:	fc1ff0ef          	jal	ra,4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	addi	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	1f670713          	addi	a4,a4,502 # 12a0 <malloc+0x1f2>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	32f000ef          	jal	ra,bea <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	0e850513          	addi	a0,a0,232 # 11a8 <malloc+0xfa>
      c8:	f83ff0ef          	jal	ra,4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	addi	a1,s1,8
      d4:	34f000ef          	jal	ra,c22 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	0d658593          	addi	a1,a1,214 # 11b0 <malloc+0x102>
      e2:	4509                	li	a0,2
      e4:	6e7000ef          	jal	ra,fca <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	301000ef          	jal	ra,bea <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	2fb000ef          	jal	ra,bea <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	31d000ef          	jal	ra,c12 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	32d000ef          	jal	ra,c2a <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	ra,8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	0b258593          	addi	a1,a1,178 # 11c0 <malloc+0x112>
     116:	4509                	li	a0,2
     118:	6b3000ef          	jal	ra,fca <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	2cd000ef          	jal	ra,bea <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	ra,68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	ra,8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	2c3000ef          	jal	ra,bf2 <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	ra,8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	addi	a0,s0,-40
     13e:	2bd000ef          	jal	ra,bfa <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	ra,68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	2c5000ef          	jal	ra,c12 <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	30d000ef          	jal	ra,c62 <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2b5000ef          	jal	ra,c12 <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2ad000ef          	jal	ra,c12 <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	ra,8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	06050513          	addi	a0,a0,96 # 11d0 <malloc+0x122>
     178:	ed3ff0ef          	jal	ra,4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	ra,68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	291000ef          	jal	ra,c12 <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	2d9000ef          	jal	ra,c62 <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	281000ef          	jal	ra,c12 <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	279000ef          	jal	ra,c12 <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	ra,8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	26b000ef          	jal	ra,c12 <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	263000ef          	jal	ra,c12 <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	23d000ef          	jal	ra,bf2 <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	237000ef          	jal	ra,bf2 <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	ra,68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	ra,8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	addi	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	6d1000ef          	jal	ra,10ae <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	019000ef          	jal	ra,a02 <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	addi	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	addi	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	addi	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	68f000ef          	jal	ra,10ae <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7d6000ef          	jal	ra,a02 <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	addi	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	addi	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	addi	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	63d000ef          	jal	ra,10ae <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	786000ef          	jal	ra,a02 <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	addi	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	addi	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	addi	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	5ff000ef          	jal	ra,10ae <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	748000ef          	jal	ra,a02 <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	addi	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	addi	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	addi	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	5c5000ef          	jal	ra,10ae <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	70e000ef          	jal	ra,a02 <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	addi	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	addi	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	addi	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	addi	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fb63          	bgeu	s1,a1,34a <gettoken+0x3c>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	6e6000ef          	jal	ra,a24 <strchr>
     342:	c501                	beqz	a0,34a <gettoken+0x3c>
    s++;
     344:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
  if(q)
     34a:	000a8463          	beqz	s5,352 <gettoken+0x44>
    *q = s;
     34e:	009ab023          	sd	s1,0(s5)
  ret = *s;
     352:	0004c783          	lbu	a5,0(s1)
     356:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35a:	03c00713          	li	a4,60
     35e:	06f76363          	bltu	a4,a5,3c4 <gettoken+0xb6>
     362:	03a00713          	li	a4,58
     366:	00f76e63          	bltu	a4,a5,382 <gettoken+0x74>
     36a:	cf89                	beqz	a5,384 <gettoken+0x76>
     36c:	02600713          	li	a4,38
     370:	00e78963          	beq	a5,a4,382 <gettoken+0x74>
     374:	fd87879b          	addiw	a5,a5,-40
     378:	0ff7f793          	andi	a5,a5,255
     37c:	4705                	li	a4,1
     37e:	06f76a63          	bltu	a4,a5,3f2 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     382:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     384:	000b0463          	beqz	s6,38c <gettoken+0x7e>
    *eq = s;
     388:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38c:	00002997          	auipc	s3,0x2
     390:	c7c98993          	addi	s3,s3,-900 # 2008 <whitespace>
     394:	0124fb63          	bgeu	s1,s2,3aa <gettoken+0x9c>
     398:	0004c583          	lbu	a1,0(s1)
     39c:	854e                	mv	a0,s3
     39e:	686000ef          	jal	ra,a24 <strchr>
     3a2:	c501                	beqz	a0,3aa <gettoken+0x9c>
    s++;
     3a4:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a6:	fe9919e3          	bne	s2,s1,398 <gettoken+0x8a>
  *ps = s;
     3aa:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3ae:	8556                	mv	a0,s5
     3b0:	70e2                	ld	ra,56(sp)
     3b2:	7442                	ld	s0,48(sp)
     3b4:	74a2                	ld	s1,40(sp)
     3b6:	7902                	ld	s2,32(sp)
     3b8:	69e2                	ld	s3,24(sp)
     3ba:	6a42                	ld	s4,16(sp)
     3bc:	6aa2                	ld	s5,8(sp)
     3be:	6b02                	ld	s6,0(sp)
     3c0:	6121                	addi	sp,sp,64
     3c2:	8082                	ret
  switch(*s){
     3c4:	03e00713          	li	a4,62
     3c8:	02e79163          	bne	a5,a4,3ea <gettoken+0xdc>
    s++;
     3cc:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d0:	0014c703          	lbu	a4,1(s1)
     3d4:	03e00793          	li	a5,62
      s++;
     3d8:	0489                	addi	s1,s1,2
      ret = '+';
     3da:	02b00a93          	li	s5,43
    if(*s == '>'){
     3de:	faf703e3          	beq	a4,a5,384 <gettoken+0x76>
    s++;
     3e2:	84b6                	mv	s1,a3
  ret = *s;
     3e4:	03e00a93          	li	s5,62
     3e8:	bf71                	j	384 <gettoken+0x76>
  switch(*s){
     3ea:	07c00713          	li	a4,124
     3ee:	f8e78ae3          	beq	a5,a4,382 <gettoken+0x74>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f2:	00002997          	auipc	s3,0x2
     3f6:	c1698993          	addi	s3,s3,-1002 # 2008 <whitespace>
     3fa:	00002a97          	auipc	s5,0x2
     3fe:	c06a8a93          	addi	s5,s5,-1018 # 2000 <symbols>
     402:	0324f163          	bgeu	s1,s2,424 <gettoken+0x116>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	618000ef          	jal	ra,a24 <strchr>
     410:	e115                	bnez	a0,434 <gettoken+0x126>
     412:	0004c583          	lbu	a1,0(s1)
     416:	8556                	mv	a0,s5
     418:	60c000ef          	jal	ra,a24 <strchr>
     41c:	e909                	bnez	a0,42e <gettoken+0x120>
      s++;
     41e:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     420:	fe9913e3          	bne	s2,s1,406 <gettoken+0xf8>
  if(eq)
     424:	06100a93          	li	s5,97
     428:	f60b10e3          	bnez	s6,388 <gettoken+0x7a>
     42c:	bfbd                	j	3aa <gettoken+0x9c>
    ret = 'a';
     42e:	06100a93          	li	s5,97
     432:	bf89                	j	384 <gettoken+0x76>
     434:	06100a93          	li	s5,97
     438:	b7b1                	j	384 <gettoken+0x76>

000000000000043a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     43a:	7139                	addi	sp,sp,-64
     43c:	fc06                	sd	ra,56(sp)
     43e:	f822                	sd	s0,48(sp)
     440:	f426                	sd	s1,40(sp)
     442:	f04a                	sd	s2,32(sp)
     444:	ec4e                	sd	s3,24(sp)
     446:	e852                	sd	s4,16(sp)
     448:	e456                	sd	s5,8(sp)
     44a:	0080                	addi	s0,sp,64
     44c:	8a2a                	mv	s4,a0
     44e:	892e                	mv	s2,a1
     450:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     452:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     454:	00002997          	auipc	s3,0x2
     458:	bb498993          	addi	s3,s3,-1100 # 2008 <whitespace>
     45c:	00b4fb63          	bgeu	s1,a1,472 <peek+0x38>
     460:	0004c583          	lbu	a1,0(s1)
     464:	854e                	mv	a0,s3
     466:	5be000ef          	jal	ra,a24 <strchr>
     46a:	c501                	beqz	a0,472 <peek+0x38>
    s++;
     46c:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     46e:	fe9919e3          	bne	s2,s1,460 <peek+0x26>
  *ps = s;
     472:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     476:	0004c583          	lbu	a1,0(s1)
     47a:	4501                	li	a0,0
     47c:	e991                	bnez	a1,490 <peek+0x56>
}
     47e:	70e2                	ld	ra,56(sp)
     480:	7442                	ld	s0,48(sp)
     482:	74a2                	ld	s1,40(sp)
     484:	7902                	ld	s2,32(sp)
     486:	69e2                	ld	s3,24(sp)
     488:	6a42                	ld	s4,16(sp)
     48a:	6aa2                	ld	s5,8(sp)
     48c:	6121                	addi	sp,sp,64
     48e:	8082                	ret
  return *s && strchr(toks, *s);
     490:	8556                	mv	a0,s5
     492:	592000ef          	jal	ra,a24 <strchr>
     496:	00a03533          	snez	a0,a0
     49a:	b7d5                	j	47e <peek+0x44>

000000000000049c <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     49c:	7159                	addi	sp,sp,-112
     49e:	f486                	sd	ra,104(sp)
     4a0:	f0a2                	sd	s0,96(sp)
     4a2:	eca6                	sd	s1,88(sp)
     4a4:	e8ca                	sd	s2,80(sp)
     4a6:	e4ce                	sd	s3,72(sp)
     4a8:	e0d2                	sd	s4,64(sp)
     4aa:	fc56                	sd	s5,56(sp)
     4ac:	f85a                	sd	s6,48(sp)
     4ae:	f45e                	sd	s7,40(sp)
     4b0:	f062                	sd	s8,32(sp)
     4b2:	ec66                	sd	s9,24(sp)
     4b4:	1880                	addi	s0,sp,112
     4b6:	8a2a                	mv	s4,a0
     4b8:	89ae                	mv	s3,a1
     4ba:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4bc:	00001b97          	auipc	s7,0x1
     4c0:	d3cb8b93          	addi	s7,s7,-708 # 11f8 <malloc+0x14a>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4c4:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4c8:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4cc:	a00d                	j	4ee <parseredirs+0x52>
      panic("missing file for redirection");
     4ce:	00001517          	auipc	a0,0x1
     4d2:	d0a50513          	addi	a0,a0,-758 # 11d8 <malloc+0x12a>
     4d6:	b75ff0ef          	jal	ra,4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4da:	4701                	li	a4,0
     4dc:	4681                	li	a3,0
     4de:	f9043603          	ld	a2,-112(s0)
     4e2:	f9843583          	ld	a1,-104(s0)
     4e6:	8552                	mv	a0,s4
     4e8:	d17ff0ef          	jal	ra,1fe <redircmd>
     4ec:	8a2a                	mv	s4,a0
    switch(tok){
     4ee:	03e00b13          	li	s6,62
     4f2:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     4f6:	865e                	mv	a2,s7
     4f8:	85ca                	mv	a1,s2
     4fa:	854e                	mv	a0,s3
     4fc:	f3fff0ef          	jal	ra,43a <peek>
     500:	c125                	beqz	a0,560 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     502:	4681                	li	a3,0
     504:	4601                	li	a2,0
     506:	85ca                	mv	a1,s2
     508:	854e                	mv	a0,s3
     50a:	e05ff0ef          	jal	ra,30e <gettoken>
     50e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     510:	f9040693          	addi	a3,s0,-112
     514:	f9840613          	addi	a2,s0,-104
     518:	85ca                	mv	a1,s2
     51a:	854e                	mv	a0,s3
     51c:	df3ff0ef          	jal	ra,30e <gettoken>
     520:	fb8517e3          	bne	a0,s8,4ce <parseredirs+0x32>
    switch(tok){
     524:	fb948be3          	beq	s1,s9,4da <parseredirs+0x3e>
     528:	03648063          	beq	s1,s6,548 <parseredirs+0xac>
     52c:	fd5495e3          	bne	s1,s5,4f6 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     530:	4705                	li	a4,1
     532:	20100693          	li	a3,513
     536:	f9043603          	ld	a2,-112(s0)
     53a:	f9843583          	ld	a1,-104(s0)
     53e:	8552                	mv	a0,s4
     540:	cbfff0ef          	jal	ra,1fe <redircmd>
     544:	8a2a                	mv	s4,a0
      break;
     546:	b765                	j	4ee <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     548:	4705                	li	a4,1
     54a:	60100693          	li	a3,1537
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca7ff0ef          	jal	ra,1fe <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	bf41                	j	4ee <parseredirs+0x52>
    }
  }
  return cmd;
}
     560:	8552                	mv	a0,s4
     562:	70a6                	ld	ra,104(sp)
     564:	7406                	ld	s0,96(sp)
     566:	64e6                	ld	s1,88(sp)
     568:	6946                	ld	s2,80(sp)
     56a:	69a6                	ld	s3,72(sp)
     56c:	6a06                	ld	s4,64(sp)
     56e:	7ae2                	ld	s5,56(sp)
     570:	7b42                	ld	s6,48(sp)
     572:	7ba2                	ld	s7,40(sp)
     574:	7c02                	ld	s8,32(sp)
     576:	6ce2                	ld	s9,24(sp)
     578:	6165                	addi	sp,sp,112
     57a:	8082                	ret

000000000000057c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     57c:	7159                	addi	sp,sp,-112
     57e:	f486                	sd	ra,104(sp)
     580:	f0a2                	sd	s0,96(sp)
     582:	eca6                	sd	s1,88(sp)
     584:	e8ca                	sd	s2,80(sp)
     586:	e4ce                	sd	s3,72(sp)
     588:	e0d2                	sd	s4,64(sp)
     58a:	fc56                	sd	s5,56(sp)
     58c:	f85a                	sd	s6,48(sp)
     58e:	f45e                	sd	s7,40(sp)
     590:	f062                	sd	s8,32(sp)
     592:	ec66                	sd	s9,24(sp)
     594:	1880                	addi	s0,sp,112
     596:	8a2a                	mv	s4,a0
     598:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59a:	00001617          	auipc	a2,0x1
     59e:	c6660613          	addi	a2,a2,-922 # 1200 <malloc+0x152>
     5a2:	e99ff0ef          	jal	ra,43a <peek>
     5a6:	e505                	bnez	a0,5ce <parseexec+0x52>
     5a8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5aa:	c27ff0ef          	jal	ra,1d0 <execcmd>
     5ae:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5b0:	8656                	mv	a2,s5
     5b2:	85d2                	mv	a1,s4
     5b4:	ee9ff0ef          	jal	ra,49c <parseredirs>
     5b8:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5ba:	008c0913          	addi	s2,s8,8
     5be:	00001b17          	auipc	s6,0x1
     5c2:	c62b0b13          	addi	s6,s6,-926 # 1220 <malloc+0x172>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5c6:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ca:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5cc:	a081                	j	60c <parseexec+0x90>
    return parseblock(ps, es);
     5ce:	85d6                	mv	a1,s5
     5d0:	8552                	mv	a0,s4
     5d2:	170000ef          	jal	ra,742 <parseblock>
     5d6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5d8:	8526                	mv	a0,s1
     5da:	70a6                	ld	ra,104(sp)
     5dc:	7406                	ld	s0,96(sp)
     5de:	64e6                	ld	s1,88(sp)
     5e0:	6946                	ld	s2,80(sp)
     5e2:	69a6                	ld	s3,72(sp)
     5e4:	6a06                	ld	s4,64(sp)
     5e6:	7ae2                	ld	s5,56(sp)
     5e8:	7b42                	ld	s6,48(sp)
     5ea:	7ba2                	ld	s7,40(sp)
     5ec:	7c02                	ld	s8,32(sp)
     5ee:	6ce2                	ld	s9,24(sp)
     5f0:	6165                	addi	sp,sp,112
     5f2:	8082                	ret
      panic("syntax");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	c1450513          	addi	a0,a0,-1004 # 1208 <malloc+0x15a>
     5fc:	a4fff0ef          	jal	ra,4a <panic>
    ret = parseredirs(ret, ps, es);
     600:	8656                	mv	a2,s5
     602:	85d2                	mv	a1,s4
     604:	8526                	mv	a0,s1
     606:	e97ff0ef          	jal	ra,49c <parseredirs>
     60a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60c:	865a                	mv	a2,s6
     60e:	85d6                	mv	a1,s5
     610:	8552                	mv	a0,s4
     612:	e29ff0ef          	jal	ra,43a <peek>
     616:	ed15                	bnez	a0,652 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     618:	f9040693          	addi	a3,s0,-112
     61c:	f9840613          	addi	a2,s0,-104
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	cebff0ef          	jal	ra,30e <gettoken>
     628:	c50d                	beqz	a0,652 <parseexec+0xd6>
    if(tok != 'a')
     62a:	fd9515e3          	bne	a0,s9,5f4 <parseexec+0x78>
    cmd->argv[argc] = q;
     62e:	f9843783          	ld	a5,-104(s0)
     632:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     636:	f9043783          	ld	a5,-112(s0)
     63a:	04f93823          	sd	a5,80(s2)
    argc++;
     63e:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     640:	0921                	addi	s2,s2,8
     642:	fb799fe3          	bne	s3,s7,600 <parseexec+0x84>
      panic("too many args");
     646:	00001517          	auipc	a0,0x1
     64a:	bca50513          	addi	a0,a0,-1078 # 1210 <malloc+0x162>
     64e:	9fdff0ef          	jal	ra,4a <panic>
  cmd->argv[argc] = 0;
     652:	098e                	slli	s3,s3,0x3
     654:	99e2                	add	s3,s3,s8
     656:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     65a:	0409bc23          	sd	zero,88(s3)
  return ret;
     65e:	bfad                	j	5d8 <parseexec+0x5c>

0000000000000660 <parsepipe>:
{
     660:	7179                	addi	sp,sp,-48
     662:	f406                	sd	ra,40(sp)
     664:	f022                	sd	s0,32(sp)
     666:	ec26                	sd	s1,24(sp)
     668:	e84a                	sd	s2,16(sp)
     66a:	e44e                	sd	s3,8(sp)
     66c:	1800                	addi	s0,sp,48
     66e:	892a                	mv	s2,a0
     670:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     672:	f0bff0ef          	jal	ra,57c <parseexec>
     676:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     678:	00001617          	auipc	a2,0x1
     67c:	bb060613          	addi	a2,a2,-1104 # 1228 <malloc+0x17a>
     680:	85ce                	mv	a1,s3
     682:	854a                	mv	a0,s2
     684:	db7ff0ef          	jal	ra,43a <peek>
     688:	e909                	bnez	a0,69a <parsepipe+0x3a>
}
     68a:	8526                	mv	a0,s1
     68c:	70a2                	ld	ra,40(sp)
     68e:	7402                	ld	s0,32(sp)
     690:	64e2                	ld	s1,24(sp)
     692:	6942                	ld	s2,16(sp)
     694:	69a2                	ld	s3,8(sp)
     696:	6145                	addi	sp,sp,48
     698:	8082                	ret
    gettoken(ps, es, 0, 0);
     69a:	4681                	li	a3,0
     69c:	4601                	li	a2,0
     69e:	85ce                	mv	a1,s3
     6a0:	854a                	mv	a0,s2
     6a2:	c6dff0ef          	jal	ra,30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6a6:	85ce                	mv	a1,s3
     6a8:	854a                	mv	a0,s2
     6aa:	fb7ff0ef          	jal	ra,660 <parsepipe>
     6ae:	85aa                	mv	a1,a0
     6b0:	8526                	mv	a0,s1
     6b2:	badff0ef          	jal	ra,25e <pipecmd>
     6b6:	84aa                	mv	s1,a0
  return cmd;
     6b8:	bfc9                	j	68a <parsepipe+0x2a>

00000000000006ba <parseline>:
{
     6ba:	7179                	addi	sp,sp,-48
     6bc:	f406                	sd	ra,40(sp)
     6be:	f022                	sd	s0,32(sp)
     6c0:	ec26                	sd	s1,24(sp)
     6c2:	e84a                	sd	s2,16(sp)
     6c4:	e44e                	sd	s3,8(sp)
     6c6:	e052                	sd	s4,0(sp)
     6c8:	1800                	addi	s0,sp,48
     6ca:	892a                	mv	s2,a0
     6cc:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6ce:	f93ff0ef          	jal	ra,660 <parsepipe>
     6d2:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6d4:	00001a17          	auipc	s4,0x1
     6d8:	b5ca0a13          	addi	s4,s4,-1188 # 1230 <malloc+0x182>
     6dc:	a819                	j	6f2 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6de:	4681                	li	a3,0
     6e0:	4601                	li	a2,0
     6e2:	85ce                	mv	a1,s3
     6e4:	854a                	mv	a0,s2
     6e6:	c29ff0ef          	jal	ra,30e <gettoken>
    cmd = backcmd(cmd);
     6ea:	8526                	mv	a0,s1
     6ec:	befff0ef          	jal	ra,2da <backcmd>
     6f0:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6f2:	8652                	mv	a2,s4
     6f4:	85ce                	mv	a1,s3
     6f6:	854a                	mv	a0,s2
     6f8:	d43ff0ef          	jal	ra,43a <peek>
     6fc:	f16d                	bnez	a0,6de <parseline+0x24>
  if(peek(ps, es, ";")){
     6fe:	00001617          	auipc	a2,0x1
     702:	b3a60613          	addi	a2,a2,-1222 # 1238 <malloc+0x18a>
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	d31ff0ef          	jal	ra,43a <peek>
     70e:	e911                	bnez	a0,722 <parseline+0x68>
}
     710:	8526                	mv	a0,s1
     712:	70a2                	ld	ra,40(sp)
     714:	7402                	ld	s0,32(sp)
     716:	64e2                	ld	s1,24(sp)
     718:	6942                	ld	s2,16(sp)
     71a:	69a2                	ld	s3,8(sp)
     71c:	6a02                	ld	s4,0(sp)
     71e:	6145                	addi	sp,sp,48
     720:	8082                	ret
    gettoken(ps, es, 0, 0);
     722:	4681                	li	a3,0
     724:	4601                	li	a2,0
     726:	85ce                	mv	a1,s3
     728:	854a                	mv	a0,s2
     72a:	be5ff0ef          	jal	ra,30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	f89ff0ef          	jal	ra,6ba <parseline>
     736:	85aa                	mv	a1,a0
     738:	8526                	mv	a0,s1
     73a:	b63ff0ef          	jal	ra,29c <listcmd>
     73e:	84aa                	mv	s1,a0
  return cmd;
     740:	bfc1                	j	710 <parseline+0x56>

0000000000000742 <parseblock>:
{
     742:	7179                	addi	sp,sp,-48
     744:	f406                	sd	ra,40(sp)
     746:	f022                	sd	s0,32(sp)
     748:	ec26                	sd	s1,24(sp)
     74a:	e84a                	sd	s2,16(sp)
     74c:	e44e                	sd	s3,8(sp)
     74e:	1800                	addi	s0,sp,48
     750:	84aa                	mv	s1,a0
     752:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     754:	00001617          	auipc	a2,0x1
     758:	aac60613          	addi	a2,a2,-1364 # 1200 <malloc+0x152>
     75c:	cdfff0ef          	jal	ra,43a <peek>
     760:	c539                	beqz	a0,7ae <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     762:	4681                	li	a3,0
     764:	4601                	li	a2,0
     766:	85ca                	mv	a1,s2
     768:	8526                	mv	a0,s1
     76a:	ba5ff0ef          	jal	ra,30e <gettoken>
  cmd = parseline(ps, es);
     76e:	85ca                	mv	a1,s2
     770:	8526                	mv	a0,s1
     772:	f49ff0ef          	jal	ra,6ba <parseline>
     776:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     778:	00001617          	auipc	a2,0x1
     77c:	ad860613          	addi	a2,a2,-1320 # 1250 <malloc+0x1a2>
     780:	85ca                	mv	a1,s2
     782:	8526                	mv	a0,s1
     784:	cb7ff0ef          	jal	ra,43a <peek>
     788:	c90d                	beqz	a0,7ba <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7dff0ef          	jal	ra,30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     796:	864a                	mv	a2,s2
     798:	85a6                	mv	a1,s1
     79a:	854e                	mv	a0,s3
     79c:	d01ff0ef          	jal	ra,49c <parseredirs>
}
     7a0:	70a2                	ld	ra,40(sp)
     7a2:	7402                	ld	s0,32(sp)
     7a4:	64e2                	ld	s1,24(sp)
     7a6:	6942                	ld	s2,16(sp)
     7a8:	69a2                	ld	s3,8(sp)
     7aa:	6145                	addi	sp,sp,48
     7ac:	8082                	ret
    panic("parseblock");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	a9250513          	addi	a0,a0,-1390 # 1240 <malloc+0x192>
     7b6:	895ff0ef          	jal	ra,4a <panic>
    panic("syntax - missing )");
     7ba:	00001517          	auipc	a0,0x1
     7be:	a9e50513          	addi	a0,a0,-1378 # 1258 <malloc+0x1aa>
     7c2:	889ff0ef          	jal	ra,4a <panic>

00000000000007c6 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7c6:	1101                	addi	sp,sp,-32
     7c8:	ec06                	sd	ra,24(sp)
     7ca:	e822                	sd	s0,16(sp)
     7cc:	e426                	sd	s1,8(sp)
     7ce:	1000                	addi	s0,sp,32
     7d0:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7d2:	c131                	beqz	a0,816 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7d4:	4118                	lw	a4,0(a0)
     7d6:	4795                	li	a5,5
     7d8:	02e7ef63          	bltu	a5,a4,816 <nulterminate+0x50>
     7dc:	00056783          	lwu	a5,0(a0)
     7e0:	078a                	slli	a5,a5,0x2
     7e2:	00001717          	auipc	a4,0x1
     7e6:	ad670713          	addi	a4,a4,-1322 # 12b8 <malloc+0x20a>
     7ea:	97ba                	add	a5,a5,a4
     7ec:	439c                	lw	a5,0(a5)
     7ee:	97ba                	add	a5,a5,a4
     7f0:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     7f2:	651c                	ld	a5,8(a0)
     7f4:	c38d                	beqz	a5,816 <nulterminate+0x50>
     7f6:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     7fa:	67b8                	ld	a4,72(a5)
     7fc:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     800:	07a1                	addi	a5,a5,8
     802:	ff87b703          	ld	a4,-8(a5)
     806:	fb75                	bnez	a4,7fa <nulterminate+0x34>
     808:	a039                	j	816 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     80a:	6508                	ld	a0,8(a0)
     80c:	fbbff0ef          	jal	ra,7c6 <nulterminate>
    *rcmd->efile = 0;
     810:	6c9c                	ld	a5,24(s1)
     812:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     816:	8526                	mv	a0,s1
     818:	60e2                	ld	ra,24(sp)
     81a:	6442                	ld	s0,16(sp)
     81c:	64a2                	ld	s1,8(sp)
     81e:	6105                	addi	sp,sp,32
     820:	8082                	ret
    nulterminate(pcmd->left);
     822:	6508                	ld	a0,8(a0)
     824:	fa3ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(pcmd->right);
     828:	6888                	ld	a0,16(s1)
     82a:	f9dff0ef          	jal	ra,7c6 <nulterminate>
    break;
     82e:	b7e5                	j	816 <nulterminate+0x50>
    nulterminate(lcmd->left);
     830:	6508                	ld	a0,8(a0)
     832:	f95ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(lcmd->right);
     836:	6888                	ld	a0,16(s1)
     838:	f8fff0ef          	jal	ra,7c6 <nulterminate>
    break;
     83c:	bfe9                	j	816 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     83e:	6508                	ld	a0,8(a0)
     840:	f87ff0ef          	jal	ra,7c6 <nulterminate>
    break;
     844:	bfc9                	j	816 <nulterminate+0x50>

0000000000000846 <parsecmd>:
{
     846:	7179                	addi	sp,sp,-48
     848:	f406                	sd	ra,40(sp)
     84a:	f022                	sd	s0,32(sp)
     84c:	ec26                	sd	s1,24(sp)
     84e:	e84a                	sd	s2,16(sp)
     850:	1800                	addi	s0,sp,48
     852:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     856:	84aa                	mv	s1,a0
     858:	180000ef          	jal	ra,9d8 <strlen>
     85c:	1502                	slli	a0,a0,0x20
     85e:	9101                	srli	a0,a0,0x20
     860:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     862:	85a6                	mv	a1,s1
     864:	fd840513          	addi	a0,s0,-40
     868:	e53ff0ef          	jal	ra,6ba <parseline>
     86c:	892a                	mv	s2,a0
  peek(&s, es, "");
     86e:	00001617          	auipc	a2,0x1
     872:	a0260613          	addi	a2,a2,-1534 # 1270 <malloc+0x1c2>
     876:	85a6                	mv	a1,s1
     878:	fd840513          	addi	a0,s0,-40
     87c:	bbfff0ef          	jal	ra,43a <peek>
  if(s != es){
     880:	fd843603          	ld	a2,-40(s0)
     884:	00961c63          	bne	a2,s1,89c <parsecmd+0x56>
  nulterminate(cmd);
     888:	854a                	mv	a0,s2
     88a:	f3dff0ef          	jal	ra,7c6 <nulterminate>
}
     88e:	854a                	mv	a0,s2
     890:	70a2                	ld	ra,40(sp)
     892:	7402                	ld	s0,32(sp)
     894:	64e2                	ld	s1,24(sp)
     896:	6942                	ld	s2,16(sp)
     898:	6145                	addi	sp,sp,48
     89a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     89c:	00001597          	auipc	a1,0x1
     8a0:	9dc58593          	addi	a1,a1,-1572 # 1278 <malloc+0x1ca>
     8a4:	4509                	li	a0,2
     8a6:	724000ef          	jal	ra,fca <fprintf>
    panic("syntax");
     8aa:	00001517          	auipc	a0,0x1
     8ae:	95e50513          	addi	a0,a0,-1698 # 1208 <malloc+0x15a>
     8b2:	f98ff0ef          	jal	ra,4a <panic>

00000000000008b6 <main>:
{
     8b6:	7139                	addi	sp,sp,-64
     8b8:	fc06                	sd	ra,56(sp)
     8ba:	f822                	sd	s0,48(sp)
     8bc:	f426                	sd	s1,40(sp)
     8be:	f04a                	sd	s2,32(sp)
     8c0:	ec4e                	sd	s3,24(sp)
     8c2:	e852                	sd	s4,16(sp)
     8c4:	e456                	sd	s5,8(sp)
     8c6:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8c8:	00001497          	auipc	s1,0x1
     8cc:	9c048493          	addi	s1,s1,-1600 # 1288 <malloc+0x1da>
     8d0:	4589                	li	a1,2
     8d2:	8526                	mv	a0,s1
     8d4:	356000ef          	jal	ra,c2a <open>
     8d8:	00054763          	bltz	a0,8e6 <main+0x30>
    if(fd >= 3){
     8dc:	4789                	li	a5,2
     8de:	fea7d9e3          	bge	a5,a0,8d0 <main+0x1a>
      close(fd);
     8e2:	330000ef          	jal	ra,c12 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8e6:	00001497          	auipc	s1,0x1
     8ea:	73a48493          	addi	s1,s1,1850 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8ee:	06300913          	li	s2,99
     8f2:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     8f6:	00001a17          	auipc	s4,0x1
     8fa:	72da0a13          	addi	s4,s4,1837 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     8fe:	00001a97          	auipc	s5,0x1
     902:	992a8a93          	addi	s5,s5,-1646 # 1290 <malloc+0x1e2>
     906:	a039                	j	914 <main+0x5e>
    if(fork1() == 0)
     908:	f60ff0ef          	jal	ra,68 <fork1>
     90c:	cd31                	beqz	a0,968 <main+0xb2>
    wait(0);
     90e:	4501                	li	a0,0
     910:	2e2000ef          	jal	ra,bf2 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     914:	06400593          	li	a1,100
     918:	8526                	mv	a0,s1
     91a:	ee6ff0ef          	jal	ra,0 <getcmd>
     91e:	04054d63          	bltz	a0,978 <main+0xc2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     922:	0004c783          	lbu	a5,0(s1)
     926:	ff2791e3          	bne	a5,s2,908 <main+0x52>
     92a:	0014c703          	lbu	a4,1(s1)
     92e:	06400793          	li	a5,100
     932:	fcf71be3          	bne	a4,a5,908 <main+0x52>
     936:	0024c783          	lbu	a5,2(s1)
     93a:	fd3797e3          	bne	a5,s3,908 <main+0x52>
      buf[strlen(buf)-1] = 0;  // chop \n
     93e:	8526                	mv	a0,s1
     940:	098000ef          	jal	ra,9d8 <strlen>
     944:	fff5079b          	addiw	a5,a0,-1
     948:	1782                	slli	a5,a5,0x20
     94a:	9381                	srli	a5,a5,0x20
     94c:	97a6                	add	a5,a5,s1
     94e:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     952:	8552                	mv	a0,s4
     954:	306000ef          	jal	ra,c5a <chdir>
     958:	fa055ee3          	bgez	a0,914 <main+0x5e>
        fprintf(2, "cannot cd %s\n", buf+3);
     95c:	8652                	mv	a2,s4
     95e:	85d6                	mv	a1,s5
     960:	4509                	li	a0,2
     962:	668000ef          	jal	ra,fca <fprintf>
     966:	b77d                	j	914 <main+0x5e>
      runcmd(parsecmd(buf));
     968:	00001517          	auipc	a0,0x1
     96c:	6b850513          	addi	a0,a0,1720 # 2020 <buf.0>
     970:	ed7ff0ef          	jal	ra,846 <parsecmd>
     974:	f1aff0ef          	jal	ra,8e <runcmd>
  exit(0);
     978:	4501                	li	a0,0
     97a:	270000ef          	jal	ra,bea <exit>

000000000000097e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     97e:	1141                	addi	sp,sp,-16
     980:	e406                	sd	ra,8(sp)
     982:	e022                	sd	s0,0(sp)
     984:	0800                	addi	s0,sp,16
  extern int main();
  main();
     986:	f31ff0ef          	jal	ra,8b6 <main>
  exit(0);
     98a:	4501                	li	a0,0
     98c:	25e000ef          	jal	ra,bea <exit>

0000000000000990 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     990:	1141                	addi	sp,sp,-16
     992:	e422                	sd	s0,8(sp)
     994:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     996:	87aa                	mv	a5,a0
     998:	0585                	addi	a1,a1,1
     99a:	0785                	addi	a5,a5,1
     99c:	fff5c703          	lbu	a4,-1(a1)
     9a0:	fee78fa3          	sb	a4,-1(a5)
     9a4:	fb75                	bnez	a4,998 <strcpy+0x8>
    ;
  return os;
}
     9a6:	6422                	ld	s0,8(sp)
     9a8:	0141                	addi	sp,sp,16
     9aa:	8082                	ret

00000000000009ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9ac:	1141                	addi	sp,sp,-16
     9ae:	e422                	sd	s0,8(sp)
     9b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9b2:	00054783          	lbu	a5,0(a0)
     9b6:	cb91                	beqz	a5,9ca <strcmp+0x1e>
     9b8:	0005c703          	lbu	a4,0(a1)
     9bc:	00f71763          	bne	a4,a5,9ca <strcmp+0x1e>
    p++, q++;
     9c0:	0505                	addi	a0,a0,1
     9c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9c4:	00054783          	lbu	a5,0(a0)
     9c8:	fbe5                	bnez	a5,9b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9ca:	0005c503          	lbu	a0,0(a1)
}
     9ce:	40a7853b          	subw	a0,a5,a0
     9d2:	6422                	ld	s0,8(sp)
     9d4:	0141                	addi	sp,sp,16
     9d6:	8082                	ret

00000000000009d8 <strlen>:

uint
strlen(const char *s)
{
     9d8:	1141                	addi	sp,sp,-16
     9da:	e422                	sd	s0,8(sp)
     9dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9de:	00054783          	lbu	a5,0(a0)
     9e2:	cf91                	beqz	a5,9fe <strlen+0x26>
     9e4:	0505                	addi	a0,a0,1
     9e6:	87aa                	mv	a5,a0
     9e8:	4685                	li	a3,1
     9ea:	9e89                	subw	a3,a3,a0
     9ec:	00f6853b          	addw	a0,a3,a5
     9f0:	0785                	addi	a5,a5,1
     9f2:	fff7c703          	lbu	a4,-1(a5)
     9f6:	fb7d                	bnez	a4,9ec <strlen+0x14>
    ;
  return n;
}
     9f8:	6422                	ld	s0,8(sp)
     9fa:	0141                	addi	sp,sp,16
     9fc:	8082                	ret
  for(n = 0; s[n]; n++)
     9fe:	4501                	li	a0,0
     a00:	bfe5                	j	9f8 <strlen+0x20>

0000000000000a02 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a02:	1141                	addi	sp,sp,-16
     a04:	e422                	sd	s0,8(sp)
     a06:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a08:	ca19                	beqz	a2,a1e <memset+0x1c>
     a0a:	87aa                	mv	a5,a0
     a0c:	1602                	slli	a2,a2,0x20
     a0e:	9201                	srli	a2,a2,0x20
     a10:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a14:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a18:	0785                	addi	a5,a5,1
     a1a:	fee79de3          	bne	a5,a4,a14 <memset+0x12>
  }
  return dst;
}
     a1e:	6422                	ld	s0,8(sp)
     a20:	0141                	addi	sp,sp,16
     a22:	8082                	ret

0000000000000a24 <strchr>:

char*
strchr(const char *s, char c)
{
     a24:	1141                	addi	sp,sp,-16
     a26:	e422                	sd	s0,8(sp)
     a28:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a2a:	00054783          	lbu	a5,0(a0)
     a2e:	cb99                	beqz	a5,a44 <strchr+0x20>
    if(*s == c)
     a30:	00f58763          	beq	a1,a5,a3e <strchr+0x1a>
  for(; *s; s++)
     a34:	0505                	addi	a0,a0,1
     a36:	00054783          	lbu	a5,0(a0)
     a3a:	fbfd                	bnez	a5,a30 <strchr+0xc>
      return (char*)s;
  return 0;
     a3c:	4501                	li	a0,0
}
     a3e:	6422                	ld	s0,8(sp)
     a40:	0141                	addi	sp,sp,16
     a42:	8082                	ret
  return 0;
     a44:	4501                	li	a0,0
     a46:	bfe5                	j	a3e <strchr+0x1a>

0000000000000a48 <gets>:

char*
gets(char *buf, int max)
{
     a48:	711d                	addi	sp,sp,-96
     a4a:	ec86                	sd	ra,88(sp)
     a4c:	e8a2                	sd	s0,80(sp)
     a4e:	e4a6                	sd	s1,72(sp)
     a50:	e0ca                	sd	s2,64(sp)
     a52:	fc4e                	sd	s3,56(sp)
     a54:	f852                	sd	s4,48(sp)
     a56:	f456                	sd	s5,40(sp)
     a58:	f05a                	sd	s6,32(sp)
     a5a:	ec5e                	sd	s7,24(sp)
     a5c:	1080                	addi	s0,sp,96
     a5e:	8baa                	mv	s7,a0
     a60:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a62:	892a                	mv	s2,a0
     a64:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a66:	4aa9                	li	s5,10
     a68:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a6a:	89a6                	mv	s3,s1
     a6c:	2485                	addiw	s1,s1,1
     a6e:	0344d663          	bge	s1,s4,a9a <gets+0x52>
    cc = read(0, &c, 1);
     a72:	4605                	li	a2,1
     a74:	faf40593          	addi	a1,s0,-81
     a78:	4501                	li	a0,0
     a7a:	188000ef          	jal	ra,c02 <read>
    if(cc < 1)
     a7e:	00a05e63          	blez	a0,a9a <gets+0x52>
    buf[i++] = c;
     a82:	faf44783          	lbu	a5,-81(s0)
     a86:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a8a:	01578763          	beq	a5,s5,a98 <gets+0x50>
     a8e:	0905                	addi	s2,s2,1
     a90:	fd679de3          	bne	a5,s6,a6a <gets+0x22>
  for(i=0; i+1 < max; ){
     a94:	89a6                	mv	s3,s1
     a96:	a011                	j	a9a <gets+0x52>
     a98:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a9a:	99de                	add	s3,s3,s7
     a9c:	00098023          	sb	zero,0(s3)
  return buf;
}
     aa0:	855e                	mv	a0,s7
     aa2:	60e6                	ld	ra,88(sp)
     aa4:	6446                	ld	s0,80(sp)
     aa6:	64a6                	ld	s1,72(sp)
     aa8:	6906                	ld	s2,64(sp)
     aaa:	79e2                	ld	s3,56(sp)
     aac:	7a42                	ld	s4,48(sp)
     aae:	7aa2                	ld	s5,40(sp)
     ab0:	7b02                	ld	s6,32(sp)
     ab2:	6be2                	ld	s7,24(sp)
     ab4:	6125                	addi	sp,sp,96
     ab6:	8082                	ret

0000000000000ab8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ab8:	1101                	addi	sp,sp,-32
     aba:	ec06                	sd	ra,24(sp)
     abc:	e822                	sd	s0,16(sp)
     abe:	e426                	sd	s1,8(sp)
     ac0:	e04a                	sd	s2,0(sp)
     ac2:	1000                	addi	s0,sp,32
     ac4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ac6:	4581                	li	a1,0
     ac8:	162000ef          	jal	ra,c2a <open>
  if(fd < 0)
     acc:	02054163          	bltz	a0,aee <stat+0x36>
     ad0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ad2:	85ca                	mv	a1,s2
     ad4:	16e000ef          	jal	ra,c42 <fstat>
     ad8:	892a                	mv	s2,a0
  close(fd);
     ada:	8526                	mv	a0,s1
     adc:	136000ef          	jal	ra,c12 <close>
  return r;
}
     ae0:	854a                	mv	a0,s2
     ae2:	60e2                	ld	ra,24(sp)
     ae4:	6442                	ld	s0,16(sp)
     ae6:	64a2                	ld	s1,8(sp)
     ae8:	6902                	ld	s2,0(sp)
     aea:	6105                	addi	sp,sp,32
     aec:	8082                	ret
    return -1;
     aee:	597d                	li	s2,-1
     af0:	bfc5                	j	ae0 <stat+0x28>

0000000000000af2 <atoi>:

int
atoi(const char *s)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e422                	sd	s0,8(sp)
     af6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     af8:	00054603          	lbu	a2,0(a0)
     afc:	fd06079b          	addiw	a5,a2,-48
     b00:	0ff7f793          	andi	a5,a5,255
     b04:	4725                	li	a4,9
     b06:	02f76963          	bltu	a4,a5,b38 <atoi+0x46>
     b0a:	86aa                	mv	a3,a0
  n = 0;
     b0c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     b0e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     b10:	0685                	addi	a3,a3,1
     b12:	0025179b          	slliw	a5,a0,0x2
     b16:	9fa9                	addw	a5,a5,a0
     b18:	0017979b          	slliw	a5,a5,0x1
     b1c:	9fb1                	addw	a5,a5,a2
     b1e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b22:	0006c603          	lbu	a2,0(a3)
     b26:	fd06071b          	addiw	a4,a2,-48
     b2a:	0ff77713          	andi	a4,a4,255
     b2e:	fee5f1e3          	bgeu	a1,a4,b10 <atoi+0x1e>
  return n;
}
     b32:	6422                	ld	s0,8(sp)
     b34:	0141                	addi	sp,sp,16
     b36:	8082                	ret
  n = 0;
     b38:	4501                	li	a0,0
     b3a:	bfe5                	j	b32 <atoi+0x40>

0000000000000b3c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b3c:	1141                	addi	sp,sp,-16
     b3e:	e422                	sd	s0,8(sp)
     b40:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b42:	02b57463          	bgeu	a0,a1,b6a <memmove+0x2e>
    while(n-- > 0)
     b46:	00c05f63          	blez	a2,b64 <memmove+0x28>
     b4a:	1602                	slli	a2,a2,0x20
     b4c:	9201                	srli	a2,a2,0x20
     b4e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b52:	872a                	mv	a4,a0
      *dst++ = *src++;
     b54:	0585                	addi	a1,a1,1
     b56:	0705                	addi	a4,a4,1
     b58:	fff5c683          	lbu	a3,-1(a1)
     b5c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b60:	fee79ae3          	bne	a5,a4,b54 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b64:	6422                	ld	s0,8(sp)
     b66:	0141                	addi	sp,sp,16
     b68:	8082                	ret
    dst += n;
     b6a:	00c50733          	add	a4,a0,a2
    src += n;
     b6e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b70:	fec05ae3          	blez	a2,b64 <memmove+0x28>
     b74:	fff6079b          	addiw	a5,a2,-1
     b78:	1782                	slli	a5,a5,0x20
     b7a:	9381                	srli	a5,a5,0x20
     b7c:	fff7c793          	not	a5,a5
     b80:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b82:	15fd                	addi	a1,a1,-1
     b84:	177d                	addi	a4,a4,-1
     b86:	0005c683          	lbu	a3,0(a1)
     b8a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b8e:	fee79ae3          	bne	a5,a4,b82 <memmove+0x46>
     b92:	bfc9                	j	b64 <memmove+0x28>

0000000000000b94 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b94:	1141                	addi	sp,sp,-16
     b96:	e422                	sd	s0,8(sp)
     b98:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b9a:	ca05                	beqz	a2,bca <memcmp+0x36>
     b9c:	fff6069b          	addiw	a3,a2,-1
     ba0:	1682                	slli	a3,a3,0x20
     ba2:	9281                	srli	a3,a3,0x20
     ba4:	0685                	addi	a3,a3,1
     ba6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ba8:	00054783          	lbu	a5,0(a0)
     bac:	0005c703          	lbu	a4,0(a1)
     bb0:	00e79863          	bne	a5,a4,bc0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bb4:	0505                	addi	a0,a0,1
    p2++;
     bb6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bb8:	fed518e3          	bne	a0,a3,ba8 <memcmp+0x14>
  }
  return 0;
     bbc:	4501                	li	a0,0
     bbe:	a019                	j	bc4 <memcmp+0x30>
      return *p1 - *p2;
     bc0:	40e7853b          	subw	a0,a5,a4
}
     bc4:	6422                	ld	s0,8(sp)
     bc6:	0141                	addi	sp,sp,16
     bc8:	8082                	ret
  return 0;
     bca:	4501                	li	a0,0
     bcc:	bfe5                	j	bc4 <memcmp+0x30>

0000000000000bce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bce:	1141                	addi	sp,sp,-16
     bd0:	e406                	sd	ra,8(sp)
     bd2:	e022                	sd	s0,0(sp)
     bd4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bd6:	f67ff0ef          	jal	ra,b3c <memmove>
}
     bda:	60a2                	ld	ra,8(sp)
     bdc:	6402                	ld	s0,0(sp)
     bde:	0141                	addi	sp,sp,16
     be0:	8082                	ret

0000000000000be2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     be2:	4885                	li	a7,1
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <exit>:
.global exit
exit:
 li a7, SYS_exit
     bea:	4889                	li	a7,2
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bf2:	488d                	li	a7,3
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bfa:	4891                	li	a7,4
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <read>:
.global read
read:
 li a7, SYS_read
     c02:	4895                	li	a7,5
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <write>:
.global write
write:
 li a7, SYS_write
     c0a:	48c1                	li	a7,16
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <close>:
.global close
close:
 li a7, SYS_close
     c12:	48d5                	li	a7,21
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <kill>:
.global kill
kill:
 li a7, SYS_kill
     c1a:	4899                	li	a7,6
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c22:	489d                	li	a7,7
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <open>:
.global open
open:
 li a7, SYS_open
     c2a:	48bd                	li	a7,15
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c32:	48c5                	li	a7,17
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c3a:	48c9                	li	a7,18
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c42:	48a1                	li	a7,8
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <link>:
.global link
link:
 li a7, SYS_link
     c4a:	48cd                	li	a7,19
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c52:	48d1                	li	a7,20
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c5a:	48a5                	li	a7,9
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c62:	48a9                	li	a7,10
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c6a:	48ad                	li	a7,11
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c72:	48b1                	li	a7,12
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c7a:	48b5                	li	a7,13
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c82:	48b9                	li	a7,14
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c8a:	1101                	addi	sp,sp,-32
     c8c:	ec06                	sd	ra,24(sp)
     c8e:	e822                	sd	s0,16(sp)
     c90:	1000                	addi	s0,sp,32
     c92:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c96:	4605                	li	a2,1
     c98:	fef40593          	addi	a1,s0,-17
     c9c:	f6fff0ef          	jal	ra,c0a <write>
}
     ca0:	60e2                	ld	ra,24(sp)
     ca2:	6442                	ld	s0,16(sp)
     ca4:	6105                	addi	sp,sp,32
     ca6:	8082                	ret

0000000000000ca8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ca8:	7139                	addi	sp,sp,-64
     caa:	fc06                	sd	ra,56(sp)
     cac:	f822                	sd	s0,48(sp)
     cae:	f426                	sd	s1,40(sp)
     cb0:	f04a                	sd	s2,32(sp)
     cb2:	ec4e                	sd	s3,24(sp)
     cb4:	0080                	addi	s0,sp,64
     cb6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cb8:	c299                	beqz	a3,cbe <printint+0x16>
     cba:	0805c663          	bltz	a1,d46 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cbe:	2581                	sext.w	a1,a1
  neg = 0;
     cc0:	4881                	li	a7,0
     cc2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     cc6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cc8:	2601                	sext.w	a2,a2
     cca:	00000517          	auipc	a0,0x0
     cce:	60e50513          	addi	a0,a0,1550 # 12d8 <digits>
     cd2:	883a                	mv	a6,a4
     cd4:	2705                	addiw	a4,a4,1
     cd6:	02c5f7bb          	remuw	a5,a1,a2
     cda:	1782                	slli	a5,a5,0x20
     cdc:	9381                	srli	a5,a5,0x20
     cde:	97aa                	add	a5,a5,a0
     ce0:	0007c783          	lbu	a5,0(a5)
     ce4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ce8:	0005879b          	sext.w	a5,a1
     cec:	02c5d5bb          	divuw	a1,a1,a2
     cf0:	0685                	addi	a3,a3,1
     cf2:	fec7f0e3          	bgeu	a5,a2,cd2 <printint+0x2a>
  if(neg)
     cf6:	00088b63          	beqz	a7,d0c <printint+0x64>
    buf[i++] = '-';
     cfa:	fd040793          	addi	a5,s0,-48
     cfe:	973e                	add	a4,a4,a5
     d00:	02d00793          	li	a5,45
     d04:	fef70823          	sb	a5,-16(a4)
     d08:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d0c:	02e05663          	blez	a4,d38 <printint+0x90>
     d10:	fc040793          	addi	a5,s0,-64
     d14:	00e78933          	add	s2,a5,a4
     d18:	fff78993          	addi	s3,a5,-1
     d1c:	99ba                	add	s3,s3,a4
     d1e:	377d                	addiw	a4,a4,-1
     d20:	1702                	slli	a4,a4,0x20
     d22:	9301                	srli	a4,a4,0x20
     d24:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d28:	fff94583          	lbu	a1,-1(s2)
     d2c:	8526                	mv	a0,s1
     d2e:	f5dff0ef          	jal	ra,c8a <putc>
  while(--i >= 0)
     d32:	197d                	addi	s2,s2,-1
     d34:	ff391ae3          	bne	s2,s3,d28 <printint+0x80>
}
     d38:	70e2                	ld	ra,56(sp)
     d3a:	7442                	ld	s0,48(sp)
     d3c:	74a2                	ld	s1,40(sp)
     d3e:	7902                	ld	s2,32(sp)
     d40:	69e2                	ld	s3,24(sp)
     d42:	6121                	addi	sp,sp,64
     d44:	8082                	ret
    x = -xx;
     d46:	40b005bb          	negw	a1,a1
    neg = 1;
     d4a:	4885                	li	a7,1
    x = -xx;
     d4c:	bf9d                	j	cc2 <printint+0x1a>

0000000000000d4e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d4e:	7119                	addi	sp,sp,-128
     d50:	fc86                	sd	ra,120(sp)
     d52:	f8a2                	sd	s0,112(sp)
     d54:	f4a6                	sd	s1,104(sp)
     d56:	f0ca                	sd	s2,96(sp)
     d58:	ecce                	sd	s3,88(sp)
     d5a:	e8d2                	sd	s4,80(sp)
     d5c:	e4d6                	sd	s5,72(sp)
     d5e:	e0da                	sd	s6,64(sp)
     d60:	fc5e                	sd	s7,56(sp)
     d62:	f862                	sd	s8,48(sp)
     d64:	f466                	sd	s9,40(sp)
     d66:	f06a                	sd	s10,32(sp)
     d68:	ec6e                	sd	s11,24(sp)
     d6a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d6c:	0005c903          	lbu	s2,0(a1)
     d70:	22090e63          	beqz	s2,fac <vprintf+0x25e>
     d74:	8b2a                	mv	s6,a0
     d76:	8a2e                	mv	s4,a1
     d78:	8bb2                	mv	s7,a2
  state = 0;
     d7a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d7c:	4481                	li	s1,0
     d7e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d80:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d84:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d88:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d8c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d90:	00000c97          	auipc	s9,0x0
     d94:	548c8c93          	addi	s9,s9,1352 # 12d8 <digits>
     d98:	a005                	j	db8 <vprintf+0x6a>
        putc(fd, c0);
     d9a:	85ca                	mv	a1,s2
     d9c:	855a                	mv	a0,s6
     d9e:	eedff0ef          	jal	ra,c8a <putc>
     da2:	a019                	j	da8 <vprintf+0x5a>
    } else if(state == '%'){
     da4:	03598263          	beq	s3,s5,dc8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     da8:	2485                	addiw	s1,s1,1
     daa:	8726                	mv	a4,s1
     dac:	009a07b3          	add	a5,s4,s1
     db0:	0007c903          	lbu	s2,0(a5)
     db4:	1e090c63          	beqz	s2,fac <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
     db8:	0009079b          	sext.w	a5,s2
    if(state == 0){
     dbc:	fe0994e3          	bnez	s3,da4 <vprintf+0x56>
      if(c0 == '%'){
     dc0:	fd579de3          	bne	a5,s5,d9a <vprintf+0x4c>
        state = '%';
     dc4:	89be                	mv	s3,a5
     dc6:	b7cd                	j	da8 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     dc8:	cfa5                	beqz	a5,e40 <vprintf+0xf2>
     dca:	00ea06b3          	add	a3,s4,a4
     dce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dd2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     dd4:	c681                	beqz	a3,ddc <vprintf+0x8e>
     dd6:	9752                	add	a4,a4,s4
     dd8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     ddc:	03878a63          	beq	a5,s8,e10 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     de0:	05a78463          	beq	a5,s10,e28 <vprintf+0xda>
      } else if(c0 == 'u'){
     de4:	0db78763          	beq	a5,s11,eb2 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     de8:	07800713          	li	a4,120
     dec:	10e78963          	beq	a5,a4,efe <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     df0:	07000713          	li	a4,112
     df4:	12e78e63          	beq	a5,a4,f30 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     df8:	07300713          	li	a4,115
     dfc:	16e78b63          	beq	a5,a4,f72 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e00:	05579063          	bne	a5,s5,e40 <vprintf+0xf2>
        putc(fd, '%');
     e04:	85d6                	mv	a1,s5
     e06:	855a                	mv	a0,s6
     e08:	e83ff0ef          	jal	ra,c8a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e0c:	4981                	li	s3,0
     e0e:	bf69                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     e10:	008b8913          	addi	s2,s7,8
     e14:	4685                	li	a3,1
     e16:	4629                	li	a2,10
     e18:	000ba583          	lw	a1,0(s7)
     e1c:	855a                	mv	a0,s6
     e1e:	e8bff0ef          	jal	ra,ca8 <printint>
     e22:	8bca                	mv	s7,s2
      state = 0;
     e24:	4981                	li	s3,0
     e26:	b749                	j	da8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e28:	03868663          	beq	a3,s8,e54 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e2c:	05a68163          	beq	a3,s10,e6e <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
     e30:	09b68d63          	beq	a3,s11,eca <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e34:	03a68f63          	beq	a3,s10,e72 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
     e38:	07800793          	li	a5,120
     e3c:	0cf68d63          	beq	a3,a5,f16 <vprintf+0x1c8>
        putc(fd, '%');
     e40:	85d6                	mv	a1,s5
     e42:	855a                	mv	a0,s6
     e44:	e47ff0ef          	jal	ra,c8a <putc>
        putc(fd, c0);
     e48:	85ca                	mv	a1,s2
     e4a:	855a                	mv	a0,s6
     e4c:	e3fff0ef          	jal	ra,c8a <putc>
      state = 0;
     e50:	4981                	li	s3,0
     e52:	bf99                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e54:	008b8913          	addi	s2,s7,8
     e58:	4685                	li	a3,1
     e5a:	4629                	li	a2,10
     e5c:	000ba583          	lw	a1,0(s7)
     e60:	855a                	mv	a0,s6
     e62:	e47ff0ef          	jal	ra,ca8 <printint>
        i += 1;
     e66:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e68:	8bca                	mv	s7,s2
      state = 0;
     e6a:	4981                	li	s3,0
        i += 1;
     e6c:	bf35                	j	da8 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e6e:	03860563          	beq	a2,s8,e98 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e72:	07b60963          	beq	a2,s11,ee4 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e76:	07800793          	li	a5,120
     e7a:	fcf613e3          	bne	a2,a5,e40 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e7e:	008b8913          	addi	s2,s7,8
     e82:	4681                	li	a3,0
     e84:	4641                	li	a2,16
     e86:	000ba583          	lw	a1,0(s7)
     e8a:	855a                	mv	a0,s6
     e8c:	e1dff0ef          	jal	ra,ca8 <printint>
        i += 2;
     e90:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e92:	8bca                	mv	s7,s2
      state = 0;
     e94:	4981                	li	s3,0
        i += 2;
     e96:	bf09                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e98:	008b8913          	addi	s2,s7,8
     e9c:	4685                	li	a3,1
     e9e:	4629                	li	a2,10
     ea0:	000ba583          	lw	a1,0(s7)
     ea4:	855a                	mv	a0,s6
     ea6:	e03ff0ef          	jal	ra,ca8 <printint>
        i += 2;
     eaa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     eac:	8bca                	mv	s7,s2
      state = 0;
     eae:	4981                	li	s3,0
        i += 2;
     eb0:	bde5                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
     eb2:	008b8913          	addi	s2,s7,8
     eb6:	4681                	li	a3,0
     eb8:	4629                	li	a2,10
     eba:	000ba583          	lw	a1,0(s7)
     ebe:	855a                	mv	a0,s6
     ec0:	de9ff0ef          	jal	ra,ca8 <printint>
     ec4:	8bca                	mv	s7,s2
      state = 0;
     ec6:	4981                	li	s3,0
     ec8:	b5c5                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eca:	008b8913          	addi	s2,s7,8
     ece:	4681                	li	a3,0
     ed0:	4629                	li	a2,10
     ed2:	000ba583          	lw	a1,0(s7)
     ed6:	855a                	mv	a0,s6
     ed8:	dd1ff0ef          	jal	ra,ca8 <printint>
        i += 1;
     edc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ede:	8bca                	mv	s7,s2
      state = 0;
     ee0:	4981                	li	s3,0
        i += 1;
     ee2:	b5d9                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee4:	008b8913          	addi	s2,s7,8
     ee8:	4681                	li	a3,0
     eea:	4629                	li	a2,10
     eec:	000ba583          	lw	a1,0(s7)
     ef0:	855a                	mv	a0,s6
     ef2:	db7ff0ef          	jal	ra,ca8 <printint>
        i += 2;
     ef6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ef8:	8bca                	mv	s7,s2
      state = 0;
     efa:	4981                	li	s3,0
        i += 2;
     efc:	b575                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
     efe:	008b8913          	addi	s2,s7,8
     f02:	4681                	li	a3,0
     f04:	4641                	li	a2,16
     f06:	000ba583          	lw	a1,0(s7)
     f0a:	855a                	mv	a0,s6
     f0c:	d9dff0ef          	jal	ra,ca8 <printint>
     f10:	8bca                	mv	s7,s2
      state = 0;
     f12:	4981                	li	s3,0
     f14:	bd51                	j	da8 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f16:	008b8913          	addi	s2,s7,8
     f1a:	4681                	li	a3,0
     f1c:	4641                	li	a2,16
     f1e:	000ba583          	lw	a1,0(s7)
     f22:	855a                	mv	a0,s6
     f24:	d85ff0ef          	jal	ra,ca8 <printint>
        i += 1;
     f28:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f2a:	8bca                	mv	s7,s2
      state = 0;
     f2c:	4981                	li	s3,0
        i += 1;
     f2e:	bdad                	j	da8 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f30:	008b8793          	addi	a5,s7,8
     f34:	f8f43423          	sd	a5,-120(s0)
     f38:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f3c:	03000593          	li	a1,48
     f40:	855a                	mv	a0,s6
     f42:	d49ff0ef          	jal	ra,c8a <putc>
  putc(fd, 'x');
     f46:	07800593          	li	a1,120
     f4a:	855a                	mv	a0,s6
     f4c:	d3fff0ef          	jal	ra,c8a <putc>
     f50:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f52:	03c9d793          	srli	a5,s3,0x3c
     f56:	97e6                	add	a5,a5,s9
     f58:	0007c583          	lbu	a1,0(a5)
     f5c:	855a                	mv	a0,s6
     f5e:	d2dff0ef          	jal	ra,c8a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f62:	0992                	slli	s3,s3,0x4
     f64:	397d                	addiw	s2,s2,-1
     f66:	fe0916e3          	bnez	s2,f52 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
     f6a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     f6e:	4981                	li	s3,0
     f70:	bd25                	j	da8 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     f72:	008b8993          	addi	s3,s7,8
     f76:	000bb903          	ld	s2,0(s7)
     f7a:	00090f63          	beqz	s2,f98 <vprintf+0x24a>
        for(; *s; s++)
     f7e:	00094583          	lbu	a1,0(s2)
     f82:	c195                	beqz	a1,fa6 <vprintf+0x258>
          putc(fd, *s);
     f84:	855a                	mv	a0,s6
     f86:	d05ff0ef          	jal	ra,c8a <putc>
        for(; *s; s++)
     f8a:	0905                	addi	s2,s2,1
     f8c:	00094583          	lbu	a1,0(s2)
     f90:	f9f5                	bnez	a1,f84 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     f92:	8bce                	mv	s7,s3
      state = 0;
     f94:	4981                	li	s3,0
     f96:	bd09                	j	da8 <vprintf+0x5a>
          s = "(null)";
     f98:	00000917          	auipc	s2,0x0
     f9c:	33890913          	addi	s2,s2,824 # 12d0 <malloc+0x222>
        for(; *s; s++)
     fa0:	02800593          	li	a1,40
     fa4:	b7c5                	j	f84 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     fa6:	8bce                	mv	s7,s3
      state = 0;
     fa8:	4981                	li	s3,0
     faa:	bbfd                	j	da8 <vprintf+0x5a>
    }
  }
}
     fac:	70e6                	ld	ra,120(sp)
     fae:	7446                	ld	s0,112(sp)
     fb0:	74a6                	ld	s1,104(sp)
     fb2:	7906                	ld	s2,96(sp)
     fb4:	69e6                	ld	s3,88(sp)
     fb6:	6a46                	ld	s4,80(sp)
     fb8:	6aa6                	ld	s5,72(sp)
     fba:	6b06                	ld	s6,64(sp)
     fbc:	7be2                	ld	s7,56(sp)
     fbe:	7c42                	ld	s8,48(sp)
     fc0:	7ca2                	ld	s9,40(sp)
     fc2:	7d02                	ld	s10,32(sp)
     fc4:	6de2                	ld	s11,24(sp)
     fc6:	6109                	addi	sp,sp,128
     fc8:	8082                	ret

0000000000000fca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fca:	715d                	addi	sp,sp,-80
     fcc:	ec06                	sd	ra,24(sp)
     fce:	e822                	sd	s0,16(sp)
     fd0:	1000                	addi	s0,sp,32
     fd2:	e010                	sd	a2,0(s0)
     fd4:	e414                	sd	a3,8(s0)
     fd6:	e818                	sd	a4,16(s0)
     fd8:	ec1c                	sd	a5,24(s0)
     fda:	03043023          	sd	a6,32(s0)
     fde:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fe2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fe6:	8622                	mv	a2,s0
     fe8:	d67ff0ef          	jal	ra,d4e <vprintf>
}
     fec:	60e2                	ld	ra,24(sp)
     fee:	6442                	ld	s0,16(sp)
     ff0:	6161                	addi	sp,sp,80
     ff2:	8082                	ret

0000000000000ff4 <printf>:

void
printf(const char *fmt, ...)
{
     ff4:	711d                	addi	sp,sp,-96
     ff6:	ec06                	sd	ra,24(sp)
     ff8:	e822                	sd	s0,16(sp)
     ffa:	1000                	addi	s0,sp,32
     ffc:	e40c                	sd	a1,8(s0)
     ffe:	e810                	sd	a2,16(s0)
    1000:	ec14                	sd	a3,24(s0)
    1002:	f018                	sd	a4,32(s0)
    1004:	f41c                	sd	a5,40(s0)
    1006:	03043823          	sd	a6,48(s0)
    100a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    100e:	00840613          	addi	a2,s0,8
    1012:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1016:	85aa                	mv	a1,a0
    1018:	4505                	li	a0,1
    101a:	d35ff0ef          	jal	ra,d4e <vprintf>
}
    101e:	60e2                	ld	ra,24(sp)
    1020:	6442                	ld	s0,16(sp)
    1022:	6125                	addi	sp,sp,96
    1024:	8082                	ret

0000000000001026 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1026:	1141                	addi	sp,sp,-16
    1028:	e422                	sd	s0,8(sp)
    102a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    102c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1030:	00001797          	auipc	a5,0x1
    1034:	fe07b783          	ld	a5,-32(a5) # 2010 <freep>
    1038:	a805                	j	1068 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    103a:	4618                	lw	a4,8(a2)
    103c:	9db9                	addw	a1,a1,a4
    103e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1042:	6398                	ld	a4,0(a5)
    1044:	6318                	ld	a4,0(a4)
    1046:	fee53823          	sd	a4,-16(a0)
    104a:	a091                	j	108e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    104c:	ff852703          	lw	a4,-8(a0)
    1050:	9e39                	addw	a2,a2,a4
    1052:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1054:	ff053703          	ld	a4,-16(a0)
    1058:	e398                	sd	a4,0(a5)
    105a:	a099                	j	10a0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    105c:	6398                	ld	a4,0(a5)
    105e:	00e7e463          	bltu	a5,a4,1066 <free+0x40>
    1062:	00e6ea63          	bltu	a3,a4,1076 <free+0x50>
{
    1066:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1068:	fed7fae3          	bgeu	a5,a3,105c <free+0x36>
    106c:	6398                	ld	a4,0(a5)
    106e:	00e6e463          	bltu	a3,a4,1076 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1072:	fee7eae3          	bltu	a5,a4,1066 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1076:	ff852583          	lw	a1,-8(a0)
    107a:	6390                	ld	a2,0(a5)
    107c:	02059713          	slli	a4,a1,0x20
    1080:	9301                	srli	a4,a4,0x20
    1082:	0712                	slli	a4,a4,0x4
    1084:	9736                	add	a4,a4,a3
    1086:	fae60ae3          	beq	a2,a4,103a <free+0x14>
    bp->s.ptr = p->s.ptr;
    108a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    108e:	4790                	lw	a2,8(a5)
    1090:	02061713          	slli	a4,a2,0x20
    1094:	9301                	srli	a4,a4,0x20
    1096:	0712                	slli	a4,a4,0x4
    1098:	973e                	add	a4,a4,a5
    109a:	fae689e3          	beq	a3,a4,104c <free+0x26>
  } else
    p->s.ptr = bp;
    109e:	e394                	sd	a3,0(a5)
  freep = p;
    10a0:	00001717          	auipc	a4,0x1
    10a4:	f6f73823          	sd	a5,-144(a4) # 2010 <freep>
}
    10a8:	6422                	ld	s0,8(sp)
    10aa:	0141                	addi	sp,sp,16
    10ac:	8082                	ret

00000000000010ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10ae:	7139                	addi	sp,sp,-64
    10b0:	fc06                	sd	ra,56(sp)
    10b2:	f822                	sd	s0,48(sp)
    10b4:	f426                	sd	s1,40(sp)
    10b6:	f04a                	sd	s2,32(sp)
    10b8:	ec4e                	sd	s3,24(sp)
    10ba:	e852                	sd	s4,16(sp)
    10bc:	e456                	sd	s5,8(sp)
    10be:	e05a                	sd	s6,0(sp)
    10c0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10c2:	02051493          	slli	s1,a0,0x20
    10c6:	9081                	srli	s1,s1,0x20
    10c8:	04bd                	addi	s1,s1,15
    10ca:	8091                	srli	s1,s1,0x4
    10cc:	0014899b          	addiw	s3,s1,1
    10d0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10d2:	00001517          	auipc	a0,0x1
    10d6:	f3e53503          	ld	a0,-194(a0) # 2010 <freep>
    10da:	c515                	beqz	a0,1106 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10de:	4798                	lw	a4,8(a5)
    10e0:	02977f63          	bgeu	a4,s1,111e <malloc+0x70>
    10e4:	8a4e                	mv	s4,s3
    10e6:	0009871b          	sext.w	a4,s3
    10ea:	6685                	lui	a3,0x1
    10ec:	00d77363          	bgeu	a4,a3,10f2 <malloc+0x44>
    10f0:	6a05                	lui	s4,0x1
    10f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10fa:	00001917          	auipc	s2,0x1
    10fe:	f1690913          	addi	s2,s2,-234 # 2010 <freep>
  if(p == (char*)-1)
    1102:	5afd                	li	s5,-1
    1104:	a0bd                	j	1172 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    1106:	00001797          	auipc	a5,0x1
    110a:	f8278793          	addi	a5,a5,-126 # 2088 <base>
    110e:	00001717          	auipc	a4,0x1
    1112:	f0f73123          	sd	a5,-254(a4) # 2010 <freep>
    1116:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1118:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    111c:	b7e1                	j	10e4 <malloc+0x36>
      if(p->s.size == nunits)
    111e:	02e48b63          	beq	s1,a4,1154 <malloc+0xa6>
        p->s.size -= nunits;
    1122:	4137073b          	subw	a4,a4,s3
    1126:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1128:	1702                	slli	a4,a4,0x20
    112a:	9301                	srli	a4,a4,0x20
    112c:	0712                	slli	a4,a4,0x4
    112e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1130:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1134:	00001717          	auipc	a4,0x1
    1138:	eca73e23          	sd	a0,-292(a4) # 2010 <freep>
      return (void*)(p + 1);
    113c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1140:	70e2                	ld	ra,56(sp)
    1142:	7442                	ld	s0,48(sp)
    1144:	74a2                	ld	s1,40(sp)
    1146:	7902                	ld	s2,32(sp)
    1148:	69e2                	ld	s3,24(sp)
    114a:	6a42                	ld	s4,16(sp)
    114c:	6aa2                	ld	s5,8(sp)
    114e:	6b02                	ld	s6,0(sp)
    1150:	6121                	addi	sp,sp,64
    1152:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1154:	6398                	ld	a4,0(a5)
    1156:	e118                	sd	a4,0(a0)
    1158:	bff1                	j	1134 <malloc+0x86>
  hp->s.size = nu;
    115a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    115e:	0541                	addi	a0,a0,16
    1160:	ec7ff0ef          	jal	ra,1026 <free>
  return freep;
    1164:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1168:	dd61                	beqz	a0,1140 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    116a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    116c:	4798                	lw	a4,8(a5)
    116e:	fa9778e3          	bgeu	a4,s1,111e <malloc+0x70>
    if(p == freep)
    1172:	00093703          	ld	a4,0(s2)
    1176:	853e                	mv	a0,a5
    1178:	fef719e3          	bne	a4,a5,116a <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    117c:	8552                	mv	a0,s4
    117e:	af5ff0ef          	jal	ra,c72 <sbrk>
  if(p == (char*)-1)
    1182:	fd551ce3          	bne	a0,s5,115a <malloc+0xac>
        return 0;
    1186:	4501                	li	a0,0
    1188:	bf65                	j	1140 <malloc+0x92>
