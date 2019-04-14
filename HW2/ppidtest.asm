
_ppidtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid = fork();
   f:	e8 b6 02 00 00       	call   2ca <fork>

  if(pid > 0){
  14:	83 f8 00             	cmp    $0x0,%eax
  17:	7e 32                	jle    4b <main+0x4b>
  19:	89 c3                	mov    %eax,%ebx
    wait();
  1b:	e8 ba 02 00 00       	call   2da <wait>
    printf(1, "Parent says: (child pid is: %d) (my pid is: %d)\n", pid, getpid());
  20:	e8 2d 03 00 00       	call   352 <getpid>
  25:	50                   	push   %eax
  26:	53                   	push   %ebx
  27:	68 40 07 00 00       	push   $0x740
  2c:	6a 01                	push   $0x1
  2e:	e8 ed 03 00 00       	call   420 <printf>
    printf(1, "Parent says: (child %d is done)\n", pid);
  33:	83 c4 0c             	add    $0xc,%esp
  36:	53                   	push   %ebx
  37:	68 74 07 00 00       	push   $0x774
  3c:	6a 01                	push   $0x1
  3e:	e8 dd 03 00 00       	call   420 <printf>
  43:	83 c4 10             	add    $0x10,%esp
    exit();
  } else {
    printf(1, "Fork error\n");
  }
  
  exit();
  46:	e8 87 02 00 00       	call   2d2 <exit>
  } else if(pid == 0){
  4b:	75 26                	jne    73 <main+0x73>
    printf(1, "Child says: (My parent pid is: %d)\n", getppid());
  4d:	e8 20 03 00 00       	call   372 <getppid>
  52:	52                   	push   %edx
  53:	50                   	push   %eax
  54:	68 98 07 00 00       	push   $0x798
  59:	6a 01                	push   $0x1
  5b:	e8 c0 03 00 00       	call   420 <printf>
    printf(1, "Child says: (exiting)\n");
  60:	59                   	pop    %ecx
  61:	5b                   	pop    %ebx
  62:	68 bc 07 00 00       	push   $0x7bc
  67:	6a 01                	push   $0x1
  69:	e8 b2 03 00 00       	call   420 <printf>
    exit();
  6e:	e8 5f 02 00 00       	call   2d2 <exit>
    printf(1, "Fork error\n");
  73:	50                   	push   %eax
  74:	50                   	push   %eax
  75:	68 d3 07 00 00       	push   $0x7d3
  7a:	6a 01                	push   $0x1
  7c:	e8 9f 03 00 00       	call   420 <printf>
  81:	83 c4 10             	add    $0x10,%esp
  84:	eb c0                	jmp    46 <main+0x46>
  86:	66 90                	xchg   %ax,%ax
  88:	66 90                	xchg   %ax,%ax
  8a:	66 90                	xchg   %ax,%ax
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	89 c2                	mov    %eax,%edx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a0:	83 c1 01             	add    $0x1,%ecx
  a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  a7:	83 c2 01             	add    $0x1,%edx
  aa:	84 db                	test   %bl,%bl
  ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  af:	75 ef                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  b1:	5b                   	pop    %ebx
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
  b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	56                   	push   %esi
  c4:	53                   	push   %ebx
  c5:	8b 55 08             	mov    0x8(%ebp),%edx
  c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  cb:	0f b6 02             	movzbl (%edx),%eax
  ce:	0f b6 19             	movzbl (%ecx),%ebx
  d1:	84 c0                	test   %al,%al
  d3:	75 1e                	jne    f3 <strcmp+0x33>
  d5:	eb 29                	jmp    100 <strcmp+0x40>
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  e6:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  e9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  ed:	84 c0                	test   %al,%al
  ef:	74 0f                	je     100 <strcmp+0x40>
  f1:	89 f1                	mov    %esi,%ecx
  f3:	38 d8                	cmp    %bl,%al
  f5:	74 e9                	je     e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  f7:	29 d8                	sub    %ebx,%eax
}
  f9:	5b                   	pop    %ebx
  fa:	5e                   	pop    %esi
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  while(*p && *p == *q)
 100:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 102:	29 d8                	sub    %ebx,%eax
}
 104:	5b                   	pop    %ebx
 105:	5e                   	pop    %esi
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    
 108:	90                   	nop
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 39 00             	cmpb   $0x0,(%ecx)
 119:	74 12                	je     12d <strlen+0x1d>
 11b:	31 d2                	xor    %edx,%edx
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c2 01             	add    $0x1,%edx
 123:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 127:	89 d0                	mov    %edx,%eax
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 12d:	31 c0                	xor    %eax,%eax
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <memset>
 133:	90                   	nop
 134:	90                   	nop
 135:	90                   	nop
 136:	90                   	nop
 137:	90                   	nop
 138:	90                   	nop
 139:	90                   	nop
 13a:	90                   	nop
 13b:	90                   	nop
 13c:	90                   	nop
 13d:	90                   	nop
 13e:	90                   	nop
 13f:	90                   	nop

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	89 d0                	mov    %edx,%eax
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	74 1d                	je     18e <strchr+0x2e>
    if(*s == c)
 171:	38 d3                	cmp    %dl,%bl
 173:	89 d9                	mov    %ebx,%ecx
 175:	75 0d                	jne    184 <strchr+0x24>
 177:	eb 17                	jmp    190 <strchr+0x30>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 180:	38 ca                	cmp    %cl,%dl
 182:	74 0c                	je     190 <strchr+0x30>
  for(; *s; s++)
 184:	83 c0 01             	add    $0x1,%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	84 d2                	test   %dl,%dl
 18c:	75 f2                	jne    180 <strchr+0x20>
      return (char*)s;
  return 0;
 18e:	31 c0                	xor    %eax,%eax
}
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 1a8:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ae:	eb 29                	jmp    1d9 <gets+0x39>
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	57                   	push   %edi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 2d 01 00 00       	call   2ea <read>
    if(cc < 1)
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 1d                	jle    1e1 <gets+0x41>
      break;
    buf[i++] = c;
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1cd:	3c 0a                	cmp    $0xa,%al
    buf[i++] = c;
 1cf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1d3:	74 1b                	je     1f0 <gets+0x50>
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 17                	je     1f0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1d9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7c cf                	jl     1b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1eb:	5b                   	pop    %ebx
 1ec:	5e                   	pop    %esi
 1ed:	5f                   	pop    %edi
 1ee:	5d                   	pop    %ebp
 1ef:	c3                   	ret    
  buf[i] = '\0';
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i=0; i+1 < max; ){
 1f3:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fc:	5b                   	pop    %ebx
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <stat>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 215:	83 ec 08             	sub    $0x8,%esp
 218:	6a 00                	push   $0x0
 21a:	ff 75 08             	pushl  0x8(%ebp)
 21d:	e8 f0 00 00 00       	call   312 <open>
  if(fd < 0)
 222:	83 c4 10             	add    $0x10,%esp
 225:	85 c0                	test   %eax,%eax
 227:	78 27                	js     250 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	pushl  0xc(%ebp)
 22f:	89 c3                	mov    %eax,%ebx
 231:	50                   	push   %eax
 232:	e8 f3 00 00 00       	call   32a <fstat>
  close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 23a:	89 c6                	mov    %eax,%esi
  close(fd);
 23c:	e8 b9 00 00 00       	call   2fa <close>
  return r;
 241:	83 c4 10             	add    $0x10,%esp
}
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	89 f0                	mov    %esi,%eax
 249:	5b                   	pop    %ebx
 24a:	5e                   	pop    %esi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb ed                	jmp    244 <stat+0x34>
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <atoi>:

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 267:	0f be 11             	movsbl (%ecx),%edx
 26a:	8d 42 d0             	lea    -0x30(%edx),%eax
 26d:	3c 09                	cmp    $0x9,%al
 26f:	b8 00 00 00 00       	mov    $0x0,%eax
 274:	77 1f                	ja     295 <atoi+0x35>
 276:	8d 76 00             	lea    0x0(%esi),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 280:	8d 04 80             	lea    (%eax,%eax,4),%eax
 283:	83 c1 01             	add    $0x1,%ecx
 286:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 28a:	0f be 11             	movsbl (%ecx),%edx
 28d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x20>
  return n;
}
 295:	5b                   	pop    %ebx
 296:	5d                   	pop    %ebp
 297:	c3                   	ret    
 298:	90                   	nop
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 db                	test   %ebx,%ebx
 2b0:	7e 14                	jle    2c6 <memmove+0x26>
 2b2:	31 d2                	xor    %edx,%edx
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2c2:	39 da                	cmp    %ebx,%edx
 2c4:	75 f2                	jne    2b8 <memmove+0x18>
  return vdst;
}
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    

000002ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ca:	b8 01 00 00 00       	mov    $0x1,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <exit>:
SYSCALL(exit)
 2d2:	b8 02 00 00 00       	mov    $0x2,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <wait>:
SYSCALL(wait)
 2da:	b8 03 00 00 00       	mov    $0x3,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <pipe>:
SYSCALL(pipe)
 2e2:	b8 04 00 00 00       	mov    $0x4,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <read>:
SYSCALL(read)
 2ea:	b8 05 00 00 00       	mov    $0x5,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <write>:
SYSCALL(write)
 2f2:	b8 10 00 00 00       	mov    $0x10,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <close>:
SYSCALL(close)
 2fa:	b8 15 00 00 00       	mov    $0x15,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <kill>:
SYSCALL(kill)
 302:	b8 06 00 00 00       	mov    $0x6,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <exec>:
SYSCALL(exec)
 30a:	b8 07 00 00 00       	mov    $0x7,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <open>:
SYSCALL(open)
 312:	b8 0f 00 00 00       	mov    $0xf,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mknod>:
SYSCALL(mknod)
 31a:	b8 11 00 00 00       	mov    $0x11,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <unlink>:
SYSCALL(unlink)
 322:	b8 12 00 00 00       	mov    $0x12,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <fstat>:
SYSCALL(fstat)
 32a:	b8 08 00 00 00       	mov    $0x8,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <link>:
SYSCALL(link)
 332:	b8 13 00 00 00       	mov    $0x13,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mkdir>:
SYSCALL(mkdir)
 33a:	b8 14 00 00 00       	mov    $0x14,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <chdir>:
SYSCALL(chdir)
 342:	b8 09 00 00 00       	mov    $0x9,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <dup>:
SYSCALL(dup)
 34a:	b8 0a 00 00 00       	mov    $0xa,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getpid>:
SYSCALL(getpid)
 352:	b8 0b 00 00 00       	mov    $0xb,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <sbrk>:
SYSCALL(sbrk)
 35a:	b8 0c 00 00 00       	mov    $0xc,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <sleep>:
SYSCALL(sleep)
 362:	b8 0d 00 00 00       	mov    $0xd,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <uptime>:
SYSCALL(uptime)
 36a:	b8 0e 00 00 00       	mov    $0xe,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getppid>:
SYSCALL(getppid)
 372:	b8 16 00 00 00       	mov    $0x16,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    
 37a:	66 90                	xchg   %ax,%ax
 37c:	66 90                	xchg   %ax,%ax
 37e:	66 90                	xchg   %ax,%ax

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	89 c6                	mov    %eax,%esi
 388:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 38e:	85 db                	test   %ebx,%ebx
 390:	74 7e                	je     410 <printint+0x90>
 392:	89 d0                	mov    %edx,%eax
 394:	c1 e8 1f             	shr    $0x1f,%eax
 397:	84 c0                	test   %al,%al
 399:	74 75                	je     410 <printint+0x90>
    neg = 1;
    x = -xx;
 39b:	89 d0                	mov    %edx,%eax
    neg = 1;
 39d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 3a4:	f7 d8                	neg    %eax
 3a6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3a9:	31 ff                	xor    %edi,%edi
 3ab:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3ae:	89 ce                	mov    %ecx,%esi
 3b0:	eb 08                	jmp    3ba <printint+0x3a>
 3b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3b8:	89 cf                	mov    %ecx,%edi
 3ba:	31 d2                	xor    %edx,%edx
 3bc:	8d 4f 01             	lea    0x1(%edi),%ecx
 3bf:	f7 f6                	div    %esi
 3c1:	0f b6 92 e8 07 00 00 	movzbl 0x7e8(%edx),%edx
  }while((x /= base) != 0);
 3c8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3ca:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3cd:	75 e9                	jne    3b8 <printint+0x38>
  if(neg)
 3cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3d2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3d5:	85 c0                	test   %eax,%eax
 3d7:	74 08                	je     3e1 <printint+0x61>
    buf[i++] = '-';
 3d9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3de:	8d 4f 02             	lea    0x2(%edi),%ecx

  while(--i >= 0)
 3e1:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
  write(fd, &c, 1);
 3ed:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 3f0:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 3f3:	6a 01                	push   $0x1
 3f5:	53                   	push   %ebx
 3f6:	56                   	push   %esi
 3f7:	88 45 d7             	mov    %al,-0x29(%ebp)
 3fa:	e8 f3 fe ff ff       	call   2f2 <write>
  while(--i >= 0)
 3ff:	83 c4 10             	add    $0x10,%esp
 402:	83 ff ff             	cmp    $0xffffffff,%edi
 405:	75 e1                	jne    3e8 <printint+0x68>
    putc(fd, buf[i]);
}
 407:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40a:	5b                   	pop    %ebx
 40b:	5e                   	pop    %esi
 40c:	5f                   	pop    %edi
 40d:	5d                   	pop    %ebp
 40e:	c3                   	ret    
 40f:	90                   	nop
    x = xx;
 410:	89 d0                	mov    %edx,%eax
  neg = 0;
 412:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 419:	eb 8b                	jmp    3a6 <printint+0x26>
 41b:	90                   	nop
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000420 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 426:	8d 45 10             	lea    0x10(%ebp),%eax
{
 429:	83 ec 2c             	sub    $0x2c,%esp
  for(i = 0; fmt[i]; i++){
 42c:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 42f:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 432:	89 45 d0             	mov    %eax,-0x30(%ebp)
 435:	0f b6 1e             	movzbl (%esi),%ebx
 438:	83 c6 01             	add    $0x1,%esi
 43b:	84 db                	test   %bl,%bl
 43d:	0f 84 b0 00 00 00    	je     4f3 <printf+0xd3>
 443:	31 d2                	xor    %edx,%edx
 445:	eb 39                	jmp    480 <printf+0x60>
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 450:	83 f8 25             	cmp    $0x25,%eax
 453:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 456:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 45b:	74 18                	je     475 <printf+0x55>
  write(fd, &c, 1);
 45d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 460:	83 ec 04             	sub    $0x4,%esp
 463:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 466:	6a 01                	push   $0x1
 468:	50                   	push   %eax
 469:	57                   	push   %edi
 46a:	e8 83 fe ff ff       	call   2f2 <write>
 46f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 472:	83 c4 10             	add    $0x10,%esp
 475:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 478:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 47c:	84 db                	test   %bl,%bl
 47e:	74 73                	je     4f3 <printf+0xd3>
    if(state == 0){
 480:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 482:	0f be cb             	movsbl %bl,%ecx
 485:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 488:	74 c6                	je     450 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48a:	83 fa 25             	cmp    $0x25,%edx
 48d:	75 e6                	jne    475 <printf+0x55>
      if(c == 'd'){
 48f:	83 f8 64             	cmp    $0x64,%eax
 492:	0f 84 f8 00 00 00    	je     590 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 498:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 49e:	83 f9 70             	cmp    $0x70,%ecx
 4a1:	74 5d                	je     500 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a3:	83 f8 73             	cmp    $0x73,%eax
 4a6:	0f 84 84 00 00 00    	je     530 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ac:	83 f8 63             	cmp    $0x63,%eax
 4af:	0f 84 ea 00 00 00    	je     59f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b5:	83 f8 25             	cmp    $0x25,%eax
 4b8:	0f 84 c2 00 00 00    	je     580 <printf+0x160>
  write(fd, &c, 1);
 4be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c1:	83 ec 04             	sub    $0x4,%esp
 4c4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4c8:	6a 01                	push   $0x1
 4ca:	50                   	push   %eax
 4cb:	57                   	push   %edi
 4cc:	e8 21 fe ff ff       	call   2f2 <write>
 4d1:	83 c4 0c             	add    $0xc,%esp
 4d4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4d7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4da:	6a 01                	push   $0x1
 4dc:	50                   	push   %eax
 4dd:	57                   	push   %edi
 4de:	83 c6 01             	add    $0x1,%esi
 4e1:	e8 0c fe ff ff       	call   2f2 <write>
  for(i = 0; fmt[i]; i++){
 4e6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 4ea:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ed:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4ef:	84 db                	test   %bl,%bl
 4f1:	75 8d                	jne    480 <printf+0x60>
    }
  }
}
 4f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f6:	5b                   	pop    %ebx
 4f7:	5e                   	pop    %esi
 4f8:	5f                   	pop    %edi
 4f9:	5d                   	pop    %ebp
 4fa:	c3                   	ret    
 4fb:	90                   	nop
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	b9 10 00 00 00       	mov    $0x10,%ecx
 508:	6a 00                	push   $0x0
 50a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 50d:	89 f8                	mov    %edi,%eax
 50f:	8b 13                	mov    (%ebx),%edx
 511:	e8 6a fe ff ff       	call   380 <printint>
        ap++;
 516:	89 d8                	mov    %ebx,%eax
 518:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51b:	31 d2                	xor    %edx,%edx
        ap++;
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 d0             	mov    %eax,-0x30(%ebp)
 523:	e9 4d ff ff ff       	jmp    475 <printf+0x55>
 528:	90                   	nop
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 530:	8b 45 d0             	mov    -0x30(%ebp),%eax
 533:	8b 18                	mov    (%eax),%ebx
        ap++;
 535:	83 c0 04             	add    $0x4,%eax
 538:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 53b:	85 db                	test   %ebx,%ebx
 53d:	74 7c                	je     5bb <printf+0x19b>
        while(*s != 0){
 53f:	0f b6 03             	movzbl (%ebx),%eax
 542:	84 c0                	test   %al,%al
 544:	74 29                	je     56f <printf+0x14f>
 546:	8d 76 00             	lea    0x0(%esi),%esi
 549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 550:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 553:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 556:	83 ec 04             	sub    $0x4,%esp
 559:	6a 01                	push   $0x1
          s++;
 55b:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 55e:	50                   	push   %eax
 55f:	57                   	push   %edi
 560:	e8 8d fd ff ff       	call   2f2 <write>
        while(*s != 0){
 565:	0f b6 03             	movzbl (%ebx),%eax
 568:	83 c4 10             	add    $0x10,%esp
 56b:	84 c0                	test   %al,%al
 56d:	75 e1                	jne    550 <printf+0x130>
      state = 0;
 56f:	31 d2                	xor    %edx,%edx
 571:	e9 ff fe ff ff       	jmp    475 <printf+0x55>
 576:	8d 76 00             	lea    0x0(%esi),%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  write(fd, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
 583:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 586:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 589:	6a 01                	push   $0x1
 58b:	e9 4c ff ff ff       	jmp    4dc <printf+0xbc>
        printint(fd, *ap, 10, 1);
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	b9 0a 00 00 00       	mov    $0xa,%ecx
 598:	6a 01                	push   $0x1
 59a:	e9 6b ff ff ff       	jmp    50a <printf+0xea>
        putc(fd, *ap);
 59f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5a2:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5a5:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5a7:	6a 01                	push   $0x1
        putc(fd, *ap);
 5a9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5af:	50                   	push   %eax
 5b0:	57                   	push   %edi
 5b1:	e8 3c fd ff ff       	call   2f2 <write>
 5b6:	e9 5b ff ff ff       	jmp    516 <printf+0xf6>
        while(*s != 0){
 5bb:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5c0:	bb df 07 00 00       	mov    $0x7df,%ebx
 5c5:	eb 89                	jmp    550 <printf+0x130>
 5c7:	66 90                	xchg   %ax,%ax
 5c9:	66 90                	xchg   %ax,%ax
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 84 0a 00 00       	mov    0xa84,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5de:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5e0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e3:	39 c8                	cmp    %ecx,%eax
 5e5:	73 19                	jae    600 <free+0x30>
 5e7:	89 f6                	mov    %esi,%esi
 5e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 5f0:	39 d1                	cmp    %edx,%ecx
 5f2:	72 1c                	jb     610 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f4:	39 d0                	cmp    %edx,%eax
 5f6:	73 18                	jae    610 <free+0x40>
{
 5f8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fa:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fc:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	72 f0                	jb     5f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	39 d0                	cmp    %edx,%eax
 602:	72 f4                	jb     5f8 <free+0x28>
 604:	39 d1                	cmp    %edx,%ecx
 606:	73 f0                	jae    5f8 <free+0x28>
 608:	90                   	nop
 609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 610:	8b 73 fc             	mov    -0x4(%ebx),%esi
 613:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 616:	39 fa                	cmp    %edi,%edx
 618:	74 19                	je     633 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 61a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 61d:	8b 50 04             	mov    0x4(%eax),%edx
 620:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 623:	39 f1                	cmp    %esi,%ecx
 625:	74 23                	je     64a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 627:	89 08                	mov    %ecx,(%eax)
  freep = p;
 629:	a3 84 0a 00 00       	mov    %eax,0xa84
}
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5f                   	pop    %edi
 631:	5d                   	pop    %ebp
 632:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 633:	03 72 04             	add    0x4(%edx),%esi
 636:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 639:	8b 10                	mov    (%eax),%edx
 63b:	8b 12                	mov    (%edx),%edx
 63d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 640:	8b 50 04             	mov    0x4(%eax),%edx
 643:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 646:	39 f1                	cmp    %esi,%ecx
 648:	75 dd                	jne    627 <free+0x57>
    p->s.size += bp->s.size;
 64a:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 64d:	a3 84 0a 00 00       	mov    %eax,0xa84
    p->s.size += bp->s.size;
 652:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 655:	8b 53 f8             	mov    -0x8(%ebx),%edx
 658:	89 10                	mov    %edx,(%eax)
}
 65a:	5b                   	pop    %ebx
 65b:	5e                   	pop    %esi
 65c:	5f                   	pop    %edi
 65d:	5d                   	pop    %ebp
 65e:	c3                   	ret    
 65f:	90                   	nop

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 15 84 0a 00 00    	mov    0xa84,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 78 07             	lea    0x7(%eax),%edi
 675:	c1 ef 03             	shr    $0x3,%edi
 678:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 67b:	85 d2                	test   %edx,%edx
 67d:	0f 84 93 00 00 00    	je     716 <malloc+0xb6>
 683:	8b 02                	mov    (%edx),%eax
 685:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 688:	39 cf                	cmp    %ecx,%edi
 68a:	76 64                	jbe    6f0 <malloc+0x90>
 68c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 692:	bb 00 10 00 00       	mov    $0x1000,%ebx
 697:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 69a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6a1:	eb 0e                	jmp    6b1 <malloc+0x51>
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6aa:	8b 48 04             	mov    0x4(%eax),%ecx
 6ad:	39 cf                	cmp    %ecx,%edi
 6af:	76 3f                	jbe    6f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b1:	39 05 84 0a 00 00    	cmp    %eax,0xa84
 6b7:	89 c2                	mov    %eax,%edx
 6b9:	75 ed                	jne    6a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	56                   	push   %esi
 6bf:	e8 96 fc ff ff       	call   35a <sbrk>
  if(p == (char*)-1)
 6c4:	83 c4 10             	add    $0x10,%esp
 6c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ca:	74 1c                	je     6e8 <malloc+0x88>
  hp->s.size = nu;
 6cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6cf:	83 ec 0c             	sub    $0xc,%esp
 6d2:	83 c0 08             	add    $0x8,%eax
 6d5:	50                   	push   %eax
 6d6:	e8 f5 fe ff ff       	call   5d0 <free>
  return freep;
 6db:	8b 15 84 0a 00 00    	mov    0xa84,%edx
      if((p = morecore(nunits)) == 0)
 6e1:	83 c4 10             	add    $0x10,%esp
 6e4:	85 d2                	test   %edx,%edx
 6e6:	75 c0                	jne    6a8 <malloc+0x48>
        return 0;
 6e8:	31 c0                	xor    %eax,%eax
 6ea:	eb 1c                	jmp    708 <malloc+0xa8>
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6f0:	39 cf                	cmp    %ecx,%edi
 6f2:	74 1c                	je     710 <malloc+0xb0>
        p->s.size -= nunits;
 6f4:	29 f9                	sub    %edi,%ecx
 6f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6ff:	89 15 84 0a 00 00    	mov    %edx,0xa84
      return (void*)(p + 1);
 705:	83 c0 08             	add    $0x8,%eax
  }
}
 708:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70b:	5b                   	pop    %ebx
 70c:	5e                   	pop    %esi
 70d:	5f                   	pop    %edi
 70e:	5d                   	pop    %ebp
 70f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 710:	8b 08                	mov    (%eax),%ecx
 712:	89 0a                	mov    %ecx,(%edx)
 714:	eb e9                	jmp    6ff <malloc+0x9f>
    base.s.ptr = freep = prevp = &base;
 716:	c7 05 84 0a 00 00 88 	movl   $0xa88,0xa84
 71d:	0a 00 00 
 720:	c7 05 88 0a 00 00 88 	movl   $0xa88,0xa88
 727:	0a 00 00 
    base.s.size = 0;
 72a:	b8 88 0a 00 00       	mov    $0xa88,%eax
 72f:	c7 05 8c 0a 00 00 00 	movl   $0x0,0xa8c
 736:	00 00 00 
 739:	e9 4e ff ff ff       	jmp    68c <malloc+0x2c>
