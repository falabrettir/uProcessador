**Autores:** Rodrigo Falabretti e Luigi Lipori  
**Disciplina:** Arquitetura e Organização de Computadores

---

## 1. Arquitetura e Organização

### 1.1. Registradores

O processador conta com um banco de **9 registradores de uso geral** (R0 a R8), cada um com 16 bits de largura.

- **R0:** Registrador base (pode ser escrito e lido).
- **R1-R8:** Registradores para manipulação de dados, ponteiros e cálculos.
- **PC (Program Counter):** 17 bits.
- **IR (Instruction Register):** 17 bits.

### 1.2. Memória

- **ROM (Instruções):** 128 palavras de 17 bits. Endereçada pelo PC.
- **RAM (Dados):** 128 palavras de 16 bits. Endereçamento indireto via registrador (7 bits LSB).

---

## 2. Conjunto de Instruções (ISA)

As instruções possuem 17 bits e seguem três formatos principais.

### 2.1. Formatos

- **Tipo R:** `[Opcode 4] [Dest 4] [Src2 4] [X 5]`
- **Tipo I:** `[Opcode 4] [Dest 4] [Src1 4] [Imm 5]`
- **Tipo J:** `[Opcode 4] [Endereço 13]`

### 2.2. Tabela de Instruções

| Mnemônico | Opcode | Tipo | Operação (RTL)      | Descrição                                |
| :-------- | :----- | :--- | :------------------ | :--------------------------------------- |
| **NOP**   | `0000` | R    | -                   | No Operation                             |
| **ADD**   | `0001` | R    | `Rt = Rt + Rs`      | Soma acumulada                           |
| **SUB**   | `0010` | R    | `Rt = Rt - Rs`      | Subtração acumulada                      |
| **CMPR**  | `0011` | R    | `Flags = Rt - Rs`   | Comparação (atualiza flags)              |
| **OR**    | `0100` | R    | `Rt = Rt OR Rs`     | Ou lógico acumulado                      |
| **LW**    | `0111` | I    | `Rt = RAM[Rs]`      | Leitura da memória (Load Word)           |
| **ADDI**  | `1000` | I    | `Rt = Rs + Imm`     | Soma com imediato                        |
| **LD**    | `1000` | I    | `Rt = Imm`          | Carga de constante (Pseudo: CLR + ADDI)  |
| **SW**    | `1011` | I    | `RAM[Rs] = Rt`      | Escrita na memória (Store Word)          |
| **MOV**   | `1110` | I    | `Rt = Rs`           | Cópia de registrador                     |
| **BNE**   | `1100` | J    | `if Z=0, PC += Off` | Desvio se diferente (Branch Not Equal)   |
| **BLO**   | `1101` | J    | `if C=1, PC += Off` | Desvio se menor (Branch Lower/Carry Set) |
| **JMP**   | `1111` | J    | `PC = Endereço`     | Salto incondicional                      |

---
