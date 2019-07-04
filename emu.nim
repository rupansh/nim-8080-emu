#[
Copyright (c) Rupansh Sekar. All rights reserved.
Licensed under the MIT license. See LICENSE file in the project root for details.
]#

import streams

type
  conditionCodes* {.bycopy.} = object
    z* {.bitsize: 1.}: uint8
    s* {.bitsize: 1.}: uint8
    p* {.bitsize: 1.}: uint8
    cy* {.bitsize: 1.}: uint8
    ac* {.bitsize: 1.}: uint8 # unused for space invaders
    pad* {.bitsize: 3.}: uint8

  state* {.bycopy.} = object
    a*: uint8
    b*: uint8
    c*: uint8
    d*: uint8
    e*: uint8
    h*: uint8
    l*: uint8
    sp*: uint16
    pc*: uint16
    mem*: ptr uint8
    cc*: conditionCodes
    intEnable*: uint8


proc disassemble8080(codebuffer: ptr uint8; pc: int): int =
  var code: ptr cuchar = addr(cast[ptr cstring](codebuffer)[pc])
  var opbytes: int = 1
  echo("%04x ", pc)
  case code[]
  of 0x00.chr:
    echo("NOP")
  of 0x01.chr:
    echo("LXI    B,#$%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x02.chr:
    echo("STAX   B")
  of 0x03.chr:
    echo("INX    B")
  of 0x04.chr:
    echo("INR    B")
  of 0x05.chr:
    echo("DCR    B")
  of 0x06.chr:
    echo("MVI    B,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x07.chr:
    echo("RLC")
  of 0x08.chr:
    echo("NOP")
  of 0x09.chr:
    echo("DAD    B")
  of 0x0A.chr:
    echo("LDAX   B")
  of 0x0B.chr:
    echo("DCX    B")
  of 0x0C.chr:
    echo("INR    C")
  of 0x0D.chr:
    echo("DCR    C")
  of 0x0E.chr:
    echo("MVI    C,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x0F.chr:
    echo("RRC")
  of 0x10.chr:
    echo("NOP")
  of 0x11.chr:
    echo("LXI    D,#$%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x12.chr:
    echo("STAX   D")
  of 0x13.chr:
    echo("INX    D")
  of 0x14.chr:
    echo("INR    D")
  of 0x15.chr:
    echo("DCR    D")
  of 0x16.chr:
    echo("MVI    D,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x17.chr:
    echo("RAL")
  of 0x18.chr:
    echo("NOP")
  of 0x19.chr:
    echo("DAD    D")
  of 0x1A.chr:
    echo("LDAX   D")
  of 0x1B.chr:
    echo("DCX    D")
  of 0x1C.chr:
    echo("INR    E")
  of 0x1D.chr:
    echo("DCR    E")
  of 0x1E.chr:
    echo("MVI    E,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x1F.chr:
    echo("RAR")
  of 0x20.chr:
    echo("NOP")
  of 0x21.chr:
    echo("LXI    H,#$%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x22.chr:
    echo("SHLD   $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x23.chr:
    echo("INX    H")
  of 0x24.chr:
    echo("INR    H")
  of 0x25.chr:
    echo("DCR    H")
  of 0x26.chr:
    echo("MVI    H,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x27.chr:
    echo("DAA")
  of 0x28.chr:
    echo("NOP")
  of 0x29.chr:
    echo("DAD    H")
  of 0x2A.chr:
    echo("LHLD   $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x2B.chr:
    echo("DCX    H")
  of 0x2C.chr:
    echo("INR    L")
  of 0x2D.chr:
    echo("DCR    L")
  of 0x2E.chr:
    echo("MVI    L,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x2F.chr:
    echo("CMA")
  of 0x30.chr:
    echo("NOP")
  of 0x31.chr:
    echo("LXI    SP,#$%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x32.chr:
    echo("STA    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x33.chr:
    echo("INX    SP")
  of 0x34.chr:
    echo("INR    M")
  of 0x35.chr:
    echo("DCR    M")
  of 0x36.chr:
    echo("MVI    M,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x37.chr:
    echo("STC")
  of 0x38.chr:
    echo("NOP")
  of 0x39.chr:
    echo("DAD    SP")
  of 0x3A.chr:
    echo("LDA    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0x3B.chr:
    echo("DCX    SP")
  of 0x3C.chr:
    echo("INR    A")
  of 0x3D.chr:
    echo("DCR    A")
  of 0x3E.chr:
    echo("MVI    A,#$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0x3F.chr:
    echo("CMC")
  of 0x40.chr:
    echo("MOV    B,B")
  of 0x41.chr:
    echo("MOV    B,C")
  of 0x42.chr:
    echo("MOV    B,D")
  of 0x43.chr:
    echo("MOV    B,E")
  of 0x44.chr:
    echo("MOV    B,H")
  of 0x45.chr:
    echo("MOV    B,L")
  of 0x46.chr:
    echo("MOV    B,M")
  of 0x47.chr:
    echo("MOV    B,A")
  of 0x48.chr:
    echo("MOV    C,B")
  of 0x49.chr:
    echo("MOV    C,C")
  of 0x4A.chr:
    echo("MOV    C,D")
  of 0x4B.chr:
    echo("MOV    C,E")
  of 0x4C.chr:
    echo("MOV    C,H")
  of 0x4D.chr:
    echo("MOV    C,L")
  of 0x4E.chr:
    echo("MOV    C,M")
  of 0x4F.chr:
    echo("MOV    C,A")
  of 0x50.chr:
    echo("MOV    D,B")
  of 0x51.chr:
    echo("MOV    D,C")
  of 0x52.chr:
    echo("MOV    D,D")
  of 0x53.chr:
    echo("MOV    D.E")
  of 0x54.chr:
    echo("MOV    D,H")
  of 0x55.chr:
    echo("MOV    D,L")
  of 0x56.chr:
    echo("MOV    D,M")
  of 0x57.chr:
    echo("MOV    D,A")
  of 0x58.chr:
    echo("MOV    E,B")
  of 0x59.chr:
    echo("MOV    E,C")
  of 0x5A.chr:
    echo("MOV    E,D")
  of 0x5B.chr:
    echo("MOV    E,E")
  of 0x5C.chr:
    echo("MOV    E,H")
  of 0x5D.chr:
    echo("MOV    E,L")
  of 0x5E.chr:
    echo("MOV    E,M")
  of 0x5F.chr:
    echo("MOV    E,A")
  of 0x60.chr:
    echo("MOV    H,B")
  of 0x61.chr:
    echo("MOV    H,C")
  of 0x62.chr:
    echo("MOV    H,D")
  of 0x63.chr:
    echo("MOV    H.E")
  of 0x64.chr:
    echo("MOV    H,H")
  of 0x65.chr:
    echo("MOV    H,L")
  of 0x66.chr:
    echo("MOV    H,M")
  of 0x67.chr:
    echo("MOV    H,A")
  of 0x68.chr:
    echo("MOV    L,B")
  of 0x69.chr:
    echo("MOV    L,C")
  of 0x6A.chr:
    echo("MOV    L,D")
  of 0x6B.chr:
    echo("MOV    L,E")
  of 0x6C.chr:
    echo("MOV    L,H")
  of 0x6D.chr:
    echo("MOV    L,L")
  of 0x6E.chr:
    echo("MOV    L,M")
  of 0x6F.chr:
    echo("MOV    L,A")
  of 0x70.chr:
    echo("MOV    M,B")
  of 0x71.chr:
    echo("MOV    M,C")
  of 0x72.chr:
    echo("MOV    M,D")
  of 0x73.chr:
    echo("MOV    M.E")
  of 0x74.chr:
    echo("MOV    M,H")
  of 0x75.chr:
    echo("MOV    M,L")
  of 0x76.chr:
    echo("HLT")
  of 0x77.chr:
    echo("MOV    M,A")
  of 0x78.chr:
    echo("MOV    A,B")
  of 0x79.chr:
    echo("MOV    A,C")
  of 0x7A.chr:
    echo("MOV    A,D")
  of 0x7B.chr:
    echo("MOV    A,E")
  of 0x7C.chr:
    echo("MOV    A,H")
  of 0x7D.chr:
    echo("MOV    A,L")
  of 0x7E.chr:
    echo("MOV    A,M")
  of 0x7F.chr:
    echo("MOV    A,A")
  of 0x80.chr:
    echo("ADD    B")
  of 0x81.chr:
    echo("ADD    C")
  of 0x82.chr:
    echo("ADD    D")
  of 0x83.chr:
    echo("ADD    E")
  of 0x84.chr:
    echo("ADD    H")
  of 0x85.chr:
    echo("ADD    L")
  of 0x86.chr:
    echo("ADD    M")
  of 0x87.chr:
    echo("ADD    A")
  of 0x88.chr:
    echo("ADC    B")
  of 0x89.chr:
    echo("ADC    C")
  of 0x8A.chr:
    echo("ADC    D")
  of 0x8B.chr:
    echo("ADC    E")
  of 0x8C.chr:
    echo("ADC    H")
  of 0x8D.chr:
    echo("ADC    L")
  of 0x8E.chr:
    echo("ADC    M")
  of 0x8F.chr:
    echo("ADC    A")
  of 0x90.chr:
    echo("SUB    B")
  of 0x91.chr:
    echo("SUB    C")
  of 0x92.chr:
    echo("SUB    D")
  of 0x93.chr:
    echo("SUB    E")
  of 0x94.chr:
    echo("SUB    H")
  of 0x95.chr:
    echo("SUB    L")
  of 0x96.chr:
    echo("SUB    M")
  of 0x97.chr:
    echo("SUB    A")
  of 0x98.chr:
    echo("SBB    B")
  of 0x99.chr:
    echo("SBB    C")
  of 0x9A.chr:
    echo("SBB    D")
  of 0x9B.chr:
    echo("SBB    E")
  of 0x9C.chr:
    echo("SBB    H")
  of 0x9D.chr:
    echo("SBB    L")
  of 0x9E.chr:
    echo("SBB    M")
  of 0x9F.chr:
    echo("SBB    A")
  of 0xA0.chr:
    echo("ANA    B")
  of 0xA1.chr:
    echo("ANA    C")
  of 0xA2.chr:
    echo("ANA    D")
  of 0xA3.chr:
    echo("ANA    E")
  of 0xA4.chr:
    echo("ANA    H")
  of 0xA5.chr:
    echo("ANA    L")
  of 0xA6.chr:
    echo("ANA    M")
  of 0xA7.chr:
    echo("ANA    A")
  of 0xA8.chr:
    echo("XRA    B")
  of 0xA9.chr:
    echo("XRA    C")
  of 0xAA.chr:
    echo("XRA    D")
  of 0xAB.chr:
    echo("XRA    E")
  of 0xAC.chr:
    echo("XRA    H")
  of 0xAD.chr:
    echo("XRA    L")
  of 0xAE.chr:
    echo("XRA    M")
  of 0xAF.chr:
    echo("XRA    A")
  of 0xB0.chr:
    echo("ORA    B")
  of 0xB1.chr:
    echo("ORA    C")
  of 0xB2.chr:
    echo("ORA    D")
  of 0xB3.chr:
    echo("ORA    E")
  of 0xB4.chr:
    echo("ORA    H")
  of 0xB5.chr:
    echo("ORA    L")
  of 0xB6.chr:
    echo("ORA    M")
  of 0xB7.chr:
    echo("ORA    A")
  of 0xB8.chr:
    echo("CMP    B")
  of 0xB9.chr:
    echo("CMP    C")
  of 0xBA.chr:
    echo("CMP    D")
  of 0xBB.chr:
    echo("CMP    E")
  of 0xBC.chr:
    echo("CMP    H")
  of 0xBD.chr:
    echo("CMP    L")
  of 0xBE.chr:
    echo("CMP    M")
  of 0xBF.chr:
    echo("CMP    A")
  of 0xC0.chr:
    echo("RNZ")
  of 0xC1.chr:
    echo("POP    B")
  of 0xC2.chr:
    echo("JNZ    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xC3.chr:
    echo("JMP    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xC4.chr:
    echo("CNZ    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xC5.chr:
    echo("PUSH   B")
  of 0xC6.chr:
    echo("ADI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xC7.chr:
    echo("RST    0")
  of 0xC8.chr:
    echo("RZ")
  of 0xC9.chr:
    echo("RET")
  of 0xCA.chr:
    echo("JZ     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xCB.chr:
    echo("JMP    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xCC.chr:
    echo("CZ     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xCD.chr:
    echo("CALL   $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xCE.chr:
    echo("ACI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xCF.chr:
    echo("RST    1")
  of 0xD0.chr:
    echo("RNC")
  of 0xD1.chr:
    echo("POP    D")
  of 0xD2.chr:
    echo("JNC    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xD3.chr:
    echo("OUT    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xD4.chr:
    echo("CNC    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xD5.chr:
    echo("PUSH   D")
  of 0xD6.chr:
    echo("SUI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xD7.chr:
    echo("RST    2")
  of 0xD8.chr:
    echo("RC")
  of 0xD9.chr:
    echo("RET")
  of 0xDA.chr:
    echo("JC     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xDB.chr:
    echo("IN     #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xDC.chr:
    echo("CC     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xDD.chr:
    echo("CALL   $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xDE.chr:
    echo("SBI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xDF.chr:
    echo("RST    3")
  of 0xE0.chr:
    echo("RPO")
  of 0xE1.chr:
    echo("POP    H")
  of 0xE2.chr:
    echo("JPO    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xE3.chr:
    echo("XTHL")
  of 0xE4.chr:
    echo("CPO    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xE5.chr:
    echo("PUSH   H")
  of 0xE6.chr:
    echo("ANI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xE7.chr:
    echo("RST    4")
  of 0xE8.chr:
    echo("RPE")
  of 0xE9.chr:
    echo("PCHL")
  of 0xEA.chr:
    echo("JPE    $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xEB.chr:
    echo("XCHG")
  of 0xEC.chr:
    echo("CPE     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xED.chr:
    echo("CALL   $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xEE.chr:
    echo("XRI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xEF.chr:
    echo("RST    5")
  of 0xF0.chr:
    echo("RP")
  of 0xF1.chr:
    echo("POP    PSW")
  of 0xF2.chr:
    echo("JP     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xF3.chr:
    echo("DI")
  of 0xF4.chr:
    echo("CP     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xF5.chr:
    echo("PUSH   PSW")
  of 0xF6.chr:
    echo("ORI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xF7.chr:
    echo("RST    6")
  of 0xF8.chr:
    echo("RM")
  of 0xF9.chr:
    echo("SPHL")
  of 0xFA.chr:
    echo("JM     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xFB.chr:
    echo("EI")
  of 0xFC.chr:
    echo("CM     $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xFD.chr:
    echo("CALL   $%02x%02x", cast[cstring](code)[2], cast[cstring](code)[1])
    opbytes = 3
  of 0xFE.chr:
    echo("CPI    #$%02x", cast[cstring](code)[1])
    opbytes = 2
  of 0xFF.chr:
    echo("RST    7")

  return opbytes


proc parity(a: uint16, size: int): uint8 =
    var i = 0
    var p = 0
    var x: uint16 = (a and ((1 shl size)-1).uint16)
    while i<size:
        if (x and 0x1) > 0.uint16: inc(p)
        x = x shr 1
    
    return ((p and 0x1) == 0).uint8

proc addHandle(aState: ref state, ansArg: uint16) =
    let answer = cast[uint16](aState[].a) + ansArg
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.cy = (answer > 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc incHandle(aState: ref state, ansArg: uint16) =
    let answer = ansArg + 1
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc inxHandle(reg1:var uint8, reg2: var uint8) =
    reg2 += 1
    if (reg2 == 0):
        reg1 += 1

proc dadHandle(aState: ref state, reg1: uint8, reg2: uint8) =
    let hl: uint32 = (aState[].h shl 8) or aState[].l
    let pair: uint32 = (reg1 shl 8) or reg2
    let res = hl + pair
    aState[].h = ((res and 0xff00) shr 8).uint8
    aState[].l = (res and 0xff).uint8
    aState[].cc.cy = ((res and 0xffff0000.uint32) > 0.uint32).uint8

proc subHandle(aState: ref state, ansArg: uint16) =
    let answer = cast[uint16](aState[].a) - ansArg
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.cy = (answer > 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc decHandle(aState: ref state, ansArg: uint16) =
    let answer = ansArg - 1
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc jConditional(aState: ref state, condition: uint16, opcode: ptr cuchar) =
    if (condition == 0.uint8):
        aState[].pc += 2
    else:
        aState[].pc = (cast[cstring](opcode)[2].uint16 shl 8) or cast[cstring](opcode)[1].uint16

proc callConditional(aState: ref state, condition: uint16, opcode: ptr cuchar) =
    if (condition == 0.uint8):
        aState[].pc += 2
    else:
        var ret = aState[].pc+2
        cast[ptr cstring](aState[].mem)[aState[].sp-1] = ((ret shr 8) and 0xff).cuchar
        cast[ptr cstring](aState[].mem)[aState[].sp-2] = (ret and 0xff).cuchar
        aState[].sp -= 2
        aState[].pc = (cast[cstring](opcode)[2].uint16 shl 8) or cast[cstring](opcode)[1].uint16

proc retConditional(aState: ref state, condition: uint16, opcode: ptr cuchar) =
    if (condition == 0.uint8):
        aState[].pc += 2
    else:
        aState[].pc = (cast[ptr cstring](aState[].mem)[aState[].sp]).uint8 or ((cast[ptr cstring](aState[].mem)[aState[].sp+1]).uint8 shl 8)
        aState[].sp += 2

proc cmpHandle(aState: ref state, ansArg: uint16) =
    let answer = cast[uint16](aState[].a) - ansArg
    aState[].cc.z = ((answer and 0xff.uint16) == ansArg).uint8
    aState[].cc.cy = (answer < 0.uint16).uint8

proc ldaxHandle(aState: ref state, reg1: uint8, reg2: uint8) =
    let offset: uint16 = (reg1 shl 8) or reg2
    aState[].a = cast[ptr cstring](aState[].mem)[offset].uint8

proc lxiHandle(aState: ref state, reg1: var uint8, reg2: var uint8, opcode: ptr cuchar) =
    reg2 = cast[cstring](opcode)[1].uint8
    reg1 = cast[cstring](opcode)[2].uint8
    aState[].pc += 2

proc logicFlagsA(aState: ref state) =
    aState[].cc.cy = 0
    aState[].cc.ac = 0
    aState[].cc.z = (aState[].a == 0).uint8
    aState[].cc.p = parity(aState[].a , 8)

proc errUinmplemented() =
    echo "Instruction Unimplemented!"
    quit(1)

proc emulate8080(ourState: ref state): int =
    var opcode: ptr cuchar = addr(cast[ptr cstring](ourState[].mem)[ourState[].pc])
    discard disassemble8080(ourState[].mem, ourState[].pc.int)

    ourState[].pc += 1

    case opcode[]
    of 0x0.chr: discard # NOP

    of 0x01.chr: # LXI BC, Data
        lxiHandle(ourState, ourState[].b, ourState[].c, opcode)
    of 0x11.chr: # LXI DE, Data
        lxiHandle(ourState, ourState[].d, ourState[].e, opcode)
    of 0x21.chr: # LXI HL, data
        lxiHandle(ourState, ourState[].h, ourState[].l, opcode)
    of 0x31.chr: # LXI SP, data
        ourState[].sp = (cast[cstring](opcode)[2].uint8 shl 8) or cast[cstring](opcode)[1].uint8
        ourState[].pc += 2

    of 0x41.chr: ourState[].b = ourState[].c # MOV B, C
    of 0x42.chr: ourState[].b = ourState[].d # MOV B, D
    of 0x43.chr: ourState[].b = ourState[].e # MOV B, E
    of 0x56.chr: # MOV D, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].d = cast[ptr cstring](ourState[].mem)[offset].uint8
    of 0x5e.chr: # MOV E, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].e = cast[ptr cstring](ourState[].mem)[offset].uint8
    of 0x66.chr: # MOV H, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].h = cast[ptr cstring](ourState[].mem)[offset].uint8
    of 0x6f.chr: ourState[].l = ourState[].a # MOV L, A
    of 0x77.chr: # MOV Mem, A
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        cast[ptr cstring](ourState[].mem)[offset] = ourState[].a.chr
    of 0x7A.chr: ourState[].a = ourState[].d # MOV A, D
    of 0x7B.chr: ourState[].a = ourState[].e # MOV A, E
    of 0x7C.chr: ourState[].a = ourState[].h # MOV A, H
    of 0x7E.chr: # MOV A, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].a = cast[ptr cstring](ourState[].mem)[offset].uint8

    of 0xA7.chr: # ANA A
        ourState[].a = ourState[].a and ourState[].a
        logicFlagsA(ourState)
    of 0xAF.chr: # XRA A
        if (ourState[].a and ourState[].a) > 0.uint8:
            ourState[].a = 1
        else:
            ourState[].a = 0

    of 0xd3.chr: # OUT Data
        inc(ourState[].pc)
        # no idea wut to do

    of 0x80.chr: # ADD B
        addHandle(ourState, cast[uint16](ourState[].b))
    of 0x81.chr: # ADD C
        addHandle(ourState, cast[uint16](ourState[].c))
    of 0x82.chr: # ADD D
        addHandle(ourState, cast[uint16](ourState[].d))
    of 0x83.chr: # Add E
        addHandle(ourState, cast[uint16](ourState[].e))
    of 0x84.chr: # Add H
        addHandle(ourState, cast[uint16](ourState[].h))
    of 0x85.chr: # Add L
        addHandle(ourState, cast[uint16](ourState[].l))
    of 0x87.chr: # Add A
        addHandle(ourState, cast[uint16](ourState[].a))
    of 0x86.chr: # ADD Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = cast[ptr cstring](ourState[].mem)[offset]
        addHandle(ourState, memArg.uint16)

    of 0x88.chr: # ADC B
        let addCarr = cast[uint16](ourState[].b) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x89.chr: # ADC C
        let addCarr = cast[uint16](ourState[].c) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8A.chr: # ADC D
        let addCarr = cast[uint16](ourState[].d) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8B.chr: # ADC E
        let addCarr = cast[uint16](ourState[].e) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8C.chr: # ADC H
        let addCarr = cast[uint16](ourState[].h) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8D.chr: # ADC L
        let addCarr = cast[uint16](ourState[].l) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8E.chr: # ADC Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let addCarr = cast[ptr cstring](ourState[].mem)[offset].uint16 + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8F.chr: # ADC A
        let addCarr = cast[uint16](ourState[].a) + ourState[].cc.cy
        addHandle(ourState, addCarr)

    of 0x90.chr: # SUB B
        subHandle(ourState, cast[uint16](ourState[].b))
    of 0x91.chr: # SUB C
        subHandle(ourState, cast[uint16](ourState[].c))
    of 0x92.chr: # SUB D
        subHandle(ourState, cast[uint16](ourState[].d))
    of 0x93.chr: # SUB E
        subHandle(ourState, cast[uint16](ourState[].e))
    of 0x94.chr: # SUB H
        subHandle(ourState, cast[uint16](ourState[].h))
    of 0x95.chr: # SUB L
        subHandle(ourState, cast[uint16](ourState[].l))
    of 0x97.chr: # SUB A
        subHandle(ourState, cast[uint16](ourState[].a))
    of 0x96.chr: # SUB Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = cast[ptr cstring](ourState[].mem)[offset]
        addHandle(ourState, memArg.uint16)

    of 0x98.chr: # SBB B
        let subCarr = cast[uint16](ourState[].b) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x99.chr: # SBB C
        let subCarr = cast[uint16](ourState[].c) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9A.chr: # SBB D
        let subCarr = cast[uint16](ourState[].d) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9B.chr: # SBB E
        let subCarr = cast[uint16](ourState[].e) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9C.chr: # SBB H
        let subCarr = cast[uint16](ourState[].h) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9D.chr: # SBB L
        let subCarr = cast[uint16](ourState[].l) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9E.chr: # SBB Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let subCarr = cast[ptr cstring](ourState[].mem)[offset].uint16 - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9F.chr: # SBB A
        let subCarr = cast[uint16](ourState[].a) - ourState[].cc.cy
        subHandle(ourState, subCarr)

    of 0xC6.chr: # ADI data
        addHandle(ourState, cast[cstring](opcode)[1].uint16)
    of 0xCE.chr: # ACI data
        let addCarr = cast[cstring](opcode)[1].uint16 + ourState[].cc.cy
        addHandle(ourState, addCarr)

    of 0xD6.chr: # SUI data
        subHandle(ourState, cast[cstring](opcode)[1].uint16)
    of 0xDE.chr: # SBI data
        let subCarr = cast[cstring](opcode)[1].uint16 - ourState[].cc.cy
        subHandle(ourState, subCarr)

    of 0x04.chr: # INR B
        incHandle(ourState, cast[uint16](ourState[].b))
    of 0x0c.chr: # INR C
        incHandle(ourState, cast[uint16](ourState[].c))
    of 0x14.chr: # INR D
        incHandle(ourState, cast[uint16](ourState[].d))
    of 0x1c.chr: # INR E
        incHandle(ourState, cast[uint16](ourState[].e))
    of 0x24.chr: # INR H
        incHandle(ourState, cast[uint16](ourState[].h))
    of 0x2c.chr: # INR L
        incHandle(ourState, cast[uint16](ourState[].l))
    of 0x3c.chr: # INR A
        incHandle(ourState, cast[uint16](ourState[].a))
    of 0x34.chr: # INR Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = cast[ptr cstring](ourState[].mem)[offset]
        incHandle(ourState, memArg.uint16)

    of 0x05.chr: # DCR B
        decHandle(ourState, cast[uint16](ourState[].b))
    of 0x0d.chr: # DCR C
        decHandle(ourState, cast[uint16](ourState[].c))
    of 0x15.chr: # DCR D
        decHandle(ourState, cast[uint16](ourState[].d))
    of 0x1d.chr: # DCR E
        decHandle(ourState, cast[uint16](ourState[].e))
    of 0x25.chr: # DCR H
        decHandle(ourState, cast[uint16](ourState[].h))
    of 0x2d.chr: # DCR L
        decHandle(ourState, cast[uint16](ourState[].l))
    of 0x3d.chr: # DCR A
        decHandle(ourState, cast[uint16](ourState[].a))
    of 0x35.chr: # DCR Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = cast[ptr cstring](ourState[].mem)[offset]
        decHandle(ourState, memArg.uint16)

    of 0xCA.chr: # JZ addr
        jConditional(ourState, ourState[].cc.z, opcode)
    of 0xC2.chr: # JNZ addr
        jConditional(ourState, (not ourState[].cc.z), opcode)
    of 0xDA.chr: # JC addr
        jConditional(ourState, ourState[].cc.cy, opcode)
    of 0xD2.chr: # JNC addr
        jConditional(ourState, (not ourState[].cc.cy), opcode)
    of 0xEA.chr: # JPE addr
        jConditional(ourState, ourState[].cc.p, opcode)
    of 0xE2.chr: # JPO addr
        jConditional(ourState, (not ourState[].cc.p), opcode)
    of 0xFA.chr: # JM addr
        jConditional(ourState, ourState[].cc.s, opcode)
    of 0xF2.chr: # JP addr
        jConditional(ourState, (not ourState[].cc.s), opcode)
    of 0xC3.chr: # JMP addr
        ourState[].pc = (cast[cstring](opcode)[2].uint16 shl 8) or cast[cstring](opcode)[1].uint16

    of 0xCC.chr: # CZ addr
        callConditional(ourState, ourState[].cc.z, opcode)
    of 0xC4.chr: # CNZ addr
        callConditional(ourState, (not ourState[].cc.z), opcode)
    of 0xDC.chr: # CC addr
        callConditional(ourState, ourState[].cc.cy, opcode)
    of 0xD4.chr: # CNC addr
        callConditional(ourState, (not ourState[].cc.cy), opcode)
    of 0xEC.chr: # CPE addr
        callConditional(ourState, ourState[].cc.p, opcode)
    of 0xE4.chr: # CPO addr
        callConditional(ourState, (not ourState[].cc.p), opcode)
    of 0xFC.chr: # CM addr
        callConditional(ourState, ourState[].cc.s, opcode)
    of 0xF4.chr: # CP addr
        callConditional(ourState, (not ourState[].cc.s), opcode)
    of 0xCD.chr: # CALL addr
        var ret = ourState[].pc+2
        cast[ptr cstring](ourState[].mem)[ourState[].sp-1] = ((ret shr 8) and 0xff).cuchar
        cast[ptr cstring](ourState[].mem)[ourState[].sp-2] = (ret and 0xff).cuchar
        ourState[].sp -= 2
        ourState[].pc = (cast[cstring](opcode)[2].uint16 shl 8) or cast[cstring](opcode)[1].uint16

    of 0xC8.chr: # RZ
        retConditional(ourState, ourState[].cc.z, opcode)
    of 0xC0.chr: # RNZ
        retConditional(ourState, (not ourState[].cc.z), opcode)
    of 0xD8.chr: # RC
        retConditional(ourState, ourState[].cc.cy, opcode)
    of 0xD0.chr: # RNC
        retConditional(ourState, (not ourState[].cc.cy), opcode)
    of 0xE8.chr: # RPE
        retConditional(ourState, ourState[].cc.p, opcode)
    of 0xE0.chr: # RPO
        retConditional(ourState, (not ourState[].cc.p), opcode)
    of 0xF8.chr: # RM
        retConditional(ourState, ourState[].cc.s, opcode)
    of 0xF0.chr: # RP
        retConditional(ourState, (not ourState[].cc.s), opcode)
    of 0xc9.chr: # RET
        ourState[].pc = (cast[ptr cstring](ourState[].mem)[ourState[].sp]).uint8 or ((cast[ptr cstring](ourState[].mem)[ourState[].sp+1]).uint8 shl 8)
        ourState[].sp += 2

    of 0x2A.chr: # CMA (not)
        ourState[].a = not ourState[].a

    of 0xe6.chr: # ANI byte
        let x: uint8 = ourState[].a and cast[cstring](opcode)[1].uint8
        ourState[].cc.z = (x == 0).uint8
        ourState[].cc.s = ((x and 0x80.uint8) == 0x80).uint8
        ourState[].cc.p = parity(x, 8)
        ourState[].cc.cy = 0
        ourState[].a = x
        ourState[].pc += 1
    
    of 0x0F.chr: # RRC
        let x: uint8 = ourState[].a
        ourState[].a = ((x and 1) shl 7) or (x shr 1)
        ourState[].cc.cy = ((x and 1) == 1).uint8
    of 0x1F.chr: # RAR
        let x: uint8 = ourState[].a
        ourState[].a = (ourState[].cc.cy shl 7) or (x shr 1)
        ourState[].cc.cy = ((x and 1) == 1).uint8
    
    of 0xb8.chr: # CMP B
        cmpHandle(ourState, cast[uint16](ourState[].b))
    of 0xb9.chr: # CMP C
        cmpHandle(ourState, cast[uint16](ourState[].c))
    of 0xbA.chr: # CMP D
        cmpHandle(ourState, cast[uint16](ourState[].d))
    of 0xBB.chr: # CMP E
        cmpHandle(ourState, cast[uint16](ourState[].e))
    of 0xBC.chr: # CMP H
        cmpHandle(ourState, cast[uint16](ourState[].h))
    of 0xBD.chr: # CMP L
        cmpHandle(ourState, cast[uint16](ourState[].l))
    of 0xBF.chr: # CMP A
        cmpHandle(ourState, cast[uint16](ourState[].a))
    of 0xBE.chr: # CMP Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = cast[ptr cstring](ourState[].mem)[offset]
        cmpHandle(ourState, memArg.uint16)

    of 0xFE.chr: # CPI byte
        let x = ourState[].a - cast[cstring](opcode)[1].uint8
        ourState[].cc.z = (x == 0).uint8
        ourState[].cc.s = ((x and 0x80) == 0x80.uint8).uint8
        ourState[].cc.p = parity(x, 8)
        ourState[].cc.cy = (ourState[].a < cast[cstring](opcode)[1].uint8).uint8
        ourState[].pc += 1

    of 0x3F.chr: # CMC
        ourState[].cc.cy = not ourState[].cc.cy
    of 0x37.chr: # STC
        ourState[].cc.cy = 1
    
    of 0x76.chr: # HLT
        quit(0)
    
    of 0xC1.chr: # POP BC
        ourState[].c = cast[ptr cstring](ourState[].mem)[ourState[].sp].uint8
        ourState[].c = cast[ptr cstring](ourState[].mem)[ourState[].sp+1].uint8
        ourState[].sp += 2
    of 0xD1.chr: # POP DE
        ourState[].d = cast[ptr cstring](ourState[].mem)[ourState[].sp].uint8
        ourState[].e = cast[ptr cstring](ourState[].mem)[ourState[].sp+1].uint8
        ourState[].sp += 2
    of 0xE1.chr: # POP HL
        ourState[].h = cast[ptr cstring](ourState[].mem)[ourState[].sp].uint8
        ourState[].l = cast[ptr cstring](ourState[].mem)[ourState[].sp+1].uint8
        ourState[].sp += 2
    of 0xf1.chr: # POP PSW
        ourState[].a = cast[ptr cstring](ourState[].mem)[ourState[].sp+1].uint8
        let psw: uint8 = cast[ptr cstring](ourState[].mem)[ourState[].sp].uint8
        ourState[].cc.z = ((psw and 0x01) == 0x01).uint8
        ourState[].cc.s = ((psw and 0x02) == 0x02).uint8
        ourState[].cc.p = ((psw and 0x04) == 0x04).uint8
        ourState[].cc.cy = ((psw and 0x08) == 0x05).uint8
        ourState[].cc.cy = ((psw and 0x10) == 0x10).uint8
        ourState[].sp += 2

    of 0xC5.chr: # PUSH BC
        cast[ptr cstring](ourState[].mem)[ourState[].sp-1] = ourState[].b.chr
        cast[ptr cstring](ourState[].mem)[ourState[].sp-2] = ourState[].c.chr
        ourState[].sp -= 2
    of 0xD5.chr: # PUSH DE
        cast[ptr cstring](ourState[].mem)[ourState[].sp-1] = ourState[].d.chr
        cast[ptr cstring](ourState[].mem)[ourState[].sp-2] = ourState[].e.chr
        ourState[].sp -= 2
    of 0xE5.chr: # PUSH HL
        cast[ptr cstring](ourState[].mem)[ourState[].sp-1] = ourState[].h.chr
        cast[ptr cstring](ourState[].mem)[ourState[].sp-2] = ourState[].l.chr
        ourState[].sp -= 2
    of 0xF5.chr: # PUSH PSW
        cast[ptr cstring](ourState[].mem)[ourState[].sp-1] = ourState[].a.chr
        let psw: uint8 = (ourState[].cc.z or
           ourState[].cc.s shl 1 or
           ourState[].cc.p shl 2 or 
           ourState[].cc.cy shl 3 or
           ourState[].cc.ac shl 4)
        cast[ptr cstring](ourState[].mem)[ourState[].sp-2] = psw.chr
        ourState[].sp -= 2

    of 0xf9.chr: # SPHL
        ourState[].sp = (ourState[].h shl 8) or (ourState[].l)
    
    of 0x06.chr: # MVI B, data
        ourState[].b = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2
    of 0x0e.chr: # MVI C, data
        ourState[].c = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2
    of 0x16.chr: # MVI D, data
        ourState[].d = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2
    of 0x1e.chr: # MVI E, data
        ourState[].e = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2
    of 0x26.chr: # MVI H, data
        ourState[].h = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2
    of 0x2e.chr: # MVI L, data
        ourState[].l = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2
    of 0x36.chr: # MVI Mem, data
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        cast[ptr cstring](ourState[].mem)[offset] = cast[cstring](opcode)[1]
        ourState[].pc += 2
    of 0x3e.chr: # MVI A, data
        ourState[].a = cast[cstring](opcode)[1].uint8
        ourState[].pc += 2

    of 0x09.chr: # DAD BC
        dadHandle(ourState, ourState[].b, ourState[].c)
    of 0x19.chr: # DAD DE
        dadHandle(ourState, ourState[].d, ourState[].e)
    of 0x29.chr: # DAD HL
        dadHandle(ourState, ourState[].h, ourState[].l)
    of 0x39.chr: # DAD SP
        let hl: uint32 = (ourState[].h shl 8) or ourState[].l
        let res = hl + ourState[].sp
        ourState[].h = ((res and 0xff00) shr 8).uint8
        ourState[].l = (res and 0xff).uint8
        ourState[].cc.cy = ((res and 0xffff0000.uint32) > 0.uint32).uint8

    of 0x03.chr: # INX BC
        inxHandle(ourState[].b, ourState[].c)
    of 0x13.chr: # INX DE
        inxHandle(ourState[].d, ourState[].e)
    of 0x23.chr: # INX HL
        inxHandle(ourState[].h, ourState[].l)

    of 0x0a.chr: # LDAX BC
        ldaxHandle(ourState, ourState[].b, ourState[].c)
    of 0x1a.chr: # LDAX DE
        ldaxHandle(ourState, ourState[].d, ourState[].e)
    
    of 0x32.chr: # STA addr
        let offset = (cast[cstring](opcode)[2].uint8 shl 8) or cast[cstring](opcode)[1].uint8
        cast[ptr cstring](ourState[].mem)[offset] = ourState[].a.chr
        ourState[].pc += 2
    of 0x3a.chr: # LDA addr
        let offset = (cast[cstring](opcode)[2].uint8 shl 8) or cast[cstring](opcode)[1].uint8
        ourState[].a = cast[ptr cstring](ourState[].mem)[offset].uint8
        ourState[].pc += 2
    
    of 0xEB.chr: # XCHG
        let reg1 = ourState[].d
        let reg2 = ourState[].e
        ourState[].d = ourState[].h
        ourState[].e = ourState[].l
        ourState[].h = reg1
        ourState[].l = reg2

    of 0xFB.chr: # EI
            ourState[].intEnable = 1

    else:
        errUinmplemented()
        echo "OPCode=" & opcode[]

    echo "Cmds=" & $ourState[].cc
    echo "state=" & $ourState[]
    return 1
    #[TODO:
        INX SP - Unsure how to
        DCX - Lazy
        RST - Too lazy to add all of them. Space invaders doesn't use it anyways
        PCHL - Dunno how to assign to PCH and PCL
        IO/Special Groups - Not at that stage
        XTHL - useless
    ]#

# to do, borked
proc readToMem(ourState: ref state, filename: string) =
    let file = newFileStream(filename, fmWrite)
    discard readData(file, cast[ptr uint8](addr(cast[ptr cstring](ourState[].mem)[0])), 8)
    file.close
# to do
proc main() =
    var done = 0
    var vblankcycles = 0
    var ourState = new(ref state)

    readToMem(ourState, "rom/invaders.rom")

    while done == 0:
        done = emulate8080(ourState)


main()