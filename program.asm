
program.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	40000113          	li	sp,1024
   4:	000021b7          	lui	gp,0x2
   8:	97818193          	addi	gp,gp,-1672 # 1978 <__global_pointer$>
   c:	008000ef          	jal	14 <main>

00000010 <end_loop>:
  10:	0000006f          	j	10 <end_loop>

00000014 <main>:
  14:	fd010113          	addi	sp,sp,-48
  18:	02112623          	sw	ra,44(sp)
  1c:	02812423          	sw	s0,40(sp)
  20:	03010413          	addi	s0,sp,48
  24:	fe042623          	sw	zero,-20(s0)
  28:	02c0006f          	j	54 <main+0x40>
  2c:	83018713          	addi	a4,gp,-2000 # 11a8 <dist>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00279793          	slli	a5,a5,0x2
  38:	00f707b3          	add	a5,a4,a5
  3c:	00002737          	lui	a4,0x2
  40:	70f70713          	addi	a4,a4,1807 # 270f <__global_pointer$+0xd97>
  44:	00e7a023          	sw	a4,0(a5)
  48:	fec42783          	lw	a5,-20(s0)
  4c:	00178793          	addi	a5,a5,1
  50:	fef42623          	sw	a5,-20(s0)
  54:	fec42703          	lw	a4,-20(s0)
  58:	00200793          	li	a5,2
  5c:	fce7d8e3          	bge	a5,a4,2c <main+0x18>
  60:	83018793          	addi	a5,gp,-2000 # 11a8 <dist>
  64:	0007a023          	sw	zero,0(a5)
  68:	fe042423          	sw	zero,-24(s0)
  6c:	0e80006f          	j	154 <main+0x140>
  70:	fe042223          	sw	zero,-28(s0)
  74:	0c80006f          	j	13c <main+0x128>
  78:	000017b7          	lui	a5,0x1
  7c:	17878713          	addi	a4,a5,376 # 1178 <edges>
  80:	fe442783          	lw	a5,-28(s0)
  84:	00479793          	slli	a5,a5,0x4
  88:	00f707b3          	add	a5,a4,a5
  8c:	0007a783          	lw	a5,0(a5)
  90:	fef42023          	sw	a5,-32(s0)
  94:	000017b7          	lui	a5,0x1
  98:	17878713          	addi	a4,a5,376 # 1178 <edges>
  9c:	fe442783          	lw	a5,-28(s0)
  a0:	00479793          	slli	a5,a5,0x4
  a4:	00f707b3          	add	a5,a4,a5
  a8:	0047a783          	lw	a5,4(a5)
  ac:	fcf42e23          	sw	a5,-36(s0)
  b0:	000017b7          	lui	a5,0x1
  b4:	17878713          	addi	a4,a5,376 # 1178 <edges>
  b8:	fe442783          	lw	a5,-28(s0)
  bc:	00479793          	slli	a5,a5,0x4
  c0:	00f707b3          	add	a5,a4,a5
  c4:	0087a783          	lw	a5,8(a5)
  c8:	fcf42c23          	sw	a5,-40(s0)
  cc:	83018713          	addi	a4,gp,-2000 # 11a8 <dist>
  d0:	fe042783          	lw	a5,-32(s0)
  d4:	00279793          	slli	a5,a5,0x2
  d8:	00f707b3          	add	a5,a4,a5
  dc:	0007a703          	lw	a4,0(a5)
  e0:	fd842783          	lw	a5,-40(s0)
  e4:	00f70733          	add	a4,a4,a5
  e8:	83018693          	addi	a3,gp,-2000 # 11a8 <dist>
  ec:	fdc42783          	lw	a5,-36(s0)
  f0:	00279793          	slli	a5,a5,0x2
  f4:	00f687b3          	add	a5,a3,a5
  f8:	0007a783          	lw	a5,0(a5)
  fc:	02f75a63          	bge	a4,a5,130 <main+0x11c>
 100:	83018713          	addi	a4,gp,-2000 # 11a8 <dist>
 104:	fe042783          	lw	a5,-32(s0)
 108:	00279793          	slli	a5,a5,0x2
 10c:	00f707b3          	add	a5,a4,a5
 110:	0007a703          	lw	a4,0(a5)
 114:	fd842783          	lw	a5,-40(s0)
 118:	00f70733          	add	a4,a4,a5
 11c:	83018693          	addi	a3,gp,-2000 # 11a8 <dist>
 120:	fdc42783          	lw	a5,-36(s0)
 124:	00279793          	slli	a5,a5,0x2
 128:	00f687b3          	add	a5,a3,a5
 12c:	00e7a023          	sw	a4,0(a5)
 130:	fe442783          	lw	a5,-28(s0)
 134:	00178793          	addi	a5,a5,1
 138:	fef42223          	sw	a5,-28(s0)
 13c:	fe442703          	lw	a4,-28(s0)
 140:	00200793          	li	a5,2
 144:	f2e7dae3          	bge	a5,a4,78 <main+0x64>
 148:	fe842783          	lw	a5,-24(s0)
 14c:	00178793          	addi	a5,a5,1
 150:	fef42423          	sw	a5,-24(s0)
 154:	fe842703          	lw	a4,-24(s0)
 158:	00100793          	li	a5,1
 15c:	f0e7dae3          	bge	a5,a4,70 <main+0x5c>
 160:	00000793          	li	a5,0
 164:	00078513          	mv	a0,a5
 168:	02c12083          	lw	ra,44(sp)
 16c:	02812403          	lw	s0,40(sp)
 170:	03010113          	addi	sp,sp,48
 174:	00008067          	ret

Disassembly of section .data:

00001178 <edges>:
    1178:	0000                	.insn	2, 0x0000
    117a:	0000                	.insn	2, 0x0000
    117c:	0001                	.insn	2, 0x0001
    117e:	0000                	.insn	2, 0x0000
    1180:	0004                	.insn	2, 0x0004
    1182:	0000                	.insn	2, 0x0000
    1184:	0000                	.insn	2, 0x0000
    1186:	0000                	.insn	2, 0x0000
    1188:	0001                	.insn	2, 0x0001
    118a:	0000                	.insn	2, 0x0000
    118c:	0002                	.insn	2, 0x0002
    118e:	0000                	.insn	2, 0x0000
    1190:	fffe                	.insn	2, 0xfffe
    1192:	ffff                	.insn	2, 0xffff
	...
    119c:	0002                	.insn	2, 0x0002
    119e:	0000                	.insn	2, 0x0000
    11a0:	0005                	.insn	2, 0x0005
    11a2:	0000                	.insn	2, 0x0000
    11a4:	0000                	.insn	2, 0x0000
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	5078                	.insn	2, 0x5078
   8:	6361                	.insn	2, 0x6361
   a:	4e47206b          	.insn	4, 0x4e47206b
   e:	2055                	.insn	2, 0x2055
  10:	4952                	.insn	2, 0x4952
  12:	562d4353          	.insn	4, 0x562d4353
  16:	4520                	.insn	2, 0x4520
  18:	626d                	.insn	2, 0x626d
  1a:	6465                	.insn	2, 0x6465
  1c:	6564                	.insn	2, 0x6564
  1e:	2064                	.insn	2, 0x2064
  20:	20434347          	.insn	4, 0x20434347
  24:	3878                	.insn	2, 0x3878
  26:	5f36                	.insn	2, 0x5f36
  28:	3436                	.insn	2, 0x3436
  2a:	2029                	.insn	2, 0x2029
  2c:	3531                	.insn	2, 0x3531
  2e:	322e                	.insn	2, 0x322e
  30:	302e                	.insn	2, 0x302e
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1b41                	.insn	2, 0x1b41
   2:	0000                	.insn	2, 0x0000
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <main>
   c:	0011                	.insn	2, 0x0011
   e:	0000                	.insn	2, 0x0000
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	0031                	.insn	2, 0x0031
